#' Get text-mined terms
#'
#' Retrieve a count and a list of text-mined terms gathered by Europe PMC.
#'
#' @param ext_id character, publication identifier
#' @param data_src character, data source, by default Pubmed/MedLine index will be searched.
#'   The only sources relevant to this methods are \code{med} and \code{pmc}.
#'   \describe{
#'   \item{med}{Publications from PubMed and MEDLINE}
#'   \item{pmc}{Publications from PubMed Central}}
#'
#' @param semantic_type controlled vocabulary. Specify the semantic type you
#'   wish to retrieve. The following types are supported:
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
#' @param limit Number of records to be returned. By default, this function
#'   returns 100 records.
#' @param verbose print information about what's going on
#'
#' @return Terms found as tibble
#' @examples
#' \dontrun{
#' epmc_tm("25249410")
#' epmc_tm("25249410", semantic_type = "GO_TERM")
#' epmc_tm("PMC4340542", data_src = "pmc", semantic_type = "GO_TERM")
#' }
#' @export
epmc_tm <-
  function(ext_id = NULL,
           data_src = "med",
           semantic_type = NULL,
           limit = 100,
           verbose = TRUE) {
    # validate input
    val_input(ext_id, data_src, limit, verbose)
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
    if (!is.null(semantic_type))
    #   stop("Please Specify the semantic type you wish to
    #        retrieve text-mined terms for")
      if (!toupper(semantic_type) %in% supported_semantic_types)
      stop(
        paste0(
          "Controlled vocabulary '",
          semantic_type,
          "' not supported. Try
          one of the following types: ",
          paste0(supported_semantic_types, collapse = ", ")
        )
      )
    # build request
    path <- mk_path(data_src, ext_id, req_method = "textMinedTerms")
    # how many records are found?
    doc <- rebi_GET(path = path,
                            query = list(format = "json", pageSize = batch_size(), semantic_type = semantic_type))
    hit_count <- doc$hitCount
    if (hit_count == 0) {
      message("Sorry, no text-mined terms found")
      out <- NULL
    } else {
      # provide info
      msg(hit_count = hit_count,
          limit = limit,
          verbose = verbose)
      # request records and parse them
      if (hit_count >= limit) {
        req <-
          rebi_GET(path = path,
                   query = list(format = "json", pageSize = limit, semantic_type = semantic_type))
        out <-req$semanticTypeList$semanticType$tmSummary
        names(out) <- req$semanticTypeList$semanticType$name
      } else {
        query <-
          make_path(hit_count = hit_count,
                    limit = limit, semantic_type = semantic_type)
        out <- lapply(query, function(x) {
          req <- rebi_GET(path = path, query = x)
          tmp <- req$semanticTypeList$semanticType$tmSummary
          names(tmp) <- req$semanticTypeList$semanticType$name
          tmp
        })
      }
      #combine all into one
      out
      attr(out, "hit_count") <- hit_count
      # return hit count as attribute
    }
    out
  }


#
#
#     # build request
#     req_method <- "textMinedTerms"
#     path <- paste(rest_path(),
#                   data_src,
#                   ext_id,
#                   req_method,
#                   semantic_type,
#                   "json",
#                   sep = "/")
#     doc <- rebi_GET(path = path)
#     hit_count <- doc$hitCount
#     if (hit_count == 0) {
#       message("Sorry, no text-mined terms found")
#       result <- NULL
#     } else {
#       paths <-
#         make_path(
#           hit_count = hit_count,
#           limit = limit,
#           ext_id = ext_id,
#           data_src = data_src,
#           req_method = req_method,
#           type = semantic_type
#         )
#       out <- plyr::ldply(paths, function(x) {
#         if (verbose == TRUE)
#           message(paste0(
#             hit_count,
#             " records found. Returning ",
#             ifelse(hit_count <= limit, hit_count, limit)
#           ))
#         doc <- rebi_GET(path = x)
#         plyr::ldply(
#           doc$semanticTypeList$semanticType$tmSummary,
#           as.data.frame,
#           stringsAsFactors = FALSE,
#           .id = NULL
#         )
#       })
#       #combine all into one
#       result <- dplyr::data_frame(
#         term = out$term,
#         alt_term = out$altNameList$altName,
#         db_name = out$dbName,
#         db_ids = unlist(out$dbIdList$dbId)
#       )
#       attr(result, "hit_count") <- hit_count
#     }
#     # result
#     result
#   }
#
# # check semantic types

supported_semantic_types <-
  c("ACCESSION",
    "CHEMICAL",
    "DISEASE",
    "EFO",
    "GENE_PROTEIN",
    "GO_TERM",
    "ORGANISM")


