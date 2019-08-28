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

Goal and Purpose (expectations)
==========================================

* Goal
* Purpose
* Outcome
* What not covering
* Signup (username)

.. note::

    * Allowed to leave if not suitable.
    * Signup / provisioning.
    * high level introduction to set context, we will dig into the details more as we go along. 
    
----

What is Omnia (and why?)
==========================================

* Equinors cloud journey
* Enabled by certain technology platforms
* Pillars include:
    * Sharing
    * Responsibility
    * Process
    
Omnia home: https://omniahomewa.azurewebsites.net/
Omnia docs: https://docs.omnia.equinor.com/

.. note::

    * Conceptual idea
    * How to handle signup / provisioning.
    * Pillars
        * Sharing - move from silos to common platform. 
        * Responsibility - more possibilities, but requires more responsibility. (e.g. complience with data architecture, API strategy, cost, ...).
        * Process - devops, infra as code, cloud first mindset, EDM
    * Show Omnia home, what is Omnia, 

----

Omnia as an Environment
=======================

Runtime environment

Data platform

Omnia Applications (v's workshop) - subscription / resource group

.. note::

    * When does data become a part of the data platform.

----

Tutorial scenario (+ alternatives / limitations)
===============================================================

NPD - show data, architecture diagram (and plots?)

https://www.npd.no/en/facts/news/Production-figures/

https://www.npd.no/en/facts/news/Production-figures/2019/production-figures-july-2019/

----

Working with Azure
==================

Portal, CLI, ARM, DevOps, ...
