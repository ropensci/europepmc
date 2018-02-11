# europepmc - R Interface to Europe PMC RESTful Web Service




[![Build Status](https://travis-ci.org/ropensci/europepmc.svg?branch=master)](https://travis-ci.org/ropensci/europepmc)
[![Build status](https://ci.appveyor.com/api/projects/status/f8xtpvhhr074lk44?svg=true)](https://ci.appveyor.com/project/sckott/europepmc)
[![codecov.io](https://codecov.io/github/ropensci/europepmc/coverage.svg?branch=master)](https://codecov.io/github/ropensci/europepmc?branch=master)
[![cran version](http://www.r-pkg.org/badges/version/europepmc)](https://cran.r-project.org/package=europepmc)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/europepmc)](https://github.com/metacran/cranlogs.app)
[![](https://badges.ropensci.org/29_status.svg)](https://github.com/ropensci/onboarding/issues/29)

europepmc facilitates access to the [Europe PMC RESTful Web
Service](http://europepmc.org/RestfulWebService).

[Europe PMC](http://europepmc.org/) covers life science literature and
gives access to open access full texts. Europe
PMC ingests all PubMed content and extends its index with other sources,
including Agricola, a bibliographic database of citations to the agricultural
literature, or Biological Patents.

For more infos on Europe PMC, see:

<https://europepmc.org/About>

Levchenko, M., Gou, Y., Graef, F., Hamelers, A., Huang, Z., Ide-Smith, M., … McEntyre, J. (2017). Europe PMC in 2017. Nucleic Acids Research, 46(D1), D1254–D1260. <https://doi.org/10.1093/nar/gkx1005>

## Implemented API methods

This client supports the following API methods:

|API-Method     |Description                                                                                  |R functions                                |
|:--------------|:--------------------------------------------------------------------------------------------|:------------------------------------------|
|search         |Search Europe PMC and get detailed metadata                                                  |`epmc_search()`, `epmc_details()`          |
|profile        |Obtain a summary of hit counts for several Europe PMC databases                              |`epmc_profile()`, `epmc_profile_hits()`                           |
|citations      |Load metadata representing citing articles for a given publication                           |`epmc_citations()`                         |
|references     |Retrieve the reference section of a pubication                                               |`epmc_refs()`                              |
|databaseLinks  |Get links to biological databases such as UniProt or ENA                                     |`epmc_db()`, `epmc_db_count()`             |
|labslinks      |Access links to Europe PMC provided by third parties                                         |`epmc_lablinks()`, `epmc_lablinks_count()` |
|textMinedTerms |Retrieve text-mined terms                                                                    |`epmc_tm()`, `epmc_tm_count()`             |
|fullTextXML    |Fetch full-texts deposited in PMC                                                            |`epmc_ftxt()`                              |
|bookXML        |retrieve book XML formatted full text for the Open Access subset of the Europe PMC bookshelf |`epmc_ftxt_book()`                         |

## Installation

From CRAN

```r
install.packages("europepmc")
```

The latest development version can be installed using
[devtools](https://github.com/hadley/devtools) package:


```r
require(devtools)
install_github("ropensci/europepmc")
```

Loading into R


```r
library(europepmc)
```

## Search Europe PMC

The search covers both metadata (e.g. abstracts or title) and full texts. To
build your query, please refer to the comprehensive guidance on how to search
Europe PMC: <http://europepmc.org/help>. Simply provide your query in the Europe
PMC search syntax to `epmc_search()`. 


```r
europepmc::epmc_search("Lagotto Romagnolo")
#> # A tibble: 42 x 27
#>    id     source pmid   doi   title    authorString     journalTitle issue
#>    <chr>  <chr>  <chr>  <chr> <chr>    <chr>            <chr>        <chr>
#>  1 28583… MED    28583… 10.1… Basal A… Syrjä P, Anwar … Vet Pathol   6    
#>  2 25945… MED    25945… 10.1… Behavio… Jokinen TS, Tii… J Vet Inter… 4    
#>  3 24354… MED    24354… 10.1… FDG-PET… Jokinen TS, Haa… Vet Radiol … 3    
#>  4 17552… MED    17552… 10.1… Benign … Jokinen TS, Met… J Vet Inter… 3    
#>  5 17490… MED    17490… 10.1… Cerebel… Jokinen TS, Rus… J Small Ani… 8    
#>  6 29056… MED    29056… 10.1… Relatio… Byosiere SE, Fe… Behav Proce… <NA> 
#>  7 27525… MED    27525… 10.1… Genetic… Donner J, Kauko… PLoS One     8    
#>  8 29166… MED    29166… 10.1… Frequen… Zierath S, Hugh… PLoS One     11   
#>  9 29237… MED    29237… 10.1… Molecul… Yu Y, Hasegawa … BMC Vet Res  1    
#> 10 25875… MED    25875… 10.1… A misse… Kyöstilä K, Syr… PLoS Genet   4    
#> # ... with 32 more rows, and 19 more variables: journalVolume <chr>,
#> #   pubYear <chr>, journalIssn <chr>, pageInfo <chr>, pubType <chr>,
#> #   isOpenAccess <chr>, inEPMC <chr>, inPMC <chr>, hasPDF <chr>,
#> #   hasBook <chr>, citedByCount <int>, hasReferences <chr>,
#> #   hasTextMinedTerms <chr>, hasDbCrossReferences <chr>,
#> #   hasLabsLinks <chr>, hasTMAccessionNumbers <chr>,
#> #   firstPublicationDate <chr>, pmcid <chr>, hasSuppl <chr>
```

By default, `epmc_search()` returns 100 records. To adjust the limit, simply use
the `limit` parameter.

See vignette [Introducing europepmc, an R interface to Europe PMC RESTful API](https://ropensci.github.io/europepmc/articles/introducing-europepmc.html) for a long-form documentation about how to search Europe PMC with this client.

## Creating proper review graphs with `epmc_hits_trend()`

There is also a nice function allowing you to easily create review graphs like described in Maëlle
Salmon's [blog post](http://www.masalmon.eu/2017/05/14/evergreenreviewgraph/):


```r
tt_oa <- europepmc::epmc_hits_trend("Malaria", period = 1995:2016, synonym = FALSE)
tt_oa
#> # A tibble: 22 x 3
#>     year all_hits query_hits
#>    <int>    <dbl>      <dbl>
#>  1  1995   448477       1485
#>  2  1996   458064       1560
#>  3  1997   455691       1853
#>  4  1998   473173       1749
#>  5  1999   492786       1935
#>  6  2000   531286       2127
#>  7  2001   544411       2203
#>  8  2002   560843       2352
#>  9  2003   587503       2554
#> 10  2004   627130       2748
#> # ... with 12 more rows
# we use ggplot2 for plotting the graph
library(ggplot2)
ggplot(tt_oa, aes(year, query_hits / all_hits)) + 
  geom_point() + 
  geom_line() +
  xlab("Year published") + 
  ylab("Proportion of articles on Malaria in Europe PMC")
```

![plot of chunk unnamed-chunk-4](inst/image/unnamed-chunk-4-1.png)

For more info, read the vignette about creating literature review graphs:

<https://ropensci.github.io/europepmc/articles/evergreenreviewgraphs.html>

## Re-use of europepmc

Chris Stubben (@cstubben) has created an Shiny App that allows you to search and
browse Europe PMC:

<https://cstubben.shinyapps.io/euPMC/>

## Other ways to access Europe PubMed Central

### Other APIs

- Data dumps: <https://europepmc.org/FtpSite>
- OAI service: <https://europepmc.org/OaiService>
- SOAP web service: <https://europepmc.org/SoapWebServices>
- Grants RESTful (Grist) API: <https://europepmc.org/GristAPI>

### Other R clients

- use rOpenSci's `oai` to get metadata and full text via Europe PMC's OAI interface: <https://github.com/ropensci/oai>
- use rOpenSci's `rentrez` to interact with [NCBI databases](http://www.ncbi.nlm.nih.gov/) such as [PubMed](http://www.ncbi.nlm.nih.gov/pubmed): <https://github.com/ropensci/rentrez>
- rOpenSci's `fulltext` package gives access to supplementary material of open access life-science publications in Europe PMC: <https://github.com/ropensci/fulltext>

## Meta

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

License: GPL-3

Please use the issue tracker for bug reporting and feature requests.

---

[![rofooter](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
