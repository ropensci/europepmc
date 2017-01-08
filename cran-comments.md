# europepmc v 0.1.2

## Test environments

* local OS X install, R 3.3.2 
* ubuntu 12.04 (on travis-ci), R 3.3.1 
* win-builder (devel and release) and appveyor CI

## R CMD check results

I have run R CMD check locally using option "--as-cran" and one note:

* checking CRAN incoming feasibility ... NOTE
Maintainer: ‘Najko Jahn <najko.jahn@gmail.com>’

Days since last update: 2

The win-builder furthermore send one Note about possibly mis-spelled words in DESCRIPTION,
which are, in fact, correctly spelled.

## Reverse dependencies

* I have run R CMD check on downstream dependencies using devtools::revdep_check() 
and found no problems related to this new version.

---

Dear CRAN team,

Apologies for this submission of a new version after two days. 

This version should fix issues reported by CRAN checks and Uwe Ligges. These errors occured while building the vignette, more specifically some functions stopped because the web service sometimes returned HTTP 500 errors. There is now a new function caching 500 errors. It also re-tries a call up to five times when a 500 occur. I will also report the HTTP 500 errors to the maintainer of the web service.

This submission should also fix a note on importing the xml2 package.

This submission adds a new function, epmc_profile(), returning a profile of hit counts.

Thanks! Najko Jahn
