.. raw:: html

    <script type="text/javascript">
    if (String(window.location).indexOf("readthedocs") !== -1) {
        window.alert('This example has been moved. I will redirect you to the new location.');
        window.location.replace('https://drieslab.github.io/Giotto_website/articles/visium_cytassist_human_glioblastoma.html');
    }
    </script>

==========================================
Visium CytAssist Human Glioblastoma (FFPE)
==========================================

:Date: 9/7/23

1 Dataset explanation
=====================

The `Human glioblastoma (FFPE) dataset <https://www.10xgenomics.com/resources/datasets/gene-and-protein-expression-library-of-human-glioblastoma-cytassist-ffpe-2-standard/>`__ was obtained from 10x Genomics. The tissue was sectioned as described in Visium CytAssist Spatial Gene Expression for FFPE – Tissue Preparation Guide Demonstrated Protocol (CG000518). 5 µm tissue sections were placed on Superfrost glass slides, then IF stained following deparaffinization, then hard coverslipped. Sections were imaged, decoverslipped, followed by Demonstrated Protocol (CG000494)

More information about this dataset can be found `here <https://www.10xgenomics.com/resources/datasets/gene-and-protein-expression-library-of-human-glioblastoma-cytassist-ffpe-2-standard>`__.


2 Start Giotto
==============

.. container:: cell

   .. code:: r

      # Ensure Giotto Suite is installed
      if(!"Giotto" %in% installed.packages()) {
        devtools::install_github("drieslab/Giotto")
      }
      library(Giotto)

      # Ensure the Python environment for Giotto has been installed
      genv_exists = checkGiottoEnvironment()
      if(!genv_exists){
        # The following command need only be run once to install the Giotto environment
        installGiottoEnvironment()
      }

.. container:: cell

   .. code:: r

      # 1. set results directory
      results_directory = 'results'

      # 2. set giotto python path
      # set python path to your preferred python version path
      # set python path to NULL if you want to automatically install (only the 1st time) and use the giotto miniconda environment
      python_path = NULL
      if(is.null(python_path)) {
        installGiottoEnvironment()
      }

      # 3. create giotto instructions
      instrs = createGiottoInstructions(save_dir = results_directory,
                                        save_plot = TRUE,
                                        show_plot = TRUE,
                                        python_path = python_path)

3 Create Giotto object
======================

The minimum requirements are

- matrix with expression information (or path to)

- x,y(,z) coordinates for cells or spots (or path to)

createGiottoVisiumObject() will automatically detect both rna and protein modalities within the expression matrix creating a multi-omics Giotto object.

.. container:: cell

   .. code:: r

      # Provide path to visium folder
      data_directory <- 'path/to/visium/data'

      # Create Giotto object
      visium = createGiottoVisiumObject(visium_dir = data_directory,
                                        expr_data = 'raw',
                                        png_name = 'tissue_lowres_image.png',
                                        gene_column_index = 2,
                                        instructions = instrs)

How to work with Giotto instructions that are part of your Giotto object:

- Show the instructions associated with your Giotto object with showGiottoInstructions()
- Change one or more instructions with changeGiottoInstructions()
- Replace all instructions at once with replaceGiottoInstructions()
- Read or get a specific Giotto instruction with readGiottoInstructions()

.. container:: cell

   .. code:: r

      # show instructions associated with the giotto object

      showGiottoInstructions(visium)

4 Processing
============

- Filter features and cells based on detection frequencies
- Normalize expression matrix (log transformation, scaling factor and/or z-scores)
- Add cell and feature statistics (optional)
- Adjust expression matrix for technical covariates or batches (optional).

.. container:: cell

   .. code:: r

      # Subset on spots that were covered by tissue
      metadata = pDataDT(visium)
      in_tissue_barcodes = metadata[in_tissue == 1]$cell_ID
      visium = subsetGiotto(visium, cell_ids = in_tissue_barcodes)

      ## Visualize aligned tissue
      spatPlot2D(gobject = visium,
                 point_alpha = 0.7)

   .. container:: cell-output-display

      .. image:: visium_cytassist_human_glioblastoma_files/1-spatPlot2D.png


   .. code:: r

      # Filtering, normalization, and statistics

      ## RNA feature
      visium <- filterGiotto(gobject = visium,
                             expression_threshold = 1,
                             feat_det_in_min_cells = 50,
                             min_det_feats_per_cell = 1000,
                             expression_values = c('raw'),
                             verbose = TRUE)

      visium <- normalizeGiotto(gobject = visium,
                                scalefactor = 6000,
                                verbose = TRUE)

      visium <- addStatistics(gobject = visium)

      ### Visualize number of features after processing
      spatPlot2D(gobject = visium,
                 point_alpha = 0.7,
                 cell_color = 'nr_feats',
                 color_as_factor = FALSE)

   .. container:: cell-output-display

      .. image:: visium_cytassist_human_glioblastoma_files/2-spatPlot2D.png

      ## Protein feature
      visium <- filterGiotto(gobject = visium,
                             spat_unit = 'cell',
                             feat_type = 'protein',
                             expression_threshold = 1,
                             feat_det_in_min_cells = 50,
                             min_det_feats_per_cell = 1,
                             expression_values = c('raw'),
                             verbose = TRUE)

      visium <- normalizeGiotto(gobject = visium,
                                spat_unit = 'cell',
                                feat_type = 'protein',
                                scalefactor = 6000,
                                verbose = TRUE)

      visium <- addStatistics(gobject = visium,
                              spat_unit = 'cell',
                              feat_type = 'protein')

      ### Visualize number of features after processing
      spatPlot2D(gobject = visium,
                 spat_unit = 'cell',
                 feat_type = 'protein',
                 point_alpha = 0.7,
                 cell_color = 'nr_feats',
                 color_as_factor = FALSE)

   .. container:: cell-output-display

      .. image:: visium_cytassist_human_glioblastoma_files/3-spatPlot2D.png


5 Dimention Reduction
=====================

.. container:: cell

   .. code:: r

      # Identify highly variable features (HVF)
      visium <- calculateHVF(gobject = visium)

   .. container:: cell-output-display

      .. image:: visium_cytassist_human_glioblastoma_files/4-HVFplot.png


   .. code:: r

      # PCA

      ## RNA
      visium <- runPCA(gobject = visium)

      screePlot(visium, ncp = 30)

   .. container:: cell-output-display

      .. image:: visium_cytassist_human_glioblastoma_files/5-screePlot.png

   .. code:: r

      ### Visualize RNA PCA
      plotPCA(gobject = visium)

   .. container:: cell-output-display

      .. image:: visium_cytassist_human_glioblastoma_files/6-PCA.png


   .. code:: r

      ## Protein
      visium <- runPCA(gobject = visium,
                       spat_unit = 'cell',
                       feat_type = 'protein')

      screePlot(visium,
                spat_unit = 'cell',
                feat_type = 'protein',
                ncp = 30)

   .. container:: cell-output-display

      .. image:: visium_cytassist_human_glioblastoma_files/7-screePlot.png


   .. code:: r

      ### Visualize Protein PCA
      plotPCA(gobject = visium,
              spat_unit = 'cell',
              feat_type = 'protein')

   .. container:: cell-output-display

      .. image:: visium_cytassist_human_glioblastoma_files/8-PCA.png


6 Clustering
============

.. container:: cell

   .. code:: r

      # cluster and run UMAP
      # sNN network (default)

      ## RNA feature
      visium <- createNearestNetwork(gobject = visium,
                                     dimensions_to_use = 1:10,
                                     k = 30)

      ## Protein feature
      visium <- createNearestNetwork(gobject = visium,
                                     spat_unit = 'cell',
                                     feat_type = 'protein',
                                     dimensions_to_use = 1:10,
                                     k = 30)

      # Leiden clustering

      ## RNA feature
      visium <- doLeidenCluster(gobject = visium,
                                resolution = 1,
                                n_iterations = 1000)

      ## Protein feature
      visium <- doLeidenCluster(gobject = visium,
                                spat_unit = 'cell',
                                feat_type = 'protein',
                                resolution = 1,
                                n_iterations = 1000)

      # UMAP

      ## RNA feature
      visium <- runUMAP(visium,
                        dimensions_to_use = 1:10)

      plotUMAP(gobject = visium,
               cell_color = 'leiden_clus',
               show_NN_network = TRUE,
               point_size = 2)

   .. container:: cell-output-display

      .. image:: visium_cytassist_human_glioblastoma_files/9-UMAP.png

      ## Protein feature
      visium <- runUMAP(visium,
                        spat_unit = 'cell',
                        feat_type = 'protein',
                        dimensions_to_use = 1:10)

      plotUMAP(gobject = visium,
               spat_unit = 'cell',
               feat_type = 'protein',
               cell_color = 'leiden_clus',
               show_NN_network = TRUE,
               point_size = 2)

   .. container:: cell-output-display

      .. image:: visium_cytassist_human_glioblastoma_files/10-UMAP.png

.. container:: cell

   .. code:: r

      # Visualize spatial plot

      ## RNA feature
      spatPlot2D(gobject = visium,
                 show_image = TRUE,
                 cell_color = 'leiden_clus',
                 point_size = 2)

   .. container:: cell-output-display

      .. image:: visium_cytassist_human_glioblastoma_files/11-rna_spatPlot2D.png

   .. code:: r

      ## Protein feature
      spatPlot2D(gobject = visium,
                 spat_unit = 'cell',
                 feat_type = 'protein',
                 show_image = TRUE,
                 cell_color = 'leiden_clus',
                 point_size = 2)

   .. container:: cell-output-display

      .. image:: visium_cytassist_human_glioblastoma_files/12-protein_spatPlot2D.png


7 Multi-omics integration
======================

The Weighted Nearest Neighbors allows to integrate two or more modalities adquired from the same sample. WNN will re-calculate the clustering to provide an integrated umap and leiden clustering. For running WNN, the Giotto object must contain the results of running PCA calculation for each modality.

.. container:: cell

   .. code:: r

      # Calculate kNN

      ## RNA modality
      visium <- createNearestNetwork(gobject = visium,
                                    type = 'kNN',
                                    dimensions_to_use = 1:10,
                                    k = 20)

      ## Protein modality
      visium <- createNearestNetwork(gobject = visium,
                                    spat_unit = 'cell',
                                    feat_type = 'protein',
                                    type = 'kNN',
                                    dimensions_to_use = 1:10,
                                    k = 20)


      # Run WNN
      visium <- runWNN(visium,
                       spat_unit = "cell",
                       modality_1 = "rna",
                       modality_2 = "protein",
                       pca_name_modality_1 = "pca",
                       pca_name_modality_2 = "protein.pca",
                       k = 20,
                       integrated_feat_type = NULL,
                       matrix_result_name = NULL,
                       w_name_modality_1 = NULL,
                       w_name_modality_2 = NULL,
                       verbose = TRUE)

      # Run Integrated umap
      visium <- runIntegratedUMAP(visium,
                                  modality1 = "rna",
                                  modality2 = "protein",
                                  spread = 5,
                                  min_dist = 0.5,
                                  force = FALSE)

      # Calculate integrated clusters
      visium <- doLeidenCluster(gobject = visium,
                                spat_unit = "cell",
                                feat_type = "rna",
                                nn_network_to_use = "kNN",
                                network_name = "integrated_kNN",
                                name = "integrated_leiden_clus",
                                resolution = 1)

      # Visualize integrated umap
      plotUMAP(gobject = visium,
               spat_unit = "cell",
               feat_type = "rna",
               cell_color = 'integrated_leiden_clus',
               dim_reduction_name = "integrated.umap",
               point_size = 1.5,
               title = "Integrated UMAP using Integrated Leiden clusters",
               axis_title = 12,
               axis_text = 10 )

   .. container:: cell-output-display

      .. image:: visium_cytassist_human_glioblastoma_files/13-UMAP.png

.. container:: cell

   .. code:: r

      # Visualize spatial plot with integrated clusters
      spatPlot2D(visium,
                 spat_unit = "cell",
                 feat_type = "rna",
                 cell_color = "integrated_leiden_clus",
                 point_size = 2,
                 show_image = FALSE,
                 title = "Integrated Leiden clustering")

   .. container:: cell-output-display

      .. image:: visium_cytassist_human_glioblastoma_files/14-integrated_spatPlot2D.png



8 Session Info
==============

.. container:: cell

   .. code:: r

      sessionInfo()

   .. container:: cell-output cell-output-stdout

      ::


         R version 4.3.1 (2023-06-16)
         Platform: x86_64-apple-darwin20 (64-bit)
         Running under: macOS Ventura 13.5.1

         Matrix products: default
         BLAS:   /System/Library/Frameworks/Accelerate.framework/Versions/A                /Frameworks/vecLib.framework/Versions/A/libBLAS.dylib
         LAPACK: /Library/Frameworks/R.framework/Versions/4.3-x86_64/Resources/lib          /libRlapack.dylib;  LAPACK version 3.11.0

         locale:
         [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8

         time zone: America/New_York
         tzcode source: internal

         attached base packages:
         [1] stats     graphics  grDevices utils     datasets  methods   base

         other attached packages:
         [1] Giotto_3.3.2             GiottoVisuals_0.0.0.9002
         [3] GiottoClass_0.0.0.9003   GiottoUtils_0.0.0.9002

         loaded via a namespace (and not attached):
          [1] gtable_0.3.4       xfun_0.40          ggplot2_3.4.3
          [4] htmlwidgets_1.6.2  devtools_2.4.5     remotes_2.4.2.1
          [7] processx_3.8.2     lattice_0.21-8     callr_3.7.3
         [10] vctrs_0.6.3        tools_4.3.1        ps_1.7.5
         [13] generics_0.1.3     parallel_4.3.1     tibble_3.2.1
         [16] fansi_1.0.4        colorRamp2_0.1.0   pkgconfig_2.0.3
         [19] Matrix_1.6-1       data.table_1.14.8  checkmate_2.2.0
         [22] RColorBrewer_1.1-3 lifecycle_1.0.3    farver_2.1.1
         [25] compiler_4.3.1     stringr_1.5.0      textshaping_0.3.6
         [28] munsell_0.5.0      terra_1.7-39       codetools_0.2-19
         [31] httpuv_1.6.11      htmltools_0.5.6    usethis_2.2.2
         [34] yaml_2.3.7         later_1.3.1        pillar_1.9.0
         [37] crayon_1.5.2       urlchecker_1.0.1   ellipsis_0.3.2
         [40] cachem_1.0.8       magick_2.7.5       sessioninfo_1.2.2
         [43] mime_0.12          tidyselect_1.2.0   digest_0.6.33
         [46] stringi_1.7.12     dplyr_1.1.2        purrr_1.0.2
         [49] labeling_0.4.2     cowplot_1.1.1      fastmap_1.1.1
         [52] grid_4.3.1         colorspace_2.1-0   cli_3.6.1
         [55] magrittr_2.0.3     pkgbuild_1.4.2     utf8_1.2.3
         [58] withr_2.5.0        prettyunits_1.1.1  scales_1.2.1
         [61] promises_1.2.1     backports_1.4.1    rmarkdown_2.24
         [64] igraph_1.5.1       reticulate_1.31    ragg_1.2.5
         [67] png_0.1-8          memoise_2.0.1      shiny_1.7.5
         [70] evaluate_0.21      knitr_1.43         miniUI_0.1.1.1
         [73] profvis_0.3.8      rlang_1.1.1        Rcpp_1.0.11
         [76] xtable_1.8-4       glue_1.6.2         pkgload_1.3.2.1
         [79] jsonlite_1.8.7     rstudioapi_0.15.0  R6_2.5.1
         [82] systemfonts_1.0.4  fs_1.6.3



