.. raw:: html

    <script type="text/javascript">
    if (String(window.location).indexOf("readthedocs") !== -1) {
        window.alert('This example has been moved. I will redirect you to the new location.');
        window.location.replace('https://drieslab.github.io/Giotto_website/articles/starmap_mouse_cortex.html');
    }
    </script>


===================================
3D Starmap with 3D slicing examples
===================================

:Date: 4/14/23

1 Dataset explanation
=====================

`Wang et al. <https://rubd.github.io/Giotto_site/articles/mouse_starmap_cortex_200917.html>`__
created a 3D spatial expression dataset consisting of 28 genes from
32,845 single cells in a visual cortex volume using the STARmap
technology.

The STARmap data to run this tutorial can be found
`here. <https://github.com/RubD/spatial-datasets/tree/master/data/2018_starmap_3D_cortex>`__
Alternatively you can use the **getSpatialDataset** to automatically
download this dataset from our GiottoData package like we do in this example.

2 Start Giotto
==============

.. container:: cell

   .. code:: r

      # Ensure Giotto Suite is installed
      if(!"Giotto" %in% installed.packages()) {
        devtools::install_github("drieslab/Giotto@suite")
      }
      library(Giotto)

      # Ensure Giotto Data is installed
      if(!"GiottoData" %in% installed.packages()) {
        devtools::install_github("drieslab/GiottoData")
      }
      library(GiottoData)

      # Ensure the Python environment for Giotto has been installed
      genv_exists = checkGiottoEnvironment()
      if(!genv_exists){
        # The following command need only be run once to install the Giotto environment
        installGiottoEnvironment()
      }

      ## Create instructions
      instrs = createGiottoInstructions(save_dir = getwd(),
                                        save_plot = TRUE,
                                        show_plot = TRUE,
                                        return_plot = FALSE)

3 Create a Giotto object
========================

Minimum requirements:

- matrix with expression information (or path to)
- x,y(,z) coordinates for cells or spots (or path to)

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

   .. container:: cell-output cell-output-stdout

      ::

         └──Spatial unit "cell"
            └──S4 spatLocsObj "raw" coordinates:   (4000 rows)
                  An object of class spatLocsObj
                  provenance: cell
                      ------------------------
                     sdimx sdimy sdimz    cell_ID
                  1:   270   212    19  cell_2944
                  2:  1389  1215    54 cell_17523
                  3:  1051   360    89 cell_30080
                  4:   592   777    10   cell_941

                  ranges:
                       sdimx sdimy
                  [1,]     3     1
                  [2,]  1774  1536




   .. code:: r

      showGiottoExpression(mini_starmap)

   .. container:: cell-output cell-output-stdout

      ::

         └──Spatial unit "cell"
            └──Feature type "rna"
               └──Expression data "raw" values:
                     An object of class exprObj
                     for spatial unit: "cell" and feature type: "rna"
                       Provenance:  cell

                     contains:
                     28 x 4000 sparse Matrix of class "dgCMatrix"

                     Slc17a7 34999 12200 12494 82087 22633 55543 50891 5124 37814 9275 25346 51716 25506
                     Mgp       768  1842   366  2320   503  1311  2329  227   789  448   710  1609   510
                     Gad1      926  3036   215   627   341  1651 12148  190   333 2947  1520  8017   209

                     Slc17a7 ......
                     Mgp     ......
                     Gad1    ......

                      ........suppressing 3987 columns and 22 rows

                     Ctss  6148 7050 1405 15017  698  1723  7807  1833 15769 6041 11558 26615  6655 ......
                     Mbp  18242 8368  640 50069 4783 12600 15076 25495 14903 6912  8176 38820 28268 ......
                     Flt1  9406  551  504  9169  329  1822  4125 13984  1773 8490  2127  5448  5300 ......

                      First four colnames:
                      cell_2944 cell_17523 cell_30080
                      cell_941


4 Processing
============

1. Filter genes and cells based on detection frequencies

2. Normalize expression matrix (log transformation, scaling factor and/or z-scores)

3. Add cell and gene statistics (optional)

4. Adjust expression matrix for technical covariates or batches (optional). These results will be stored in the custom slot.

.. container:: cell

   .. code:: r

      filterDistributions(mini_starmap, detection = 'feats',
                          save_param = list(save_name = '2_a_filtergenes'))

   .. container:: cell-output-display

      .. image:: 3D_starmap_files/figure-rst/unnamed-chunk-3-1.png

   .. code:: r

      filterDistributions(mini_starmap, detection = 'cells',
                          save_param = list(save_name = '2_b_filtercells'))

   .. container:: cell-output-display

      .. image:: 3D_starmap_files/figure-rst/unnamed-chunk-3-2.png

   .. code:: r

      filterCombinations(mini_starmap,
                         expression_thresholds = c(1),
                         feat_det_in_min_cells = c(50, 100, 200),
                         min_det_feats_per_cell = c(20, 28, 28),
                         save_param = list(save_name = '2_c_filtercombos'))

   .. container:: cell-output-display

      .. image:: 3D_starmap_files/figure-rst/unnamed-chunk-3-3.png

   .. container:: cell-output cell-output-stdout

      ::

         $results
            threshold feat_detected_in_min_cells min_detected_feats_per_cell combination
         1:         1                         50                          20       50-20
         2:         1                        100                          28      100-28
         3:         1                        200                          28      200-28
            removed_feats removed_cells
         1:             0            95
         2:             0           586
         3:             0           586

         $ggplot

   .. container:: cell-output-display

      .. image:: 3D_starmap_files/figure-rst/unnamed-chunk-3-4.png

   .. code:: r

      # Filtering and normalization
      mini_starmap <- filterGiotto(gobject = mini_starmap,
                                 expression_threshold = 1,
                                 feat_det_in_min_cells = 50,
                                 min_det_feats_per_cell = 20,
                                 expression_values = c('raw'),
                                 verbose = T)

   .. container:: cell-output cell-output-stdout

      ::

         preview:
               sdimx sdimy sdimz    cell_ID
            1:   270   212    19  cell_2944
            2:  1389  1215    54 cell_17523
            3:  1051   360    89 cell_30080
            4:   592   777    10   cell_941
            5:  1058   223    84 cell_28514
           ---
         3901:   348  1383    78 cell_26011
         3902:   674  1080    89 cell_31539
         3903:   919   532    22  cell_4185
         3904:   947   885    23  cell_3851
         3905:   144   439    60 cell_21337

         ranges:
              sdimx sdimy
         [1,]    11    12
         [2,]  1774  1525





         Feature type:  rna
         Number of cells removed:  95  out of  4000
         Number of feats removed:  0  out of  28

   .. code:: r

      mini_starmap <- normalizeGiotto(gobject = mini_starmap,
                                      scalefactor = 6000, verbose = T)

      mini_starmap <- addStatistics(gobject = mini_starmap)

5 Dimension Reduction
=====================

1. Identify highly variable genes (HVG) will not be performed here, because there are only few genes
perform PCA

2. Identify number of significant prinicipal components (PCs)

3. Run UMAP and/or TSNE on PCs (or directly on matrix)

.. container:: cell

   .. code:: r

      # mini_starmap <- calculateHVF(gobject = mini_starmap)

      mini_starmap <- runPCA(gobject = mini_starmap, method = 'factominer')

      screePlot(mini_starmap, ncp = 30,
                save_param = list(save_name = '3_a_screeplot'))

   .. container:: cell-output-display

      .. image:: 3D_starmap_files/figure-rst/unnamed-chunk-4-1.png

   .. code:: r

      plotPCA(gobject = mini_starmap,
              save_param = list(save_name = '3_b_PCA'))

   .. container:: cell-output-display

      .. image:: 3D_starmap_files/figure-rst/unnamed-chunk-4-2.png

   .. code:: r

      # 2D umap
      mini_starmap <- runUMAP(mini_starmap, dimensions_to_use = 1:8)
      plotUMAP(gobject = mini_starmap,
               save_param = list(save_name = '3_c_UMAP'))

   .. container:: cell-output-display

      .. image:: 3D_starmap_files/figure-rst/unnamed-chunk-4-3.png

   .. code:: r

      # 2D tSNE
      mini_starmap <- runtSNE(mini_starmap, dimensions_to_use = 1:8)
      plotTSNE(gobject = mini_starmap, save_param = list(save_name = '3_d_TSNE'))

   .. container:: cell-output-display

      .. image:: 3D_starmap_files/figure-rst/unnamed-chunk-4-4.png

6 Clustering
============

1. Create a shared (default) nearest network in PCA space (or directly on matrix)

2. Cluster on nearest network with Leiden or Louvan (kmeans and hclust are alternatives)

.. container:: cell

   .. code:: r

      ## sNN network (default)
      mini_starmap <- createNearestNetwork(gobject = mini_starmap, dimensions_to_use = 1:8, k = 25)

      ## Leiden clustering
      mini_starmap <- doLeidenCluster(gobject = mini_starmap, resolution = 0.5, n_iterations = 1000)

      plotUMAP(gobject = mini_starmap, cell_color = 'leiden_clus', show_NN_network = T, point_size = 2.5, save_param = list(save_name = '4_a_UMAP'))

   .. container:: cell-output-display

      .. image:: 3D_starmap_files/figure-rst/unnamed-chunk-5-1.png

   .. code:: r

      # 2D umap + coordinates
      spatDimPlot(gobject = mini_starmap, cell_color = 'leiden_clus',
                  dim_point_size = 2, spat_point_size = 2.5,
                  save_param = list(save_name = '4_b_spatdimplot'))

   .. container:: cell-output-display

      .. image:: 3D_starmap_files/figure-rst/unnamed-chunk-5-2.png

7 Spatial Grids
===============

Create a grid based on defined stepsizes in the x,y(,z) axes.

.. container:: cell

   .. code:: r

      mini_starmap <- createSpatialGrid(gobject = mini_starmap,
                                        sdimx_stepsize = 200,
                                        sdimy_stepsize = 200,
                                        sdimz_stepsize = 20,
                                        minimum_padding = 10)

      showGiottoSpatGrids(mini_starmap)

   .. container:: cell-output cell-output-stdout

      ::

         └──Spatial unit "cell"
            └──Feature type "rna"
               └──S4 spatialGridObj "spatial_grid"   (432 rows)
                        x_start y_start z_start x_end y_end z_end gr_name gr_x_name gr_y_name
                     1:    -7.5   -31.5     -10 192.5 168.5    10    gr_1    gr_x_1    gr_y_1
                     2:   192.5   -31.5     -10 392.5 168.5    10    gr_2    gr_x_2    gr_y_1
                     3:   392.5   -31.5     -10 592.5 168.5    10    gr_3    gr_x_3    gr_y_1
                     4:   592.5   -31.5     -10 792.5 168.5    10    gr_4    gr_x_4    gr_y_1
                        gr_z_name
                     1:    gr_z_1
                     2:    gr_z_1
                     3:    gr_z_1
                     4:    gr_z_1


   .. code:: r

      # visualize grid
      spatPlot2D(gobject = mini_starmap, show_grid = T, point_size = 1.5,
                 save_param = list(save_name = '5_a_spatplot'))

   .. container:: cell-output-display

      .. image:: 3D_starmap_files/figure-rst/unnamed-chunk-6-1.png

8 Spatial Networks
==================

Only the method = delaunayn_geometry can make 3D Delaunay networks. This requires the package geometry to be installed.

1. Visualize information about the default Delaunay network

2. Create a spatial Delaunay network (default)

3. Create a spatial kNN network

.. container:: cell

   .. code:: r

      plotStatDelaunayNetwork(gobject = mini_starmap, maximum_distance = 200,
                              method = 'delaunayn_geometry',
                              save_param = list(save_name = '6_a_delnetwork'))

   .. container:: cell-output-display

      .. image:: 3D_starmap_files/figure-rst/unnamed-chunk-7-1.png

   .. code:: r

      mini_starmap = createSpatialNetwork(gobject = mini_starmap, minimum_k = 2,
                                          maximum_distance_delaunay = 200,
                                          method = 'Delaunay',
                                          delaunay_method = 'delaunayn_geometry')
      mini_starmap = createSpatialNetwork(gobject = mini_starmap, minimum_k = 2,
                                          method = 'kNN', k = 10)
      showGiottoSpatNetworks(mini_starmap)

   .. container:: cell-output cell-output-stdout

      ::

         └──Spatial unit "cell"
            ├──S4 spatialNetworkObj "Delaunay_network"   (28093 rows)
            │              from         to sdimx_begin sdimy_begin sdimz_begin sdimx_end
            │     1: cell_10002  cell_9593        1007        1155          38       982
            │     2: cell_10002 cell_23094        1007        1155          38       994
            │     3: cell_10002  cell_5783        1007        1155          38      1045
            │     4: cell_10002  cell_6165        1007        1155          38      1020
            │        sdimy_end sdimz_end distance     weight
            │     1:      1136        36 31.46427 0.03178209
            │     2:      1123        64 43.23193 0.02313105
            │     3:      1119        29 53.11309 0.01882775
            │     4:      1204        20 53.79591 0.01858877
            │
            └──S4 spatialNetworkObj "kNN_network"   (23135 rows)
                           from         to sdimx_begin sdimy_begin sdimz_begin sdimx_end
                  1: cell_10002  cell_9593        1007        1155          38       982
                  2: cell_10002 cell_23094        1007        1155          38       994
                  3: cell_10002  cell_5783        1007        1155          38      1045
                  4: cell_10002  cell_6165        1007        1155          38      1020
                     sdimy_end sdimz_end distance     weight
                  1:      1136        36 31.46427 0.03080310
                  2:      1123        64 43.23193 0.02260810
                  3:      1119        29 53.11309 0.01847982
                  4:      1204        20 53.79591 0.01824954


   .. code:: r

      # visualize the two different spatial networks
      spatPlot(gobject = mini_starmap, show_network = T,
               network_color = 'blue', spatial_network_name = 'Delaunay_network',
               point_size = 2.5, cell_color = 'leiden_clus',
               save_param = list(save_name = '6_b_spatplot'))

   .. container:: cell-output-display

      .. image:: 3D_starmap_files/figure-rst/unnamed-chunk-7-2.png

   .. code:: r

      spatPlot(gobject = mini_starmap, show_network = T,
               network_color = 'blue', spatial_network_name = 'kNN_network',
               point_size = 2.5, cell_color = 'leiden_clus',
               save_param = list(save_name = '6_c_spatplot'))

   .. container:: cell-output-display

      .. image:: 3D_starmap_files/figure-rst/unnamed-chunk-7-3.png

9 Spatial Genes
===============

Identify spatial genes with 2 different methods:

- binSpect with kmeans binarization (default)

- binSpect with rank binarization

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

   .. container:: cell-output-display

      .. image:: 3D_starmap_files/figure-rst/unnamed-chunk-8-1.png

   .. code:: r

      rank_spatialgenes = binSpect(mini_starmap, bin_method = 'rank')

      spatFeatPlot2D(mini_starmap, expression_values = 'scaled',
                   feats = rank_spatialgenes[1:4]$feats,
                   point_shape = 'border', point_border_stroke = 0.1,
                   show_network = F, network_color = 'lightgrey', point_size = 2.5,
                   cow_n_col = 2,
                   save_param = list(save_name = '7_b_spatgeneplot'))

   .. container:: cell-output-display

      .. image:: 3D_starmap_files/figure-rst/unnamed-chunk-8-2.png

10 Spatial Co-expression Patterns
=================================

Identify robust spatial co-expression patterns using the spatial network or grid and a subset of individual spatial genes.

1. calculate spatial correlation scores

2. cluster correlation scores

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

   .. container:: cell-output-display

      .. image:: 3D_starmap_files/figure-rst/unnamed-chunk-9-1.png

   .. code:: r

      netw_ranks = rankSpatialCorGroups(mini_starmap,
                                        spatCorObject = spat_cor_netw_DT,
                                        use_clus_name = 'spat_netw_clus',
                                        save_param = list(save_name = '8_b_rankcorgroup'))

   .. container:: cell-output-display

      .. image:: 3D_starmap_files/figure-rst/unnamed-chunk-9-2.png

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

   .. container:: cell-output-display

      .. image:: 3D_starmap_files/figure-rst/unnamed-chunk-9-3.png

11 3D Slicing
=============

Create 2D cross sections from 3D object

.. container:: cell

   .. code:: r

      delaunay_network_DT = mini_starmap@spatial_network$cell$Delaunay_network
      delaunay_network_DT = delaunay_network_DT@networkDT

      networkDT = delaunay_network_DT
      mini_starmap = createCrossSection(mini_starmap,
                                        method="equation",
                                        equation=c(0,1,1,8),
                                        extend_ratio = 0.2,
                                        cell_distance_estimate_method = "mean",
                                        thickness_unit = "cell",
                                        slice_thickness = 2,
                                        mesh_grid_n = 20)

      # show cross section
      crossSection_obj = mini_starmap@spatial_network[["Delaunay_network"]][["crossSectionObjects"]][["cross_section"]]
      insertCrossSectionSpatPlot3D(gobject = mini_starmap,
                                   crossSection_obj = crossSection_obj,
                                   cell_color = 'leiden_clus',
                                   axis_scale = 'cube',
                                   point_size = 2,
                                   save_param = list(save_name = '9_a_insertcross'))

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

   .. container:: cell-output-display

      .. image:: 3D_starmap_files/figure-rst/unnamed-chunk-10-2.png

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

   .. container:: cell-output-display

      .. image:: 3D_starmap_files/figure-rst/unnamed-chunk-10-3.png

12 Session Info
===============

.. container:: cell

   .. code:: r

      sessionInfo()

   .. container:: cell-output cell-output-stdout

      ::

         R version 4.2.3 (2023-03-15)
         Platform: aarch64-apple-darwin20 (64-bit)
         Running under: macOS Monterey 12.5.1

         Matrix products: default
         BLAS:   /Library/Frameworks/R.framework/Versions/4.2-arm64/Resources/lib/libRblas.0.dylib
         LAPACK: /Library/Frameworks/R.framework/Versions/4.2-arm64/Resources/lib/libRlapack.dylib

         locale:
         [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8

         attached base packages:
         [1] stats     graphics  grDevices utils     datasets  methods   base

         other attached packages:
         [1] GiottoData_0.2.1 Giotto_3.2.1

         loaded via a namespace (and not attached):
           [1] matrixStats_0.63.0    doParallel_1.0.17     RColorBrewer_1.1-3
           [4] httr_1.4.5            rprojroot_2.0.3       tools_4.2.3
           [7] utf8_1.2.3            R6_2.5.1              irlba_2.3.5.1
          [10] DT_0.27               uwot_0.1.14           BiocGenerics_0.44.0
          [13] lazyeval_0.2.2        colorspace_2.1-0      GetoptLong_1.0.5
          [16] withr_2.5.0           tidyselect_1.2.0      emmeans_1.8.5
          [19] compiler_4.2.3        textshaping_0.3.6     cli_3.6.1
          [22] flashClust_1.01-2     plotly_4.10.1         labeling_0.4.2
          [25] scales_1.2.1          mvtnorm_1.1-3         multcompView_0.1-8
          [28] systemfonts_1.0.4     digest_0.6.31         dbscan_1.1-11
          [31] rmarkdown_2.21        R.utils_2.12.2        pkgconfig_2.0.3
          [34] htmltools_0.5.5       fastmap_1.1.1         FactoMineR_2.8
          [37] htmlwidgets_1.6.2     rlang_1.1.0           GlobalOptions_0.1.2
          [40] rstudioapi_0.14       FNN_1.1.3.2           shape_1.4.6
          [43] farver_2.1.1          generics_0.1.3        jsonlite_1.8.4
          [46] crosstalk_1.2.0       dplyr_1.1.1           R.oo_1.25.0
          [49] magrittr_2.0.3        leaps_3.1             Matrix_1.5-4
          [52] Rcpp_1.0.10           munsell_0.5.0         S4Vectors_0.36.2
          [55] fansi_1.0.4           abind_1.4-5           reticulate_1.28
          [58] lifecycle_1.0.3       R.methodsS3_1.8.2     terra_1.7-23
          [61] scatterplot3d_0.3-43  yaml_2.3.7            MASS_7.3-58.3
          [64] Rtsne_0.16            grid_4.2.3            parallel_4.2.3
          [67] ggrepel_0.9.3         crayon_1.5.2          lattice_0.20-45
          [70] cowplot_1.1.1         circlize_0.4.15       magick_2.7.4
          [73] knitr_1.42            ComplexHeatmap_2.14.0 pillar_1.9.0
          [76] igraph_1.4.2          rjson_0.2.21          estimability_1.4.1
          [79] codetools_0.2-19      stats4_4.2.3          magic_1.6-1
          [82] glue_1.6.2            evaluate_0.20         data.table_1.14.8
          [85] png_0.1-8             vctrs_0.6.1           foreach_1.5.2
          [88] gtable_0.3.3          purrr_1.0.1           tidyr_1.3.0
          [91] clue_0.3-64           ggplot2_3.4.2         xfun_0.38
          [94] xtable_1.8-4          viridisLite_0.4.1     ragg_1.2.5
          [97] geometry_0.4.7        tibble_3.2.1          iterators_1.0.14
         [100] IRanges_2.32.0        cluster_2.1.4         ellipsis_0.3.2
         [103] here_1.0.1
