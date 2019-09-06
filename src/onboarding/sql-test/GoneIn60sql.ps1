$pwd = New-Guid
$location = "northeurope"

$resourceGroupName = "EDC2019Test3"

$secpasswd = ConvertTo-SecureString $pwd.Guid -AsPlainText -Force
$i = 0

while ($i -lt 60)
{
    $serverName = "edc2019-test3-$i"
    Write-Progress $serverName
    $mycreds = New-Object System.Management.Automation.PSCredential ($serverName, $secpasswd)
    $createSqlJob =  New-AzSqlServer -ServerName $serverName -ResourceGroupName $resourceGroupName -SqlAdministratorCredentials $mycreds -Location $location -AsJob
    $i++;
}
Write-Host "Waiting for SQL Server creates to finish ... " -NoNewline
Get-Job | Wait-Job 
Write-Host "Done" -ForegroundColor Green
$i = 0
while ($i -lt 60)
{
    $serverName = "edc2019-test3-$i"
    $dbName = "test_$i"
    New-AzSqlDatabase -DatabaseName $dbName -ServerName $serverName -Edition "Basic" -ResourceGroupName $resourceGroupName -AsJob
    $i++
}
