.. raw:: html

    <script type="text/javascript">
    if (String(window.location).indexOf("readthedocs") !== -1) {
        window.alert('This example has been moved. I will redirect you to the new location.');
        window.location.replace('https://drieslab.github.io/Giotto_website/articles/interactive_selection.html');
    }
    </script>

=========================
Interactive selection
=========================

:Date: 2022-11-17

Set up Giotto object
=========================

NOTE: To follow this tutorial, you must pre-run the Parts 1-4 from the `Mouse Visium Brain tutorial <https://giottosuite.readthedocs.io/en/latest/subsections/datasets/mouse_visium_brain.html>`__

You can use as input either a ggplot2 object, a terra::rast image, or the output of running the spatPlot2D( ) function.

.. container:: cell

   .. code:: r

      # Ensure Giotto Suite is installed.
      if(!'Giotto' %in% installed.packages()) {
        devtools::install_github('drieslab/Giotto@suite')
      }

      # Ensure GiottoData, a small, helper module for tutorials, is installed.
      if(!'GiottoData' %in% installed.packages()) {
        devtools::install_github('drieslab/GiottoData')
      }
      library(Giotto)
      # Ensure the Python environment for Giotto has been installed.
      genv_exists = checkGiottoEnvironment()
      if(!genv_exists){
        # The following command need only be run once to install the Giotto environment.
        installGiottoEnvironment()
      }

Part 1: Create a Giotto spatPlot object
=================================================

When creating the spatPlot2D object, you can only plot the spatial cells/spots or show the tissue image in the background.

If you plan to select individual clusters or cell types, we recommend coloring the cells/spots using the cell_color argument.

.. container:: cell

   .. code:: r

      ## Plot spatial cells/spots
      my_spatPlot <- spatPlot2D(gobject = visium_brain,
                                cell_color = 'leiden_clus',
                                point_size = 1.5,
                                point_alpha = 0.5,
                                show_image = FALSE)

      ## Plot spatial cells/spots with tissue on the background
      my_spatPlot <- spatPlot2D(gobject = visium_brain,
                                point_size = 1.5,
                                point_alpha = 0.1,
                                show_image = TRUE)

Part 2: Run the interactive selection tool
====================================

plotInteractivePolygons( ) will run a ShinyApp gadget within your RStudio session. Use your cursor to draw the area of interest and add a name. You can draw as many regions as you wish.

.. container:: cell

   .. code:: r

      ## Run the Shiny app with default parameters
      plotInteractivePolygons(my_spatPlot)

.. image:: /images/images_pkgdown/interactive_selection/vignette_221013/1-interactive_brain_spots.png
   :width: 50.0%

.. container:: cell

   .. code:: r

      ## Run the Shiny app using the tissue image
      plotInteractivePolygons(my_spatPlot)

.. image:: /images/images_pkgdown/interactive_selection/vignette_221013/2-interactive_brain_tissue.png
   :width: 50.0%

You can use additional parameters passed to the polygon( ) function, such as the line thickness and color of the polygons.

.. container:: cell

   .. code:: r

      ## Modify the width and/or color of the line
      plotInteractivePolygons(my_spatPlot,
                              color = 'black',
                              lwd = 2)

.. image:: /images/images_pkgdown/interactive_selection/vignette_221013/3-interactive_brain_black.png
   :width: 50.0%

.. container:: cell

   .. code:: r

      ## Modify the width or heigh of the plotted image
      plotInteractivePolygons(my_spatPlot,
                              height = 500)

.. image:: /images/images_pkgdown/interactive_selection/vignette_221013/4-interactive_brain_height.png
   :width: 50.0%

Use the slider bars to zoom in or out your plot and draw tiny polygons.

.. container:: cell

   .. code:: r

      ## Use the zoom in and out slide-bars to select small areas
      plotInteractivePolygons(my_spatPlot,
                              height = 320)

.. image:: /images/images_pkgdown/interactive_selection/vignette_221013/5-interactive_brain_zoom.png
   :width: 50.0%

Part 3: Save the coordinates
===========================

Click on the button *Done* once you have finished selecting the areas of interest.

By default, plotInteractivePolygons will print the polygon x and y coordinates as a ‘data.table’ object on the Console panel, but you can store the output using the assignment operator.


.. container:: cell

   .. code:: r

      ## The polygon coordinates will be saved on my_polygon_coordinates as a data.table object
      my_polygon_coordinates <- plotInteractivePolygons(my_spatPlot,
                                                        height = 320)

.. image:: /images/images_pkgdown/interactive_selection/vignette_221013/6-my_polygon_coordinates.png
   :width: 30.0%


Now, let's add the polygon coordinates to the Giotto object:

.. container:: cell

   .. code:: r

      ## We must transform the data.table or data.frame with coordinates into a Giotto polygon object
      my_giotto_polygons <- createGiottoPolygonsFromDfr(my_polygon_coordinates, name = 'selections')

      ## Then, add the polygons to the Giotto object
      visium_brain <- addGiottoPolygons(gobject = visium_brain,
                                        gpolygons = list(my_giotto_polygons))

Finally, add the corresponding polygon ID to the cell Metadata. By default, the function will add a 'no_polygon' label to cells outside polygons, but you can customize it using the na.label argument.

.. container:: cell

   .. code:: r

      ## Using the default parameters
      visium_brain <- addPolygonCells(visium_brain,
                                      polygon_name = 'selections')

      ## Let's see how it looks like now the cell_metadata
      pDataDT(visium_brain)

.. image:: /images/images_pkgdown/interactive_selection/vignette_221013/7-new_metadata.png
   :width: 80.0%

.. container:: cell

   .. code:: r

      ## Customize the NA label
      visium_brain <- addPolygonCells(visium_brain,
                                      polygon_name = 'selections',
                                      na.label = 'No Polygon')

.. image:: /images/images_pkgdown/interactive_selection/vignette_221013/8-new_metadata_customized.png
   :width: 80.0%

Part 4: Get the cells located within each polygon
===========================

You can extract the coordinates and IDs from cells located within one or multiple regions of interest.

.. container:: cell

   .. code:: r

      ## Provide the name of the polygon to extract cells from
      getCellsFromPolygon(visium_brain,
                          polygon_name = 'selections',
                          polygons = 'polygon 1')

.. image:: /images/images_pkgdown/interactive_selection/vignette_221013/9-get_cells_polygon_1.png
   :width: 55.0%

.. container:: cell

   .. code:: r

      ## If no polygon name is provided, the function will retrieve cells located within all polygons
      getCellsFromPolygon(visium_brain,
                          polygon_name = 'selections')

.. image:: /images/images_pkgdown/interactive_selection/vignette_221013/10-get_cells.png
   :width: 55.0%

Part 5: Compare gene expression
===========================

Let's compare the expression levels of some genes of interest between the selected regions.

.. container:: cell

   .. code:: r

      ## You can provide a list of genes
      comparePolygonExpression(visium_brain,
                               selected_feats = c('Stmn1', 'Psd', 'Ly6h'))


.. image:: /images/images_pkgdown/interactive_selection/vignette_221013/11-compare_genes.png
   :width: 50.0%

.. container:: cell

   .. code:: r

      ## Or calculate the top genes expressed within each region, then provide the result to compare polygons.
      scran_results <- findMarkers_one_vs_all(visium_brain,
                                              spat_unit = 'cell',
                                              feat_type = 'rna',
                                              method = 'scran',
                                              expression_values = 'normalized',
                                              cluster_column = 'selections',
                                              min_feats = 10)

      top_genes <- scran_results[, head(.SD, 2), by = 'cluster']$feats

      comparePolygonExpression(visium_brain,
                               selected_feats = top_genes)


.. image:: /images/images_pkgdown/interactive_selection/vignette_221013/12-compare_topgenes.png
   :width: 50.0%

Part 6: Compare cell type abundance
===========================

If you have run an analysis for finding clusters or have anotated cell types within the cell metadata slot, you can use the column name to compare the abundance of cell types between the selected regions.

.. container:: cell

   .. code:: r

      ## By default, the function will look for the leiden_cluster
      compareCellAbundance(visium_brain)

      ## You can use other columns within the cell metadata table to compare the cell type abundances
      compareCellAbundance(visium_brain, cell_type_column = 'cell_type')

.. image:: /images/images_pkgdown/interactive_selection/vignette_221013/13-compare_cell_abundance.png
   :width: 50.0%


Part 7: Create a spatPlot per region
===========================

You can use the spatPlot( ) arguments to isolate and plot each region. Also, you can color each cell by cluster, cell type or expression level.

.. container:: cell

   .. code:: r

      ## Compare clusters within each region
      spatPlot2D(visium_brain,
                 cell_color = 'leiden_clus',
                 group_by = 'selections',
                 point_size = 1,
                 coord_fix_ratio = 1,
                 cow_n_col = 3,
                 show_legend = FALSE)

.. image:: /images/images_pkgdown/interactive_selection/vignette_221013/14-compare_spatplots.png
   :width: 80.0%

.. container:: cell

   .. code:: r

      ## Compare expression levels between regions
      spatFeatPlot2D(visium_brain,
                     expression_values = 'scaled',
                     group_by = 'selections',
                     feats = 'Psd',
                     point_size = 1)

.. image:: /images/images_pkgdown/interactive_selection/vignette_221013/15-compare_spatfeatplot.png
   :width: 80.0%

Part 8: Plot again the polygons
===========================

You can plot again all or some drawn polygons. The minimal input is the Giotto object containing polygon coordinates within the spatial_info slot, as well as the spatial plot.

.. container:: cell

   .. code:: r

      ## Plot all polygons
      plotPolygons(visium_brain,
                   polygon_name = 'selections',
                   x = my_spatPlot)

.. image:: /images/images_pkgdown/interactive_selection/vignette_221013/16-plotPolygons.png
   :width: 50.0%

Additionaly, you can plot a few polygons by providing a vector with the polygon IDs.

.. container:: cell

   .. code:: r

      ## Plot a subset of polygons
      plotPolygons(visium_brain,
                   polygon_name = 'selections',
                   x = my_spatPlot,
                   polygons = 'polygon 2')

.. image:: /images/images_pkgdown/interactive_selection/vignette_221013/17-plotPolygon2.png
   :width: 50.0%
