Introduction
============
This part of the tutorial covers XXXXX

When writing up, be sure to consider:

* Alternative url's / sources if they didn't complete previous parts


Prerequisites
-------------

Sub section
-----------
asdf
asdf
asdf

Play around with production data from the new REST API in MS Excel
-----------------------------------------------------------------------
This is a very simple example of how to retrive data from the API to play around and do whatever analysis your heart's desire in Excel. You can do a lot of things in Excel as you migth know, and thus you can connect to data sources, import and play around with data in various ways.
This simple walk through will show you how to connect to the exposed REST API just made and fetch production data into a simple table in Excel. We do not take it any further, because once the data is in Excel you have tons of possibilitites of data analysis, massaging, visualization and so on, and that part you probably know better than us.

We will do this visually by clicking around in the user interface, but of course you can also program this in an Excel module later if you like.



* Open MS Excel 

* Create a new file, an empty workbook
.. image:: ./images/consume/new_workbook.jpg 

* Add the REST API as a data source. NOTE: Use your own API URL if you finished creating one. Otherwise you can use this URL as a fallback that will work -> https://edc2019-jonatpapp.azurewebsites.net/production-data/between-dates?fromYear=2010&toYear=2015&fromMonth=1&toMonth=12 
Net production data from January to December 2010 to 2015.
Here the entire API is explained here: https://edc2019-jonatpapp.azurewebsites.net/swagger/index.html

.. image:: ./images/consume/add_data_source.jpg

Add service call here:
.. image:: ./images/consume/add_data_source_url.jpg

The data has been retrieved now in JSON and are listed as records. Convert them to a table. Use default conversion settings and click OK.
.. image:: ./images/consume/convert_data_to_table.jpg

.. image:: ./images/consume/convert_data_to_table_ok.jpg

Expand the JSON records to Excel table columns.
.. image:: ./images/consume/convert_data_to_table_expand.jpg

Use all the default of all columns and click OK.
.. image:: ./images/consume/convert_data_to_table_expand_ok.jpg

Close the data source setup and load data into Excel.
.. image:: ./images/consume/convert_data_to_table_expand_close_and_load.jpg

Finished result. Now all the data returned form the service is in an Excel table ready to be played with. Remember to save. The data connection is also saved for you to reuse/refresh later.
.. image:: ./images/consume/save_result.jpg



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
