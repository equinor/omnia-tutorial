$AADGroup = "0bf1cd33-f89c-4de2-851a-ff7bcd6ba1a9"

$commonSubscriptionId = "160c90f1-6bbe-4276-91f3-f732cc0a45db"
$commonSubscriptionName = "Omnia Application Workspace - Sandbox"

Write-Host "Setting Subscription to $commonSubscriptionName ... " -NoNewline
Set-AzContext -SubscriptionName $commonSubscriptionId | Out-Null
Write-Host "Done" -ForegroundColor Green

$adGroup = Get-AzADGroup -ObjectId $AADGroup
$groupMembers = Get-AzADGroupMember -GroupObjectId $AADGroup


foreach ($user in $groupMembers | Where-Object {$_.Type -eq "User"})
{
    Write-Host "Checking $($user.UserPrincipalName) ... "  -NoNewline
    $shortName = $user.UserPrincipalName.Split("@")[0].ToLower()

    $resourceGroupName = "omnia-tutorial-$shortName"
    $dfName = "omnia-tutorial-" + $shortName + "-df"
    $appServiceName = "omnia-tutorial-" + $shortName + "-app" 

    $dfPrincipal = $null
    $dfPrincipal = $groupMembers | Where-Object {$_.Type -eq "ServicePrincipal" -and $_.DisplayName -eq $dfName}

    if ($null -eq $dfPrincipal)
    {
        Write-Host " fixing df id ... " -ForegroundColor Yellow -NoNewline
        $df = Get-AzDataFactoryV2 -Name $dfName -ResourceGroupName $resourceGroupName
        Add-AzADGroupMember -TargetGroupObjectId $adGroup.Id -MemberObjectId $df.Identity.PrincipalId
    }

    $appPrincipal = $null
    $appPrincipal = $groupMembers | Where-Object {$_.Type -eq "ServicePrincipal" -and $_.DisplayName -eq $appServiceName}
    if ($null -eq $appPrincipal)
    {
        Write-Host " fixing app id ... " -ForegroundColor Yellow -NoNewline
        $appService = Get-AzWebApp -ResourceGroupName $resourceGroupName -Name $appServiceName
        Add-AzADGroupMember -TargetGroupObjectId $adGroup.Id -MemberObjectId $appService.Identity.PrincipalId
    }
    Write-Host "Done" -ForegroundColor Green


}