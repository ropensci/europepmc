# europepmc v0.3

## Test environments

* local OS X install, R version 3.4.4
* Ubuntu 14.04.5 LTS (on travis-ci), R version 3.4.4 
* win-builder (devel and release) and appveyor CI

## R CMD check results

On local machine (OS):

Status: OK

The win-builder send one NOTE about possibly mis-spelled words in DESCRIPTION, which are, in fact, correctly spelled.

## Reverse dependencies

* I have run R CMD check on downstream dependencies using devtools::revdep_check() and found no problems related to this new version.

---

This submission implements the most recent API changes. This will fix current R checks problems. It also provides new functionalities and improved documentation.

Thanks!

Najko Jahn
