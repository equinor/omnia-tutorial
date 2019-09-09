# EDC2019-Ingest-API

This guide is an example on how to transfer data from REST APIs using an function app. The function app in this tutorial will call the an API, convert the content from CSV to JSON and upload the result to a Blob. A Data Factory pipeline will then copy the Blob file to a SQL table.

## Linked Services
1. Create a linked service for the function app. You will need the following parameters:
- **Function url:** https://factpages-tutorial.azurewebsites.net
- **Function key:** 63qtXSzq1OEwFrnas8VlgcxdPtpoL97ti4Xvw41MAh94FfQk8lD7ag==
2. Create a linked service for the Azure Blob Storage.
- **Authentication method:** Account Key
- **Account selection method:** From Azure subscription
- **Azure Subscription:** Omnia Application Workspace - Sandbox
- **Storage account:** omniatutorial

3. Create a linked service for Azure SQL Database. Find database from Azure subscription, server name and database name.
- **Account selection method:** From Azure subscription
- **Server name:** edc2019-sql
- **Database:** common
- **Authentication type:** Managed Identity

## Datasets
1. Create a Dataset for the Blob Storage. Select linked service from step 2 in the previous section. When promptet for file type, select JSON. Browse for file *wellbore.json*
2. Create a Dataset for the SQL table. Select SQL linked service from  step 3 from the previous section. Select the tabel *dbo.Wellbore* as source

## Pipeline
1. Create a pipeline in Data Factory.
2. Set up an Azure Function activity. Linked service is the linked service from step 1 in the previous section. Set "Ingest" as Function name. Method can be either GET or POST. Create a new header by clicking on New under Headers. Use the following vales:
- **Url:** http://factpages.npd.no/ReportServer?/FactPages/TableView/wellbore_exploration_all&rs:Command=Render&rc:Toolbar=false&rc:Parameters=f&rs:Format=CSV&Top100=false&IpAddress=143.97.2.35&CultureCode=en
- **ConnectionString:** DefaultEndpointsProtocol=https;AccountName=omniatutorial;AccountKey=M96FW0QVawI1CqIjnlU8VceVzlpCucXTqBcuGrNpjuhW2B9HCph2ZTE07fX3PbQlINS8NePsKwMhvNI6QRupWw==;EndpointSuffix=core.windows.net
- **ContainerName:** factpages
- **FileName:** wellbore.json
<br/>
The setup shoould look like following:
![alt-text](EDC2019-Ingest-API.PNG)
3. Set up a Copy activity. The Source is the Blob Storage Dataset and Sink is the SQL Dataste.
4. In pre-copy script type in the command *DELETE FROM  dbo.Wellbore*
5. Under Mapping, select Import schemas. This will automatically set up column mapping
4. Click on the green area on the right hand side of the Azure function activity and drag the green line over to the copy activity. This will controll the data flow and will make sure that the copy activity only starts when the Azure function activity has completed successfully