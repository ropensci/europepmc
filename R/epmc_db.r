#' Retrieve external database entities referenced in a given publication
#'
#' This function returns EBI database entities referenced in a publication from
#' Europe PMC RESTful Web Service.
#'
#' @inheritParams epmc_refs
#' @param db character, specify database:
#'  \describe{
#'  \item{'ARXPR'}{Array Express, a database of functional genomics experiments
#'     \url{https://www.ebi.ac.uk/arrayexpress/}}
#'  \item{'CHEBI'}{a database and ontology of chemical entities of biological
#'      interest \url{http://www.ebi.ac.uk/chebi/}}
#'   \item{'CHEMBL'}{a database of bioactive drug-like small molecules
#'      \url{https://www.ebi.ac.uk/chembldb/}}
#'   \item{'EMBL'}{now ENA, provides a comprehensive record of the world's
#'   nucleotide sequencing information \url{http://www.ebi.ac.uk/ena/}}
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
#'   \item{'PRIDE'}{PRIDE Archive - proteomics data repository
#'   \url{https://www.ebi.ac.uk/pride/archive/}}}
#'
#' @return Cross-references as data.frame
#' @examples
#'   \dontrun{
#'   epmc_db("12368864", db = "uniprot", limit = 150)
#'   epmc_db("25249410", db = "embl")
#'   epmc_db("14756321", db = "uniprot")
#'   epmc_db("11805837", db = "pride")
#'   }
#' @export
epmc_db <- function(ext_id = NULL,
                    data_src = "med",
                    db = NULL,
                    limit = 100,
                    verbose = TRUE) {
  # validate input
  val_input(ext_id, data_src, limit, verbose)
  if (is.null(db))
    stop("Please restrict reponse to a database")
  if (!toupper(db) %in% supported_db)
    stop(
      paste0(
        "Data source '",
        db,
        "' not supported. Try one of the
        following sources: ",
        paste0(supported_db, collapse = ", ")
      )
    )
  # build request
  path <- mk_path(data_src, ext_id, req_method = "databaseLinks")
  # how many records are found?
  hit_count <- get_counts(path = path, database = db)
  if (hit_count == 0) {
    message("No links found")
    out <- NULL
  } else {
    # provide info
    msg(hit_count = hit_count,
        limit = limit,
        verbose = verbose)
    # request records and parse them
    # request records and parse them
    if (hit_count >= limit) {
      req <-
        rebi_GET(path = path,
                 query = list(format = "json", pageSize = limit, database = db))
      out <- dplyr::bind_cols(req$dbCrossReferenceList$dbCrossReference$dbCrossReferenceInfo)
    } else {
      query <-
        make_path(hit_count = hit_count,
                  limit = limit, database = db)
      out <- purrr::map_df(query, function(x) {
        req <- rebi_GET(path = path, query = x)
        dplyr::bind_cols(req$dbCrossReferenceList$dbCrossReference$dbCrossReferenceInfo)
      })
    }
    dplyr::as_data_frame(out)
    # return hit count as attribute
    attr(out, "hit_count") <- hit_count
  }
  out
}



#
#
#     paths <-
#       make_path(
#         hit_count = hit_count,
#         limit = limit,
#         ext_id = ext_id,
#         data_src = data_src,
#         req_method = req_method,
#         database = db
#       )
#     out <- lapply(paths, function(x) {
#       doc <- rebi_GET(path = x)
#       plyr::ldply(
#         doc$dbCrossReferenceList$dbCrossReference$dbCrossReferenceInfo,
#         data.frame,
#         stringsAsFactors = FALSE,
#         .id = NULL
#       )
#     })
#     #combine all into one
#     result <- jsonlite::rbind_pages(out) %>%
#       dplyr::as_data_frame()
#     # return
#     attr(result, "hit_count") <- hit_count
#   }
#   result
# }


# supported dbs
supported_db <-
  c("ARXPR",
    "CHEBI",
    "CHEMBL",
    "EMBL",
    "INTACT",
    "INTERPRO",
    "OMIM",
    "PDB",
    "UNIPROT",
    "PRIDE")
