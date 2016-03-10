#' Search Europe PMC publication database
#'
#' @description This is the main function to search
#' Europe PMC RESTful Web Service (\url{http://europepmc.org/RestfulWebService})
#'
#' @seealso \url{http://europepmc.org/Help}
#'
#' @param query search query (character vector). For more information how to
#'   build a search query, see \url{http://europepmc.org/Help}
#' @param id_list Should only IDs (e.g. PMID) and sources be retrieved for the
#'   given search terms?
#' @param n_pages Number of pages to be returned. By default, this function
#'   returns 25 records for each page.
#' @return List of two, number of hits and the retrieved metadata as data.frame
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
#' }
#' @export

epmc_search <- function(query = NULL, id_list = FALSE, n_pages = 50){
  # check
  if (is.null(query))
    stop("No query provided")
  path = "europepmc/webservices/rest/search"
  q <- list(query = query, format = "json")
  doc <- rebi_GET(path = path, query = q)
  hitCount <- doc$hitCount
  if(hitCount == 0)
    stop("nothing found, please check your query")
  no_pages <- rebi_pageing(hitCount = hitCount, pageSize = doc$request$pageSize)
  # limit number of pages that will be retrieved
  if(max(no_pages) > n_pages) no_pages <- 1:n_pages
  pages = list()
  for(i in no_pages){
    if(!id_list) {
      out <- rebi_GET(path = path,
                      query = list(query = query,format = "json", page = i))
      } else {
        out <- rebi_GET(path = path,
                        query = list(query = query, format = "json", page = i,
                                     resulttype ="idlist"))
      }
    message("Retrieving page ", i)
    result <- plyr::ldply(out$resultList, data.frame,
                          stringsAsFactors = FALSE, .id = NULL)
    pages[[i+1]] <- result
    }
  #combine all into one
  result <- jsonlite::rbind.pages(pages)
  # remove nested lists from data.frame, get these infos with epmc_details
  md <- result[, !(names(result) %in% fix_list(result))]
  # return
  list(hit_count = hitCount, data = md)
}

# Implementing GET method and json parser for EPMC
rebi_GET <- function(path = NULL, query = NULL, ...) {
  if (is.null(path) && is.null(query))
    stop("Nothing to search")
  uri <- "http://www.ebi.ac.uk"
  # call api
  req <- httr::GET(uri, path = path, query = query)
  # check for http status
  httr::stop_for_status(req)
  # load json into r
  out <- httr::content(req, "text")
  # valid json
  if(!jsonlite::validate(out))
    stop("Upps, nothing to parse, please check your query")
  doc <- jsonlite::fromJSON(out)
  if (!exists("doc"))
    stop("No json to parse", call. = FALSE)
  doc
}

# Calculate pages. Each page consists of 25 records.
rebi_pageing <- function(hitCount, pageSize) {
  if (all.equal((hitCount / pageSize), as.integer(hitCount / pageSize)) == TRUE) {
    1:(hitCount / pageSize)
  } else {
    1:(hitCount / pageSize + 1)
  }
}

# fix to remove columns that cannot be easily flatten from the data.frame
 fix_list <- function(x){
   if(!is.null(x))
  tmp <- plyr::ldply(x, is.list)
  tmp[tmp$V1 == TRUE, ".id"]
}
