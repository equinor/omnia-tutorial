<#
 .SYNOPSIS
    Setup shared resources for the Omnia tutorial

 .DESCRIPTION
    Setup shared resources for the Omnia tutorial using ARM templates and otherwise.

 .EXAMPLE
    ./create-environment.ps1 -subscription "Azure Subscription" -resourceGroupName myresourcegroup -resourceGroupLocation centralus

 .PARAMETER Subscription
    The subscription name or id where the template will be deployed.

 .PARAMETER ResourceGroupName
    The resource group where the template will be deployed. Can be the name of an existing or a new resource group.

 .PARAMETER ResourceGroupLocation
    Optional, a resource group location. If specified, will try to create a new resource group in this location. If not specified, assumes resource group is existing.

 .PARAMETER TemplateFilePath
    Optional, path to the template file. Defaults to template.json.

 .PARAMETER ParametersFilePath
    Optional, path to the parameters file. Defaults to parameters.json. If file is not found, will prompt for parameter values based on template.
#>

param(
 [string]
 $ScenarioName = "omnia-tutorial",

 [string]
 $Subscription = "Omnia Application Workspace - Sandbox",

 [string]
 $ResourceGroupName = "omnia-tutorial-common",

 [string]
 $ResourceGroupLocation = "northeurope"
)

$AzModuleVersion = "2.0.0"

$DLSTemplateFilePath = "templates/dls/template.json"
$DLSParametersFilePath = "templates/dls/parameters.json"
$DFTemplateFilePath = "templates/data-factory-pipelines/template.json"
$DFParametersFilePath = "templates/data-factory-pipelines/parameters.json"
$SQLTemplateFilePath = "templates/sql/template.json"
$SQLParametersFilePath = "templates/sql/parameters.json"
$DataBricksTemplateFilePath = "templates/databricks/template.json"
$DataBricksParametersFilePath = "templates/databricks/parameters.json"
$WebAppTemplateFilePath = "templates/webapp/template.json"
$WebAppParametersFilePath = "templates/webapp/parameters.json"

<#
.SYNOPSIS
    Registers RPs
#>
Function RegisterRP {
    Param(
        [string]$ResourceProviderNamespace
    )

    Write-Host "Registering resource provider '$ResourceProviderNamespace'";
    Register-AzResourceProvider -ProviderNamespace $ResourceProviderNamespace;
}

#******************************************************************************
# Script body
# Execution begins here
#******************************************************************************
$ErrorActionPreference = "Stop"

# Verify that the Az module is installed 
if (!(Get-InstalledModule -Name Az -MinimumVersion $AzModuleVersion -ErrorAction SilentlyContinue)) {
    Write-Host "This script requires to have Az Module version $AzModuleVersion installed..
It was not found, please install from: https://docs.microsoft.com/en-us/powershell/azure/install-az-ps"
    exit
} 

# Verify that the SqlServer module is installed
if (!(Get-InstalledModule -Name SqlServer -ErrorAction SilentlyContinue)) {
    Write-Host "This script requires to have SqlServer Module installed..
It was not found, please install from: https://docs.microsoft.com/en-gb/sql/powershell/download-sql-server-ps-module?view=sql-server-2017"
    exit
} 

# sign in
$context = Get-AzContext
if ($null -eq $context )
{
    Write-Host "Logging in...";
    $context = Connect-AzAccount
}

$account = Get-AzADUser -UserPrincipalName $context.Account.Id

# select subscription
Write-Host "Selecting subscription '$Subscription'";
Select-AzSubscription -Subscription $Subscription;

# Register RPs
$resourceProviders = @("microsoft.storage");
if($resourceProviders.length) {
    Write-Host "Registering resource providers"
    foreach($resourceProvider in $resourceProviders) {
        RegisterRP($resourceProvider);
    }
}

# Create or check for existing resource group
$resourceGroup = Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue
if(!$resourceGroup)
{
    if(!$ResourceGroupLocation) {
        Write-Host "Resource group '$ResourceGroupName' does not exist. To create a new resource group, please enter a location.";
        $resourceGroupLocation = Read-Host "ResourceGroupLocation";
    }
    Write-Host "Creating resource group '$ResourceGroupName' in location '$ResourceGroupLocation'";
    $resourceGroup = New-AzResourceGroup -Name $ResourceGroupName -Location $ResourceGroupLocation
}
else{
    Write-Host "Using existing resource group '$ResourceGroupName'";
}

# # Create the Data Lake Store
# Write-Host "Creating Data Lake Store ... " -NoNewline
# if(Test-Path $DLSParametersFilePath) {
#     # New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $DLSTemplateFilePath -TemplateParameterFile $DLSParametersFilePath;
# } else {
#     # New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $DLSTemplateFilePath;
# }
# Write-Host "Done" -ForegroundColor Green

# Create the Data Factory
$dfName = "$ScenarioName-common-df"
$df = Get-AzDataFactoryV2 -Name $dfName -ResourceGroupName $resourceGroupName -ErrorAction SilentlyContinue 
if ($null -eq $df)
{
    Write-Host "Creating Data Factory ... " -NoNewline
    $df = New-AzDataFactoryV2 -Name $dfName -ResourceGroupName $resourceGroupName -Location $resourceGroup.Location
    Write-Host "$df" -ForegroundColor Green
    Write-Host "Data Factory Created" -ForegroundColor Green
}
else {
    Write-Host "Data Factoryalready exists. Skipping creation!" -ForegroundColor "Yellow"
}


# Create the Key Vault
$keyVault = Get-AzKeyVault -VaultName "$ScenarioName-common-kv" -ResourceGroupName $resourceGroupName -ErrorAction SilentlyContinue 
if ($null -eq $keyVault)
{
    Write-Host "Creating Key Vault ... " -NoNewline
    $keyVault = New-AzKeyVault -Name "$ScenarioName-common-kv" -ResourceGroupName $resourceGroupName -Location "$ResourceGroupLocation"
    Write-Host "$keyVault" -ForegroundColor Green
    Write-Host "Key Vault Created" -ForegroundColor Green
}
else {
    Write-Host "Key Vault already exists. Skipping creation!" -ForegroundColor "Yellow"
}


# Create the SQL Database
$serverName = "$ScenarioName-common-sql"
$databaseName = "common"
$sqlDb = Get-AzSqlDatabase -ResourceGroupName $resourceGroupName -ServerName $serverName -DatabaseName $databaseName -ErrorAction SilentlyContinue 
if ($null -eq $sqlDb)
{
    Write-Host "Creating SQL Database '$serverName'... " -NoNewline
    $sql = New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $SQLTemplateFilePath -TemplateParameterFile $SQLParametersFilePath -scenarioName $ScenarioName;
    Write-Host "$sql SQL Database Created" -ForegroundColor Green
}
else {
    Write-Host "SQL Database already exists. Skipping creation!" -ForegroundColor "Yellow"
}

# SQL - Add Firewall rule 
$serverFirewallRuleClient = Get-AzSqlServerFirewallRule -ResourceGroupName $resourceGroupName -ServerName $serverName -FirewallRuleName "Client" -ErrorAction SilentlyContinue
if (!$serverFirewallRuleClient)
{
    # Create a server firewall rule that allows access from the specified IP range
    Write-Host "Creating firewallrule for $serverName"
    # Find breakout IP address
    $whatsMyIP = (Invoke-WebRequest -uri https://ipinfo.io/ip).Content.Trim()
    $startIP = $whatsMyIP
    $endIP = $whatsMyIP    
    Write-Host "Start IP: $startIP"
    Write-Host "End IP: $endIP"
    $serverFirewallRuleClient = New-AzSqlServerFirewallRule -ResourceGroupName $resourceGroupName `
    -ServerName $serverName `
    -FirewallRuleName "Client" -StartIpAddress $startIP -EndIpAddress $endIP
    Write-Host "Azure SQL server firewall rule:"
    $serverFirewallRuleClient
}

# SQL - Set a server Active Directory Admin
$serverAADAdmin = Get-AzSqlServerActiveDirectoryAdministrator -ResourceGroupName $resourceGroupName -ServerName $serverName
if (!$serverAADAdmin)
{
    Write-Host "Setting Active Directory Admin for $serverName"
    $serverAADAdmin = Set-AzSqlServerActiveDirectoryAdministrator -ResourceGroupName $resourceGroupName `
    -ServerName $serverName `
    -DisplayName $account.DisplayName `
    -ObjectId $account.Id
    Write-Host "Azure SQL server Active Directory Admin:"
    $serverAADAdmin
}

# Create table and view and populate
$connectionString = "Data Source=$serverName.database.windows.net;Authentication=Active Directory Integrated; Initial Catalog=$databaseName"
$sqlScriptFile = "resources\\setup_database.sql"
Invoke-Sqlcmd -ConnectionString $connectionString -InputFile $sqlScriptFile 
$sqlScriptFile = "resources\\populate_database.sql"
Invoke-Sqlcmd -ConnectionString $connectionString -InputFile $sqlScriptFile 

# Create Databricks
$dataBricks = Get-AzResource -ResourceGroupName $resourceGroupName -Name "$ScenarioName-common-databricks" -ErrorAction SilentlyContinue 
if ($null -eq $dataBricks)
{
    Write-Host "Creating Databricks ... " -NoNewline
    $dataBricks = New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $DataBricksTemplateFilePath -TemplateParameterFile $DataBricksParametersFilePath -scenarioName $ScenarioName;
    Write-Host "$dataBricks Databricks Created" -ForegroundColor Green
}
else {
    Write-Host "Databricks already exists. Skipping creation!" -ForegroundColor "Yellow"
}

# Create the App Service
$webApp = Get-AzWebApp -ResourceGroupName $resourceGroupName -Name "$ScenarioName-common" -ErrorAction SilentlyContinue 
if ($null -eq $webApp)
{
    Write-Host "Creating Web App ... " -NoNewline
    $webApp = New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $WebAppTemplateFilePath -TemplateParameterFile $WebAppParametersFilePath -scenarioName $ScenarioName;
    Write-Host "$webApp Created" -ForegroundColor Green
}
else {
    Write-Host "Web App already exists. Skipping creation!" -ForegroundColor "Yellow"
}