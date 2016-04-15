# utils

# base uri
base_uri <- function() "http://www.ebi.ac.uk"

# rest path
rest_path <- function() "europepmc/webservices/rest"
# check data sources
supported_data_src <- c("agr", "cba", "ctx", "eth", "hir", "med", "nbk", "pat",
                        "pmc")

# Common methods:

# Implementing GET method and json parser for EPMC
rebi_GET <- function(path = NULL, query = NULL, ...) {
  if (is.null(path) && is.null(query))
    stop("Nothing to search")
  # call api
  req <- httr::GET(base_uri(), path = path, query = query)
  # check for http status
  httr::stop_for_status(req)
  # load json into r
  out <- httr::content(req, "text")
  # valid json
  if(!jsonlite::validate(out))
    stop("Upps, nothing to parse, please check your query")
  doc <- jsonlite::fromJSON(out)
  if (!exists("doc"))
    stop("No json to parse", call. = FALSE)
  doc
}

# Calculate pages. Each page consists of 25 records.
rebi_pageing <- function(hitCount, pageSize) {
  if (all.equal((hitCount / pageSize), as.integer(hitCount / pageSize)) == TRUE) {
    1:(hitCount / pageSize)
  } else {
    1:(hitCount / pageSize + 1)
  }
}

# fix to remove columns that cannot be easily flatten from the data.frame
fix_list <- function(x){
  if(!is.null(x))
    tmp <- plyr::ldply(x, is.list)
  tmp[tmp$V1 == TRUE, ".id"]
}


