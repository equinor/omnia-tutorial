param([Parameter(Mandatory=$true)] [string]$shortName)

# Handle Login to Azure

$context = Get-AzContext
if ($null -eq $context )
{
    $context = Connect-AzAccount
}

$shortName = $shortName.ToLower()

#Common Variables

# Group used for giving access (OMNIA - Tutorial participants) - participants should be added here
$AADGroup = "0bf1cd33-f89c-4de2-851a-ff7bcd6ba1a9"

$commonRg = "omnia-tutorial-common"
$commonDls = "omniatutorialdls"

$commonSubscriptionId = "160c90f1-6bbe-4276-91f3-f732cc0a45db"
$commonSubscriptionName = "Omnia Application Workspace - Sandbox"

$logFile = "onboardErrors.ps1" 

$commonKvName = "omnia-tutorial-common-kv"

$location = "northeurope"

$principalName = "$shortName" + "@equinor.com"
$resourceGroupName = "omnia-tutorial-$shortName"
$dfName = "omnia-tutorial-" + $shortName + "-df"

$appServicePlanName = "omnia-tutorial-" + $shortName + "-asp"
$appServiceName = "omnia-tutorial-" + $shortName + "-app" 


$adGroup = Get-AzADGroup -ObjectId $AADGroup


# Adding the current user to the shared Databricks-instance

$secretName = "DatabricksToken"
Write-Host "Getting Databricks access-token from $commonKvName ... " -NoNewline
$tokenValue = (Get-AzKeyVaultSecret -VaultName $commonKvName -Name $secretName -ErrorAction Stop).SecretValueText
if ($null -eq $tokenValue)
{
     Write-Error "DataBricks Access Token is Null or Empty. Aborting..."
     return;
}
Write-Host "Done" -ForegroundColor Green

$databricksApiUri = "https://northeurope.azuredatabricks.net/api/"
$endPoint = "2.0/preview/scim/v2/Users"
$bearerToken = "Bearer " + $tokenValue
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", $bearerToken)
$groups = @()
$entitlements = @()

$body = @{
    "schemas" = @("urn:ietf:params:scim:schemas:core:2.0:User")
    "groups" = $groups
    "entitlements" = $entitlements
    "userName" = "$shortName@equinor.com"
} | ConvertTo-Json



Write-Host "Setting Subscription to $commonSubscriptionName ... " -NoNewline
Set-AzContext -SubscriptionName $commonSubscriptionId | Out-Null
Write-Host "Done" -ForegroundColor Green

Write-Host "Resolving $principalName => " -NoNewline
$user = Get-AzAdUser -UserPrincipalName $principalName

if ($null -eq $user)
{
    Write-Host Failed -ForegroundColor Red
    return;
}
else {
    Write-Host $user.DisplayName -ForegroundColor Green    
}


$rg = Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue 
$rgCreated = $false
if ($null -eq $rg)
{
    Write-Host "Creating ResourceGroup $resourceGroupName ... " -NoNewline
    New-AzResourceGroup -Name $resourceGroupName -Location $location -ErrorAction Stop | Out-Null
    Write-Host "Done" -ForegroundColor Green

    Write-Host "Granting Permission to $principalName ... " -NoNewline
    New-AzRoleAssignment -ObjectId $user.Id -RoleDefinitionName "Owner" -ResourceGroupName $resourceGroupName | Out-Null
    Write-Host "Done" -ForegroundColor Green
    $rgCreated = $true

}
else {
    $rgCreated = $false
    Write-Host "Already exists..." -ForegroundColor "Red"
    return;
}

Write-Host "Creating Data Factory ... " -NoNewline
$df = New-AzDataFactoryV2 -Name $dfName -ResourceGroupName $resourceGroupName -Location $location
Write-Host "Done" -ForegroundColor Green

Write-Host "Creating web app and app service plan ... " -NoNewline
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile "webapp-arm-template.json" -shortName $shortName | Out-Null
Write-Host "Done" -ForegroundColor Green



Write-Host "Setting up DataBricks ... " -NoNewline


try {
    #Write-Host "Add user to EDC2019SharedDatabricks"
    $createUserResponse = Invoke-WebRequest -Method Post -Uri ($databricksApiUri + $endPoint) -Headers $headers -Body $body -ContentType 'application/json'
    if ($createUserResponse.StatusCode -eq "Created")
    {
        Write-Host "Done" -ForegroundColor Green
    }       
    } 
    catch {
    $myError = $_.ErrorDetails.Message
    if ($myError.Contains('"status":"409"')){
        Write-Warning "User already exist"
        }
    else{
        Write-Error "Error: " $myError
    }
}



Write-Host "Waiting 5 seconds for AD to propagate ... " -NoNewline
Start-Sleep -Seconds 5
Write-Host "Done" -ForegroundColor Green


Write-Host "Adding User to AD Group ..." -NoNewline
Add-AzADGroupMember -TargetGroupObjectId $adGroup.Id -MemberObjectId $user.Id 
Write-Host "Done" -ForegroundColor Green

try {
    Write-Host "Adding DF MSI to AD Group ..." -NoNewline
    $df = Get-AzDataFactoryV2 -Name $dfName -ResourceGroupName $resourceGroupName
    Add-AzADGroupMember -TargetGroupObjectId $adGroup.Id -MemberObjectId $df.Identity.PrincipalId
    Write-Host "Done" -ForegroundColor Green
}
catch {
    Start-Sleep -Seconds 5
    $df = Get-AzDataFactoryV2 -Name $dfName -ResourceGroupName $resourceGroupName
    try {
        Add-AzADGroupMember -TargetGroupObjectId $adGroup.Id -MemberObjectId $df.Identity.PrincipalId    
    }
    catch {
        Add-Content -Path $logFile  -Value "Add-AzADGroupMember -TargetGroupObjectId $($adGroup.Id) -MemberObjectId $($df.Identity.PrincipalId)"    
    }
    
    
}

try {
    Write-Host "Adding WebApp MSI to AD Group ..." -NoNewline
    $appService = Get-AzWebApp -ResourceGroupName $resourceGroupName -Name $appServiceName
    Add-AzADGroupMember -TargetGroupObjectId $adGroup.Id -MemberObjectId $appService.Identity.PrincipalId
    Write-Host "Done" -ForegroundColor Green
        
}
catch {
    Add-Content -Path $logFile -Value "Add-AzADGroupMember -TargetGroupObjectId $($adGroup.Id) -MemberObjectId $($appService.Identity.PrincipalId)"
}

# create user folder in datalake 

$storageAccount = "omniatutorialdls"
$fileSystem = "dls"
$tenantId = "3aa4a235-b6e2-48d5-9195-7fcf05b459b0"
$clientId = "df14e561-cf9a-45f9-bc21-b0f38f2b2c27"

try{
    Write-Host "Creating user folder in datalake ..."
    $clientSecret = (Get-AzKeyVaultSecret -VaultName $commonKvName -Name 'DlsOnboarding' -ErrorAction Stop ).SecretValueText 

    # Acquire OAuth token
    $body = @{ 
    client_id = $clientId
    client_secret = $clientSecret
    scope = "https://storage.azure.com/.default"
    grant_type = "client_credentials" 
    }
    $token = Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token" -Body $body
        
    # Required headers
    
    $headers = @{
            "x-ms-version" = "2018-11-09"
            Authorization = "Bearer " + $token.access_token
    }
     
    $path = "user/$shortName"
    Invoke-WebRequest -Method "Put" -Headers $headers -Uri "https://$storageAccount.dfs.core.windows.net/$fileSystem/$path`?resource=directory"

}
catch{
    Write-Host "Creating user folder in datalake failed" -ForegroundColor Red

}
try{
    Write-Host "Set permission on user folder ..."
    $path = [System.Web.HttpUtility]::UrlEncode($path)
    
    $ownerId = $user.Id
    $groupId = $user.Id
    
    
    $aclFolder = "user::rwx,default:user::rwx,group::rwx,default:group::rwx";
    
    $aclHeaders = @{
            "x-ms-version" = "2018-11-09"
            "x-ms-owner" = $ownerId
            "x-ms-group" = $groupId
            "x-ms-acl" = $aclFolder
            Authorization = "Bearer " + $token.access_token
           
    }

    $uri = "https://$storageAccount.dfs.core.windows.net/$fileSystem"
    Invoke-WebRequest -Headers $aclHeaders -Method "PATCH" -Uri "$uri/$path`?action=setAccessControl"  
}
catch{
    Write-Host "Setting permission on user folder in datalake failed" -ForegroundColor Red

}

# send notification email to user
function EmailNotification{
    param([string]$recipient)
    # get smtp properties from key vault
    $secretInfo = Get-AzKeyVaultSecret -VaultName $commonKvName -Name SmtpConnectionDetails -ErrorAction Stop
    $secpasswd = $secretInfo.SecretValue
    $username = $secretInfo.Tags.User
    $port = $secretInfo.Tags.Port
    $smtpServer = $secretInfo.Tags.Server
    $sslStatus = $secretInfo.Tags.EnableSsl

    # Set e-mail properties
    $content = New-Object System.Net.Mail.MailMessage
    $content.From = $username
    $content.To.Add($recipient)
    $content.Subject = ("Hands On With Omnia Workshop Onboarded")
    $content.IsBodyHtml = $true

    $content.Body = "<html><head><style type='text/css'>table{ font-size:11pt;font-family:Calibri;border:solid 1px #cccccc;vertical-align:top;padding:0px 0px;border-spacing:0px 0px;}img.middle{vertical-align:middle;}</style></head><body><div style='font-size:11pt;font-family:Calibri'>Hi,<p>"
    $content.Body += ("You have been successfully onboarded to EDC workshop: <b>Hands on with Omnia</b>.<p>")
    $content.Body += ("In the link below you can find the resource group created for you:<p>")
    $content.Body += ("https://portal.azure.com/#@statoilsrm.onmicrosoft.com/resource/subscriptions/160c90f1-6bbe-4276-91f3-f732cc0a45db/resourceGroups/edc2019_" + $shortName + "/overview <p>")
    $content.Body += ("You can find the shared common resources for this workshop in the resource group <b>EDC2019Common</b>:<p>")
    $content.Body += ("https://portal.azure.com/#@statoilsrm.onmicrosoft.com/resource/subscriptions/160c90f1-6bbe-4276-91f3-f732cc0a45db/resourceGroups/EDC2019Common/overview<p>")
    $content.Body += ("The workshop Github repository is available here:<p>")
    $content.Body += ("https://github.com/equinor/omnia-tutorial<p>")
    $content.Body += ("We have a Slack channel <b>#edc2019-omnia</b> for information, discussion and questions. Feel free to join the channel here:<p>")
    $content.Body += ("https://app.slack.com/client/T02JL00JU/CMPSS6U3F<p>")
    $content.Body += ("<b>If you are redirected to home page by clicking the links above, try paste and go to the links in browser.</b><p>")
    $content.Body += ("Thank you for attending our workshop. Wish you good luck!<p>")
    $content.Body += ("Best regards!<p>")
    $content.Body += ("OMNIA Family<p>")
    $content.Body += "</div></body></html>"
    
    # set SMTP server
    $smtpClient = New-Object System.Net.Mail.SmtpClient($smtpServer, $port)
    $smtpClient.EnableSsl = $sslStatus
    $smtpClient.Credentials = New-Object System.Net.NetworkCredential($username, $secpasswd)
    
    # Send e-mail 
    $smtpClient.Send($content)

}

try {
    if($rgCreated){
        $recipient = $shortName + '@equinor.com'
        EmailNotification $recipient
        Write-Host "User $shortname onboarded successfully with email sent." -ForegroundColor Green
    }
    else{
        Write-Host "Email was not sent." -ForegroundColor Red
    }
}
catch { 
    $exceptionDetails = $_.Exception | format-list -force | Out-String
    $lineNo = $_.InvocationInfo.ScriptLineNumber
    $exceptionDetails = "$exceptionDetails, Line number: $lineNo"
    Write-Error $exceptionDetails
    throw
}
