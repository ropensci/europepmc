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

Europe PMC: a full-text literature database for the life sciences and platform
for innovation. (2014). Nucleic Acids Research, 43(D1), D1042–D1048. doi:[10.1093/nar/gku1061](http://doi.org/10.1093/nar/gku1061)

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
#> 7  27507985    MED 27507985            10.3389/fpls.2016.01115
#> 8  27117628    MED 27117628                  10.1038/srep24971
#> 9  26343971    MED 26343971         10.1016/j.molp.2015.08.011
#> 10 28167950    MED 28167950            10.3389/fpls.2017.00007
#> # ... with 90 more rows, and 23 more variables: title <chr>,
#> #   authorString <chr>, journalTitle <chr>, issue <chr>,
#> #   journalVolume <chr>, pubYear <chr>, journalIssn <chr>, pageInfo <chr>,
#> #   pubType <chr>, isOpenAccess <chr>, inEPMC <chr>, inPMC <chr>,
#> #   hasPDF <chr>, hasBook <chr>, citedByCount <int>, hasReferences <chr>,
#> #   hasTextMinedTerms <chr>, hasDbCrossReferences <chr>,
#> #   hasLabsLinks <chr>, hasTMAccessionNumbers <chr>,
#> #   firstPublicationDate <chr>, pmcid <chr>, hasSuppl <chr>
```

Get PLOS Genetics (ISSN:1553-7404) articles that cross-reference EMBL:


```r
epmc_search(query = 'ISSN:1553-7404 HAS_EMBL:y')
#> # A tibble: 100 × 27
#>          id source     pmid      pmcid                          doi
#>       <chr>  <chr>    <chr>      <chr>                        <chr>
#> 1  28222092    MED 28222092 PMC5340410 10.1371/journal.pgen.1006596
#> 2  27780204    MED 27780204 PMC5079590 10.1371/journal.pgen.1006397
#> 3  27764113    MED 27764113 PMC5072692 10.1371/journal.pgen.1006387
#> 4  27541862    MED 27541862 PMC4991801 10.1371/journal.pgen.1006270
#> 5  27385107    MED 27385107 PMC4934787 10.1371/journal.pgen.1006155
#> 6  27327578    MED 27327578 PMC4915694 10.1371/journal.pgen.1006110
#> 7  27203426    MED 27203426 PMC4874600 10.1371/journal.pgen.1006063
#> 8  27149082    MED 27149082 PMC4858218 10.1371/journal.pgen.1006030
#> 9  27120580    MED 27120580 PMC4847869 10.1371/journal.pgen.1005987
#> 10 27082250    MED 27082250 PMC4833346 10.1371/journal.pgen.1005954
#> # ... with 90 more rows, and 22 more variables: title <chr>,
#> #   authorString <chr>, journalTitle <chr>, issue <chr>,
#> #   journalVolume <chr>, pubYear <chr>, journalIssn <chr>, pageInfo <chr>,
#> #   pubType <chr>, isOpenAccess <chr>, inEPMC <chr>, inPMC <chr>,
#> #   hasPDF <chr>, hasBook <chr>, hasSuppl <chr>, citedByCount <int>,
#> #   hasReferences <chr>, hasTextMinedTerms <chr>,
#> #   hasDbCrossReferences <chr>, hasLabsLinks <chr>,
#> #   hasTMAccessionNumbers <chr>, firstPublicationDate <chr>
```

Use [ORCID](http://orcid.org/) to search for personal publications:


```r
epmc_search(query = 'AUTHORID:"0000-0002-7635-3473"', limit = 1000)
#> # A tibble: 132 × 27
#>          id source     pmid                          doi
#>       <chr>  <chr>    <chr>                        <chr>
#> 1  28013277    MED 28013277           10.1093/pcp/pcw205
#> 2  27230558    MED 27230558    10.1186/s12870-016-0805-5
#> 3  27214749    MED 27214749            10.1111/nph.14008
#> 4  26980001    MED 26980001    10.1186/s12864-016-2566-9
#> 5  27557761    MED 27557761  10.1007/978-1-4939-6396-6_5
#> 6  26676716    MED 26676716            10.1111/tpj.13103
#> 7  26343971    MED 26343971   10.1016/j.molp.2015.08.011
#> 8  26328666    MED 26328666    10.1186/s13059-015-0729-7
#> 9  27711162    MED 27711162 10.1371/journal.pone.0164321
#> 10 27660776    MED 27660776     10.1128/genomea.00975-16
#> # ... with 122 more rows, and 23 more variables: title <chr>,
#> #   authorString <chr>, journalTitle <chr>, issue <chr>,
#> #   journalVolume <chr>, pubYear <chr>, journalIssn <chr>, pageInfo <chr>,
#> #   pubType <chr>, isOpenAccess <chr>, inEPMC <chr>, inPMC <chr>,
#> #   hasPDF <chr>, hasBook <chr>, citedByCount <int>, hasReferences <chr>,
#> #   hasTextMinedTerms <chr>, hasDbCrossReferences <chr>,
#> #   hasLabsLinks <chr>, hasTMAccessionNumbers <chr>,
#> #   firstPublicationDate <chr>, pmcid <chr>, hasSuppl <chr>
```

### Include MeSH and UniProt synonyms

You may also want to include synonyms when searching Europe PMC. If
`synonym = TRUE` MeSH and UniProt synonyms are searched as well.


```r
# with snyonyms
epmc_search('aspirin', synonym = TRUE)
#> # A tibble: 100 × 27
#>          id source     pmid                            doi
#>       <chr>  <chr>    <chr>                          <chr>
#> 1  28147891    MED 28147891  10.1080/13880209.2017.1283706
#> 2  28142297    MED 28142297  10.1080/15419061.2017.1282469
#> 3  28472145    MED 28472145   10.1371/journal.pone.0177201
#> 4  28507039    MED 28507039 10.1158/1940-6207.capr-17-0033
#> 5  28464540    MED 28464540               10.1002/jhbp.461
#> 6  28481152    MED 28481152  10.1080/01616412.2017.1326657
#> 7  28504994    MED 28504994   10.1213/ane.0000000000002053
#> 8  28463532    MED 28463532  10.1080/17512433.2017.1324782
#> 9  28503981    MED 28503981  10.1080/09537104.2017.1306039
#> 10 28460643    MED 28460643      10.1186/s13058-017-0840-7
#> # ... with 90 more rows, and 23 more variables: title <chr>,
#> #   authorString <chr>, journalTitle <chr>, issue <chr>,
#> #   journalVolume <chr>, pubYear <chr>, journalIssn <chr>, pageInfo <chr>,
#> #   pubType <chr>, isOpenAccess <chr>, inEPMC <chr>, inPMC <chr>,
#> #   hasPDF <chr>, hasBook <chr>, citedByCount <int>, hasReferences <chr>,
#> #   hasTextMinedTerms <chr>, hasDbCrossReferences <chr>,
#> #   hasLabsLinks <chr>, hasTMAccessionNumbers <chr>,
#> #   firstPublicationDate <chr>, pmcid <chr>, hasSuppl <chr>

# without synonyms
epmc_search('aspirin', synonym = FALSE)
#> # A tibble: 100 × 27
#>          id source     pmid                            doi
#>       <chr>  <chr>    <chr>                          <chr>
#> 1  28147891    MED 28147891  10.1080/13880209.2017.1283706
#> 2  28464540    MED 28464540               10.1002/jhbp.461
#> 3  28472145    MED 28472145   10.1371/journal.pone.0177201
#> 4  28507039    MED 28507039 10.1158/1940-6207.capr-17-0033
#> 5  28463532    MED 28463532  10.1080/17512433.2017.1324782
#> 6  28481152    MED 28481152  10.1080/01616412.2017.1326657
#> 7  28432049    MED 28432049             10.2146/ajhp160219
#> 8  28453510    MED 28453510   10.1371/journal.pone.0175966
#> 9  28446712    MED 28446712          10.18632/aging.101224
#> 10 28444860    MED 28444860        10.1111/1755-5922.12268
#> # ... with 90 more rows, and 23 more variables: title <chr>,
#> #   authorString <chr>, journalTitle <chr>, issue <chr>,
#> #   journalVolume <chr>, pubYear <chr>, journalIssn <chr>, pageInfo <chr>,
#> #   pubType <chr>, isOpenAccess <chr>, inEPMC <chr>, inPMC <chr>,
#> #   hasPDF <chr>, hasBook <chr>, citedByCount <int>, hasReferences <chr>,
#> #   hasTextMinedTerms <chr>, hasDbCrossReferences <chr>,
#> #   hasLabsLinks <chr>, hasTMAccessionNumbers <chr>,
#> #   firstPublicationDate <chr>, pmcid <chr>, hasSuppl <chr>
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
#> 7  27507985    MED 27507985            10.3389/fpls.2016.01115
#> 8  27117628    MED 27117628                  10.1038/srep24971
#> 9  26343971    MED 26343971         10.1016/j.molp.2015.08.011
#> 10 28167950    MED 28167950            10.3389/fpls.2017.00007
#> # ... with 90 more rows, and 23 more variables: title <chr>,
#> #   authorString <chr>, journalTitle <chr>, issue <chr>,
#> #   journalVolume <chr>, pubYear <chr>, journalIssn <chr>, pageInfo <chr>,
#> #   pubType <chr>, isOpenAccess <chr>, inEPMC <chr>, inPMC <chr>,
#> #   hasPDF <chr>, hasBook <chr>, citedByCount <int>, hasReferences <chr>,
#> #   hasTextMinedTerms <chr>, hasDbCrossReferences <chr>,
#> #   hasLabsLinks <chr>, hasTMAccessionNumbers <chr>,
#> #   firstPublicationDate <chr>, pmcid <chr>, hasSuppl <chr>
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
#> 7  27507985    MED 27507985 PMC4960254
#> 8  27117628    MED 27117628 PMC4846993
#> 9  26343971    MED 26343971       <NA>
#> 10 28167950    MED 28167950 PMC5253381
#> # ... with 90 more rows
```

#### Record details

Full metadata as list. Please be aware that these lists can become very large, and fetching these data from Europe PMC therefore takes some time.


```r
my_list <- epmc_search('Gabi-Kat', output = 'raw', limit = 10)
# display the structure for one list element
str(my_list[[10]])
#> List of 38
#>  $ id                       : chr "28167950"
#>  $ source                   : chr "MED"
#>  $ pmid                     : chr "28167950"
#>  $ pmcid                    : chr "PMC5253381"
#>  $ doi                      : chr "10.3389/fpls.2017.00007"
#>  $ title                    : chr "Small One-Helix Proteins Are Essential for Photosynthesis in Arabidopsis."
#>  $ authorString             : chr "Beck J, Lohscheider JN, Albert S, Andersson U, Mendgen KW, Rojas-Stütz MC, Adamska I, Funck D."
#>  $ authorList               :List of 1
#>   ..$ author:List of 8
#>   .. ..$ :List of 5
#>   .. .. ..$ fullName   : chr "Beck J"
#>   .. .. ..$ firstName  : chr "Jochen"
#>   .. .. ..$ lastName   : chr "Beck"
#>   .. .. ..$ initials   : chr "J"
#>   .. .. ..$ affiliation: chr "Plant Physiology and Biochemistry Group, Department of Biology, University of Konstanz Konstanz, Germany."
#>   .. ..$ :List of 5
#>   .. .. ..$ fullName   : chr "Lohscheider JN"
#>   .. .. ..$ firstName  : chr "Jens N"
#>   .. .. ..$ lastName   : chr "Lohscheider"
#>   .. .. ..$ initials   : chr "JN"
#>   .. .. ..$ affiliation: chr "Plant Physiology and Biochemistry Group, Department of Biology, University of Konstanz Konstanz, Germany."
#>   .. ..$ :List of 5
#>   .. .. ..$ fullName   : chr "Albert S"
#>   .. .. ..$ firstName  : chr "Susanne"
#>   .. .. ..$ lastName   : chr "Albert"
#>   .. .. ..$ initials   : chr "S"
#>   .. .. ..$ affiliation: chr "Plant Physiology and Biochemistry Group, Department of Biology, University of Konstanz Konstanz, Germany."
#>   .. ..$ :List of 5
#>   .. .. ..$ fullName   : chr "Andersson U"
#>   .. .. ..$ firstName  : chr "Ulrica"
#>   .. .. ..$ lastName   : chr "Andersson"
#>   .. .. ..$ initials   : chr "U"
#>   .. .. ..$ affiliation: chr "Plant Physiology and Biochemistry Group, Department of Biology, University of Konstanz Konstanz, Germany."
#>   .. ..$ :List of 5
#>   .. .. ..$ fullName   : chr "Mendgen KW"
#>   .. .. ..$ firstName  : chr "Kurt W"
#>   .. .. ..$ lastName   : chr "Mendgen"
#>   .. .. ..$ initials   : chr "KW"
#>   .. .. ..$ affiliation: chr "Plant Physiology and Biochemistry Group, Department of Biology, University of Konstanz Konstanz, Germany."
#>   .. ..$ :List of 5
#>   .. .. ..$ fullName   : chr "Rojas-Stütz MC"
#>   .. .. ..$ firstName  : chr "Marc C"
#>   .. .. ..$ lastName   : chr "Rojas-Stütz"
#>   .. .. ..$ initials   : chr "MC"
#>   .. .. ..$ affiliation: chr "Plant Physiology and Biochemistry Group, Department of Biology, University of Konstanz Konstanz, Germany."
#>   .. ..$ :List of 5
#>   .. .. ..$ fullName   : chr "Adamska I"
#>   .. .. ..$ firstName  : chr "Iwona"
#>   .. .. ..$ lastName   : chr "Adamska"
#>   .. .. ..$ initials   : chr "I"
#>   .. .. ..$ affiliation: chr "Plant Physiology and Biochemistry Group, Department of Biology, University of Konstanz Konstanz, Germany."
#>   .. ..$ :List of 5
#>   .. .. ..$ fullName   : chr "Funck D"
#>   .. .. ..$ firstName  : chr "Dietmar"
#>   .. .. ..$ lastName   : chr "Funck"
#>   .. .. ..$ initials   : chr "D"
#>   .. .. ..$ affiliation: chr "Plant Physiology and Biochemistry Group, Department of Biology, University of Konstanz Konstanz, Germany."
#>  $ journalInfo              :List of 7
#>   ..$ volume              : chr "8"
#>   ..$ journalIssueId      : int 2519709
#>   ..$ dateOfPublication   : chr "2017 "
#>   ..$ monthOfPublication  : int 0
#>   ..$ yearOfPublication   : int 2017
#>   ..$ printPublicationDate: chr "2017-01-01"
#>   ..$ journal             :List of 6
#>   .. ..$ title              : chr "Frontiers in plant science"
#>   .. ..$ medlineAbbreviation: chr "Front Plant Sci"
#>   .. ..$ essn               : chr "1664-462X"
#>   .. ..$ issn               : chr "1664-462X"
#>   .. ..$ isoabbreviation    : chr "Front Plant Sci"
#>   .. ..$ nlmid              : chr "101568200"
#>  $ pubYear                  : chr "2017"
#>  $ pageInfo                 : chr "7"
#>  $ abstractText             : chr "The extended superfamily of chlorophyll a/b binding proteins comprises the Light-Harvesting Complex Proteins (L"| __truncated__
#>  $ affiliation              : chr "Plant Physiology and Biochemistry Group, Department of Biology, University of Konstanz Konstanz, Germany."
#>  $ language                 : chr "eng"
#>  $ pubModel                 : chr "Electronic-eCollection"
#>  $ pubTypeList              :List of 1
#>   ..$ pubType: chr [1:2] "research-article" "Journal Article"
#>  $ keywordList              :List of 1
#>   ..$ keyword: chr [1:5] "Photosynthesis" "Phylogeny" "Photoprotection" "Pigment-Protein Complexes" ...
#>  $ fullTextUrlList          :List of 1
#>   ..$ fullTextUrl:List of 3
#>   .. ..$ :List of 5
#>   .. .. ..$ availability    : chr "Open access"
#>   .. .. ..$ availabilityCode: chr "OA"
#>   .. .. ..$ documentStyle   : chr "pdf"
#>   .. .. ..$ site            : chr "Europe_PMC"
#>   .. .. ..$ url             : chr "http://europepmc.org/articles/PMC5253381?pdf=render"
#>   .. ..$ :List of 5
#>   .. .. ..$ availability    : chr "Open access"
#>   .. .. ..$ availabilityCode: chr "OA"
#>   .. .. ..$ documentStyle   : chr "html"
#>   .. .. ..$ site            : chr "Europe_PMC"
#>   .. .. ..$ url             : chr "http://europepmc.org/articles/PMC5253381"
#>   .. ..$ :List of 5
#>   .. .. ..$ availability    : chr "Subscription required"
#>   .. .. ..$ availabilityCode: chr "S"
#>   .. .. ..$ documentStyle   : chr "doi"
#>   .. .. ..$ site            : chr "DOI"
#>   .. .. ..$ url             : chr "https://doi.org/10.3389/fpls.2017.00007"
#>  $ isOpenAccess             : chr "Y"
#>  $ inEPMC                   : chr "Y"
#>  $ inPMC                    : chr "N"
#>  $ hasPDF                   : chr "Y"
#>  $ hasBook                  : chr "N"
#>  $ hasSuppl                 : chr "N"
#>  $ citedByCount             : int 0
#>  $ hasReferences            : chr "Y"
#>  $ hasTextMinedTerms        : chr "Y"
#>  $ hasDbCrossReferences     : chr "N"
#>  $ hasLabsLinks             : chr "Y"
#>  $ license                  : chr "cc by"
#>  $ authMan                  : chr "N"
#>  $ epmcAuthMan              : chr "N"
#>  $ nihAuthMan               : chr "N"
#>  $ hasTMAccessionNumbers    : chr "N"
#>  $ dateOfCreation           : chr "2017-02-07"
#>  $ dateOfRevision           : chr "2017-02-10"
#>  $ electronicPublicationDate: chr "2017-01-23"
#>  $ firstPublicationDate     : chr "2017-01-23"
```

### Get results number

Count hits before with `epmc_hits` to define limit. For example, get list of ids
that represent articles referencing DataCite DOIs:


```r
query <- "ACCESSION_TYPE:doi"
epmc_hits(query)
#> [1] 7245
# set limit to 10 records
my_data <- epmc_search(query = query, limit = 10)
head(my_data)
#> # A tibble: 6 × 27
#>         id source     pmid      pmcid                      doi
#>      <chr>  <chr>    <chr>      <chr>                    <chr>
#> 1 28280457    MED 28280457 PMC5321675 10.3389/fnmol.2017.00048
#> 2 28230794    MED 28230794 PMC5334628       10.3390/md15020048
#> 3 28079148    MED 28079148 PMC5228185        10.1038/srep40501
#> 4 28097071    MED 28097071 PMC5228508       10.7717/peerj.2874
#> 5 28097058    MED 28097058 PMC5228507       10.7717/peerj.2844
#> 6 28071681    MED 28071681 PMC5223163        10.1038/srep40034
#> # ... with 22 more variables: title <chr>, authorString <chr>,
#> #   journalTitle <chr>, journalVolume <chr>, pubYear <chr>,
#> #   journalIssn <chr>, pageInfo <chr>, pubType <chr>, isOpenAccess <chr>,
#> #   inEPMC <chr>, inPMC <chr>, hasPDF <chr>, hasBook <chr>,
#> #   hasSuppl <chr>, citedByCount <int>, hasReferences <chr>,
#> #   hasTextMinedTerms <chr>, hasDbCrossReferences <chr>,
#> #   hasLabsLinks <chr>, hasTMAccessionNumbers <chr>,
#> #   firstPublicationDate <chr>, issue <chr>
attr(my_data, "hit_count")
#> [1] 7245
```

You may also use `epmc_profile` to retrieve a summary of hit counts.


```r
epmc_profile(query = 'malaria')
#> $source
#> # A tibble: 10 × 2
#>     name  count
#> *  <chr>  <int>
#> 1    AGR    121
#> 2    CBA    118
#> 3    CTX      8
#> 4    ETH    239
#> 5    HIR      4
#> 6    MED 130208
#> 7    PAT   2295
#> 8    CIT      0
#> 9    PMC  10850
#> 10   PPR      2
#> 
#> $pubType
#> # A tibble: 5 × 2
#>                  name  count
#> *               <chr>  <int>
#> 1                 ALL 143845
#> 2           FULL TEXT  82186
#> 3         OPEN ACCESS  36145
#> 4              REVIEW  17124
#> 5 BOOKS AND DOCUMENTS     98
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
#> # A tibble: 1 × 32
#>         id source     pmid      pmcid              doi
#> *    <chr>  <chr>    <chr>      <chr>            <chr>
#> 1 24270414    MED 24270414 PMC3859427 10.1172/jci73168
#> # ... with 27 more variables: title <chr>, authorString <chr>,
#> #   pubYear <chr>, pageInfo <chr>, abstractText <chr>, language <chr>,
#> #   pubModel <chr>, isOpenAccess <chr>, inEPMC <chr>, inPMC <chr>,
#> #   hasPDF <chr>, hasBook <chr>, hasSuppl <chr>, citedByCount <int>,
#> #   hasReferences <chr>, hasTextMinedTerms <chr>,
#> #   hasDbCrossReferences <chr>, hasLabsLinks <chr>, authMan <chr>,
#> #   epmcAuthMan <chr>, nihAuthMan <chr>, hasTMAccessionNumbers <chr>,
#> #   dateOfCompletion <chr>, dateOfCreation <chr>, dateOfRevision <chr>,
#> #   electronicPublicationDate <chr>, firstPublicationDate <chr>
#> 
#> $author_details
#> # A tibble: 2 × 6
#>           fullName firstName       lastName initials authorId.type
#> *            <chr>     <chr>          <chr>    <chr>         <chr>
#> 1 Malaga-Dieguez L     Laura Malaga-Dieguez        L         ORCID
#> 2        Susztak K   Katalin        Susztak        K          <NA>
#> # ... with 1 more variables: authorId.value <chr>
#> 
#> $journal_info
#> # A tibble: 1 × 13
#>   issue volume journalIssueId dateOfPublication monthOfPublication
#> * <chr>  <chr>          <int>             <chr>              <int>
#> 1    12    123        2099360          2013 Dec                 12
#> # ... with 8 more variables: yearOfPublication <int>,
#> #   printPublicationDate <chr>, journal.title <chr>,
#> #   journal.medlineAbbreviation <chr>, journal.essn <chr>,
#> #   journal.issn <chr>, journal.isoabbreviation <chr>, journal.nlmid <chr>
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
#> # A tibble: 3 × 4
#>        grantId        agency acronym orderIn
#> *        <chr>         <chr>   <chr>   <int>
#> 1 R01 DK076077 NIDDK NIH HHS      DK       0
#> 2  R01DK076077 NIDDK NIH HHS      DK       0
#> 3 R01 DK087635 NIDDK NIH HHS      DK       0
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
#> 3  10440384    MED
#> 4   9696842    MED
#> 5   9703304    MED
#> 6   9728974    MED
#> 7   9728985    MED
#> 8   9728986    MED
#> 9   9728987    MED
#> 10 11134319    MED
#> # ... with 90 more rows, and 10 more variables: citationType <chr>,
#> #   title <chr>, authorString <chr>, journalAbbreviation <chr>,
#> #   pubYear <int>, volume <chr>, issue <chr>, pageInfo <chr>,
#> #   citedByCount <int>, text <chr>
# hits:
attr(my_cites, 'hit_count')
#> [1] 200
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

Get linksfrom Wikipedia (`lab_id = "1507"`)


```r
epmc_lablinks('20301687', lab_id = '1507')
#> # A tibble: 2 × 6
#>                                    title
#>                                    <chr>
#> 1                        Werner_syndrome
#> 2 Werner_syndrome_ATP-dependent_helicase
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
