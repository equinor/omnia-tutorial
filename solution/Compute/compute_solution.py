# This file contains the solution python code for module Compute

# Task 1:  Reference Databricks documentation Authenticate to Azure Data Lake Storage with your Azure Active Directory Credentials for using Azure Passthrough to load targeted .csv file as dataframe from datalake.
df = spark.read.format('csv').options(
    header='true', inferschema='false').load("abfss://dls@edc2019dls.dfs.core.windows.net/data/open/npd.no/field_production/*.csv")
display(df)

  # or like below:
  df =spark.read.csv("abfss://dls@edc2019dls.dfs.core.windows.net/data/open/npd.no/field_production/*.csv", header='true').collect()
  df = spark.createDataFrame(df)
  display(df)

# Task 5: Get client secret from key vault in databricks.
client_secret = dbutils.secrets.get(scope = "edc_key_vault_scope", key = "DatabricksSpnClientSecret")
	  
# Task 8: Redo step Get Data From Datalake Gen 2. Instead of using Azure Passthrough, reference Databricks documentation Azure Data Lake Storage Gen 2 to mount targeted data to databricks with client credentials.
clientId = 'f0d5bd54-9617-491d-afa1-07c8bd4dc5c1'
# Get client secret of service principal from key vault
clientSecret = dbutils.secrets.get(scope = "edc_key_vault_scope", key = "DatabricksSpnClientSecret")

# only mount once
configs = {"fs.azure.account.auth.type": "OAuth",
       "fs.azure.account.oauth.provider.type": "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider",
       "fs.azure.account.oauth2.client.id": clientId,
       "fs.azure.account.oauth2.client.secret": clientSecret,
       "fs.azure.account.oauth2.client.endpoint": "https://login.microsoftonline.com/3aa4a235-b6e2-48d5-9195-7fcf05b459b0/oauth2/token",
       "fs.azure.createRemoteFileSystemDuringInitialization": "true"}

dbutils.fs.mount(
source = "abfss://dls@edc2019dls.dfs.core.windows.net/data/open/npd.no/field_production/",
mount_point = "/mnt/edc2019",
extra_configs = configs)

df = spark.read.format('csv').options(
    header='true', inferschema='false').load("/mnt/edc2019/*.csv")
display(df)

# Task 9: Redo step Get Data From Datalake Gen 2. Reference Databricks documentation Azure Data Lake Storage Gen 2 to access data in datalake directly with client credentials.
clientId = 'f0d5bd54-9617-491d-afa1-07c8bd4dc5c1'
# Get client secret of service principal from key vault
clientSecret = dbutils.secrets.get(scope = "edc_key_vault_scope", key = "DatabricksSpnClientSecret")

# set up spark session to connect to datalake with client credentials
spark.conf.set("fs.azure.account.auth.type.edc2019dls.dfs.core.windows.net", "OAuth")
spark.conf.set("fs.azure.account.oauth.provider.type.edc2019dls.dfs.core.windows.net", "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider")
spark.conf.set("fs.azure.account.oauth2.client.id.edc2019dls.dfs.core.windows.net", clientId)
spark.conf.set("fs.azure.account.oauth2.client.secret.edc2019dls.dfs.core.windows.net", clientSecret)
spark.conf.set("fs.azure.account.oauth2.client.endpoint.edc2019dls.dfs.core.windows.net", "https://login.microsoftonline.com/3aa4a235-b6e2-48d5-9195-7fcf05b459b0/oauth2/token")

df = spark.read.format('csv').options(
    header='true', inferschema='false').load("abfss://dls@edc2019dls.dfs.core.windows.net/data/open/npd.no/field_production/*.csv")
display(df)

# Task 10: Reference Connect Azure Databricks to SQL Database & Azure SQL Data Warehouse using a Service Principal to use client credentials to read the table you created in step Store Data To a SQL Table.
import adal
authority_host_uri = 'https://login.windows.net'
tenant = '3aa4a235-b6e2-48d5-9195-7fcf05b459b0'
authority_uri = authority_host_uri + '/' + tenant
resource_uri = 'https://database.windows.net/'
client_id = 'f0d5bd54-9617-491d-afa1-07c8bd4dc5c1'
client_secret = dbutils.secrets.get(scope = "edc_key_vault_scope", key = "DatabricksSpnClientSecret")

context = adal.AuthenticationContext(authority_uri, api_version=None)
mgmt_token = context.acquire_token_with_client_credentials(resource_uri, client_id, client_secret)
token = mgmt_token['accessToken']

df = spark.read.format('jdbc').options(
      url="jdbc:sqlserver://<your-sql-server-name>.database.windows.net:1433",
      databaseName="<your-sql-database-name>",
      driver="com.microsoft.sqlserver.jdbc.SQLServerDriver",
      dbtable="dbo.FieldProduction",
      encrypt="true",
      hostNameInCertificate = "*.database.windows.net",
      trustServerCertificate = "false",
      accessToken=token).load()
display(df)

# Task 11: Redo step Store Data To a SQL Table. Instead of using service principal OmniaEDC2019_DatabricksSPN to connect to SQL database, use the username and password you created in module Ingest to connect from databricks to your database.
df_4.write.format('jdbc').options(
      url='jdbc:sqlserver://<your-sql-server-name>.database.windows.net:1433;database=<your-sql-database-name>',
      driver='com.microsoft.sqlserver.jdbc.SQLServerDriver',
      dbtable='dbo.FieldProduction',
      user='<your-sql-server-username>',
      password='<your-sql-server-password>').mode('append').save()

# Task 12: Reference Databricks documentation Authenticate to Azure Data Lake Storage with your Azure Active Directory Credentials for using Azure Passthrough to write the latest dataframe into file system dls in datalake edc2019dls. The path is /user/<your-short-name>/yearly_field_production.csv.
df_4.write.csv("abfss://dls@edc2019dls.dfs.core.windows.net/user/<your-short-name>/yearly_field_production.csv")


























