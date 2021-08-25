#' Retrieve the number of database links from Europe PMC publication database
#'
#' This function returns the number of EBI database links associated with a
#' publication.
#'
#' @details Europe PMC supports cross-references between literature and the
#'   following databases:
#'  \describe{
#'  \item{'ARXPR'}{Array Express, a database of functional genomics experiments}
#'  \item{'CHEBI'}{a database and ontology of chemical entities of biological
#'      interest}
#'   \item{'CHEMBL'}{a database of bioactive drug-like small molecules}
#'   \item{'EMBL'}{now ENA, provides a comprehensive record of the world's
#'   nucleotide sequencing information}
#'   \item{'INTACT'}{provides a freely available, open
#'      source database system and analysis tools for molecular interaction data}
#'   \item{'INTERPRO'}{provides functional analysis of proteins by classifying
#'      them into families and predicting domains and important sites}
#'   \item{'OMIM'}{a comprehensive and authoritative compendium of human genes and
#'      genetic phenotypes}
#'   \item{'PDB'}{European resource for the collection,
#'      organisation and dissemination of data on biological macromolecular
#'      structures}
#'   \item{'UNIPROT'}{comprehensive and freely accessible
#'      resource of protein sequence and functional information}
#'   \item{'PRIDE'}{PRIDE Archive - proteomics data repository}}
#'
#' @param ext_id character, publication identifier
#' @param data_src character, data source, by default Pubmed/MedLine index will
#'   be searched.
#' @return data.frame with counts for each database
#' @export
#' @examples
#'   \dontrun{
#'   epmc_db_count(ext_id = "10779411")
#'   epmc_db_count(ext_id = "PMC3245140", data_src = "PMC")
#'   }
epmc_db_count <- function(ext_id = NULL, data_src = "med") { # validate input
  val_input(ext_id, data_src, limit = 1, verbose = FALSE)
  # build request
  # build request
  path <- mk_path(data_src, ext_id, req_method = "databaseLinks")
  doc <- rebi_GET(path = path, query = list(format = "json"))
  if (doc$hitCount == 0) {
    message("Nothing found")
    NULL
  } else {
    plyr::rbind.fill(doc$dbCountList) %>%
      tibble::as_tibble()
  }
}
