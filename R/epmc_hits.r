#' Get search result count
#'
#' Search over Europe PMC and retrieve the number of results found
#'
#' @param query query in the Europe PMC syntax
#' @param ... add query parameters from `epmc_search()`, e.g. synonym=true
#'
#' @seealso \code{\link{epmc_search}}
#' @examples
#'  \dontrun{
#'  epmc_hits('abstract:"burkholderia pseudomallei"')
#'  epmc_hits('AUTHORID:"0000-0002-7635-3473"')
#'  }
#' @export

epmc_hits <- function(query = NULL, ...) {
  # check
  query <- transform_query(query)
  path = paste0(rest_path(), "/search")
  doc <- rebi_GET(path, query = list(query = query, format = "json", resulttype = "idlist"))
  doc$hitCount
}
