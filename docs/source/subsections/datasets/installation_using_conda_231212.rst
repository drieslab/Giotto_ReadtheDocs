.. raw:: html

    <script type="text/javascript">
    if (String(window.location).indexOf("readthedocs") !== -1) {
        window.alert('This example has been moved. I will redirect you to the new location.');
        window.location.replace('https://drieslab.github.io/Giotto_website/articles/installation.html');
    }
    </script>

============
Installation Using Conda
============

:Date: 2023-12-12

0. Clean up
=========================

Clear Conda Temporary Files

.. container:: cell

   .. code:: shell

      conda clean -a

Clear Pip Temporary Files

.. container:: cell

   .. code:: shell

      pip cache purge

1. Create Conda Environment
=========================

.. container:: cell

   .. code:: shell

      conda create -y -n giotto_suite python=3.10 r=4.2
      conda activate giotto_suite

      export PKG_CONFIG_PATH=$CONDA_PREFIX/envs/giotto_suite/lib/pkgconfig
      # export PKG_CONFIG_PATH=/sc/arion/work/wangw32/conda-env/envs/giotto_suite_bento_install/lib/pkgconfig

2. Install Giotto
=========================

2.1 Install Dependency Packages
------------------------
Install these packages first, as they may encounter network issues during Giotto's installation. Use conda for installation.

.. container:: cell

   .. code:: shell

      conda install -y -c conda-forge -c bioconda -c r -c defaults r-gert
      conda install -y -c conda-forge -c bioconda -c r -c defaults r-magick r-terra r-igraph
      # For other dependencies with installation issues, use conda:
      # conda install -y -c conda-forge -c bioconda -c r -c defaults r-sf


2.2 Check R_LIB
-----------------------------------------

.. container:: cell

   .. code:: r

      library_paths <- .libPaths()
      print(library_paths)
      # [1] "/sc/arion/work/wangw32/conda-env/envs/giotto_suite/lib/R/library"

2.3 Install Devtools & Giotto
-----------------------------------------

.. container:: cell

   .. code:: r

      options(timeout=1000)

      # Necessary for installation from R
      if(!"devtools" %in% installed.packages()) {
        install.packages("devtools")
      }

      devtools::install_github("drieslab/Giotto")

3. Install Python Dependency Packages
====================================

Install Necessary Python Packages.

.. container:: cell

   .. code:: shell

     conda activate giotto_suite
     conda install -y cmake
     pip install pandas python-igraph networkx python-louvain leidenalg scikit-learn smfishHmrf

Install Other Packages (Optional).

.. container:: cell

   .. code:: shell
     pip install git+https://github.com/wwang-chcn/bento-tools.git
