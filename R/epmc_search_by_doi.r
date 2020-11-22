#' Search Europe PMC by DOIs
#'
#' Look up DOIs indexed in Europe PMC and get metadata back.
#'
#' @param doi, character vector containing DOI names.
#' @param output character, what kind of output should be returned. One of
#'   'parsed', 'id_list' or 'raw' As default, parsed key metadata will be
#'   returned as data.frame. 'id_list' returns a list of IDs and sources. Use
#'   'raw' to get full metadata as list. Please be aware that these lists can
#'   become very large.
#' @examples \dontrun{
#' # single DOI name
#' epmc_search_by_doi(doi = "10.1161/strokeaha.117.018077")
#' # multiple DOIname in a vector
#' my_dois <- c(
#'   "10.1159/000479962",
#'   "10.1002/sctm.17-0081",
#'   "10.1161/strokeaha.117.018077",
#'   "10.1007/s12017-017-8447-9")
#' epmc_search_by_doi(doi = my_dois)
#' # full metadata
#' epmc_search_by_doi(doi = my_dois, output = "raw")
#' }
#' @export
epmc_search_by_doi <- function(doi = NULL, output = "parsed") {
  # input validation
  stopifnot(!is.null(doi))
  if (!output %in% c("id_list", "parsed", "raw"))
    stop("'output' must be one of 'parsed', 'id_list', or 'raw'",
         call. = FALSE)
  # remove empty characters
  if (any(doi %in% "")) {
    doi <- doi[doi != ""]
    warning("Removed empty characters from DOI vector")
  }
  pb <- pb(length(doi))
  if (output != "raw") {
    out <- purrr::map_df(paste0("DOI:", doi),
                         epmc_search_by_doi_,
                         .pb = pb,
                         output = output)
  } else {
    out <- purrr::map(paste0("DOI:", doi),
                      epmc_search_by_doi_,
                      .pb = pb,
                      output = "raw")
  }
  return(out)
}
#' Search Europe PMC by a DOI name
#'
#' Please use \code{\link{epmc_search_by_doi}} instead. It calls this
#' method, returning open access status information from all your requests.
#'
#' @inheritParams epmc_search_by_doi
#' @param .pb progress bar object
#' @export
#' @examples \dontrun{
#'   epmc_search_by_doi_("10.1159/000479962")
#' }
epmc_search_by_doi_ <-
  function(doi,
           .pb = NULL,
           output = NULL) {
    out <- suppressMessages(epmc_search(doi, output = output))
    # https://rud.is/b/2017/03/27/all-in-on-r%E2%81%B4-progress-bars-on-first-post/
    # choose output
    if ((!is.null(.pb)) &&
        inherits(.pb, "Progress") && (.pb$i < .pb$n))
      .pb$tick()$print()
    if (is.null(out))
      message(paste("\n", doi, "not indexed in Europe PMC"))
    out
  }
