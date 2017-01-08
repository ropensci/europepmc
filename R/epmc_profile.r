#' Obtain a summary of hit counts
#'
#' @description This functions returns the number of results found for your query,
#'   and breaks it down to the various publication types, data sources, and
#'   subsets Europe PMC provides.
#' @param query character, search query. For more information on how to
#'   build a search query, see \url{http://europepmc.org/Help}
#' @examples \dontrun{
#'   epmc_profile('malaria')
#'   # use field search, e.g. query materials and reference section for
#'   # mentions of "ropensci"
#'   epmc_profile('(METHODS:"ropensci")')
#'  }
#' @export
epmc_profile <- function(query = NULL) {
  query <- transform_query(query)
  args <-
    list(
      query = query,
      format = "json")
  out <-
    rebi_GET(path = paste0(rest_path(), "/profile"), query = args)
  lapply(out$profileList, dplyr::as_data_frame)
}
