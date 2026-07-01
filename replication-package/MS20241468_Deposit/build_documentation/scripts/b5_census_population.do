*==============================================================================*
* b5_census_population.do
*
* Builds county-level population counts from IPUMS full-count census micro-
* data. For each census year 1880-1930 it counts people by population group
* -- everyone, all immigrants, and European immigrants -- separately by sex,
* in three measures: total, urban, and working-age (16-64).
*
* INPUT (in $rawlocal/):
*   IPUMS/IPUMS_fullcount_<year>.dta  - IPUMS full-count microdata, one file
*                                      per year (1880, 1900, 1910, 1920, 1930).
*                                      Not shipped; see the README.
*
* OUTPUTS (in $intmdata/; b16 ships these to data/public/census_aggregates/):
*   IPUMS_<year>_population_county_m.dta / _w.dta  - men / women
*   IPUMS_<year>_population_county.dta             - the two merged
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
* County population counts, 1880-1930
*------------------------------------------------------------------------------*

foreach year in 1880 1900 1910 1920 1930 {

foreach sex in 1 2 {

if `sex' == 1 {
local s = "m"
}
if `sex' == 2 {
local s = "w"
}

* The 1900 full count lacks the NHGIS county identifier (countynhg).
if inlist(`year',1880,1910,1920,1930) == 1 {
use year age bpl sex urban countynhg stateicp countyicp if sex == `sex' using "$rawlocal/IPUMS/IPUMS_fullcount_`year'.dta", clear
}
if `year' == 1900 {
use year age bpl sex urban stateicp countyicp if sex == `sex' using "$rawlocal/IPUMS/IPUMS_fullcount_`year'.dta", clear
}

* Population groups: everyone; all immigrants (born outside the U.S. -- IPUMS
* birthplace codes above 120); and European immigrants (bpl 400-465).
gen all      = 1
gen imm      = (bpl > 120)
gen euro_imm = (inrange(bpl,400,465) == 1)

* For each group, count total, urban, and working-age (16-64) population.
foreach var of varlist all imm euro_imm {
	gen `var'_totpop_`s'    = (`var' == 1)
	gen `var'_urbanpop_`s'  = (`var' == 1 & urban == 2)
	gen `var'_wkgagepop_`s' = (`var' == 1 & inrange(age,16,64) == 1)
}

* Collapse to county level. 1900 has no countynhg, so it keys on
* stateicp x countyicp only.
preserve

if inlist(`year',1880,1910,1920,1930) == 1 {
gcollapse (sum) *_totpop* *_urbanpop* *_wkgagepop*, by(countynhg stateicp countyicp year)
}
if `year' == 1900 {
gcollapse (sum) *_totpop* *_urbanpop* *_wkgagepop*, by(stateicp countyicp year)
}

order year, first
save "$intmdata/IPUMS_`year'_population_county_`s'.dta", replace

restore

}

}


*------------------------------------------------------------------------------*
* Combine the men's and women's county datasets, 1880-1930
*------------------------------------------------------------------------------*

foreach year in 1880 1900 1910 1920 1930 {

use "$intmdata/IPUMS_`year'_population_county_m.dta", clear

merge 1:1 stateicp countyicp year using "$intmdata/IPUMS_`year'_population_county_w.dta"
foreach var of varlist *_w {
replace `var' = 0 if _merge == 1 & `var' == .
}
foreach var of varlist *_m {
replace `var' = 0 if _merge == 2 & `var' == .
}
drop _merge

* Men + women, for each population group x measure.
foreach pop in totpop urbanpop wkgagepop {
foreach group in all imm euro_imm {
	gen `group'_`pop'_mw = `group'_`pop'_m + `group'_`pop'_w
}
}

save "$intmdata/IPUMS_`year'_population_county.dta", replace

}
