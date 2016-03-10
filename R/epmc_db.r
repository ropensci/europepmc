#' Retrieve external database entities referenced in a given publication
#'
#' This function returns EBI database entities referenced in a publication from
#' Europe PMC RESTful Web Service.
#'
#' @param ext_id publication identifier
#' @param data_src data source, by default Pubmed/MedLine index will be searched.
#'   Other sources Europe PubMed Central supports are:
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
#' @param db restrict the response to a specific database:
#'  \describe{
#'  \item{'CHEBI'}{a database and ontology of chemical entities of biological
#'      interest \url{http://www.ebi.ac.uk/chebi/}}
#'   \item{'CHEMBL'}{a database of bioactive drug-like small molecules
#'      \url{https://www.ebi.ac.uk/chembldb/}}
#'   \item{'EMBL'}{provides a comprehensive record of the world's nucleotide
#'      sequencing information \url{http://www.ebi.ac.uk/ena/}}
#'   \item{'INTACT'}{provides a freely available, open
#'      source database system and analysis tools for molecular interaction data
#'      \url{http://www.ebi.ac.uk/intact/}}
#'   \item{'INTERPRO'}{provides functional analysis of proteins by classifying
#'      them into families and predicting domains and important sites
#'      \url{http://www.ebi.ac.uk/interpro/}}
#'   \item{'OMIM'}{a comprehensive and authoritative compendium of human genes and
#'      genetic phenotypes \url{http://www.ncbi.nlm.nih.gov/omim}}
#'   \item{'PDB'}{European resource for the collection,
#'      organisation and dissemination of data on biological macromolecular
#'      structures \url{http://www.ebi.ac.uk/pdbe/}}
#'   \item{'UNIPROT'}{comprehensive and freely accessible
#'      resource of protein sequence and functional information
#'   \url{http://www.uniprot.org/}}
#'   }
#' @param n_pages Number of pages to be returned. By default, this function
#'      returns 10 records for each page.
#' @return list of 3 including link count and metadata of cross-references.
#' @examples
#'   \dontrun{
#'   epmc_db("12368864", db = "uniprot", n_pages = 2)
#'   epmc_db("25249410", db = "embl")
#'   epmc_db("14756321", db = "uniprot")
#'   }
#' @export
epmc_db <- function(ext_id = NULL, data_src = "med", db = NULL,
                            n_pages = 20) {
  if (is.null(ext_id))
    stop("Please provide a publication id")
  # build request
  if (is.null(db))
    stop("Please restrict reponse to a database")
  path = paste("europepmc/webservices/rest", data_src, ext_id, "databaseLinks",
               db, "json", sep ="/")
  doc <- rebi_GET(path = path)
  hitCount <- doc$hitCount
  if(doc$hitCount == 0)
    stop("No references available")
  no_pages <- rebi_pageing(hitCount = hitCount, pageSize = doc$request$pageSize)
  # limit number of pages that will be retrieved
  if(max(no_pages) > n_pages) no_pages <- 1:n_pages
  pages = list()
  for(i in no_pages){
    out <- rebi_GET(path = paste("europepmc/webservices/rest", data_src, ext_id,
                                 "databaseLinks", db, "json", i, sep ="/"))
    message("Retrieving page ", i)
    result <- plyr::ldply(
      doc$dbCrossReferenceList$dbCrossReference$dbCrossReferenceInfo,
      data.frame, stringsAsFactors = FALSE, .id = NULL
      )
    pages[[i+1]] <- result
  }
  #combine all into one
  result <- jsonlite::rbind.pages(pages)
  # return
  list(hit_count = hitCount, data = result, db = db)
}
