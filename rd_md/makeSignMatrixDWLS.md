# `makeSignMatrixDWLS`

makeSignMatrixDWLS


## Description

Function to convert a matrix within a Giotto object into a format
 that can be used with [`runDWLSDeconv`](#rundwlsdeconv) . A vector of cell types
 for cell_type_vector can be created from the cell metadata (pDataDT).


## Usage

```r
makeSignMatrixDWLS(
  gobject,
  expression_values = c("normalized", "scaled", "custom"),
  reverse_log = TRUE,
  log_base = 2,
  sign_gene,
  cell_type_vector,
  cell_type = NULL
)
```


## Arguments

Argument      |Description
------------- |----------------
`gobject`     |     Giotto object of single cell
`expression_values`     |     expression values to use
`reverse_log`     |     reverse a log-normalized expression matrix
`log_base`     |     the logarithm base (deafult  = 2)
`sign_gene`     |     all of DE genes (signature)
`cell_type_vector`     |     vector with cell types (length = ncol(matrix))
`cell_type`     |     deprecated, use cell_type_vector


## Value

matrix


## Seealso

[`spatialDWLS`](#spatialdwls)


