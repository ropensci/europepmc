# europepmc v 0.1.1

## Test environments

* local OS X install, R 3.3.2 
* ubuntu 12.04 (on travis-ci), R 3.3.1 
* win-builder (devel and release) and appveyor CI

## R CMD check results

I have run R CMD check locally using option "--as-cran" and found no problems.

The win-builder send one Note about possibly mis-spelled words in DESCRIPTION,
which are, in fact, correctly spelled.

## Reverse dependencies

* I have run R CMD check on downstream dependencies using devtools::revdep_check() 
and found no problems related to this new version.

---

Dear CRAN team,

This submission should fix issues shown on
https://cran.r-project.org/web/checks/check_results_europepmc.html

This submission implements Europe PMC's most recent API change to v4.5.3. Some
functions have new parameter, e.g. for controlling pageing and output formats. 
Documentation has been improved.

Thanks! Najko Jahn
