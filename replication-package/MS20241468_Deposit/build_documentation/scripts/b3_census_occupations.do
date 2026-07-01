*==============================================================================*
* b3_census_occupations.do
*
* Builds county-level occupation counts from IPUMS full-count census micro-
* data, by census year, for working-age (16-64) men. For each county-year it
* counts men in each OCC1950 occupation, split by population group: natives
* (nat / nat_np / all) and -- for European immigrants -- by birthplace
* country. A second pass restricts to immigrants who arrived within the last
* 10 years; a final pass merges the per-group files into one occupation
* dataset per census year.
*
* INPUT  (in $rawlocal/):
*   IPUMS/IPUMS_fullcount_<year>.dta  - IPUMS full-count census microdata, one
*                                       file per year. Not shipped; see README.
*
* OUTPUTS (in $intmdata/; b16 ships these to data/public/census_aggregates/):
*   IPUMS_<year>_nat_all_occ_county_m.dta       - natives, by occupation
*   IPUMS_<year>_euroimm_occ_county_m.dta       - immigrants, by country x occ
*   IPUMS_<year>_euroimm_occ_10yr_county_m.dta  - recent (<10yr) immigrants
*   IPUMS_<year>_occ_county_m.dta               - the three merged (read by 1b_merge_preadjust)
* The first three are per-group intermediates consumed by the merge below.
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
* Occupation counts: all occupations, by nativity group / birthplace country
*------------------------------------------------------------------------------*

foreach group in nat_all euroimm {

if "`group'" == "nat_all" {
local condition = "bpl != ."
}
if "`group'" == "euroimm" {
local condition = "inrange(bpl,400,465) == 1"
}

foreach year in 1880 1900 1910 1920 {

local s = "m"

clear all
clear mata
set maxvar 120000

use if inrange(age,16,64) == 1 & sex == 1 & `condition' using "$rawlocal/IPUMS/IPUMS_fullcount_`year'.dta", clear

if `year' == 1900 {
keep stateicp year countyicp sex bpl nativity race occ1950 ind1950 occscore histid
}
if `year' != 1900 {
keep stateicp year countyicp sex bpl nativity race occ1950 ind1950 labforce histid
}

if "`group'" == "nat_all" {
* Natives: born in the U.S.; nat_np adds native parentage
gen byte nat    = (bpl < 150)
gen byte nat_np = (nat == 1 & nativity == 1)
gen byte all    = 1
}

if "`group'" == "euroimm" {
* Birthplace-country dummies, by IPUMS bpl code
* Northern Europe
gen byte denmark     = (bpl == 400)
gen byte finland     = (bpl == 401)
gen byte norway      = (bpl == 404)
gen byte sweden      = (bpl == 405)
gen byte uk          = (inrange(bpl,410,413))
gen byte ireland     = (bpl == 414)
gen byte oth_northeu = (inlist(bpl,402,403,419))
* Western Europe
gen byte belgium    = (bpl == 420)
gen byte france     = (bpl == 421)
gen byte luxemb     = (bpl == 423)
gen byte nether     = (bpl == 425)
gen byte switz      = (bpl == 426)
gen byte oth_westeu = (inlist(bpl,422,424,429))
* Southern Europe
gen byte italy       = (bpl == 434)
gen byte gr_pt_es    = (inlist(bpl,433,436,438))
gen byte oth_southeu = (inlist(bpl,430,431,432,435,437,439,440))
* Central-Eastern Europe
gen byte aus_hung     = (inlist(bpl,450,454))
gen byte czech        = (bpl == 452)
gen byte germany      = (bpl == 453)
gen byte poland       = (bpl == 455)
gen byte oth_easteu   = (inlist(bpl,451,456,457,459))
gen byte oth_centereu = (inlist(bpl,458))
* Russian Empire
gen byte russia     = (bpl == 465)
gen byte oth_russeu = (inlist(bpl,460,461,462,463))
}

* Labor-force dummy
if `year' != 1900 {
gen byte d_labforce = (labforce == 2) if labforce != 0								// = . if LF status is N/A (i.e., labforce == 0)
}
if `year' == 1900 {
gen byte d_labforce = (occ1950 < 980)								// labforce is missing in 1900: treat anyone with a recorded occupation as in the LF
}

* Split the OCC1950 operative residual (970) into industry-specific codes
replace occ1950 = 971 if occ1950 == 970 & inlist(ind1950,437,446,449) == 1		// textile industry
replace occ1950 = 972 if occ1950 == 970 & inlist(ind1950,406) == 1				// meat-production industry
replace occ1950 = 973 if occ1950 == 970 & inlist(ind1950,418) == 1				// beverage industry

levelsof occ1950 if occ1950 < 979, local(occupationcodes)

* Count, per county, the in-LF working-age men in each occupation, by group, plus
* the labor-force total. Computed as a narrow collapse over the group indicators by
* county x occupation, then reshaped wide -- equivalent to one dummy per
* (group x occupation) + a collapse of thousands of columns, but far faster on the
* full count.

if "`group'" == "nat_all" local groups nat nat_np all
if "`group'" == "euroimm" local groups denmark finland norway sweden uk ireland oth_northeu belgium france luxemb nether switz oth_westeu italy gr_pt_es oth_southeu aus_hung czech germany poland oth_easteu oth_centereu russia oth_russeu

* (a) Labor-force totals: count of in-LF men of each group, by county. Over all
*     working-age men, so a county with men but no in-LF men still appears (lf = 0).
preserve
foreach j of local groups {
    gen byte `j'_lf_`s' = (`j' == 1 & d_labforce == 1)
}
* For euroimm, also carry the bare country population totals (count of working-
* age men born in each country, by county).
if "`group'" == "euroimm" gcollapse (sum) *_lf_`s' `groups', by(stateicp countyicp year)
else                      gcollapse (sum) *_lf_`s', by(stateicp countyicp year)
tempfile lftot
save `lftot'
restore

* (b) Occupation counts: in-LF men with occ < 979, by county x occupation, reshaped
*     wide to <group>_occ<occ>_<s>. Padded stubs g01.. avoid reshape's nat/nat_np
*     prefix collision.
preserve
keep if d_labforce == 1 & occ1950 < 979
local stubs ""
local k = 0
foreach j of local groups {
    local ++k
    local pad = string(`k', "%02.0f")
    rename `j' g`pad'
    local stubs "`stubs' g`pad'"
}
gcollapse (sum) `stubs', by(stateicp countyicp year occ1950)
reshape wide `stubs', i(stateicp countyicp year) j(occ1950)
local k = 0
foreach j of local groups {
    local ++k
    local pad = string(`k', "%02.0f")
    rename g`pad'* `j'_occ*_`s'
}
merge 1:1 stateicp countyicp year using `lftot', nogen

* Add any occupation column the data did not produce, and blank cells, as 0 (a
* genuine zero in the dummy+collapse output).
foreach j of local groups {
    foreach o of local occupationcodes {
        capture confirm variable `j'_occ`o'_`s'
        if _rc gen byte `j'_occ`o'_`s' = 0
    }
}
foreach v of varlist *_occ*_`s' {
    replace `v' = 0 if missing(`v')
}

save "$intmdata/IPUMS_`year'_`group'_occ_county_`s'.dta", replace
restore

}

}


*------------------------------------------------------------------------------*
* Occupation counts: European immigrants who arrived within the last 10 years
*------------------------------------------------------------------------------*

foreach year in 1900 1910 1920 {

local s = "m"

clear all
clear mata
set maxvar 120000

use if inrange(age,16,64) == 1 & sex == 1 & inrange(bpl,400,465) == 1 using "$rawlocal/IPUMS/IPUMS_fullcount_`year'.dta", clear

keep if year - yrimmig < 10

if `year' == 1900 {
keep stateicp year countyicp sex bpl nativity race occ1950 ind1950 occscore yrimmig histid
}
if `year' != 1900 {
keep stateicp year countyicp sex bpl nativity race occ1950 ind1950 labforce yrimmig histid
}

* Birthplace-country dummies, by IPUMS bpl code
* Northern Europe
gen byte denmark     = (bpl == 400)
gen byte finland     = (bpl == 401)
gen byte norway      = (bpl == 404)
gen byte sweden      = (bpl == 405)
gen byte uk          = (inrange(bpl,410,413))
gen byte ireland     = (bpl == 414)
gen byte oth_northeu = (inlist(bpl,402,403,419))
* Western Europe
gen byte belgium    = (bpl == 420)
gen byte france     = (bpl == 421)
gen byte luxemb     = (bpl == 423)
gen byte nether     = (bpl == 425)
gen byte switz      = (bpl == 426)
gen byte oth_westeu = (inlist(bpl,422,424,429))
* Southern Europe
gen byte italy       = (bpl == 434)
gen byte gr_pt_es    = (inlist(bpl,433,436,438))
gen byte oth_southeu = (inlist(bpl,430,431,432,435,437,439,440))
* Central-Eastern Europe
gen byte aus_hung     = (inlist(bpl,450,454))
gen byte czech        = (bpl == 452)
gen byte germany      = (bpl == 453)
gen byte poland       = (bpl == 455)
gen byte oth_easteu   = (inlist(bpl,451,456,457,459))
gen byte oth_centereu = (inlist(bpl,458))
* Russian Empire
gen byte russia     = (bpl == 465)
gen byte oth_russeu = (inlist(bpl,460,461,462,463))

* Labor-force dummy
if `year' != 1900 {
gen byte d_labforce = (labforce == 2) if labforce != 0								// = . if LF status is N/A (i.e., labforce == 0)
}
if `year' == 1900 {
gen byte d_labforce = (occ1950 < 980)								// labforce is missing in 1900: treat anyone with a recorded occupation as in the LF
}

* Split the OCC1950 operative residual (970) into industry-specific codes
replace occ1950 = 971 if occ1950 == 970 & inlist(ind1950,437,446,449) == 1		// textile industry
replace occ1950 = 972 if occ1950 == 970 & inlist(ind1950,406) == 1				// meat-production industry
replace occ1950 = 973 if occ1950 == 970 & inlist(ind1950,418) == 1				// beverage industry

levelsof occ1950 if occ1950 < 979, local(occupationcodes)

* Count, per county, the recent (arrived within 10 years) in-LF male immigrants in
* each occupation, by birthplace country, plus the labor-force total. Same narrow
* collapse + reshape as the main pass above.

local groups denmark finland norway sweden uk ireland oth_northeu belgium france luxemb nether switz oth_westeu italy gr_pt_es oth_southeu aus_hung czech germany poland oth_easteu oth_centereu russia oth_russeu

preserve
foreach j of local groups {
    gen byte `j'_lf_10yr_`s' = (`j' == 1 & d_labforce == 1)
}
* Carry the bare country population totals too.
gcollapse (sum) *_lf_10yr_`s' `groups', by(stateicp countyicp year)
tempfile lftot
save `lftot'
restore

preserve
keep if d_labforce == 1 & occ1950 < 979
local stubs ""
local k = 0
foreach j of local groups {
    local ++k
    local pad = string(`k', "%02.0f")
    rename `j' g`pad'
    local stubs "`stubs' g`pad'"
}
gcollapse (sum) `stubs', by(stateicp countyicp year occ1950)
reshape wide `stubs', i(stateicp countyicp year) j(occ1950)
local k = 0
foreach j of local groups {
    local ++k
    local pad = string(`k', "%02.0f")
    rename g`pad'* `j'_occ*_10yr_`s'
}
merge 1:1 stateicp countyicp year using `lftot', nogen

foreach j of local groups {
    foreach o of local occupationcodes {
        capture confirm variable `j'_occ`o'_10yr_`s'
        if _rc gen byte `j'_occ`o'_10yr_`s' = 0
    }
}
foreach v of varlist *_occ*_10yr_`s' {
    replace `v' = 0 if missing(`v')
}

save "$intmdata/IPUMS_`year'_euroimm_occ_10yr_county_`s'.dta", replace
restore

}


*------------------------------------------------------------------------------*
* Combine the per-group files into one occupation dataset per census year
*------------------------------------------------------------------------------*

foreach year in 1880 1900 1910 1920 {

use if year == `year' using "$intmdata/IPUMS_`year'_nat_all_occ_county_m.dta", clear

* Add the immigrant counts: total by country x occupation, and -- 1900 on --
* the same for immigrants who arrived within the last 10 years. The 1880
* census has no year-of-immigration, so the recent-arrival file starts in 1900.
merge 1:1 stateicp countyicp year using "$intmdata/IPUMS_`year'_euroimm_occ_county_m.dta"
drop if year != `year'
drop _merge

if `year' != 1880 {
merge 1:1 stateicp countyicp year using "$intmdata/IPUMS_`year'_euroimm_occ_10yr_county_m.dta"
drop if year != `year'
drop _merge
}

* A county present in one input but absent from another comes through the
* merge with missing counts -- those are true zeros.
foreach var of varlist *_occ* *_lf* {
	replace `var' = 0 if `var' == .
}

* The build passes above emit an occupation column only for the OCC1950 codes
* observed in a given year, so the column set differs across years. Walk the
* full (group x occupation) grid and backfill any cell the merge did not
* create, so every year's file carries the same variables. OCC1950 codes
* 971/972/973 are the industry-specific split of the operative residual (970).
*
* A regular count column the merge did not create means a genuine zero, so it
* is filled with 0. The recent-arrival (10yr) columns are the exception for
* 1880: the 1880 census never recorded year of arrival, so this script builds no 1880
* 10yr file and the whole 10yr block is absent for 1880 -- those cells are
* unavailable, not zero, and are filled with missing. (For 1900-1920 a 10yr
* column the merge did not create is still a genuine zero.)
if `year' == 1880 local fill10yr "."
if `year' != 1880 local fill10yr "0"

foreach country in all nat nat_np ///
				   denmark finland norway sweden uk ireland oth_northeu ///
				   belgium france luxemb nether switz oth_westeu ///
				   italy gr_pt_es oth_southeu ///
				   aus_hung czech germany poland oth_easteu oth_centereu ///
				   russia oth_russeu {

	capture confirm var `country'_lf_m, exact
	if c(rc) == 111 { 															// rc 111 = variable not found
	gen `country'_lf_m = 0
	}

	if inlist("`country'","all","nat","nat_np") == 0 {
	capture confirm var `country'_lf_10yr_m, exact
	if c(rc) == 111 {
	gen `country'_lf_10yr_m = `fill10yr'
	}
	}

foreach o in 0 1 2 3 4 5 6 7 8 9 10 12 13 14 15 16 17 18 19 23 24 25 26 27 28 29 ///
			 31 32 33 34 35 36 41 42 43 44 45 46 47 48 49 51 52 53 54 55 56 57 58 59 ///
			 61 62 63 67 68 69 70 71 72 73 74 75 76 77 78 79 81 82 83 84 91 92 93 94 95 96 97 98 99 ///
			 100 123 200 201 203 204 205 210 230 240 250 260 270 280 290 300 301 302 304 305 310 320 ///
			 321 322 325 335 340 341 342 350 360 365 370 380 390 400 410 420 430 450 460 470 480 490 ///
			 500 501 502 503 504 505 510 511 512 513 514 515 520 521 522 523 524 525 530 531 532 533 534 535 ///
			 540 541 542 543 544 545 550 551 552 553 554 555 560 561 562 563 564 565 570 571 572 573 574 575 ///
			 580 581 582 583 584 585 590 591 592 593 594 595 600 601 602 603 604 605 610 611 612 613 614 615 ///
			 620 621 622 623 624 625 630 631 632 633 634 635 640 641 642 643 644 645 650 660 661 662 ///
			 670 671 672 673 674 675 680 681 682 683 685 690 700 710 720 730 731 732 740 750 751 752 753 754 ///
			 760 761 762 763 764 770 771 772 773 780 781 782 783 784 785 790 810 820 830 840 910 920 930 940 950 960 970 ///
			 971 972 973 {

	capture confirm var `country'_occ`o'_m, exact
	if c(rc) == 111 {
	gen `country'_occ`o'_m = 0
	}

	if inlist("`country'","all","nat","nat_np") == 0 {
	capture confirm var `country'_occ`o'_10yr_m, exact
	if c(rc) == 111 {
	gen `country'_occ`o'_10yr_m = `fill10yr'
	}
	}

}

	order `country'_*_m, sequential last

}

order year stateicp countyicp, first

save "$intmdata/IPUMS_`year'_occ_county_m.dta", replace

}
