.. _datasets:

**********************************************
WEBSITE UPDATE! PLEASE USE THE NEW WEBSITE
**********************************************

This website is outdated and will be terminated on May 1st 2025. Please visit www.giottosuite.com for more information.

################################
Tutorials
################################


.. toctree::
    :maxdepth: 1
    :caption: Tutorials
    :hidden:

    Stereo-Seq Mouse Embryo <subsections/datasets/SSeq-E12-5_E1S3-Tutorial>
    Seq-Scope Mouse Liver <subsections/datasets/seqscope_mouse_liver_221115>
    Spatial Genomics Kidney <subsections/datasets/spatial_genomics_kidney>
    Xenium Breast Cancer <subsections/datasets/xenium_breast_cancer>
    Nanostring CosMx Lung <subsections/datasets/Nanostring_Lung12>
    MERFISH <subsections/datasets/merFISH_hypot_preopt_region>
    Vizgen Brain <subsections/datasets/vizgen_mouse_brain>
    Visium Mouse Kidney <subsections/datasets/mouse_visium_kidney>
    Visium Mouse Brain <subsections/datasets/mouse_visium_brain>
    Visium Prostate Integration <subsections/datasets/visium_prostate_integration>
    CytAssist Human Lung Cancer (FFPE) <subsections/datasets/cytassist_visium>
    Mini SeqFISH <subsections/datasets/mini_seqFISH>
    SeqFISH+ Cortex <subsections/datasets/seqFISH_cortex>
    osmFISH SS Cortex <subsections/datasets/osmFISH_mouse_SS_cortex>
    Resolve Biosciences <subsections/datasets/resolve_bc_210928>
    CODEX Spleen <subsections/datasets/mouse_CODEX_spleen>
    scRNA-seq Prostate <subsections/datasets/singlecell_prostate_standard>
    scRNA-seq Integration <subsections/datasets/singlecell_prostate_integration>
    Other technologies <subsections/datasets/other_technologies_coming_soon>

Most of these tutorials use data which is stored within a helper extension of Giotto Suite, GiottoData. To run these tutorials, please first install this small package.
Please note that some of the tutorials do require a manual download from an external site.

.. code-block:: r

    devtools::install_github("drieslab/GiottoData")

****************************
Sequencing-based
****************************

Stereo-seq
=================
.. card-carousel:: 3

    .. card:: Mouse E12.5_E1S3
        :link: /subsections/datasets/SSeq-E12-5_E1S3-Tutorial
        :link-type: doc

        .. image:: images/dataset_page/Stereo-seq.png

Seq-Scope
=================
.. card-carousel:: 3

    .. card:: Seq-Scope Mouse Liver
        :link: /subsections/datasets/seqscope_mouse_liver_221115
        :link-type: doc

        .. image:: images/dataset_page/Seqscope_Icon.png


Visium
=================
.. card-carousel:: 3

    .. card:: Visium Mouse Kidney
        :link: /subsections/datasets/mouse_visium_kidney
        :link-type: doc

        .. image:: images/dataset_page/visium_kidney_image_summary.png

    .. card:: Visium Mouse Brain
        :link: /subsections/datasets/mouse_visium_brain
        :link-type: doc

        .. image:: images/dataset_page/visium_brain_image_summary.png

    .. card:: Visium Integration
        :link: subsections/datasets/visium_prostate_integration
        :link-type: doc

        .. image:: images/dataset_page/visium_prostate_summary.png

    .. card:: CytAssist Human Lung Cancer
        :link: subsections/datasets/cytassist_visium
        :link-type: doc

        .. image:: https://github.com/PratishthaGuckhool/Giotto_site_suite/blob/master/inst/images/cytassist_visium_lungcancer/21-spatPlot2D.png?raw=true


    .. card:: Visium CytAssist Human Glioblastoma
        :link: subsections/datasets/visium_cytassist_human_glioblastoma
        :link-type: doc

          .. image:: images/dataset_page/visium_cytassist_human_glioblastoma.png


*********************
RNA Multiplex Imaging
*********************

Spatial Genomics
=================
.. card-carousel:: 3

    .. card::
        :link: subsections/datasets/spatial_genomics_kidney
        :link-type: doc

        .. image:: images/tutorials/spatial_genomics_kidney/LeidenSpatPlot6.png

Xenium
=================
.. card-carousel:: 3

    .. card::
        :link: subsections/datasets/xenium_breast_cancer
        :link-type: doc

        .. image:: images/dataset_page/xenium_breast_summary.png

Nanostring CosMx
=================
.. card-carousel:: 3

    .. card::
        :link: subsections/datasets/Nanostring_Lung12
        :link-type: doc

        .. image:: images/dataset_page/nanostring_overview_icon.png

MERFISH
=================
.. card-carousel:: 3

    .. card::
        :link: /subsections/datasets/merFISH_hypot_preopt_region
        :link-type: doc

        .. image:: images/dataset_page/merFISH_hypoth_image_summary.png

Vizgen
=================
.. card-carousel:: 3

    .. card::
        :link: subsections/datasets/vizgen_mouse_brain
        :link-type: doc

        .. image:: images/dataset_page/vizgen_brain_summary.png

seqFISH
=================
.. card-carousel:: 3

    .. card:: seqFISH
        :link: subsections/datasets/mini_seqFISH
        :link-type: doc

        .. image:: images/dataset_page/mini_seqFISH.png

    .. card:: seqFISH+
        :link: subsections/datasets/seqFISH_cortex
        :link-type: doc

        .. image:: images/dataset_page/cortex_image_summary.png


osmFISH
=================
.. card-carousel:: 3

    .. card::
        :link: subsections/datasets/osmFISH_mouse_SS_cortex
        :link-type: doc

        .. image:: images/dataset_page/osmFISH_SS_cortex_image_summary.png

Resolve Biosciences
===================
.. card-carousel:: 3

    .. card::
        :link: subsections/datasets/resolve_bc_210928
        :link-type: doc

        .. image:: images/dataset_page/resolve_bioscience_cancer_summary.png

**********************
Protein Multiplexing
**********************

CODEX
===================

.. card-carousel:: 3

    .. card::
        :link: subsections/datasets/mouse_CODEX_spleen
        :link-type: doc

        .. image:: images/dataset_page/CODEX_spleen_image_summary.png


*****************************
Single Cell RNA Sequencing
*****************************

.. card-carousel:: 3

    .. card:: Prostate
        :link: subsections/datasets/singlecell_prostate_standard
        :link-type: doc

        .. image:: images/dataset_page/SC_RNAseq_standard.png

    .. card:: Prostate Integration
        :link: subsections/datasets/singlecell_prostate_integration
        :link-type: doc

        .. image:: images/dataset_page/SC_RNAseq_integration.png


*****************************
Other Technologies
*****************************

.. card-carousel:: 3

    .. card::
        :link: /subsections/datasets/other_technologies_coming_soon
        :link-type: doc

        .. image:: images/dataset_page/coming_soon_summary.png
