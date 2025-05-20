.. raw:: html

    <script type="text/javascript">
    if (String(window.location).indexOf("readthedocs") !== -1) {
        window.alert('This example has been moved. I will redirect you to the new location.');
        window.location.replace('https://drieslab.github.io/Giotto_website/');
    }
    </script>

.. _detailed_workflow:

##########################
Giotto Suite Workflow
##########################

.. card-carousel:: 1

      .. card:: Input
         :text-align: center

         .. image:: ../images/detailed_workflow/giotto_ip.png
            :width: 200

      .. card:: Data Structure
         :text-align: center

         .. image:: ../images/detailed_workflow/giotto_ds.png
            :width: 300

      .. card:: Analysis
         :text-align: center

         .. image:: ../images/detailed_workflow/giotto_analysis.png
            :width: 300

      .. card:: Visualization
         :text-align: center

         .. image:: ../images/detailed_workflow/giotto_viz.png
            :width: 200

Input
==========
The input to giotto can be spatial data such as array-based(10X Visium), single-cell etc., It also has capabilities to store image data and polygon information.

Data Structure
====================
The giotto object has several slots that incorporates metadata, shape data containing the cellular shape polygonal data and network data amongst others. Images can also be stored optimized for memory usage.

Analysis
=============
Users can perform analyses such as single cell filtering and normalization, spatial data analysis with overlaying single cell information to name a few.

Visualizations
==================
Giotto has capabilties that can help user to interatively explore the spatial information, multidimensional and multimodality visualizations and custom saving options producing high quality publishable figures
