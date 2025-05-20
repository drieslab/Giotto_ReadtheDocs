.. raw:: html

    <script type="text/javascript">
    if (String(window.location).indexOf("readthedocs") !== -1) {
        window.alert('This example has been moved. I will redirect you to the new location.');
        window.location.replace('https://drieslab.github.io/Giotto_website/');
    }
    </script>

.. _working-with-giotto-images:

#################################################################################
Adding and Working with Images in Giotto: *How to Work with Background Images?*
#################################################################################

All spatial visualization functions in the Giotto toolbox can be overlaid on a background image. This allows you to visualize your results on top of the original tissue image. We provide multiple ways of adding and modifying figures in Giotto.

**There are 3 things to consider:**

.. dropdown:: **1. How to add an image to a Giotto object?**
	:animate: fade-in

	* **createGiottoVisiumObject** can be used directly for a visium 10X dataset
	* **createGiottoImage** can be used to create a Giotto image object from a magick image object
	* **addGiottoImage** this add a Giotto image to your Giotto object
	* **updateGiottoImage** this helps to adjust the alignment of your image with your results


.. dropdown:: **2. How to modify an image (i.e. change the background color)?**
	:animate: fade-in

	* **estimateImageBg** function to estimate the background color of your Giotto or magick image
	* **changeImageBg** function to change the background color of your image
	* **plotGiottoImage** function to plot an image by itself


.. dropdown:: **3. How to show these images with your spatial plots?**
	:animate: fade-in

	* **showGiottoImageNames:** this tells you which giotto image(s) are part of your giotto object
	* Each spatial plotting function has the following 3 parameters:

    	1. show_image = TRUE or FALSE, to show a background image or not
    	2. image_name = name of associated Giotto image to use for the background image (option 1)
    	3. gimage = a giotto image object to use (option 2)

	* **addGiottoImageToSpatPlot** to test your giotto images you can use this function to them to spatPlot result

Here we process the Visium Kidney dataset to illustrate all of the different and flexible ways to deal with images using Giotto:

****************************
1. Create Giotto Object
****************************

Here we use the wrapper function **createGiottoVisiumObject** to create a Giotto object for a 10X Visium dataset, which includes a png image.

.. code-block::

    library(Giotto)

    visium_kidney = createGiottoVisiumObject(visium_dir = '/path/to/Visium_data/Kidney_data',
                                         png_name = 'tissue_lowres_image.png', gene_column_index = 2)

****************************
2. Align Plot
****************************

The image plot and the Giotto results are not always perfectly aligned. This step just needs to be done once.

.. code-block::

    # output from Giotto
    spatPlot(gobject = visium_kidney, cell_color = 'in_tissue', point_alpha = 0.5)

.. image:: /images/howtos/giotto_images/vignette_1/2_a_spatplot.png
	:width: 400
	:alt: 2_a_spatplot.png


.. code-block::

	# problem: image is not perfectly aligned
	spatPlot(gobject = visium_kidney, cell_color = 'in_tissue', show_image = T, point_alpha = 0.5)

.. image:: /images/howtos/giotto_images/vignette_1/2_b_spatplot_image.png
	:width: 400
	:alt: 2_b_spatplot_image.png


Adjust the x and y minima and maxima to align the image and the giotto output results:

Alignment Insights
======================

X and Y Control
=====================

We can use **updateGiottoImage** and **spatPlot** in an iterative manner to see how changing the x and y minima and maxima affect the image.

xmax_adj and xmin_adj: adjust the x location (in data coordinates) giving horizontal location of raster (offset values)
ymax_adj and ymin_adj: adjust the y location (in data coordinates) giving vertical location of raster (offset values)

Without adjustment:
=====================

.. code-block::

	## no adjustment
	visium_kidney = updateGiottoImage(visium_kidney, image_name = 'image',
                               	   xmax_adj = 0, xmin_adj = 0,
                              	    ymax_adj = 0, ymin_adj = 0)

	spatPlot(gobject = visium_kidney, cell_color = 'in_tissue', show_image = T, point_alpha = 0.5)


.. image:: /images/howtos/giotto_images/vignette_1/2_c_spatplot_image_adjusted_1.png
	:width: 400
	:alt: 2_c_spatplot_image_adjusted_1.png

Right Adjustment –> with xmax_adj:
======================================

.. code-block::

	## adjust the image to right side with xmax_adj
	visium_kidney = updateGiottoImage(visium_kidney, image_name = 'image',
          	                        xmax_adj = 1000, xmin_adj = 0,
   		                        ymax_adj = 0, ymin_adj = 0)

	spatPlot(gobject = visium_kidney, cell_color = 'in_tissue', show_image = T, point_alpha = 0.5)


.. image:: /images/howtos/giotto_images/vignette_1/2_c_spatplot_image_adjusted_2.png
	:width: 400
	:alt: 2_c_spatplot_image_adjusted_2.png


Left Adjustment <– with xmin_adj:
====================================
.. code-block::


	## adjust to left side with xmin_adj
	visium_kidney = updateGiottoImage(visium_kidney, image_name = 'image',
        	                          xmax_adj = 0, xmin_adj = 1000,
        	                          ymax_adj = 0, ymin_adj = 0)

	spatPlot(gobject = visium_kidney, cell_color = 'in_tissue', show_image = T, point_alpha = 0.5)

.. image:: /images/howtos/giotto_images/vignette_1/2_c_spatplot_image_adjusted_3.png
	:width: 400
	:alt: 2_c_spatplot_image_adjusted_3.png

Adjustment to the Top with ymax_adj:
=======================================

.. code-block::

	## adjust to top side with ymax_adj
	visium_kidney = updateGiottoImage(visium_kidney, image_name = 'image',
                                  xmax_adj = 0, xmin_adj = 0,
                                  ymax_adj = 1000, ymin_adj = 0)

	spatPlot(gobject = visium_kidney, cell_color = 'in_tissue', show_image = T, point_alpha = 0.5)

.. image:: /images/howtos/giotto_images/vignette_1/2_c_spatplot_image_adjusted_4.png
	:width: 400
	:alt: 2_c_spatplot_image_adjusted_4.png

Adjustment to the bottom with ymin_adj:
==========================================

.. code-block::

	## adjust to bottom side with ymin_adj
	visium_kidney = updateGiottoImage(visium_kidney, image_name = 'image',
                                  xmax_adj = 0, xmin_adj = 0,
                                  ymax_adj = 0, ymin_adj = 1000)

	spatPlot(gobject = visium_kidney, cell_color = 'in_tissue', show_image = T, point_alpha = 0.5)


.. image:: /images/howtos/giotto_images/vignette_1/2_c_spatplot_image_adjusted_5.png
	:width: 400
	:alt: 2_c_spatplot_image_adjusted_5.png

Simulation of shifts
=======================

Create an OK adjustment:
--------------------------

.. code-block::

	## OK alignment
	visium_kidney = updateGiottoImage(visium_kidney, image_name = 'image',
                                  xmax_adj = 1000, xmin_adj = 1000,
                                  ymax_adj = 1000, ymin_adj = 1000)

	patPlot(gobject = visium_kidney, cell_color = 'in_tissue', show_image = T, point_alpha = 0.5)


.. image:: /images/howtos/giotto_images/vignette_1/2_c_spatplot_image_adjusted_6.png
	:width: 400
	:alt: 2_c_spatplot_image_adjusted_6.png

Simulate a right shift and compare with the OK adjustment:
-------------------------------------------------------------

.. code-block::


	## simulate a right shift
	visium_kidney = updateGiottoImage(visium_kidney, image_name = 'image',
                                  xmax_adj = 2000, xmin_adj = 500,
                                  ymax_adj = 1000, ymin_adj = 1000)

	spatPlot(gobject = visium_kidney, cell_color = 'in_tissue', show_image = T, point_alpha = 0.5)

.. image:: /images/howtos/giotto_images/vignette_1/2_c_spatplot_image_adjusted_7.png
	:width: 400
	:alt: 2_c_spatplot_image_adjusted_7.png

Simulate a left shift and compare with the OK adjustment:
-------------------------------------------------------------

.. code-block:


	## simulate a right shift
	visium_kidney = updateGiottoImage(visium_kidney, image_name = 'image',
                                  xmax_adj = 2000, xmin_adj = 500,
                                  ymax_adj = 1000, ymin_adj = 1000)

	spatPlot(gobject = visium_kidney, cell_color = 'in_tissue', show_image = T, point_alpha = 0.5)

.. image:: /images/howtos/giotto_images/vignette_1/2_c_spatplot_image_adjusted_8.png
	:width: 400
	:alt: 2_c_spatplot_image_adjusted_8.png

Simulate a downward shift and compare with the OK adjustment:
--------------------------------------------------------------

.. code-block::


	## simulate a downward shift
	visium_kidney = updateGiottoImage(visium_kidney, image_name = 'image',
                                  xmax_adj = 1000, xmin_adj = 1000,
                                  ymax_adj = 500, ymin_adj = 2000)

	spatPlot(gobject = visium_kidney, cell_color = 'in_tissue', show_image = T, point_alpha = 0.5)

.. image:: /images/howtos/giotto_images/vignette_1/2_c_spatplot_image_adjusted_9.png
	:width: 400
	:alt: 2_c_spatplot_image_adjusted_9.png

Simulate a upward shift and compare with the OK adjustment:
--------------------------------------------------------------

.. code-block::

	## simulate a upward shift
	visium_kidney = updateGiottoImage(visium_kidney, image_name = 'image',
                                  xmax_adj = 1000, xmin_adj = 1000,
                                  ymax_adj = 2000, ymin_adj = 500)

	spatPlot(gobject = visium_kidney, cell_color = 'in_tissue', show_image = T, point_alpha = 0.5)

.. image:: /images/howtos/giotto_images/vignette_1/2_c_spatplot_image_adjusted_10.png
	:width: 400
	:alt: 2_c_spatplot_image_adjusted_10.png

A Good Alignment
=====================

.. code-block::

	# check name
	showGiottoImageNames(visium_kidney)
	visium_kidney = updateGiottoImage(visium_kidney, image_name = 'image',
                            xmax_adj = 1300, xmin_adj = 1200,
                            ymax_adj = 1100, ymin_adj = 1000)

	spatPlot(gobject = visium_kidney, cell_color = 'in_tissue', show_image = T, point_alpha = 0.7)

.. image:: /images/howtos/giotto_images/vignette_1/2_c_spatplot_image_adjusted_11.png
	:width: 400
	:alt: 2_c_spatplot_image_adjusted_11.png

.. code-block::

	# plot original image
	plotGiottoImage(visium_kidney, 'image')

.. image:: /images/howtos/giotto_images/vignette_1/2_d_original_plot.png
	:width: 400
	:alt: 2_d_original_plot.png

*******************************************************
3. Change Background of a Giotto or Magick Image
*******************************************************

Extract the giotto image from your giotto object and then estimate the background of your image:

.. code-block::

	myimage = getGiottoImage(visium_kidney, image_name = 'image') # extract image to modify
	estimateImageBg(mg_object = myimage, top_color_range = 1:20)  # estimate background (bg) color

.. image:: /images/howtos/giotto_images/vignette_1/3_a_background_colors.png
	:width: 400
	:alt: 3_a_background_colors.png

.. code-block::

	## create and test black background
	orig_black_png = changeImageBg(mg_object = myimage, bg_color = '#949594', perc_range = 10, new_color = '#000000', new_name = 'black_bg')

	mypl = spatPlot(gobject = visium_kidney, cell_color = 'in_tissue', return_plot = T, point_alpha = 0.5)
	mypl_image = addGiottoImageToSpatPlot(mypl, orig_black_png)
	mypl_image

.. image:: /images/howtos/giotto_images/vignette_1/3_b_black_background.png
	:width: 400
	:alt: 3_b_black_background.png

.. code-block::

	## create and test white background
	orig_white_png = changeImageBg(mg_object = myimage, bg_color = '#949594', perc_range = 10, new_color = '#FFFFFF', new_name = 'white_bg')

	mypl = spatPlot(gobject = visium_kidney, cell_color = 'in_tissue', return_plot = T, point_alpha = 0.5)
	mypl_image = addGiottoImageToSpatPlot(mypl, orig_white_png)
	mypl_image

.. image:: /images/howtos/giotto_images/vignette_1/3_c_white_background.png
	:width: 400
	:alt: 3_c_white_background.png

*******************************************************
4. Add Image From Scratch
*******************************************************

.. code-block::

	## use magick library to load (and optionally modify) figure ##
	# original image
	png_path = '/your/data/path/Visium_data/Kidney_data/spatial/tissue_lowres_image.png'
	mg_img = magick::image_read(png_path)

Create a negated image
========================

.. code-block::

	# original image negated
	mg_img2 = magick::image_negate(mg_img)
	orig_neg_png = createGiottoImage(gobject = visium_kidney, mg_object = mg_img2, name = 'image_neg',
                                 xmax_adj = 1300, xmin_adj = 1200, ymax_adj = 1100, ymin_adj = 1000)
	mypl_image = addGiottoImageToSpatPlot(mypl, orig_neg_png)
	mypl_image

.. image:: /images/howtos/giotto_images/vignette_1/4_a_external_image_negated.png
	:width: 400
	:alt: 4_a_external_image_negated.png

Create a charcoal image
=========================

.. code-block::

	# charcoal image (black/white)
	mg_img3 = magick::image_charcoal(mg_img, radius = 1)
	mg_img3 = magick::image_convert(mg_img3, colorspace = 'rgb')
	orig_charc_png = createGiottoImage(gobject = visium_kidney, mg_object = mg_img3, name = 'image_charc',
                                   xmax_adj = 1300, xmin_adj = 1200, ymax_adj = 1100, ymin_adj = 1000)
	mypl_image = addGiottoImageToSpatPlot(mypl, orig_charc_png)
	mypl_image

.. image:: /images/howtos/giotto_images/vignette_1/4_b_external_image_charcoal.png
	:width: 400
	:alt: 4_b_external_image_charcoal.png

Add multiple new images to your giotto object
==============================================

.. code-block::

	## add images to Giotto object ##
	image_list = list(orig_white_png, orig_black_png, orig_neg_png, orig_charc_png)
	visium_kidney = addGiottoImage(gobject = visium_kidney,
                               images = image_list)
	showGiottoImageNames(visium_kidney) # shows which Giotto images are attached to you Giotto object

**********************************
5. Example: Kidney Analysis
**********************************

5.1 Processing
===============

.. code-block::


	## subset on spots that were covered by tissue
	metadata = pDataDT(visium_kidney)
	in_tissue_barcodes = metadata[in_tissue == 1]$cell_ID
	visium_kidney = subsetGiotto(visium_kidney, cell_ids = in_tissue_barcodes)

	## filter
	visium_kidney <- filterGiotto(gobject = visium_kidney,
                              expression_threshold = 1,
                              gene_det_in_min_cells = 50,
                              min_det_genes_per_cell = 1000,
                              expression_values = c('raw'),
                              verbose = T)
	## normalize
	visium_kidney <- normalizeGiotto(gobject = visium_kidney, scalefactor = 6000, verbose = T)
	## add gene & cell statistics
	visium_kidney <- addStatistics(gobject = visium_kidney)
	## visualize
	spatPlot(gobject = visium_kidney)

.. image:: /images/howtos/giotto_images/vignette_1/5_1_a_spatial_locations.png
	:width: 400
	:alt: 5_1_a_spatial_locations.png

.. code-block::

	spatPlot(gobject = visium_kidney, cell_color = 'nr_genes', color_as_factor = F)

.. image:: /images/howtos/giotto_images/vignette_1/5_1_b_nr_genes.png
	:width: 400
	:alt: 5_1_b_nr_genes.png

.. code-block::

	# add black background image
	spatPlot(gobject = visium_kidney, show_image = T, image_name = "black_bg",
           	cell_color = 'nr_genes', color_as_factor = F, point_alpha = 0.5)

.. image:: /images/howtos/giotto_images/vignette_1/5_1_c_nr_genes_black_bg.png
			   :width: 400
			   :alt: 5_1_c_nr_genes_black_bg.png

.. code-block::

	## alternative: directly provide a gimage (giotto image object), this will override the the image_name param
	spatPlot(gobject = visium_kidney, show_image = T, gimage = orig_charc_png,
           	cell_color = 'nr_genes', color_as_factor = F, point_alpha = 0.8)

.. image:: /images/howtos/giotto_images/vignette_1/5_1_d_nr_genes_charc_bg.png
			   :width: 400
			   :alt: 5_1_d_nr_genes_charc_bg.png

5.2 Dimension Reduction
===========================

.. code-block::

	## highly variable genes (HVG)
	visium_kidney <- calculateHVG(gobject = visium_kidney, nr_expression_groups = 10)

	## select genes based on HVG and gene statistics, both found in gene metadata
	gene_metadata = fDataDT(visium_kidney)
	featgenes = gene_metadata[hvg == 'yes' & perc_cells > 4 & mean_expr_det > 0.5]$gene_ID

	## run PCA on expression values (default)
	visium_kidney <- runPCA(gobject = visium_kidney, genes_to_use = featgenes)

	## run UMAP and tSNE on PCA space (default)
	visium_kidney <- runUMAP(visium_kidney, dimensions_to_use = 1:10)
	plotUMAP(gobject = visium_kidney)

.. image:: /images/howtos/giotto_images/vignette_1/5_2_a_UMAP_reduction.png
	:width: 400
	:alt: 5_2_a_UMAP_reduction.png

5.3 Cluster
==============

.. code-block::

	## sNN network (default)
	visium_kidney <- createNearestNetwork(gobject = visium_kidney, dimensions_to_use = 1:10, k = 15)
	## Leiden clustering
	visium_kidney <- doLeidenCluster(gobject = visium_kidney, resolution = 0.4, n_iterations = 1000)
	plotUMAP(gobject = visium_kidney,
        	 cell_color = 'leiden_clus', show_NN_network = T, point_size = 2.5)

.. image:: /images/howtos/giotto_images/vignette_1/5_3_a_UMAP_leiden.png
			   :width: 400
			   :alt: 5_3_a_UMAP_leiden.png

5.4 Co-Visualize
=====================

.. code-block::

	# expression and spatial
	showGiottoImageNames(visium_kidney)

	spatDimPlot(gobject = visium_kidney, cell_color = 'leiden_clus',
            show_image = T, image_name = 'black_bg',
            dim_point_size = 2, spat_point_size = 2.5,
            save_param = list(save_name = '7_a_covis_leiden_black'))

.. image:: /images/howtos/giotto_images/vignette_1/5_4_a_covis_leiden_black.png
			   :width: 400
			   :alt: 5_4_a_covis_leiden_black.png

.. code-block::

	spatDimPlot(gobject = visium_kidney, cell_color = 'leiden_clus',
            	show_image = T, image_name = 'image_neg',
            	dim_point_size = 2, spat_point_size = 2.5,
            	save_param = list(save_name = '7_b_covis_leiden_negated'))

.. image:: /images/howtos/giotto_images/vignette_1/5_4_b_covis_leiden_negated.png
				:width: 400
				:alt: 5_4_b_covis_leiden_negated.png

.. code-block::

	spatDimPlot(gobject = visium_kidney, cell_color = 'leiden_clus',
            	show_image = T, image_name = 'image_charc',
            	dim_point_size = 2, spat_point_size = 2.5,
            	save_param = list(save_name = '7_b_covis_leiden_charc'))

.. image:: /images/howtos/giotto_images/vignette_1/5_4_c_covis_leiden_charc.png
			   :width: 400
			   :alt: 5_4_c_covis_leiden_charc.png


5.5 Spatial Gene Plots
=============================

.. code-block::

	## gene plots ##
	spatGenePlot(visium_kidney, show_image = T, image_name = 'image_charc',
             	expression_values = 'scaled', point_size = 2,
             	genes = c('Lrp2', 'Sptssb', 'Slc12a3'),  cow_n_col = 2,
             	cell_color_gradient = c('darkblue', 'white', 'red'), gradient_midpoint = 0, point_alpha = 0.8,
             	save_param = list(save_name = '8_a_spatgene_charc'))

.. image:: /images/howtos/giotto_images/vignette_1/5_5_a_spatgene_charc_vor.png
			   :width: 400
			   :alt: 5_5_a_spatgene_charc_vor.png

.. code-block::

	spatGenePlot(visium_kidney, show_image = T, image_name = 'image_charc',
             	expression_values = 'scaled', point_size = 2, point_shape = 'voronoi',
             	genes = c('Lrp2', 'Sptssb', 'Slc12a3'),  cow_n_col = 2,
             	cell_color_gradient = c('darkblue', 'white', 'red'), gradient_midpoint = 0, vor_alpha = 0.8,
             	save_param = list(save_name = '8_b_spatgene_charc_vor'))

.. image:: /images/howtos/giotto_images/vignette_1/5_5_b_spatgene_charc_vor.png
			   :width: 400
			   :alt: 5_5_b_spatgene_charc_vor.png

5.6 Subset Plots
=====================

.. code-block::

	visium_kidney_subset = subsetGiottoLocs(visium_kidney, x_min = 3000, x_max = 5500, y_min = -10000, y_max = -7000)

	spatGenePlot(visium_kidney_subset, show_image = T, image_name = 'image_charc',
             	expression_values = 'scaled', point_size = 4,
             	genes = c('Lrp2', 'Sptssb', 'Slc12a3'),  cow_n_col = 2,
             	cell_color_gradient = c('darkblue', 'white', 'red'), gradient_midpoint = 0,
             	point_alpha = 0.8,
             	save_param = list(save_name = '9_a_subset_spatgene_charc'))

.. image:: /images/howtos/giotto_images/vignette_1/5_6_a_subset_spatgene_charc.png
				 :width: 400
				 :alt: 5_6_a_subset_spatgene_charc.png

.. code-block::

	spatGenePlot(visium_kidney_subset, show_image = T, image_name = 'image_charc',
             	expression_values = 'scaled', point_size = 4,  point_shape = 'voronoi', vor_alpha = 0.5,
             	genes = c('Lrp2', 'Sptssb', 'Slc12a3'),  cow_n_col = 2,
             	cell_color_gradient = c('darkblue', 'white', 'red'), gradient_midpoint = 0,
             	save_param = list(save_name = '9_b_subset_spatgene_charc_vor'))

.. image:: /images/howtos/giotto_images/vignette_1/5_6_b_subset_spatgene_charc_vor.png
				 :width: 400
				 :alt: 5_6_b_subset_spatgene_charc_vor.png





