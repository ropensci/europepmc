#' Get text-mined terms
#'
#' Retrieve a count and list of terms text-mined from
#' full text publications by Europe PMC.
#'
#'@inheritParams epmc_refs
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
#' @return Terms found as data.frame
#' @examples
#' \dontrun{
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
    if (is.null(ext_id))
      stop("Please provide a publication id")
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
    if (is.null(semantic_type))
      stop("Please Specify the semantic type you wish to
           retrieve text-mined terms for")
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
    stopifnot(is.numeric(limit))
    stopifnot(is.logical(verbose))
    # build request
    req_method <- "textMinedTerms"
    path <- paste(rest_path(),
                  data_src,
                  ext_id,
                  req_method,
                  semantic_type,
                  "json",
                  sep = "/")
    doc <- rebi_GET(path = path)
    hit_count <- doc$hitCount
    if (hit_count == 0)
      stop("Sorry, no text-mined terms found")
    paths <-
      make_path(
        hit_count = hit_count,
        limit = limit,
        ext_id = ext_id,
        data_src = data_src,
        req_method = req_method,
        type = semantic_type
      )
    out <- lapply(paths, function(x) {
      if (verbose == TRUE)
        message(paste0(
          hit_count,
          " records found. Returning ",
          ifelse(hit_count <= limit, hit_count, limit)
        ))
      doc <- rebi_GET(path = x)
      plyr::ldply(
        doc$semanticTypeList$semanticType$tmSummary,
        data.frame,
        stringsAsFactors = FALSE,
        .id = NULL
      )
    })
    #combine all into one
    result <- jsonlite::rbind.pages(out) # %>%
    # TO DO: unnest dplyr::as_data_frame()
    # return
    attr(result, "hit_count") <- hit_count
    result
  }

# check semantic types

supported_semantic_types <-
  c("ACCESSION",
    "CHEMICAL",
    "DISEASE",
    "EFO",
    "GENE_PROTEIN",
    "GO_TERM",
    "ORGANISM")
