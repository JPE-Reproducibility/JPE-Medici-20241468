*==============================================================================*
* 1c_boundary_adjustment.do
*
* Harmonizes counties to constant 1930 boundaries. County definitions change
* over time -- counties split, merge, and shift borders -- so each census
* year's county dataset is re-aggregated onto 1930 county boundaries using the
* area-weighted county-border crosswalks of Ferrara et al. (2022). For each
* non-1930 year, every county-level variable is split across the 1930 counties
* a historical county overlaps (weighted by area share) and summed within each
* 1930 county.
*
* INPUTS (in $rawdata/county_crosswalks/crosswalks/CountyToCounty/):
*   <y>/Identifiers_<y>.dta       - county identifiers, year <y>
*   1930/Crosswalk_<y>_1930.dta  - area weights, year <y> -> 1930
*   County-border crosswalks of Ferrara et al. (2022), openICPSR project 150101.
* INPUT (in $data/county_unadjusted/):
*   county_panel_<year>_unadjusted.dta  - per-year county data, from 1b
*
* OUTPUTS (in $data/county_adjusted/):
*   county_panel_<year>_county1930.dta  - per-year, on 1930 boundaries;
*                                         read by 1d
*
* Run via 00_master.do, or standalone.
*==============================================================================*

clear all
set more off, perm

* Project root. 00_master.do sets \$root for the full run; the line below also
* lets this file run on its own -- set it to the local path of the package.
if "$root" == "" global root "set-this-to-the-replication-package-path"
global rawdata  "$root/data/public"
global intmdata "$root/data/intermediate"
global data     "$root/data/clean"
cap mkdir "$intmdata"
cap mkdir "$intmdata/county_identifiers"
cap mkdir "$data"
cap mkdir "$data/county_adjusted"


*------------------------------------------------------------------------------*
* Extract county identifiers from the Ferrara et al. (2022) crosswalks
*------------------------------------------------------------------------------*

* For each census year, pull the county identifiers (ICPSR and NHGIS codes)
* from the county crosswalk files into a slim lookup used in the adjustment below.
forvalues y = 1880(10)1920 {
use "$rawdata/county_crosswalks/crosswalks/CountyToCounty/`y'/Identifiers_`y'.dta", clear
rename decade year
keep year nhgisnam icpsrst icpsrcty icpsrnam gisjoin gisjoin2 shape_area shape_len cnty_area_`y' gisjoin_`y'
drop if icpsrst == .
save "$intmdata/county_identifiers/countyid_`y'.dta", replace
}


*------------------------------------------------------------------------------*
* Re-aggregate each census year's county data onto 1930 county boundaries
*------------------------------------------------------------------------------*

local baseyear 1930

numlist "1880(10)1930"
local allyears `r(numlist)'
local years_notbase: list allyears - baseyear

foreach year of local years_notbase {
	
* Start from the county crosswalk: the area weights mapping each year-<year>
* county (gisjoin_<year>) onto the 1930 counties it overlaps.
use "$rawdata/county_crosswalks/crosswalks/CountyToCounty/`baseyear'/Crosswalk_`year'_`baseyear'.dta", clear
keep gisjoin_`year' gisjoin_`baseyear' m*_weight
gen year = `year'

* Attach the county data. Counties match on the NHGIS id (countynhg) for most
* years; 1890 needs ICPSR ids plus manual corrections for DC and Oklahoma.
if `year' != 1890 {
merge m:1 gisjoin_`year' using "$intmdata/county_identifiers/countyid_`year'.dta", keepusing(icpsrst icpsrcty gisjoin2)
replace gisjoin2 = real(substr(gisjoin_`year',2,7)) if _merge == 1 & gisjoin_`year' != ""
drop _merge

rename (icpsrst icpsrcty gisjoin2) (stateicp countyicp countynhg)
merge m:1 countynhg year using "$data/county_unadjusted/county_panel_`year'_unadjusted.dta"
drop if _merge == 2
drop _merge
}

if `year' == 1890 {
merge m:1 gisjoin_`year' using "$intmdata/county_identifiers/countyid_`year'.dta", keepusing(icpsrst icpsrcty gisjoin2)
replace gisjoin2 = real(substr(gisjoin_`year',2,7)) if _merge == 1 & gisjoin_`year' != ""
replace icpsrst  = 98 if gisjoin2 == 1100010									// DC
replace icpsrcty = 10 if gisjoin2 == 1100010
replace icpsrst  = 53 if substr(gisjoin_`year',1,4) == "G405" & _merge == 1		// Oklahoma
replace icpsrcty = real(substr(gisjoin_`year',-4,4)) - 5 if substr(gisjoin_`year',1,4) == "G405" & _merge == 1
drop _merge

rename (icpsrst icpsrcty gisjoin2) (stateicp countyicp countynhg)
merge m:1 stateicp countyicp year using "$data/county_unadjusted/county_panel_`year'_unadjusted.dta"
drop if _merge == 2
drop _merge
}

* Oklahoma's pre-statehood county identifiers do not match the crosswalk for
* 1880-1900; pull those counties in using the 1910 gisjoin identifiers instead.
if inlist(`year',1880,1890,1900) == 1 {

drop if stateicp == 53
preserve
use "$rawdata/county_crosswalks/crosswalks/CountyToCounty/`baseyear'/Crosswalk_1910_`baseyear'.dta", clear
keep gisjoin_1910 gisjoin_`baseyear' m*_weight
gen year = `year'

merge m:1 gisjoin_1910 using "$intmdata/county_identifiers/countyid_1910.dta", keepusing(icpsrst icpsrcty gisjoin2)
keep if icpsrst == 53
drop _merge

rename (icpsrst icpsrcty gisjoin2) (stateicp countyicp countynhg)
merge m:1 stateicp countyicp year using "$data/county_unadjusted/county_panel_`year'_unadjusted.dta"
keep if _merge == 3
drop _merge
rename gisjoin_1910 gisjoin_`year'

tempfile statestoadd_`year'
save `statestoadd_`year'', replace
restore

append using `statestoadd_`year''

}

* Area-weighted re-aggregation: each county-level variable is multiplied by its
* area-share weight and summed (gegen total(), missing) within each 1930 county,
* giving one row per 1930 county-year; a 1930 county-year with no non-missing
* contributor for a variable is left missing rather than recorded as a zero. The
* variables are processed in column chunks (the panel is wide) so the
* re-aggregation stays within memory; the chunk results are then merged on the
* 1930 county-year key.
ds gisjoin* countynhg stateicp countyicp year *_weight, not
local datavars `r(varlist)'

tempfile base
qui save `base'

local chunksize 6000
local nc 0
local c  0
local chunkvars ""
local datavars `datavars' _flush_			// trailing sentinel flushes the last chunk

foreach var of local datavars {
	if "`var'" != "_flush_" {
		local chunkvars `chunkvars' `var'
		local ++nc
	}
	if (`nc' >= `chunksize') | ("`var'" == "_flush_" & `nc' > 0) {
		local ++c

		* load this chunk's columns plus keys + weight, area-weight them, and sum
		* within each 1930 county; total(),missing leaves all-missing cells missing
		use gisjoin_`baseyear' year m1_weight `chunkvars' using `base', clear
		foreach v of local chunkvars {
			replace `v' = `v' * m1_weight
			rename `v' `v'_o
			bysort gisjoin_`baseyear' year: gegen `v' = total(`v'_o), missing
			drop `v'_o
		}
		gegen tag = tag(gisjoin_`baseyear' year)
		keep if tag == 1
		keep gisjoin_`baseyear' year `chunkvars'

		tempfile chunk`c'
		qui save `chunk`c''

		local chunkvars ""
		local nc 0
	}
}

* merge the chunk results into one row per 1930 county-year
use `chunk1', clear
forvalues i = 2/`c' {
	merge 1:1 gisjoin_`baseyear' year using `chunk`i'', nogen
}

drop if all_totpop_mw == .

order year, first

save "$data/county_adjusted/county_panel_`year'_county`baseyear'.dta", replace

}


*------------------------------------------------------------------------------*
* 1930 (the base year): the county data is already on 1930 county boundaries, so
* there is no crosswalk and no area-weighted re-aggregation. Attach the string
* gisjoin_1930 identifier the adjusted panel is keyed on and save in the same
* structure as the adjusted years.
*------------------------------------------------------------------------------*

use "$data/county_unadjusted/county_panel_`baseyear'_unadjusted.dta", clear

* countynhg is the numeric NHGIS id (= gisjoin2); map it to the string gisjoin_1930.
rename countynhg gisjoin2
merge m:1 gisjoin2 using "$rawdata/county_crosswalks/crosswalks/CountyToCounty/`baseyear'/Identifiers_`baseyear'.dta", keepusing(gisjoin_`baseyear')
drop if _merge == 2
drop _merge
drop if gisjoin_`baseyear' == ""

drop gisjoin2 stateicp countyicp
drop if all_totpop_mw == .

order year gisjoin_`baseyear', first

save "$data/county_adjusted/county_panel_`baseyear'_county`baseyear'.dta", replace
