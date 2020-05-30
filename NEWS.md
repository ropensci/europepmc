# europepmc 0.4

- Support API version 6.3
- Europe PMC Annotations ID integration

New functionalities:

- `epmc_annotations_by_id()` get text-mined concepts and full-texts from Europe PMC indexed full-texts;  `epmc_tm()`and `epmc_tm_count()` deprecated, use `epmc_annotations_by_id()` instead
- `epmc_search_by_doi()` get PubMed metadata by DOI names

Minor changes:

- improved retry in case API call fails accidentially
- preprint records collection added
- retrieve full-text by PMID
- improved long-form documentation
- improved testing
- new official docs site
- use *tibble instead of deprecated *data_frame functions

# europepmc 0.3

- Implement API version 6.0

## Minor changes

- improved feedback when calling the API
- link to most current paper from the Europe PMC team

# europepmc 0.2

- Move to HTTPS
- new `epmc_hits_trends()` function to obtain data for review graphs (thanks @maelle)
- new vignette "Making proper trend graphs" and updated search documentation

## Minor changes

- fix sort param
- rename `jsonlite::rbind_pages()` function
- improve `europepmc::epmc_tm()` output

# europepmc 0.1.4

- fixed example in vignette which lead to warnings
- synonym search is operational again

# europepmc 0.1.3

## Minor changes

- [removed explicit API versioning, so that the client now always supports the most recent API version #13](https://github.com/ropensci/europepmc/issues/13)
- set user agent to "ropensci/europepmc"
- `epmc_db()`, `epmc_db_count()`: add PRIDE archive as external database

# europepmc 0.1.2

- cache HTTP 500 errors which sometimes occur and re-try up to five times. It is based on [googlesheet's approach](https://github.com/jennybc/googlesheets/commit/a91403ecb8ab5d8059bf14a9f9878ab68a829f0a)
- new function `epmc_profile()` to get an overview of hit counts for several databases or publication types
- update imported packages in DESCRIPTION

# europepmc 0.1.1

Implement [RESTful API v4.5.3](https://europepmc.org/docs/Europe_PMC_RESTful_Release_Notes.pdf)

## Major changes

- `epmc_search()`: implement cursorMark to paginate through results
- `epmc_search()`: added sort parameter
- `epmc_search()`: [support of `raw` output file #7](https://github.com/ropensci/europepmc/issues/7)

## Minor changes

- `epmc_search()` and other functions return non-nested data.frames as tibbles to better support the [tidyverse](http://tidyverse.org/)
- `epmc_search()` improve error handling when nothing was found
- `epmc_details()` [added MeSH qualifer #8]((https://github.com/ropensci/europepmc/issues/8)
- remove NBK` as data source for `epmc_details()`, use PMIDs (`MED`) instead
- fix warnings regarding vignettes and imported dependencies reported by CRAN

# europepmc 0.1

Initial submission to CRAN

## Major changes

Support of the following  Europe PMC RESTful API methods:

- search
- citations
- references
- databaseLinks
- labsLinks
- textMinedTerms
- fullTextXML
- bookXML

Changes made during the ropensci onboarding review by @toph-allen <https://github.com/ropensci/onboarding/issues/29>

Answering to @cstubben reports and suggestions:

- [search returns data.frame of lists #1](https://github.com/ropensci/europepmc/issues/1)
- [removed hit_count from epmc_search results #4](https://github.com/ropensci/europepmc/issues/4)
- [set default batch_size to 1000 and limit to 25? #5](https://github.com/ropensci/europepmc/issues/4)

