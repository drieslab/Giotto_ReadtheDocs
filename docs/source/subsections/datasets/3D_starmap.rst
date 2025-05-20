.. raw:: html

    <script type="text/javascript">
    if (String(window.location).indexOf("readthedocs") !== -1) {
        window.alert('This example has been moved. I will redirect you to the new location.');
        window.location.replace('https://drieslab.github.io/Giotto_website/articles/starmap_mouse_cortex.html');
    }
    </script>

==========
3D Starmap
==========

:Date: 2023-04-14

Start Giotto
============

To run the current vignette you need to install the Giotto Suite branch and the GiottoData package.

.. container:: cell

   .. code:: r

      # Ensure Giotto Suite is installed.
      if(!"Giotto" %in% installed.packages()) {
        remotes::install_github("drieslab/Giotto@suite")
      }

      library(Giotto)

      remotes::install_github("drieslab/GiottoData")
      library(GiottoData)

Create Giotto object
====================

Minimum requirements:

1. Matrix with expression information (or path to)
2. x,y(,z) coordinates for cells or spots (or path to)

.. container:: cell

   .. code:: r

      ## provide path to 3D starmap folder
      data_path = system.file('/Mini_datasets/3D_starmap', package = 'GiottoData')

      ## 0.1 path to expression matrix ####
      # --------------------------- #
      expr_path = paste0(data_path, '/', 'starmap_expr.txt.gz')

      ## 0.2 path to spot locations ####
      # -------------------------------------- #
      locations_path = paste0(data_path, '/', 'starmap_cell_loc.txt')

      # 1. Create Giotto object ####
      # ---------------------------------- #
      mini_starmap <- createGiottoObject(expression = expr_path,
                                  spatial_locs = locations_path,
                                  instructions = instrs)

      showGiottoSpatLocs(mini_starmap)
      showGiottoExpression(mini_starmap)


Processing steps
================

1. Filter genes and cells based on detection frequencies

2. Normalize expression matrix (log transformation, scaling factor and/or z-scores)

3. Add cell and gene statistics (optional)

4. Adjust expression matrix for technical covariates or batches (optional). These results will be stored in the custom sl

.. container:: cell

   .. code:: r

      filterDistributions(mini_starmap, detection = 'feats',
                          save_param = list(save_name = '2_a_filtergenes'))

.. image:: https://github.com/PratishthaGuckhool/Giotto_site_suite/blob/master/inst/images/3DStarmap_images/2_a_filtergenes.png?raw=true
   :width: 50.0%

.. container:: cell

   .. code:: r

      filterDistributions(mini_starmap, detection = 'cells',
                          save_param = list(save_name = '2_b_filtercells'))

.. image:: https://github.com/PratishthaGuckhool/Giotto_site_suite/blob/master/inst/images/3DStarmap_images/2_b_filtercells.png?raw=true
   :width: 50.0%

.. container:: cell

   .. code:: r

      filterCombinations(mini_starmap,
                         expression_thresholds = c(1),
                         feat_det_in_min_cells = c(50, 100, 200),
                         min_det_feats_per_cell = c(20, 28, 28),
                         save_param = list(save_name = '2_c_filtercombos'))

.. image:: https://github.com/PratishthaGuckhool/Giotto_site_suite/blob/master/inst/images/3DStarmap_images/2_c_filtercombos.png?raw=true
   :width: 50.0%

.. container:: cell

   .. code:: r

      # Filtering and normalization
      mini_starmap <- filterGiotto(gobject = mini_starmap,
                                   expression_threshold = 1,
                                   feat_det_in_min_cells = 50,
                                   min_det_feats_per_cell = 20,
                                   expression_values = c('raw'),
                                   verbose = T)
      mini_starmap <- normalizeGiotto(gobject = mini_starmap,
                                      scalefactor = 6000, verbose = T)
      mini_starmap <- addStatistics(gobject = mini_starmap)

Dimension Reduction
===================

1. Identify highly variable genes (HVG)

2. Perform PCA

3. Identify number of significant prinicipal components (PCs)

4. Run UMAP and/or TSNE on PCs (or directly on matrix)

.. container:: cell

   .. code:: r

      mini_starmap <- runPCA(gobject = mini_starmap, method = 'factominer')
      screePlot(mini_starmap, ncp = 30,
                save_param = list(save_name = '3_a_screeplot'))

.. image:: https://github.com/PratishthaGuckhool/Giotto_site_suite/blob/master/inst/images/3DStarmap_images/3_a_screeplot.png?raw=true
   :width: 50.0%

.. container:: cell

   .. code:: r

      plotPCA(gobject = mini_starmap,
              save_param = list(save_name = '3_b_PCA'))

.. image:: https://github.com/PratishthaGuckhool/Giotto_site_suite/blob/master/inst/images/3DStarmap_images/3_b_PCA.png?raw=true
   :width: 50.0%

.. container:: cell

   .. code:: r

      # 2D umap
      mini_starmap <- runUMAP(mini_starmap, dimensions_to_use = 1:8)
      plotUMAP(gobject = mini_starmap,
               save_param = list(save_name = '3_c_UMAP'))

.. image:: https://github.com/PratishthaGuckhool/Giotto_site_suite/blob/master/inst/images/3DStarmap_images/3_c_UMAP.png?raw=true
   :width: 50.0%

.. container:: cell

   .. code:: r

      # 2D tSNE
      mini_starmap <- runtSNE(mini_starmap, dimensions_to_use = 1:8)
      plotTSNE(gobject = mini_starmap, save_param = list(save_name = '3_d_TSNE'))

.. image:: https://github.com/PratishthaGuckhool/Giotto_site_suite/blob/master/inst/images/3DStarmap_images/3_d_TSNE.png?raw=true
   :width: 50.0%


Clustering
==========

1. Create a shared (default) nearest network in PCA space (or directly on matrix)

2. Cluster on nearest network with Leiden or Louvan (kmeans and hclust are alternatives)

.. container:: cell

   .. code:: r

      ## sNN network (default)
      mini_starmap <- createNearestNetwork(gobject = mini_starmap, dimensions_to_use = 1:8, k = 25)

      ## Leiden clustering
      mini_starmap <- doLeidenCluster(gobject = mini_starmap, resolution = 0.5, n_iterations = 1000)

      plotUMAP(gobject = mini_starmap, cell_color = 'leiden_clus', show_NN_network = T, point_size = 2.5, save_param = list(save_name = '4_a_UMAP'))

.. image:: https://github.com/PratishthaGuckhool/Giotto_site_suite/blob/master/inst/images/3DStarmap_images/4_a_UMAP.png?raw=true
   :width: 50.0%

.. container:: cell

   .. code:: r

      # 2D umap + coordinates
      spatDimPlot(gobject = mini_starmap, cell_color = 'leiden_clus',
                  dim_point_size = 2, spat_point_size = 2.5,
                  save_param = list(save_name = '4_b_spatdimplot'))

.. image:: https://github.com/PratishthaGuckhool/Giotto_site_suite/blob/master/inst/images/3DStarmap_images/4_b_spatdimplot.png?raw=true
   :width: 50.0%

Spatial Grids
=============

Create a grid based on defined stepsizes in the x,y(,z) axes.

.. container:: cell

   .. code:: r

      mini_starmap <- createSpatialGrid(gobject = mini_starmap,
                                  sdimx_stepsize = 200,
                                  sdimy_stepsize = 200,
                                  sdimz_stepsize = 20,
                                  minimum_padding = 10)

      showGiottoSpatGrids(mini_starmap)

      # visualize grid
      spatPlot2D(gobject = mini_starmap, show_grid = T, point_size = 1.5,
                 save_param = list(save_name = '5_a_spatplot'))

.. image:: https://github.com/PratishthaGuckhool/Giotto_site_suite/blob/master/inst/images/3DStarmap_images/5_a_spatplot.png?raw=true
   :width: 50.0%

Spatial Network
===============

Only the method = delaunayn_geometry can make 3D Delaunay networks. This requires the package geometry to be installed.

1. Visualize information about the default Delaunay network

2. Create a spatial Delaunay network (default)

3. Create a spatial kNN network

.. container:: cell

   .. code:: r

      plotStatDelaunayNetwork(gobject = mini_starmap, maximum_distance = 200,
                              method = 'delaunayn_geometry',
                              save_param = list(save_name = '6_a_delnetwork'))

.. image:: https://github.com/PratishthaGuckhool/Giotto_site_suite/blob/master/inst/images/3DStarmap_images/6_a_delnetwork.png?raw=true
   :width: 50.0%

.. container:: cell

   .. code:: r
      mini_starmap = createSpatialNetwork(gobject = mini_starmap, minimum_k = 2,
                                          maximum_distance_delaunay = 200,
                                          method = 'Delaunay',
                                          delaunay_method = 'delaunayn_geometry')
      mini_starmap = createSpatialNetwork(gobject = mini_starmap, minimum_k = 2,
                                          method = 'kNN', k = 10)
      showGiottoSpatNetworks(mini_starmap)

      # visualize the two different spatial networks
      spatPlot(gobject = mini_starmap, show_network = T,
               network_color = 'blue', spatial_network_name = 'Delaunay_network',
               point_size = 2.5, cell_color = 'leiden_clus',
               save_param = list(save_name = '6_b_spatplot'))

.. image:: https://github.com/PratishthaGuckhool/Giotto_site_suite/blob/master/inst/images/3DStarmap_images/6_b_spatplot.png?raw=true
   :width: 50.0%

.. container:: cell

   .. code:: r

      spatPlot(gobject = mini_starmap, show_network = T,
               network_color = 'blue', spatial_network_name = 'kNN_network',
               point_size = 2.5, cell_color = 'leiden_clus',
               save_param = list(save_name = '6_c_spatplot'))

.. image:: https://github.com/PratishthaGuckhool/Giotto_site_suite/blob/master/inst/images/3DStarmap_images/6_c_spatplot.png?raw=true
   :width: 50.0%

Spatial Genes
=============

Identify spatial genes with 3 different methods:

1. binSpect with kmeans binarization (default)
2. binSpect with rank binarization

Visualize top 4 genes per method.

.. container:: cell

   .. code:: r

      km_spatialgenes = binSpect(mini_starmap)
      spatFeatPlot2D(mini_starmap, expression_values = 'scaled',
                  feats = km_spatialgenes[1:4]$feats,
                  point_shape = 'border', point_border_stroke = 0.1,
                  show_network = F, network_color = 'lightgrey', point_size = 2.5,
                  cow_n_col = 2,
                  save_param = list(save_name = '7_a_spatgeneplot'))

.. image:: https://github.com/PratishthaGuckhool/Giotto_site_suite/blob/master/inst/images/3DStarmap_images/7_a_spatgeneplot.png?raw=true
   :width: 50.0%

.. container:: cell

   .. code:: r

       rank_spatialgenes = binSpect(mini_starmap, bin_method = 'rank')
       spatFeatPlot2D(mini_starmap, expression_values = 'scaled',
                      feats = rank_spatialgenes[1:4]$feats,
                      point_shape = 'border', point_border_stroke = 0.1,
                      show_network = F, network_color = 'lightgrey', point_size = 2.5,
                      cow_n_col = 2,
                      save_param = list(save_name = '7_b_spatgeneplot'))

.. image:: https://github.com/PratishthaGuckhool/Giotto_site_suite/blob/master/inst/images/3DStarmap_images/7_b_spatgeneplot.png?raw=true
   :width: 50.0%

3D visualization in Spatial and Expression Space
================================================

.. container:: cell

   .. code:: r

      # 1. calculate spatial correlation scores
      ext_spatial_genes = km_spatialgenes[1:20]$feats
      spat_cor_netw_DT = detectSpatialCorFeats(mini_starmap,
                                               method = 'network',
                                               spatial_network_name = 'Delaunay_network',
                                               subset_feats = ext_spatial_genes)

      # 2. cluster correlation scores
      spat_cor_netw_DT = clusterSpatialCorFeats(spat_cor_netw_DT,
                                                 name = 'spat_netw_clus', k = 6)
      heatmSpatialCorFeats(mini_starmap, spatCorObject = spat_cor_netw_DT,
                           use_clus_name = 'spat_netw_clus',
                           save_param = list(save_name = '8_a_heatmspatcor', units = 'in'))

.. image:: https://github.com/PratishthaGuckhool/Giotto_site_suite/blob/master/inst/images/3DStarmap_images/8_a_heatmspatcor.png?raw=true
   :width: 50.0%

.. container:: cell

   .. code:: r

      netw_ranks = rankSpatialCorGroups(mini_starmap,
                                        spatCorObject = spat_cor_netw_DT,
                                        use_clus_name = 'spat_netw_clus',
                                  save_param = list(save_name = '8_b_rankcorgroup'))

.. image:: https://github.com/PratishthaGuckhool/Giotto_site_suite/blob/master/inst/images/3DStarmap_images/8_b_rankcorgroup.png?raw=true
   :width: 50.0%

.. container:: cell

   .. code:: r

      top_netw_spat_cluster = showSpatialCorFeats(spat_cor_netw_DT,
                                                  use_clus_name = 'spat_netw_clus',
                                                  selected_clusters = 6,
                                                  show_top_feats = 1)

      cluster_genes_DT = showSpatialCorFeats(spat_cor_netw_DT,
                                             use_clus_name = 'spat_netw_clus',
                                             show_top_feats = 1)
      cluster_genes = cluster_genes_DT$clus; names(cluster_genes) = cluster_genes_DT$feat_ID

      mini_starmap = createMetafeats(mini_starmap,
                                     feat_clusters = cluster_genes,
                                     name = 'cluster_metagene')
      spatCellPlot(mini_starmap,
                   spat_enr_names = 'cluster_metagene',
                   cell_annotation_values = netw_ranks$clusters,
                   point_size = 1.5, cow_n_col = 3,
                   save_param = list(save_name = '8_c_spatcellplot'))

.. image:: https://github.com/PratishthaGuckhool/Giotto_site_suite/blob/master/inst/images/3DStarmap_images/8_c_spatcellplot.png?raw=true
   :width: 50.0%

3D Slicing
==========

Visualize cells in a virtual 2D cross section according to spatial coordinates.

The 2D cross section can be created using four different methods (parameter defined in createCrossSection function:

1. Equation: the plane is defined by a four element numerical vector (equation) in the form of c(A,B,C,D), corresponding to a plane with equation Ax+By+Cz=D

2. 3 points: the plane is define by the coordinates of 3 points, given by point1, point2, and point3

3. Point and norm vector: the plane is defined by the coordinates of one point (point1) in the plane and the coordinates of one norm vector (normVector) to the plane.

4. Point and two plane vector: the plane is defined by the coordinates of one point (point1) in the plane and the coordinates of two vectors (planeVector1, planeVector2) in the plane.

.. container:: cell

   .. code:: r

      # create cross section
      mini_starmap = createCrossSection(mini_starmap,
                                        method="equation",
                                        equation=c(0,1,1,8),
                                        extend_ratio = 0.2,
                                        cell_distance_estimate_method = "mean",
                                        thickness_unit = "cell",
                                        slice_thickness = 2,
                                        mesh_grid_n = 20)


      # show cross section
      insertCrossSectionSpatPlot3D(gobject = mini_starmap,
                                   crossSection_obj = crossSection_obj,
                                   cell_color = 'leiden_clus',
                                   axis_scale = 'cube',
                                   point_size = 2,
                                   save_param = list(save_name = '9_a_insertcross'))

.. image:: https://github.com/PratishthaGuckhool/Giotto_site_suite/blob/master/inst/images/3DStarmap_images/9_a_insertcross.png?raw=true
   :width: 50.0%

.. container:: cell

   .. code:: r

      insertCrossSectionGenePlot3D(gobject = mini_starmap,
                                   crossSection_obj = crossSection_obj,
                                   expression_values = 'scaled',
                                   axis_scale = "cube",
                                   genes = "Slc17a7",
                                   save_param = list(save_name = '9_b_insertcrossgene'))

      # for cell annotation
      crossSectionPlot(gobject = mini_starmap,
                       crossSection_obj = crossSection_obj,
                       point_size = 2, point_shape = "border",
                       cell_color = "leiden_clus",
                       save_param = list(save_name = '9_c_crossplot'))

.. image:: https://github.com/PratishthaGuckhool/Giotto_site_suite/blob/master/inst/images/3DStarmap_images/9_c_crossplot.png?raw=true
   :width: 50.0%

.. container:: cell

   .. code:: r

      crossSectionPlot3D(gobject = mini_starmap,
                         crossSection_obj = crossSection_obj,
                         point_size = 2, cell_color = "leiden_clus",
                         axis_scale = "cube",
                         save_param = list(save_name = '9_c_crossplot3D'))

      # for gene expression
      crossSectionGenePlot(gobject = mini_starmap,
                           crossSection_obj = crossSection_obj,
                           genes = "Slc17a7",
                           point_size = 2,
                           point_shape = "border",
                           cow_n_col = 1.5,
                           expression_values = 'scaled',
                           save_param = list(save_name = '9_d_crossgeneplot'))

.. image:: https://github.com/PratishthaGuckhool/Giotto_site_suite/blob/master/inst/images/3DStarmap_images/9_d_crossgeneplot.png?raw=true
   :width: 50.0%

