**********************************************
WEBSITE UPDATE! PLEASE USE THE NEW WEBSITE
**********************************************

This website is outdated and will be terminated on May 1st 2025. Please visit www.giottosuite.com for more information.

===========================================
An introduction to the Giotto Suite classes
===========================================

:Date: 2023-07-26

*Giotto* is a technique-agnostic framework and toolbox for spatial-omic
analysis. Its structure and classes are designed to be flexible,
intuitive, and readable. The framework supports working with both
aggregate (cell x count) and un-aggregated spatial data where the
polygon annotations are separate from the spatial expression data.

1. Giotto Object Structure
==========================

Usage of the *Giotto* package revolves around the ``giotto`` object.
This is an S4 class that holds spatial expression data and facilitates
its manipulation and visualization with the *Giotto* package’s
functions. Additional metadata and other outputs generated from certain
functions, which may be used in downstream analyses, are also be stored
within the ``giotto`` object. Its self-contained nature provides a
convenient representation of the entire spatial experiment and is why
most *Giotto* functions take a given ``giotto`` object as input and
return a ``giotto`` object as output.

| Data is organized within the ``giotto`` object in defined ``slots`` as
  described in the diagram below.
| |image1|
| |image2|
| |image3|

2. Nested Organization of the Giotto Object
===========================================

Biology happens across multiple scales of size and types of modalities.
While it is possible to simply generate a new object for each
combination of the two, the fact that data from most spatial methods are
both high resolution and spatially contiguous, requires a more flexible
approach that permits the coexistence of multiple spatial units within
the same object. This allows the user to define the spatial unit(s) of
biology that are most relevant to the analysis and re-aggregate the
feature information to those units.

With this organization it is convenient to compare expression across
different spatial units. Additionally, by determining spatial overlaps
between these spatial units, it becomes possible to represent the
hierarchical organization of biological subunits and make queries using
it.

2.1 Spatial unit and feature type
---------------------------------

To accommodate this complexity, information is subnested within many of
the ``giotto`` object’s slots first by ``spat_unit`` (spatial unit) and
then by ``feat_type`` (feature type). This structurally separates each
set of information within *Giotto*\ ’s framework so that there is
minimal ambiguity.

A summary of what information the object contains can be viewed by
directly returning it.

.. container:: cell

   .. code:: r

      library(Giotto)
      library(GiottoData)
      library(data.table)

      vizmini = loadGiottoMini('vizgen')

.. container:: cell

   .. code:: r

      vizmini

   .. container:: cell-output cell-output-stdout

      ::

         An object of class giotto
         >Active spat_unit:  z0
         >Active feat_type:  rna
         [SUBCELLULAR INFO]
         polygons      : z0 z1 aggregate
         features      : rna
         [AGGREGATE INFO]
         expression -----------------------
           [z0][rna] raw
           [z1][rna] raw
           [aggregate][rna] raw normalized scaled pearson
         spatial locations ----------------
           [z0] raw
           [z1] raw
           [aggregate] raw
         spatial networks -----------------
           [aggregate] Delaunay_network kNN_network
         spatial enrichments --------------
           [aggregate][rna] cluster_metagene
         dim reduction --------------------
           [aggregate][rna] pca umap tsne
         nearest neighbor networks --------
           [aggregate][rna] sNN.pca
         attached images ------------------
         giottoLargeImage : 4 items...


         Use objHistory() to see steps and params used

Included below is a description of the ``giotto`` object subnesting for
each data slot and also the accessor functions for setting and getting
information from them.


.. role:: pink
.. role:: blue
.. role:: purple
.. role:: magenta
.. role:: orange


.. list-table:: Slots and Subnesting
   :widths: 35 15 15 35
   :header-rows: 1
   :class: tight-table

   * - Slot
     - Nested
     - Example
     - Internal Accessors
   * - **@expression**
     - :blue:`spat_unit` - :pink:`feat_type` -  :magenta:`name`
     - :blue:`cell` - :pink:`rna` - :magenta:`raw`
     - getExpression()
       setExpression()
   * - **@cell_metadata**
     - :blue:`spat_unit` - :pink:`feat_type`
     - :blue:`cell` - :pink:`rna`
     - getCellMetadata()
       setCellMetadata()
   * - **@feat_metadata**
     - :blue:`spat_unit` - :pink:`feat_type`
     - :blue:`cell` - :pink:`rna`
     - getFeatMetadata()
       setFeatMetadata()
   * - **@spatial_grid**
     - :blue:`spat_unit` - :magenta:`name`
     - :blue:`grid`- :magenta:`grid`
     - getSpatialGrid()
       setSpatialGrid()
   * - **@dimension_reduction**
     - :purple:`approach` - :blue:`spat_unit` - :pink:`feat_type` - :orange:`method` - :magenta:`name`
     - :purple:`cells` - :blue:`cell` - :pink:`rna` - :orange:`pca` - :magenta:`pca`
     - getDimReduction()
       setDimReduction()
   * - **@multiomics**
     - :blue:`spat_unit` - :pink:`feat_type` - :orange:`method` - :magenta:`name`
     - :blue:`cell` :pink:`rna-protein` - :orange:`WNN` - :magenta:`theta_weighted_matrix`
     - getMultiomics()
       setMultiomics()
   * - **@nn_network**
     - :blue:`spat_unit`- :orange:`method` -:magenta:`name`
     - :blue:`cell`- :orange:`sNN` - :magenta:`sNN_results1`
     - getNearestNetwork()
       setNearestNetwork()
   * - **@spatial_enrichment**
     - :blue:`spat_unit` - :pink:`feat_type` - :magenta:`name`
     - :blue:`cell` - :pink:`rna` - :magenta:`results1`
     - getSpatialEnrichment()
       setSpatialEnrichment()
   * - **@spatial_info**
     - :blue:`spat_unit`
     - :blue:`cell`
     - getPolygonInfo()
       setPolygonInfo()
   * - **@spatial_locs**
     - :blue:`spat_unit` - :magenta:`name`
     - :blue:`cell`- :magenta:`raw`
     - getSpatialLocations()
       setSpatialLocations()
   * - **@spatial_network**
     - :blue:`spat_unit` - :magenta:`name`
     - :blue:`cell`- :magenta:`Delaunay_network1`
     - getSpatialNetwork()
       setSpatialNetwork()
   * - **@feat_info**
     - :pink:`feat_type`
     - :pink:`rna`
     - getFeatureInfo
       setFeatureInfo
   * - **@images**
     - :magenta:`name`
     - :magenta:`image`
     - getGiottoImage()
       setGiottoImage()
   * - **@largeImages**
     - :magenta:`name`
     - :magenta:`image`
     - getGiottoImage()
       setGiottoImage()
   * - **@instructions**
     -
     -
     - instructions()





2.2 Show and list functions
---------------------------

Show and list functions are also provided for determining what
information exists within each of these slots and its nesting.

-  ``show`` functions print a preview of all the data within the slot,
   but do not return information

.. container:: cell

   .. code:: r

      showGiottoSpatLocs(vizmini)

   .. container:: cell-output cell-output-stdout

      ::

         ├──Spatial unit "z0"
         │  └──S4 spatLocsObj "raw" coordinates:   (498 rows)
         │        An object of class spatLocsObj
         │        provenance: z0
         │            ------------------------
         │              sdimx     sdimy                                 cell_ID
         │        1: 6405.067 -4780.499  40951783403982682273285375368232495429
         │        2: 6426.020 -4972.519 240649020551054330404932383065726870513
         │        3: 6428.456 -4799.158 274176126496863898679934791272921588227
         │        4: 6408.155 -4816.583 323754550002953984063006506310071917306
         │
         │        ranges:
         │                sdimx     sdimy
         │        [1,] 6402.438 -5146.726
         │        [2,] 6899.203 -4700.157
         │
         │
         │
         ├──Spatial unit "z1"
         │  └──S4 spatLocsObj "raw" coordinates:   (504 rows)
         │        An object of class spatLocsObj
         │        provenance: z1
         │            ------------------------
         │              sdimx     sdimy                                 cell_ID
         │        1: 6404.014 -4779.625  40951783403982682273285375368232495429
         │        2: 6408.296 -4970.794  17685062374745280598492217386845129350
         │        3: 6401.148 -4991.061 223553142498364321238189328942498473503
         │        4: 6430.153 -4971.251 240649020551054330404932383065726870513
         │
         │        ranges:
         │                sdimx     sdimy
         │        [1,] 6401.148 -5147.193
         │        [2,] 6899.323 -4700.410
         │
         │
         │
         └──Spatial unit "aggregate"
            └──S4 spatLocsObj "raw" coordinates:   (461 rows)
                  An object of class spatLocsObj
                  provenance: z0 z1
                      ------------------------
                        sdimx     sdimy                                 cell_ID
                  1: 6637.881 -5140.465 100210519278873141813371229408401071444
                  2: 6471.978 -4883.541 101161259912191124732236989250178928032
                  3: 6801.610 -4968.685 101488859781016188084173008420811094152
                  4: 6789.055 -5105.338 101523780333017320796881555775415156847

                  ranges:
                          sdimx     sdimy
                  [1,] 6401.412 -5146.747
                  [2,] 6899.108 -4700.326




-  ``list`` functions are (internal) functions that return a
   ``data.table`` of the available information and nesting.

.. container:: cell

   .. code:: r

      Giotto:::list_expression(vizmini)

   .. container:: cell-output cell-output-stdout

      ::

            spat_unit feat_type       name
         1:        z0       rna        raw
         2:        z1       rna        raw
         3: aggregate       rna        raw
         4: aggregate       rna normalized
         5: aggregate       rna     scaled
         6: aggregate       rna    pearson

   .. code:: r

      # Find specific spat_unit objects #
      Giotto:::list_expression(vizmini, spat_unit = 'z0')

   .. container:: cell-output cell-output-stdout

      ::

            spat_unit feat_type name
         1:        z0       rna  raw

-  ``list names`` (internal) functions return a ``vector`` of object
   names at the specified nesting

.. container:: cell

   .. code:: r

      Giotto:::list_expression_names(vizmini, spat_unit = 'z1', feat_type = 'rna')

   .. container:: cell-output cell-output-stdout

      ::

         [1] "raw"

2.3 Provenance
--------------

Going further, sometimes different sources of information can be used
when aggregating to a particular spatial unit. This is most easily shown
with the subcellular datasets from the Vizgen MERSCOPE platform which
provide both feature polygon information for multiple confocal planes
within a tissue. The aggregated information produced then could be drawn
from different z-planes or combinations thereof. Giotto tracks this
provenance information for each set of aggregated data.

.. container:: cell

   .. code:: r

      expr_mat = getExpression(vizmini, spat_unit = 'aggregate')
      prov(expr_mat)

   .. container:: cell-output cell-output-stdout

      ::

         [1] "z0" "z1"

:math:`-`

3. Giotto subobjects
====================

| *Giotto* 3.0 update introduced S4 subobjects that are used within the
  ``giotto`` object and its processing. These subobjects provide more
  formalized definitions for what information and formatting is needed
  in each of the ``giotto`` object slots in order for it to be
  functional. These objects are standalone and extensible and commonly
  used spatial manipulation and plotting methods are being implemented
  for them.
| In addition, these subobjects carry several pieces of metadata in
  additional slots alongside the main information (e.g. also slots for
  ``spat_unit`` and ``feat_type`` alongside the ``exprDT`` slot for the
  ``exprObj`` S4). This makes it so that nesting information is retained
  when they are taken out of the ``giotto`` object and that nesting
  information does not need to be supplied anymore when interacting with
  the ``setter`` functions.

``getter`` functions now have an ``output`` param that **defaults** to
extracting the information from the ``giotto`` object as the S4
subobject. When extracting information that will be modified and then
returned to the ``giotto`` object, it is preferred that the information
is extracted as the S4 both so that tagged information is not lost, and
because it is convenient to work with the S4’s main data slot through
the ``[`` and ``[<-`` generics (see
`Section 3.5 <#sec-working_with_subobjects>`__).

3.1 Creating an S4 subobject
----------------------------

3.1.1 Constructors
~~~~~~~~~~~~~~~~~~

For directly creating a subobject, constructor functions can be used.

.. raw:: html

   <details>

.. raw:: html

   <summary>

constructors

.. raw:: html

   </summary>

``createExprObj()``
``createCellMetaObj()``
``createFeatMetaObj()``
``createDimObj()``
``createNearestNetObj()``
``createSpatLocsObj()``
``createSpatNetObj()``
``createSpatEnrObj()``
``createSpatialGrid()``
``createGiottoPoints()``
``createGiottoPolygonsFromDfr()``
``createGiottoPolygonsFromMask()``
``createGiottoImage()``
``createGiottoLargeImage()``

.. raw:: html

   </details>

.. container:: cell

   .. code:: r

      coords = data.table(
        sdimx = c(1,2,3),
        sdimy = c(1,2,3),
        cell_ID = c('A','B','C')
      )

      st = createSpatLocsObj(name = 'test',
                             spat_unit = 'cell',
                             coordinates = coords,
                             provenance = 'cell')

   .. container:: cell-output cell-output-stderr

      ::

         There are non numeric or integer columns for the spatial location input at
          column position(s): 3
          The first non-numeric column will be considered as a cell ID to test for
          consistency with the expression matrix
          Other non numeric columns will be removed

   .. code:: r

      print(st)

   .. container:: cell-output cell-output-stdout

      ::

         An object of class spatLocsObj : "test"
         spat_unit : "cell"
         provenance: cell
            ------------------------

         preview:
            sdimx sdimy cell_ID
         1:     1     1       A
         2:     2     2       B
         3:     3     3       C

         ranges:
              sdimx sdimy
         [1,]     1     1
         [2,]     3     3

3.1.2 Readers
~~~~~~~~~~~~~

Alternatively, read functions can be used to take named nested lists of
raw data input and convert them to lists of subobjects which are
directly usable by the setter functions.

.. raw:: html

   <details>

.. raw:: html

   <summary>

readers

.. raw:: html

   </summary>

``readPolygonData()``
``readFeatData()``
``readExprData()``
``readCellMetadata()``
``readFeatMetadata()``
``readSpatLocsData()``
``readSpatNetData()``
``readSpatEnrichData()``
``readDimReducData()``
``readNearestNetData()``

.. raw:: html

   </details>

.. container:: cell

   .. code:: r

      st2 = readSpatLocsData(list(cell2 = list(test1 = coords,
                                               test2 = coords)))

   .. container:: cell-output cell-output-stderr

      ::

         list depth of 2

   .. container:: cell-output cell-output-stderr

      ::


         List item [1]:
          spat_unit: cell2
          name: test1

   .. container:: cell-output cell-output-stderr

      ::

         There are non numeric or integer columns for the spatial location input at
          column position(s): 3
          The first non-numeric column will be considered as a cell ID to test for
          consistency with the expression matrix
          Other non numeric columns will be removed

   .. container:: cell-output cell-output-stderr

      ::


         List item [2]:
          spat_unit: cell2
          name: test2

   .. container:: cell-output cell-output-stderr

      ::

         There are non numeric or integer columns for the spatial location input at
          column position(s): 3
          The first non-numeric column will be considered as a cell ID to test for
          consistency with the expression matrix
          Other non numeric columns will be removed

   .. code:: r

      print(st2)

   .. container:: cell-output cell-output-stdout

      ::

         [[1]]
         An object of class spatLocsObj : "test1"
         spat_unit : "cell2"
         provenance: cell2
            ------------------------

         preview:
            sdimx sdimy cell_ID
         1:     1     1       A
         2:     2     2       B
         3:     3     3       C

         ranges:
              sdimx sdimy
         [1,]     1     1
         [2,]     3     3



         [[2]]
         An object of class spatLocsObj : "test2"
         spat_unit : "cell2"
         provenance: cell2
            ------------------------

         preview:
            sdimx sdimy cell_ID
         1:     1     1       A
         2:     2     2       B
         3:     3     3       C

         ranges:
              sdimx sdimy
         [1,]     1     1
         [2,]     3     3

3.2 Giotto Accessors
--------------------

*Giotto* provides ``getter`` and ``setter`` functions for manually
accessing the information contained within the ``giotto`` object. Note
that the ``setters`` require that the data be provided as compatible S4
subobjects or lists thereof. External data can read into the appropriate
formats using the above ``reader`` functions. The ``getter`` functions
return S4 subobjects by default.

.. raw:: html

   <details>

.. raw:: html

   <summary>

getters

.. raw:: html

   </summary>

``getExpression()``
``getCellMetadata()``
``getFeatMetadata()``
``getSpatialLocations()``
``getDimReduction()``
``getNearestNetwork()``
``getSpatialNetwork()``
``getPolygonInfo()``
``getFeatureInfo()``
``getSpatialEnrichment()``
``getGiottoImage()``

.. raw:: html

   </details>

.. raw:: html

   <details>

.. raw:: html

   <summary>

setters

.. raw:: html

   </summary>

``setExpression()``
``setCellMetadata()``
``setFeatureMetadata()``
``setSpatialLocations()``
``setDimReduction()``
``setNearestNetwork()``
``setSpatialNetwork()``
``setPolygonInfo()``
``setFeatureInfo()``
``setSpatialEnrichment()``
``setGiottoImage()``

.. raw:: html

   </details>

.. container:: cell

   .. code:: r

      expval = getExpression(vizmini)
      print(expval)

   .. container:: cell-output cell-output-stdout

      ::

         An object of class exprObj : "raw"
         spat_unit : "z0"
         feat_type : "rna"
         provenance: z0

         contains:
         336 x 498 sparse Matrix of class "dgCMatrix"

         Adora1 . . . . . . . . . . 1 . . ......
         Adgrb1 . . . . 1 . . . . . . . . ......
         Adgrb3 . . . . . . . . . . 1 3 . ......

          ........suppressing 485 columns and 330 rows

         Blank-128 . . . . . . . . . . . . . ......
         Blank-145 . . . . . . . . . . . . . ......
         Gpr101    . . . . . . . . . . . . . ......

          First four colnames:
          40951783403982682273285375368232495429
          240649020551054330404932383065726870513
          274176126496863898679934791272921588227
          323754550002953984063006506310071917306

3.3 Get and set S4 spat_unit, feat_type, provenance
---------------------------------------------------

``spatUnit()``, ``featType()``, and ``prov()`` are replacement functions
for tagged spatial unit, feature type, and provenance information
respectively.

.. container:: cell

   .. code:: r

      # spat_unit
      spatUnit(expval) <- 'new_spat'
      spatUnit(expval)

   .. container:: cell-output cell-output-stdout

      ::

         [1] "new_spat"

   .. code:: r

      # feat_type
      featType(expval) <- 'new_feat'
      featType(expval)

   .. container:: cell-output cell-output-stdout

      ::

         [1] "new_feat"

   .. code:: r

      # provenance
      prov(expval) <- 'cell'
      prov(expval)

   .. container:: cell-output cell-output-stdout

      ::

         [1] "cell"

3.4 Setting an S4 subobject
---------------------------

The ``spat_unit``, ``feat_type``, and ``name`` params no longer need to
be given when setting an S4 subobject with tagged information into a
``giottoObject``. However, if input is given to the ``set`` function
parameters then it is prioritized over the tagged information and the
tagged information is updated.

.. container:: cell

   .. code:: r

      # set exprObj to tagged nesting location
      vizmini <- setExpression(vizmini, expval)

   .. container:: cell-output cell-output-stderr

      ::

         Setting expression [new_spat][new_feat] raw

   .. code:: r

      Giotto:::list_expression(vizmini)

   .. container:: cell-output cell-output-stdout

      ::

            spat_unit feat_type       name
         1:        z0       rna        raw
         2:        z1       rna        raw
         3: aggregate       rna        raw
         4: aggregate       rna normalized
         5: aggregate       rna     scaled
         6: aggregate       rna    pearson
         7:  new_spat  new_feat        raw

.. _sec-working_with_subobjects:

3.5 Working with S4 subobjects
------------------------------

Giotto’s S4 subobjects each wrap one main data object. The empty ``[]``
and ``[]<-`` operators are defined as shorthand for directly accessing
this slot that contains the data. For example, with a ``spatLocsObj``:

``class(spatLocsObj[])`` is equivalent to
``class(spatLocsObj@coordinates)``

In this way, the S4 subobjects can be used in contexts that the wrapped
objects could be.

.. container:: cell

   .. code:: r

      st = getSpatialLocations(vizmini)
      class(st)

   .. container:: cell-output cell-output-stdout

      ::

         [1] "spatLocsObj"
         attr(,"package")
         [1] "Giotto"

   .. code:: r

      # With empty brackets
      class(st[])

   .. container:: cell-output cell-output-stdout

      ::

         [1] "data.table" "data.frame"

**Setting information**

.. container:: cell

   .. code:: r

      print(st)

   .. container:: cell-output cell-output-stdout

      ::

         An object of class spatLocsObj : "raw"
         spat_unit : "z0"
         provenance: z0
            ------------------------

         preview:
                 sdimx     sdimy                                 cell_ID
           1: 6405.067 -4780.499  40951783403982682273285375368232495429
           2: 6426.020 -4972.519 240649020551054330404932383065726870513
           3: 6428.456 -4799.158 274176126496863898679934791272921588227
           4: 6408.155 -4816.583 323754550002953984063006506310071917306
           5: 6425.894 -4862.808  87260224659312905497866017323180367450
          ---
         494: 6863.376 -4764.372 264234489423886906860498828392801290668
         495: 6833.515 -4724.922 328891726607418454659643302361160567789
         496: 6829.474 -4755.392   6380671372744430258754116433861320161
         497: 6823.512 -4713.632  75286702783716447443887872812098770697
         498: 6842.534 -4717.261   9677424102111816817518421117250891895

         ranges:
                 sdimx     sdimy
         [1,] 6402.438 -5146.726
         [2,] 6899.203 -4700.157

.. container:: cell

   .. code:: r

      st[] = coords
      print(st)

   .. container:: cell-output cell-output-stdout

      ::

         An object of class spatLocsObj : "raw"
         spat_unit : "z0"
         provenance: z0
            ------------------------

         preview:
            sdimx sdimy cell_ID
         1:     1     1       A
         2:     2     2       B
         3:     3     3       C

         ranges:
              sdimx sdimy
         [1,]     1     1
         [2,]     3     3

4. Session Info
----------------

.. container:: cell

   .. code:: r

      sessionInfo()

   .. container:: cell-output cell-output-stdout

      ::

         R version 4.2.1 (2022-06-23)
         Platform: x86_64-apple-darwin17.0 (64-bit)
         Running under: macOS Big Sur ... 10.16

         Matrix products: default
         BLAS:   /Library/Frameworks/R.framework/Versions/4.2/Resources/lib/libRblas.0.dylib
         LAPACK: /Library/Frameworks/R.framework/Versions/4.2/Resources/lib/libRlapack.dylib

         locale:
         [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8

         attached base packages:
         [1] stats     graphics  grDevices utils     datasets  methods   base

         other attached packages:
         [1] data.table_1.14.8 GiottoData_0.2.2  Giotto_3.3.1

         loaded via a namespace (and not attached):
          [1] Rcpp_1.0.11      pillar_1.9.0     compiler_4.2.1   tools_4.2.1
          [5] digest_0.6.31    jsonlite_1.8.4   evaluate_0.21    lifecycle_1.0.3
          [9] tibble_3.2.1     gtable_0.3.3     lattice_0.20-45  png_0.1-8
         [13] pkgconfig_2.0.3  rlang_1.1.1      igraph_1.4.2     Matrix_1.5-4
         [17] cli_3.6.1        rstudioapi_0.14  parallel_4.2.1   yaml_2.3.7
         [21] xfun_0.39        fastmap_1.1.1    terra_1.7-39     withr_2.5.0
         [25] dplyr_1.1.2      knitr_1.42       generics_0.1.3   vctrs_0.6.2
         [29] rprojroot_2.0.3  grid_4.2.1       tidyselect_1.2.0 here_1.0.1
         [33] reticulate_1.28  glue_1.6.2       R6_2.5.1         fansi_1.0.4
         [37] rmarkdown_2.21   ggplot2_3.4.2    magrittr_2.0.3   scales_1.2.1
         [41] codetools_0.2-18 htmltools_0.5.5  colorspace_2.1-0 utf8_1.2.3
         [45] munsell_0.5.0

.. |image1| image:: /images/images_pkgdown/getting_started_figs/getting_started_gobject/Giotto_suite_object-01.svg
   :width: 100.0%
.. |image2| image:: /images/images_pkgdown/getting_started_figs/getting_started_gobject/Giotto_suite_object-02.svg
   :width: 100.0%
.. |image3| image:: /images/images_pkgdown/getting_started_figs/getting_started_gobject/Giotto_suite_object-03.svg
   :width: 100.0%
