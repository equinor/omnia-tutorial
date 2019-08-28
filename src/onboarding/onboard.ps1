param([string]$shortName)

#Common Variables
$edcAADGroup = "c5f931df-8725-4611-9594-378ec0a82c13"

$commonRg = "EDC2019Common"
$commonDls = "edc2019dls"
$commonSubscriptionId = "160c90f1-6bbe-4276-91f3-f732cc0a45db"
$commonSubscriptionName = "Omnia Application Workspace - Sandbox"
$commonDlsDataReaderRole = "Storage Blob Data Reader"
$commonDlsResourceType = "Microsoft.Storage/storageAccounts"
$commonDlsReaderRole = "Reader"
$commonKvName = "EDC2019KV"

$location = "northeurope"

$principalName = "$shortName" + "@equinor.com"
$resourceGroupName = "edc2019_$shortName"
$dfName = "edc2019-" + $shortName + "-df"

$adGroup = Get-AzADGroup -ObjectId $edcAADGroup

Write-Host "Setting Subscription to $commonSubscriptionName"
Set-AzContext -SubscriptionName $commonSubscriptionId | Out-Null

Write-Host "Resolving $principalName => " -NoNewline
$user = Get-AzAdUser -UserPrincipalName $principalName

if ($null -eq $user)
{
    Write-Host Failed -ForegroundColor Red
    return
}
else {
    Write-Host $user.DisplayName -ForegroundColor Green    
}


$rg = Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue 

if ($null -eq $rg)
{
    Write-Host "Creating ResourceGroup $resourceGroupName ... " -NoNewline
    New-AzResourceGroup -Name $resourceGroupName -Location $location -ErrorAction Stop | Out-Null
    Write-Host "Done" -ForegroundColor Green

    Write-Host "Granting Permission to $principalName ... " -NoNewline
    New-AzRoleAssignment -ObjectId $user.Id -RoleDefinitionName "Owner" -ResourceGroupName $resourceGroupName | Out-Null
    Write-Host "Done" -ForegroundColor Green

}
else {
    Write-Host "Already exists..." -ForegroundColor "Red"
    return;
}

Write-Host "Creating Data Factory ... " -NoNewline
$df = New-AzDataFactoryV2 -Name $dfName -ResourceGroupName $resourceGroupName -Location $location
Write-Host "Done" -ForegroundColor Green

Write-Host "Waiting 5 seconds for AD to propagate ... " -NoNewline
Start-Sleep -Seconds 5
Write-Host "Done" -ForegroundColor Green

Write-Host "Adding User to OMNIA - EDC2019 ..." -NoNewline
Add-AzADGroupMember -TargetGroupObjectId $adGroup.Id -MemberObjectId $user.Id 
Write-Host "Done" -ForegroundColor Green

Write-Host "Adding DF MSI to OMNIA - EDC2019 ..." -NoNewline
Add-AzADGroupMember -TargetGroupObjectId $adGroup.Id -MemberObjectId $df.Identity.PrincipalId
Write-Host "Done" -ForegroundColor Green

# Adding the current user to the shared Databricks-instance
Write-Host "Getting Databricks access-token from $commonKvName"
$tokenValue = (Get-AzKeyVaultSecret -VaultName $kvName -Name $secretName -ErrorAction Stop).SecretValueText

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

# create user
try {
    Write-Host "Add user to EDC2019SharedDatabricks"
    $createUserResponse = Invoke-WebRequest -Method Post -Uri ($databricksApiUri + $endPoint) -Headers $headers -Body $body -ContentType 'application/json'
    Write-Host $createUserResponse.StatusCode " " $createUserResponse.StatusDescription
    } 
    catch {
    $myError = $_.ErrorDetails.Message
    if ($myError.Contains('"status":"409"')){
        Write-Host "User already exist"
        }
    else{
        Write-Host "Some other problem: " $myError
    }
}