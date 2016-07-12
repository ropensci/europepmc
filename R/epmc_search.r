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

epmc_search <- function(query = NULL, limit = 25, id_list = FALSE,
                        synonym = FALSE, verbose = TRUE){
  # check
  if (is.null(query))
    stop("No query provided")
  stopifnot(is.numeric(limit))
  stopifnot(is.logical(verbose))
  stopifnot(is.logical(id_list))
  stopifnot(is.logical(synonym))
  #  get the correct hit count when mesh and uniprot synonyms are also searched
  synonym = ifelse(synonym == FALSE, "false", "true")
  # get results found
  hit_count <- epmc_hits(query = query, synonym = synonym)
  #prepare queries
  queries <- make_queries(hit_count = hit_count, limit = limit, query = query)
  # if only ids are requested
  if (id_list == TRUE)
    queries <-
    lapply(queries, function(x)
      c(x, resulttype = "idlist"))
  # include synonyms from mesh and uniprot
  if (synonym == TRUE)
    queries <-
    lapply(queries, function(x)
      c(x, synonym = "true"))
  # get and parse the json from the queries
  out <- lapply(queries, function(x) {
    if(verbose == TRUE)
      message(paste0(hit_count, " records found. Retrieving batch ",
                     x[["page"]]))
    out <- rebi_GET(path = paste0(rest_path(), "/search"), query = x)
    plyr::ldply(out$resultList,
                data.frame,
                stringsAsFactors = FALSE,
                .id = NULL)
  })
  #combine all into one
  result <- jsonlite::rbind.pages(out)
  # remove nested lists from data.frame, get these infos with epmc_details
  md <- result[, !(names(result) %in% fix_list(result))]
  # return (thanks to @cstubben)
  attr(md, "hit_count") <- hit_count
  md
}


