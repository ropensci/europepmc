#' europepmc - an R client for the Europe PMC RESTful article API
#'
#' @section What is europepmc?:
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
#' Levchenko, M., Gou, Y., Graef, F., Hamelers, A., Huang, Z., Ide-Smith, M.,
#'  … McEntyre, J. (2017). Europe PMC in 2017. Nucleic Acids Research, 46(D1),
#'  D1254–D1260. \url{https://doi.org/10.1093/nar/gkx1005}.

#'
#' @name europepmc
#' @docType package
#'
#' @importFrom urltools url_decode
#' @importFrom utils URLencode
#' @importFrom plyr rbind.fill ldply
#' @importFrom jsonlite fromJSON rbind_pages
#' @importFrom httr GET content stop_for_status status_code user_agent
#' @importFrom dplyr %>% as_data_frame select_if data_frame bind_rows bind_cols
#' @importFrom stats runif
#' @importFrom xml2 read_xml
#' @importFrom progress progress_bar
#' @importFrom purrr map map_df
NULL
