# `trendSceek`

trendSceek


## Description

Compute spatial variable genes with trendsceek method


## Usage

```r
trendSceek(
  gobject,
  expression_values = c("normalized", "raw"),
  subset_genes = NULL,
  nrand = 100,
  ncores = 8,
  ...
)
```


## Arguments

Argument      |Description
------------- |----------------
`gobject`     |     Giotto object
`expression_values`     |     gene expression values to use
`subset_genes`     |     subset of genes to run trendsceek on
`nrand`     |     An integer specifying the number of random resamplings of the mark distribution as to create the null-distribution.
`ncores`     |     An integer specifying the number of cores to be used by BiocParallel
`list()`     |     Additional parameters to the [`trendsceek_test`](#trendsceektest) function


## Details

This function is a wrapper for the trendsceek_test method implemented in the trendsceek package


## Value

data.frame with trendsceek spatial genes results


