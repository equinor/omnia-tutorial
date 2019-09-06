# EDC 2019 - Omnia Workshoop
# https://docs.microsoft.com/en-us/azure/sql-database/sql-database-single-database-get-started?tabs=azure-powershell

# Set variable for your shortname
# $shortname = <shortname>
$shortname = Read-Host -Prompt "Input your shortname"
$shortname = $shortname.ToLower()


# Set variables for your server and database
# Subscription = Omnia Application Workspace - Sandbox
$subscriptionId = "160c90f1-6bbe-4276-91f3-f732cc0a45db"
$resourceGroupName = "edc2019_$shortname"
$location = "northeurope"
$adminLogin = "azureuser"
$password = ConvertTo-SecureString "EDC2019!(New-Guid).Guid" -AsPlainText -Force
$serverName = "edc2019sql-$shortname"
$databaseName = "edc2019db"
$firewallRuleNameEDC2019 = "edc2019-fw"
$firewallRuleNameAllAzure = "edc2019-allazure"
$server = $null
$database = $null
$serverFirewallRuleEDC2019 = $null
$serverFirewallRuleAllAzure = $null

# The ip address range that you want to allow to access your server 
# (leaving at 0.0.0.0 will prevent outside-of-azure connections to your DB)
# $startIP = "0.0.0.0"
# $endIP = "0.0.0.0"

# Find breakout IP address
$whatsMyIP = (Invoke-WebRequest -uri https://ipinfo.io/ip).Content.Trim()
$startIP = $whatsMyIP
$endIP = $whatsMyIP

# Connect to Azure
# Connect-AzAccount

# Get user object
$account = Get-AzADUser -UserPrincipalName "$shortname@equinor.com"

# Set subscription ID
Set-AzContext -SubscriptionId $subscriptionId
$subscription = Get-AzSubscription -SubscriptionId $subscriptionId
$subscriptionName = $subscription.Name

# Show randomized variables
Write-Host "Subscription name: $subscriptionName"
Write-Host "Resource group name: $resourceGroupName"
Write-Host "Location: $location"
Write-Host "Server name: $serverName"
Write-Host "Server admin: $adminLogin"
Write-Host "Password: $password"
Write-Host "Database name: $databaseName"
Write-Host "Firewallrule EDDC2019: $firewallRuleNameEDC2019"
Write-Host "Start IP: $startIP"
Write-Host "End IP: $endIP"

$server = Get-AzSqlServer -ResourceGroupName $resourceGroupName -ServerName $serverName -ErrorAction SilentlyContinue

if (!$server)
{
    # Create a server with a system wide unique server name
    Write-Host "Creating database server..."
    $server = New-AzSqlServer -ResourceGroupName $resourceGroupName `
    -ServerName $serverName `
    -Location $location `
    -SqlAdministratorCredentials $(New-Object -TypeName System.Management.Automation.PSCredential `
    -ArgumentList $adminLogin, $password)
}

Write-Host "Azure SQL server properties:"
$server

$serverFirewallRuleEDC2019 = Get-AzSqlServerFirewallRule -ResourceGroupName $resourceGroupName -ServerName $serverName -FirewallRuleName $firewallRuleNameEDC2019 -ErrorAction SilentlyContinue

if (!$serverFirewallRuleEDC2019)
{
    # Create a server firewall rule that allows access from the specified IP range
    Write-Host "Creating firewallrule for $serverName"
    $serverFirewallRuleEDC2019 = New-AzSqlServerFirewallRule -ResourceGroupName $resourceGroupName `
    -ServerName $serverName `
    -FirewallRuleName $firewallRuleNameEDC2019 -StartIpAddress $startIP -EndIpAddress $endIP
}

Write-Host "Azure SQL server firewallrule:"
$serverFirewallRuleEDC2019

$serverFirewallRuleAllAzure = Get-AzSqlServerFirewallRule -ResourceGroupName $resourceGroupName -ServerName $serverName -FirewallRuleName $firewallRuleNameAllAzure -ErrorAction SilentlyContinue

if (!$serverFirewallRuleAllAzure)
{
    # Create a server firewall rule that allows access from the specified IP range
    Write-Host "Creating firewallrule for $serverName"
    $serverFirewallRuleAllAzure = New-AzSqlServerFirewallRule -ResourceGroupName $resourceGroupName `
    -ServerName $serverName `
    -FirewallRuleName $firewallRuleNameAllAzure -StartIpAddress "0.0.0.0" -EndIpAddress "0.0.0.0"
}

Write-Host "Azure SQL server firewallrule:"
$serverFirewallRuleAllAzure

$database = Get-AzSqlDatabase -ResourceGroupName $resourceGroupName -ServerName $serverName -DatabaseName $databaseName -ErrorAction SilentlyContinue

if (!$database)
{
    # Create General Purpose Gen4 database with 1 vCore
    Write-Host "Creating database $databaseName on Azure SQL server $serverName"
    $database = New-AzSqlDatabase  -ResourceGroupName $resourceGroupName `
    -ServerName $serverName `
    -DatabaseName $databaseName `
    -Edition GeneralPurpose `
    -VCore 2 `
    -ComputeGeneration Gen5 `
    -MinimumCapacity 2 `
    -SampleName "AdventureWorksLT"
}

Write-Host "Azure SQL database properties:"
$database

Write-Host "Azure SQL server Active Directory Admin"
$serverAADAdmin = Get-AzSqlServerActiveDirectoryAdministrator -ResourceGroupName $resourceGroupName -ServerName $serverName

if (!$serverAADAdmin)
{
    # Set a server Active Directory Admin
    Write-Host "Setting Active Directory Admin for $serverName"
    $serverAADAdmin = Set-AzSqlServerActiveDirectoryAdministrator -ResourceGroupName $resourceGroupName `
    -ServerName $serverName `
    -DisplayName $account.DisplayName `
    -ObjectId $account.Id
}

Write-Host "Azure SQL server Active Directory Admin:"
$serverAADAdmin