$context = Get-AzContext
if ($null -eq $context )
{
    $context = Connect-AzAccount
}

$commonSubscriptionId = "160c90f1-6bbe-4276-91f3-f732cc0a45db"
$commonSubscriptionName = "Omnia Application Workspace - Sandbox"

Write-Host "Setting Subscription to $commonSubscriptionName ... " -NoNewline
Set-AzContext -SubscriptionName $commonSubscriptionId | Out-Null
Write-Host "Done" -ForegroundColor Green

#Common Variables
$edcAADGroup = "c5f931df-8725-4611-9594-378ec0a82c13"

$groupMembers = Get-AzADGroupMember -GroupObjectId $edcAADGroup

foreach ($member in $groupMembers)
{
    if ($member.Type -eq "User")
    {
        $shortName = $member.UserPrincipalName.Split("@")[0].ToLower()
        $resourceGroupName = "edc2019_$shortName"
        Remove-AzResourceGroup -Name $resourceGroupName -WhatIf
    }

    Remove-AzADGroupMember -MemberObjectId $($member.Id) -GroupObjectId $edcAADGroup -WhatIf
}

Write-Host "Offboarding complete. Run the script to delete the shared runtime environment if desired." -ForegroundColor Green
