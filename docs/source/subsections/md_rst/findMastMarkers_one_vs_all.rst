findMastMarkers_one_vs_all
--------------------------

.. link-button:: https://github.com/drieslab/Giotto/tree/suite/R/differential_expression.R#L838
		:type: url
		:text: View Source Code
		:classes: btn-outline-primary btn-block

Last Updated: |today|

Description
~~~~~~~~~~~

Identify marker feats for all clusters in a one vs all manner based on
the MAST package.

Usage
~~~~~

::

   findMastMarkers_one_vs_all(
     gobject,
     feat_type = NULL,
     spat_unit = NULL,
     expression_values = c("normalized", "scaled", "custom"),
     cluster_column,
     subset_clusters = NULL,
     adjust_columns = NULL,
     pval = 0.001,
     logFC = 1,
     min_feats = 10,
     min_genes = NULL,
     verbose = TRUE,
     ...
   )

Arguments
~~~~~~~~~

+-----------------------------------+-----------------------------------+
| ``gobject``                       | giotto object                     |
+-----------------------------------+-----------------------------------+
| ``feat_type``                     | feature type                      |
+-----------------------------------+-----------------------------------+
| ``spat_unit``                     | spatial unit                      |
+-----------------------------------+-----------------------------------+
| ``expression_values``             | feat expression values to use     |
+-----------------------------------+-----------------------------------+
| ``cluster_column``                | clusters to use                   |
+-----------------------------------+-----------------------------------+
| ``subset_clusters``               | selection of clusters to compare  |
+-----------------------------------+-----------------------------------+
| ``adjust_columns``                | column in pDataDT to adjust for   |
|                                   | (e.g. detection rate)             |
+-----------------------------------+-----------------------------------+
| ``pval``                          | filter on minimal p-value         |
+-----------------------------------+-----------------------------------+
| ``logFC``                         | filter on logFC                   |
+-----------------------------------+-----------------------------------+
| ``min_feats``                     | minimum feats to keep per         |
|                                   | cluster, overrides pval and logFC |
+-----------------------------------+-----------------------------------+
| ``min_genes``                     | deprecated, use min_feats         |
+-----------------------------------+-----------------------------------+
| ``verbose``                       | be verbose                        |
+-----------------------------------+-----------------------------------+
| ``...``                           | additional parameters for the zlm |
|                                   | function in MAST                  |
+-----------------------------------+-----------------------------------+

Value
~~~~~

data.table with marker feats

See Also
~~~~~~~~

``findMastMarkers``
