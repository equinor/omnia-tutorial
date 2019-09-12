# Authentication
Clear-Host;
$subscriptionId = "4bb8df6f-e5b7-45f8-8db6-22ec061d6938";
if ([string]::IsNullOrEmpty((Get-AzureRmContext).Account)) {
    $connectResult = (Connect-AzureRmAccount -ErrorAction Stop);
    Write-Output "`n$($connectResult.Context.Account.Id) connected to tenant $($connectResult.Context.Tenant), subscription $($connectResult.Context.Subscription).";
} else {
    $context = (Get-AzureRmContext -ErrorAction Stop);
    Write-Output "`n$($context.Account.Id) connected to tenant $($context.Tenant), subscription $($context.Subscription).";
}
$contextResult = Set-AzureRMContext -SubscriptionId $subscriptionId;
Write-Output "Subscription set to $($contextResult.Subscription.Name) ($($contextResult.Subscription.Id)).";

# Paths and variables
$dfname = "ODET2DFDev";
$rgname = "odet2rgdev";


#Pipelines
Remove-AzureRmDataFactoryV2Pipeline -ResourceGroupName $rgname -DataFactoryName $dfname -Name "EDC2019_Ingest_API" -Verbose -Force -ErrorAction Stop;

#Datasets
Remove-AzureRmDataFactoryV2Dataset -ResourceGroupName $rgname -DataFactoryName $dfname -Name "Wellbore_BL_JSON" -Verbose -Force -ErrorAction Stop;
Remove-AzureRmDataFactoryV2Dataset -ResourceGroupName $rgname -DataFactoryName $dfname -Name "Wellbore_SQL" -Verbose -Force -ErrorAction Stop;

#Linked Services
try{Remove-AzureRmDataFactoryV2LinkedService -ResourceGroupName $rgname -DataFactoryName $dfname -Name "EDC2019CommonBL" -Verbose -Force -ErrorAction Stop;}
    catch{Write-Warning "Unable to remove EDC2019CommonBL. Most likely it is in use by other pipeline(s)";}
try{Remove-AzureRmDataFactoryV2LinkedService -ResourceGroupName $rgname -DataFactoryName $dfname -Name "EDC2019CommonSQL" -Verbose -Force -ErrorAction Stop;}
    catch{Write-Warning "Unable to remove EDC2019CommonSQL. Most likely it is in use by other pipeline(s)";}
try{Remove-AzureRmDataFactoryV2LinkedService -ResourceGroupName $rgname -DataFactoryName $dfname -Name "fa_factpages" -Verbose -Force -ErrorAction Stop;}
    catch{Write-Warning "Unable to remove fa_factpages. Most likely it is in use by other pipeline(s)";}
try{Remove-AzureRmDataFactoryV2LinkedService -ResourceGroupName $rgname -DataFactoryName $dfname -Name "kv_edc2019" -Verbose -Force -ErrorAction Stop;}
    catch{Write-Warning "Unable to remove kv_edc2019. Most likely it is in use by other pipeline(s)";}  

Write-Output "Done."