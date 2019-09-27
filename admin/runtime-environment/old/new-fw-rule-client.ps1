# EDC 2019 - Omnia Workshoop
# https://docs.microsoft.com/en-us/azure/sql-database/sql-database-server-level-firewall-rule

# Prerequisite; Connect to Azure using Connect-AzAccount

# Set variable for your shortname
# $shortname = <shortname>
$shortname = Read-Host -Prompt "Input your shortname"
$shortname = $shortname.ToLower()

# Set variables for your server and database
# Subscription = Omnia Application Workspace - Sandbox
$subscriptionId = "160c90f1-6bbe-4276-91f3-f732cc0a45db"
$resourceGroupName = "edc2019_$shortname"
$serverName = "edc2019sql-$shortname"
$firewallRuleNameClient = "edc2019-client"
$serverFirewallRuleClient = $null

# The ip address range that you want to allow to access your server 
# (leaving at 0.0.0.0 will prevent outside-of-azure connections to your DB)
# $startIP = "0.0.0.0"
# $endIP = "0.0.0.0"

# Find breakout IP address
$whatsMyIP = (Invoke-WebRequest -uri https://ipinfo.io/ip).Content.Trim()
$startIP = $whatsMyIP
$endIP = $whatsMyIP

# Set subscription ID
Set-AzContext -SubscriptionId $subscriptionId
$subscription = Get-AzSubscription -SubscriptionId $subscriptionId
$subscriptionName = $subscription.Name

# Show randomized variables
Write-Host "Subscription name: $subscriptionName"
Write-Host "Resource group name: $resourceGroupName"
Write-Host "Location: $location"
Write-Host "Server name: $serverName"
Write-Host "Firewallrule SQL Server Management Studio: $firewallRuleNameClient"
Write-Host "Start IP: $startIP"
Write-Host "End IP: $endIP"

$serverFirewallRuleClient = Get-AzSqlServerFirewallRule -ResourceGroupName $resourceGroupName -ServerName $serverName -FirewallRuleName $firewallRuleNameClient -ErrorAction SilentlyContinue

if (!$serverFirewallRuleClient)
{
    # Create a server firewall rule that allows access from the specified IP range
    Write-Host "Creating firewallrule for $serverName"
    $serverFirewallRuleClient = New-AzSqlServerFirewallRule -ResourceGroupName $resourceGroupName `
    -ServerName $serverName `
    -FirewallRuleName $firewallRuleNameClient -StartIpAddress $startIP -EndIpAddress $endIP
}

Write-Host "Azure SQL server firewallrule:"
$serverFirewallRuleClient