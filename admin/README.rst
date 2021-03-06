Administration 
==============

This contents of ths folder are for various administration tasks: 

* `runtime-environment/ <#Shared-Runtime-Environment>`_ - For setting up the common runtime environment.
* `onboarding/ <#Onboarding>`_ - For onboarding users
* `offboarding/ <#Offboarding>`_ - For offboarding users
* diagrams-images.pptx - Master for selected media used in the presentations 
  and exercises.

Shared Runtime Environment
--------------------------

Setup
^^^^^

ARM templates for the different common components are under the templates 
folder. To create an environment you should perform the below steps:

Note: More of this could be automated, but it is assumed this won't be run 
too often?!? so time hasn't been invested in this at this stage.

* Change to the runtime-environment folder and run the 
  **create-environment.ps1** script to setup key resources.

  * When prompted enter a SQL admin password that meets Equinor guidelines 
    (you do not need to remember this as AD login will be enabled).
  * Note: Creation of the data lake store might fail if the Resource Group 
    does not exist from before and / or doesn't have a policy exception. In 
    this case see the manual steps for data lake below.

* Give the ``OMNIA - Tutorial participants`` AD group the **Reader** role on 
  the *omnia-tutorial-common* resource group.

* Onboarding

  * Under Active Directory | App registrations add a new registration 
    (service principal) *omnia-tutorial* if it doesn't already 
    exist that will be used for client credential authentication against the 
    data lake. Under certificates & secrets, create a new 
    client secret. Add the value to keyvault as a secret named 
    *DlsOnboarding*. Note the application ID (client ID) and 
    update the onboard.ps1 script $clientId (line 183) to use this.
  * Create a secret in the key vault *SmtpConnectionDetails* this is used for
    details when sending the onboarding email. Request email sending details.
    Enter the password as the secret and populate the other values as tags 
    named User (value: Omnia@equinor.com), Server (value: mrrr.statoil.com), 
    EnableSsl (value: true), Port (value: 25)

* Data Lake Store

  * If not created by the script, the a DLS v2 needs to be setup manually by 
    the Omnia Solum team as current policy doesn't allow this to be created.
    Create this as a standard storage account named **omniatutorialdls** using
    **LRS** replication and with **Hierarchical namespace** enabled.

  * Give the omnia-tutorial service principal the **Storage Blob Data Owner** 
    role.
  
  * Give the ``OMNIA - Tutorial participants`` AD group the **Storage Blob 
    Data Contributor** role (also **Contributor**?? role to view files in 
    online storage explorer).

  * Create the folders:

    * dls/data/open/npd.no/field_production
    * dls/user

  * Upload the file resources\\field_production_monthly.csv to 
    dls/data/open/npd.no/field_production (ideally we might run the data 
    factory job to get an updated version and check things work.

* Data Factory

  * Start Data Factory and from the ARM template dropdown import the 
    data-factory-pipelines temnplate and properties, updating properties and
    settings to reference the EDC resources (TODO: fix / automate this)

* Databricks

  * Login to Databricks, go to User Settings and create an Access Token that 
    will be used for administration purposes (be sure to copy the token 
    value).
  * Go into the key vault. Add a new secret named *DatabricksToken* with the 
    above token
  * Under Active Directory | App registrations add a new registration 
    (service principal) *omnia-tutorial-databricks* if it doesn't already 
    exist that will be used for client credential authentication against the 
    data lake and Sql Server. Under certificates & secrets, create a new 
    client secret. Add the value to keyvault as a secret named 
    *DatabricksSpnClientSecret*. Note the application ID (client ID) and 
    update the compute exercise with this.
  * Link databricks and the keyvault as described at: https://docs.azuredatabricks.net/user-guide/secrets/secret-scopes.html
    Scope name *omnia-tutorial-common-kv* Manage Principal set to *All Users*.
  * Give the service principal permission to the datalake. Under DataLake 
    access control give the service principal the *STORAGE BLOB DATA 
    CONTRIBUTOR* role.
  * Create 2 clusters.

    * High concurency, Terminate after 120 minutes, *Advanced Options | 
      Enable credential passthrough*
    * Standard. 
  * After cluster creation under *Advanced Options | Permissions* set *all 
    users* to *Can Attach To*
  * Add the library *azure-datalake-store* from PyPI to both clusters.
  * Add the library *adal* from PyPI to the high concurrency cluster.

* App Service

  * Go into the WebApp | Identity and verify System assigned status is On.
  * Open query editor for the common database and run the below SQL to give
    the app service access to the database. 

    .. code-block:: sql

      CREATE USER [omnia-tutorial] FROM  EXTERNAL PROVIDER  WITH DEFAULT_SCHEMA=[dbo]
      GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA :: [dbo] TO [omnia-tutorial]
  * Open the solution at */exercises/expose/solution/omnia-tutorial-API.sln* in visual studio and publish
    to the created app service. Verify by going to the website under the path 
    */swagger/*

* Create VMs in Digital Academy Training subscription

  * Use the powershell script 'deploy.ps1' from folder /create-vms to create vms for users to use in the Expose module. Revise the parameters before you run the script, like the number of vms, username and password, etc. The powershell script will create a storage account for vm diagnostics and then create a certain number of vms in the resource group set as parameter. 

  * When the powershell script is finished successfully, check all the resources created in the target resource group. Pick one or a few vms to test the connection and check if you can deploy the starter api to azure web app using Visual Studio. 

  * Send out IP address and user credentials to each user separately. Put password in separate email.

Removal
^^^^^^^

Run the **delete-environment.ps1** script to remove the shared runtime 
environment and all common / shared resources.
NOTE: This script will not remove the app registrations / service principals
- these may be reused at a later time is already setup.

Onboarding
----------

The contents of this folder can be used to onboard individual users and setup 
resources that they need to run the tutorial. Onboarding can be done using the
following scripts:

* **onboard.ps1** - Run this powershell script to add a user, passing their 
  short name as a parameter. This script sets up common resources. Amongst 
  other things it uses the *webapp-arm-template.json* arm template for setting
  up an app service resource.
* **post-onboarding.ps1** - Some of the steps in the onboarding script have 
  been known to fail. In case of errors run this script to retry certain 
  failed actions.



Offboarding
-----------

The contents of this folder can be used to offboard all users and cleanup 
any resources that they have used or created.

Run the **offboard.ps1** script to perform offboarding. Note that 
this does not prompt for any confirmation.

