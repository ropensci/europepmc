#'  Get references for a given publication
#'
#'  This function retrieves all the works listed in the bibliography of a given
#'  article.
#'
#' @param ext_id character, publication identifier
#' @param data_src character, data source, by default Pubmed/MedLine index will
#'   be searched.
#'   The following three letter codes represent the sources
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
#' @param limit integer, number of results. By default, this function
#'   returns 100 records.
#' @param verbose logical, print some information on what is going on.
#'
#' @return returns reference section as tibble

#' @export
#'
#' @examples
#' \dontrun{
#' epmc_refs("PMC3166943", data_src = "pmc")
#' epmc_refs("25378340")
#' epmc_refs("21753913")
#' }
epmc_refs <-
  function(ext_id = NULL,
           data_src = "med",
           limit = 100,
           verbose = TRUE) {
    if (is.null(ext_id))
      stop("Please provide a publication id")
    if (!is.numeric(limit))
      stop("limit must be of type 'numeric'")
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
    req_method <- "references"
    path <- paste(rest_path(), data_src, ext_id, req_method,
                 "json", sep = "/")
    doc <- rebi_GET(path = path)
    hit_count <- doc$hitCount
    if (hit_count == 0)
      stop("No references found")
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
        req_method = req_method
      )
    out <- lapply(paths, function(x) {
      doc <- rebi_GET(path = x)
      plyr::ldply(doc$referenceList,
                  data.frame,
                  stringsAsFactors = FALSE,
                  .id = NULL)
    })
    #combine all into one
    result <- jsonlite::rbind.pages(out) %>%
      dplyr::as_data_frame()
    # return (thanks to @cstubben)
    attr(result, "hit_count") <- hit_count
    result
  }
