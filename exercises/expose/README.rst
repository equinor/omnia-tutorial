Introduction
============
This part of the tutorial covers how to expose a SQL Server database-table as an API.

This module is quite code-heavy and would typically involve having some tools pre-installed, like Visual Studio or Visual Studio Code. 

The exercise has 3 different paths showing how to achieve the goals using Visual Studio, Visual Studio Code, and also a variant that uses no-pre installed applications.

A Word of warning
-----------------

Doing this without the installed tools is cumbersome and inefficient, so...:

.. image:: ./images/dont-panic.jpg
    :width: 200px

Prerequisites
-------------

This module needs three things:

* Access to Azure
* Tutorial onboarding completed
* A coding environment consisting of one of the following:

  * Visual Studio + git
  * Visual Studio Code + git
  * A modern browser using the portal-experience with VSCode in Azure CLI

Setting up
----------

The tutorial onboarding should have setup a few resources including an Azure
App Service. This will host the API so we will make sure that this is 
connected with the database using a managed service identity (MSI). To check 
this:

* Locate the app service in your resource group in the 
  `Azure Portal <https://portal.azure.com>`_  (Hint: search for "omnia-tutorial-<shortname>-app"
* In the list on the left under the title `Settings`, click the field 
  called "Identity",
* Status should be toggled to *On*,
* If it is *Off*, toggle it *On*, and press save. This enables the MSI for
  your app.
* If it was *Off* contact one of the assistants to get the MSI added to the
  proper AD-group.

If you will NOT be using Visual Studio or Visual Studio Code
------------------------------------------------------------

If you are NOT using Visual Studio or Visual Studio Code you will need to use
the Azure Cloud Shell and VSCode in Azure CLI. If you havent used and 
configured Cloud Shell previously you will need to do that now:

* Start Azure Cloud Shell using the icon at the top right of the Azure portal.

  .. image:: ./images/cloud-shell-button.png

* Choose the powershell-variant when prompted

  .. image:: ./images/welcome-storage.png
          
* In the storage dialog chose advanced settings so we can create necessary
  storage in your own resource group.

  .. image:: ./images/basic-storage.png

* Use the following settings for advanced setup:

  * Subscription: "Omnia Application Workspace - Sandbox"
  * Cloud Shell region: Noth Europe
  * Resource group: "Use existing" --> edc2019\_\<shortname\>
  * Storage account: "Create new" --> your choice of name, all lowercase and 
    no special characters, e.g. edc2019\-\<shortname\>-cs-storage
  * File share: "Create new" --> your choice of name, all lowercase and no 
    special characters, e.g. cloudshell

  .. image:: ./images/advanced-storage.png
   
* For some general information about Azure cloud shell
  * [How to use Azure Cloud Shell](https://docs.microsoft.com/en-us/azure/cloud-shell/quickstart-powershell)
  * [Persist files in Azure Cloud Shell](https://docs.microsoft.com/en-us/azure/cloud-shell/persisting-shell-storage)
  * [How to upload files from local computer](https://docs.microsoft.com/en-us/azure/cloud-shell/using-the-shell-window#upload-and-download-files)

Getting the code
----------------

First we need to get a local copy of the started project. This will differ 
depending upon the tools that we are using.

Visual Studio Code or Visual Studio 17/19
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* In powershell or a command prompt, navigate to a folder where you want to
  download the git repository, example "C:\Code".
* Run the command `git clone https://github.com/equinor/omnia-tutorial.git`

VSCode in Azure CLI
^^^^^^^^^^^^^^^^^^^

* Open up a cloud shell prompt either through the Azure portal or `here <https://shell.azure.com/>`__
* Run the command `cd`, this should move you to the */$home/\<shortname\>* 
  folder
* Run the command `git clone https://github.com/equinor/omnia-tutorial.git`
* If you are prompted with a login, enter your credentials.
* The multi-factor authentication might mess up the login, to fix this:

  * Navigate to `GitHub <https://github.com/>`_ and login in
  * Find the account meny on the top right
  * Go to "settings"
  * Go to "Developer Settings"
  * Go to "Personal access tokens" and press "Generate new token" on the 
    right.
  * Select the "repo" permissions
  * When the token has been generated it will display as a long string of 
    character, something like "c26abfb14015d35c19fb4f2b0ba529de2b4f48fa", 
    copy this to a text document.
  * Go back to the powershell prompt from earlier, and re-run the command 
    `git clone https://github.com/equinor/omnia-tutorial.git`
  * Enter your username
  * Copy and paste in the token string instead of you password, this should 
    start the download.

Opening up the project
----------------------

Next we will open the started project in our chosen tool.

Visual Studio 17/19
^^^^^^^^^^^^^^^^^^^

* Start Visual Studio.
* Open the *EDC-API-skeleton.sln* solution file located in the folder where 
  you cloned down the github repository under the 
  *omnia-tutorial\\exercises\\expose\\starter* folder
* On one of the sides, there should be a "Solution Explorer" containing all 
  the files in the project
* If the "Solution Explorer" isn't there, press "Ctrl-Alt-L" and it should 
  appear. If not, navigate to "View" in the top and select 
  "Solution Explorer".

Visual Studio Code
^^^^^^^^^^^^^^^^^^

* Open up Visual Studio Code
* Click "File" in the top left, and select "Open Folder"
* Navigate to "omnia-tutorial\\exercises\\expose\\starter" and select the 
  folder "EDC-API" and click "Select Folder"
* This should open the file structure in the "Explorer" on the left, if not 
  open it by pressing `Ctrl-Shift-E`, or press the *Explorer* icon in the top
  left.

VSCode in Azure CLI
^^^^^^^^^^^^^^^^^^^

* In the cloud shell prompt navigate to the starter folder using the command
  `cd ./omnia-tutorial/exercises/expose/starter/EDC-API`
* Enter `code EDC-API-skeleton`
* This should open a VSCode view with the correct folder open. You can open
  different files to edit using the `...` dropdown at the top right of the 
  VSCode window and then typing the name of the file to open.

Connecting to the data
----------------------

In your selected editor, open the file `appsettings.json` (if
using VSCode online be sure to chose the one under the starter folder). We 
need to update the `ConnectionString` value with the correct connection 
string for the backend database. 

Here we have two scenarios:

* Scenario 1 - You completed the ingest module and therefore have a 
  personal SQL Server with the required data.
* Scenario 2 - You have not completed the ingest module.

Scenario 1
^^^^^^^^^^
If you completed the ingest module then we will use the connection string for 
your personal SQL Server and also need to setup access from the AppService 
that will host our API.

* Update the `ConnectionString` in `appsettings.json` with the connection 
  string for your database. This should be in the following format:

  `Server=tcp:<database url>,1433;Initial Catalog=<database name>;Persist Security Info=False;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;`

  To find the URL, navigate to your resouce group in the 
  `Azure Portal <portal.azure.com>`__, open up your `SQL database`. The URL 
  should be located in the top right under `Server name`.

  Example:
  
  `Server=tcp:edc-api-track.database.windows.net,1433;Initial Catalog=common;Persist Security Info=False;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;`

  .. note:: 
    The connection string does NOT contain any username/password, this is 
    handled by the *Managed Service Identity (MSI)* in the next step.

* We now need to grant the MSI access in the database so navigate to your 
  resouce group in the `Azure Portal <portal.azure.com>`__ and locate your 
  `SQL database`.
* In the list on the left, navigate to `Query editor (preview)`, and connect
  using `Active Directory authentication`. 
  
  *(The login might fail, retry it a few times before contacting one of us)*.
* This should open a query editor, enter the following commands, replacing the
  <app name> placeholder with the name of your AppService e.g. 
  edc2019-<shortname>-app: 

  .. code-block:: sql

    CREATE USER [<app name>] FROM  EXTERNAL PROVIDER  WITH DEFAULT_SCHEMA=[dbo]
    GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA :: [dbo] TO [<app name>]
        
Scenario 2
^^^^^^^^^^

If you have not completed the ingest module we will use a shared completed 
database that has already been created.

* Update the `ConnectionString` in `appsettings.json` with the connection 
  string for the common  database. The connection string is as follows: 

  `Server=tcp:edc2019-sql.database.windows.net,1433;Initial Catalog=common;Persist Security Info=False;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;`

  If you don't get access, please contact one of us.

.. note:: 
  We only give read access to our database. All endpoints with creates/updates/deletes will then fail, but the logic should still be in place. This is to ensure that someone doesn't break the database for all the rest.

Testing Your API locally
------------------------

At the moment our API doesn't do much, however we have preconfigured 
Swashbuckle in the project, giving access to a documentation page for the API. 

Any time you want to test your API, simply run the API locally by doing
the following:

* In Visual Studio 17/19, press `F5`. 

  The swagger page should be available at https://localhost:44373/swagger. If the window doesn't appear, find the base URL in the Visual studio `Output` window, and add `/swagger`.
* In Visual Studio Code open a terminal window and enter the command 
  `dotnet build` to build your solution, and `dotnet run` to start the API. 

  The default URL is typically `localhost:5001`, and the swagger page should 
  be available at localhost:5001/swagger.
* If using the cloud shell, make sure you are still in the EDC-API folder and
  enter the command `dotnet build` to build your solution, and `dotnet run` 
  to start the API. 

  The service should now be up and running in the context of the 
  CLI- workspace.
  But we have had some problems on accessing the running site, so to
  fully test this, head down to the Deploying to Azure section.

Implementing the code-changes
-----------------------------

We have configured `Entity Framework (EF) Core <https://docs.microsoft.com/en-us/ef/core/>`_ for the project. EF is a Object-relational mapper that converts between objects in the code, and tables in the database. This allows us to access data without writing SQL statements. 

We have configured the project such that the database can be accessed through the `CommonDbContext` class. This class is already injected into both controllers.

Examples of using Entity Framework might include:

* Retrieving all production data entries: 
    `var productionDatas = _context.ProductionData.Tolist()`
* Adding new entry: 
    `_context.ProductionData.Add(new ProductionData {})`
* Updating existing entry: 
    `_context.ProductionData.Update(productionDataObject)`
* Retrieving a single entry based on some criteria: 
    `var productionData = _context.ProductionData.FirstOrDefault( pd => pd.Wellbore == "Some wellbore")`
* Retrieving a list of entries matching some criteria: 
    `var productionDatasList = _context.ProductionData.Where( pd => pd.Wellbore == "Some wellbore").ToList()`

ProductionDataController
^^^^^^^^^^^^^^^^^^^^^^^^^

Under the solution folder `Controllers` you should find the `ProductionDataController`. Open this file as it is here you will need to make changes. 

This controller should implement the most common functionality for any API; Create, Read, Update, and Delete (CRUD). Typically CRUD is implemented on a per-table/view basis.

Since we are in the web API domain, all results from the API has to be associated with a HTTP response. This means, we never return a list of objects directly, return a `200 Ok` response that contains the list of objects.

Example:

.. code::

  > var entries = _context.ProductionData.ToList();
  > return Ok(entries);

`ASP.NET Core <https://docs.microsoft.com/en-us/aspnet/core/?view=aspnetcore-2.2>`_ natively supports: `Ok()`, `BadRequest()`, `NotFound()`, `Unauthorized`, `Forbid()`, `NoContent()`, and many more.

Here we will implement the Read operation. The other parts will be completed 
later as an optional exercise in the `Completing the API`_ section.

The controller method `GetProductionData()` should return a list containing 
the entire `ProductionData` table. Replacing the method with the 
following:

.. code::

    public ActionResult<IEnumerable<ProductionData>> GetList(string search)
    {
        var productionDataQueryable = _context.ProductionData.AsQueryable();

        if (!string.IsNullOrEmpty(search))
        {
            productionDataQueryable = productionDataQueryable
                .Where(pa => pa.Wellbore.Contains(search) || pa.Year.ToString().Contains(search));
        };

        return productionDataQueryable.ToList();
    }
    
The controller method `Get(int id)` should return a single 
entry from the `ProductionData` table, correpsonding to the ID. It should
also appropriately handle non-existing entries. Replacing the method with the 
following:

.. code::

    public ActionResult<ProductionData> Get(int id)
    {
        var productionData =  _context.ProductionData.Find(id);

        if (productionData == null)
        {
            return NotFound();
        }

        return productionData;
    }
    
Deploying to Azure
------------------

In a traditional setup, deployments to Azure should be done using some sort of DevOps tools, like Azure DevOps. However, for the sake of brevity we will publish the code directly.

Visual Studio 17/19
^^^^^^^^^^^^^^^^^^^

* Right click the api project in the solution explorer
* Select `Publish..`
* Select `App Service` and then check of `Select Existing` and hit `Publish`
* Give the app a logical name
* Select the subscription `Omnia Application Workspace - Sandbox` and 
  `edc2019_<shortname>` resource group.
* Select the app service `edc2019-<shortname>-app` and hit `Ok`

After a while a new window will open with the deployed API. As this is the 
base url, it will give a 404 error. You can either append part of the API path
directly e.g. */production-data* or access the swagger file at 
https://edc2019-<shortname>-app.azurewebsites.net/swagger/index.html and test 
from there. Be sure to swap out <shortname> with your actual shortname.

`Reference <https://docs.microsoft.com/en-us/dotnet/azure/dotnet-quickstart-vs?view=azure-dotnet#deploying-the-application-as-an-azure-web-app>`__

Visual Studio Code
^^^^^^^^^^^^^^^^^^

* Install the `Azure App Service` extension
* Open Visual Studio Code terminal
* Use the following command to generate a Release package to a sub folder 
  called publish:
  * `dotnet publish -c Release -o ./publish`
* A new publish folder will be created under the project structure
* Right click the `publish` folder and select `Deploy to Web App...`, this 
  might prompt for login
* Select the subscription `Omnia Application Workspace - Sandbox` and 
  `edc2019_<shortname>` resource group.
* Select the app service `edc2019-<shortname>-app` if needed and hit `Ok`
* Visual Studio Code will ask you if you want to overwrite the existing 
  content. Click `Deploy` to confirm

After a while a new window will open with the deployed API. As this is the 
base url, it will give a 404 error. You can either append part of the API path
directly e.g. */production-data* or access the swagger file at 
https://edc2019-<shortname>-app.azurewebsites.net/swagger/index.html and test 
from there. Be sure to swap out <shortname> with your actual shortname.

`Reference <https://docs.microsoft.com/en-us/aspnet/core/tutorials/publish-to-azure-webapp-using-vscode?view=aspnetcore-2.2#generate-the-deployment-package-locally>`__

VSCode in Azure CLI
^^^^^^^^^^^^^^^^^^^

* Run the command `Set-AzContext "Omnia Application Workspace - Sandbox"` so 
  we are working in the correct subscription.
* Ensure you are still in the correct folder.
* Run `dotnet publish -c Release`, this creates the project in the 
  `publish` folder. Note this path as you need it in the next step. 

  Typically this is `/home/<your-name>/omnia-tutorial/expose/starter/EDC-API/bin/Release/netcoreapp2.2/publish/`
* Create a .zip file of the project:

  * Create a reference to the publish folder: 
    `$publishFolder = "<path-to-folder>"`, this is the same folder from the 
    last step.
  * Create variable in the CLI: `$publishZip = "publish.zip"`
  * Create the zip

    .. code-block::

      if(Test-path ~/$publishZip) {Remove-item ~/$publishZip} 
      Add-Type -assembly "system.io.compression.filesystem" 
      [io.compression.zipfile]::CreateFromDirectory($publishFolder, $publishZip)
  * Run the following block to deploy the zip file, replacing <your-shortname>
    with your shortname:

    .. code-block::
    
      Publish-AzWebapp -ResourceGroupName "edc2019_<your-shortname>" -Name "edc2019-<your-shortname>-app" -ArchivePath $publishZip

* The deployment might take a few seconds
* It should produce output like the table below if the deployment was 
  successful:

==============================  ========    =========================== ======================================================== =============
Name                            State       ResourceGroup               EnabledHostNames                                         Location 
==============================  ========    =========================== ======================================================== =============
edc2019-\<your-shortname\>-app  Running     edc2019\_\<your-shortname\> {"edc2019-\<your-hortname\>-app.azurewebsites.net", ...  North Europe 
==============================  ========    =========================== ======================================================== =============

* Navigate to 
  `edc2019-\<your-shortname\>-app.azurewebsites.net/swagger/` to 
  verify that the API is running as it should.

Open API Specification
----------------------

As mentioned earlier, we have enabled [Swashbuckle](https://github.com/domaindrivendev/Swashbuckle.AspNetCore) for the project. Swashbuckle is a open-source framework that auto generates a Open API Specification file based on the source code.

Open API Specification comes in various versions, with version 2.0 being popularised under the name `Swagger`. The newest verion of OAP is 3.0, and it is quickly catching up with `Swagger`.

An API specification file has some interesting use-cases:

* There are various tools for various programming languages that can 
  auto-generate a client library based on a spec file.
* It can supplement API documentation, making the API easier to understand.
* It can be used to publish an API in Azure API Management (APIM).

In many cases it might actually be able to start with an API specification 
file before generating any code (contract first development).

Azure API Management
--------------------

In order to get an API exposed on the api.equinor.com domain, the API has to 
be published in Equinors Azure API Management instance. There are many 
reasons why you maybe want to do this:

* Sharing APIs with both internal and external partners in a good manner
* Connectivity between On-prem and cloud solutions are easier with APIM

API Management have various ways of publishing an API, however, it has been 
decided that publishing should be done using Open API Specification files. 
This is simply because generating a OpenAPI specification is relatively easy, 
and importing and publishing such a file in APIM is trivial.

Completing the API
------------------

Earlier we only added code for the *ProductionDataController* read-method. Here we will complete the other parts.

Note that this will only work if you have setup your own SQL Server, as you only have read-rights on the Common-one.

You can reference the Entity Framework examples above or look at the reference
implementation in *omnia-tutorial\exercises\expose\solution\EDC-API*.

1. ProductionDataController
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**1.1 Create**
..............

Implement the controller method `Post(ProductionDataRequest request)`

* Take `ProductionDataRequest` object and create a new `ProductionData` object
* Insert the new `ProductionData` object in the table.
* *NB: Can't create an existing entry.*

**1.2 Update**
..............

Implemented the controller method `Put(int id, ProductionData productionData)`

* Update an entry in the database using the `Update` functionality of Entity 
  Framework

**1.3 Delete**
..............

Implement the controller method `Delete(int id)`
* Delete an entry in the database based on its' ID
* Should return the deleted entry
* *NB: Can't delete an entry that doesn't exist.*

**2. AggregatesController**
^^^^^^^^^^^^^^^^^^^^^^^^^^^

All these methods calculate properties for all the wellbores.

**2.1 Calculate sum of Oil & Gas between 2 dates**
..................................................

Implemented the controller method `GetOilBetweenDates(int? fromYear, int? toYear, int? fromMonth, int? toMonth)`

* Takes in 2 dates, as a year-month pair, and calculates the total amount of 
  Oil production in the interval sorted by wellbores.
* Should return a list of wellbores and their total amount of Oil

Implemented the controller method `GetGasBetweenDates(int? fromYear, int? toYear, int? fromMonth, int? toMonth)`

* Takes in 2 dates, as a year-month pair, and calculates the total amount of 
  Gas production in the interval.
* Should return a list of wellbores and their total amount of Gas

Be sure to preprocess the input properly

**2.2 Calculate average Oil and Gas between 2 dates**
.....................................................

Implemented the controller method `GetOilAvgBetweenDates(int? fromYear, int? toYear, int? fromMonth, int? toMonth)`

* Takes in 2 dates, as a year-month pair, and calculates the average amount 
  of Oil production in the interval sorted by wellbores.
* Should return a list of wellbores and their average amount of Oil

Implemented the controller method `GetGasAvgBetweenDates(int? fromYear, int? toYear, int? fromMonth, int? toMonth)`

* Takes in 2 dates, as a year-month pair, and calculates the average amount 
  of Gas production in the interval.
* Should return a list of wellbores and their average amount of Gas

Be sure to preprocess the input properly


**2.3 Find the number of wellbore records between 2 dates**
...........................................................

Implement the method `GetWellboreRecordsBetweenDates(int? fromYear, int? toYear, int? fromMonth, int? toMonth)`

* Should return a list of wellbores and the amount of records each wellbore 
  has for the given period.

> Be sure to preprocess the input properly

What we Didn't Cover
--------------------

In the interest of time and simplicity, the following points have been omitted from this tutorial although should / must be considered when building production ready solutions:

* Authorisation & Authentication
* Deployment & Sharing
* Legal aspects
* Performance
* Sharing
* Data Catalog
* Publishing in APIM

