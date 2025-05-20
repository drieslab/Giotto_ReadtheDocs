.. raw:: html

    <script type="text/javascript">
    if (String(window.location).indexOf("readthedocs") !== -1) {
        window.alert('This example has been moved. I will redirect you to the new location.');
        window.location.replace('https://drieslab.github.io/Giotto_website/articles/faqs.html');
    }
    </script>

====
faqs
====

:Date: 2022-09-16

\*\* Copied from old Giotto, likely needs to be updated for Giotto Suite
\*\*

Installation
============

-  `First time R package
   installation <./installation_issues.html#first-time-r-package-installation>`__
-  `Manual python
   installation <./installation_issues.html#python-manual-installation>`__
-  `Clang error on MacOS <./installation_issues.html#errors-on-macos>`__
-  `Error: ‘make’ not
   found <./installation_issues.html#make-not-found-error>`__
-  `Error converted from
   warning <./installation_issues.html#error-converted-from-warning>`__
-  `R 3.6.3 and Catalina
   issue <./installation_issues.html#errors-on-macos>`__

Data availability
=================

-  | Where to find seqFISH+ and other ready-to-use datasets?
   | **Checkout https://github.com/drieslab/spatial-datasets to find already
     preprocessed datasets**

-  | Where to find other spatial datasets?
   | **Checkout https://www.spatialomics.org/SpatialDB/ to download
     expression matrix and location information**

-  How to automatically download tutorial datasets? (merFISH example)

.. container:: cell

   .. code:: r

      # choose your directory
      my_working_dir = getwd()

      # standard download data to working directory
      getSpatialDataset(dataset = 'merfish_preoptic', directory = my_working_dir)

      # use wget to  download data to working directory (much faster)
      getSpatialDataset(dataset = 'merfish_preoptic', directory = my_working_dir, method = 'wget')

      # avoid certification issues with wget
      getSpatialDataset(dataset = 'merfish_preoptic', directory = my_working_dir, method = 'wget', extra = '--no-check-certificate')

      # see download.file for more options
      ?download.file
