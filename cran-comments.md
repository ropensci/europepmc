# europepmc v0.3

## Test environments

* local OS X install, R version 3.4.4
* Ubuntu 14.04.5 LTS (on travis-ci), R version 3.4.4 
* win-builder (devel and release) and appveyor CI

## R CMD check results

On local machine (OS):

Status: OK

Win-Builder:

The win-builder send one NOTE about possibly mis-spelled words in DESCRIPTION, which are, in fact, correctly spelled.

Win-builder R version 3.3.3 (2017-03-06) notes about (possibly) invalid URLs, which, in fact, are valid.

## Reverse dependencies

* I have run R CMD check on downstream dependencies using devtools::revdep_check() and found no problems related to this new version.

---

This submission implements the most recent API changes. This will fix current R checks problems. It also provides new functionalities and improved documentation.

Thanks!

Najko Jahn
