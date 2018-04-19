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
    # validate input
    val_input(ext_id, data_src, limit, verbose)
    # build request
    path <- mk_path(data_src, ext_id, req_method = "references")
    # how many records are found?
    hit_count <- get_counts(path = path)
    if (hit_count == 0) {
      message("No references found")
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
                   query = list(format = "json", pageSize = limit))
        out <- dplyr::as_data_frame(req$referenceList$reference)
      } else {
        query <-
          make_path(hit_count = hit_count,
                    limit = limit)
        out <- purrr::map_df(query, function(x) {
          req <- rebi_GET(path = path, query = x)
          dplyr::as_data_frame(req$referenceList$reference)
        })
      }
      # return hit count as attribute
      attr(out, "hit_count") <- hit_count
    }
    out
  }
