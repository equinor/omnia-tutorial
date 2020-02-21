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
$participantsAADGroup = "0bf1cd33-f89c-4de2-851a-ff7bcd6ba1a9"

$groupMembers = Get-AzADGroupMember -GroupObjectId $participantsAADGroup

foreach ($member in $groupMembers)
{
    if ($member.Type -eq "User")
    {
        $shortName = $member.UserPrincipalName.Split("@")[0].ToLower()
        $resourceGroupName = "omnia-tutorial-$shortName"
        Write-Host "Removing $resourceGroupName"
        Remove-AzResourceGroup -Name $resourceGroupName -Force
    }

    Remove-AzADGroupMember -MemberObjectId $($member.Id) -GroupObjectId $participantsAADGroup
}

Write-Host "Offboarding complete. Run the script to delete the shared runtime environment if desired." -ForegroundColor Green
