% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/epmc_ftxt.r
\name{epmc_ftxt}
\alias{epmc_ftxt}
\title{Fetch Europe PMC full texts}
\usage{
epmc_ftxt(ext_id = NULL)
}
\arguments{
\item{ext_id}{character, PMCID. 
All full text publications have external IDs starting 'PMC_'}
}
\value{
xml_document
}
\description{
This function loads full texts into R. Full texts are in XML format and are
only provided for the Open Access subset of Europe PMC.
}
\examples{
  \dontrun{
  epmc_ftxt("PMC3257301")
  epmc_ftxt("PMC3639880")
  }
}
