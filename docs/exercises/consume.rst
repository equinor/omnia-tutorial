Consuming Data Through API's
============================
This part of the tutorial covers how you might consume data from an API hosted
in Omnia (or elsewhere). You might want this data to include in an application
as part of a visualisation, for furthar analytics and more. As discussed in 
the `expose exercises <expose.rst>`_ API's are the preferred way to expose 
data within Equinor.

There are many possibilities when consuming API's. We cover a number of 
these including Microsoft Excel, Power BI and using python code. You are free 
to try whatever of these options you like.

Prerequisites
-------------

You can select which of the options you want to try so only need the
tools for those parts. More details follow in the different sections.

, however if 
using Power BI then you will need `this installed <https://powerbi.microsoft.com/en-us/downloads/>`__
(note use the advanced download options for direct download to avoid 
installing through Microsoft Store).

Using Microsoft Excel
---------------------
Excel is one of the most widely used tools in Equinor and installed by default
on every computer. You can do a lot of things in Excel including connecting to
data sources, and importing and playing around with data in various ways. 

This simple walk through will show you how to connect to the exposed REST API
made in the previous part to fetch production data into a simple table in Excel. 

We do not take it any further, because once the data is in Excel you have tons
of possibilitites for data analysis, massaging, visualization and so on, and 
that part you probably know better than us.

We will do this visually by clicking around in the user interface, but of 
course you can also program this in an Excel module later if you like.

* Open MS Excel 

* Create a new file, an empty workbook

.. image:: ./images/consume/new_workbook.jpg 

* Add the REST API as a data source.
 
 .. image:: ./images/consume/add_data_source.jpg

* You should enter the URL of your API created in the previous step.

  Note: If you did not complete the previous part then you may use this that
  of the completed scenario: 
  
  https://edc2019-common.azurewebsites.net/production-data/between-dates?fromYear=2010&toYear=2015&fromMonth=1&toMonth=12

  It will retrieve production data from January to December 2010 to 2015. 

  The entire API is explained here in the `Swagger API definition <https://edc2019-common.azurewebsites.net/swagger/index.html>`_.

.. image:: ./images/consume/add_data_source_url.jpg

* When prompted we will connect anonymously. Other options are provided for 
  connecting with secured services.

.. image:: ./images/consume/add_data_source_anonymous_ok.jpg

* The data has been retrieved now in JSON and are listed as records. 
  Convert them to a table. Use default conversion settings and click OK

.. image:: ./images/consume/convert_data_to_table.jpg

.. image:: ./images/consume/convert_data_to_table_ok.jpg

* Expand the JSON records to Excel table columns

.. image:: ./images/consume/convert_data_to_table_expand.jpg

* Use the default of all columns and click OK

.. image:: ./images/consume/convert_data_to_table_expand_ok.jpg

* Close the data source setup and load data into Excel

.. image:: ./images/consume/convert_data_to_table_expand_close_and_load.jpg

There we are, finished. All the data returned from the servcie is now in an
Excel table ready to be played with. 
  
Remember to save your workbook. 

The API data connection is also saved for you to reuse/refresh later. To 
refresh the data use the refresh button under the Data menu. Under the 
Data menu you will also find options for modifying the query and connection
if needed.

.. image:: ./images/consume/save_result.jpg


Consuming an API from Python
----------------------------

Most programming languages provide easy support for consuming API's and Python
is no exception. We will use the pandas library to collect the json format 
data from our API and matplotlib to create a simple plot of the results.

As in the compute exercise we will use DataBricks as our runtime environment, 
although you can run the same code locally if you have python setup, in 
`Azure notebooks <https://notebooks.azure.com/>`_ or any other python 
environment.

* As in the `compute <compute.rst>`_ section create a new notebook within your
  workspace named *consume-from-api*

* In the first cell add the following code to query the API: 

   | import pandas as pd
   | 
   | # specify the url - swap the below (solution url) with your custom one 
     from the expose exercise.
   | api_url = 'https://edc2019-common.azurewebsites.net/production-data/between-dates?fromYear=2010&toYear=2015&fromMonth=1&toMonth=12'
   | 
   | # Call the api and use pandas to convert the returned json into a 
     dataframe
   | df_production_data = pd.read_json(api_url)

* Create a new cell with the following code to display a summary of the 
  returned data: 

    | df_production_data.head(10)

* Attach a cluster to run the notebook as shown below and then chose 
  *Run All*.

  .. image:: ./images/consume/python-attach-cluster.png

  You should see that the notebook is run and data submitted.

A completed notebook is provided at https://github.com/equinor/omnia-tutorial/blob/master/solution/consume/consume-from-api.ipynb.
This notebook can be viewed online in github or imported directly into DataBricks.

Consuming an API from PowerBI
-----------------------------


What we Didn't Cover
--------------------

There are several points that we haven't covered in the interest of time:

* *Other tools* - there are many other tools that can also be used.
* *Authorisation & Authentication* - for simplicity this exercise used an 
  open API with no security. In real world scenarios it is highly likely 
  that you will need to ensure API's are secured.
* *Deployment & Sharing* - once you have a solution created that consumes data
  from an API you might want to operationalise and share it somehow.
* *Legal aspects* - if you modify and combine data, you may be changing the 
  security classification and so need to consider possible implications
