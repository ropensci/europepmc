# europepmc v 0.4

## Test environments

* local OS X install, R version R version 4.0.0 
* Ubuntu 16.04.6 LTS (on travis-ci), R version 4.0.0
* win-builder (oldrelease, release and devel) and appveyor CI

## R CMD check results

On local machine (OS):

Status: OK

Win-Builder:

Status: OK


## Reverse dependencies

* I have run R CMD check on downstream dependencies using revdepcheck::revdep_check() and found no problems related to this new version.

---

This submission implements the most recent API changes. This will fix current R checks problems. It also provides new functionalities and improved documentation.

Thanks!

Najko Jahn
