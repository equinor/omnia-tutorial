$context = Get-AzContext
if ($null -eq $context )
{
    $context = Connect-AzAccount
}

$commonSubscriptionId = "160c90f1-6bbe-4276-91f3-f732cc0a45db"
$commonSubscriptionName = "Omnia Application Workspace - Sandbox"

$commonRg = "EDC2019Common"

Write-Host "Setting Subscription to $commonSubscriptionName ... " -NoNewline
Set-AzContext -SubscriptionName $commonSubscriptionId | Out-Null
Write-Host "Done" -ForegroundColor Green


# Fix: We don't delete the resource group automatically as this is where the static website is hosted.
# Remove-AzResourceGroup -Name $commonRg -WhatIf

Write-Host "Currently you need to delete shared resources manually." -ForegroundColor Yellow
Write-Host "Note you probably want to keep the omniatutorialstaticweb resource as that is for the built web site" -ForegroundColor Yellow