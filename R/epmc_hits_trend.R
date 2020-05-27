#' Get the yearly number of hits for a query and the total
#' yearly number of hits for a given period
#'
#' @param query query in the Europe PMC syntax
#' @param synonym logical, synonym search. If TRUE, synonym terms from MeSH
#'  terminology and the UniProt synonym list are queried, too. Disabled by
#'  default.
#' @param period a vector of years (numeric) over which to perform the search
#' @param data_src character, data source, by default Pubmed/MedLine index  (\code{med})
#'   will be searched.
#'   The following three letter codes represent the sources, which are currently
#'   supported
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
#'     \item{ppr}{Preprint records}
#'     }
#'
#' @details A similar function was used in
#'  \url{http://www.masalmon.eu/2017/05/14/evergreenreviewgraph/} where
#'  it was advised to not plot no. of hits over time for a query,
#'  but to normalize it by the total no. of hits.
#'
#' @return a data.frame (dplyr tbl_df) with year, total number of hits
#'  (all_hits) and number of hits for the query (query_hits)
#' @export
#'
#' @examples
#' \dontrun{
#' # aspirin as query
#' epmc_hits_trend('aspirin', period = 2006:2016, synonym = FALSE)
#' # link to cran packages in reference lists
#' epmc_hits_trend('REF:"cran.r-project.org*"', period = 2006:2016, synonym = FALSE)
#' # more complex with publication type review
#' epmc_hits_trend('(REF:"cran.r-project.org*") AND (PUB_TYPE:"Review" OR PUB_TYPE:"review-article")',
#' period = 2006:2016, synonym = FALSE)
#' }
epmc_hits_trend <- function(query,
                            synonym = TRUE,
                            data_src = "med",
                            period = 1975:2016) {
  # input validation
  stopifnot(is.character(query),
            is.logical(synonym),
            is.numeric(period))
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
  years <- period
  results <- lapply(
    years,
    epmc_hits_trend_by_year,
    query = query,
    synonym = synonym,
    data_src = data_src
  )
  dplyr::bind_rows(results)
}

epmc_hits_trend_by_year <-
  function(year, query, synonym, data_src) {
    queryforall <-
      paste0('(FIRST_PDATE:[',
             year,
             '-01-01+TO+',
             year,
             '-12-31]) AND SRC:',
             data_src)
    all_hits <-
      as.numeric(europepmc::epmc_profile(queryforall, synonym)$pubType[1, 2])

    queryforterm <-
      paste0(
        '(FIRST_PDATE:[',
        year,
        '-01-01+TO+',
        year,
        '-12-31]) AND ',
        query,
        ' AND SRC:',
        data_src
      )

    query_hits <-
      as.numeric(europepmc::epmc_profile(queryforterm, synonym)$pubType[1, 2])

    return(tibble::tibble(
      year = year,
      all_hits = all_hits,
      query_hits = query_hits
    ))
  }
