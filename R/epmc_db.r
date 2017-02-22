#' Retrieve external database entities referenced in a given publication
#'
#' This function returns EBI database entities referenced in a publication from
#' Europe PMC RESTful Web Service.
#'
#' @inheritParams epmc_refs
#' @param db character, restrict the response to a specific database:
#'  \describe{
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
#'   \url{https://www.ebi.ac.uk/pride/archive/}}
#'   }

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
  if (is.null(ext_id))
    stop("Please provide a publication id")
  # build request
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
  if (!tolower(data_src) %in% supported_data_src)
    stop(
      paste0(
        "Data source '",
        data_src,
        "' not supported. Try one of the
        following sources: ",
        paste0(supported_data_src, collapse = ", ")
      )
    )
  stopifnot(is.numeric(limit))
  stopifnot(is.logical(verbose))
  # build request
  req_method <- "databaseLinks"
  path = paste(rest_path(), data_src, ext_id, req_method, db,
               "json", sep = "/")
  doc <- rebi_GET(path = path)
  hit_count <- doc$hitCount
  if (hit_count == 0)
    stop("Sorry, no links found")
  if (verbose == TRUE)
    message(paste0(
      hit_count,
      " records found. Returning ",
      ifelse(hit_count <= limit, hit_count, limit)
    ))
  paths <-
    make_path(
      hit_count = hit_count,
      limit = limit,
      ext_id = ext_id,
      data_src = data_src,
      req_method = req_method,
      type = db
    )
  out <- lapply(paths, function(x) {
    doc <- rebi_GET(path = x)
    plyr::ldply(
      doc$dbCrossReferenceList$dbCrossReference$dbCrossReferenceInfo,
      data.frame,
      stringsAsFactors = FALSE,
      .id = NULL
    )
  })
  #combine all into one
  result <- jsonlite::rbind.pages(out) %>%
    dplyr::as_data_frame()
  # return
  attr(result, "hit_count") <- hit_count
  result
}


# supported dbs
supported_db <-
  c("CHEBI",
    "CHEMBL",
    "EMBL",
    "INTACT",
    "INTERPRO",
    "OMIM",
    "PDB",
    "UNIPROT",
    "PRIDE")
