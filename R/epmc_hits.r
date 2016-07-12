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
  if (is.null(query))
    stop("No query provided")
  path = paste0(rest_path(), "/search")
  doc <- rebi_GET(path, query = list(query = query, format = "json", ...))
  hit_count <- doc$hitCount
  if(hit_count == 0)
      stop("nothing found, please check your query")
  hit_count
}
