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
epmc_citations_new <-
  function(ext_id = NULL,
           data_src = "med",
           limit = 100,
           verbose = TRUE) {
    if (is.null(ext_id))
      stop("Please provide a publication id")
    if (!tolower(data_src) %in% supported_data_src)
      stop(
        paste0(
          "Data source '",
          data_src,
          "' not supported. Try one of the
          following sources: ",
          paste0(supported_data_src, collapse = ", ")
        )
      )
    stopifnot(is.numeric(limit))
    stopifnot(is.logical(verbose))
    # build request
    req_method <- "citations"
    path <- c(rest_path(), data_src, ext_id, req_method)
    doc <- rebi_GET(path = path,
                    query = list(format = "json", pageSize = batch_size()))
    hit_count <- doc$hitCount
    if (hit_count == 0) {
      message("No citing documents found")
      out <- NULL
    } else {
      if (verbose == TRUE)
        message(paste0(
          hit_count,
          " records found. Returning ",
          ifelse(hit_count <= limit, hit_count, limit)
        ))
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
      # return
      attr(out, "hit_count") <- hit_count
    }
    out
  }
