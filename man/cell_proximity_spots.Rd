% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/spatial_interaction_spot.R
\name{cell_proximity_spots}
\alias{cell_proximity_spots}
\title{cell_proximity_spots}
\usage{
cell_proximity_spots(cell_IDs, pairs_external, dwls_values)
}
\arguments{
\item{cell_IDs}{cell_IDs to calculate internal cell-type/cell-type interactions}

\item{dwls_values}{data.table of cell type enrichment in each spot and multiply
by cell number in each spot}

\item{pairs}{data.table of paired spots. Format: cell_ID1, cell_ID2, N}
}
\value{
List of cell proximity observed value in data.table format. Columns:
unified_int, type_int, V1, external, internal.
}
\description{
Compute cell-cell interactions observed value for internal and external spots
}
\keyword{internal}
