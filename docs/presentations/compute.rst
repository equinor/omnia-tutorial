:title: Hands on with Omnia - Compute
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

    hovercraft introduction.rst output/compute

And then view the output/compute/index.html file to see how it turned out.

You separate slides with a line that consists of four or more dashes. The
first slide will start at the first such line, or at the first heading. Since
none of the text so far has been a heading, it means that the first slide has
not yet started. As a result, all this text will be ignored in the generated 
output.

TODO - one slide on the below:


----

Compute Basic
=============

* Polling v's Event Driven
* Elasticity
* Cost

.. note::

   * Polling: batch processing
   * Event Driven: stream processing

   * Elasticity: worker nodes, cores, auto-scaling

   * Cost: Will focus on Databricks cost in later slides

----

Compute Alternatives
====================

* HDInsight: use hive, pig or map reduce jobs
* Apache Kafka: cover both streaming and computing
* Stream Analytics: streaming process, need databricks or event hubs to ingest realtime data
* ...

----

Databricks
===========
* What is Databricks?

----

Databricks
===========
* Databricks Architecture
  (diagram of databricks architecture)

----

Databricks
===========
* Demo: How to create cluster/notebook in Databricks?

----

Exercise Overview
=================

* (high level diagram of data flow)
