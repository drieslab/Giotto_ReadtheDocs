# `showClusterDendrogram`

showClusterDendrogram


## Description

Creates dendrogram for selected clusters.


## Usage

```r
showClusterDendrogram(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  expression_values = c("normalized", "scaled", "custom"),
  cluster_column,
  cor = c("pearson", "spearman"),
  distance = "ward.D",
  h = NULL,
  h_color = "red",
  rotate = FALSE,
  show_plot = NA,
  return_plot = NA,
  save_plot = NA,
  save_param = list(),
  default_save_name = "showClusterDendrogram",
  ...
)
```


## Arguments

Argument      |Description
------------- |----------------
`gobject`     |     giotto object
`spat_unit`     |     spatial unit (e.g. "cell")
`feat_type`     |     feature type (e.g. "rna", "dna", "protein")
`expression_values`     |     expression values to use (e.g. "normalized", "scaled", "custom")
`cluster_column`     |     name of column to use for clusters (e.g. "leiden_clus")
`cor`     |     correlation score to calculate distance (e.g. "pearson", "spearman")
`distance`     |     distance method to use for hierarchical clustering, default to "ward.D"
`h`     |     height of horizontal lines to plot
`h_color`     |     color of horizontal lines
`rotate`     |     rotate dendrogram 90 degrees
`show_plot`     |     show plot. TRUE or FALSE
`return_plot`     |     return ggplot object. TRUE or FALSE
`save_plot`     |     directly save the plot. TRUE or FALSE
`save_param`     |     list of saving parameters, see [`showSaveParameters`](#showsaveparameters)
`default_save_name`     |     default save name for saving, don't change, change save_name in save_param
`...`     |     additional parameters passed to [`ggdendrogram`](#ggdendrogram)


## Details

Expression correlation dendrogram for selected clusters.


## Value

ggplot


