.. raw:: html

    <script type="text/javascript">
    if (String(window.location).indexOf("readthedocs") !== -1) {
        window.alert('The documentation has moved. I will redirect you to the new location.');
        window.location.replace('http://drieslab.github.io/Giotto_website');
    }
    </script>

##########################################
Giotto Suite
##########################################

.. toctree::
   :maxdepth: 4
   :caption: General
   :hidden:

   Branches <branches.rst>
   Documentation <documentation.rst>
   Contribute <contribute.rst>
   News </subsections/datasets/giotto_news.rst>
   Presentations <presentations.rst>

.. toctree::
   :hidden:
   :maxdepth: 3
   :caption: Getting Started

   Giotto Installation </subsections/datasets/installation_04122023.rst>
   Giotto Ecosystem </subsections/datasets/giotto_ecosystem_04122023.rst>
   Giotto Configuration </subsections/datasets/configuration_04122023.rst>
   Giotto Object Creation </subsections/getting_started/getting_started_gobject.rst>
   Giotto Class Structure </subsections/getting_started/classes_intro.rst>

.. toctree::
   :hidden:
   :maxdepth: 3
   :caption: Tutorials

   Datasets <datasets.rst>
   Tools <tools.rst>
   Analyses <analyses.rst>

.. toctree::
   :maxdepth: 1
   :caption: Try Giotto in the Cloud
   :hidden:

   Terra.bio </subsections/trygiotto/terra.rst>
   Docker </subsections/trygiotto/docker.rst>

.. toctree::
   :maxdepth: 1
   :caption: Issues
   :hidden:

   FAQs <faqs.rst>
   Troubleshooting <errorsfaqsandtips.rst>
   Report a Bug <github_issues.rst>

.. toctree::
   :maxdepth: 1
   :caption: Updates
   :hidden:

   Changelog <additionalinformation.rst>

.. image:: images/index/GiottoSuiteWebsite-07.svg
   :align: center
   :target: https://github.com/drieslab/Giotto/tree/suite

**********************************************
WEBSITE UPDATE! PLEASE USE THE NEW WEBSITE
**********************************************

This website is outdated and will be terminated on May 1st 2025. Please visit www.giottosuite.com for more information.

An open-source and technology-agnostic spatial multi-omics analysis platform
============================================================================

Giotto Suite is a collection of open source software tools, including data structures and methods, for the comprehensive analysis and visualization of spatial multi-omics data at multiple scales and resolutions. It extends and improves our previous R package `Giotto`_. The underlying framework of Giotto Suite is generalizable to virtually all current and emerging spatial technologies which may differ in resolution (e.g. subcellular, single cell, or multiple cells), spatial dimension (i.e. 2D vs. 3D), molecular modality (e.g. protein, RNA, DNA, …), and throughput (i.e. number of cells and analytes). Giotto Suite is designed to ensure spatial analysis solutions remain compatible with current and future spatial -omics technologies and platforms. It will also aid in the further integration of spatial -omics with external analysis pipelines and tools.

.. _Giotto: https://github.com/drieslab/Giotto/tree/suite

The source code for Giotto Suite may be found on our `GitHub repository <https://github.com/drieslab/Giotto/tree/suite>`_.


.. note::
        Giotto Suite is still in beta. We are actively developing the website content and source code of Giotto Suite ahead of the official release. We welcome any feedback or suggestions, please submit any bugs or issues on the Github page above.

**********************************************
Workflow
**********************************************

.. image:: images/index/GiottoSuiteWebsite_Compatibility.svg
   :width: 400

Data Structure
===============

.. image:: images/index/GiottoSuiteWebsite_Data Structure.svg
   :width: 600

Analysis
=============

.. image:: images/index/GiottoSuiteWebsite_Workspace.svg
   :width: 500

More technical information can be found in the `getting started section <https://giottosuite.readthedocs.io/en/latest/gettingstarted.html#learn-more-about-giotto-suite>`_.


References
=============

* `Dries, R., Zhu, Q. et al. Giotto, a toolbox for integrative analysis and visualization of spatial expression data. Genome Biology (2021). <https://genomebiology.biomedcentral.com/articles/10.1186/s13059-021-02286-2>`_
* `Dries, R., Chen, J., Rossi, N. del, Khan, M.M., Sistig, A., Yuan, G.-C., 2021. Advances in spatial transcriptomic data analysis. Genome Res. 31, 1706–1718 <https://genome.cshlp.org/content/31/10/1706?top=1>`_
* `Del Rossi, N., Chen, J. et al. Analyzing Spatial Transcriptomics Data Using Giotto. Current Protocols (2022). <https://currentprotocols.onlinelibrary.wiley.com/doi/abs/10.1002/cpz1.405>`_

**********************************
Cite Giotto
**********************************

:ref:`Citing Giotto <citing_giotto>`

*******************************
License
*******************************
:doc:`Full License </subsections/license>`

.. github-shield::
    :username: RubD
    :repository: Giotto
    :branch: suite
    :license:

*******************************
Community
*******************************

:doc:`Code of Conduct <subsections/code_of_conduct>`

****************************
Authors and Developers
****************************

+------------------------+---------------------+
|`Ruben Dries`_          |*Author, Maintainer* |
+------------------------+---------------------+
| `Jiaji George Chen`_   |*Author*             |
+------------------------+---------------------+
| Natalie Del Rossi      |*Author*             |
+------------------------+---------------------+
| Emma Kelley            |*Author*             |
+------------------------+---------------------+
| `Junxiang Xu`_         |*Author*             |
+------------------------+---------------------+
| `Guo-Cheng Yuan`_      |*Author*             |
+------------------------+---------------------+
| `Joselyn Chávez`_      |*Author*             |
+------------------------+---------------------+
| Adriana Sistig         |*Author*             |
+------------------------+---------------------+
| `Matthew O'Brien`_     |*Author*             |
+------------------------+---------------------+
| `Edward C. Ruiz`_      |*Author*             |
+------------------------+---------------------+

.. _Ruben Dries: https://www.drieslab.com
.. _Jiaji George Chen: https://github.com/jiajic
.. _Junxiang Xu: https://github.com/JunxiangXu
.. _Guo-Cheng Yuan: https://labs.icahn.mssm.edu/yuanlab
.. _Joselyn Chávez: https://twitter.com/josschavezf1
.. _Matthew O'Brien: https://github.com/mattobny
.. _Edward C. Ruiz: https://twitter.com/Ed2uiz

