#' Search Europe PMC publication database
#'
#' @description This is the main function to search Europe PMC RESTful Web
#'   Service (\url{http://europepmc.org/RestfulWebService}). It fully supports
#'   the comprehensive Europe PMC query language. Simply copy & paste your query
#'   terms to R. To get familiar with the Europe PMC query syntax, check the
#'   Advanced Search Query Builder \url{https://europepmc.org/advancesearch}.
#'
#' @seealso \url{http://europepmc.org/Help}
#'
#' @param query character, search query. For more information on how to build a
#'   search query, see \url{http://europepmc.org/Help}
#' @param output character, what kind of output should be returned. One of
#'   'parsed', 'id_list' or 'raw' As default, parsed key metadata will be
#'   returned as data.frame. 'id_list' returns a list of IDs and sources. Use
#'   'raw' to get full metadata as list. Please be aware that these lists can
#'   become very large.
#' @param limit integer, limit the number of records you wish to retrieve. By
#'   default, 100 are returned.
#' @param synonym logical, synonym search. If TRUE, synonym terms from MeSH
#'   terminology and the UniProt synonym list are queried, too.
#'   In order to replicate results from the website, with the Rest API
#'   you need to turn synonyms ON!
#' @param sort character, relevance ranking is used by default. Use
#'   \code{sort = 'cited'} for sorting by the number of citations, or
#'   \code{sort = 'date'} by the most recent publications.
#' @param verbose	logical, print progress bar. Activated by default.
#' @return tibble
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
#' # exclude MeSH synonyms in search
#' my.data <- epmc_search(query = 'aspirin', synonym = FALSE)
#'
#' # get 100 most cited atricles from PLOS ONE publsihed in 2014
#' epmc_search(query = '(ISSN:1932-6203) AND FIRST_PDATE:2014', sort = 'cited')
#'
#' # print number of records found
#' attr(my.data, "hit_count")
#'
#' # change output
#'
#' }
#' @export
epmc_search <- function(query = NULL,
                        output = 'parsed',
                        synonym = TRUE,
                        verbose = TRUE,
                        limit = 100,
                        sort = NULL) {
  #--- Input validation
  stopifnot(is.logical(c(verbose, synonym)))
  stopifnot(is.numeric(limit))


  # sort
  if (!is.null(sort)) {
    match.arg(sort, c("date", "cited"))
    query <- switch(
      sort,
      date = paste(query, "sort_date:y"),
      cited = paste(query, "sort_cited:y")
    )
  } else {
    query <- query
  }
  # get the correct hit count when mesh and uniprot synonyms are also searched
  # synonym <- ifelse(synonym == FALSE, "false", "true")
  # this is so far the only way how I got the synonym paramworking after
  # the API change.
  # there is a possible conflict with the resumption token and decoding
  # the API call.
  query <- transform_query(paste0(query, "&synonym=", synonym))

  page_token <- "*"
  if (!output == "raw")
    results <- tibble::tibble()
  else
    results <- NULL
  # search
  out <-
    epmc_search_(
      query = query,
      limit = limit,
      output = output,
      verbose = verbose,
      page_token = page_token,
      sort = sort
    )
  res_chunks <- chunks(limit = limit)
  # super hacky to control limit, better approach using pageSize param needed
  hits <- epmc_hits(query, synonym = synonym)
  if (hits == 0) {
    message("There are no results matching your query")
    md <- NULL
  } else {
    limit <- as.integer(limit)
    limit <- ifelse(hits <= limit, hits, limit)
    message(paste(hits, "records found, returning", limit))
    # let's loop over until page max is reached,
    # or until cursor marks are identical
    if (!is.null(out$next_cursor)) {
    i <- 0
    # progress
    pb <- pb(limit = limit)
    while (i < res_chunks$page_max) {
      out <-
        epmc_search_(
          query = query,
          limit = limit,
          output = output,
          verbose = verbose,
          page_token = page_token,
          sort = sort
        )
      if (is.null(out$next_cursor))
        break
      i <- i + 1
      if (verbose == TRUE && hits > 100)
        pb$tick()
      page_token <- out$next_cursor
      if (output == "raw") {
        results <- c(results, out$results)
      } else {
        results <- dplyr::bind_rows(results, out$results)
      }
    }
    # again, approach needed to use param pageSize instead
    if (output == "raw") {
      md <- results[1:limit]
    } else {
      md <- results[1:limit, ]
    }
    # return hit counts(thanks to @cstubben)
    attr(md, "hit_count") <- hits
  } else {
    md <- out$results
    attr(md, "hit_count") <- hits
  }
  }
  return(md)
}

#' Get one page of results when searching Europe PubMed Central
#'
#' In general, use \code{\link{epmc_search}} instead. It calls this function, calling all
#' pages within the defined limit.
#'
#' @param query character, search query. For more information on how to
#'   build a search query, see \url{http://europepmc.org/Help}
#' @param output character, what kind of output should be returned. One of 'parsed', 'id_list'
#'   or 'raw' As default, parsed key metadata will be returned as data.frame.
#'   'id_list returns a list of IDs and sources.
#'   Use 'raw' to get full metadata as list. Please be aware that these lists
#'   can become very large.
#' @param limit integer, limit the number of records you wish to retrieve.
#'   By default, 25 are returned.
#' @param page_token cursor marking the page
#'
#' @param ... further params from \code{\link{epmc_search}}
#'
#' @export
#'
#' @seealso \link{epmc_search}
epmc_search_ <-
  function(query = NULL,
           limit = 100,
           output = "parsed",
           page_token = NULL,
           ...) {
    # control limit
    limit <- as.integer(limit)
    page_size <- ifelse(batch_size() <= limit, batch_size(), limit)
    # choose output
    if (!output %in% c("id_list", "parsed", "raw"))
      stop("'output' must be one of 'parsed', 'id_list', or 'raw'",
           call. = FALSE)
    result_types <- c("id_list" = "idlist",
                      "parsed" = "lite",
                      "raw" = "core")
    resulttype <- result_types[[output]]
    # build query
    args <-
      list(
        query = query,
        format = "json",
        resulttype = resulttype,
        pageSize = page_size,
        cursorMark = page_token
      )
    # call API
    out <-
      rebi_GET(path = paste0(rest_path(), "/search"), query = args)
    # remove nested lists from resulting data.frame, get these infos
    # with epmc_details or using output "raw"
    if (!resulttype == "core") {
      md <- out$resultList$result
      if (length(md) == 0) {
        md <- tibble::tibble()
      } else {
        md <- md %>%
          dplyr::select_if(Negate(is.list)) %>%
          tibble::as_tibble()
      }
    } else {
      out <- jsonlite::fromJSON(out, simplifyDataFrame = FALSE)
      md <- out$resultList$result
    }
    list(next_cursor = out$nextCursorMark, results = md)
  }
