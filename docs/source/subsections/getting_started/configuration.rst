.. raw:: html

    <script type="text/javascript">
    if (String(window.location).indexOf("readthedocs") !== -1) {
        window.alert('This example has been moved. I will redirect you to the new location.');
        window.location.replace('https://drieslab.github.io/Giotto_website/articles/installation.html');
    }
    </script>

=============
Configuration
=============

:Date: 2022-10-12

1 Configuring the Giotto Environment
====================================

Giotto contains several functions that contain wrappers to Python code
and thus requires an environment containing Python. Utilizing the
functionality of the
`reticulate <https://rstudio.github.io/reticulate/>`__ package, Giotto
contains a function which sets up a miniconda environment and installs
the required Python packages within that environment. Once this
function,
`installGiottoEnvironment <../md_rst/installGiottoEnvironment.html>`__,
has been run, Giotto will automatically default to utilizing this
environment.

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

The function
`installGiottoEnvironment <../md_rst/installGiottoEnvironment.html>`__
two particular arguments that are most useful for reinstallation, if
necessary:

-  **force_miniconda**: force reinstallation of miniconda, default is
   FALSE
-  **force_environment**: force reinstallation of the Giotto
   environment, default is FALSE

**Note that, by default,**
`installGiottoEnvironment <../md_rst/installGiottoEnvironment.html>`__
**installs a specific version of Python and each required package. At
the time of this tutorial’s creation, the following versions are
utilized:**

-  `Python <https://www.python.org/>`__ 3.10.2
-  `pandas <https://pandas.pydata.org/>`__ 1.5.1
-  `networkx <https://networkx.org/>`__ 2.8.8
-  `python-igraph <https://igraph.org/python/>`__ 0.10.2
-  `leidenalg <https://leidenalg.readthedocs.io/en/latest/>`__ 0.9.0
-  `python-louvain <https://python-louvain.readthedocs.io/en/latest/>`__
   0.16
-  `python.app <https://github.com/conda-forge/python.app-feedstock>`__
   (Mac only) 1.4
-  `scikit-learn <https://scikit-learn.org/stable/>`__ 1.1.3
-  `smfishHmrf <https://pypi.org/project/smfishHmrf/>`__ 1.3.3

2 Customizing the Giotto Installation
=====================================

If different versions of Python or packages are necessary for a
workflow, Giotto may be installed accordingly. Ensure that all required
packages, which have been listed above, are accounted for when
installing. Simply specify the desired version numbers for each package
within a vector, and provide that vector to the *packages_to_install*
argument within **installGiottoEnvironment**.

Note that machine type is not relevant when providing
*packages_to_install* to **installGiottoEnvironment**; this function
will identify the OS in use and install/not install packages
(i.e. python.app) accordingly.

.. container:: cell

   .. code:: r

      ### Note that the following code has been provided to indicate how to install
      ### Giotto with customized Python and Python package versions. It has been
      ### intentionally commented out so that it will not run and overwrite the
      ### default versions unless deliberately edited.

      ### new_pkg_versions <- c('pandas==1.4.4',
      ###                       'networkx==2.6.3',
      ###                       'python-igraph==0.9.6',
      ###                       'leidenalg==0.8.7',
      ###                       'python-louvain==0.15',
      ###                       'scikit-learn==0.24.2',
      ###                       'python.app==2')
      ###
      ### ############################
      ### # If altering the original Giotto Installation is not desired, DO NOT
      ### # run the following command as written.
      ### ############################
      ### installGiottoEnvironment(packages_to_install = new_pkg_versions,
      ###                          python_version = '3.8') # Default is 3.10.2

3 Using a non-default Conda Environment with Giotto
===================================================

Inherently as a result of the interface with reticulate, it is not
possible to install the Giotto environment at a specified location. For
this reason, the specific packages and versions used in the default
Giotto installation have been provided so that custom Conda environments
may also be used. **Note that the installation of all aforementioned
packages is necessary for the full functionality of Giotto**.

To use a specific Conda environment, a path to a system-specific python
executable within a conda/miniconda environment must be provided to
`createGiottoInstructions <../md_rst/createGiottoInstructions.html>`__.
This will direct reticulate to activate and utilize that environment
within that R session. See `How to Create a Giotto
Object <./getting_started_gobject.html>`__ for more details.

4 Package Accessibility
=======================

Giotto makes use of the following Python packages (and their respective
dependencies) for full functionality:

-  `pandas <https://pandas.pydata.org/>`__
-  `networkx <https://networkx.org/>`__
-  `python-igraph <https://igraph.org/python/>`__
-  `leidenalg <https://leidenalg.readthedocs.io/en/latest/>`__
-  `python-louvain <https://python-louvain.readthedocs.io/en/latest/>`__
-  `python.app <https://github.com/conda-forge/python.app-feedstock>`__
   (Mac only)
-  `scikit-learn <https://scikit-learn.org/stable/>`__
-  `smfishHmrf <https://pypi.org/project/smfishHmrf/>`__

Here is a brief troubleshooting workflow to investigate if
`reticulate <https://rstudio.github.io/reticulate/>`__ can access them.

*Note that “community” and “sklearn” are aliases of “python-louvain” and
“scikit-learn”, respectively.*

.. container:: cell

   .. code:: r

      # Creating Giotto Instructions without specifying a Python path will make
      # reticulate activate the default Giotto environment.
      default_instrs <- createGiottoInstructions()

      # Extract python path information
      default_python_path <- default_instrs$python_path

      # Make reticulate iteratively check for the packages
      pkg_check <- function(){
        py_pkgs = c('pandas','networkx', 'igraph', 'leidenalg','community','sklearn','python.app')
        py_pkg_error = character()
        test_availability = TRUE

        for (i in py_pkgs){
          if(i == 'python.app' & Sys.info()[['sysname']] != "Darwin"){
            # If the machine OS is not OSX (Mac), break out of the loop
            # Otherwise, also check for python.app
            break
          }
          test_availability <- reticulate::py_module_available(i)
          if(!test_availability) {py_pkg_error <- c(py_pkg_error,i)}
        }

        if(test_availability){
          cat('All Python packages for Giotto are accessible at environment:\n', default_python_path)
        }else{
          for (x in py_pkg_error) cat(x,'was not found within environment:\n',default_python_path,'\n\n')
        }

        return(py_pkg_error)
      }

      pkg_check()

.. raw:: html

   <details>

.. raw:: html

   <summary>

**Troubleshooting Packages not Found**

.. raw:: html

   </summary>

In the event that packages are inaccessible in the default installation
of the Giotto miniconda environment, one troubleshooting method is
provided here.

.. container:: cell

   .. code:: r

      # Restart the R session, while maintaining workspace variables.
      # If using RStudio, the following command will do exactly that:
      .rs.restartR()

      # Direct reticulate to use Python within the Giotto Environment
      reticulate::use_python(default_python_path)

      # Check if packages exist again. Ensure function from above code block is defined.
      missing_packages <- pkg_check()

      retry_install <- length(missing_packages) > 0

      if(retry_install){

        # Attempt to reinstall all packages.
        pkgs_w_versions <- c('pandas==1.5.1',
                             'networkx==2.8.8',
                             'python-igraph==0.10.2',
                             'leidenalg==0.9.0',
                             'python-louvain==0.16',
                             'python.app==1.4',
                             'scikit-learn==1.1.3')

        python_version = "3.10.2"

        py_pkgs = c('pandas','networkx',
                    'igraph', 'leidenalg',
                    'python-louvain','scikit-learn','python.app')

        if(Sys.info()[['sysname']] != "Darwin"){
          pkgs_w_versions = pkgs_w_versions[!grepl(pattern = 'python.app', x = pkgs_w_versions)]
          py_pkgs = py_pkgs[!grepl(pattern = 'python.app', x = py_pkgs)]
        }

        env_location <- reticulate::py_discover_config()$pythonhome
        partial_path_to_conda <- paste0(reticulate::miniconda_path(),'/envs/giotto_env')

        py_lou = pkgs_w_versions[grepl(pattern = 'python-louvain',x = pkgs_w_versions)]
        pip_packages = c("smfishhmrf", py_lou)
        pkgs_w_versions = pkgs_w_versions[!grepl(pattern = 'python-louvain',x = pkgs_w_versions)]

        if(.Platform[['OS.type']] == 'unix') {

          conda_full_path = paste0(partial_conda_path,'/','bin/conda')

          # Remove all previous installations
          reticulate::conda_remove(envname = env_location,
                                   packages = py_pkgs,
                                   conda = conda_full_path)

          # Reinstall
          reticulate::conda_install(packages = pkgs_w_versions,
                                    envname = env_location,
                                    method = 'conda',
                                    conda = conda_full_path,
                                    python_version = python_version)

          # Reinstall with pip
          reticulate::conda_install(packages = pip_packages,
                                    envname = env_location,
                                    method = 'conda',
                                    conda = conda_full_path,
                                    pip = TRUE,
                                    python_version = python_version)
        }
        else if(.Platform[['OS.type']] == 'windows'){
          conda_full_path = paste0(partial_conda_path,'/','condabin/conda.bat')

          # Remove all previous installations
          reticulate::conda_remove(envname = env_location,
                                   packages = py_pkgs,
                                   conda = conda_full_path)

          # Reinstall
          reticulate::conda_install(packages = pkgs_w_versions,
                                    envname = env_location,
                                    method = 'conda',
                                    conda = conda_full_path,
                                    python_version = python_version,
                                    channel = c('conda-forge', 'vtraag'))

          # Reinstall with pip
          reticulate::conda_install(packages = pip_packages,
                                    envname = env_location,
                                    method = 'conda',
                                    conda = conda_full_path,
                                    pip = TRUE,
                                    python_version = python_version)

        }
      }

If this does not fix the issue at hand, here are some potential action
items:

-  Remove and attempt to reinstall the Giotto environment.

   -  Run
      `removeGiottoEnvironment <../md_rst/removeGiottoEnvironment.html>`__,
      then terminate R.
   -  Open a completely new R session, and run
      `installGiottoEnvironment <../md_rst/installGiottoEnvironment.html>`__

-  Post to an issue to the Giotto GitHub page
   `here <https://github.com/drieslab/Giotto>`__.

   -  Please include the version numbers of R, Giotto, and the OS in use
      at the time of the issue.

-  See `FAQ <../../FAQ.html>`__.

.. raw:: html

   </details>
