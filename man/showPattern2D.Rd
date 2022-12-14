% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/spatial_genes.R
\name{showPattern2D}
\alias{showPattern2D}
\title{showPattern2D}
\usage{
showPattern2D(
  gobject,
  spatPatObj,
  dimension = 1,
  trim = c(0.02, 0.98),
  background_color = "white",
  grid_border_color = "grey",
  show_legend = T,
  point_size = 1,
  show_plot = NA,
  return_plot = NA,
  save_plot = NA,
  save_param = list(),
  default_save_name = "showPattern2D"
)
}
\arguments{
\item{gobject}{giotto object}

\item{spatPatObj}{Output from detectSpatialPatterns}

\item{dimension}{dimension to plot}

\item{trim}{Trim ends of the PC values.}

\item{background_color}{background color for plot}

\item{grid_border_color}{color for grid}

\item{show_legend}{show legend of ggplot}

\item{point_size}{size of points}

\item{show_plot}{show plot}

\item{return_plot}{return ggplot object}

\item{save_plot}{directly save the plot [boolean]}

\item{save_param}{list of saving parameters, see \code{\link{showSaveParameters}}}

\item{default_save_name}{default save name for saving, don't change, change save_name in save_param}
}
\value{
ggplot
}
\description{
show patterns for 2D spatial data
}
\keyword{internal}
