Introduction
============
The main part of the tutorial covers the following points for computing in Azure Databricks:

* Extraction
  
  * Load data from ADLS Gen 2
* Transformation  
  
  * Basic computing
  * Enrich data (dummy GDPR) 
* Loading
  
  * Load transformed data to SQL server for further analysis

The extras section covers other options you can consider.

Prerequisites
-------------
* User has access to databricks workspace **EDC2019sharedDatabricks**, has own folder created in the workspace.
* User has own SQL server and database created in module **Ingest**. 

Create Notebook in Databricks
-----------------------------
* Open Databricks workspace **EDC2019sharedDatabricks** with URL: https://northeurope.azuredatabricks.net/?o=1561392505117079.

  **Note: Don't launch the workspace from Azure Portal. You don't have access there.**
* Sign in using Azure AD.
* After you login, on the upper right area of the web page, click on the people icon, shown as below:

  .. image:: ./images/compute/peopleicon.PNG
* Accept the invitation from workspace **EDC2019sharedDatabricks**. Make sure you are working in this workspace before you continue.
* Find your user folder under **Workspace**, like below:
  
  .. image:: ./images/compute/userfolder.PNG
* Right click on your folder and choose **Create** -> **Notebook**:

  .. image:: ./images/compute/createnotebook.PNG
* Input the name for your new notebook (e.g. 'Compute') and attach the notebook to a running cluster we have created for you:
  
  .. image:: ./images/compute/createnotebook2.PNG

After the notebook is created, you will jump to the notebook page. And you can start your databricks notebook from there now!

**!!!Before you get started, read the following points for background info BELOW:**

  * The target dataset is stored in file system **dls** in Data Lake **edc2019dls** with path **/user/<your-short-name>/<your-csv-filename>.csv**. 

  * A Service Principal **OmniaEDC2019_DatabricksSPN** has been created and set up to be used here as the client. The application ID (client ID) of this Service Principal is "f0d5bd54-9617-491d-afa1-07c8bd4dc5c1".  

  * There is a secret created for this Service Principal to be used as client secret. The secret is stored in the shared key vault **EDC2019KV** with secret name **databricksSpnClientSecret**. The permissions of this client have been set up for this module. 

  * The connection between the key vault and the databricks workspace has been set up with a secret scope **edc_key_vault_scope** in the databricks. 

  * The **tenant ID** of Equinor is "3aa4a235-b6e2-48d5-9195-7fcf05b459b0".

  * For the tasks without reference script given, you can find the solution script in `EDC Compute Module Solutions <https://github.com/equinor/omnia-tutorial/blob/master/solution/Compute/compute_solution.py>`_.


Extraction - Load data from ADLS Gen 2
--------------------------------------
In this step, you need to load the .csv file as a dataframe from targeted folder in datalake. 

* Task 1: Reference Databricks documentation `Authenticate to Azure Data Lake Storage with your Azure Active Directory Credentials <https://docs.azuredatabricks.net/spark/latest/data-sources/azure/adls-passthrough.html>`_. Use the vcode under the section *Read and write Azure Data Lake Storage using credential passthrough* to load the .csv file from the datalake as a dataframe.

**Note: Choose cluster "EDC-HighConcurrency-Shared" to run the notebook. Azure Passthrough is enabled on this cluster.**

  You can reference the example code as below:
  ::

      df =spark.read.csv("abfss://dls@edc2019dls.dfs.core.windows.net/user/<your-short-name>/*.csv", header='true').collect()
      df = spark.createDataFrame(df)
      display(df)


Transformation
--------------
Basic Computing
_______________
In this step, you will do some basic compute on the dataframe you get from the steps above. 

* Task 2: For each Information Carrier and each year, calculate the sum of each column listed below:

  * prfPrdOilNetMillSm3  
  * prfPrdGasNetBillSm3
  * prfPrdNGLNetMillSm3
  * prfPrdCondensateNetMillSm3
  * prfPrdOeNetMillSm3
  * prfPrdProducedWaterInFieldMillSm3

  The output dataframe should look like below:

  .. image:: ./images/compute/basiccompute.PNG

  If you are not familiar with python, you can reference the script below:
  ::

      df_2 = df.select(df.prfInformationCarrier.cast("string"), df.prfYear.cast("int"), df.prfPrdOilNetMillSm3.cast("double"), df.prfPrdGasNetBillSm3.cast("double"), df.prfPrdNGLNetMillSm3.cast("double"), df.prfPrdCondensateNetMillSm3.cast("double"), df.prfPrdOeNetMillSm3.cast("double"), df.prfPrdProducedWaterInFieldMillSm3.cast("double"))
      display(df_2)

      df_3 = df_2.orderBy('prfInformationCarrier').groupBy('prfInformationCarrier','prfYear').agg({'prfPrdOilNetMillSm3':'sum', 'prfPrdGasNetBillSm3':'sum', 'prfPrdNGLNetMillSm3':'sum', 'prfPrdCondensateNetMillSm3':'sum', 'prfPrdOeNetMillSm3':'sum', 'prfPrdProducedWaterInFieldMillSm3':'sum'})
      display(df_3)


Enrich data (dummy GDPR)
________________________
In this step, you will add a column to the dataframe you get in the last step. This column will be treated as GDPR data in the next module. 

* Task 3: Add a column named "GDPRColumn" in the dataframe. The content can be any dummy data.

  Like in **Basic Computing**, you can reference the script below:
  ::

      df_4 = df_3.select('*', (df_3.prfYear + 300).alias('GDPRColumn'))
      display(df_4)

Loading - Load transformed data to SQL server for further analysis
------------------------------------------------------------------
In this step, the latest dataframe will be stored into a table in the SQL database you created in module **Ingest**. Reference `Connect Azure Databricks to SQL Database & Azure SQL Data Warehouse using a Service Principal <https://thedataguy.blog/connect-azure-databricks-to-sql-database-azure-sql-data-warehouse-using-a-service-principal/>`_ to use client credentials to authenticate against SQL server from databricks.

**Note: Use Service Principal OmniaEDC2019_DatabricksSPN. Don't create own Service Principal.**

* Task 4: Set service principal **OmniaEDC2019_DatabricksSPN** as a user to your database with **db_owner** role. 

  Run the following SQL query upon your SQL database:
  ::

      CREATE USER [OmniaEDC2019_DatabricksSPN] FROM  EXTERNAL PROVIDER  WITH DEFAULT_SCHEMA=[dbo];

      EXEC sp_addrolemember N'db_owner', N'OmniaEDC2019_DatabricksSPN';

* Task 5: Get client secret from key vault in databricks. Reference the section **Use the secrets in a notebook** in `Azure Databricks Documentation <https://docs.azuredatabricks.net/user-guide/secrets/example-secret-workflow.html#use-the-secrets-in-a-notebook>`_.
* Task 6: Authenticate against SQL server with client credentials. Connect to SQL Database using JDBC. 
  The example code in `Connect Azure Databricks to SQL Database & Azure SQL Data Warehouse using a Service Principal <https://thedataguy.blog/connect-azure-databricks-to-sql-database-azure-sql-data-warehouse-using-a-service-principal/>`_ is written in Scala. You need to rewrite it in python. You can reference the script below:
  ::

      import adal
      authority_host_uri = 'https://login.windows.net'
      tenant = '3aa4a235-b6e2-48d5-9195-7fcf05b459b0'
      authority_uri = authority_host_uri + '/' + tenant
      resource_uri = 'https://database.windows.net/'
      client_id = 'f0d5bd54-9617-491d-afa1-07c8bd4dc5c1'

      context = adal.AuthenticationContext(authority_uri, api_version=None)
      mgmt_token = context.acquire_token_with_client_credentials(resource_uri, client_id, client_secret)
      token = mgmt_token['accessToken']

* Task 7: Create a table named **dbo.TransformedFieldProduction** in SQL database. Write the dataframe you get from the last step into this table. 

  You can reference the script below:
  ::

      df_4.write.format('jdbc').options(
            url="jdbc:sqlserver://<your-sql-server-name>.database.windows.net:1433",
            databaseName="<your-sql-database-name>",
            driver="com.microsoft.sqlserver.jdbc.SQLServerDriver",
            dbtable="dbo.TransformedFieldProduction",
            encrypt="true",
            hostNameInCertificate = "*.database.windows.net",
            trustServerCertificate = "false",
            accessToken=token).mode('append').save()

Optional Extras
---------------

Extraction - Read Data From Datalake Using Client Credentials With Mounting
___________________________________________________________________________
* Task 8: Redo step **Get Data From Datalake Gen 2**. Instead of using Azure Passthrough, reference Databricks documentation `Azure Data Lake Storage Gen 2 <https://docs.databricks.com/spark/latest/data-sources/azure/azure-datalake-gen2.html>`_ to mount targeted data to databricks with client credentials.

**Note: Choose cluster "EDC-Standard-Shared" to run the notebook. Azure Passthrough is not enabled on this cluster.**

Extraction - Read Data From Datalake Directly Using Client Credentials
______________________________________________________________________
* Task 9: Redo step **Get Data From Datalake Gen 2**. Reference Databricks documentation `Azure Data Lake Storage Gen 2 <https://docs.databricks.com/spark/latest/data-sources/azure/azure-datalake-gen2.html>`_ to access data in datalake directly with client credentials.

**Note: Choose cluster "EDC-Standard-Shared" to run the notebook. Azure Passthrough is not enabled on this cluster.**

Extraction - Read Data From SQL Database using Client Credentials
_________________________________________________________________
* Task 10: Reference `Connect Azure Databricks to SQL Database & Azure SQL Data Warehouse using a Service Principal <https://thedataguy.blog/connect-azure-databricks-to-sql-database-azure-sql-data-warehouse-using-a-service-principal/>`_ to use client credentials to read the table you created in step **Store Data To a SQL Table**.

Loading - Write Data Into SQL Database With Username And Password
_________________________________________________________________
* Task 11: Redo step **Store Data To a SQL Table**. Instead of using service principal **OmniaEDC2019_DatabricksSPN** to connect to SQL database, use the username and password you created in module **Ingest** to connect from databricks to your database.

Loading - Write Data Into Datalake Gen 2 with Azure Passthrough
_______________________________________________________________
* Task 12: Reference Databricks documentation `Authenticate to Azure Data Lake Storage with your Azure Active Directory Credentials <https://docs.azuredatabricks.net/spark/latest/data-sources/azure/adls-passthrough.html>`_ for using Azure Passthrough to write the latest dataframe into file system **dls** in datalake **edc2019dls**. The path is **/user/<your-short-name>/yearly_field_production.csv**.

**Note: Choose cluster "EDC-HighConcurrency-Shared" to run the notebook. Azure Passthrough is enabled on this cluster.**

Conclusion
----------
In this tutorial, we went through different ways to authenticate datalake gen 2 and SQL server. We also did some basic computing upon the dataframe we got. Our focus in this module is to show you how the connections between Azure Databricks and Azure Storage work. Thus, instead of doing computing with python, we put more effort on authentication and connection.  

If you managed to complete all tasks, you should be able to read from / write to datalake / SQL database with different authentication methods listed below:

* Read from datalake gen 2 using Azure Passthrough
* Read from datalake gen 2 using client credentials with/without mounting data
* Read from SQL database using client credentials
* Write to datalake gen 2 using Azure Passthrough
* Write to SQL database using client credentials
* Write to SQL database using username and password

Summary
-------

In the interest of time and simplicity, the following points have been omitted from this tutorial although should / must be considered when building production ready solutions:

* Automation and DevOps
* Create client, store client secret in key vault, set up client permissions
* Source Control (Github)

.. note::

    * Content copied from presentation summary