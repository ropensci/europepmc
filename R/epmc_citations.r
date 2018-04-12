#' Get citations for a given publication
#'
#' Finds works that cite a given publication.
#'
#' @inheritParams epmc_refs
#'
#' @return Metadata of citing documents as data.frame
#' @export
#'
#' @examples
#' \dontrun{
#' epmc_citations("PMC3166943", data_src = "pmc")
#' epmc_citations("9338777")
#' }
epmc_citations <-
  function(ext_id = NULL,
           data_src = "med",
           limit = 100,
           verbose = TRUE) {
    # validate input
    val_input(ext_id, data_src, limit, verbose)
    # build request
    path <- mk_path(data_src, ext_id, req_method = "citations")
    # how many records are found?
    hit_count <- get_counts(path = path)
    if (hit_count == 0) {
      message("No citing documents found")
      out <- NULL
    } else {
      # provide info
      msg(hit_count = hit_count,
          limit = limit,
          verbose = verbose)
      # request records and parse them
      if (hit_count >= limit) {
        req <-
          rebi_GET(path = path,
                   query = list(format = "json", pageSize = limit))
        out <- dplyr::as_data_frame(req$citationList$citation)
      } else {
        query <-
          make_path(hit_count = hit_count,
                    limit = limit)
        out <- purrr::map_df(query, function(x) {
          req <- rebi_GET(path = path, query = x)
          dplyr::as_data_frame(req$citationList$citation)
        })
      }
      # return hit count as attribute
      attr(out, "hit_count") <- hit_count
    }
    out
  }
