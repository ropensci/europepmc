#' Fetch Europe PMC full texts
#'
#' This function loads full texts into R. Full texts are in XML format and are
#' only provided for the Open Access subset of Europe PMC.
#'
#' @param ext_id publication identifier. All full text publications have
#' external IDs starting 'PMC___'.
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
    stop("Please provide a PMCID, i.e. ids starting with 'PMC'")
  if (!substring(ext_id, 1, 3) == "PMC")
    stop("Full texts can only be provided for publications indexed PubMed
         Central. So please provide a PMCID, i.e. ids starting with 'PMC'")
  uri <- "http://www.ebi.ac.uk"
  # call api
  req <- httr::GET(uri, path = paste("europepmc/webservices/rest", ext_id,
                                     "fullTextXML", sep = "/"))
  # check for http status
  httr::stop_for_status(req, "retrieve full text. Check with epmc_details()
                        if full text is available")
  # load xml into r
  httr::content(req, encoding = "utf-8")
}
