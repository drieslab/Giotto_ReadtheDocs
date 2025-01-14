#############################
FAQs
#############################

**********************************************
WEBSITE UPDATE! PLEASE USE THE NEW WEBSITE
**********************************************

This website is outdated and will be terminated on May 1st 2025. Please visit www.giottosuite.com for more information.

*******************************
Frequently Asked Questions
*******************************

Installation
==================
:octicon:`question` `How do I install an R package for the first time? <./subsections/datasets/installation_04122023.html>`_

:octicon:`question` `Can I install Python components manually? <./subsections/datasets/configuration_04122023.html>`_

Data Availability
=====================

:octicon:`question` Where can I find seqFISH+ and other ready-to-use datasets?

    Checkout our `GiottoData <https://github.com/drieslab/GiottoData>`_ extension package to find already preprocessed datasets and Giotto mini Objects.

:octicon:`question` Where else can I find more spatial datasets?

    Checkout the following for more spatial -omics data:
        - `Aquila <https://aquila.cheunglab.org/view>`_
        - Tencent's `SODB <https://gene.ai.tencent.com/SpatialOmics/>`_
            - `PySODB <https://pysodb.readthedocs.io/en/latest/>`_, a python interface for the SODB

:octicon:`question` How can I automatically download tutorial datasets?

    Use `getSpatialDataset()` from GiottoData:

    .. code-block:: r

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


        # choose your directory
        my_working_dir = getwd()

        # merFISH example:

        # standard download data to working directory
        getSpatialDataset(dataset = 'merfish_preoptic', directory = my_working_dir)

        # use wget to  download data to working directory (much faster)
        getSpatialDataset(dataset = 'merfish_preoptic', directory = my_working_dir, method = 'wget')

        # avoid certification issues with wget
        getSpatialDataset(dataset = 'merfish_preoptic', directory = my_working_dir, method = 'wget', extra = '--no-check-certificate')
