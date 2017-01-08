#' Fetch Europe PMC books
#'
#' Use this function to retrieve book XML formatted full text for the Open
#' Access subset of the Europe PMC bookshelf.
#'
#' @param ext_id character, publication identifier. All book full texts are accessible
#' either by the PMID or the 'NBK' book number.

#' @export
#' @return xml_document
#'
#' @examples
#'   \dontrun{
#'   epmc_ftxt_book("NBK32884")
#'   }
epmc_ftxt_book <- function(ext_id = NULL) {
  if (is.null(ext_id))
    stop("Please provide an id. All book full texts are accessible either by the
         PMID or the 'NBK' book number")
  # call api
  req <- httr::GET(base_uri(), path = paste(rest_path(), ext_id,
    "bookXML", sep = "/"))
  # check for http status
  httr::stop_for_status(req)
  # load xml into r
  httr::content(req, as = "text", encoding = "utf-8") %>%
    xml2::read_xml()
}
