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