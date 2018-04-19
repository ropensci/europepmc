#' Retrieve the number of database links from Europe PMC publication database
#'
#' This function returns the number of database links for each EBI database from
#'   Europe PMC RESTful Web Service.
#' @details Europe PMC supports the following semantic types:
#'     \describe{
#'     \item{ACCESSION}{accession IDs for DNA or protein sequences}
#'     \item{CHEMICAL}{chemicals}
#'     \item{DISEASE}{diseases}
#'     \item{EFO}{Experimental Factor Ontology
#'       (\url{http://www.ebi.ac.uk/efo/})}
#'     \item{GENE_PROTEIN}{gene proteins}
#'     \item{GO_TERM}{Gene Ontology Terms (\url{http://geneontology.org/})}
#'     \item{ORGANISM}{organism}
#'     }
#'
#' @param ext_id character, publication identifier
#' @param data_src character, data source, by default Pubmed/MedLine index will
#'   be searched.
#' @return data.frame with counts for each semantic type
#' @export
#' @examples
#'   \dontrun{
#'   epmc_tm_count("PMC4340542", data_src = "pmc")
#'   }

epmc_tm_count <- function(ext_id = NULL, data_src = "med") {
  if (!tolower(data_src) %in% c("pmc", "med"))
    stop(
      paste0(
        "Data source '",
        data_src,
        "' not supported. Try one of the
        following sources: ",
        paste0(c("med", "pmc"), collapse = ", ")
      )
    )
  # build request
  path <- mk_path(data_src, ext_id, req_method = "textMinedTerms")
  # how many records are found?
  doc <- rebi_GET(path = path,
                  query = list(format = "json"))
  if (doc$hitCount == 0) {
    message("Sorry, no text-mined terms found")
    NULL
  } else {
    plyr::rbind.fill(doc$semanticTypeCountList) %>%
      dplyr::as_data_frame()
  }
}
