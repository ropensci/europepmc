epmc_search_tmp_ <- function(query = NULL, id_list = FALSE,
                         synonym = FALSE, verbose = TRUE, page_token = NULL) {
  # check
  if (is.null(query))
    stop("No query provided")
  stopifnot(is.logical(c(verbose, id_list, synonym)))
  #  get the correct hit count when mesh and uniprot synonyms are also searched
  synonym = ifelse(synonym == FALSE, "false", "true")
  resulttype = ifelse(id_list == FALSE, "lite", "idlist")

  #build query
  args <-
    list(query = query,
         format = "json",
         synonym = synonym,
         resulttype = resulttype,
         pageSize = batch_size(),
         cursorMark = page_token)
  out <- rebi_GET(path = paste0(rest_path(), "/search"), query = args)
  list(next_cursor = out$nextCursorMark, results = as.data.frame(out$resultList$result))
}

epmc_search_tmp <- function(query = NULL, id_list = FALSE,
                         synonym = FALSE, verbose = TRUE, page_token = NULL) {
  results <- data.frame()
  page_token <- "*"
  repeat {
  out <- epmc_search_tmp_(query = query, id_list = id_list,
               synonym = synonym, verbose = verbose, page_token = page_token)
  page_token <- out$next_cursor
  results <- dplyr::bind_rows(results, out$results)
  if(nrow(out$results) == 0) {
    break
  }
  message(print(page_token))
   }
  message("Variants are now available.")
  results
}

