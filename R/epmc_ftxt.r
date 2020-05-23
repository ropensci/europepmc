#' Fetch Europe PMC full texts
#'
#' This function loads full texts into R. Full texts are in XML format and are
#' only provided for the Open Access subset of Europe PMC.
#'
#' @param ext_id character, publication identifier. PMID or PMCID for articles
#'   where Europe PMC indexes the full-text.
#'
#' @export
#' @return xml_document
#'
#' @examples
#'   \dontrun{
#'   epmc_ftxt("PMC3257301")
#'   epmc_ftxt("PMC3639880")
#'   epmc_ftxt("29456894")
#'   }
epmc_ftxt <- function(ext_id = NULL) {
  if (is.null(ext_id))
    stop("Please provide a PMID or PMCID, i.e. ids starting with 'PMC'")
  # call api
  req <-
    httr::RETRY("GET",
                base_uri(),
                path = paste(rest_path(), ext_id,
                             "fullTextXML", sep = "/"))
  # check for http status
  httr::stop_for_status(req, "retrieve full text.")
  # load xml into r
  httr::content(req, as = "text", encoding = "utf-8") %>%
    xml2::read_xml()
}
