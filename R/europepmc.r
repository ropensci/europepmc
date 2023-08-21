#' europepmc - an R client for the Europe PMC RESTful article API
#'
#' @description What is europepmc?:
#'
#' europepmc facilitates access to Europe PMC RESTful Web Service. Europe
#' PMC covers life science literature and gives access to open access full
#' texts. Coverage is not only restricted to Europe, but articles and
#' abstracts are indexed from all over the world. Europe PMC ingests all PubMed
#' content and extends its index with other sources, including Agricola, a
#' bibliographic database of citations to the agricultural literature, or
#' Biological Patents.
#'
#' Besides searching abstracts and full text, europepmc can be used to
#' retrieve reference sections and citations, text-mined terms or cross-links
#' to other databases hosted by the European Bioinformatics Institute (EBI).
#'
#' For more information about Europe PMC, see their current paper:
#' Ferguson, C., Araújo, D., Faulk, L., Gou, Y., Hamelers, A., Huang, Z., 
#' Ide-Smith, M., Levchenko, M., Marinos, N., Nambiar, R., Nassar, M., Parkin, M.,
#' Pi, X., Rahman, F., Rogers, F., Roochun, Y., Saha, S., Selim, M., Shafique, Z.,
#' … McEntyre, J. (2020). Europe PMC in 2020. Nucleic Acids Research, 49(D1), 
#' D1507–D1514. \doi{10.1093/nar/gkaa994}.

#'
#' @name europepmc
#' @docType package
#'
#' @importFrom urltools url_decode
#' @importFrom utils URLencode
#' @importFrom plyr rbind.fill ldply
#' @importFrom jsonlite fromJSON rbind_pages validate
#' @importFrom httr GET RETRY content stop_for_status status_code user_agent
#'   modify_url
#' @importFrom dplyr %>% select_if bind_rows bind_cols
#'   progress_estimated
#' @importFrom stats runif
#' @importFrom xml2 read_xml
#' @importFrom progress progress_bar
#' @importFrom purrr map map_df
#' @importFrom tibble as_tibble tibble
#' @importFrom tidyr unnest
#' @importFrom rlang .data
"_PACKAGE"
