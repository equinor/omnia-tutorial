param([string]$shortName)

$commonSubscriptionId = "160c90f1-6bbe-4276-91f3-f732cc0a45db"
$commonSubscriptionName = "Omnia Application Workspace - Sandbox"
$resourceGroupName = "edc2019_$shortName"


Write-Host "Setting Subscription to $commonSubscriptionName"
Set-AzContext -SubscriptionName $commonSubscriptionId | Out-Null

Write-Host "Creating web app and app service plan"
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile "webapp-arm-template.json" -shortName $shortName > $null

Write-Host "Deployment complete"