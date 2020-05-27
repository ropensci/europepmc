#' Summarise links to external sources
#'
#' With the External Link services, Europe PMC allows third parties to publish
#' links from Europe PMC to other webpages or tools. Current External Link
#' providers, which can be selected through Europe PMC's advanced search,
#' include Wikipedia, Dryad Digital Repository or the institutional repo of
#' Bielefeld University. For more information, see
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
#' @export
#' @return data.frame with counts for each database
#' @examples
#'    \dontrun{
#'    epmc_lablinks_count("24023770")
#'    epmc_lablinks_count("PMC3986813", data_src = "pmc")
#'    }
epmc_lablinks_count <- function(ext_id = NULL, data_src = "med") {
  # validate input
  val_input(ext_id, data_src, limit = 1, verbose = FALSE)
  # build request
  path <- mk_path(data_src, ext_id, req_method = "labsLinks")
  doc <- rebi_GET(path = path, query = list(format = "json"))
  if (doc$hitCount == 0) {
    message("Sorry, no links available")
    NULL
  } else {
    tibble::as_tibble(plyr::rbind.fill(doc$linksCountList))
  }
}
