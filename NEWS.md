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

