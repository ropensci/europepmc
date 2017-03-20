# utils

# base uri
base_uri <- function()
  "http://www.ebi.ac.uk"

# rest path
rest_path <- function()
  "europepmc/webservices/rest"

# set user agent
ua <- httr::user_agent("https://github.com/ropensci/europepmc")

# check data sources
supported_data_src <-
  c("agr", "cba", "ctx", "eth", "hir", "med", "pat",
    "pmc")

# default batch size
batch_size <- function()
  100


# Common methods:

# Implementing GET method and json parser for EPMC
rebi_GET <- function(path = NULL, query = NULL, ...) {
  if (is.null(path) && is.null(query))
    stop("Nothing to search")
  # call api, decode workaround because Europe PMC only accepts decoded cursor
  req <- rGET(urltools::url_decode(httr::modify_url(
    base_uri(), path = path, query = query
  )), ua)
  # check for http status
  httr::stop_for_status(req)
  # load json into r
  out <- httr::content(req, "text")
  # valid json
  if (!jsonlite::validate(out))
    stop("Upps, nothing to parse, please check your query")
  # return core format as list
  if (length(query$resulttype) == 1 && query$resulttype == "core") {
    doc <- out
  } else {
    doc <- jsonlite::fromJSON(out)
  }
  if (!exists("doc"))
    stop("No json to parse", call. = FALSE)
  return(doc)
}

# # build query
# build_query <- function(query, page, batch_size, ...) {
#   list(
#     query = query,
#     format = "json",
#     page = page,
#     pageSize = batch_size,
#     ...
#   )
# }

# Calculate pages. Each page consists of 25 records.
rebi_pageing <- function(hitCount, pageSize) {
  if (all.equal((hitCount / pageSize), as.integer(hitCount / pageSize)) == TRUE) {
    1:(hitCount / pageSize)
  } else {
    1:(hitCount / pageSize + 1)
  }
}

# make paths according to limit and request methods
make_path <- function(hit_count = NULL,
                      limit = NULL,
                      ext_id = NULL,
                      data_src = NULL,
                      req_method = NULL,
                      type = NULL) {
  limit <- as.integer(limit)
  limit <- ifelse(hit_count <= limit, hit_count, limit)
  if (limit > batch_size()) {
    tt <- chunks(limit)
    paths <- lapply(1:(tt$page_max - 1), function(x)
      paste(
        c(
          rest_path(),
          data_src,
          ext_id,
          req_method,
          type,
          x,
          batch_size(),
          "json"
        ),
        collapse = "/"
      ))
    paths <- append(paths, list(paste(
      c(
        rest_path(),
        data_src,
        ext_id,
        req_method,
        type,
        tt$page_max,
        tt$last_chunk,
        "json"
      ),
      collapse = "/"
    )))
  } else {
    paths <-
      paste(c(
        rest_path(),
        data_src,
        ext_id,
        req_method,
        type,
        1,
        limit,
        "json"
      ),
      collapse = "/")
  }
  paths
}

# make_queries <-
#   function(hit_count = hit_count,
#            limit = limit,
#            query = query) {
#     limit <- as.integer(limit)
#     limit <- ifelse(hit_count <= limit, hit_count, limit)
#     if (limit > batch_size()) {
#       tt <- chunks(limit)
#       queries <-
#         lapply(1:(tt$page_max - 1),
#                build_query,
#                batch_size = batch_size(),
#                query = query)
#       queries <-
#         append(queries, list(
#           build_query(
#             query = query,
#             page = tt$page_max,
#             batch_size = tt$last_chunk
#           )
#         ))
#     } else {
#       queries <-
#         list(build_query(
#           page = 1,
#           query = query,
#           batch_size = limit
#         ))
#     }
#     queries
#   }

# calculate number of page chunks needed in accordance with limit param
chunks <- function(limit, ...) {
  if (all.equal(limit / batch_size(),
                as.integer(limit / batch_size())) == TRUE) {
    page_max <- limit / batch_size()
    last_chunk <- batch_size()
  } else {
    page_max <- as.integer(limit / batch_size()) + 1
    last_chunk <- limit - ((page_max - 1) * batch_size())
  }
  list(page_max = page_max, last_chunk = last_chunk)
}


# fix to remove columns that cannot be easily flatten from the data.frame
fix_list <- function(x) {
  if (!is.null(x))
    tmp <- plyr::ldply(x, is.list)
  tmp[tmp$V1 == TRUE, ".id"]
}

# URL encode parts of the query. Needed because EPMC inconsistently
# deal with URL encoding
transform_query <- function(query = NULL) {
  # check
  if (is.null(query))
    stop("No query provided")
  query <- URLencode(query)
  return(query)
}


# There is a problem with accidental internal server error (HTTP 500),
# which, for instance, leads to CRAN checks warnings when trying to build
# the package. Let's try and re-use googlesheets' approach:
# https://github.com/jennybc/googlesheets/issues/225
# https://github.com/jennybc/googlesheets/commit/a91403ecb8ab5d8059bf14a9f9878ab68a829f0a

## http://www.iana.org/assignments/http-status-codes/http-status-codes-1.csv
coarsen_code <- function(code)
  cut(code, c(0, 500, 600), right = FALSE, labels = FALSE)

VERB_n <- function(VERB, n = 5) {
  function(...) {
    for (i in seq_len(n)) {
      out <- VERB(...)
      status <- httr::status_code(out)
      switch(coarsen_code(status),
             break, ## < 500
             {
               ## >= 500
               backoff <-
                 stats::runif(n = 1,
                              min = 0,
                              max = 2 ^ i - 1)
               ## TO DO: honor a verbose argument or option
               mess <- paste("HTTP error %s on attempt %d ...\n",
                             "  backing off %0.2f seconds, retrying")
               mpf(mess, status, i, backoff)
               Sys.sleep(backoff)
             })
    }
    out
  }
}
mpf <- function(...)
  message(sprintf(...))
rGET <- VERB_n(httr::GET)
