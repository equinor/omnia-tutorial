Introduction
============
This part of the tutorial covers the following points for computing in Azure Databricks:

* Get data from a data lake gen 2
* Basic computing on the data
* Add dummy GDPR data 
* Store the new data into a Sql table

When writing up, be sure to consider:

* Alternative url's / sources if they didn't complete previous parts


Prerequisites
-------------
* User has access to databricks workspace **EDC2019sharedDatabricks**, has own folder created in the workspace, and has permission to create clusters in the workspace.

Create Notebook and Cluster in Databricks
-----------------------------------------

Get Data From a Data Lake Gen 2
-------------------------------
Mount Data Lake Gen 2 Filesystem Into Databricks
________________________________________________
In this step, we will use Client Credentials to authenticate against Data Lake from Databricks and mount the target folder from Data Lake into Databricks.

**ReadMe:** 
A Service Principal **OmniaEDC2019_DatabricksSPN** has been created and set up to be used here as the client. The application ID (client ID) of this Service Principal is "f0d5bd54-9617-491d-afa1-07c8bd4dc5c1".  

There is a secret created for this Service Principal to be used as client secret. The secret is stored in the shared key vault **EDC2019KV** with secret name **databricksSpnClientSecret**. 

The connection between the key vault and the databricks workspace has been set up with a secret scope **edc_key_vault_scope** in the databricks. 

The target dataset is stored in file system **dls** in Data Lake **edc2019dls** with path **/data/open/npd.no/field_production/field_production_monthly.csv**. 

* Task 1: Figure out how to use key vault secrets from databricks

* Task 2: Reference Databricks documentation `Azure Data Lake Storage Gen 2 <https://docs.databricks.com/spark/latest/data-sources/azure/azure-datalake-gen2.html>`_ to mount data with Client credentials.

**Note: Use this Service Principal and client secret to authenticate against Data Lake. Don't create own Service Principal.**

Read Data After Mounted To Databricks
_____________________________________

Basic Computing
-------------------------------

Add Dummy GDPR Data
-------------------------------

Store Data To a SQL Table
-------------------------------


Optional Extras
---------------

Optional Extra 1
________________
The followinga assumes that you have [Visual Studio installed|an Azure DevOps account|...]

What we Didn't Cover
--------------------

In the interest of time and simplicity, the following points have been omitted from this tutorial although should / must be considered when building production ready solutions:

* Automation and DevOps
* Security (Authentication / Authorisation)
* ...
