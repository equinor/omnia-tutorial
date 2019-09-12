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
# Setting paths and variables
Push-Location;
$dfname = "ODET2DFDev";
$rgname = "odet2rgdev";
function Select-WorkDir() {
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null;
    $folderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog;
    $folderBrowserDialog.Description = "Please select folder containing the JSON definition files.";
    $folderBrowserDialog.RootFolder = "MyComputer";
    if ($folderBrowserDialog.ShowDialog() -eq "OK") {
        $folderPath = $null;
        $folderPath = $folderBrowserDialog.SelectedPath;
    }
    return $folderPath;
}
$workDir = $null;
try {
    $workDir = (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent -ErrorAction SilentlyContinue);
}
catch {
    if ([string]::IsNullOrEmpty($workDir)) {
        Write-Output "Work directory path was not found. Prompting user.";
        $workDir = Select-WorkDir;
    }
}
Set-Location $workDir;

# Deployment

#Linked services (if they do not exist):
if ((Get-AzureRmDataFactoryV2LinkedService -ResourceGroupName $rgname -DataFactoryName $dfname | Where-Object {$_.Name -eq 'kv_edc2019'}).Count -eq 0){
    Set-AzureRmDataFactoryV2LinkedService -ResourceGroupName $rgname -DataFactoryName $dfname -Name "kv_edc2019" -DefinitionFile "$workDir\LinkedServices\kv_edc2019.json" -Verbose -ErrorAction Stop;
}
if ((Get-AzureRmDataFactoryV2LinkedService -ResourceGroupName $rgname -DataFactoryName $dfname | Where-Object {$_.Name -eq 'fa_factpages'}).Count -eq 0){
    Set-AzureRmDataFactoryV2LinkedService -ResourceGroupName $rgname -DataFactoryName $dfname -Name "fa_factpages" -DefinitionFile "$workDir\LinkedServices\fa_factpages.json" -Verbose -ErrorAction Stop;
}
if ((Get-AzureRmDataFactoryV2LinkedService -ResourceGroupName $rgname -DataFactoryName $dfname | Where-Object {$_.Name -eq 'EDC2019CommonBL'}).Count -eq 0){
    Set-AzureRmDataFactoryV2LinkedService -ResourceGroupName $rgname -DataFactoryName $dfname -Name "EDC2019CommonBL" -DefinitionFile "$workDir\LinkedServices\EDC2019CommonBL.json" -Verbose -ErrorAction Stop;
}
if ((Get-AzureRmDataFactoryV2LinkedService -ResourceGroupName $rgname -DataFactoryName $dfname | Where-Object {$_.Name -eq 'EDC2019CommonSQL'}).Count -eq 0){
    Set-AzureRmDataFactoryV2LinkedService -ResourceGroupName $rgname -DataFactoryName $dfname -Name "EDC2019CommonSQL" -DefinitionFile "$workDir\LinkedServices\EDC2019CommonSQL.json" -Verbose -ErrorAction Stop;
}

#Datasets
Set-AzureRmDataFactoryV2Dataset -ResourceGroupName $rgname -DataFactoryName $dfname -Name Wellbore_BL_JSON -DefinitionFile ".\Datasets\Wellbore_BL_JSON.json" -Verbose -ErrorAction Stop;
Set-AzureRmDataFactoryV2Dataset -ResourceGroupName $rgname -DataFactoryName $dfname -Name Wellbore_SQL -DefinitionFile ".\Datasets\Wellbore_SQL.json" -Verbose -ErrorAction Stop;

#Pipelines
Set-AzureRmDataFactoryV2Pipeline -ResourceGroupName $rgname -DataFactoryName $dfname -Name EDC2019_Ingest_API -DefinitionFile ".\Pipelines\EDC2019_Ingest_API.json" -Verbose -ErrorAction Stop;

# Go back to previous location
Pop-Location;