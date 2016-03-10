#' Fetch Europe PMC full texts
#'
#' This function loads full texts into R. Full texts are in XML format and are
#' only provided for the Open Access subset of Europe PMC.
#'
#' @param ext_id publication identifier. All full text publications have
#' external IDs starting 'PMC___'.
#' @param data_src data source. For full texts, only 'pmc' is accepted.
#'
#' @export
#' @return xml_document
#'
#' @examples
#'   \dontrun{
#'   epmc_ftxt("PMC3257301")
#'   epmc_ftxt("PMC3639880")
#'   }
epmc_ftxt <- function(ext_id = NULL, data_src = "pmc") {
  if (is.null(ext_id))
    stop("Please provide a PMC id, i.e. id starting with 'PMC'")
  if (!data_src == "pmc")
    stop("Full texts can only be provided for publications indexed in 'pmc'")
  uri <- "http://www.ebi.ac.uk"
  # call api
  req <- httr::GET(uri, path = paste("europepmc/webservices/rest", ext_id,
                                     "fullTextXML", sep = "/"))
  # check for http status
  httr::stop_for_status(req)
  # load xml into r
  httr::content(req, encoding = "utf-8")
}
