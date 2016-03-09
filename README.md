# rebi - R Interface to Europe PMC RESTful Web Service



[![Build Status](https://travis-ci.org/njahn82/rebi.svg?branch=master)](https://travis-ci.org/njahn82/rebi)

rebi facilitates access to [Europe PMC RESTful Web Service](http://europepmc.org/RestfulWebService). 

Europe PubMed Central, one of the largest literature databases for life-science 
publications,  indexes more than 30 millions publications, including 25
millions from PubMed. It gives also access to full texts, if available.

## Installation

The latest development version can be installed using [devtools](https://github.com/hadley/devtools) package:


```r
require(devtools)
install_github("njahn82/rebi")
```

## Search Europe PMC

Europe PMC provides comprehensive guidance on how to search:
<http://europepmc.org/help>


```r
my_data <- epmc_search(query='Gabi-Kat')
# number of records
my_data$hit_count
#> [1] 237
# first six records
head(my_data$md)
#>         id source     pmid      pmcid
#> 1 26842807    MED 26842807 PMC4740857
#> 2 26824478    MED 26824478 PMC4733102
#> 3 26343971    MED 26343971       <NA>
#> 4 26493293    MED 26493293 PMC4737287
#> 5 25262228    MED 25262228 PMC4265151
#> 6 25779053    MED 25779053 PMC4402529
#>                                                                                                                                       title
#> 1       Precocious leaf senescence by functional loss of PROTEIN S-ACYL TRANSFERASE14 involves the NPR1-dependent salicylic acid signaling.
#> 2                 The Early-Acting Peroxin PEX19 Is Redundantly Encoded, Farnesylated, and Essential for Viability in Arabidopsis thaliana.
#> 3 The Structural Features of Thousands of T-DNA Insertion Sites Are Consistent with a Double-Strand Break Repair-Based Insertion Mechanism.
#> 4                                    The RNA helicase, eIF4A-1, is required for ovule development and cell size homeostasis in Arabidopsis.
#> 5                                                       PERK-KIPK-KCBP signalling negatively regulates root growth in Arabidopsis thaliana.
#> 6                        The nuclease FAN1 is involved in DNA crosslink repair in Arabidopsis thaliana independently of the nuclease MUS81.
#>                                                                       authorString
#> 1                        Zhao XY, Wang JG, Song SJ, Wang Q, Kang H, Zhang Y, Li S.
#> 2         McDonnell MM, Burkhart SE, Stoddard JM, Wright ZJ, Strader LC, Bartel B.
#> 3           Kleinboelting N, Huep G, Appelhagen I, Viehoever P, Li Y, Weisshaar B.
#> 4                                            Bush MS, Crowe N, Zheng T, Doonan JH.
#> 5 Humphrey TV, Haasen KE, Aldea-Brydges MG, Sun H, Zayed Y, Indriolo E, Goring DR.
#> 6                                                  Herrmann NJ, Knoll A, Puchta H.
#>        journalTitle journalVolume pubYear journalIssn  pageInfo
#> 1           Sci Rep             6    2016   2045-2322     20309
#> 2          PLoS One            11    2016   1932-6203  e0148335
#> 3         Mol Plant             8    2015   1674-2052 1651-1664
#> 4           Plant J            84    2015   0960-7412  989-1004
#> 5         J Exp Bot            66    2015   0022-0957     71-83
#> 6 Nucleic Acids Res            43    2015   0305-1048 3653-3666
#>                                                               pubType
#> 1                                   journal article; research-article
#> 2                                   journal article; research-article
#> 3                   journal article; research support, non-u.s. gov't
#> 4                                   journal article; research-article
#> 5 journal article; research support, non-u.s. gov't; research-article
#> 6 journal article; research support, non-u.s. gov't; research-article
#>   isOpenAccess inEPMC inPMC hasPDF hasBook hasSuppl citedByCount
#> 1            Y      Y     N      Y       N        N            0
#> 2            Y      Y     N      Y       N        N            0
#> 3         <NA>      N     N      N       N        N            0
#> 4            Y      Y     N      Y       N        N            0
#> 5            Y      Y     N      Y       N        Y            1
#> 6            Y      Y     N      Y       N        Y            0
#>   hasReferences hasTextMinedTerms hasDbCrossReferences hasLabsLinks
#> 1             N                 N                    N            N
#> 2             N                 N                    N            N
#> 3             N                 N                    N            N
#> 4             N                 N                    N            N
#> 5             Y                 Y                    N            N
#> 6             Y                 Y                    N            N
#>   epmcAuthMan hasTMAccessionNumbers luceneScore
#> 1           N                     N         NaN
#> 2           N                     N         NaN
#> 3           N                     N         NaN
#> 4           N                     N         NaN
#> 5           N                     N         NaN
#> 6           N                     N         NaN
#>                            doi issue
#> 1            10.1038/srep20309  <NA>
#> 2 10.1371/journal.pone.0148335     1
#> 3   10.1016/j.molp.2015.08.011    11
#> 4            10.1111/tpj.13062     5
#> 5           10.1093/jxb/eru390     1
#> 6           10.1093/nar/gkv208     7
```

Get first PLOS Genetics articles that cross-reference EMBL


```r
my_data <- epmc_search(query = 'ISSN:1553-7404 HAS_EMBL:y')
head(my_data$md)
#>         id source     pmid      pmcid
#> 1 25664770    MED 25664770 PMC4335487
#> 2 26379286    MED 26379286 PMC4574769
#> 3 26241656    MED 26241656 PMC4524724
#> 4 26115430    MED 26115430 PMC4483262
#> 5 26427027    MED 26427027 PMC4591017
#> 6 25951176    MED 25951176 PMC4423873
#>                                                                                                                                             title
#> 1                                    Tribolium castaneum RR-1 cuticular protein TcCPR4 is required for formation of pore canals in rigid cuticle.
#> 2                                                  Recurrent Domestication by Lepidoptera of Genes from Their Parasites Mediated by Bracoviruses.
#> 3                             Retrohoming of a Mobile Group II Intron in Human Cells Suggests How Eukaryotes Limit Group II Intron Proliferation.
#> 4                       Genetic Changes to a Transcriptional Silencer Element Confers Phenotypic Diversity within and between Drosophila Species.
#> 5                    Functional Impact and Evolution of a Novel Human Polymorphic Inversion That Disrupts a Gene and Creates a Fusion Transcript.
#> 6 Natural Variation Identifies ICARUS1, a Universal Gene Required for Cell Proliferation and Growth at High Temperatures in Arabidopsis thaliana.
#>                                                                                                                                              authorString
#> 1                                                                                                          Noh MY, Muthukrishnan S, Kramer KJ, Arakane Y.
#> 2                                Gasmi L, Boulain H, Gauthier J, Hua-Van A, Musset K, Jakubowska AK, Aury JM, Volkoff AN, Huguet E, Herrero S, Drezen JM.
#> 3                                                                                                   Truong DM, Hewitt FC, Hanson JH, Cui X, Lambowitz AM.
#> 4                                                                                      Johnson WC, Ordway AJ, Watada M, Pruitt JN, Williams TM, Rebeiz M.
#> 5                     Puig M, Castellano D, Pantano L, Giner-Delgado C, Izquierdo D, Gayà-Vidal M, Lucas-Lledó JI, Esko T, Terao C, Matsuda F, Cáceres M.
#> 6 Zhu W, Ausin I, Seleznev A, Méndez-Vigo B, Picó FX, Sureshkumar S, Sundaramoorthi V, Bulach D, Powell D, Seemann T, Alonso-Blanco C, Balasubramanian S.
#>   journalTitle issue journalVolume pubYear journalIssn pageInfo
#> 1   PLoS Genet     2            11    2015   1553-7390 e1004963
#> 2   PLoS Genet     9            11    2015   1553-7390 e1005470
#> 3   PLoS Genet     8            11    2015   1553-7390 e1005422
#> 4   PLoS Genet     6            11    2015   1553-7390 e1005279
#> 5   PLoS Genet    10            11    2015   1553-7390 e1005495
#> 6   PLoS Genet     5            11    2015   1553-7390 e1005085
#>                                                                                                         pubType
#> 1                                           journal article; research support, non-u.s. gov't; research-article
#> 2                                           journal article; research support, non-u.s. gov't; research-article
#> 3                                           journal article; research support, non-u.s. gov't; research-article
#> 4 journal article; research support, non-u.s. gov't; research support, u.s. gov't, non-p.h.s.; research-article
#> 5                                           journal article; research support, non-u.s. gov't; research-article
#> 6                                           journal article; research support, non-u.s. gov't; research-article
#>   isOpenAccess inEPMC inPMC hasPDF hasBook hasSuppl citedByCount
#> 1            Y      Y     N      Y       N        N            1
#> 2            Y      Y     N      Y       N        N            0
#> 3            Y      Y     N      Y       N        N            0
#> 4            Y      Y     N      Y       N        N            0
#> 5            Y      Y     N      Y       N        N            0
#> 6            Y      Y     N      Y       N        N            0
#>   hasReferences hasTextMinedTerms hasDbCrossReferences hasLabsLinks
#> 1             Y                 Y                    Y            N
#> 2             Y                 Y                    Y            N
#> 3             Y                 Y                    Y            N
#> 4             Y                 Y                    Y            N
#> 5             Y                 Y                    Y            N
#> 6             Y                 Y                    Y            Y
#>   epmcAuthMan hasTMAccessionNumbers luceneScore
#> 1           N                     Y         NaN
#> 2           N                     Y         NaN
#> 3           N                     Y         NaN
#> 4           N                     N         NaN
#> 5           N                     Y         NaN
#> 6           N                     Y         NaN
#>                            doi
#> 1 10.1371/journal.pgen.1004963
#> 2 10.1371/journal.pgen.1005470
#> 3 10.1371/journal.pgen.1005422
#> 4 10.1371/journal.pgen.1005279
#> 5 10.1371/journal.pgen.1005495
#> 6 10.1371/journal.pgen.1005085
```

Get list of ids that represent articles referencing DataCite DOIs


```r
my_data <- epmc_search(query = "ACCESSION_TYPE:doi", n_pages = 1, 
                       id_list = TRUE)
head(my_data$md)
#>         id source     pmid      pmcid
#> 1 26474846    MED 26474846 PMC4693979
#> 2 26725519    MED 26725519 PMC4698588
#> 3 26734726    MED 26734726 PMC4703221
#> 4 26751378    MED 26751378 PMC4709234
#> 5 26751577    MED 26751577 PMC4709135
#> 6 26731720    MED 26731720 PMC4701503
my_data$hit_count
#> [1] 4262
```

## Get article details


```r
epmc_details(ext_id = "24270414")
#> $basic
#>         id source     pmid      pmcid
#> 1 24270414    MED 24270414 PMC3859427
#>                                     title                 authorString
#> 1 ADCK4 "reenergizes" nephrotic syndrome. Malaga-Dieguez L, Susztak K.
#>    pageInfo
#> 1 4996-4999
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         abstractText
#> 1 Steroid-resistant nephrotic syndrome has a poor prognosis and often leads to end-stage renal disease development. In this issue of the JCI, Ashraf and colleagues used exome sequencing to identify mutations in the aarF domain containing kinase 4 (ADCK4) gene that cause steroid-resistant nephrotic syndrome. Patients with ADCK4 mutations had lower coenzyme Q10 levels, and coenzyme Q10 supplementation ameliorated renal disease in a patient with this particular mutation, suggesting a potential therapy for patients with steroid-resistant nephrotic syndrome with ADCK4 mutations.
#>   language         pubModel isOpenAccess inEPMC inPMC hasPDF hasBook
#> 1      eng Print-Electronic            N      Y     Y      Y       N
#>   hasSuppl citedByCount hasReferences hasTextMinedTerms
#> 1        N            0             Y                 Y
#>   hasDbCrossReferences hasLabsLinks epmcAuthMan hasTMAccessionNumbers
#> 1                    N            N           N                     N
#>   dateOfCompletion dateOfCreation dateOfRevision electronicPublicationDate
#> 1       2014-02-04     2013-12-02     2015-07-10                2013-11-25
#>   firstPublicationDate luceneScore              doi
#> 1           2013-11-25         NaN 10.1172/jci73168
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

Show author details including orcid, if available


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


```r
my_cites <- epmc_citations("9338777")
my_cites$hit_count
#> [1] 178
head(my_cites$citations)
#>         id source
#> 1  9728985    MED
#> 2  9728986    MED
#> 3  9728987    MED
#> 4  9811736    MED
#> 5 11222700    MED
#> 6 10590090    MED
#>                                                                              citationType
#> 1                                       Journal Article; Research Support, Non-U.S. Gov't
#> 2 Journal Article; Research Support, Non-U.S. Gov't; Research Support, U.S. Gov't, P.H.S.
#> 3                         Case Reports; Journal Article; Research Support, Non-U.S. Gov't
#> 4                                       Journal Article; Research Support, Non-U.S. Gov't
#> 5                                       Journal Article; Research Support, Non-U.S. Gov't
#> 6                                       Journal Article; Research Support, Non-U.S. Gov't
#>                                                                                                                  title
#> 1           Expression of pig endogenous retrovirus by primary porcine endothelial cells and infection of human cells.
#> 2          No evidence of infection with porcine endogenous retrovirus in recipients of porcine islet-cell xenografts.
#> 3 No evidence of pig DNA or retroviral infection in patients with short-term extracorporeal connection to pig kidneys.
#> 4                                   Host range and interference studies of three classes of pig endogenous retrovirus.
#> 5                                             Multiple groups of novel retroviral genomes in pigs and related species.
#> 6                                          Extended analysis of the in vitro tropism of porcine endogenous retrovirus.
#>                                                                                                       authorString
#> 1                               Martin U, Kiessig V, Blusch JH, Haverich A, von der Helm K, Herden T, Steinhoff G.
#> 2 Heneine W, Tibell A, Switzer WM, Sandstrom P, Rosales GV, Mathews A, Korsgren O, Chapman LE, Folks TM, Groth CG.
#> 3                                  Patience C, Patton GS, Takeuchi Y, Weiss RA, McClure MO, Rydberg L, Breimer ME.
#> 4                                  Takeuchi Y, Patience C, Magre S, Weiss RA, Banerjee PT, Le Tissier P, Stoye JP.
#> 5                      Patience C, Switzer WM, Takeuchi Y, Griffiths DJ, Goward ME, Heneine W, Stoye JP, Weiss RA.
#> 6                                                                 Wilson CA, Wong S, VanBrocklin M, Federspiel MJ.
#>   journalAbbreviation pubYear volume issue  pageInfo citedByCount text
#> 1              Lancet    1998    352  9129   692-694          137 <NA>
#> 2              Lancet    1998    352  9129   695-699          156 <NA>
#> 3              Lancet    1998    352  9129   699-701          131 <NA>
#> 4           J. Virol.    1998     72    12 9986-9991          174 <NA>
#> 5           J. Virol.    2001     75     6 2771-2775           88 <NA>
#> 6           J. Virol.    2000     74     1     49-56          104 <NA>
```

## Get reference section


```r
epmc_refs("PMC3166943", data_src = "pmc")
#> $hit_count
#> [1] 18
#> 
#> $references
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

## Retrieve links to other EBI databases

Summary of links found


```r
epmc_db_count("12368864")
#>     dbName count
#> 1     EMBL     5
#> 2 INTERPRO     1
#> 3  UNIPROT  5320
```

Select database and get links:


```r
epmc_db("12368864", db = "embl")
#> $hit_count
#> [1] 5
#> 
#> $references
#>      info1                                                       info2
#> 1 AE014187 Plasmodium falciparum 3D7 chromosome 14, complete sequence.
#> 2 AE014186 Plasmodium falciparum 3D7 chromosome 11, complete sequence.
#> 3 AE001362  Plasmodium falciparum 3D7 chromosome 2, complete sequence.
#> 4 AE014188 Plasmodium falciparum 3D7 chromosome 12, complete sequence.
#> 5 AE014185 Plasmodium falciparum 3D7 chromosome 10, complete sequence.
#>     info3 info4
#> 1 3291871     5
#> 2 2038337     5
#> 3  947102     5
#> 4 2271478     5
#> 5 1687655     5
#> 
#> $db
#> [1] "embl"
```


## Get text-mined terms

Summary of text-mined terms


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

Select semantic type to retrieve the terms:


```r
epmc_tm("25249410", semantic_type = "GO_TERM")
#> $hit_count
#> [1] 17
#> 
#> $tm_terms
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


## References

Europe PMC: a full-text literature database for the life sciences and platform 
for innovation. (2014). Nucleic Acids Research, 43(D1), D1042–D1048. doi:[10.1093/nar/gku1061](http://doi.org/10.1093/nar/gku1061)
