.. raw:: html

    <script type="text/javascript">
    if (String(window.location).indexOf("readthedocs") !== -1) {
        window.alert('This example has been moved. I will redirect you to the new location.');
        window.location.replace('https://drieslab.github.io/Giotto_website/articles/deconvolution.html');
    }
    </script>

==============================
analyses_deconvolution_Oct2021
==============================

:Date: 2022-09-16

| Technologies like Visium spatial transcriptomics does not provide
  single-cell resolution, making cell type annotation a harder problem.
| One barcode of these spatial datasets can be made up of different cell
  types.

| To solve this problem, Giotto provides several ways to calculate
  enrichment of specific cell-type signature gene list:
| Spatial Enrichment:
| -
  `PAGE <https://bmcbioinformatics.biomedcentral.com/articles/10.1186/1471-2105-6-144>`__
| - hypergeometric test
| - Rank
| Spatial Deconvolution:
| - `DWLS
  Deconvolution <https://genomebiology.biomedcentral.com/articles/10.1186/s13059-021-02362-7>`__

| The deconvolution analysis is also a good way to integrate single cell
  RNAseq data with spatial transcriptomics datasets.
| In this example, Corresponded Single cell dataset can be generated
  from `here <http://mousebrain.org/downloads.html>`__.
| Giotto_SC is processed from the downsampled
  `Loom <https://satijalab.org/loomr/loomr_tutorial>`__ file and can
  also be downloaded from getSpatialDataset.

.. container:: cell

   .. code:: r

      # download data to results directory ####
      # if wget is installed, set method = 'wget'
      # if you run into authentication issues with wget, then add " extra = '--no-check-certificate' "
      getSpatialDataset(dataset = 'Mouse_brain_scRNAseq', directory = results_folder)

      sc_expression = paste0(results_folder, "/brain_sc_expression_matrix.txt.gz")
      sc_metadata = paste0(results_folder,"/brain_sc_metadata.csv")

      giotto_SC <- createGiottoObject(
        expression = sc_expression,
        instructions = instrs
      )

      giotto_SC <- addCellMetadata(giotto_SC,
                                   new_metadata = data.table::fread(sc_metadata))

      giotto_SC<- normalizeGiotto(giotto_SC)

PAGE enrichment
===============

.. container:: cell

   .. code:: r

      # Create PAGE matrix
      # PAGE matrix should be a binary matrix with each row represent a gene marker and each column represent a cell type
      # There are several ways to create PAGE matrix
      # 1.1 create binary matrix of cell signature genes
      # small example #
      gran_markers = c("Nr3c2", "Gabra5", "Tubgcp2", "Ahcyl2",
                       "Islr2", "Rasl10a", "Tmem114", "Bhlhe22",
                       "Ntf3", "C1ql2")

      oligo_markers = c("Efhd1", "H2-Ab1", "Enpp6", "Ninj2",
                        "Bmp4", "Tnr", "Hapln2", "Neu4",
                        "Wfdc18", "Ccp110")

      di_mesench_markers = c("Cartpt", "Scn1a", "Lypd6b",  "Drd5",
                             "Gpr88", "Plcxd2", "Cpne7", "Pou4f1",
                             "Ctxn2", "Wnt4")

      PAGE_matrix_1 = makeSignMatrixPAGE(sign_names = c('Granule_neurons',
                                                        'Oligo_dendrocytes',
                                                        'di_mesenchephalon'),
                                         sign_list = list(gran_markers,
                                                          oligo_markers,
                                                          di_mesench_markers))



      # ----

      # 1.2 [shortcut] fully pre-prepared matrix for all cell types
      sign_matrix_path = system.file("extdata", "sig_matrix.txt", package = 'Giotto')
      brain_sc_markers = data.table::fread(sign_matrix_path)
      PAGE_matrix_2 = as.matrix(brain_sc_markers[,-1])
      rownames(PAGE_matrix_2) = brain_sc_markers$Event


      # ---

      # 1.3 make PAGE matrix from single cell dataset
      markers_scran = findMarkers_one_vs_all(gobject=giotto_SC, method="scran",
                                             expression_values="normalized", cluster_column = "Class", min_feats=3)
      top_markers <- markers_scran[, head(.SD, 10), by="cluster"]
      celltypes<-levels(factor(markers_scran$cluster))
      sign_list<-list()
      for (i in 1:length(celltypes)){
        sign_list[[i]]<-top_markers[which(top_markers$cluster == celltypes[i]),]$feats
      }

      PAGE_matrix_3 = makeSignMatrixPAGE(sign_names = celltypes,
                                         sign_list = sign_list)

      # 1.4 enrichment test with PAGE

      # runSpatialEnrich() can also be used as a wrapper for all currently provided enrichment options
      visium_brain = runPAGEEnrich(gobject = visium_brain, sign_matrix = PAGE_matrix_2)

      # 1.5 heatmap of enrichment versus annotation (e.g. clustering result)
      cell_types_PAGE = colnames(PAGE_matrix_2)
      plotMetaDataCellsHeatmap(gobject = visium_brain,
                               metadata_cols = 'leiden_clus',
                               value_cols = cell_types_PAGE,
                               spat_enr_names = 'PAGE',
                               x_text_size = 8,
                               y_text_size = 8)

.. image:: /images/images_pkgdown/mouse_visium_brain/vignette_220328/20-plotMetaDataCellsHeatmap.png
   :width: 50.0%

PAGE enrichment stats will be stored in the
giotto_object@spatial_enrichment slot and can be retrieved by
get_spatial_enrichment. The enrichment result can be visualized by
spatplot by adding the spat_enr_names argument.

.. container:: cell

   .. code:: r

      # 1.6 visualizations
      # Check PAGE enrichment result
      # get_spatial_enrichment(visium_brain,enrichm_name = "PAGE")
      spatCellPlot2D(gobject = visium_brain,
                     spat_enr_names = 'PAGE',
                     cell_annotation_values = cell_types_PAGE[1:4],
                     cow_n_col = 2,coord_fix_ratio = 1, point_size = 1.25, show_legend = T,
                     save_param = list(save_name="spat_enr_PAGE_spatcellplot"))

.. image:: /images/images_pkgdown/mouse_visium_brain/vignette_220328/21-spatCellPlot2D.png
   :width: 50.0%

.. container:: cell

   .. code:: r

      spatDimCellPlot2D(gobject = visium_brain,
                        spat_enr_names = 'PAGE',
                        cell_annotation_values = cell_types_PAGE[1:4],
                        cow_n_col = 1, spat_point_size = 1,
                        plot_alignment = 'horizontal',
                        save_param = list(base_width=7, base_height=10, save_name="spat_enr_PAGE_spatdimplot"))

.. image:: /images/images_pkgdown/mouse_visium_brain/vignette_220328/22-spatDimCellPlot2D.png
   :width: 50.0%

HyperGeometric test
===================

.. container:: cell

   .. code:: r

      #Modify the sparse matrix in normalized slot
      visium_brain = runHyperGeometricEnrich(gobject = visium_brain,
                                             expression_values = "normalized",
                                             sign_matrix = PAGE_matrix_2)

HyperGeometric enrichment stats will be stored in the
giotto_object@spatial_enrichment slot and can be retrieved by
get_spatial_enrichment. The enrichment result can be visualized by
spatplot by adding the spat_enr_names argument.

.. container:: cell

   .. code:: r

      # Check HyperGeometric enrichment result
      # get_spatial_enrichment(visium_brain,enrichm_name = "hypergeometric")
      cell_types_HyperGeometric = colnames(PAGE_matrix_2)
      spatCellPlot(gobject = visium_brain,
                   spat_enr_names = 'hypergeometric',
                   cell_annotation_values = cell_types_HyperGeometric[1:4],
                   cow_n_col = 2,coord_fix_ratio = 1, point_size = 1.75,
                   save_param = list(save_name="spat_enr_HyperGeometric_spatplot"))

.. image:: /images/images_pkgdown/mouse_visium_brain/vignette_220328/23-spatCellPlot2D.png
   :width: 50.0%

Rank
====

This algorithm calculates gene signature enrichment scores per spatial
position using a rank based approach. Rank enrichment stats will be
stored in the giotto_object@spatial_enrichment slot and can be retrieved
by get_spatial_enrichment. The enrichment result can be visualized by
spatplot by adding the spat_enr_names argument.

.. container:: cell

   .. code:: r

      # Create rank matrix, not that rank matrix is different from PAGE
      # A count matrix and a vector for all cell labels will be needed
      rank_matrix = makeSignMatrixRank(sc_matrix = get_expression_values(giotto_SC,values = "normalized"),
                                       sc_cluster_ids = pDataDT(giotto_SC)$Class)
      colnames(rank_matrix)<-levels(factor(pDataDT(giotto_SC)$Class))
      visium_brain = runRankEnrich(gobject = visium_brain, sign_matrix = rank_matrix,expression_values = "normalized")

      # Check Rank enrichment result
      # get_spatial_enrichment(visium_brain,enrichm_name = "rank")

      # Plot Rank enrichment result
      spatCellPlot2D(gobject = visium_brain,
                     spat_enr_names = 'rank',
                     cell_annotation_values = colnames(rank_matrix)[1:4],
                     cow_n_col = 2,coord_fix_ratio = 1, point_size = 1,
                     save_param = list(save_name = "spat_enr_Rank_plot"))

.. image:: /images/images_pkgdown/mouse_visium_brain/vignette_220426/spat_enr_Rank_plot.png
   :width: 50.0%

Deconvolution
=============

DWLS deconvolution stats will be also stored in the
giotto_object@spatial_enrichment slot and can be retrieved by
get_spatial_enrichment. The enrichment result can be visualized by
spatplot by adding the spat_enr_names argument.

.. container:: cell

   .. code:: r

      # Create DWLS matrix, not that DWLS matrix is different from PAGE and rank
      # A count matrix a vector for a list of gene signatures and a vector for all cell labels will be needed
      DWLS_matrix<-makeSignMatrixDWLSfromMatrix(matrix = as.matrix(get_expression_values(giotto_SC,values = "normalized")),
                                                cell_type = pDataDT(giotto_SC)$Class,
                                                sign_gene = top_markers$feats)
      visium_brain = runDWLSDeconv(gobject = visium_brain, sign_matrix = DWLS_matrix)

      # Check DWLS deconvolution result
      # get_spatial_enrichment(visium_brain,enrichm_name = "DWLS")

      # Plot DWLS deconvolution result
      spatCellPlot2D(gobject = visium_brain,
                     spat_enr_names = 'DWLS',
                     cell_annotation_values = levels(factor(pDataDT(giotto_SC)$Class))[1:4],
                     cow_n_col = 2,coord_fix_ratio = 1, point_size = 1,
                     save_param = list(save_name = "DWLS_plot"))

.. image:: /images/images_pkgdown/mouse_visium_brain/vignette_220426/DWLS_plot.png
   :width: 50.0%
