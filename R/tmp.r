epmc_search_tmp_ <-
  function(query = NULL,
           limit = 100,
           id_list = FALSE,
           synonym = FALSE,
           verbose = TRUE,
           page_token = NULL,
           sort = NULL) {
    # check
    if (is.null(query))
      stop("No query provided")
    stopifnot(is.logical(c(verbose, id_list, synonym)))
    #  get the correct hit count when mesh and uniprot synonyms are also searched
    synonym <- ifelse(synonym == FALSE, "false", "true")
    resulttype <- ifelse(id_list == FALSE, "lite", "idlist")
    # control limit
    limit <- as.integer(limit)
    page_size <- ifelse(batch_size() <= limit, batch_size(), limit)
    #build query
    args <-
      list(
        query = query,
        format = "json",
        synonym = synonym,
        resulttype = resulttype,
        pageSize = page_size,
        cursorMark = page_token,
        sort = sort
      )
    # call API
    out <-
      rebi_GET(path = paste0(rest_path(), "/search"), query = args)
    # remove nested lists from resulting data.frame, get these infos with epmc_details
    md <- out$resultList$result
    if (length(md) == 0) {
      md <- dplyr::data_frame()
    } else {
      md <- md %>%
        dplyr::select_if(Negate(is.list)) %>%
        as_data_frame()
    }
    list(next_cursor = out$nextCursorMark, results = md)
  }

epmc_search_tmp <- function(query = NULL,
                            id_list = FALSE,
                            synonym = FALSE,
                            verbose = TRUE,
                            limit = 100,
                            sort = NULL) {
  page_token <- "*"
  results <- dplyr::data_frame()
  out <-
    epmc_search_tmp_(
      query = query,
      limit = limit,
      id_list = id_list,
      synonym = synonym,
      verbose = verbose,
      page_token = page_token,
      sort = sort
    )
  res_chunks <- chunks(limit = limit)
  # super hacky to control limit, better approach using pageSize param needed
  hits <- epmc_hits(query)
  limit <- as.integer(limit)
  limit <- ifelse(hits <= limit, hits, limit)
  # let's loop over until page max is reached, or until cursor marks are identical
  i <- 0
  while (i < res_chunks$page_max) {
    out <-
      epmc_search_tmp_(
        query = query,
        limit = limit,
        id_list = id_list,
        synonym = synonym,
        verbose = verbose,
        page_token = page_token,
        sort = sort
      )
    if (page_token == out$next_cursor)
      break
    i <- i + 1
    message(paste("Retrieving result page", i))
    page_token <- out$next_cursor
    results <- dplyr::bind_rows(results, out$results)
  }
  # again, approach needed to use param pageSize instead
  return(results[1:limit, ])
}
