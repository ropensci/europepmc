% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/epmc_db.r
\name{epmc_db}
\alias{epmc_db}
\title{Retrieve external database entities referenced in a given publication}
\usage{
epmc_db(
  ext_id = NULL,
  data_src = "med",
  db = NULL,
  limit = 100,
  verbose = TRUE
)
}
\arguments{
\item{ext_id}{character, publication identifier}

\item{data_src}{character, data source, by default Pubmed/MedLine index will
  be searched.


  The following three letter codes represent the sources
  Europe PubMed Central supports:
  \describe{
    \item{agr}{Agricola is a bibliographic database of citations to the
    agricultural literature created by the US National Agricultural Library
    and its co-operators.}
    \item{cba}{Chinese Biological Abstracts}
    \item{ctx}{CiteXplore}
    \item{eth}{EthOs Theses, i.e. PhD theses (British Library)}
    \item{hir}{NHS Evidence}
    \item{med}{PubMed/Medline NLM}
    \item{nbk}{Europe PMC Book metadata}
    \item{pat}{Biological Patents}
    \item{pmc}{PubMed Central}
    }}

\item{db}{character, specify database:
\describe{
\item{'ARXPR'}{Array Express, a database of functional genomics experiments}
\item{'CHEBI'}{a database and ontology of chemical entities of biological
    interest}
 \item{'CHEMBL'}{a database of bioactive drug-like small molecules}
 \item{'EMBL'}{now ENA, provides a comprehensive record of the world's
 nucleotide sequencing information}
 \item{'INTACT'}{provides a freely available, open
    source database system and analysis tools for molecular interaction data}
 \item{'INTERPRO'}{provides functional analysis of proteins by classifying
    them into families and predicting domains and important sites}
 \item{'OMIM'}{a comprehensive and authoritative compendium of human genes and
    genetic phenotypes}
 \item{'PDB'}{European resource for the collection,
    organisation and dissemination of data on biological macromolecular
    structures}
 \item{'UNIPROT'}{comprehensive and freely accessible
    resource of protein sequence and functional information}
 \item{'PRIDE'}{PRIDE Archive - proteomics data repository}}}

\item{limit}{integer, number of results. By default, this function
returns 100 records.}

\item{verbose}{logical, print some information on what is going on.}
}
\value{
Cross-references as data.frame
}
\description{
This function returns EBI database entities referenced in a publication from
Europe PMC RESTful Web Service.
}
\examples{
  \dontrun{
  epmc_db("12368864", db = "uniprot", limit = 150)
  epmc_db("25249410", db = "embl")
  epmc_db("14756321", db = "uniprot")
  epmc_db("11805837", db = "pride")
  }
}
