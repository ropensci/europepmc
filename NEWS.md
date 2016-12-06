# europepmc 0.1.1

Implement [RESTful API v4.5.3](https://europepmc.org/docs/Europe_PMC_RESTful_Release_Notes.pdf)

## Major changes

- `epmc_search()`: implement cursorMark to paginate through results
- `epmc_search()`: added sort parameter

## Minor changes

- `epmc_search()` returns tibble
- `epmc_search()` improve error handling when zero results were found
- `epmc_details()` added MeSH qualifer #8
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

