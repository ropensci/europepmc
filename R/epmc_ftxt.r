#' Fetch Europe PMC full text
#'
#' This function loads one full text into R. Full text is in XML format and is
#' only provided for the Open Access subset of Europe PMC.
#'
#' @param ext_id character, PMCID. 
#'   All full text publications have external IDs starting 'PMC_'
#'
#' @export
#' @return xml_document
#'
#' @examples
#'   \dontrun{
#'   epmc_ftxt("PMC3257301")
#'   epmc_ftxt("PMC3639880")
#'   }
epmc_ftxt <- function(ext_id = NULL) {
  if (!grepl("^PMC", ext_id) || length(ext_id) != 1)
    stop("Please provide one PMCID, i.e. id starting with 'PMC'")
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
