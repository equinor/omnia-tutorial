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

Removal
^^^^^^^

Run the **delete-environment.ps1** script to remove the shared runtime 
environment and all common / shared resources.

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
any resources that they have used or created. It will also delete the 
common resource group.

Run the **offboard-edc2019.ps1** script to perform offboarding. Note that 
this does not prompt for any confirmation.

