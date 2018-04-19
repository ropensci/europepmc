# utils

# base uri
base_uri <- function()
  "https://www.ebi.ac.uk"

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
  req <- rGET(urltools::url_decode(
    httr::modify_url(
    base_uri(), path = path, query = query
    )
  ), ua)#, httr::verbose())
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


# make paths according to limit and request methods
make_path <- function(hit_count = NULL,
                      limit = NULL,
                      format = "json",
                 ...) {
  limit <- as.integer(limit)
  limit <- ifelse(hit_count <= limit, hit_count, limit)
  if (limit > batch_size()) {
    tt <- chunks(limit)
    arg <- lapply(1:(tt$page_max - 1), function(x)
      list(page = x,
           pageSize = batch_size(),
           format = format,
           ...)
    )
    arg[[tt$page_max]] <- list(page = tt$page_max,
                              pageSize = tt$last_chunk,
                              format = format,
                              ...)
  } else {
    arg <- NULL
    arg[[1]] <- list(pageSize = limit, format = format, ...)
  }
    arg
}

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

#' Progress bar definition
#'
#' @param limit maximum number of hits to be returned
#'
#' @noRd
pb <- function(limit) {
  if(!is.integer(limit))
    stop("Limit is not integer")
  progress::progress_bar$new(total = limit / batch_size(),
                                 format = "(:spin) [:bar] :percent",
                                 clear = FALSE, width = 60)
}

# common methods for id based request -------------------------------------

#' Validate inputs for ID-based requests
#'
#' @noRd
val_input <- function(ext_id,
                      data_src,
                      limit,
                      verbose) {
  if (is.null(ext_id))
    stop("Please provide a publication id")
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
    stopifnot(is.numeric(limit), is.logical(verbose))
}
#' Make path for  ID-based requests
#'
#'@noRd
mk_path <- function(req_method, data_src, ext_id, ...) {
  if (!is.null(req_method))
    c(rest_path(), data_src, ext_id, req_method)
  else
    stop("No request method provided")
}
#' Get hit counts for ID-based requests
#'
#' @noRd
get_counts <- function(path, ...) {
  if (!is.null(path))
    doc <- rebi_GET(path = path,
                    query = list(format = "json", pageSize = batch_size(), ...))
  doc$hitCount
}
#' Provide feedback about how many records where found and
#' will be returned
#'
#' @noRd
msg <- function(hit_count, limit, verbose) {
  if (verbose == TRUE)
    message(paste0(
      hit_count,
      " records found. Returning ",
      ifelse(hit_count <= limit, hit_count, limit)
    ))
}
