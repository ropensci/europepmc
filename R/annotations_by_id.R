#' Get annotations by article
#'
#' Retrieve text-mined annotations contained in abstracts and open access
#' full-text articles.
#'
#' @param ids, character vector with publication identifiers
#'  following the structure "source:ext_id", e.g. `"MED:28585529"`
#'
#' @return returns text-mined annotations in a tidy format with the following
#' variables
#'
#' \describe{
#'   \item{source}{Publication data source}
#'   \item{ext_id}{Article Identifier}
#'   \item{pmcid}{PMCID that locates full-text in Pubmed Central}
#'   \item{prefix}{Text snipped found before the annotation}
#'   \item{exact}{Annotated entity}
#'   \item{postfix}{Text snipped found after the annotation}
#'   \item{name}{Targeted entity}
#'   \item{uri}{Uniform link dictionary entry for targeted entity}
#'   \item{id}{URL to full-text occurence of the annotation}
#'   \item{type}{Type of annotation like Chemicals}
#'   \item{section}{Article section mentioning the annotation like Methods}
#'   \item{provider}{Annotation data provider}
#'   \item{subtype}{Sub-data provider}
#'}
#'
#' @examples \dontrun{
#'   annotations_by_id("MED:28585529")
#'   # multiple ids
#'   annotations_by_id(c("MED:28585529", "PMC:PMC1664601"))
#' }
#' @export
epmc_annotations_by_id <- function(ids = NULL){
  # input validation
  stopifnot(!is.null(ids))
  # remove empty characters
  if (any(ids %in% "")) {
    ids <- ids[ids != ""]
    warning("Removed empty characters from DOI vector")
  }
  # progress
  pb <- dplyr::progress_estimated(length(ids))
  purrr::map_df(ids, epmc_annotations_by_id_, .pb = pb)
}

epmc_annotations_by_id_ <- function(ids = NULL, .pb = NULL) {
  # https://rud.is/b/2017/03/27/all-in-on-r%E2%81%B4-progress-bars-on-first-post/
  if ((!is.null(.pb)) &&
      inherits(.pb, "Progress") && (.pb$i < .pb$n))
    .pb$tick()$print()

  args <- list(
    articleIds = ids,
    format = "json"
  )
  req <- rebi_GET(path = c(anno_path(), "annotationsByArticleIds"), query = args)
  # API sometimes returns empty response when nothing is found,
  # but id is syntactically correct
  if(length(req) != 0) {
  out <- tibble::tibble(source = req[["source"]],
                 ext_id = req[["extId"]],
                 pmcid = req[["pmcid"]],
                 annotations = req[["annotations"]])
  tidyr::unnest(
    tidyr::unnest(out, .data$annotations),
    .data$tags)
  } else {
    NULL
  }
}
