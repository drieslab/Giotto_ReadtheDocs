.. _gettingstartedpage:

**********************************************
WEBSITE UPDATE! PLEASE USE THE NEW WEBSITE
**********************************************

This website is outdated and will be terminated on May 1st 2025. Please visit www.giottosuite.com for more information.

#######################
Getting Started
#######################

Giotto Suite is installed via R **but there are required Python modules** which **must** be installed in order for Giotto Suite to function properly.
Below are the instructions for both the installation of the Giotto Suite package (Step 1) and required Python environment (Step 2).

*************
Requirements
*************
* R (>= 3.5.1)
* Python (>= 3.0)
* `Windows, MacOS or Linux specific installation tools.`_

.. _Windows, MacOS or Linux specific installation tools.: https://support.rstudio.com/hc/en-us/articles/200486498-Package-Development-Prerequisites

.. _Installation_Section:

*************
Installation
*************

**Step 1: Install Giotto Suite**

.. code-block:: r

    devtools::install_github("drieslab/Giotto@suite")

**Step 2: Install the Giotto Python environment**

This step only needs to be run once. Giotto Suite will automatically detect the environment in the future.

.. code-block:: r

    library(Giotto)
    installGiottoEnvironment()


:octicon:`light-bulb` Encountering errors? Checkout out the `Troubleshooting page <https://giottosuite.readthedocs.io/en/latest/errorsfaqsandtips.html>`__ for installation help.


**************************
Try Giotto in the cloud
**************************

To avoid installation issues, you can run Giotto analysis on Terra.bio. Take a look on the `Terra tutorial <https://giottosuite.readthedocs.io/en/latest/subsections/trygiotto/terra.html#terra/>`__.


**************************
Learn more about Giotto Suite
**************************

The following tutorials use data which is stored within another package in the Giotto Suite ecosystem, GiottoData. To run these tutorials, please first install this small package.

.. code-block:: r

    devtools::install_github("drieslab/GiottoData")

.. grid:: 4

    .. grid-item-card:: Configuration

        .. image:: images/getting_started/icons_configuration.png
	    :target: ./subsections/getting_started/configuration.html

    .. grid-item-card:: Object & Classes

        .. image:: images/getting_started/icons_giotto.png
            :target: ./subsections/getting_started/getting_started_gobject.html


    .. grid-item-card:: Data Processing

        .. image:: images/getting_started/icons_processing.png
            :target: ./subsections/getting_started/data_processing.html


    .. grid-item-card:: Clustering

        .. image:: images/getting_started/icons_clustering.png
            :target: ./subsections/getting_started/dimension_reduction.html

    .. grid-item-card:: Image Alignment

        .. image:: images/getting_started/icons_images.png
            :target: ./subsections/getting_started/getting_started_images.html

    .. grid-item-card:: Visualizations

        .. image:: images/getting_started/icons_visualizations.png
            :target: ./subsections/getting_started/visualizations.html

    .. grid-item-card:: Saving Objects

        .. image:: images/getting_started/icons_saving.png
            :target: ./subsections/getting_started/getting_started_saving.html

    .. grid-item-card:: Interactive Selection

        .. image:: images/dataset_page/interactive_selection_image_summary.png
            :target: ./subsections/getting_started/interactive_selection.html
