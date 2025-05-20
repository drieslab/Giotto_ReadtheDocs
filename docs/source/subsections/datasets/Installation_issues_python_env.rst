.. raw:: html

    <script type="text/javascript">
    if (String(window.location).indexOf("readthedocs") !== -1) {
        window.alert('This example has been moved. I will redirect you to the new location.');
        window.location.replace('https://drieslab.github.io/Giotto_website/articles/installation.html');
    }
    </script>

==============================
Installation_issues_python_env
==============================

:Date: 2022-09-16

1. Install Giotto python Environment within R
=============================================

In terms of Giotto Suite, the best way to install and load Giotto python
Environment is to use the installGiottoEnvironment() function and
activate the Giotto Environment via createGiottoInstructions(). The
installGiottoEnvironment function will install required packages from
r-miniconda and createGiottoInstructions will search for giotto
environment and load it into R.

.. container:: cell

   .. code:: r

      library(Giotto)
      installGiottoEnvironment()
      instrs = createGiottoInstructions(save_dir = results_folder,
                                        save_plot = TRUE,
                                        show_plot = FALSE)

2. Manually installation of python Environment with conda.
==========================================================

Unfortunately, sometimes r-miniconda may have a problem or something
else happens. A manually installation of required python package via
miniconda is needed. Before you try to install python packages, make
sure you have the
`miniconda <https://docs.conda.io/en/latest/miniconda.html>`__ installed

2.1 Create conda environment and install required packages
----------------------------------------------------------

.. code:: python

   conda env create -n giotto
   conda activate giotto
   conda install pandas networkx python-igraph leidenalg python-louvain python.app scikit-learn -c conda-forge

2.2 Check the conda environment location
----------------------------------------

.. code:: bash

   conda info

You should be able to find the conda environment
path/to/conda/envs/giotto from the listed active env location

2.3 Determine the path to this environment when you create the Giotto instructions or Giotto object. Please double check the name of the path. Some MacOS system has the same folder structure as linux.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

for OSX:

::

   path/to/conda/envs/giotto/bin/pythonw

for linux:

::

   path/to/conda/envs/giotto/bin/python

for windows:

::

   path/to/conda/envs/giotto/python.exe

2.4 load the python path to R session. Note you need to change the path to the actual location of the installed python environment
----------------------------------------------------------------------------------------------------------------------------------

.. container:: cell

   .. code:: r

      library(Giotto)
      intrs = createGiottoInstructions(python_path = "path/to/conda/envs/giotto/bin/python")

Alternatively, load the python path directly from reticulate would also
work:

.. container:: cell

   .. code:: r

      reticulate::use_python("path/to/conda/envs/giotto/bin/python")

Or this should also work: note the conda_install_location path should be
able to found by “conda av data dir” from conda info

.. container:: cell

   .. code:: r

      reticulate::use_condaenv(conda = conda_install_location, condaenv = "giotto")

Note that load library(reticulate) might result in loading the first
python environment on the machine and the loaded python cannot be
overwritten until a new R session was created. So avoid loading the
reticulate library before a giotto python environment is loaded. You can
always check if the correct python was loaded:

.. container:: cell

   .. code:: r

      reticulate::py_config()
