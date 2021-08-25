# europepmc v 0.4.1

## Test environments

* local OS X install (Platform: aarch64-apple-darwin20 (64-bit)), R version 4.1.0 (2021-05-18)
* GitHub Actions initialized with `usethis::use_github_action("check-standard")`: windows-latest (release), macOS-latest (release), ubuntu-20.04 (release, devel)
* Win-Builder 

## R CMD check results

On local machine (OS):

Status: OK

Win-Builder:

Status: OK


## Reverse dependencies

* I have run R CMD check on downstream dependencies using revdepcheck::revdep_check() and found no problems related to this new version.

---

This submission implements the most recent API changes. This will fix current R checks problems. It will also prevent warnings and errors on CRAN when internet resource should fail.

Thanks!

Najko Jahn
