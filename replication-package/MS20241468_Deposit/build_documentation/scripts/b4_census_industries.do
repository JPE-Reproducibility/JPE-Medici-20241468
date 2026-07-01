*==============================================================================*
* b4_census_industries.do
*
* Builds county-level labor-force counts by IND1950 industry code, from IPUMS
* full-count census microdata, by census year, for working-age (16-64) men.
* For each county-year it counts men in each industry -- in total, and among
* European immigrants.
*
* INPUT  (in $rawlocal/):
*   IPUMS/IPUMS_fullcount_<year>.dta  - IPUMS full-count census microdata, one
*                                       file per year. Not shipped; see README.
*
* OUTPUT (in $intmdata/; b16 ships these to data/public/census_aggregates/):
*   IPUMS_<year>_ind1950counts_county.dta  - LF counts by IND1950 industry
* Read by 1b_merge_preadjust.
*
* Build stage - run via build_documentation/scripts/00_master_build.do, or standalone.
*==============================================================================*

clear all
set more off, perm

* Project root. 00_master.do sets \$root for the full run; the line below also
* lets this file run on its own -- set it to the local path of the package.
if "$root" == "" global root "set-this-to-the-replication-package-path"
global rawdata  "$root/data/public"
global rawlocal "$root/data/_raw_local"   // unshippable raw (IPUMS micro, ICPSR); excluded from deposit zip
global intmdata "$root/data/intermediate"
global data     "$root/data/clean"
cap mkdir "$intmdata"
cap mkdir "$data"


*------------------------------------------------------------------------------*
* Labor-force counts by IND1950 industry code
*------------------------------------------------------------------------------*

foreach year in 1880 1900 1910 1920 {

clear all
use if year == `year' & inrange(age,16,64) == 1 & sex == 1 & ind1950 != . using "$rawlocal/IPUMS/IPUMS_fullcount_`year'.dta", clear

* Population groups for the industry counts: everyone, and European
* immigrants (IPUMS birthplace codes 400-465).
gen all      = 1
gen euro_imm = (inrange(bpl,400,465) == 1)

* Labor-force dummy
if `year' != 1900 {
gen d_labforce = (labforce == 2) if labforce != 0								// = . if LF status is N/A (i.e., labforce == 0)
}
if `year' == 1900 {
gen d_labforce = (occ1950 < 980)												// labforce is missing in 1900: treat anyone with a recorded occupation as in the LF
}
label var d_labforce "= 1 if in Labor Force"

* Count, per county, the working-age men in each IND1950 industry, by group.
foreach i in all euro_imm {

foreach ind in 105 116 126 206 216 226 236 239 246 306 307 308 309 316 317 318 ///
               319 326 336 337 338 346 347 348 356 357 358 367 376 377 378 379 ///
               386 387 388 399 406 407 408 409 416 417 418 419 426 429 436 437 ///
               438 439 446 448 449 456 457 458 459 466 467 468 469 476 477 478 ///
               487 488 489 499 506 516 526 527 536 546 556 567 568 578 579 586 ///
               587 588 596 597 598 606 607 608 609 616 617 618 619 626 627 636 ///
               637 646 647 656 657 658 659 667 668 669 679 686 687 688 689 696 ///
               697 698 699 716 726 736 746 756 806 807 808 816 817 826 836 846 ///
               847 848 849 856 857 858 859 868 869 879 888 896 897 898 899 906 ///
               916 926 936 946 {

	gen `i'_lf_ind`ind'_m = (`i' == 1 & d_labforce == 1 & ind1950 == `ind')

}

order `i'_*_m, sequential last

}

keep year countyicp stateicp statefip all_* euro_imm_*
gcollapse (sum) *_lf_ind* (firstnm) statefip, by(stateicp countyicp year)

save "$intmdata/IPUMS_`year'_ind1950counts_county.dta", replace

}
