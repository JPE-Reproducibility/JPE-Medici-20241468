*==============================================================================*
* b1_census_base.do
*
* Builds county-level labor-market aggregates from IPUMS full-count census
* microdata, separately by census year and sex. For each county-year it counts
* working-age (16-64) people by population group and labor-market outcome, and
* records the inputs for a county-average occupational-income score.
*
* INPUT  (in $rawlocal/):
*   IPUMS/IPUMS_fullcount_<year>.dta  - IPUMS full-count census microdata, one file
*                                 per year (1880, 1900, 1910, 1920). Not
*                                 shipped; the replicator rebuilds it from the
*                                 IPUMS extract definition -- see the README.
*
* OUTPUTS (in $intmdata/; b16 ships these to data/public/census_aggregates/):
*   IPUMS_<year>_county_m.dta / _w.dta  - county aggregates, men / women
*   IPUMS_<year>_county.dta             - the two merged
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
* Import individual-level Census data and collapse to county level
*------------------------------------------------------------------------------*

foreach year in 1880 1900 1910 1920 {

foreach sex in 1 2 {

if `sex' == 1 {
local s = "m"
}
if `sex' == 2 {
local s = "w"
}

clear all
use if inrange(age,16,64) == 1 & sex == `sex' using "$rawlocal/IPUMS/IPUMS_fullcount_`year'.dta", clear

* Population groups. In IPUMS, birthplace codes (bpl) 1-120 are U.S. states /
* territories and 400-465 are European countries; nativity == 1 flags a person
* of native parentage (both parents U.S.-born).
gen all      = 1
gen nat      = (inrange(bpl,1,120) == 1)
gen nat_np   = (inrange(bpl,1,120) == 1 & nativity == 1)
gen euro_imm = (inrange(bpl,400,465) == 1)

* Labor-force dummy
if `year' != 1900 {
gen d_labforce = (labforce == 2) if labforce != 0								// = . if LF status is N/A (i.e., labforce == 0)
}
if `year' == 1900 {
gen d_labforce = (occ1950 < 980)												// labforce is missing in 1900: treat anyone with a recorded occupation as in the LF
}
label var d_labforce "= 1 if in Labor Force"

* Occupational income score
gen occincomescore = occscore if occscore != 00 & d_labforce == 1				// = . if occscore is N/A (i.e., occscore == 00)
label var occincomescore "Income Score"

* Occupation groups, by OCC1950 code
gen craft   = (occ1950 >= 500 & occ1950 <= 594)
gen farmer  = (occ1950 >= 100 & occ1950 <= 123)
gen farmlab = (occ1950 >= 810 & occ1950 <= 840)

* In the mining industry (IND1950 206-239), among the labor force
gen d_mining = (inrange(ind1950,206,239)) if d_labforce == 1

* Labor-market outcome counts, by population group. occsc_n and occsc_d are
* defined identically; the collapse below sums the first and counts the
* second, so occsc_n / occsc_d recovers the county-mean income score.
foreach i in all nat nat_np euro_imm {

	gen `i'_lf_tot_`s'     = (`i' == 1 & d_labforce == 1)
	gen `i'_lf_mining_`s'  = (`i' == 1 & d_labforce == 1 & d_mining == 1)
	gen `i'_lf_craft_`s'   = (`i' == 1 & craft == 1 & d_labforce == 1)
	gen `i'_lf_farmer_`s'  = (`i' == 1 & farmer == 1 & d_labforce == 1)
	gen `i'_lf_farmlab_`s' = (`i' == 1 & farmlab == 1 & d_labforce == 1)

	gen `i'_occsc_n_`s' = occincomescore if `i' == 1 & d_labforce == 1
	gen `i'_occsc_d_`s' = occincomescore if `i' == 1 & d_labforce == 1

}

* Collapse to county level. The 1900 full count lacks the NHGIS county
* identifier (countynhg), so 1900 is collapsed on stateicp x countyicp only.
preserve

if inlist(year,1880,1910,1920) == 1 {
gcollapse (sum) *_lf* *_n_`s' (count) *_d_`s'  ///
			  (firstnm) statefip, by(countynhg stateicp countyicp year)
}

if year == 1900 {
gcollapse (sum) *_lf* *_n_`s' (count) *_d_`s'  ///
			  (firstnm) statefip, by(stateicp countyicp year)
}

save "$intmdata/IPUMS_`year'_county_`s'.dta", replace

restore

}
}


*------------------------------------------------------------------------------*
* Combine the men's and women's county datasets
*------------------------------------------------------------------------------*

foreach year in 1880 1900 1910 1920 {

use "$intmdata/IPUMS_`year'_county_m.dta", clear

merge 1:1 stateicp countyicp using "$intmdata/IPUMS_`year'_county_w.dta"
foreach var of varlist *_w {
replace `var' = 0 if _merge == 1 & `var' == .
}
foreach var of varlist *_m {
replace `var' = 0 if _merge == 2 & `var' == .
}
drop _merge

save "$intmdata/IPUMS_`year'_county.dta", replace

}
