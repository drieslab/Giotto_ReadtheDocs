.. raw:: html

    <script type="text/javascript">
    if (String(window.location).indexOf("readthedocs") !== -1) {
        window.alert('This example has been moved. I will redirect you to the new location.');
        window.location.replace('https://drieslab.github.io/Giotto_website/articles/dimension_reduction.html');
    }
    </script>

==================================
Dimension Reduction and Clustering
==================================

:Date: 2022-10-12

This tutorial walks through the dimension reduction and clustering
capabilities of Giotto and begins with the Giotto Object processed in
the previous tutorial, `data processing <./data_processing.html>`__. For
convenience, the code to create this object is provided below. However,
new users are encouraged to review the data processing tutorial prior to
beginning this tutorial.

This tutorial uses a SeqFISH+ dataset of a murine cortex and
subventrical zone. A complete walkthrough of that dataset can be found
`here <../datasets/seqFISH_cortex.html>`__. To download the data used to
create the Giotto Object below, please ensure that
`wget <https://www.gnu.org/software/wget/?>`__ is installed locally.

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

1. Creating and Processing a Giotto Object
==========================================

.. container:: cell

   .. code:: r

      library(Giotto)
      library(GiottoData)

      # Specify path from which data may be retrieved/stored
      data_directory = paste0(getwd(),'/gobject_clustering_data/')
      # alternatively, "/path/to/where/the/data/lives/"

      # Specify path to which results may be saved
      results_directory = paste0(getwd(),'/gobject_clustering_results/')
      # alternatively, "/path/to/store/the/results/"

      # Optional: Specify a path to a Python executable within a conda or miniconda
      # environment. If set to NULL (default), the Python executable within the previously
      # installed Giotto environment will be used.
      my_python_path = NULL # alternatively, "/local/python/path/python" if desired.

      getSpatialDataset(dataset = 'seqfish_SS_cortex', directory = data_directory, method = 'wget')

      # Set Giotto instructions
      instrs = createGiottoInstructions(save_plot = TRUE,
                                        show_plot = TRUE,
                                        save_dir = results_directory,
                                        python_path = my_python_path)

      # Create giotto object from provided paths
      expr_path = paste0(data_directory, "cortex_svz_expression.txt")
      loc_path = paste0(data_directory, "cortex_svz_centroids_coord.txt")
      meta_path = paste0(data_directory, "cortex_svz_centroids_annot.txt")


      # This dataset contains multiple field of views which need to be stitched together.

      # First, merge location and additional metadata
      SS_locations = data.table::fread(loc_path)
      cortex_fields = data.table::fread(meta_path)
      SS_loc_annot = data.table::merge.data.table(SS_locations, cortex_fields, by = 'ID')
      SS_loc_annot[, ID := factor(ID, levels = paste0('cell_',1:913))]
      data.table::setorder(SS_loc_annot, ID)

      # Create a file with offset information
      my_offset_file = data.table::data.table(field = c(0, 1, 2, 3, 4, 5, 6),
                                              x_offset = c(0, 1654.97, 1750.75, 1674.35, 675.5, 2048, 675),
                                              y_offset = c(0, 0, 0, 0, -1438.02, -1438.02, 0))

      # Create a file to stitch the multiple fields of view together
      stitch_file = stitchFieldCoordinates(location_file = SS_loc_annot,
                                           offset_file = my_offset_file,
                                           cumulate_offset_x = T,
                                           cumulate_offset_y = F,
                                           field_col = 'FOV',
                                           reverse_final_x = F,
                                           reverse_final_y = T)
      stitch_file    = stitch_file[,.(ID, X_final, Y_final)]
      stitch_file$ID = as.character(stitch_file$ID) # ID must be a character vector
      my_offset_file = my_offset_file[,.(field, x_offset_final, y_offset_final)]

      # Create Giotto object
      testobj <- createGiottoObject(expression = expr_path,
                                    spatial_locs = stitch_file,
                                    offset_file = my_offset_file,
                                    instructions = instrs)

      # Add additional annotation if wanted
      testobj = addCellMetadata(testobj,
                                new_metadata = cortex_fields,
                                by_column = T,
                                column_cell_ID = 'ID')

      # Subset data to the cortex field of views in a new Giotto object
      cell_metadata = pDataDT(testobj)
      cortex_cell_ids = cell_metadata[FOV %in% 0:4]$cell_ID
      testobj = subsetGiotto(testobj, cell_ids = cortex_cell_ids)

      # Process the Giotto object, filtering, normalization, adding statistics and correcting for covariates
      testobj <- processGiotto(testobj,
                               filter_params = list(expression_threshold = 1,
                                                    feat_det_in_min_cells = 100,
                                                    min_det_feats_per_cell = 10),
                               norm_params = list(norm_methods = 'standard',
                                                  scale_feats = TRUE,
                                                  scalefactor = 6000),
                               stat_params = list(expression_values = 'normalized'),
                               adjust_params = list(expression_values = c('normalized'),
                                                    covariate_columns = 'nr_feats'))

2. Dimension Reduction and PCA
==============================

Highly variable features (genes) may be computed based on high
coefficient of variance within groups, variance of pearson residuals for
each gene, or loess regression predictions. Specify the desired
computation with the **method** parameter.

.. container:: cell

   .. code:: r

      # Calculate HVF using coefficient of variance within groups
      testobj <- calculateHVF(gobject = testobj, method = 'cov_groups')

.. image:: /images/images_pkgdown/getting_started_figs/dimension_reduction/0-HVFplot_covgroups.png
   :width: 50.0%

.. container:: cell

   .. code:: r

      # Calculate HVF using variance of Pearson residuals
      testobj <- calculateHVF(gobject = testobj, method = 'var_p_resid')

.. image:: /images/images_pkgdown/getting_started_figs/dimension_reduction/1-HVFplot_varpresid.png
   :width: 50.0%

.. container:: cell

   .. code:: r

      #calculate HVF using the loess regression prediction model
      testobj <- calculateHVF(gobject = testobj, method = 'cov_loess')

.. image:: /images/images_pkgdown/getting_started_figs/dimension_reduction/2-HVFplot_covloess.png
   :width: 50.0%

PCA can be run based on the highly variable genes. After PCA, a tSNE, a
UMAP, or both may be run. For this example, highly variable genes have
been identified using Loess Regression predictions.

.. container:: cell

   .. code:: r

      ## Select genes highly variable genes that fit specified statistics
      # These are both found within feature metadata
      feature_metadata = fDataDT(testobj)
      featgenes = feature_metadata[hvf == 'yes' & perc_cells > 4 & mean_expr_det > 0.5]$feat_ID

      ## run PCA on expression values (default)
      testobj <- runPCA(gobject = testobj, feats_to_use = featgenes, scale_unit = F, center = F)

      # plot a scree plot
      screePlot(testobj)

.. image:: /images/images_pkgdown/getting_started_figs/dimension_reduction/3-screePlot.png
   :width: 50.0%

.. container:: cell

   .. code:: r

      # Plot a PCA
      plotPCA(gobject = testobj)

.. image:: /images/images_pkgdown/getting_started_figs/dimension_reduction/4-PCA.png
   :width: 50.0%

.. container:: cell

   .. code:: r

      # Run a tSNE based on PCA dimension reduction
      testobj <- runtSNE(testobj, dimensions_to_use = 1:15)
      # Plot tSNE of data
      plotTSNE(gobject = testobj)

.. image:: /images/images_pkgdown/getting_started_figs/dimension_reduction/5-tSNE.png
   :width: 50.0%

.. container:: cell

   .. code:: r

      # Run a UMAP based on PCA dimension reduction
      testobj <- runUMAP(testobj, dimensions_to_use = 1:15)
      # View pre-clustering UMAP
      plotUMAP(gobject = testobj)

.. image:: /images/images_pkgdown/getting_started_figs/dimension_reduction/6-UMAP.png
   :width: 50.0%

3. Clustering
=============

Cells may be clustered into distinct groups based on feature expression.
To cluster, the Giotto Object must contain data that has undergone PCA
dimension reduction, either tSNE or UMAP dimension reduction, and have a
neighbor network.

.. container:: cell

   .. code:: r

      ## create a shared nearest neighbor network (sNN), where k is the number of k neighbors to use
      testobj <- createNearestNetwork(gobject = testobj, dimensions_to_use = 1:15, k = 15)

Cells can be clustered in Giotto using k-means, Leiden, or Louvain
clustering. These clustering algorithms return cluster information
within cell_metadata, which is named accordingly by default. The name
may be changed by providing the name argument, as shown in the code
chunk below.

Naming clusters allows for clusters of various resolutions to be created
if desired, and assists in visualization; cluster names may be provided
as an argument to cell_color within plotUMAP for enhanced visualization.

.. container:: cell

   .. code:: r

      ## k-means clustering
      testobj <- doKmeans(gobject = testobj, dim_reduction_to_use = 'pca')

      ## Leiden clustering - increase the resolution to increase the number of clusters
      testobj <- doLeidenCluster(gobject = testobj,
                                 resolution = 0.4,
                                 n_iterations = 1000,
                                 name = 'leiden_0.4_1000')

      ## Louvain clustering - increase the resolution to increase the number of clusters
      # The version argument may be changed to 'multinet' to run a Louvain algorithm
      # from the multinet package in R.
      testobj <- doLouvainCluster(gobject = testobj,
                                  version = 'community',
                                  resolution = 0.4)

      #Plot UMAP post-clustering to visualize Leiden clusters
      plotUMAP(gobject = testobj,
               cell_color = 'leiden_0.4_1000',
               show_NN_network = T,
               point_size = 2.5)

.. image:: /images/images_pkgdown/getting_started_figs/dimension_reduction/7-UMAP.png
   :width: 50.0%

Clusters of interest can be further sub-clustered. Choose the clusters
to be sub-clustered with the **selected_clusters** argument. Note that
the same HVF method selection and PCA parameters are used here for
consistent sub-clustering.

.. container:: cell

   .. code:: r

      ## Leiden subclustering for specified clusters
      testobj = doLeidenSubCluster(gobject = testobj,
                                   cluster_column = 'leiden_0.4_1000',
                                   resolution = 0.2,
                                   k_neighbors = 10,
                                   hvf_param = list(method = 'cov_loess',
                                                    difference_in_cov = 0.1),
                                   pca_param = list(expression_values = 'normalized',
                                                    scale_unit = F,
                                                    center = F),
                                   nn_param = list(dimensions_to_use = 1:5),
                                   selected_clusters = c(5, 6, 7),
                                   name = 'sub_leiden_clus_select')

      #Plot a UMAP to visualize sub-clusters
      plotUMAP(gobject = testobj, cell_color = 'sub_leiden_clus_select', show_NN_network = T)

.. image:: /images/images_pkgdown/getting_started_figs/dimension_reduction/12-UMAP.png
   :width: 50.0%
