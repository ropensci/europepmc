#' Get citations for a given publication
#'
#' The function finds citations to a publication in the Europe PMC index. It
#' retrieves the citation count and some metadata about the citing publications.
#'
#' @param ext_id publication identifier
#' @param data_src data source, by default Pubmed/MedLine index will be searched.
#'   The following three letter codes represents the sources
#'   Europe PubMed Central supports:
#'   \describe{
#'     \item{agr}{Agricola is a bibliographic database of citations to the
#'     agricultural literature created by the US National Agricultural Library
#'     and its co-operators.}
#'     \item{cba}{Chinese Biological Abstracts}
#'     \item{ctx}{CiteXplore}
#'     \item{eth}{EthOs Theses, i.e. PhD theses (British Library)}
#'     \item{hir}{NHS Evidence}
#'     \item{med}{PubMed/Medline NLM}
#'     \item{nbk}{Europe PMC Book metadata}
#'     \item{pat}{Biological Patents}
#'     \item{pmc}{PubMed Central}
#'     }
#' @param n_pages Number of pages to be returned. By default, this function
#'   returns 25 records for each page.
#'
#' @return List of 3, citation count, metadata of citing documents (data.frame)
#'   and summary of request parameter
#' @export
#'
#' @examples
#' \dontrun{
#' epmc_citations("PMC3166943", data_src = "pmc")
#' epmc_citations("9338777")
#' }
epmc_citations <- function(ext_id = NULL, data_src = "med", n_pages = 20) {
  if (is.null(ext_id))
    stop("Please provide a publication id")
  # build request
  path = paste("europepmc/webservices/rest", data_src, ext_id, "citations",
               "json", sep ="/")
  doc <- rebi_GET(path = path)
  hitCount <- doc$hitCount
  if(doc$hitCount == 0)
    stop("This article has not been cited yet")
  no_pages <- rebi_pageing(hitCount = hitCount)
  # limit number of pages that will be retrieved
  if(max(no_pages) > n_pages) no_pages <- 1:n_pages
  pages = list()
  for(i in no_pages){
    out <- rebi_GET(path = paste("europepmc/webservices/rest", data_src, ext_id,
                               "citations", "json", i, sep ="/"))
    message("Retrieving page ", i)
    result <- plyr::ldply(out$citationList, data.frame,
                          stringsAsFactors = FALSE, .id = NULL)
    pages[[i+1]] <- result
  }
  #combine all into one
  result <- jsonlite::rbind.pages(pages)
  # return
  list(hit_count = hitCount, citations = result)
}
