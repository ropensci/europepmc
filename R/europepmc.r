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
#' Europe PMC: a full-text literature database for the life sciences and
#' platform for innovation. (2014). Nucleic Acids Research, 43(D1), D1042-D1048.
#' \url{http://doi.org/10.1093/nar/gku1061}.
#'
#' @name europepmc
#' @docType package
#'
#' @importFrom urltools url_decode
#' @importFrom utils URLencode
#' @importFrom plyr rbind.fill ldply
#' @importFrom jsonlite fromJSON rbind_pages
#' @importFrom httr GET content stop_for_status status_code user_agent
#' @importFrom dplyr %>% as_data_frame select_if data_frame bind_rows
#' @importFrom stats runif
#' @importFrom xml2 read_xml
#' @importFrom progress progress_bar
NULL
