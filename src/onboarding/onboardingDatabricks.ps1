param([string]$shortName, [string]$tokenValue)


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