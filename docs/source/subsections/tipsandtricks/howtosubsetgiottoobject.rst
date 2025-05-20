.. raw:: html

    <script type="text/javascript">
    if (String(window.location).indexOf("readthedocs") !== -1) {
        window.alert('This example has been moved. I will redirect you to the new location.');
        window.location.replace('https://drieslab.github.io/Giotto_website/');
    }
    </script>

.. _ways-of-subsetting:

##################################
How to Subset a Giotto Object?
##################################

There are several ways to subset a Giotto object or visualize a subset of the data. Below are some subsetting examples.

.. note::
	Figures may not be identical, because examples might have been updated, but the subsetting principles remain the same.

********************************
1. The Visium 10X Whole Brain
********************************

.. code-block::

    spatDimPlot(visium_brain, cell_color = 'leiden_clus',
    plot_alignment = 'horizontal', spat_point_size = 2)

.. image:: /images/howtos/subset_giotto/vignette_1/1_whole_brain.png
	:width: 400
	:alt: Visium 10X Whole Brain Image

**********************************
2. Show Only A Subset of Clusters
**********************************

.. code-block::

    spatDimPlot(visium_brain,
            cell_color = 'leiden_clus',  select_cell_groups = '4',
            plot_alignment = 'horizontal', spat_point_size = 2)

.. image:: /images/howtos/subset_giotto/vignette_1/2_whole_brain_clus4.png
			:width: 400
			:alt: Show only a subset of clusters

*********************************************************************
3. Show Only A Subset of Clusters (excluding not selected cells)
*********************************************************************

.. code-block::

	spatDimPlot(visium_brain,
            cell_color = 'leiden_clus',  select_cell_groups = '4', show_other_cells = F,
            plot_alignment = 'horizontal', spat_point_size = 2)

.. image:: /images/howtos/subset_giotto/vignette_1/3_whole_brain_clus4_noOther.png
			:width: 400
			:alt: Excluding not selected cells

*********************************************************************
4. Create Spatial Plots
*********************************************************************
These spatial plots have been grouped by the Leiden Clustering results

.. code-block::

	spatPlot(visium_brain,
         	group_by = 'leiden_clus', group_by_subset = c(1:8),
         	cell_color = 'leiden_clus', cow_n_col = 4,
         	point_size = 1, axis_text = 6, axis_title = 6, legend_text = 6)

.. image:: /images/howtos/subset_giotto/vignette_1/4_whole_brain_by_group_leiden_1.png
			 :width: 400
			 :alt: Leiden group 1


.. code-block::

	spatPlot(visium_brain,
         	group_by = 'leiden_clus', group_by_subset = c(9:16),
         	cell_color = 'leiden_clus', cow_n_col = 4,
         	point_size = 1, axis_text = 6, axis_title = 6, legend_text = 6)


.. image:: /images/howtos/subset_giotto/vignette_1/4_whole_brain_by_group_leiden_2.png
			 :width: 400
			 :alt: Leiden group 2

*********************************************************************
5. Create Dimension Plots
*********************************************************************
These dimension plots have been grouped by the HMRF results.

.. code-block::

	spatDimPlot(visium_brain, cell_color = 'HMRF_k12_b.1',
          	  plot_alignment = 'horizontal', spat_point_size = 2)

.. image:: /images/howtos/subset_giotto/vignette_1/5_whole_brain_HMRF.png
			 :width: 400
			 :alt: HMRF Whole Brain

.. code-block::

	dimPlot(visium_brain,
		group_by = 'HMRF_k12_b.1', group_by_subset = c(1:6),
        		cell_color = 'leiden_clus', cow_n_col = 3,
         	point_size = 1, axis_text = 6, axis_title = 6, legend_text = 6)


.. image:: /images/howtos/subset_giotto/vignette_1/5_whole_brain_by_group_HMRF_1.png
			 :width: 400
			 :alt: HMRF Whole Brain by group 1

.. code-block::

	dimPlot(visium_brain,
       	 	group_by = 'HMRF_k12_b.1', group_by_subset = c(7:14),
        		cell_color = 'leiden_clus', cow_n_col = 3,
        		point_size = 1, axis_text = 6, axis_title = 6, legend_text = 6)


.. image:: /images/howtos/subset_giotto/vignette_1/5_whole_brain_by_group_HMRF_2.png
			 :width: 400
			 :alt: HMRF Whole Brain by group 2

*********************************************************************
6. Create A New Giotto Object By Subsetting Selected Clusters
*********************************************************************

.. code-block::

	metadata = pDataDT(visium_brain)
	subset_cell_IDs = metadata[leiden_clus %in% c(4, 5, 8, 13)]$cell_ID
	visium_brain_small = subsetGiotto(visium_brain, cell_ids = subset_cell_IDs)

	spatDimPlot(visium_brain_small,
           	 cell_color = 'leiden_clus',
          	 plot_alignment = 'horizontal', spat_point_size = 2.5)


.. image:: /images/howtos/subset_giotto/vignette_1/6_subset_brain.png
			 :width: 400
			 :alt: Subsetting selected clusters

.. code-block::

	spatDimPlot(visium_brain_small,
           	 cell_color = 'nr_genes', color_as_factor = F,
            	 plot_alignment = 'horizontal', spat_point_size = 2.5)

.. image:: /images/howtos/subset_giotto/vignette_1/6_subset_brain_nr_genes.png
			 :width: 400
			 :alt: Subset brain nr

************************************************************************************
7. Create A New Giotto Object By Subsetting Spatial Coordinates/Locations
************************************************************************************

.. code-block::

	DG_subset = subsetGiottoLocs(visium_brain,
                             x_max = 6500, x_min = 3000,
                             y_max = -2500, y_min = -5500)

	spatDimPlot(DG_subset,
            	cell_color = 'leiden_clus',
            	plot_alignment = 'horizontal', spat_point_size = 4,
            	save_param = list(save_name = '6_DG_loc_subset', base_height = 4))


.. image:: /images/howtos/subset_giotto/vignette_1/7_DG_loc_subset.png
			 :width: 400
			 :alt: Subset based on spatial coordinates/locations
