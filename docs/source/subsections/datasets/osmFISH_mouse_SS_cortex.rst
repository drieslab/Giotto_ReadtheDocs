.. raw:: html

    <script type="text/javascript">
    if (String(window.location).indexOf("readthedocs") !== -1) {
        window.alert('This example has been moved. I will redirect you to the new location.');
        window.location.replace('https://drieslab.github.io/Giotto_website/articles/osmfish_mouse_ss_cortex.html');
    }
    </script>

===============================
osmFISH Mouse SS Cortex
===============================

:Date: 2022-09-16

Dataset explanation
===================

`Codeluppi et al. <https://www.nature.com/articles/s41592-018-0175-z>`__
created a cyclic single-molecule fluorescence in situ hybridization
(osmFISH) technology and define the cellular organization of the
somatosensory cortex with the expression of 33 genes in 5,328 cells.

.. image:: /images/images_pkgdown/general_figs/osmfish_image_demo.png
   :width: 50.0%

Set up Giotto environment
=========================

.. container:: cell

   .. code:: r

      # Ensure Giotto Suite is installed.
      if(!"Giotto" %in% installed.packages()) {
        devtools::install_github("drieslab/Giotto@suite")
      }

      # Ensure GiottoData, a small, helper module for tutorials, is installed.
      if(!"GiottoData" %in% installed.packages()) {
        devtools::install_github("drieslab/GiottoData")
      }
      library(Giotto)
      # Ensure the Python environment for Giotto has been installed.
      genv_exists = checkGiottoEnvironment()
      if(!genv_exists){
        # The following command need only be run once to install the Giotto environment.
        installGiottoEnvironment()
      }

.. container:: cell

   .. code:: r

      library(Giotto)
      library(GiottoData)

      # 1. set working directory
      results_folder = 'path/to/result'

      # Optional: Specify a path to a Python executable within a conda or miniconda
      # environment. If set to NULL (default), the Python executable within the previously
      # installed Giotto environment will be used.
      my_python_path = NULL # alternatively, "/local/python/path/python" if desired.

Dataset download
================

The osmFISH data to run this tutorial can be found
`here <https://github.com/drieslab/spatial-datasets/tree/master/data/2018_osmFISH_SScortex>`__.
Alternatively you can use the **getSpatialDataset** to automatically
download this dataset like we do in this example; to download the data used to create the Giotto Object below, please ensure
that `wget <https://www.gnu.org/software/wget/?>`__ is installed locally.

.. container:: cell

   .. code:: r

      # download data to working directory ####
      # if wget is installed, set method = 'wget'
      # if you run into authentication issues with wget, then add " extra = '--no-check-certificate' "
      getSpatialDataset(dataset = 'osmfish_SS_cortex', directory = results_folder, method = 'wget')

Part 1: Giotto global instructions and preparations
===================================================

.. container:: cell

   .. code:: r

      ## instructions allow us to automatically save all plots into a chosen results folder
      instrs = createGiottoInstructions(save_plot = TRUE,
                                        show_plot = FALSE,
                                        save_dir = results_folder,
                                        python_path = python_path)

      expr_path = paste0(results_folder, "osmFISH_prep_expression.txt")
      loc_path = paste0(results_folder, "osmFISH_prep_cell_coordinates.txt")
      meta_path = paste0(results_folder, "osmFISH_prep_cell_metadata.txt")

Part 2: Create Giotto object & process data
===========================================

.. container:: cell

   .. code:: r

      ## create
      osm_test <- createGiottoObject(expression = expr_path,
                                    spatial_locs = loc_path,
                                    instructions = instrs)

      ## add field annotation
      metadata = data.table::fread(file = meta_path)
      osm_test = addCellMetadata(osm_test, new_metadata = metadata,
                                 by_column = T, column_cell_ID = 'CellID')
      ## filter
      osm_test <- filterGiotto(gobject = osm_test,
                               expression_threshold = 1,
                               feat_det_in_min_cells = 10,
                               min_det_feats_per_cell = 10,
                               expression_values = c('raw'),
                               verbose = T)

      ## normalize Giotto
      ## there are two ways for osmFISH object

      # 1. standard z-score way
      osm_test <- normalizeGiotto(gobject = osm_test)

      # 2. osmFISH way
      raw_expr_matrix = get_expression_values(osm_test, values = "raw")
      norm_genes = (raw_expr_matrix/Giotto:::rowSums_flex(raw_expr_matrix)) * nrow(raw_expr_matrix)

      norm_genes_cells = Giotto:::t_flex((Giotto:::t_flex(norm_genes)/Giotto:::colSums_flex(norm_genes)) * ncol(raw_expr_matrix))
      osm_test = set_expression_values(osm_test, values = norm_genes_cells , name = "custom")

      ## add gene & cell statistics
      osm_test <- addStatistics(gobject = osm_test)

      # save according to giotto instructions
      spatPlot2D(gobject = osm_test, cell_color = 'ClusterName', point_size = 1.5,
               save_param = list(save_name = '2_a_original_clusters'))

.. image:: /images/images_pkgdown/osmFISH_mouse_SS_cortex/vignette_sep29_2021/2_a_original_clusters.png
   :width: 50.0%

.. container:: cell

   .. code:: r

      spatPlot2D(gobject = osm_test, cell_color = 'Region',
               save_param = list(save_name = '2_b_original_regions'))

.. image:: /images/images_pkgdown/osmFISH_mouse_SS_cortex/vignette_sep29_2021/2_b_original_regions.png
   :width: 50.0%

.. container:: cell

   .. code:: r

      spatPlot2D(gobject = osm_test, cell_color = 'ClusterID',
               save_param = list(save_name = '2_c_clusterID'))

.. image:: /images/images_pkgdown/osmFISH_mouse_SS_cortex/vignette_sep29_2021/2_c_clusterID.png
   :width: 50.0%

.. container:: cell

   .. code:: r

      spatPlot2D(gobject = osm_test, cell_color = 'total_expr', color_as_factor = F, gradient_midpoint = 160,
               gradient_limits = c(120,220),
               save_param = list(save_name = '2_d_total_expr_limits'))

.. image:: /images/images_pkgdown/osmFISH_mouse_SS_cortex/vignette_sep29_2021/2_d_total_expr_limits.png
   :width: 50.0%

Part 3: Dimension reduction
===========================

.. container:: cell

   .. code:: r

      ## highly variable genes (HVG)
      # only 33 genes so use all genes

      ## run PCA on expression values (default)
      osm_test <- runPCA(gobject = osm_test, expression_values = 'custom', scale_unit = F, center = F)
      screePlot(osm_test, ncp = 30,
                save_param = list(save_name = '3_a_screeplot'))

.. image:: /images/images_pkgdown/osmFISH_mouse_SS_cortex/vignette_sep29_2021/3_a_screeplot.png
   :width: 50.0%

.. container:: cell

   .. code:: r

      plotPCA(osm_test,
              save_param = list(save_name = '3_b_PCA_reduction'))

.. image:: /images/images_pkgdown/osmFISH_mouse_SS_cortex/vignette_sep29_2021/3_b_PCA_reduction.png
   :width: 50.0%

.. container:: cell

   .. code:: r

      ## run UMAP and tSNE on PCA space (default)
      osm_test <- runUMAP(osm_test, dimensions_to_use = 1:31, n_threads = 4)
      plotUMAP(gobject = osm_test,
               save_param = list(save_name = '3_c_UMAP_reduction.png'))

.. image:: /images/images_pkgdown/osmFISH_mouse_SS_cortex/vignette_sep29_2021/3_c_UMAP_reduction.png.png
   :width: 50.0%

.. container:: cell

   .. code:: r

      plotUMAP(gobject = osm_test,
               cell_color = 'total_expr', color_as_factor = F, gradient_midpoint = 180, gradient_limits = c(120, 220),
               save_param = list(save_name = '3_d_UMAP_reduction_expression.png'))

.. image:: /images/images_pkgdown/osmFISH_mouse_SS_cortex/vignette_sep29_2021/3_d_UMAP_reduction_expression.png.png
   :width: 50.0%

.. container:: cell

   .. code:: r

      osm_test <- runtSNE(osm_test, dimensions_to_use = 1:31, perplexity = 70, check_duplicates = F)
      plotTSNE(gobject = osm_test,  save_param = list(save_name = '3_e_tSNE_reduction'))

.. image:: /images/images_pkgdown/osmFISH_mouse_SS_cortex/vignette_sep29_2021/3_e_tSNE_reduction.png
   :width: 50.0%

Part 4: Cluster
===============

.. container:: cell

   .. code:: r

      ## hierarchical clustering
      osm_test = doHclust(gobject = osm_test, expression_values = 'custom', k = 36)
      plotUMAP(gobject = osm_test, cell_color = 'hclust', point_size = 2.5,
               show_NN_network = F, edge_alpha = 0.05,
               save_param = list(save_name = '4_a_UMAP_hclust'))

.. image:: /images/images_pkgdown/osmFISH_mouse_SS_cortex/vignette_sep29_2021/4_a_UMAP_hclust.png
   :width: 50.0%

.. container:: cell

   .. code:: r

      ## kmeans clustering
      osm_test = doKmeans(gobject = osm_test, expression_values = 'normalized', dim_reduction_to_use = 'pca', dimensions_to_use = 1:20, centers = 36, nstart = 2000)
      plotUMAP(gobject = osm_test, cell_color = 'kmeans',
               point_size = 2.5, show_NN_network = F, edge_alpha = 0.05,
               save_param =  list(save_name = '4_b_UMAP_kmeans'))

.. image:: /images/images_pkgdown/osmFISH_mouse_SS_cortex/vignette_sep29_2021/4_b_UMAP_kmeans.png
   :width: 50.0%

.. container:: cell

   .. code:: r

      ## Leiden clustering strategy:
      # 1. overcluster
      # 2. merge small clusters that are highly similar

      # sNN network (default)
      osm_test <- createNearestNetwork(gobject = osm_test, dimensions_to_use = 1:31, k = 12)

      osm_test <- doLeidenCluster(gobject = osm_test, resolution = 0.09, n_iterations = 1000)
      plotUMAP(gobject = osm_test, cell_color = 'leiden_clus', point_size = 2.5,
               show_NN_network = F, edge_alpha = 0.05,
               save_param = list(save_name = '4_c_UMAP_leiden'))

.. image:: /images/images_pkgdown/osmFISH_mouse_SS_cortex/vignette_sep29_2021/4_c_UMAP_leiden.png
   :width: 50.0%

.. container:: cell

   .. code:: r

      # merge small groups based on similarity
      leiden_similarities = getClusterSimilarity(osm_test,
                                                 expression_values = 'custom',
                                                 cluster_column = 'leiden_clus')

      osm_test = mergeClusters(osm_test,
                               expression_values = 'custom',
                               cluster_column = 'leiden_clus',
                               new_cluster_name = 'leiden_clus_m',
                               max_group_size = 30,
                               force_min_group_size = 25,
                               max_sim_clusters = 10,
                               min_cor_score = 0.7)

      plotUMAP(gobject = osm_test, cell_color = 'leiden_clus_m', point_size = 2.5,
               show_NN_network = F, edge_alpha = 0.05,
               save_param = list(save_name = '4_d_UMAP_leiden_merged'))

.. image:: /images/images_pkgdown/osmFISH_mouse_SS_cortex/vignette_sep29_2021/4_d_UMAP_leiden_merged.png
   :width: 50.0%

.. container:: cell

   .. code:: r

      ## show cluster relationships
      showClusterHeatmap(gobject = osm_test, expression_values = 'custom', cluster_column = 'leiden_clus_m',
                         save_param = list(save_name = '4_e_heatmap', units = 'cm'),
                         row_names_gp = grid::gpar(fontsize = 6), column_names_gp = grid::gpar(fontsize = 6))

.. image:: /images/images_pkgdown/osmFISH_mouse_SS_cortex/vignette_sep29_2021/4_e_heatmap.png
   :width: 50.0%

.. container:: cell

   .. code:: r

      showClusterDendrogram(osm_test, cluster_column = 'leiden_clus_m', h = 1, rotate = T,
                            save_param = list(save_name = '4_f_dendro', units = 'cm'))

.. image:: /images/images_pkgdown/osmFISH_mouse_SS_cortex/vignette_sep29_2021/4_f_dendro.png
   :width: 50.0%

Part 5: Co-visualize
====================

.. container:: cell

   .. code:: r

      # expression and spatial
      spatDimPlot2D(gobject = osm_test, cell_color = 'leiden_clus', spat_point_size = 2,
                    save_param = list(save_name = '5_a_covis_leiden'))

.. image:: /images/images_pkgdown/osmFISH_mouse_SS_cortex/vignette_sep29_2021/5_a_covis_leiden.png
   :width: 50.0%

.. container:: cell

   .. code:: r

      spatDimPlot2D(gobject = osm_test, cell_color = 'leiden_clus_m', spat_point_size = 2,
                    save_param = list(save_name = '5_b_covis_leiden_m'))

.. image:: /images/images_pkgdown/osmFISH_mouse_SS_cortex/vignette_sep29_2021/5_b_covis_leiden_m.png
   :width: 50.0%

.. container:: cell

   .. code:: r

      spatDimPlot2D(gobject = osm_test, cell_color = 'leiden_clus_m',
                    dim_point_size = 2, spat_point_size = 2, select_cell_groups = 'm_8',
                    save_param = list(save_name = '5_c_covis_leiden_merged_selected'))

.. image:: /images/images_pkgdown/osmFISH_mouse_SS_cortex/vignette_sep29_2021/5_c_covis_leiden_merged_selected.png
   :width: 50.0%

.. container:: cell

   .. code:: r

      spatDimPlot2D(gobject = osm_test, cell_color = 'total_expr', color_as_factor = F,
                    gradient_midpoint = 160, gradient_limits = c(120,220),
                    save_param = list(save_name = '5_d_total_expr'))

.. image:: /images/images_pkgdown/osmFISH_mouse_SS_cortex/vignette_sep29_2021/5_d_total_expr.png
   :width: 50.0%

Part 6: Differential expression
===============================

.. container:: cell

   .. code:: r

      ## split dendrogram nodes ##
      dendsplits = getDendrogramSplits(gobject = osm_test,
                                       expression_values = 'custom',
                                       cluster_column = 'leiden_clus_m')
      split_3_markers = findMarkers(gobject = osm_test,
                                               method = 'gini',
                                               expression_values = 'custom',
                                               cluster_column = 'leiden_clus_m',
      group_1 = unlist(dendsplits[3]$tree_1), group_2 = unlist(dendsplits[3]$tree_2))

.. image:: /images/images_pkgdown/osmFISH_mouse_SS_cortex/vignette_sep29_2021/6_a_dendrogram.png
   :width: 50.0%

.. container:: cell

   .. code:: r

      ## Individual populations ##
      markers = findMarkers_one_vs_all(gobject = osm_test,
                                       method = 'scran',
                                       expression_values = 'custom',
                                       cluster_column = 'leiden_clus_m',
                                       min_feats = 2, rank_score = 2)
      ## violinplot
      topgenes = markers[, head(.SD, 1), by = 'cluster']$feats
      violinPlot(osm_test, feats = unique(topgenes), cluster_column = 'leiden_clus_m', expression_values = 'custom',
                 strip_text = 5, strip_position = 'right',
                 save_param = c(save_name = '6_a_violinplot'))

.. image:: /images/images_pkgdown/osmFISH_mouse_SS_cortex/vignette_sep29_2021/6_a_violinplot.png
   :width: 50.0%

.. container:: cell

   .. code:: r

      plotMetaDataHeatmap(osm_test, expression_values = 'custom',
                          metadata_cols = c('leiden_clus_m'),
                          save_param = c(save_name = '6_b_metaheatmap'))

.. image:: /images/images_pkgdown/osmFISH_mouse_SS_cortex/vignette_sep29_2021/6_b_metaheatmap.png
   :width: 50.0%

.. container:: cell

   .. code:: r

      plotMetaDataHeatmap(osm_test, expression_values = 'custom',
                          metadata_cols = c('leiden_clus_m'),
                          save_param = c(save_name = '6_e_metaheatmap_all_genes'))

.. image:: /images/images_pkgdown/osmFISH_mouse_SS_cortex/vignette_sep29_2021/6_e_metaheatmap_all_genes.png
   :width: 50.0%

.. container:: cell

   .. code:: r

      plotMetaDataHeatmap(osm_test, expression_values = 'custom',
                          metadata_cols = c('ClusterName'),
                          save_param = c(save_name = '6_f_metaheatmap_all_genes_names'))

.. image:: /images/images_pkgdown/osmFISH_mouse_SS_cortex/vignette_sep29_2021/6_f_metaheatmap_all_genes_names.png
   :width: 50.0%

Part 7: Cell type annotation
============================

Use
`annotateGiotto() <http://giottosuite.com/reference/annotateGiotto.html>`__
to annotate the clusters. For this dataset, we have ClusterName in the
metadata.

Part 8: Spatial grid
====================

.. container:: cell

   .. code:: r

      osm_test <- createSpatialGrid(gobject = osm_test,
                                    sdimx_stepsize = 2000,
                                    sdimy_stepsize = 2000,
                                    minimum_padding = 0)
      spatPlot2D(osm_test, cell_color = 'ClusterName', show_grid = T,

                 grid_color = 'lightblue', spatial_grid_name = 'spatial_grid',
                 point_size = 1.5,
                 save_param = c(save_name = '8_grid_det_cell_types'))

.. image:: /images/images_pkgdown/osmFISH_mouse_SS_cortex/vignette_sep29_2021/8_grid_det_cell_types.png
   :width: 50.0%

Part 9: Spatial network
=======================

.. container:: cell

   .. code:: r

      osm_test <- createSpatialNetwork(gobject = osm_test)
      spatPlot2D(gobject = osm_test, show_network = T,
                 network_color = 'blue',
                 point_size = 1.5, cell_color = 'ClusterName', legend_symbol_size = 2,
                 save_param = c(save_name = '9_spatial_network_k10'))

.. image:: /images/images_pkgdown/osmFISH_mouse_SS_cortex/vignette_sep29_2021/9_spatial_network_k10.png
   :width: 50.0%

Part 10: Spatial genes
======================

.. container:: cell

   .. code:: r

      # km binarization
      kmtest = binSpect(osm_test, calc_hub = T, hub_min_int = 5,
                        bin_method = 'kmeans')

      spatDimFeatPlot2D(osm_test, expression_values = 'scaled',
                     feats = kmtest$feats[1:3], plot_alignment = 'horizontal',
                     cow_n_col = 1,
                     save_param = c(save_name = '10_a_spatial_genes_km'))

.. image:: /images/images_pkgdown/osmFISH_mouse_SS_cortex/vignette_sep29_2021/10_a_spatial_genes_km.png
   :width: 50.0%

Part 12. cell-cell preferential proximity
=========================================

.. container:: cell

   .. code:: r

      ## calculate frequently seen proximities
      cell_proximities = cellProximityEnrichment(gobject = osm_test,
                                                 cluster_column = 'ClusterName',
                                                 number_of_simulations = 1000)
      ## barplot
      cellProximityBarplot(gobject = osm_test, CPscore = cell_proximities, min_orig_ints = 25, min_sim_ints = 25,
                           save_param = c(save_name = '12_a_barplot_cell_cell_enrichment'))

.. image:: /images/images_pkgdown/osmFISH_mouse_SS_cortex/vignette_sep29_2021/12_a_barplot_cell_cell_enrichment.png
   :width: 50.0%

.. container:: cell

   .. code:: r

      ## heatmap
      cellProximityHeatmap(gobject = osm_test, CPscore = cell_proximities, order_cell_types = T, scale = T,
                           color_breaks = c(-1.5, 0, 1.5), color_names = c('blue', 'white', 'red'),
                           save_param = c(save_name = '12_b_heatmap_cell_cell_enrichment', unit = 'in'))

.. image:: /images/images_pkgdown/osmFISH_mouse_SS_cortex/vignette_sep29_2021/12_b_heatmap_cell_cell_enrichment.png
   :width: 50.0%

.. container:: cell

   .. code:: r

      ## network
      cellProximityNetwork(gobject = osm_test, CPscore = cell_proximities, remove_self_edges = F, only_show_enrichment_edges = T,
                           save_param = c(save_name = '12_c_network_cell_cell_enrichment'))

.. image:: /images/images_pkgdown/osmFISH_mouse_SS_cortex/vignette_sep29_2021/12_c_network_cell_cell_enrichment.png
   :width: 50.0%

.. container:: cell

   .. code:: r

      ## visualization
      spec_interaction = "Astrocyte_Mfge8--Oligodendrocyte_Precursor_cells"
      cellProximitySpatPlot(gobject = osm_test,
                            interaction_name = spec_interaction,
                            cluster_column = 'ClusterName',
                            cell_color = 'ClusterName', cell_color_code = c('Astrocyte_Mfge8' = 'blue', 'Oligodendrocyte_Precursor_cells' = 'red'),
                            coord_fix_ratio = 0.5,  point_size_select = 3, point_size_other = 1.5,
                            save_param = c(save_name = '12_d_cell_cell_enrichment_selected'))

.. image:: /images/images_pkgdown/osmFISH_mouse_SS_cortex/vignette_sep29_2021/12_d_cell_cell_enrichment_selected.png
   :width: 50.0%
