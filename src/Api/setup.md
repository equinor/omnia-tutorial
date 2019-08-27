# EDC API

## 1. Setup

1. Make sure that the web api is connected with the database using MSI. This is done by the setup scripts, and should be in place.
1. Update the `ConnectionString` in `appsettings.json` with the connection string for your database. The connection string is on the following format: 
    - `Server=tcp:<database url>,1433;Initial Catalog=<database name>;Persist Security Info=False;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;`
    - Example:
    - `Server=tcp:edc-api-track.database.windows.net,1433;Initial Catalog=common;Persist Security Info=False;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;`
    > Note that the connection string does NOT contain any username/password, this is handled by the MSI.
    
    > If you didn't finish the previous step, you can use the master database setup by us;  "`Server=tcp:edc2019-sql.database.windows.net,1433;Initial Catalog=common;Persist Security Info=False;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;`", if you don't get access, please contact one of us.

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


## X. Open API Specification (Swagger)

As mentioned earlier, we have enabled [swashbuckle](https://github.com/domaindrivendev/Swashbuckle.AspNetCore) for the project. Swashbuckle is a open-source framework that auto generates a Open API Specification file based on the source code.

Open API Specification comes in various versions, with version 2.0 being popularised under the name `Swagger`. The newest verion of OAP is 3.0, and it is quickly catching up with `Swagger`.

A API specification file has some interesting use-cases;
- There are various tools for various programming languages that can auto-generate a client library based on a spec file.
- It can supplement API documentation, making the API easier to understand.
- It can be used to publish an API in Azure API Management (APIM).

## X 1. Azure API Management

In order to get an API exposed on the api.equinor.com domain, the API has to be published in Equinors Azure API Management instance. There are many reasons why you maybe want to do this;
- Sharing APIs with both internal and external partners in a good manner
- Connectivity between On-prem and cloud solutions are easier with APIM


API Management have various ways of publishing an API, however, it has been decided that publishing should be done using Open API Specification files. This is simply because generating a OpenAPI specification is relatively easy, and importing and publishing such a file in APIM is trivial.