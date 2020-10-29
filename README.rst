.. image:: https://dev.azure.com/mhew/omnia-tutorial/_apis/build/status/omnia-tutorial?branchName=master
   :target: https://dev.azure.com/mhew/omnia-tutorial/_build/latest?definitionId=10&branchName=master

omnia-tutorial
==============
 **This is an open repo and we encourage all of you to contribute to maintaining and improving this repo.**

This repository contains a hands-on tutorial on using the Omnia Data Platform. 

We will give a general introduction to Omnia concepts whilst walking through 
building the below scenario:

.. image:: presentations/images/architecture-overview.png
    :width: 800px

Contents
--------

#. Introduction - `Presentation <https://mhewstoragev2.z16.web.core.windows.net/introduction/index.html>`__ (`rst <presentations/introduction.rst>`__)
#. Ingestion - `Presentation <https://mhewstoragev2.z16.web.core.windows.net/ingest/index.html>`__ (`rst <presentations/ingest.rst>`__) | `Exercises <exercises/ingest/README.rst>`__
#. Compute - `Presentation <https://mhewstoragev2.z16.web.core.windows.net/compute/index.html>`__ (`rst <presentations/compute.rst>`__) | `Exercises <exercises/compute/README.rst>`__
#. Expose - `Presentation <https://mhewstoragev2.z16.web.core.windows.net/expose/index.html>`__ (`rst <presentations/expose.rst>`__) | `Exercises <exercises/expose/README.rst>`__
#. Consume - `Presentation <https://mhewstoragev2.z16.web.core.windows.net/consume/index.html>`__ (`rst <presentations/consume.rst>`__) | `Exercises <exercises/consume/README.rst>`__
#. End Notes - `Presentation <https://mhewstoragev2.z16.web.core.windows.net/endnotes/index.html>`__ (`rst <presentations/endnotes.rst>`__)

Note that for the exercises, we provide reference implementations for each step that you can use if you have trouble completing prior parts.

Exercise Prerequisites
----------------------

There are **no prerequisites** to run the exercises other than a modern browser. That said, we present alternatives that more closely match how you might otherwise develop for Omnia. In that regard, and especially if you intend to continue developing within Omnia it can be useful to have a developer profile PC with the following free tools installed: 

* `Azure SDK <https://azure.microsoft.com/en-us/downloads/>`__ for the language of your choice.
* `Azure Command Line Interface <https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest>`__ and / or `Powershell Interface <https://docs.microsoft.com/en-us/powershell/azure/>`__
* `Azure Storage Explorer <https://azure.microsoft.com/en-us/features/storage-explorer/>`__
* `GIT <https://git-scm.com/downloads>`__
* `SQL Server Management Studio (SSMS) <https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-2017>`__ and / or `Azure Data Studio <https://docs.microsoft.com/en-us/sql/azure-data-studio/what-is?view=sql-server-2017>`__
* `Visual Studio <https://visualstudio.microsoft.com/vs/>`__ and / or `Visual Studio Code <https://code.visualstudio.com/>`__

You may also want to consider having the following:

* An `Azure DevOps <https://dev.azure.com>`__ organisation.


Getting Help
------------
Please join the ``#omnia`` Slack channel for information, questions and discussion.

Otherwise please see the ``Omnia`` yammer channel.

Contributing
------------
To contribute to this tutorial please submit a pull request (currently master is open for direct commits).

Presentations are generated automatically using an azure devops build pipeline
