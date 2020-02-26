# if 12 users attending workshop
$vmnum = (1..12)

# set context
$subscriptionId = "9bc2f845-5f0d-450d-bf32-82d81d9e8445"  # Digital Academy Training
$resourceGroupName = "jmorStudentRG"

$context = Get-AzContext
if ($null -eq $context )
{
    $context = Connect-AzAccount
}
Set-AzContext -SubscriptionName $subscriptionId

# deploy one storage account for diagnostics
$storageAccountName = "omniatutorialdiag"


New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile "blob-arm-template.json" -TemplateParameterFile "blob-template-parameter.json" -storageAccountName $storageAccountName

$storageAccountId = (Get-AzResource -Name $storageAccountName -ResourceGroupName $resourceGroupName).ResourceId

# deploy vms
foreach ($num in $vmnum) {
    
    $networkInterfaceName = "omniatutorial" + $num + "ni"
    $virtualMachineName = "omniatutorial" + $num
    $adminPassword = "Omniatutorial" + $num
    $adminPassword = ConvertTo-SecureString $adminPassword -AsPlainText -Force

    New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile "vm-arm-template.json" -TemplateParameterFile "vm-template-parameter.json" -networkInterfaceName $networkInterfaceName -virtualMachineName $virtualMachineName -virtualMachineRG $resourceGroupName -adminPassword $adminPassword -diagnosticsStorageAccountName $storageAccountName -diagnosticsStorageAccountId $storageAccountId

}





