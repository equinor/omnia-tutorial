.. image:: https://dev.azure.com/mhew/omnia-tutorial/_apis/build/status/omnia-tutorial?branchName=master
   :target: https://dev.azure.com/mhew/omnia-tutorial/_build/latest?definitionId=10&branchName=master

omnia-tutorial
==============

This repository contains a hands-on tutorial on using the Omnia Data Platform.
We will give a general introduction to Omnia concepts whilst walking through 
building the below scenario:

TODO: Architecture diagram goes here

Contents
--------

#. Introduction (`Presentation <https://mhewstoragev2.z16.web.core.windows.net/introduction/index.html>`__ (`rst </docs/presentations/introduction.rst>`__) | `Exercises </docs/exercises/introduction.rst>`__)
#. Ingestion (`Presentation <https://mhewstoragev2.z16.web.core.windows.net/ingest/index.html>`__ (`rst </docs/presentations/ingest.rst>`__) | `Exercises </docs/exercises/ingestion.rst>`__)
#. Compute (`Presentation <https://mhewstoragev2.z16.web.core.windows.net/compute/index.html>`__ (`rst </docs/presentations/compute.rst>`__) | `Exercises </docs/exercises/compute.rst>`__)
#. Expose (`Presentation <https://mhewstoragev2.z16.web.core.windows.net/expose/index.html>`__ (`rst </docs/presentations/expose.rst>`__) | `Exercises </docs/exercises/expose.rst>`__)
#. Consume (`Presentation <https://mhewstoragev2.z16.web.core.windows.net/consume/index.html>`__ (`rst </docs/presentations/consume.rst>`__) | `Exercises </docs/exercises/consume.rst>`__)

Note that for the exercises, we provide reference implementations for each step that you can use if you have trouble completing prior parts.

Exercise Prerequisites
----------------------

There are **no prerequisites** to run the exercises other than a modern browser. That said, we present alternatives that more closely match how you might otherwise develop for Omnia. In that regard it can be useful to have a developer profile PC with the following free tools installed: 

* `Azure SDK <https://azure.microsoft.com/en-us/downloads/>`__ for the language of your choice.
* `Azure Command Line Interface <https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest>`__ and / or `Powershell Interface <https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest>`__
* `Azure Storage Explorer <https://azure.microsoft.com/en-us/features/storage-explorer/>`__
* `GIT <https://git-scm.com/downloads>`__
* `SQL Server Management Studio (SSMS) <https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-2017>`__
* `Visual Studio <https://visualstudio.microsoft.com/vs/>`__ and / or `Visual Studio Code <https://code.visualstudio.com/>`__

You may also want to consider having the following:

* An `Azure DevOps <https://dev.azure.com>`__ organisation.


Getting Help
------------
For the EDC 2019 conference, please join the ``#edc2019-omnia`` Slack channel for information, questions and discussion.

Otherwise please see the ``Omnia`` yammer channel.

Contributing
------------
To contribute to this tutorial please submit a pull request (currently master is open for direct commits).

Presentations are generate automatically using an azure devops build pipeline
