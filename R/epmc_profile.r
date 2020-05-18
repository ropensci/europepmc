#' Obtain a summary of hit counts
#'
#' @description This functions returns the number of results found for your query,
#'   and breaks it down to the various publication types, data sources, and
#'   subsets Europe PMC provides.
#' @param query character, search query. For more information on how to
#'   build a search query, see \url{http://europepmc.org/Help}
#' @param synonym logical, synonym search. If TRUE, synonym terms from MeSH
#'  terminology and the UniProt synonym list are queried, too. Enabled by
#'  default.
#' @examples \dontrun{
#'   epmc_profile('malaria')
#'   # use field search, e.g. query materials and reference section for
#'   # mentions of "ropensci"
#'   epmc_profile('(METHODS:"ropensci")')
#'  }
#' @export
epmc_profile <- function(query = NULL, synonym = TRUE) {
  synonym <- ifelse(synonym == FALSE, "false", "true")
  # this is so far the only way how I got the synonym paramworking after
  # the API change.
  # there is a possible conflict with the resumption token and
  # decoding the API call.
  query <- transform_query(paste0(query, "&synonym=", synonym))
  args <-
    list(query = query,
         format = "json")
  out <-
    rebi_GET(path = paste0(rest_path(), "/profile"), query = args)
  lapply(out$profileList, tibble::as_tibble)
}
