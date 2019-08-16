:title: Introduction to Omnia
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

This slide show is written in rst and designed to be generated as an HTML site using 
Hovercraft_. See `README.rst <..\..\README.rst>`__ for details on where you can view
an automatically generated version.

You can render this presentation to HTML with the command::

    hovercraft introduction.rst output

And then view the output/index.html file to see how it turned out.

You separate slides with a line that consists of four or more dashes. The
first slide will start at the first such line, or at the first heading. Since
none of the text so far has been a heading, it means that the first slide has
not yet started. As a result, all this text will be ignored in the generated output.

----

Goal and Purpose (expectations)
==========================================

asdf

----

What is Omnia (and why?)
==========================================

asdf

----

Service Offerings - Omnia Applications (v's workshop) - subscription / resource group
=============================================================================================

asdf

----

Tutorial scenario (+ alternatives / limitations)
===============================================================

asdf

----

This is a first slide
=====================

Restructured text takes any line that is underlined with punctuation and
makes it into a heading. Each type of underlining will be made into a different
level of heading, but it is not the type that is important, but rather the
order of which each type will be enountered.

So in this presentation, lines underlined with equal (=) characters will be
made into a first-level (H1) heading.

----

First header
============

You can choose other punctuation characters as your level 1 heading if you like,
but this is the most common. Any if these character works::

    = - ` : ' " ~ ^ _ * + # < > .

Second header
-------------

Third header
............

The drawback with reStructuredText is that you can't skip levels. You can't
go directly from level 1 to level 3 without having a level 2 in between.
If you do you get an error::

    Title level inconsistent

----

Other formatting
================

All the normal reStructuredText functions are supported in Hovercraft!

- Such as bulletlists, which start with a dash (-) or an asterisk (*).
  You can have many lines of text in one bullet if you indent the
  following lines.

   - And you can have many levels of bullets.

       - Like this.

- There is *Emphasis* and **strong emphasis**, rendered as <em> and <strong>.

----

More formatting
===============

#. Numbered lists are of course also supported.

#. They are automatically numbered.

#. But only for single-level lists and single rows of text.

#. ``inline literals``, rendered as <tt> and usually shown with a monospace font, which is good for source code.

#. Hyperlinks, like Python_

.. _Python: http://www.python.org


----

Images
======

You can insert an image with the .. image:: directive:

.. image:: images/hovercraft_logo.png

And you can optionally set width and height:

.. image:: images/hovercraft_logo.png
    :width: 50px
    :height: 130px

Some people like to have slideshows containing only illustrative images. This
works fine with Hovercraft! as well, as you can see on the next slide.

----

.. image:: images/hovercraft_logo.png

----

Slides can have presenter notes!
================================

This is the killer-feature of Hovercraft! as very few other tools like this
support a presenter console. You add presenter notes in the slide like this:

.. note::

    And then you indent the text afterwards. You can have a lot of formatting
    in the presenter notes, like *emphasis* and **strong** emphasis.

    - Even bullet lists!

    - Which can be handy!

    But you can't have any headings.


----

Source code
===========

You can also have text that is mono spaced, for source code and similar.
There are several syntaxes for that. For code that is a part of a sentence
you use the inline syntax with ``double backticks`` we saw earlier.

If you want a whole block of preformatted text you can use double colons::

    And then you
    need to indent the block
    of text that
    should be preformatted

You can even have the double colons on a line by themselves:

::

    And this text will
    now be
    rendered as
    preformatted text

----

Syntax highlighting
===================

But the more interesting syntax for preformatted text is the .. code::
directive. This enables you to syntax highlight the code.

.. code:: python

    def day_of_year(month, day):
        return (month - 1) * 30 + day_of_month

    def day_of_week(day):
        return ((day - 1) % 10) + 1

    def weekno(month, day):
        return ((day_of_year(month, day) - 1) // 10) + 1

----

More code features
==================

The syntax highlighting is done via docutils by a module called Pygments_
which support all popular languages, and a lot of unpopular ones as well.

The coloring is done by CSS, if you want to change it, copy the CSS in
the highlight.css file and override it in your custom CSS.

.. _Pygments: http://pygments.org/

----

Testing the code
================

If you are including Python-code, then Manuel_ 1.7.0 and later can test the
code for you. This enables you to have code in your presentation and make
sure it works.

To do this properly you sometimes want setup and teardown code, code that
should be executed as a part of the test, but not shown in the presentation.

To do that, you can simply set a class on the code block.

.. code:: python
    :class: hidden

    from datetime import datetime

Add the hidden class in your css:

.. code:: css

    pre.hidden {
        display: none;
    }

----

And your visible code will now be runnable with Manuel:

.. code:: python

   >>> datetime(2013, 2, 19, 12)
   datetime.datetime(2013, 2, 19, 12, 0)

.. _Manuel: https://pypi.python.org/pypi/manuel

----

Render mathematics!
===================

Mathematical formulas can be rendered with Mathjax!

.. math::

    e^{i \pi} + 1 = 0

    dS = \frac{dQ}{T}

And inline: :math:`S = k \log W`

.. _Mathjax: https://www.mathjax.org/

----



That's all folks!
=================

That finishes the basic tutorial for Hovercraft! Next you probably want to
take a look at the positioning tutorial, so you can use the pan, rotate and
zoom functionality.