# EDC API

## 1. Setup

1. Make sure that the web api is connected with the database using MSI. This is done by the setup scripts, and should be in place. To check the this:
    - Locate the app service in your resource group in the azure portal
    - In the list on the left under the title `Settings`, click the field called `Identity`,
    - Status should be toggled to  `On`,
    - If it is `Off`, toggle it `On`, and press save. This enables the MSI for your app.    
1. **IF YOU ARE USING YOU OWN DATABASE**:
    1. Update the `ConnectionString` in `appsettings.json` with the connection string for your database. The connection string is on the following format: 
        - `Server=tcp:<database url>,1433;Initial Catalog=<database name>;Persist Security Info=False;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;`
        - Example:
        - `Server=tcp:edc-api-track.database.windows.net,1433;Initial Catalog=common;Persist Security Info=False;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;`
        > Note that the connection string does NOT contain any username/password, this is handled by the MSI.
    2. Then we have to grant the MSI access in the database:
    1. Navigate to your resource group and locate your `SQL database`.
    1. In the list on the left, navigate to `Query editor (preview)`, and connect using `Active Directory authentication`. *(The login might fail, retry it a few times before contacting one of us)*.
    1. This should open a query editor, enter the following commands, **updated with your values** of course: 
        - `CREATE USER [<app name>] FROM  EXTERNAL PROVIDER  WITH DEFAULT_SCHEMA=[dbo]`
        - `GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA :: [dbo] TO [<app name>]`
        

    
1. **IF YOU ARE USING OUR DATABASE**:
    1. Update the `ConnectionString` in `appsettings.json` with the connection string for your database. The connection string is on the following format: 
        - "`Server=tcp:edc2019-sql.database.windows.net,1433;Initial Catalog=common;Persist Security Info=False;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;`"
        - If you don't get access, please contact one of us.

    > NOTE: We only give read access to our database. All endpoints with creates/updates/deletes will then fail, but the logic should still be in place. This is to ensure that someone doesn't break the database for all the rest.

We have preconfigured Swashbuckle in the project, giving access to a documentation page.

If you want to test your API, simply run the API locally and use the portal that appears.
## 2. ProductionDatasController
The `ProductionDatasController` represent the most common functionality for any API; Create, Read, Update, and Delete (CRUD). Typically CRUD is implemented on a per-table/view basis.
### 2.1 Read
Implement the controller methods:
- `GetProductionData()`
    - Should return a list containing the entire `ProductionData` table.
- `GetProductionData(int id)`
    - Should return a single entry in the `ProductionData` table, correpsonding to the ID.
    - *NB: Appropriately handle non-existing entry.*
### 2.2 Create
Implement the controller method `PostProductionData(ProductionDataRequest request)`
- Take `ProductionDataRequest` object and create a new `ProductionData` object
- Insert the new `ProductionData` object in the table.
- *NB: Can't create an existing entry.*
### 2.3 Update
Implemented the controller method `PutProductionData(int id, ProductionData productionData)`
- Update an entry in the database using the `Update` functionality of Entity Framework
- *NB: Make sure to handle concurrent updates.*
### 2.4 Delete
Implement the controller method `DeleteProductionData(int id)`
- Delete an entry in the database based on its' ID
- Should return the deleted entry
- *NB: Can't delete an entry that doesn't exist.*

## 3. AggregatesController

All these methods calculate properties for all the wellbores.

### 3.1 Calculate sum of Oil & Gas between 2 dates
Implemented the controller methods:
- `GetOilBetweenDates(int? fromYear, int? toYear, int? fromMonth, int? toMonth)`
    - Takes in 2 dates, as a year-month pair, and calculates the total amount of Oil production in the interval sorted by wellbores.
    - Should return a list of wellbores and their total amount of Oil
- `GetGasBetweenDates(int? fromYear, int? toYear, int? fromMonth, int? toMonth)`
    - Takes in 2 dates, as a year-month pair, and calculates the total amount of Gas production in the interval.
    - Should return a list of wellbores and their total amount of Gas

> Be sure to preprocess the input properly
### 3.2 Calculate average Oil and Gas between 2 dates
Implemented the controller methods:
- `GetOilAvgBetweenDates(int? fromYear, int? toYear, int? fromMonth, int? toMonth)`
    - Takes in 2 dates, as a year-month pair, and calculates the average amount of Oil production in the interval sorted by wellbores.
    - Should return a list of wellbores and their average amount of Oil
- `GetGasAvgBetweenDates(int? fromYear, int? toYear, int? fromMonth, int? toMonth)`
    - Takes in 2 dates, as a year-month pair, and calculates the average amount of Gas production in the interval.
    - Should return a list of wellbores and their average amount of Gas

> Be sure to preprocess the input properly


### 3.3 Find the number of wellbore records between 2 dates

Implement the method `GetWellboreRecordsBetweenDates(int? fromYear, int? toYear, int? fromMonth, int? toMonth)`:
- Should return a list of wellbores and the amount of records each wellbore has for the given period.

> Be sure to preprocess the input properly

## 4 Moving to Azure

In a traditional setup deployments to Azure should be done using some DevOps tools, like Azure DevOps. However, for the sake of brevity we will publish the code directly.

### [Visual Studio](https://docs.microsoft.com/en-us/dotnet/azure/dotnet-quickstart-vs?view=azure-dotnet#deploying-the-application-as-an-azure-web-app)
- Right click the api project in the solution explorer
- Select `Publish..`
- Select `App Service` and then check of `Select Existing` and hit `Publish`
- Give the app a logical name
- Select the subscription `Omnia Application Workspace - Sandbox` and `edc2019_<shortname>`
- Select the app service `edc2019-<shortname>app` and hit `Ok`

After a while a new window will open with the API

### [Visual Studio Code](https://docs.microsoft.com/en-us/aspnet/core/tutorials/publish-to-azure-webapp-using-vscode?view=aspnetcore-2.2#generate-the-deployment-package-locally)
- Install the `Azure App Service` extension
- Open Visual Studio Code terminal
- Use the following command to generate a Release package to a sub folder called publish:
    - `dotnet publish -c Release -o ./publish`
- A new publish folder will be created under the project structure
- Right click the `publish` folder and select `Deploy to Web App...`, this might prompt for login
- Select the subscription the existing Web App resides
- Select the Web App from the list
- Visual Studio Code will ask you if you want to overwrite the existing content. Click `Deploy` to confirm

### VSCode in Azure CLI
- Navigate to the folder with the with the solution.
    - Typically `/home/<your-name>/code/omnia-tutorial/src/Api/EDC-API-skeleton`
- Run `dotnet publish -c Release`, this creates the project in the `publish` folder.
    - Typically `/home/<your-name>/code/omnia-tutorial/src/Api/EDC-API-skeleton/EDC-API/bin/Release/netcoreapp2.2/publish/`
- Create .zip file of the project:
    - Create a reference to the publish folder: `$publishFolder = "<path-to-folder>"`, this is the same folder from the last step.
    - Create variable in the CLI: `$publishZip = "publish.zip"`
    - Create the zip:
    ```ps1
    if(Test-path $publishZip) {Remove-item $publishZip}
    Add-Type -assembly "system.io.compression.filesystem"
    [io.compression.zipfile]::CreateFromDirectory($publishFolder, $publishZip)
    ```
    - Run the following block to deploy the zip file:
    ```ps1
    Publish-AzWebapp -ResourceGroupName "edc2019_<your-shortname>" -Name "edc2019-<your-shortname>app" -ArchivePath $publishDir
    ```
- The deployment might take a few seconds
- It should produce output like the table below if the deployment was successful:
    | Name | State |ResourceGroup |EnabledHostNames | Location |
    |--|--|--|--|--|
    | edc2019-`your-hortname`app | Running | edc2019_`your-hortname` | {`edc2019-'your-hortname'app.azurewebsites.net`, edc2019-jon… | North Europe |
- Navigate to `edc2019-'your-hortname'app.azurewebsites.net/swagger/index.html` to verify that the API is running as it should.

## 5 Open API Specification

As mentioned earlier, we have enabled [Swashbuckle](https://github.com/domaindrivendev/Swashbuckle.AspNetCore) for the project. Swashbuckle is a open-source framework that auto generates a Open API Specification file based on the source code.

Open API Specification comes in various versions, with version 2.0 being popularised under the name `Swagger`. The newest verion of OAP is 3.0, and it is quickly catching up with `Swagger`.

A API specification file has some interesting use-cases;
- There are various tools for various programming languages that can auto-generate a client library based on a spec file.
- It can supplement API documentation, making the API easier to understand.
- It can be used to publish an API in Azure API Management (APIM).

## 6 Azure API Management

In order to get an API exposed on the api.equinor.com domain, the API has to be published in Equinors Azure API Management instance. There are many reasons why you maybe want to do this;
- Sharing APIs with both internal and external partners in a good manner
- Connectivity between On-prem and cloud solutions are easier with APIM


API Management have various ways of publishing an API, however, it has been decided that publishing should be done using Open API Specification files. This is simply because generating a OpenAPI specification is relatively easy, and importing and publishing such a file in APIM is trivial.
