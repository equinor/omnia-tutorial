:title: Hands on with Omnia - Introduction
:author: Omnia Team
:description: Hands on tutorial with Omnia.
:keywords: omnia, tutorial
:css: main.css

.. header::

    .. image:: images/omnia_icon_black.png
        :width: 100px
        :height: 100px

.. footer::

   Hands on with Omnia, https://github.com/equinor/omnia-tutorial

.. _Hovercraft: http://www.python.org/https://hovercraft.readthedocs.io/

This slide show is written in rst and designed to be generated as an HTML site
using Hovercraft_. See `README.rst <..\..\README.rst>`__ for details on where 
you can view an automatically generated version.

You can render this presentation to HTML with the command::

    hovercraft introduction.rst output/introduction

And then view the output/introduction/index.html file to see how it turned out.

You separate slides with a line that consists of four or more dashes. The
first slide will start at the first such line, or at the first heading. Since
none of the text so far has been a heading, it means that the first slide has
not yet started. As a result, all this text will be ignored in the generated 
output.

----

Introduction
============

* A hands on introduction with Omnia
* What we are not covering
* Signup

.. note::
    | P - A hands on introduction with Omnia
    | O - A better understanding of Omnia
    | W - Better equiped to develop within Equinor's new IT platform
    | E - Who has worked with Omnia? What expectations do people have?
    | R - ?
    
    How: A mixture of presentations and tutorial. We will use Azure docs extensively as they need to know how to navigate these pages.

    What we are not covering

    * You will not be an expert after 1 day
    * Every possible scenario - but we will touch on alternatives
    * All the details - this is a high level introduction to set context, we will dig into the details more as we go along. 

    Other 

    * Allowed to leave if not suitable.
    * Signup / provisioning.
    
----

What is Omnia (and why?)
========================

* Equinors cloud journey
* Enabled by certain technology platforms
* Pillars include

  * Sharing
  * Responsibility
  * Process
    
Omnia home: https://omniahomewa.azurewebsites.net/
Omnia docs: https://docs.omnia.equinor.com/

.. note::

    * Conceptual idea backed by Azure + ...    
    * Pillars

      * Sharing - move from silos to common platform. 
      * Responsibility - more possibilities, but requires more responsibility. (e.g. complience with data architecture, API strategy, cost, ...).
      * Process - devops, infra as code, cloud first mindset, EDM

    * Show Omnia home, what is Omnia, 

----

Omnia as an Environment
=======================

Runtime environment + Compute + Storage

.. image:: images/introduction/environment.png

.. note::

    * Runtime - The basic products (subscription, resourcegroup, networking). Show https://docs.omnia.equinor.com/

      * Omnia classic
      * Omnia applications
      * Standalone

    * Compute + Storage will come back to as part of the tutorial.
    * When does data become a part of the data platform. Will come back to later also.
    * Omnia Applications (v's workshop) - subscription / resource group

    Image is from slide deck at: https://omniahomewa.azurewebsites.net/

----

Tutorial scenario
=================

.. image:: images/introduction/NPD.png

https://www.npd.no/en/facts/news/Production-figures/
http://factpages.npd.no/factpages/Default.aspx?culture=en


.. note::

    * NPD holds open data on production from different fields.
    * Create a pipeline to make the data available through Omnia

----

What we Will Build
==================

TODO - Add architecture diagram

.. note::

    * Details on choices for each part and omissions are covered as we go.

----

Working with Azure
==================

.. image:: images/introduction/portal.jpg

.. note::

    * Portal, CLI, Power Shell, Cloud Shell, SDK, ARM templates, DevOps ...
    * For this tutorial everything can be done through the portal. Where
      possible we will describe and give alternative options that might more
      closely reflect how you would develop in practice.
