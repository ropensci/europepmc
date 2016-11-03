#' Search Europe PMC publication database
#'
#' @description This is the main function to search
#' Europe PMC RESTful Web Service (\url{http://europepmc.org/RestfulWebService})
#'
#' @seealso \url{http://europepmc.org/Help}
#'
#' @param query character, search query. For more information on how to
#'   build a search query, see \url{http://europepmc.org/Help}
#' @param id_list logical, should only IDs (e.g. PMID) and sources be retrieved
#'   for the given search terms?
#' @param limit integer, limit the number of records you wish to retrieve.
#'   By default, 25 are returned.
#' @param synonym logical, synonym search. If TRUE, synonym terms from MeSH
#'  terminology and the UniProt synonym list are queried, too. Disabled by
#'  default.
#' @param verbose	logical, print some information on what is going on.
#' @return data.frame
#' @examples \dontrun{
#' #Search articles for 'Gabi-Kat'
#' my.data <- epmc_search(query='Gabi-Kat')
#'
#' #Get article metadata by DOI
#' my.data <- epmc_search(query = 'DOI:10.1007/bf00197367')
#'
#' #Get article metadata by PubMed ID (PMID)
#' my.data <- epmc_search(query = 'EXT_ID:22246381')
#'
#' #Get only PLOS Genetics article with EMBL database references
#' my.data <- epmc_search(query = 'ISSN:1553-7404 HAS_EMBL:y')
#' #Limit search to 250 PLOS Genetics articles
#' my.data <- epmc_search(query = 'ISSN:1553-7404', limit = 250)
#'
#' # include mesh and uniprot synonyms in search
#' my.data <- epmc_search(query = 'aspirin', synonym = TRUE)
#'
#' # print number of records found
#' attr(my.data, "hit_count")
#'
#' }
#' @export

epmc_search <- function(query = NULL,
                            id_list = FALSE,
                            synonym = FALSE,
                            verbose = TRUE,
                            limit = 100,
                            sort = NULL) {
  # needed because of decoded/encoded conflicts regarding cursorMark
  query <- URLencode(query)
  # get the correct hit count when mesh and uniprot synonyms are also searched
  synonym <- ifelse(synonym == FALSE, "false", "true")
  page_token <- "*"
  results <- dplyr::data_frame()
  out <-
    epmc_search_(
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
  hits <- epmc_hits(query, synonym = synonym)
  limit <- as.integer(limit)
  limit <- ifelse(hits <= limit, hits, limit)
  # let's loop over until page max is reached, or until cursor marks are identical
  i <- 0
  while (i < res_chunks$page_max) {
    out <-
      epmc_search_(
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
  md <- results[1:limit, ]
  # return hit counts(thanks to @cstubben)
  attr(md, "hit_count") <- hits
  return(md)
}

epmc_search_ <-
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
#    stopifnot(is.logical(c(verbose, id_list, synonym)))
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
