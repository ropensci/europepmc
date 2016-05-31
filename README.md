# europepmc - R Interface to Europe PMC RESTful Web Service




[![Build Status](https://travis-ci.org/ropensci/europepmc.svg?branch=master)](https://travis-ci.org/ropensci/europepmc)
[![Build status](https://ci.appveyor.com/api/projects/status/f8xtpvhhr074lk44?svg=true)](https://ci.appveyor.com/project/sckott/europepmc)
[![codecov.io](https://codecov.io/github/ropensci/europepmc/coverage.svg?branch=master)](https://codecov.io/github/ropensci/europepmc?branch=master)

europepmc facilitates access to [Europe PMC RESTful Web
Service](http://europepmc.org/RestfulWebService).

[Europe PMC](http://europepmc.org/) covers life science literature and
gives access to open access full texts. Europe
PMC ingests all PubMed content and extends its index with other sources,
including Agricola, a bibliographic database of citations to the agricultural
literature, or Biological Patents.

![Index coverage](https://europepmc.org/wicket/resource/uk.bl.ukpmc.web.pages.faq.Help/images/EuropePMCContent-ver-4BB17F003F8F38DF2D3BBE48AB5896C6.png)

For more background, see:

<https://europepmc.org/About>

Europe PMC: a full-text literature database for the life sciences and platform
for innovation. (2014). Nucleic Acids Research, 43(D1), D1042–D1048. doi:[10.1093/nar/gku1061](http://doi.org/10.1093/nar/gku1061)

## Installation

The latest development version can be installed using
[devtools](https://github.com/hadley/devtools) package:


```r
require(devtools)
install_github("ropensci/europepmc")
```

## Search Europe PMC

The search covers both metadata (e.g. abstracts or title) and full texts. To
build your query, please refer to the comprehensive guidance on how to search
Europe PMC: <http://europepmc.org/help>. Simply provide your query in the Europe
PMC search syntax to `epmc_search()`.

The search function helps to get a general overview about additional
information types that are offered by Europe PMC and which can be retrieved
through other `europepmc`-functions. Columns inform whether open access full texts
(`isOpenAccess`), cross-links to other EBI databases (`hasDbCrossReferences`),
text-mined terms (`hasTextMinedTerms`) or references (`hasReferences`) are
available.

By default, `epmc_search` returns 25 records. To adjust the limit, simply use
the `limit` parameter.

Either list of publication ids (`id_list = TRUE`) or key metadata
information  (`id_list = FALSE`, default option) are returned.

For instance, search for abstracts and full texts that mention `Gabi-Kat`:


```r
library(europepmc)
my_data <- epmc_search(query = 'Gabi-Kat')
# first six records
head(my_data)
#>         id source     pmid      pmcid                          doi
#> 1 27117628    MED 27117628 PMC4846993            10.1038/srep24971
#> 2 26842807    MED 26842807 PMC4740857            10.1038/srep20309
#> 3 26930070    MED 26930070 PMC4773003 10.1371/journal.pone.0150254
#> 4 26957563    MED 26957563 PMC4861014           10.1093/jxb/erw096
#> 5 27064270    MED 27064270 PMC4814454      10.3389/fpls.2016.00405
#> 6 26824478    MED 26824478 PMC4733102 10.1371/journal.pone.0148335
#>                                                                                                                                                                                                                  title
#> 1                                                                                                                         Cancer-specific binary expression system activated in mice by bacteriophage HK022 Integrase.
#> 2                                                                                  Precocious leaf senescence by functional loss of PROTEIN S-ACYL TRANSFERASE14 involves the NPR1-dependent salicylic acid signaling.
#> 3 The Arabidopsis Domain of Unknown Function 1218 (DUF1218) Containing Proteins, MODIFYING WALL LIGNIN-1 and 2 (At1g31720/MWL-1 and At4g19370/MWL-2) Function Redundantly to Alter Secondary Cell Wall Lignin Content.
#> 4                                                                                                                                                                  SLTAB2 is the paramutated SULFUREA locus in tomato.
#> 5                                                                                          Photosystem II Repair and Plant Immunity: Lessons Learned from Arabidopsis Mutant Lacking the THYLAKOID LUMEN PROTEIN 18.3.
#> 6                                                                                            The Early-Acting Peroxin PEX19 Is Redundantly Encoded, Farnesylated, and Essential for Viability in Arabidopsis thaliana.
#>                                                                                               authorString
#> 1 Elias A, Spector I, Sogolovsky-Bard I, Gritsenko N, Rask L, Mainbakh Y, Zilberstein Y, Yagil E, Kolot M.
#> 2                                                Zhao XY, Wang JG, Song SJ, Wang Q, Kang H, Zhang Y, Li S.
#> 3                                               Mewalal R, Mizrachi E, Coetzee B, Mansfield SD, Myburg AA.
#> 4                                                                          Gouil Q, Novák O, Baulcombe DC.
#> 5                            Järvi S, Isojärvi J, Kangasjärvi S, Salojärvi J, Mamedov F, Suorsa M, Aro EM.
#> 6                                 McDonnell MM, Burkhart SE, Stoddard JM, Wright ZJ, Strader LC, Bartel B.
#>      journalTitle journalVolume pubYear journalIssn  pageInfo
#> 1         Sci Rep             6    2016   2045-2322     24971
#> 2         Sci Rep             6    2016   2045-2322     20309
#> 3        PLoS One            11    2016   1932-6203  e0150254
#> 4       J Exp Bot            67    2016   0022-0957 2655-2664
#> 5 Front Plant Sci             7    2016   1664-462x       405
#> 6        PLoS One            11    2016   1932-6203  e0148335
#>                                                                                                                                               pubType
#> 1                                                                                                                   journal article; research-article
#> 2                                                                                                                   journal article; research-article
#> 3                                                                                                                   journal article; research-article
#> 4                                                                                                                   journal article; research-article
#> 5                                                                                                                   journal article; research-article
#> 6 journal article; research support, non-u.s. gov't; research support, u.s. gov't, non-p.h.s.; research support, n.i.h., extramural; research-article
#>   isOpenAccess inEPMC inPMC hasPDF hasBook hasSuppl citedByCount
#> 1            Y      Y     N      Y       N        N            0
#> 2            Y      Y     N      Y       N        N            1
#> 3            Y      Y     N      Y       N        N            0
#> 4            Y      Y     N      Y       N        Y            1
#> 5            Y      Y     N      Y       N        N            0
#> 6            Y      Y     N      Y       N        N            0
#>   hasReferences hasTextMinedTerms hasDbCrossReferences hasLabsLinks
#> 1             Y                 Y                    N            N
#> 2             Y                 Y                    N            N
#> 3             Y                 Y                    N            N
#> 4             Y                 Y                    N            N
#> 5             Y                 Y                    N            N
#> 6             Y                 Y                    N            N
#>   epmcAuthMan hasTMAccessionNumbers luceneScore issue
#> 1           N                     N         NaN  <NA>
#> 2           N                     N         NaN  <NA>
#> 3           N                     N         NaN     3
#> 4           N                     N         NaN     9
#> 5           N                     N         NaN  <NA>
#> 6           N                     N         NaN     1
```

Get PLOS Genetics (ISSN:1553-7404) articles that cross-reference EMBL:


```r
my_data <- epmc_search(query = 'ISSN:1553-7404 HAS_EMBL:y')
head(my_data)
#>         id source     pmid      pmcid                          doi
#> 1 27149082    MED 27149082 PMC4858218 10.1371/journal.pgen.1006030
#> 2 26982327    MED 26982327 PMC4794157 10.1371/journal.pgen.1005920
#> 3 27120580    MED 27120580 PMC4847869 10.1371/journal.pgen.1005987
#> 4 27082250    MED 27082250 PMC4833346 10.1371/journal.pgen.1005954
#> 5 26495848    MED 26495848 PMC4619825 10.1371/journal.pgen.1005609
#> 6 26020649    MED 26020649 PMC4447368 10.1371/journal.pgen.1005207
#>                                                                                                                                                                                                    title
#> 1 Germline Defects Caused by Smed-boule RNA-Interference Reveal That Egg Capsule Deposition Occurs Independently of Fertilization, Ovulation, Mating, or the Presence of Gametes in Planarian Flatworms.
#> 2                                                                                                            Hybrid Dysgenesis in Drosophila simulans Associated with a Rapid Invasion of the P-Element.
#> 3                                                 An Indel Polymorphism in the MtnA 3' Untranslated Region Is Associated with Gene Expression Variation and Local Adaptation in Drosophila melanogaster.
#> 4                                                                                        Chromosomal-Level Assembly of the Asian Seabass Genome Using Long Sequence Reads and Multi-layered Scaffolding.
#> 5                                                                                                                                                    Virus Satellites Drive Viral Evolution and Ecology.
#> 6                                                                      A Simple Auxin Transcriptional Response System Regulates Multiple Morphogenetic Processes in the Liverwort Marchantia polymorpha.
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             authorString
#> 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       Steiner JK, Tasaki J, Rouhana L.
#> 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  Hill T, Schlötterer C, Betancourt AJ.
#> 3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Catalán A, Glaser-Schmitt A, Argyridou E, Duchen P, Parsch J.
#> 4 Vij S, Kuhl H, Kuznetsova IS, Komissarov A, Yurchenko AA, Van Heusden P, Singh S, Thevasagayam NM, Prakki SR, Purushothaman K, Saju JM, Jiang J, Mbandi SK, Jonas M, Hin Yan Tong A, Mwangi S, Lau D, Ngoh SY, Liew WC, Shen X, Hon LS, Drake JP, Boitano M, Hall R, Chin CS, Lachumanan R, Korlach J, Trifonov V, Kabilov M, Tupikin A, Green D, Moxon S, Garvin T, Sedlazeck FJ, Vurture GW, Gopalapillai G, Kumar Katneni V, Noble TH, Scaria V, Sivasubbu S, Jerry DR, O'Brien SJ, Schatz MC, Dalmay T, Turner SW, Lok S, Christoffels A, Orbán L.
#> 5                                                                                                                                                                                                                                                                                                                                                                                                                                         Frígols B, Quiles-Puchalt N, Mir-Sanchis I, Donderis J, Elena SF, Buckling A, Novick RP, Marina A, Penadés JR.
#> 6                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               Flores-Sandoval E, Eklund DM, Bowman JL.
#>   journalTitle issue journalVolume pubYear journalIssn pageInfo
#> 1   PLoS Genet     5            12    2016   1553-7390 e1006030
#> 2   PLoS Genet     3            12    2016   1553-7390 e1005920
#> 3   PLoS Genet     4            12    2016   1553-7390 e1005987
#> 4   PLoS Genet     4            12    2016   1553-7390 e1005954
#> 5   PLoS Genet    10            11    2015   1553-7390 e1005609
#> 6   PLoS Genet     5            11    2015   1553-7390 e1005207
#>                                                               pubType
#> 1                                   journal article; research-article
#> 2                                   journal article; research-article
#> 3                                   journal article; research-article
#> 4                                                     journal article
#> 5 journal article; research support, non-u.s. gov't; research-article
#> 6 journal article; research support, non-u.s. gov't; research-article
#>   isOpenAccess inEPMC inPMC hasPDF hasBook hasSuppl citedByCount
#> 1            Y      Y     N      Y       N        N            0
#> 2            Y      Y     N      Y       N        N            1
#> 3            Y      Y     N      Y       N        N            0
#> 4            N      Y     N      N       N        N            0
#> 5            Y      Y     N      Y       N        N            0
#> 6            Y      Y     N      Y       N        N            3
#>   hasReferences hasTextMinedTerms hasDbCrossReferences hasLabsLinks
#> 1             Y                 Y                    Y            N
#> 2             Y                 Y                    Y            Y
#> 3             Y                 Y                    Y            N
#> 4             Y                 Y                    Y            N
#> 5             Y                 Y                    Y            Y
#> 6             Y                 Y                    Y            Y
#>   epmcAuthMan hasTMAccessionNumbers luceneScore
#> 1           N                     N         NaN
#> 2           N                     Y         NaN
#> 3           N                     Y         NaN
#> 4           N                     Y         NaN
#> 5           N                     Y         NaN
#> 6           N                     Y         NaN
```

### Get results number

Count hits before with `epmc_hits` to define limit. For example, get list of ids
that represent articles referencing DataCite DOIs:


```r
query <- "ACCESSION_TYPE:doi"
epmc_hits(query)
#> [1] 5050
# set limit to 10 records
my_data <- epmc_search(query = "ACCESSION_TYPE:doi", limit = 10,
                       id_list = TRUE)
head(my_data)
#>         id source     pmid      pmcid
#> 1 26997665    MED 26997665 PMC4797422
#> 2 27014734    MED 27014734 PMC4789307
#> 3 26855764    MED 26855764 PMC4686253
#> 4 26900179    MED 26900179 PMC4759657
#> 5 26424727    MED 26424727 PMC4678253
#> 6 27023427    MED 27023427 PMC4811434
attr(my_data, "hit_count")
#> [1] 5050
```

### Search with ORCID

Use [ORCID](http://orcid.org/) to search for personal publications:


```r
my_data <- epmc_search(query = 'AUTHORID:"0000-0002-7635-3473"')
attr(my_data, "hit_count")
#> [1] 126
```

### Include MeSH and UniProt synonyms

You may also want to include synonyms when searching Europe PMC. If
`synonym = TRUE` MeSH and UniProt synonyms are searched as well.


```r
my_data <- epmc_search("aspirin", synonym = TRUE)
attr(my_data, "hit_count")
#> [1] 111763

my_data <- epmc_search("aspirin", synonym = FALSE)
attr(my_data, "hit_count")
#> [1] 104561
```

## Get article details

In addition to key metadata, `epmc_details` also returns full metadata
providing more comprehensive information on the article-level. By default,
PubMed / Medline index is searched.



```r
epmc_details(ext_id = "24270414")
#> $basic
#>         id source     pmid      pmcid              doi
#> 1 24270414    MED 24270414 PMC3859427 10.1172/jci73168
#>                                     title                 authorString
#> 1 ADCK4 "reenergizes" nephrotic syndrome. Malaga-Dieguez L, Susztak K.
#>    pageInfo
#> 1 4996-4999
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         abstractText
#> 1 Steroid-resistant nephrotic syndrome has a poor prognosis and often leads to end-stage renal disease development. In this issue of the JCI, Ashraf and colleagues used exome sequencing to identify mutations in the aarF domain containing kinase 4 (ADCK4) gene that cause steroid-resistant nephrotic syndrome. Patients with ADCK4 mutations had lower coenzyme Q10 levels, and coenzyme Q10 supplementation ameliorated renal disease in a patient with this particular mutation, suggesting a potential therapy for patients with steroid-resistant nephrotic syndrome with ADCK4 mutations.
#>   language         pubModel isOpenAccess inEPMC inPMC hasPDF hasBook
#> 1      eng Print-Electronic            N      Y     Y      Y       N
#>   hasSuppl citedByCount hasReferences hasTextMinedTerms
#> 1        N            1             Y                 Y
#>   hasDbCrossReferences hasLabsLinks epmcAuthMan hasTMAccessionNumbers
#> 1                    N            N           N                     N
#>   dateOfCompletion dateOfCreation dateOfRevision electronicPublicationDate
#> 1       2014-02-04     2013-12-02     2015-07-10                2013-11-25
#>   firstPublicationDate luceneScore
#> 1           2013-11-25         NaN
#> 
#> $author_details
#>           fullName firstName       lastName initials
#> 1 Malaga-Dieguez L     Laura Malaga-Dieguez        L
#> 2        Susztak K   Katalin        Susztak        K
#> 
#> $journal_info
#>   issue volume journalIssueId dateOfPublication monthOfPublication
#> 1    12    123        2099360          2013 Dec                 12
#>   yearOfPublication printPublicationDate
#> 1              2013           2013-12-01
#>                           journal.title journal.medlineAbbreviation
#> 1 The Journal of clinical investigation               J Clin Invest
#>   journal.essn journal.issn journal.isoabbreviation journal.nlmid
#> 1    1558-8238    0021-9738        J. Clin. Invest.       7802877
#> 
#> $ftx
#>            availability availabilityCode documentStyle          site
#> 1                  Free                F           pdf    Europe_PMC
#> 2                  Free                F          html    Europe_PMC
#> 3                  Free                F           pdf PubMedCentral
#> 4                  Free                F          html PubMedCentral
#> 5 Subscription required                S           doi           DOI
#>                                                                                                     url
#> 1                                                   http://europepmc.org/articles/PMC3859427?pdf=render
#> 2                                                              http://europepmc.org/articles/PMC3859427
#> 3 http://www.pubmedcentral.nih.gov/picrender.fcgi?tool=EBI&pubmedid=24270414&action=stream&blobtype=pdf
#> 4                        http://www.pubmedcentral.nih.gov/articlerender.fcgi?tool=EBI&pubmedid=24270414
#> 5                                                                    http://dx.doi.org/10.1172/JCI73168
#> 
#> $chemical
#>                                     name registryNumber
#> 1                             Ubiquinone      1339-63-5
#> 2                        Protein Kinases       EC 2.7.-
#> 3 aarF domain containing kinase 4, human       EC 2.7.-
#> 4                           coenzyme Q10     EJ27X76M46
#> 
#> $mesh_topic
#>   majorTopic_YN     descriptorName
#> 1             N            Animals
#> 2             N             Humans
#> 3             N Nephrotic Syndrome
#> 4             N         Ubiquinone
#> 5             N    Protein Kinases
#> 
#> $comments
#>         id source                               reference       type
#> 1 24270420    MED J Clin Invest. 2013 Dec;123(12):5179-89 Comment on
#>   orderIn
#> 1      19
#> 
#> $grants
#>       grantId        agency acronym orderIn
#> 1 R01DK076077 NIDDK NIH HHS      DK       0
```

Show author details including ORCID:


```r
my_data <- epmc_details(ext_id = "14756321")
my_data$author_details
#>      fullName firstName  lastName initials authorId.type
#> 1    Rosso MG   Mario G     Rosso       MG          <NA>
#> 2        Li Y      Yong        Li        Y          <NA>
#> 3  Strizhov N   Nicolai  Strizhov        N          <NA>
#> 4     Reiss B     Bernd     Reiss        B         ORCID
#> 5    Dekker K      Koen    Dekker        K          <NA>
#> 6 Weisshaar B     Bernd Weisshaar        B         ORCID
#>        authorId.value
#> 1                <NA>
#> 2                <NA>
#> 3                <NA>
#> 4 0000-0002-2521-4000
#> 5                <NA>
#> 6 0000-0002-7635-3473
```

## Get citation counts and citing publications

Citing publications from the Europe PMC index can be retrieved like this:


```r
my_cites <- epmc_citations("9338777")
head(my_cites)
#>         id source
#> 1  9811736    MED
#> 2  9525633    MED
#> 3  9728986    MED
#> 4  9728985    MED
#> 5  9728987    MED
#> 6 10590090    MED
#>                                                                              citationType
#> 1                                       Journal Article; Research Support, Non-U.S. Gov't
#> 2                                                                         Journal Article
#> 3 Journal Article; Research Support, Non-U.S. Gov't; Research Support, U.S. Gov't, P.H.S.
#> 4                                       Journal Article; Research Support, Non-U.S. Gov't
#> 5                         Case Reports; Journal Article; Research Support, Non-U.S. Gov't
#> 6                                       Journal Article; Research Support, Non-U.S. Gov't
#>                                                                                                                  title
#> 1                                   Host range and interference studies of three classes of pig endogenous retrovirus.
#> 2              Type C retrovirus released from porcine primary peripheral blood mononuclear cells infects human cells.
#> 3          No evidence of infection with porcine endogenous retrovirus in recipients of porcine islet-cell xenografts.
#> 4           Expression of pig endogenous retrovirus by primary porcine endothelial cells and infection of human cells.
#> 5 No evidence of pig DNA or retroviral infection in patients with short-term extracorporeal connection to pig kidneys.
#> 6                                          Extended analysis of the in vitro tropism of porcine endogenous retrovirus.
#>                                                                                                       authorString
#> 1                                  Takeuchi Y, Patience C, Magre S, Weiss RA, Banerjee PT, Le Tissier P, Stoye JP.
#> 2                                                       Wilson CA, Wong S, Muller J, Davidson CE, Rose TM, Burd P.
#> 3 Heneine W, Tibell A, Switzer WM, Sandstrom P, Rosales GV, Mathews A, Korsgren O, Chapman LE, Folks TM, Groth CG.
#> 4                               Martin U, Kiessig V, Blusch JH, Haverich A, von der Helm K, Herden T, Steinhoff G.
#> 5                                  Patience C, Patton GS, Takeuchi Y, Weiss RA, McClure MO, Rydberg L, Breimer ME.
#> 6                                                                 Wilson CA, Wong S, VanBrocklin M, Federspiel MJ.
#>   journalAbbreviation pubYear volume issue  pageInfo citedByCount
#> 1           J. Virol.    1998     72    12 9986-9991          181
#> 2           J. Virol.    1998     72     4 3082-3087          179
#> 3              Lancet    1998    352  9129   695-699          159
#> 4              Lancet    1998    352  9129   692-694          142
#> 5              Lancet    1998    352  9129   699-701          136
#> 6           J. Virol.    2000     74     1     49-56          104
attr(my_cites, "hit_count")
#> [1] 182
```

Please note, that citation counts are often smaller than those held by toll-
access services such as Web of Science or Scopus because the number of
reference sections indexed for Europe PMC considerably differs due to the
lack of full text accessibility.

## Get reference section

Europe PMC indexes more than 5 million reference sections.


```r
epmc_refs("PMC3166943", data_src = "pmc")
#>          id source    citationType
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
#>                                                                                              title
#> 1                Gene ontology: tool for the unification of biology. The Gene Ontology Consortium.
#> 2                                                           The Gene Ontology (GO) project in 2008
#> 3                                                 Biomedical ontologies: a functional perspective.
#> 4                                                   Gene Ontology: looking backwards and forwards.
#> 5                              Gene Ontology annotations: what they mean and where they come from.
#> 6     The OBO Foundry: coordinated evolution of ontologies to support biomedical data integration.
#> 7  Documenting the emergence of bio-ontologies: or, why researching bioinformatics requires HPSSB.
#> 8                                                                            Ontology engineering.
#> 9                                                            Minutes of Gene Ontology 2005 Meeting
#> 10                                        Ontology development for biological systems: immunology.
#> 11           Innate immunity in plants and animals: striking similarities and obvious differences.
#> 12                                       The Gene Ontology (GO) database and informatics resource.
#> 13                                                Dynamic filaments of the bacterial cytoskeleton.
#> 14                                                                     The bacterial cytoskeleton.
#> 15        Cytoskeletal components of an invasion machine--the apical complex of Toxoplasma gondii.
#> 16                               A novel polymer of tubulin forms the conoid of Toxoplasma gondii.
#> 17                                                             Relations in biomedical ontologies.
#> 18                                           The Gene Ontology in 2010: extensions and refinements
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   authorString
#> 1                                                                                                                                                                                                                                                                                                                                                                                                                                                            Ashburner M, Ball CA, Blake JA, Botstein D, Butler H, Cherry JM, Davis AP, Dolinski K, Dwight SS, Eppig JT, Harris MA, Hill DP, Issel-Tarver L, Kasarskis A, Lewis S, Matese JC, Richardson JE, Ringwald M, Rubin GM, Sherlock G.
#> 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               AUTHOR UNKNOWN
#> 3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   Rubin DL, Shah NH, Noy NF.
#> 4                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    Lewis SE.
#> 5                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               Hill DP, Smith B, McAndrews-Hill MS, Blake JA.
#> 6                                                                                                                                                                                                                                                                                                                                                                                                                                                                    Smith B, Ashburner M, Rosse C, Bard J, Bug W, Ceusters W, Goldberg LJ, Eilbeck K, Ireland A, Mungall CJ; OBI Consortium, Leontis N, Rocca-Serra P, Ruttenberg A, Sansone SA, Scheuermann RH, Shah N, Whetzel PL, Lewis S.
#> 7                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  Leonelli S.
#> 8                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               Alterovitz G, Xiang M, Hill DP, Lomax J, Liu J, Cherkassky M, Dreyfuss J, Mungall C, Harris MA, Dolan ME, Blake JA, Ramoni MF.
#> 9                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               AUTHOR UNKNOWN
#> 10                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 Diehl AD, Lee JA, Scheuermann RH, Blake JA.
#> 11                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            Nurnberger T, Brunner F, Kemmerling B, Piater L.
#> 12 Harris MA, Clark J, Ireland A, Lomax J, Ashburner M, Foulger R, Eilbeck K, Lewis S, Marshall B, Mungall C, Richter J, Rubin GM, Blake JA, Bult C, Dolan M, Drabkin H, Eppig JT, Hill DP, Ni L, Ringwald M, Balakrishnan R, Cherry JM, Christie KR, Costanzo MC, Dwight SS, Engel S, Fisk DG, Hirschman JE, Hong EL, Nash RS, Sethuraman A, Theesfeld CL, Botstein D, Dolinski K, Feierbach B, Berardini T, Mundodi S, Rhee SY, Apweiler R, Barrell D, Camon E, Dimmer E, Lee V, Chisholm R, Gaudet P, Kibbe W, Kishore R, Schwarz EM, Sternberg P, Gwinn M, Hannick L, Wortman J, Berriman M, Wood V, de la Cruz N, Tonellato P, Jaiswal P, Seigfried T, White R; Gene Ontology Consortium.
#> 13                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Michie KA, Lowe J.
#> 14                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       Shih YL, Rothfield L.
#> 15                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             Hu K, Johnson J, Florens L, Fraunholz M, Suravajjala S, DiLullo C, Yates J, Roos DS, Murray JM.
#> 16                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   Hu K, Roos DS, Murray JM.
#> 17                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       Smith B, Ceusters W, Klagges B, Kohler J, Kumar A, Lomax J, Mungall C, Neuhaus F, Rector AL, Rosse C.
#> 18                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              AUTHOR UNKNOWN
#>           journalAbbreviation          issue pubYear    volume  pageInfo
#> 1                 Nat. Genet.              1    2000        25     25-29
#> 2                        <NA>           <NA>    2007      <NA>       1-5
#> 3       Brief. Bioinformatics              1    2008         9     75-90
#> 4                Genome Biol.              1    2005         6       103
#> 5          BMC Bioinformatics           <NA>    2008 9 Suppl 5        S2
#> 6            Nat. Biotechnol.             11    2007        25 1251-1255
#> 7        Hist Philos Life Sci              1    2010        32   105-125
#> 8            Nat. Biotechnol.              2    2010        28   128-130
#> 9                        <NA>           <NA>       0      <NA>      <NA>
#> 10             Bioinformatics              7    2007        23   913-915
#> 11              Immunol. Rev.           <NA>    2004       198   249-266
#> 12         Nucleic Acids Res. Database issue    2004        32   D258-61
#> 13        Annu. Rev. Biochem.           <NA>    2006        75   467-492
#> 14 Microbiol. Mol. Biol. Rev.              3    2006        70   729-754
#> 15               PLoS Pathog.              2    2006         2       e13
#> 16              J. Cell Biol.              6    2002       156 1039-1050
#> 17               Genome Biol.              5    2005         6       R46
#> 18                       <NA>    38 Database    2010      <NA> D331-D335
#>    citedOrder match      essn      issn       publicationTitle
#> 1           1     Y 1546-1718 1061-4036                   <NA>
#> 2           2     N      <NA>      <NA> Nucleic Acids Research
#> 3           3     Y 1477-4054 1467-5463                   <NA>
#> 4           4     Y 1474-760X 1474-7596                   <NA>
#> 5           5     Y 1471-2105      <NA>                   <NA>
#> 6           6     Y 1546-1696 1087-0156                   <NA>
#> 7           7     Y 1742-6316 0391-9714                   <NA>
#> 8           8     Y 1546-1696 1087-0156                   <NA>
#> 9           9     N      <NA>      <NA>                   <NA>
#> 10         10     Y 1367-4811 1367-4803                   <NA>
#> 11         11     Y 1600-065X 0105-2896                   <NA>
#> 12         12     Y 1362-4962 0305-1048                   <NA>
#> 13         13     Y 1545-4509 0066-4154                   <NA>
#> 14         14     Y 1098-5557 1092-2172                   <NA>
#> 15         15     Y 1553-7374 1553-7366                   <NA>
#> 16         16     Y 1540-8140 0021-9525                   <NA>
#> 17         17     Y 1474-760X 1474-7596                   <NA>
#> 18         18     N      <NA>      <NA> Nucleic Acids Research
#>                                                                           externalLink
#> 1                                                                                 <NA>
#> 2                                                                                 <NA>
#> 3                                                                                 <NA>
#> 4                                                                                 <NA>
#> 5                                                                                 <NA>
#> 6                                                                                 <NA>
#> 7                                                                                 <NA>
#> 8                                                                                 <NA>
#> 9  http://www.geneontology.org/minutes/20051115_TIGR_Content/20051115_TIGR_Content.pdf
#> 10                                                                                <NA>
#> 11                                                                                <NA>
#> 12                                                                                <NA>
#> 13                                                                                <NA>
#> 14                                                                                <NA>
#> 15                                                                                <NA>
#> 16                                                                                <NA>
#> 17                                                                                <NA>
#> 18                                                                                <NA>
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
epmc_db_count("12368864")
#>     dbName count
#> 1     EMBL    10
#> 2 INTERPRO     1
#> 3  UNIPROT  5588
```

Add `has_xrefs:y` or to your search string in `epmc_search` to make sure
you only get publications with cross-references to EBI databases.

Select database and get links:


```r
epmc_db("12368864", db = "embl")
#>       info1                                                       info2
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
#>      info3 info4
#> 1  3291871    10
#> 2  2038337    10
#> 3   947102    10
#> 4   947102    10
#> 5  2271494    10
#> 6  1687655    10
#> 7  1687656    10
#> 8  2038340    10
#> 9  3291936    10
#> 10 2271478    10
```

## Get text-mined terms

Text-mined terms that can be accessed via Europe PMC are mapped against
controlled vocabularies such as [Gene
Ontology](http://www.ebi.ac.uk/QuickGO/).  

Before retrieving these terms, please check availability and vocabularies
first:


```r
epmc_tm_count("25249410")
#>           name count
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
epmc_tm("25249410", semantic_type = "GO_TERM")
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
epmc_lablinks_count("PMC3986813", data_src = "pmc")
#>       providerName linksCount
#> 1 EBI Train Online          1
#> 2        Wikipedia          1
#> 3       BioStudies          1
```

Get links to PANGEA (`lab_id = "1342"`)


```r
epmc_lablinks("24023770", lab_id = "1342")
#>                                                                                                                                                                                                title
#> 1  Related to: Schewe, I (2010). Biochemical investigation of multicorer sediment profile PS74/106-3. Alfred Wegener Institute, Helmholtz Center for Polar and Marine Research, Bremerhaven, PANGAEA
#> 2  Related to: Schewe, I (2010). Biochemical investigation of multicorer sediment profile PS74/107-2. Alfred Wegener Institute, Helmholtz Center for Polar and Marine Research, Bremerhaven, PANGAEA
#> 3  Related to: Schewe, I (2010). Biochemical investigation of multicorer sediment profile PS74/108-2. Alfred Wegener Institute, Helmholtz Center for Polar and Marine Research, Bremerhaven, PANGAEA
#> 4  Related to: Schewe, I (2010). Biochemical investigation of multicorer sediment profile PS74/109-2. Alfred Wegener Institute, Helmholtz Center for Polar and Marine Research, Bremerhaven, PANGAEA
#> 5  Related to: Schewe, I (2010). Biochemical investigation of multicorer sediment profile PS74/113-2. Alfred Wegener Institute, Helmholtz Center for Polar and Marine Research, Bremerhaven, PANGAEA
#> 6  Related to: Schewe, I (2010). Biochemical investigation of multicorer sediment profile PS74/116-2. Alfred Wegener Institute, Helmholtz Center for Polar and Marine Research, Bremerhaven, PANGAEA
#> 7  Related to: Schewe, I (2010). Biochemical investigation of multicorer sediment profile PS74/118-2. Alfred Wegener Institute, Helmholtz Center for Polar and Marine Research, Bremerhaven, PANGAEA
#> 8  Related to: Schewe, I (2010). Biochemical investigation of multicorer sediment profile PS74/119-2. Alfred Wegener Institute, Helmholtz Center for Polar and Marine Research, Bremerhaven, PANGAEA
#> 9  Related to: Schewe, I (2010). Biochemical investigation of multicorer sediment profile PS74/120-2. Alfred Wegener Institute, Helmholtz Center for Polar and Marine Research, Bremerhaven, PANGAEA
#> 10 Related to: Schewe, I (2010). Biochemical investigation of multicorer sediment profile PS74/121-1. Alfred Wegener Institute, Helmholtz Center for Polar and Marine Research, Bremerhaven, PANGAEA
#> 11 Related to: Schewe, I (2010). Biochemical investigation of multicorer sediment profile PS74/127-2. Alfred Wegener Institute, Helmholtz Center for Polar and Marine Research, Bremerhaven, PANGAEA
#> 12 Related to: Schewe, I (2010). Biochemical investigation of multicorer sediment profile PS74/128-2. Alfred Wegener Institute, Helmholtz Center for Polar and Marine Research, Bremerhaven, PANGAEA
#> 13 Related to: Schewe, I (2010). Biochemical investigation of multicorer sediment profile PS74/129-3. Alfred Wegener Institute, Helmholtz Center for Polar and Marine Research, Bremerhaven, PANGAEA
#>                                         url lab_id lab_name
#> 1  http://dx.doi.org/10.1594/PANGAEA.744673   1342  PANGAEA
#> 2  http://dx.doi.org/10.1594/PANGAEA.744674   1342  PANGAEA
#> 3  http://dx.doi.org/10.1594/PANGAEA.744675   1342  PANGAEA
#> 4  http://dx.doi.org/10.1594/PANGAEA.744676   1342  PANGAEA
#> 5  http://dx.doi.org/10.1594/PANGAEA.744677   1342  PANGAEA
#> 6  http://dx.doi.org/10.1594/PANGAEA.744678   1342  PANGAEA
#> 7  http://dx.doi.org/10.1594/PANGAEA.744679   1342  PANGAEA
#> 8  http://dx.doi.org/10.1594/PANGAEA.744680   1342  PANGAEA
#> 9  http://dx.doi.org/10.1594/PANGAEA.744681   1342  PANGAEA
#> 10 http://dx.doi.org/10.1594/PANGAEA.744682   1342  PANGAEA
#> 11 http://dx.doi.org/10.1594/PANGAEA.744683   1342  PANGAEA
#> 12 http://dx.doi.org/10.1594/PANGAEA.744684   1342  PANGAEA
#> 13 http://dx.doi.org/10.1594/PANGAEA.744685   1342  PANGAEA
#>                                     lab_description
#> 1  Data Publisher for Earth & Environmental Science
#> 2  Data Publisher for Earth & Environmental Science
#> 3  Data Publisher for Earth & Environmental Science
#> 4  Data Publisher for Earth & Environmental Science
#> 5  Data Publisher for Earth & Environmental Science
#> 6  Data Publisher for Earth & Environmental Science
#> 7  Data Publisher for Earth & Environmental Science
#> 8  Data Publisher for Earth & Environmental Science
#> 9  Data Publisher for Earth & Environmental Science
#> 10 Data Publisher for Earth & Environmental Science
#> 11 Data Publisher for Earth & Environmental Science
#> 12 Data Publisher for Earth & Environmental Science
#> 13 Data Publisher for Earth & Environmental Science
```

## Full text access

Full texts are in XML format and are only provided for the Open Access subset
of Europe PMC. They can be retrieved by the PMCID.


```r
epmc_ftxt("PMC3257301")
#> {xml_document}
#> <article>
#> [1] <front>\n  <journal-meta>\n    <journal-id journal-id-type="nlm-ta"> ...
#> [2] <body>\n  <sec id="s1">\n    <title>Introduction</title>\n    <p>Atm ...
#> [3] <back>\n  <ack>\n    <p>We would like to thank Dr. C. Gourlay and Dr ...
```

Books, fetched through the PMID or the 'NBK' book number, can also be loaded
as XML into R for further text-mining activities.


```r
epmc_ftxt_book("NBK32884")
#> {xml_document}
#> <book-part>
#> [1] <book-meta>\n  <?showBookmeta?>\n  <book-id pub-id-type="pmcid">erta ...
#> [2] <book-part-meta>\n  <title-group>\n    <title>Table of Contents</tit ...
#> [3] <body>\n  <list list-type="simple">\n    <list-item>\n      <?toc-ta ...
```

Please check full-text availability before.

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
