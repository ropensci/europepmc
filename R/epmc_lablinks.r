#' Get links to external sources
#'
#' With the External Link services, Europe PMC allows third parties to publish
#' links from Europe PMC to other webpages or tools. Current External Link
#' providers, which can be selected through Europe PMC's advanced search,
#' include Wikipedia, Dryad Digital Repository or other open services.
#' For more information, see
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
#' @param lab_id identifier of the external link service. Use Europe PMC's
#'   advanced search form to find an id.
#' @param n_pages Number of pages to be returned. By default, this function
#'   returns 10 records for each page.
#'
#' @return Links found as data.frame
#' @export
#'
#' @examples
#'   \dontrun{
#'   # Link to Altmetric (lab_id = 1562)
#'   epmc_lablinks("25389392", lab_id = "1562")
#'
#'   # Links to Wikipedia
#'   epmc_lablinks("24007304", lab_id = "1507")
#'
#'   # Link to full text copy archived through the institutional repo of
#'   Bielefeld University
#'   epmc_lablinks("12736239", lab_id = "1056")
#'   }

epmc_lablinks <-
  function(ext_id = NULL,
           data_src = "med",
           lab_id = NULL,
           n_pages = 20) {
    if (is.null(ext_id))
      stop("Please provide a publication id")
    if (!is.numeric(n_pages))
      stop("n_pages must be of type 'numeric'")
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
    # build request
    if (is.null(lab_id))
      stop(
        "Please restrict your query to one external link provider. You'll find
        all providers in Europe PMC's advanced search form."
      )
    path <- paste(rest_path(),
                 data_src,
                 ext_id,
                 "labsLinks",
                 lab_id,
                 "json",
                 sep = "/")
    doc <- rebi_GET(path = path)
    hitCount <- doc$hitCount
    if (doc$hitCount == 0)
      stop("Sorry, no links available")
    no_pages <-
      rebi_pageing(hitCount = hitCount, pageSize = doc$request$pageSize)
    # limit number of pages that will be retrieved
    if (max(no_pages) > n_pages)
      no_pages <- 1:n_pages
    pages <- list()
    for (i in no_pages) {
      out <- rebi_GET(path = paste(
        rest_path(),
        data_src,
        ext_id,
        "labsLinks",
        lab_id,
        i,
        "json",
        sep = "/"
      ))
      message("Retrieving page ", i)
      result <- plyr::ldply(
        out$providers$provider$link,
        data.frame,
        stringsAsFactors = FALSE,
        .id = NULL
      )
      pages[[i + 1]] <- result
    }
    #combine all into one
    tt <- jsonlite::rbind.pages(pages)
    # add lablink metadata
    result <- cbind(
      tt,
      lab_id = doc$providers$provider$id,
      lab_name = doc$providers$provider$name,
      lab_description = doc$providers$provider$description
    )
    attr(result, "hit_count") <- hitCount
    dplyr::as_data_frame(result)
  }
