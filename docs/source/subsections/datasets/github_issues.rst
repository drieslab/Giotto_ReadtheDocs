.. raw:: html

    <script type="text/javascript">
    if (String(window.location).indexOf("readthedocs") !== -1) {
        window.alert('This example has been moved. I will redirect you to the new location.');
        window.location.replace('https://drieslab.github.io/Giotto_website/articles/github_issues.html');
    }
    </script>

=============
github_issues
=============

:Date: 2022-09-16

Github Issues Guidelines
========================

Some useful commands
--------------------

It is helpful if you provide any relevant information about the software
and Giotto object you are using. See below for some tips to get this
information.

**What version of R are you using?**

.. container:: cell

   .. code:: r

      R.version.string

.. container:: cell

   .. code:: bash

      "R version 4.0.4 (2021-02-15)"

**What version of Giotto are you using?**

.. container:: cell

   .. code:: r

      packageVersion("Giotto")

.. container:: cell

   .. code:: bash

      2.0.0.9044

**Are you using the Giotto environment or your own python path?**

.. container:: cell

   .. code:: r

      # Check Giotto environment
      Giotto:::checkGiottoEnvironment()

.. container:: cell

   .. code:: bash

      giotto environment found at
       /Users/natalie_dr/Library/r-miniconda/envs/giotto_env/bin/pythonw

**Show sequential processing steps/commands in the Giotto object**

.. container:: cell

   .. code:: r

      Giotto:::showProcessingSteps(my_giotto_object)

.. container:: cell

   .. code:: bash

      Processing steps:


       0_normalize

**Show the structure of the Giotto object**

.. container:: cell

   .. code:: r

      str(my_giotto_object, max.level = 3)

.. container:: cell

   .. code:: bash

      Formal class 'giotto' [package "Giotto"] with 20 slots
        ..@ expression         :List of 1
        .. ..$ rna:List of 3
        ..@ expression_feat    : chr "rna"
        ..@ spatial_locs       :List of 1
        .. ..$ raw:Classes ‘data.table’ and 'data.frame': 73655 obs. of  4 variables:
        .. .. ..- attr(*, ".internal.selfref")=<externalptr>
        ..@ spatial_info       : NULL
        ..@ cell_metadata      :List of 1
        .. ..$ rna:Classes ‘data.table’ and 'data.frame': 73655 obs. of  1 variable:
        .. .. ..- attr(*, ".internal.selfref")=<externalptr>
        ..@ feat_metadata      :List of 1
        .. ..$ rna:Classes ‘data.table’ and 'data.frame': 161 obs. of  1 variable:
        .. .. ..- attr(*, ".internal.selfref")=<externalptr>
        ..@ feat_info          : NULL
        ..@ cell_ID            : chr [1:73655] "cell_1" "cell_2" "cell_3" "cell_4" ...
        ..@ feat_ID            :List of 1
        .. ..$ rna: chr [1:161] "Ace2" "Adora2a" "Aldh1l1" "Amigo2" ...
        ..@ spatial_network    : NULL
        ..@ spatial_grid       : NULL
        ..@ spatial_enrichment : NULL
        ..@ dimension_reduction: NULL
        ..@ nn_network         : NULL
        ..@ images             : NULL
        ..@ parameters         :List of 1
        .. ..$ 0_normalize: Named chr [1:13] "my_giotto_object" "standard" "TRUE" "6000" ...
        .. .. ..- attr(*, "names")= chr [1:13] "gobject" "norm_methods" "library_size_norm" "scalefactor" ...
        ..@ instructions       :List of 11
        .. ..$ python_path: chr "/Users/natalie_dr/Library/r-miniconda/envs/giotto_env/bin/pythonw"
        .. ..$ show_plot  : logi TRUE
        .. ..$ return_plot: logi TRUE
        .. ..$ save_plot  : logi FALSE
        .. ..$ save_dir   : chr "/Users/natalie_dr/Desktop/my_giotto/giotto_user_help"
        .. ..$ plot_format: chr "png"
        .. ..$ dpi        : num 300
        .. ..$ units      : chr "in"
        .. ..$ height     : num 9
        .. ..$ width      : num 9
        .. ..$ is_docker  : logi FALSE
        ..@ offset_file        : NULL
        ..@ OS_platform        : chr "unix"
        ..@ join_info          : NULL

Warning messages
----------------

Deprecation warning
~~~~~~~~~~~~~~~~~~~

.. container:: cell

   .. code:: r

      my_giotto_object <- createGiottoObject(raw_exprs = "path/to/expression/data",
                                             spatial_locs = "path/to/spatial/data")

.. container:: cell

   .. code:: bash

      Warning message:
      In createGiottoObject(raw_exprs = "/Users/username/path/to/data",  :
        raw_exprs argument is deprecated, use expression argument in the future

*Solution*: The code has still run and your object has been created, but
in the future use the following command:

.. container:: cell

   .. code:: r

      my_giotto_object <- createGiottoObject(expression = "path/to/expression/data",
                                             spatial_locs = "path/to/spatial/data")

Errors
------

Is this an error from Giotto?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. container:: cell

   .. code:: bash

      Error in adjustGiottoMatrix(gobject = my_giotto_object, expression_values = c("normalized"): covariate column name(s) were not found in the cell metadata

*Solution*: In this case, you would need to check your cell metadata
(``my_giotto_object@cell_metadata``) and make appropriate adjustments.

Is this an error from an external package?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. container:: cell

   .. code:: bash

      Error in methods::as(as.matrix(x[, -1]), "Matrix") :
        no method or default for coercing "matrix" to "Matrix"

*Solution*: Ensure that the Matrix library is loaded:

.. container:: cell

   .. code:: r

      library(Matrix)

**Some steps before posting an issue**:

-  Google (or whichever search engine you prefer) the error

-  Look up the documentation for the package the error came from

Required information to provide:
--------------------------------

-  What code/data did you use? (copy-pasted or an example is helpful)

-  What did you expect your result to be?

-  What was your result?

   -  If your result was an error message, please see the category on
      error messages to determine whether the source was Giotto or an
      external package.

How to create a reproducible example
------------------------------------

For us to be able to help you at the best of our ability, it’s helpful
if you can provide a reproducible example. This just means that anyone
who reads your GitHub issue should be able to accurately reproduce your
error.

For more information on minimal reproducible examples check out `this
link <https://stackoverflow.com/help/minimal-reproducible-example>`__.

And to see what other people recommend, please check out `this
forum <https://stackoverflow.com/questions/5963269/how-to-make-a-great-r-reproducible-example>`__.

Good example of a GitHub issue:
-------------------------------

-  Provide a code example

   -  Please use the GitHub “insert code” function or wrap your code
      like so:

      \`x <- “hello world”

      print(x)\`

   -  If applicable, provide a screenshot of the issue

..

   I am having trouble adjusting my Giotto matix. I have inputted the
   following code:

.. container:: cell

   .. code:: r

      my_giotto_object <- adjustGiottoMatrix(gobject = my_giotto_object,
                                             expression_values = c('normalized'),
                                             covariate_columns = c('nr_genes',
                                                                   'total_expr'))

..

   I expected that my matrix would be appropriately adjusted, but I got
   the following error:

.. container:: cell

   .. code:: bash

      Error in adjustGiottoMatrix(gobject = my_giotto_object, expression_values = c("normalized"): covariate column name(s) were not found in the cell metadata

..

   For more context, I am running R version 4.04 and Giotto version
   2.0.0.9044. I can send you the data I used if necessary.

Bad example of a GitHub issue:
------------------------------

   I am having trouble adjusting my Giotto matrix. My error says that
   the covariate column name(s) were not found in the cell meta data.
   What do I do?
