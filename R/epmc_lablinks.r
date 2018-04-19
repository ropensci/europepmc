#' Get links to external sources
#'
#' With the External Link services, Europe PMC allows third parties to publish
#' links from Europe PMC to other webpages or tools. Current External Link
#' providers, which can be selected through Europe PMC's advanced search,
#' include Wikipedia, Dryad Digital Repository or other open services.
#' For more information, see
#' \url{http://europepmc.org/labslink}.
#'
#' @param ext_id publication identifier
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
#' @param lab_id character vector, identifiers of the external link service.
#'   Use Europe PMC's advanced search form to find ids.
#' @param limit Number of records to be returned. By default, this function
#'   returns 100 records.
#' @param verbose print information about what's going on
#'
#' @return Links found as nested data_frame
#' @export
#'
#' @examples
#'   \dontrun{
#'   # Fetch links
#'   epmc_lablinks("24007304")
#'   # Link to Altmetric (lab_id = "1562")
#'   epmc_lablinks("25389392", lab_id = "1562")
#'
#'   # Links to Wikipedia
#'   epmc_lablinks("24007304", lab_id = "1507")
#'
#'   # Link to full text copy archived through the institutional repo of
#'   Bielefeld University
#'   epmc_lablinks("12736239", lab_id = "1056")
#'   }

epmc_lablinks <- function(ext_id = NULL,
           data_src = "med",
           lab_id = NULL,
           limit = 100,
           verbose = TRUE) {
    # validate input
    val_input(ext_id, data_src, limit, verbose)
    # build request
    path <- mk_path(data_src, ext_id, req_method = "labsLinks")
    # manipulate lab ids
    if(!is.null(lab_id))
      lab_id <- lab_ids_(lab_id)
    # how many records are found?
    if (!is.null(path))
      doc <- rebi_GET(path = path,
                      query = append(list(format = "json", pageSize = batch_size()),
                                           lab_id)
    )
    hit_count <- doc$hitCount
    if (hit_count == 0) {
      message("Sorry, no links available")
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
                   query = append(list(format = "json", pageSize = limit), lab_id))
        out <- req$providers$provider %>%
          as_data_frame()
      } else {
        query <-
          make_path(hit_count = hit_count,
                    limit = limit)
        out <- purrr::map_df(query, function(x) {
          req <- rebi_GET(path = path, query = append(x, lab_id))
          req$providers$provider %>%
            dplyr::as_data_frame()
        })
      }
      # return hit count as attribute
      attr(out, "hit_count") <- hit_count
    }
    out
  }

#' helper function for labids
#' @noRd
lab_ids_ <- function(x) {
  names(x) <- rep("providerIds", length(x))
  as.list(x)
}
