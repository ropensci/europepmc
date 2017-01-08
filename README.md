# europepmc - R Interface to Europe PMC RESTful Web Service




[![Build Status](https://travis-ci.org/ropensci/europepmc.svg?branch=master)](https://travis-ci.org/ropensci/europepmc)
[![Build status](https://ci.appveyor.com/api/projects/status/f8xtpvhhr074lk44?svg=true)](https://ci.appveyor.com/project/sckott/europepmc)
[![codecov.io](https://codecov.io/github/ropensci/europepmc/coverage.svg?branch=master)](https://codecov.io/github/ropensci/europepmc?branch=master)
[![cran version](http://www.r-pkg.org/badges/version/europepmc)](https://cran.r-project.org/package=europepmc)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/europepmc)](https://github.com/metacran/cranlogs.app)


europepmc facilitates access to the [Europe PMC RESTful Web
Service](http://europepmc.org/RestfulWebService).

[Europe PMC](http://europepmc.org/) covers life science literature and
gives access to open access full texts. Europe
PMC ingests all PubMed content and extends its index with other sources,
including Agricola, a bibliographic database of citations to the agricultural
literature, or Biological Patents.

For more infos on Europe PMC, see:

<https://europepmc.org/About>

Europe PMC: a full-text literature database for the life sciences and platform
for innovation. (2014). Nucleic Acids Research, 43(D1), D1042–D1048. doi:[10.1093/nar/gku1061](http://doi.org/10.1093/nar/gku1061)

## Implemented API methods

This client supports the following API methods:

|API-Method     |Description                                                                                  |R functions                                |
|:--------------|:--------------------------------------------------------------------------------------------|:------------------------------------------|
|search         |Search Europe PMC and get detailed metadata                                                  |`epmc_search()`, `epmc_details()`          |
|profile        |Obtain a summary of hit counts for several Europe PMC databases                              |`epmc_profile()`                           |
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

By default, `epmc_search` returns 100 records. To adjust the limit, simply use
the `limit` parameter.

### Examples

For instance, search for abstracts and full texts that mention 
[`Gabi-Kat`](https://www.gabi-kat.de/),  a Flanking Sequence Tag 
(FST)-based database for T-DNA insertion mutants:


```r
epmc_search(query = 'Gabi-Kat')
#> # A tibble: 100 × 27
#>          id source     pmid                                doi
#>       <chr>  <chr>    <chr>                              <chr>
#> 1  28013277    MED 28013277                 10.1093/pcp/pcw205
#> 2  22080561    MED 22080561                10.1093/nar/gkr1047
#> 3  17062622    MED 17062622                 10.1093/nar/gkl753
#> 4  14756321    MED 14756321 10.1023/b:plan.0000009297.37235.4a
#> 5  12874060    MED 12874060      10.1093/bioinformatics/btg170
#> 6  25324895    MED 25324895            10.1186/1746-4811-10-28
#> 7  26343971    MED 26343971         10.1016/j.molp.2015.08.011
#> 8  27117628    MED 27117628                  10.1038/srep24971
#> 9  26493293    MED 26493293                  10.1111/tpj.13062
#> 10 27018849    MED 27018849      10.1080/15592324.2016.1161876
#> # ... with 90 more rows, and 23 more variables: title <chr>,
#> #   authorString <chr>, journalTitle <chr>, pubYear <chr>,
#> #   journalIssn <chr>, pubType <chr>, isOpenAccess <chr>, inEPMC <chr>,
#> #   inPMC <chr>, hasPDF <chr>, hasBook <chr>, citedByCount <int>,
#> #   hasReferences <chr>, hasTextMinedTerms <chr>,
#> #   hasDbCrossReferences <chr>, hasLabsLinks <chr>, epmcAuthMan <chr>,
#> #   hasTMAccessionNumbers <chr>, pmcid <chr>, issue <chr>,
#> #   journalVolume <chr>, pageInfo <chr>, hasSuppl <chr>
```

Get PLOS Genetics (ISSN:1553-7404) articles that cross-reference EMBL:


```r
epmc_search(query = 'ISSN:1553-7404 HAS_EMBL:y')
#> # A tibble: 100 × 27
#>          id source     pmid      pmcid                          doi
#>       <chr>  <chr>    <chr>      <chr>                        <chr>
#> 1  27780204    MED 27780204 PMC5079590 10.1371/journal.pgen.1006397
#> 2  27764113    MED 27764113 PMC5072692 10.1371/journal.pgen.1006387
#> 3  27541862    MED 27541862 PMC4991801 10.1371/journal.pgen.1006270
#> 4  27327578    MED 27327578 PMC4915694 10.1371/journal.pgen.1006110
#> 5  27203426    MED 27203426 PMC4874600 10.1371/journal.pgen.1006063
#> 6  27149082    MED 27149082 PMC4858218 10.1371/journal.pgen.1006030
#> 7  27120580    MED 27120580 PMC4847869 10.1371/journal.pgen.1005987
#> 8  27082250    MED 27082250 PMC4833346 10.1371/journal.pgen.1005954
#> 9  26982327    MED 26982327 PMC4794157 10.1371/journal.pgen.1005920
#> 10 26637114    MED 26637114 PMC4670201 10.1371/journal.pgen.1005681
#> # ... with 90 more rows, and 22 more variables: title <chr>,
#> #   authorString <chr>, journalTitle <chr>, issue <chr>,
#> #   journalVolume <chr>, pubYear <chr>, journalIssn <chr>, pageInfo <chr>,
#> #   pubType <chr>, isOpenAccess <chr>, inEPMC <chr>, inPMC <chr>,
#> #   hasPDF <chr>, hasBook <chr>, hasSuppl <chr>, citedByCount <int>,
#> #   hasReferences <chr>, hasTextMinedTerms <chr>,
#> #   hasDbCrossReferences <chr>, hasLabsLinks <chr>, epmcAuthMan <chr>,
#> #   hasTMAccessionNumbers <chr>
```

Use [ORCID](http://orcid.org/) to search for personal publications:


```r
epmc_search(query = 'AUTHORID:"0000-0002-7635-3473"', limit = 1000)
#> # A tibble: 131 × 27
#>          id source     pmid      pmcid                          doi
#>       <chr>  <chr>    <chr>      <chr>                        <chr>
#> 1  27711162    MED 27711162 PMC5053417 10.1371/journal.pone.0164321
#> 2  27230558    MED 27230558 PMC4881148    10.1186/s12870-016-0805-5
#> 3  27214749    MED 27214749       <NA>            10.1111/nph.14008
#> 4  26980001    MED 26980001 PMC4791833    10.1186/s12864-016-2566-9
#> 5  27557761    MED 27557761       <NA>  10.1007/978-1-4939-6396-6_5
#> 6  26676716    MED 26676716       <NA>            10.1111/tpj.13103
#> 7  26343971    MED 26343971       <NA>   10.1016/j.molp.2015.08.011
#> 8  26328666    MED 26328666 PMC4556409    10.1186/s13059-015-0729-7
#> 9  27660776    MED 27660776 PMC5034127     10.1128/genomea.00975-16
#> 10 27540267    MED 27540267       <NA>                         <NA>
#> # ... with 121 more rows, and 22 more variables: title <chr>,
#> #   authorString <chr>, journalTitle <chr>, issue <chr>,
#> #   journalVolume <chr>, pubYear <chr>, journalIssn <chr>, pageInfo <chr>,
#> #   pubType <chr>, isOpenAccess <chr>, inEPMC <chr>, inPMC <chr>,
#> #   hasPDF <chr>, hasBook <chr>, hasSuppl <chr>, citedByCount <int>,
#> #   hasReferences <chr>, hasTextMinedTerms <chr>,
#> #   hasDbCrossReferences <chr>, hasLabsLinks <chr>, epmcAuthMan <chr>,
#> #   hasTMAccessionNumbers <chr>
```

### Include MeSH and UniProt synonyms

You may also want to include synonyms when searching Europe PMC. If
`synonym = TRUE` MeSH and UniProt synonyms are searched as well.


```r
# with snyonyms
epmc_search('aspirin', synonym = TRUE)
#> # A tibble: 100 × 27
#>          id source     pmid                          doi
#>       <chr>  <chr>    <chr>                        <chr>
#> 1  27888917    MED 27888917    10.1016/j.otc.2016.08.007
#> 2  28025961    MED 28025961             10.5414/cp202637
#> 3  28039526    MED 28039526    10.1007/s00246-016-1529-x
#> 4  28030443    MED 28030443 10.1097/eja.0000000000000581
#> 5  28039577    MED 28039577    10.1007/s12975-016-0516-0
#> 6  28056332    MED 28056332                         <NA>
#> 7  28033561    MED 28033561 10.1016/j.ejogrb.2016.12.023
#> 8  28004997    MED 28004997        10.6002/ect.2016.0139
#> 9  28052291    MED 28052291            10.1159/000452361
#> 10 27987244    MED 27987244            10.1111/wrr.12502
#> # ... with 90 more rows, and 23 more variables: title <chr>,
#> #   authorString <chr>, journalTitle <chr>, issue <chr>,
#> #   journalVolume <chr>, pubYear <chr>, journalIssn <chr>, pageInfo <chr>,
#> #   pubType <chr>, isOpenAccess <chr>, inEPMC <chr>, inPMC <chr>,
#> #   hasPDF <chr>, hasBook <chr>, citedByCount <int>, hasReferences <chr>,
#> #   hasTextMinedTerms <chr>, hasDbCrossReferences <chr>,
#> #   hasLabsLinks <chr>, epmcAuthMan <chr>, hasTMAccessionNumbers <chr>,
#> #   pmcid <chr>, hasSuppl <chr>

# without synonyms
epmc_search('aspirin', synonym = FALSE)
#> # A tibble: 100 × 27
#>          id source     pmid                           doi
#>       <chr>  <chr>    <chr>                         <chr>
#> 1  27888917    MED 27888917     10.1016/j.otc.2016.08.007
#> 2  28025961    MED 28025961              10.5414/cp202637
#> 3  28039526    MED 28039526     10.1007/s00246-016-1529-x
#> 4  27987244    MED 27987244             10.1111/wrr.12502
#> 5  27937054    MED 27937054 10.1080/14656566.2016.1269747
#> 6  28004997    MED 28004997         10.6002/ect.2016.0139
#> 7  28056332    MED 28056332                          <NA>
#> 8  28030443    MED 28030443  10.1097/eja.0000000000000581
#> 9  28039577    MED 28039577     10.1007/s12975-016-0516-0
#> 10 27902693    MED 27902693  10.1371/journal.pone.0166103
#> # ... with 90 more rows, and 23 more variables: title <chr>,
#> #   authorString <chr>, journalTitle <chr>, issue <chr>,
#> #   journalVolume <chr>, pubYear <chr>, journalIssn <chr>, pageInfo <chr>,
#> #   pubType <chr>, isOpenAccess <chr>, inEPMC <chr>, inPMC <chr>,
#> #   hasPDF <chr>, hasBook <chr>, citedByCount <int>, hasReferences <chr>,
#> #   hasTextMinedTerms <chr>, hasDbCrossReferences <chr>,
#> #   hasLabsLinks <chr>, epmcAuthMan <chr>, hasTMAccessionNumbers <chr>,
#> #   pmcid <chr>, hasSuppl <chr>
```

### Output types

`epmc_search()` supports the following output types :

#### Parsed key metadata (default)

Key metadata parsed as non-nested tibble:


```r
epmc_search('Gabi-Kat', output = 'parsed')
#> # A tibble: 100 × 27
#>          id source     pmid                                doi
#>       <chr>  <chr>    <chr>                              <chr>
#> 1  28013277    MED 28013277                 10.1093/pcp/pcw205
#> 2  22080561    MED 22080561                10.1093/nar/gkr1047
#> 3  17062622    MED 17062622                 10.1093/nar/gkl753
#> 4  14756321    MED 14756321 10.1023/b:plan.0000009297.37235.4a
#> 5  12874060    MED 12874060      10.1093/bioinformatics/btg170
#> 6  25324895    MED 25324895            10.1186/1746-4811-10-28
#> 7  26343971    MED 26343971         10.1016/j.molp.2015.08.011
#> 8  27117628    MED 27117628                  10.1038/srep24971
#> 9  26493293    MED 26493293                  10.1111/tpj.13062
#> 10 27018849    MED 27018849      10.1080/15592324.2016.1161876
#> # ... with 90 more rows, and 23 more variables: title <chr>,
#> #   authorString <chr>, journalTitle <chr>, pubYear <chr>,
#> #   journalIssn <chr>, pubType <chr>, isOpenAccess <chr>, inEPMC <chr>,
#> #   inPMC <chr>, hasPDF <chr>, hasBook <chr>, citedByCount <int>,
#> #   hasReferences <chr>, hasTextMinedTerms <chr>,
#> #   hasDbCrossReferences <chr>, hasLabsLinks <chr>, epmcAuthMan <chr>,
#> #   hasTMAccessionNumbers <chr>, pmcid <chr>, issue <chr>,
#> #   journalVolume <chr>, pageInfo <chr>, hasSuppl <chr>
```

In addition to fetch bibliographic metadata, the parsed output also helps you
to get a general overview about additional information types that are offered by 
Europe PMC and which can be retrieved through other `europepmc`-functions. 
Columns inform whether open access full texts (`isOpenAccess`), cross-links to
other EBI databases (`hasDbCrossReferences`), text-mined terms (`hasTextMinedTerms`)
or references (`hasReferences`) are available.

#### IDs

List of literature database identifier including PMID:


```r
epmc_search('Gabi-Kat', output = 'id_list')
#> # A tibble: 100 × 4
#>          id source     pmid      pmcid
#>       <chr>  <chr>    <chr>      <chr>
#> 1  28013277    MED 28013277       <NA>
#> 2  22080561    MED 22080561 PMC3245140
#> 3  17062622    MED 17062622 PMC1781121
#> 4  14756321    MED 14756321       <NA>
#> 5  12874060    MED 12874060       <NA>
#> 6  25324895    MED 25324895 PMC4169229
#> 7  26343971    MED 26343971       <NA>
#> 8  27117628    MED 27117628 PMC4846993
#> 9  26493293    MED 26493293 PMC4737287
#> 10 27018849    MED 27018849 PMC4883958
#> # ... with 90 more rows
```

#### Record details

Full metadata as list. Please be aware that these lists can become very large, and fetching these data from Europe PMC therefore takes some time.


```r
my_list <- epmc_search('Gabi-Kat', output = 'raw', limit = 10)
# display the structure for one list element
str(my_list[[10]])
#> List of 40
#>  $ id                   : chr "27018849"
#>  $ source               : chr "MED"
#>  $ pmid                 : chr "27018849"
#>  $ pmcid                : chr "PMC4883958"
#>  $ doi                  : chr "10.1080/15592324.2016.1161876"
#>  $ title                : chr "Interaction between vitamin B6 metabolism, nitrogen metabolism and autoimmunity."
#>  $ authorString         : chr "Colinas M, Fitzpatrick TB."
#>  $ authorList           :List of 1
#>   ..$ author:List of 2
#>   .. ..$ :List of 6
#>   .. .. ..$ fullName   : chr "Colinas M"
#>   .. .. ..$ firstName  : chr "Maite"
#>   .. .. ..$ lastName   : chr "Colinas"
#>   .. .. ..$ initials   : chr "M"
#>   .. .. ..$ authorId   :List of 2
#>   .. .. .. ..$ type : chr "ORCID"
#>   .. .. .. ..$ value: chr "0000-0001-7053-2983"
#>   .. .. ..$ affiliation: chr "a Department of Botany and Plant Biology , University of Geneva , Geneva , Switzerland."
#>   .. ..$ :List of 5
#>   .. .. ..$ fullName   : chr "Fitzpatrick TB"
#>   .. .. ..$ firstName  : chr "Teresa B"
#>   .. .. ..$ lastName   : chr "Fitzpatrick"
#>   .. .. ..$ initials   : chr "TB"
#>   .. .. ..$ affiliation: chr "a Department of Botany and Plant Biology , University of Geneva , Geneva , Switzerland."
#>  $ authorIdList         :List of 1
#>   ..$ authorId:List of 1
#>   .. ..$ :List of 2
#>   .. .. ..$ type : chr "ORCID"
#>   .. .. ..$ value: chr "0000-0001-7053-2983"
#>  $ journalInfo          :List of 8
#>   ..$ issue               : chr "4"
#>   ..$ volume              : chr "11"
#>   ..$ journalIssueId      : int 2439536
#>   ..$ dateOfPublication   : chr "2016 "
#>   ..$ monthOfPublication  : int 0
#>   ..$ yearOfPublication   : int 2016
#>   ..$ printPublicationDate: chr "2016-01-01"
#>   ..$ journal             :List of 6
#>   .. ..$ title              : chr "Plant signaling & behavior"
#>   .. ..$ medlineAbbreviation: chr "Plant Signal Behav"
#>   .. ..$ isoabbreviation    : chr "Plant Signal Behav"
#>   .. ..$ issn               : chr "1559-2316"
#>   .. ..$ nlmid              : chr "101291431"
#>   .. ..$ essn               : chr "1559-2324"
#>  $ pubYear              : chr "2016"
#>  $ pageInfo             : chr "e1161876"
#>  $ abstractText         : chr "The essential micronutrient vitamin B6 is best known in its enzymatic cofactor form, pyridoxal 5'-phosphate (PLP). However, vit"| __truncated__
#>  $ affiliation          : chr "a Department of Botany and Plant Biology , University of Geneva , Geneva , Switzerland."
#>  $ language             : chr "eng"
#>  $ pubModel             : chr "Print"
#>  $ pubTypeList          :List of 1
#>   ..$ pubType: chr [1:2] "Journal Article" "Research Support, Non-U.S. Gov't"
#>  $ meshHeadingList      :List of 1
#>   ..$ meshHeading:List of 9
#>   .. ..$ :List of 3
#>   .. .. ..$ majorTopic_YN    : chr "N"
#>   .. .. ..$ descriptorName   : chr "Arabidopsis"
#>   .. .. ..$ meshQualifierList:List of 1
#>   .. .. .. ..$ meshQualifier:List of 2
#>   .. .. .. .. ..$ :List of 3
#>   .. .. .. .. .. ..$ abbreviation : chr "GE"
#>   .. .. .. .. .. ..$ qualifierName: chr "genetics"
#>   .. .. .. .. .. ..$ majorTopic_YN: chr "N"
#>   .. .. .. .. ..$ :List of 3
#>   .. .. .. .. .. ..$ abbreviation : chr "IM"
#>   .. .. .. .. .. ..$ qualifierName: chr "immunology"
#>   .. .. .. .. .. ..$ majorTopic_YN: chr "N"
#>   .. ..$ :List of 3
#>   .. .. ..$ majorTopic_YN    : chr "N"
#>   .. .. ..$ descriptorName   : chr "Nitrogen"
#>   .. .. ..$ meshQualifierList:List of 1
#>   .. .. .. ..$ meshQualifier:List of 1
#>   .. .. .. .. ..$ :List of 3
#>   .. .. .. .. .. ..$ abbreviation : chr "ME"
#>   .. .. .. .. .. ..$ qualifierName: chr "metabolism"
#>   .. .. .. .. .. ..$ majorTopic_YN: chr "Y"
#>   .. ..$ :List of 3
#>   .. .. ..$ majorTopic_YN    : chr "N"
#>   .. .. ..$ descriptorName   : chr "Vitamin B 6"
#>   .. .. ..$ meshQualifierList:List of 1
#>   .. .. .. ..$ meshQualifier:List of 1
#>   .. .. .. .. ..$ :List of 3
#>   .. .. .. .. .. ..$ abbreviation : chr "ME"
#>   .. .. .. .. .. ..$ qualifierName: chr "metabolism"
#>   .. .. .. .. .. ..$ majorTopic_YN: chr "Y"
#>   .. ..$ :List of 3
#>   .. .. ..$ majorTopic_YN    : chr "N"
#>   .. .. ..$ descriptorName   : chr "Arabidopsis Proteins"
#>   .. .. ..$ meshQualifierList:List of 1
#>   .. .. .. ..$ meshQualifier:List of 1
#>   .. .. .. .. ..$ :List of 3
#>   .. .. .. .. .. ..$ abbreviation : chr "ME"
#>   .. .. .. .. .. ..$ qualifierName: chr "metabolism"
#>   .. .. .. .. .. ..$ majorTopic_YN: chr "N"
#>   .. ..$ :List of 2
#>   .. .. ..$ majorTopic_YN : chr "N"
#>   .. .. ..$ descriptorName: chr "Temperature"
#>   .. ..$ :List of 2
#>   .. .. ..$ majorTopic_YN : chr "Y"
#>   .. .. ..$ descriptorName: chr "Autoimmunity"
#>   .. ..$ :List of 2
#>   .. .. ..$ majorTopic_YN : chr "N"
#>   .. .. ..$ descriptorName: chr "Gene Expression Regulation, Plant"
#>   .. ..$ :List of 2
#>   .. .. ..$ majorTopic_YN : chr "N"
#>   .. .. ..$ descriptorName: chr "Reproduction"
#>   .. ..$ :List of 2
#>   .. .. ..$ majorTopic_YN : chr "N"
#>   .. .. ..$ descriptorName: chr "Phenotype"
#>  $ keywordList          :List of 1
#>   ..$ keyword: chr [1:8] "Arabidopsis thaliana" "Autoimmunity" "plant defense" "Vitamin B6" ...
#>  $ chemicalList         :List of 1
#>   ..$ chemical:List of 3
#>   .. ..$ :List of 2
#>   .. .. ..$ name          : chr "Arabidopsis Proteins"
#>   .. .. ..$ registryNumber: chr "0"
#>   .. ..$ :List of 2
#>   .. .. ..$ name          : chr "Vitamin B 6"
#>   .. .. ..$ registryNumber: chr "8059-24-3"
#>   .. ..$ :List of 2
#>   .. .. ..$ name          : chr "Nitrogen"
#>   .. .. ..$ registryNumber: chr "N762921K75"
#>  $ subsetList           :List of 1
#>   ..$ subset:List of 1
#>   .. ..$ :List of 2
#>   .. .. ..$ code: chr "IM"
#>   .. .. ..$ name: chr "Index Medicus"
#>  $ fullTextUrlList      :List of 1
#>   ..$ fullTextUrl:List of 3
#>   .. ..$ :List of 5
#>   .. .. ..$ availability    : chr "Free"
#>   .. .. ..$ availabilityCode: chr "F"
#>   .. .. ..$ documentStyle   : chr "pdf"
#>   .. .. ..$ site            : chr "Europe_PMC"
#>   .. .. ..$ url             : chr "http://europepmc.org/articles/PMC4883958?pdf=render"
#>   .. ..$ :List of 5
#>   .. .. ..$ availability    : chr "Free"
#>   .. .. ..$ availabilityCode: chr "F"
#>   .. .. ..$ documentStyle   : chr "html"
#>   .. .. ..$ site            : chr "Europe_PMC"
#>   .. .. ..$ url             : chr "http://europepmc.org/articles/PMC4883958"
#>   .. ..$ :List of 5
#>   .. .. ..$ availability    : chr "Subscription required"
#>   .. .. ..$ availabilityCode: chr "S"
#>   .. .. ..$ documentStyle   : chr "doi"
#>   .. .. ..$ site            : chr "DOI"
#>   .. .. ..$ url             : chr "http://dx.doi.org/10.1080/15592324.2016.1161876"
#>  $ isOpenAccess         : chr "N"
#>  $ inEPMC               : chr "Y"
#>  $ inPMC                : chr "N"
#>  $ hasPDF               : chr "Y"
#>  $ hasBook              : chr "N"
#>  $ hasSuppl             : chr "N"
#>  $ citedByCount         : int 0
#>  $ hasReferences        : chr "Y"
#>  $ hasTextMinedTerms    : chr "Y"
#>  $ hasDbCrossReferences : chr "N"
#>  $ hasLabsLinks         : chr "N"
#>  $ epmcAuthMan          : chr "N"
#>  $ hasTMAccessionNumbers: chr "N"
#>  $ dateOfCompletion     : chr "2016-12-30"
#>  $ dateOfCreation       : chr "2016-05-11"
#>  $ dateOfRevision       : chr "2016-12-31"
#>  $ firstPublicationDate : chr "2016-03-28"
#>  $ embargoDate          : chr "2016-09-28"
```

### Get results number

Count hits before with `epmc_hits` to define limit. For example, get list of ids
that represent articles referencing DataCite DOIs:


```r
query <- "ACCESSION_TYPE:doi"
epmc_hits(query)
#> [1] 6933
# set limit to 10 records
my_data <- epmc_search(query = query, limit = 10)
head(my_data)
#> # A tibble: 6 × 27
#>         id source     pmid      pmcid
#>      <chr>  <chr>    <chr>      <chr>
#> 1 27957387    MED 27957387 PMC5147021
#> 2 27927179    MED 27927179 PMC5142327
#> 3 27927161    MED 27927161 PMC5142403
#> 4 27924834    MED 27924834 PMC5141443
#> 5 27923923    MED 27923923 PMC5142621
#> 6 27922629    MED 27922629 PMC5139674
#> # ... with 23 more variables: title <chr>, authorString <chr>,
#> #   journalTitle <chr>, journalVolume <chr>, pubYear <chr>,
#> #   journalIssn <chr>, pageInfo <chr>, pubType <chr>, isOpenAccess <chr>,
#> #   inEPMC <chr>, inPMC <chr>, hasPDF <chr>, hasBook <chr>,
#> #   hasSuppl <chr>, citedByCount <int>, hasReferences <chr>,
#> #   hasTextMinedTerms <chr>, hasDbCrossReferences <chr>,
#> #   hasLabsLinks <chr>, epmcAuthMan <chr>, hasTMAccessionNumbers <chr>,
#> #   issue <chr>, doi <chr>
attr(my_data, "hit_count")
#> [1] 6933
```

You may also use `epmc_profile` to retrieve a summary of hit counts.


```r
epmc_profile(query = 'malaria')
#> $source
#> # A tibble: 9 × 2
#>    name  count
#> * <chr>  <int>
#> 1   AGR    121
#> 2   CBA    118
#> 3   CTX      8
#> 4   ETH    239
#> 5   HIR      4
#> 6   MED 127023
#> 7   PAT   2295
#> 8   CIT      0
#> 9   PMC  10728
#> 
#> $pubType
#> # A tibble: 5 × 2
#>                  name  count
#> *               <chr>  <int>
#> 1                 ALL 140536
#> 2           FULL TEXT  79247
#> 3         OPEN ACCESS  33853
#> 4              REVIEW  16562
#> 5 BOOKS AND DOCUMENTS     94
#> 
#> $subset
#> # A tibble: 1 × 2
#>    name count
#> * <chr> <int>
#> 1    BL     3
```

## Get article details

In addition to key metadata, `epmc_details` also returns full metadata
providing more comprehensive information on the article-level. By default,
PubMed / Medline index is searched.



```r
epmc_details(ext_id = '24270414')
#> $basic
#> # A tibble: 1 × 30
#>         id source     pmid      pmcid              doi
#> *    <chr>  <chr>    <chr>      <chr>            <chr>
#> 1 24270414    MED 24270414 PMC3859427 10.1172/jci73168
#> # ... with 25 more variables: title <chr>, authorString <chr>,
#> #   pubYear <chr>, pageInfo <chr>, abstractText <chr>, language <chr>,
#> #   pubModel <chr>, isOpenAccess <chr>, inEPMC <chr>, inPMC <chr>,
#> #   hasPDF <chr>, hasBook <chr>, hasSuppl <chr>, citedByCount <int>,
#> #   hasReferences <chr>, hasTextMinedTerms <chr>,
#> #   hasDbCrossReferences <chr>, hasLabsLinks <chr>, epmcAuthMan <chr>,
#> #   hasTMAccessionNumbers <chr>, dateOfCompletion <chr>,
#> #   dateOfCreation <chr>, dateOfRevision <chr>,
#> #   electronicPublicationDate <chr>, firstPublicationDate <chr>
#> 
#> $author_details
#> # A tibble: 2 × 4
#>           fullName firstName       lastName initials
#> *            <chr>     <chr>          <chr>    <chr>
#> 1 Malaga-Dieguez L     Laura Malaga-Dieguez        L
#> 2        Susztak K   Katalin        Susztak        K
#> 
#> $journal_info
#> # A tibble: 1 × 13
#>   issue volume journalIssueId dateOfPublication monthOfPublication
#> * <chr>  <chr>          <int>             <chr>              <int>
#> 1    12    123        2099360          2013 Dec                 12
#> # ... with 8 more variables: yearOfPublication <int>,
#> #   printPublicationDate <chr>, journal.title <chr>,
#> #   journal.medlineAbbreviation <chr>, journal.isoabbreviation <chr>,
#> #   journal.issn <chr>, journal.nlmid <chr>, journal.essn <chr>
#> 
#> $ftx
#> # A tibble: 5 × 5
#>            availability availabilityCode documentStyle          site
#> *                 <chr>            <chr>         <chr>         <chr>
#> 1                  Free                F           pdf    Europe_PMC
#> 2                  Free                F          html    Europe_PMC
#> 3                  Free                F           pdf PubMedCentral
#> 4                  Free                F          html PubMedCentral
#> 5 Subscription required                S           doi           DOI
#> # ... with 1 more variables: url <chr>
#> 
#> $chemical
#> # A tibble: 4 × 2
#>                                     name registryNumber
#> *                                  <chr>          <chr>
#> 1                             Ubiquinone      1339-63-5
#> 2                        Protein Kinases       EC 2.7.-
#> 3 aarF domain containing kinase 4, human       EC 2.7.-
#> 4                           coenzyme Q10     EJ27X76M46
#> 
#> $mesh_topic
#> # A tibble: 5 × 2
#>   majorTopic_YN     descriptorName
#> *         <chr>              <chr>
#> 1             N            Animals
#> 2             N             Humans
#> 3             N Nephrotic Syndrome
#> 4             N         Ubiquinone
#> 5             N    Protein Kinases
#> 
#> $mesh_qualifiers
#> # A tibble: 4 × 4
#>       descriptorName abbreviation         qualifierName majorTopic_YN
#>                <chr>        <chr>                 <chr>         <chr>
#> 1 Nephrotic Syndrome           GE              genetics             Y
#> 2         Ubiquinone           AA analogs & derivatives             Y
#> 3         Ubiquinone           BI          biosynthesis             N
#> 4    Protein Kinases           PH            physiology             Y
#> 
#> $comments
#> # A tibble: 1 × 5
#>         id source                               reference       type
#> *    <chr>  <chr>                                   <chr>      <chr>
#> 1 24270420    MED J Clin Invest. 2013 Dec;123(12):5179-89 Comment on
#> # ... with 1 more variables: orderIn <int>
#> 
#> $grants
#> # A tibble: 2 × 4
#>        grantId        agency acronym orderIn
#> *        <chr>         <chr>   <chr>   <int>
#> 1  R01DK076077 NIDDK NIH HHS      DK       0
#> 2 R01 DK076077 NIDDK NIH HHS      DK       0
```

Show author details including ORCID:


```r
epmc_details(ext_id = '14756321')$author_details
#> # A tibble: 6 × 6
#>      fullName firstName  lastName initials authorId.type
#> *       <chr>     <chr>     <chr>    <chr>         <chr>
#> 1    Rosso MG   Mario G     Rosso       MG          <NA>
#> 2        Li Y      Yong        Li        Y          <NA>
#> 3  Strizhov N   Nicolai  Strizhov        N          <NA>
#> 4     Reiss B     Bernd     Reiss        B         ORCID
#> 5    Dekker K      Koen    Dekker        K          <NA>
#> 6 Weisshaar B     Bernd Weisshaar        B         ORCID
#> # ... with 1 more variables: authorId.value <chr>
```

## Get citation counts and citing publications

Citing publications from the Europe PMC index can be retrieved like this:


```r
my_cites <- epmc_citations('9338777')
my_cites
#> # A tibble: 100 × 12
#>          id source
#>       <chr>  <chr>
#> 1  10221475    MED
#> 2  10342317    MED
#> 3   9643812    MED
#> 4  10440384    MED
#> 5   9696842    MED
#> 6   9703304    MED
#> 7   9728974    MED
#> 8   9728985    MED
#> 9   9728986    MED
#> 10  9728987    MED
#> # ... with 90 more rows, and 10 more variables: citationType <chr>,
#> #   title <chr>, authorString <chr>, journalAbbreviation <chr>,
#> #   pubYear <int>, volume <chr>, issue <chr>, pageInfo <chr>,
#> #   citedByCount <int>, text <chr>
# hits:
attr(my_cites, 'hit_count')
#> [1] 197
```

Please note, that citation counts are often smaller than those held by toll-
access services such as Web of Science or Scopus because the number of
reference sections indexed for Europe PMC considerably differs due to the
lack of full text accessibility.

## Get reference section

Europe PMC indexes more than 5 million reference sections.


```r
epmc_refs('PMC3166943', data_src = 'pmc')
#> # A tibble: 18 × 16
#>          id source    citationType
#>       <chr>  <chr>           <chr>
#> 1  10802651    MED JOURNAL ARTICLE
#> 2      <NA>   <NA>            <NA>
#> 3  18077472    MED JOURNAL ARTICLE
#> 4  15642104    MED JOURNAL ARTICLE
#> 5  18460184    MED JOURNAL ARTICLE
#> 6  17989687    MED JOURNAL ARTICLE
#> 7  20848809    MED JOURNAL ARTICLE
#> 8  20139945    MED JOURNAL ARTICLE
#> 9      <NA>   <NA>            <NA>
#> 10 17267433    MED JOURNAL ARTICLE
#> 11 15199967    MED JOURNAL ARTICLE
#> 12 14681407    MED JOURNAL ARTICLE
#> 13 16756499    MED JOURNAL ARTICLE
#> 14 16959967    MED JOURNAL ARTICLE
#> 15 16518471    MED JOURNAL ARTICLE
#> 16 11901169    MED JOURNAL ARTICLE
#> 17 15892874    MED JOURNAL ARTICLE
#> 18     <NA>   <NA>            <NA>
#> # ... with 13 more variables: title <chr>, authorString <chr>,
#> #   journalAbbreviation <chr>, issue <chr>, pubYear <int>, volume <chr>,
#> #   pageInfo <chr>, citedOrder <int>, match <chr>, essn <chr>, issn <chr>,
#> #   publicationTitle <chr>, externalLink <chr>
```

Tip: add `has_reflist:y` to your search string in `epmc_search` to make sure
you only get publications whose reference sections are accessible through
Europe PMC.

## Retrieve links to other EBI databases

Cross-links to EBI databases are either manually curated (ENA, InterPro, PDB,
IntAct, ChEMBL, ChEBI and ArrayExpress) or automatically gathered through
text-mining (European Nucleotide Archive, UniProt, PDB, OMIM, RefSNP, RefSeq,
Pfam, InterPro, Ensembl, ArrayExpress and data DOIs).

Before retrieving the links, please check availability and sources first:


```r
epmc_db_count('12368864')
#> # A tibble: 3 × 2
#>     dbName count
#> *    <chr> <int>
#> 1     EMBL    10
#> 2 INTERPRO     1
#> 3  UNIPROT  5588
```

Add `has_xrefs:y` or to your search string in `epmc_search` to make sure
you only get publications with cross-references to EBI databases.

Select database and get links:


```r
epmc_db('12368864', db = 'embl')
#> # A tibble: 10 × 4
#>       info1                                                       info2
#>       <chr>                                                       <chr>
#> 1  AE014187 Plasmodium falciparum 3D7 chromosome 14, complete sequence.
#> 2  AE014186 Plasmodium falciparum 3D7 chromosome 11, complete sequence.
#> 3  LN999943  Plasmodium falciparum 3D7 chromosome 2, complete sequence.
#> 4  AE001362  Plasmodium falciparum 3D7 chromosome 2, complete sequence.
#> 5  LN999947 Plasmodium falciparum 3D7 chromosome 12, complete sequence.
#> 6  AE014185 Plasmodium falciparum 3D7 chromosome 10, complete sequence.
#> 7  LN999944 Plasmodium falciparum 3D7 chromosome 10, complete sequence.
#> 8  LN999945 Plasmodium falciparum 3D7 chromosome 11, complete sequence.
#> 9  LN999946 Plasmodium falciparum 3D7 chromosome 14, complete sequence.
#> 10 AE014188 Plasmodium falciparum 3D7 chromosome 12, complete sequence.
#> # ... with 2 more variables: info3 <chr>, info4 <chr>
```

## Get text-mined terms

Text-mined terms that can be accessed via Europe PMC are mapped against
controlled vocabularies like [Gene Ontology](http://www.geneontology.org/).

Before retrieving these terms, please check availability and vocabularies
first:


```r
epmc_tm_count('25249410')
#> # A tibble: 7 × 2
#>           name count
#> *        <chr> <int>
#> 1    accession     1
#> 2     chemical    25
#> 3      disease     1
#> 4          efo    28
#> 5 gene_protein    51
#> 6      go_term    17
#> 7     organism    27
```

Select vocabulary to retrieve the terms:


```r
epmc_tm('25249410', semantic_type = 'GO_TERM')
#>                             term count              altName dbName    dbId
#> 1                     chromosome    25          chromosomes     GO 0005694
#> 2                   biosynthesis    16 formation, synthesis     GO 0009058
#> 3                        binding     9                          GO 0005488
#> 4                          cells     5                 cell     GO 0005623
#> 5                         growth     4               Growth     GO 0040007
#> 6         flavonoid biosynthesis     3                          GO 0009813
#> 7                gene expression     2                          GO 0010467
#> 8           secondary metabolism     2                          GO 0019748
#> 9                     metabolism     2                          GO 0008152
#> 10             defense responses     1                          GO 0006952
#> 11            cell cycle control     1                          GO 1901987
#> 12 regulation of gene expression     1                          GO 0010468
#> 13    glucosinolate biosynthesis     1                          GO 0019761
#> 14              cell development     1                          GO 0048468
#> 15                    root hairs     1                          GO 0035618
#> 16      anthocyanin biosynthesis     1                          GO 0009718
#> 17             enzyme activities     1                          GO 0003824
```

## Links to external sources

With the External Link services, Europe PMC allows third parties to publish
links from Europe PMC to other webpages. Current External Link providers,
whose id can be found through Europe PMC's Advanced Search interface, include
Wikipedia, Dryad Digital Repository or the institutional repo of Bielefeld
University. For more information, see <http://europepmc.org/labslink>.

Check availability and number of links:


```r
epmc_lablinks_count('PMC3986813', data_src = 'pmc')
#> # A tibble: 5 × 2
#>       providerName linksCount
#> *            <chr>      <int>
#> 1 EBI Train Online          1
#> 2        Wikipedia          1
#> 3       BioStudies          1
#> 4          Publons          1
#> 5        Altmetric          1
```

Get links to PANGEA (`lab_id = "1342"`)


```r
epmc_lablinks('24023770', lab_id = '1342')
#> # A tibble: 13 × 6
#>                                                                          title
#>                                                                          <chr>
#> 1  Related to: Schewe, I (2010). Biochemical investigation of multicorer sedim
#> 2  Related to: Schewe, I (2010). Biochemical investigation of multicorer sedim
#> 3  Related to: Schewe, I (2010). Biochemical investigation of multicorer sedim
#> 4  Related to: Schewe, I (2010). Biochemical investigation of multicorer sedim
#> 5  Related to: Schewe, I (2010). Biochemical investigation of multicorer sedim
#> 6  Related to: Schewe, I (2010). Biochemical investigation of multicorer sedim
#> 7  Related to: Schewe, I (2010). Biochemical investigation of multicorer sedim
#> 8  Related to: Schewe, I (2010). Biochemical investigation of multicorer sedim
#> 9  Related to: Schewe, I (2010). Biochemical investigation of multicorer sedim
#> 10 Related to: Schewe, I (2010). Biochemical investigation of multicorer sedim
#> 11 Related to: Schewe, I (2010). Biochemical investigation of multicorer sedim
#> 12 Related to: Schewe, I (2010). Biochemical investigation of multicorer sedim
#> 13 Related to: Schewe, I (2010). Biochemical investigation of multicorer sedim
#> # ... with 5 more variables: url <chr>, imgUrl <lgl>, lab_id <int>,
#> #   lab_name <fctr>, lab_description <fctr>
```

## Full text access

Full texts are in XML format and are only provided for the Open Access subset
of Europe PMC. They can be retrieved by the PMCID.


```r
epmc_ftxt('PMC3257301')
#> {xml_document}
#> <article article-type="research-article" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML">
#> [1] <front>\n  <journal-meta>\n    <journal-id journal-id-type="nlm-ta"> ...
#> [2] <body>\n  <sec id="s1">\n    <title>Introduction</title>\n    <p>Atm ...
#> [3] <back>\n  <ack>\n    <p>We would like to thank Dr. C. Gourlay and Dr ...
```

Books, fetched through the PMID or the 'NBK' book number, can also be loaded
as XML into R for further text-mining activities using `epmc_ftxt_book()`.


Please check full-text availability before calling this method either with `epmc_search()` or `epmc_details()`.

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
