#' Get text-mined terms
#'
#' Retrieve a count and list of terms Europe PubMed Central has text-mined from
#' full text publications.
#'
#' #' @param ext_id publication identifier
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
#' @semantic_type Specify the semantic type you wish to retrieve. The following
#'   types are supported:
#'     \describe{
#'     \item{ACCESSION}{accession IDs for DNA or protein sequences}}
#'     \item{CHEMICAL}{chemicals}
#'     \item{DISEASE}{diseases}
#'     \item{EFO}{Experimental Factor Ontology
#'       (\url{http://www.ebi.ac.uk/efo/})}
#'     \item{GENE_PROTEIN}{gene proteins}
#'     \item{GO_TERM}{Gene Ontology Terms (\url{http://geneontology.org/})}
#'     \item{ORGANISM}{organism}
#'     }
#' @param n_pages Number of pages to be returned. By default, this function
#'   returns 20 pages with  25 records each.
#' @return List of 2, including counts and terms found as data.frame
#' @examples
#' \dontrun{
#' epmc_tm("25249410", semantic_type = "GO_TERM")
#' epmc_tm("PMC4340542", data_src = "pmc", semantic_type = "GO_TERM")
#' }
#' @export
epmc_tm <- function(ext_id = NULL, data_src = "med", semantic_type = NULL,
                    n_pages = 20) {
  if (is.null(ext_id))
    stop("Please provide a publication id")
  # build request
  if (is.null(semantic_type))
    stop("Please Specify the semantic type you wish to retrieve text-mined terms
         for")
  path = paste("europepmc/webservices/rest", data_src, ext_id, "textMinedTerms",
               semantic_type, "json", sep ="/")
  doc <- rebi_GET(path = path)
  hitCount <- doc$hitCount
  if(doc$hitCount == 0)
    stop("Sorry, no text-mined terms found")
  no_pages <- rebi_pageing(hitCount = hitCount, pageSize = doc$request$pageSize)
  # limit number of pages that will be retrieved
  if(max(no_pages) > n_pages) no_pages <- 1:n_pages
  pages = list()
  for(i in no_pages){
    out <- rebi_GET(path = paste("europepmc/webservices/rest", data_src, ext_id,
                                 "textMinedTerms", semantic_type, "json",
                                 i, sep ="/"))
    message("Retrieving page ", i)
    result <- plyr::ldply(out$semanticTypeList$semanticType$tmSummary,
      data.frame, stringsAsFactors = FALSE, .id = NULL)
    pages[[i+1]] <- result
  }
  #combine all into one
  result <- jsonlite::rbind.pages(pages)
  # return
  list(hit_count = hitCount, data = result)
}
