#' Search Europe PMC publication database
#'
#' @description This is the main function to search
#' Europe PMC RESTful Web Service (\url{http://europepmc.org/RestfulWebService})
#'
#' @seealso \url{http://europepmc.org/Help}
#'
#' @param query search query (character vector). For more information on how to
#'   build a search query, see \url{http://europepmc.org/Help}
#' @param id_list Should only IDs (e.g. PMID) and sources be retrieved for the
#'   given search terms?
#' @param batch_size Size of pages to be returned. By default, this function
#'   returns 100  records for each page.
#' @param limit Maximum number of recors to be retrieved. By default, 100 are
#'   returned.
#' @param verbose	print some information on what is going on.
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
#' #Limit search to 250 PLOS Genetics articles
#' my.data <- epmc_search(query = 'ISSN:1553-7404', limit = 250)
#'
#' }
#' @export

epmc_search <- function(query = NULL, batch_size = 100, limit = 1000,
                         id_list = FALSE, verbose = TRUE){
  # check
  if (is.null(query))
    stop("No query provided")
  # get results found
  path = paste0(rest_path(), "/search")
  q <- list(query = query, format = "json")
  doc <- rebi_GET(path = path, query = q)
  hit_count <- doc$hitCount
  if(hit_count == 0)
    stop("nothing found, please check your query")
  #prepare queries
  limit <- ifelse(hit_count <= limit, hit_count, limit)
  if (limit >= batch_size) {
    if (all.equal(limit / batch_size, as.integer(limit / batch_size)) == TRUE) {
      page_max <- limit / batch_size
      last_chunk <- batch_size
    } else {
      page_max <- as.integer(limit / batch_size) + 1
      last_chunk <- limit - ((page_max - 1) * batch_size)
    }
    queries <-
      lapply(1:(page_max - 1),
             build_query,
             batch_size = batch_size,
             query = query)
    queries <-
      append(queries, list(
        build_query(
          query = query,
          page = page_max,
          batch_size = last_chunk
        )
      ))
  } else {
    queries <-
      list(build_query(
        page = 1,
        query = query,
        batch_size = limit
      ))
  }
  # if only ids are requested
  if (id_list == TRUE)
    queries <-
    lapply(queries, function(x)
      c(x, resulttype = "idlist"))
  # get and parse the json from the queries
  out <- lapply(queries, function(x) {
    if(verbose == TRUE)
      message(paste0(hit_count, " records found. Retrieving batch ",
                     x[["page"]]))
    out <-
      rebi_GET(path = "europepmc/webservices/rest/search", query = x)
    plyr::ldply(out$resultList,
                data.frame,
                stringsAsFactors = FALSE,
                .id = NULL)
  })
  #combine all into one
  result <- jsonlite::rbind.pages(out)
  # remove nested lists from data.frame, get these infos with epmc_details
  md <- result[, !(names(result) %in% fix_list(result))]
  # return
  list(hit_count = hit_count, data = md)
}
