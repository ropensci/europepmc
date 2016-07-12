#' Get details for individual records
#'
#' This function returns full metadata for a given publication ID
#' including abstract, full text links, author details including ORCID and affiliation,
#' MeSH terms, chemicals, grants.
#'
#' @param ext_id character, publication identifier
#' @param data_src character, data source, by default Pubmed/MedLine index will
#'   be searched.
#'   Other sources Europe PubMed Central supports are:
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
#'
#' @return list of data frames
#' @export
#'
#' @examples
#' \dontrun{
#' epmc_details(ext_id = "24270414")
#'
#' # PMC record
#' epmc_details(ext_id = "PMC4747116", data_src = "pmc")
#'
#' # Other sources:
#' # Agricolo
#' epmc_details("IND43783977", data_src = "agr")
#' # Biological Patents
#' epmc_details("EP2412369", data_src = "pat")
#' # Chinese Biological Abstracts
#' epmc_details("583843", data_src = "cba")
#' # CiteXplore
#' epmc_details("C7603", data_src = "ctx")
#' # NHS Evidence
#' epmc_details("338638", data_src = "hir")
#' # Theses
#' epmc_details("409323", data_src = "eth")
#' # Books
#' epmc_details("NBK338142", data_src = "nbk")
#' }
epmc_details <- function(ext_id = NULL, data_src = "med") {
  if (is.null(ext_id))
    stop("Please provide a publication id")
  if (!tolower(data_src) %in% supported_data_src)
    stop(paste0("Data source '", data_src, "' not supported. Try one of the
                following sources: ", paste0(supported_data_src, collapse =", ")
                ))
  # build request
  path = paste0(rest_path(), "/search")
  if(data_src == "pmc") {
    q <- list(query = paste0("PMCID:", ext_id), format = "json",
            resulttype = "core")
  } else {
    q <- list(query = paste0("ext_id:", ext_id, " src:", data_src),
              format = "json", resulttype = "core")
  }
  doc <- rebi_GET(path = path, query = q)
  if(doc$hitCount == 0)
    stop("nothing found, please check your query")
  res <- doc$resultList$result
  # result
  out <- list(basic = res[, !names(res) %in% fix_list(res)],
              author_details = plyr::rbind.fill(res$authorList$author),
              journal_info = plyr::rbind.fill(res$journalInfo),
              ftx = plyr::rbind.fill(res$fullTextUrlList$fullTextUrl),
              chemical = plyr::rbind.fill(res$chemicalList$chemical),
              mesh_topic = plyr::rbind.fill(res$meshHeadingList$meshHeading)[-3],
#             mesh_qualifier = plyr::rbind.fill(res$mesh$meshQualifierList$meshQualifier),
              comments = plyr::rbind.fill(res$commentCorrectionList$commentCorrection),
              grants =  plyr::rbind.fill(res$grantsList$grant)
  )
  out
}
