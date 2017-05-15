#' Get the yearly number of hits for a query and the total yearly number of hits for a given period
#'
#' @param query query in the Europe PMC syntax
#' @param synonym logical, synonym search. If TRUE, synonym terms from MeSH
#'  terminology and the UniProt synonym list are queried, too. Disabled by
#'  default.
#' @param period a vector of years (numeric) over which to perform the search
#'
#' @details A similar function was used in http://www.masalmon.eu/2017/05/14/evergreenreviewgraph/ where
#' it was advised to not plot no. of hits over time for a query, but to normalize it by the total no. of hits.
#'
#' @return a data.frame (dplyr tbl_df) with year, total number of hits (all_hits) and number of hits for the query (query_hits)
#' @export
#'
#' @examples
#' \dontrun{
#' # aspirin as query
#' epmc_hits_trend('aspirin', period = 2006:2016, synonym = FALSE)
#' # link to cran packages in reference lists
#' epmc_hits_trend('REF:"cran.r-project.org*"', period = 2006:2016, synonym = FALSE)
#' # more complex with source Medline and publication type review
#' epmc_hits_trend('(REF:"cran.r-project.org*") AND (SRC:"MED") AND (PUB_TYPE:"Review" OR PUB_TYPE:"review-article")', period = 2006:2016, synonym = FALSE)
#' }
epmc_hits_trend <- function(query,
                            synonym = TRUE,
                            period = 1975:2016) {
  years <- period
  results <- lapply(years,
               epmc_hits_trend_by_year,
               query = query,
               synonym = synonym)
  dplyr::bind_rows(results)
}

epmc_hits_trend_by_year <- function(year, query, synonym) {
  queryforall <-
    paste0('(FIRST_PDATE:[', year, '-01-01+TO+', year, '-12-31])')
  all_hits <-
    as.numeric(europepmc::epmc_profile(queryforall, synonym)$pubType[1, 2])

  queryforterm <-
    paste0('(FIRST_PDATE:[',
           year,
           '-01-01+TO+',
           year,
           '-12-31]) AND ',
           query)

  query_hits <-
    as.numeric(europepmc::epmc_profile(queryforterm, synonym)$pubType[1, 2])

  return(dplyr::as_data_frame(
    year = year,
    all_hits = all_hits,
    query_hits = query_hits
  ))
}
