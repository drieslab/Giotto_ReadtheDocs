.. raw:: html

    <script type="text/javascript">
    if (String(window.location).indexOf("readthedocs") !== -1) {
        window.alert('This example has been moved. I will redirect you to the new location.');
        window.location.replace('https://drieslab.github.io/Giotto_website/articles/structure.html');
    }
    </script>

.. _giotto-class:

###################################################################################################
Working with the Giotto class: *How to create Giotto object with precomputed results?*
###################################################################################################


********************
1. The Giotto Class
********************
A Giotto object or gobject can be created with **createGiottoObject** or **createGiottoVisiumObject** for Visium datasets.

.. code-block::

    gobject = createGiottoObject()

    gvisiumobject = createGiottoVisiumObject()


**createGiottoVisiumObject** expects a typical Visium 10X data folder structure or a path to the h5 file, but **createGiottoObject** is more flexible and can also accept precomputed results (e.g. PCA, UMAP, network, …)

********************
2. Giotto Slots
********************

2.1 Required Slots
===================
The minimum requirements to make a Giotto class object are:

* Raw_exprs: matrix with raw expression values
* Spatial_locs: spatial coordinates for the cell (or spot) centroids. If this is not provided it will actually create dummy coordinates.

2.2 Additional Matrix Slots
============================

* **norm_expr**: slot to keep matrix with normalized expression values

  * Use expression_values = ‘normalized’ to access this slot in downstream functions

* **norm_scaled_expr**: slot to keep matrix with normalized and scaled expression values

  * Use expression_values = ‘scaled’ to access this slot in downstream functions

* **custom_expr**: slot to keep matrix with custom values

  * Use expression_values = ‘custom’ to access this slot in downstream functions


