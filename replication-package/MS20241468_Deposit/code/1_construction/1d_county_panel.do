*==============================================================================*
* 1d_county_panel.do
*
* Assembles the border-adjusted county panel. Stacks the per-year datasets
* that 1c_boundary_adjustment harmonized to constant 1930 county boundaries,
* attaches the 1930-geography county identifiers and centroids, and saves the
* county panel (county_panel_1880-1920_county1930; one row per 1930 county per
* census year, 1880-1920) that the downstream construction steps and the analysis read.
*
* INPUTS:
*   $data/county_adjusted/county_panel_<year>_county1930.dta  - the
*       per-year boundary-adjusted panels, from 1c_boundary_adjustment
*   $rawdata/county_crosswalks/crosswalks/  - 1930 county identifiers
*       (Identifiers_1930.dta) and centroids (Counties_1930_xy.dta); the Ferrara-Testa-Zhou county
*       crosswalks, Ferrara et al. (2022), openICPSR project 150101
*
* OUTPUT (in $data/):
*   county_panel_1880-1920_county1930.dta  - the analysis county panel,
*       1880-1920, on constant 1930 county boundaries
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
cap mkdir "$data"


*------------------------------------------------------------------------------*
* Assemble the final county panel on 1930 boundaries
*------------------------------------------------------------------------------*

local baseyear 1930

* Stack the per-year panels on 1930 boundaries; 1880-1920 are the boundary-
* adjusted panels from 1c, and 1930 is the base year (no adjustment needed).
* 1930 provides the t+10 (1930) census year used in the analysis to interpolate
* 1920 union membership and to form the one-decade-ahead immigrant share; all
* outcomes are defined for 1900, 1910, and 1920.
numlist "1880(10)1930"
local allyears `r(numlist)'

clear
foreach year of local allyears {
append using "$data/county_adjusted/county_panel_`year'_county`baseyear'.dta"
}

* Attach the 1930-geography county identifiers (state/county names and codes,
* county area).
merge m:1 gisjoin_`baseyear' using "$rawdata/county_crosswalks/crosswalks/CountyToCounty/`baseyear'/Identifiers_`baseyear'.dta", keepusing(nhgisnam icpsrst icpsrcty state county statenam gisjoin2 cnty_area_`baseyear')
replace cnty_area_`baseyear' = cnty_area_`baseyear' / 1000000
label var cnty_area_`baseyear' "Area in `baseyear' (in sq km)"
drop if _merge == 2
drop if inlist(icpsrst,81,82) == 1												// drop the Alaska and Hawaii territories
drop _merge
replace state  = state / 10														// recover the state FIPS code
replace county = county / 10													// recover the county FIPS code
rename (gisjoin2 cnty_area_`baseyear' icpsrst icpsrcty state county) ///
       (countynhg_`baseyear' area_`baseyear' stateicp countyicp statefip countyfip)

* Attach the county centroids.
merge m:1 gisjoin_`baseyear' using "$rawdata/county_crosswalks/crosswalks/County-CD-centroid-lat-lon/lat_lon_coordinates_county/Counties_`baseyear'_xy.dta", keepusing(centroid*)
drop if _merge == 2
drop _merge

order year gisjoin_`baseyear', first
order countynhg_`baseyear' statefip stateicp countyicp countyfip statenam nhgisnam area_`baseyear' centroid_x centroid_y, after(gisjoin_`baseyear')
sort gisjoin_`baseyear' year

save "$data/county_panel_1880-1920_county`baseyear'.dta", replace
