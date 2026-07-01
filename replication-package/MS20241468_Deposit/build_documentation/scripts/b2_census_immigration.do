*==============================================================================*
* b2_census_immigration.do
*
* Builds county-level counts of European immigrants by birthplace country,
* from IPUMS full-count census microdata, separately by census year and sex.
* For each county-year it counts immigrants from each European country -- in
* total, and (1900 on) among those who arrived within the last 10 years, both
* all-ages and working-age (16-64).
*
* INPUT  (in $rawlocal/):
*   IPUMS/IPUMS_fullcount_<year>.dta  - IPUMS full-count census microdata, one
*                                       file per year (1880, 1900, 1910, 1920,
*                                       1930). Not shipped; see the README.
*
* OUTPUTS (in $intmdata/; b16 ships these to data/public/census_aggregates/):
*   IPUMS_<year>_euroimm_county_m.dta / _w.dta  - county counts, men / women
*   IPUMS_<year>_euroimm_county.dta             - the two merged
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
* Count European immigrants by birthplace country and collapse to county level
*------------------------------------------------------------------------------*

foreach year in 1880 1900 1910 1920 1930 {

foreach sex in 1 2 {

if `sex' == 1 {
local s = "m"
}
if `sex' == 2 {
local s = "w"
}

* European immigrants only (IPUMS birthplace codes 400-465)
use if inrange(bpl,400,465) & sex == `sex' using "$rawlocal/IPUMS/IPUMS_fullcount_`year'.dta", clear

* The 1880 census has no year-of-immigration (yrimmig), so 1880 keeps fewer
* variables and skips the recent-arrival counts below.
if year != 1880 {
keep stateicp year countyicp sex age bpl yrimmig lit speakeng histid
}
if year == 1880 {
keep stateicp year countyicp sex age bpl histid
}

* Birthplace-country dummies, by IPUMS bpl code
** Northern Europe
gen denmark_`s'     = (bpl == 400)
gen finland_`s'     = (bpl == 401)
gen norway_`s'      = (bpl == 404)
gen sweden_`s'      = (bpl == 405)
gen uk_`s'          = (inrange(bpl,410,413))
gen ireland_`s'     = (bpl == 414)
gen oth_northeu_`s' = (inlist(bpl,402,403,419))

** Western Europe
gen belgium_`s'    = (bpl == 420)
gen france_`s'     = (bpl == 421)
gen luxemb_`s'     = (bpl == 423)
gen nether_`s'     = (bpl == 425)
gen switz_`s'      = (bpl == 426)
gen oth_westeu_`s' = (inlist(bpl,422,424,429))

** Southern Europe
gen italy_`s'       = (bpl == 434)
gen gr_pt_es_`s'    = (inlist(bpl,433,436,438))
gen oth_southeu_`s' = (inlist(bpl,430,431,432,435,437,439,440))

** Central-Eastern Europe
gen aus_hung_`s'     = (inlist(bpl,450,454))
gen czech_`s'        = (bpl == 452)
gen germany_`s'      = (bpl == 453)
gen poland_`s'       = (bpl == 455)
gen oth_easteu_`s'   = (inlist(bpl,451,456,457,459))
gen oth_centereu_`s' = (inlist(bpl,458))

** Russian Empire
gen russia_`s'     = (bpl == 465)
gen oth_russeu_`s' = (inlist(bpl,460,461,462,463))

* Recent-arrival counts -- arrived within the last 10 years, all ages and
* working-age (16-64). Built for 1900 on only (1880 has no yrimmig).
if year != 1880 {
foreach country in denmark finland norway sweden uk ireland oth_northeu ///
				   belgium france luxemb nether switz oth_westeu ///
				   italy gr_pt_es oth_southeu ///
				   aus_hung czech germany poland oth_easteu oth_centereu ///
				   russia oth_russeu {
	gen `country'_10yr_`s'        = (`country'_`s' == 1 & (year - yrimmig) < 10)
	gen `country'_wkgage_10yr_`s' = (`country'_`s' == 1 & (year - yrimmig < 10) & inrange(age,16,64) == 1)
}
}

* Collapse to county level
preserve

gcollapse (sum) denmark* finland* norway* sweden* uk* ireland* oth_northeu* ///
				belgium* france* luxemb* nether* switz* oth_westeu* ///
				italy* gr_pt_es* oth_southeu* ///
				aus_hung* czech* germany* poland* oth_easteu* oth_centereu* ///
				russia* oth_russeu*, ///
				by(stateicp countyicp year)

save "$intmdata/IPUMS_`year'_euroimm_county_`s'.dta", replace

restore

}
}


*------------------------------------------------------------------------------*
* Combine the men's and women's county datasets
*------------------------------------------------------------------------------*

foreach year in 1880 1900 1910 1920 1930 {

use "$intmdata/IPUMS_`year'_euroimm_county_m.dta", clear

merge 1:1 stateicp countyicp year using "$intmdata/IPUMS_`year'_euroimm_county_w.dta"
foreach var of varlist *_w {
replace `var' = 0 if _merge == 1 & `var' == .
}
foreach var of varlist *_m {
replace `var' = 0 if _merge == 2 & `var' == .
}
drop _merge

save "$intmdata/IPUMS_`year'_euroimm_county.dta", replace

}
