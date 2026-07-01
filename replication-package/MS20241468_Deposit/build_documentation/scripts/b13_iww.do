*==============================================================================*
* b13_iww.do
*
* One-time prep script. Builds the county-level dataset of IWW locals from the
* Industrial Workers of the World locals list (IWW History Project, Civil
* Rights & Labor History Consortium; Gregory 2015).
*
* The output ships under data/public/unions/IWW_unions_county1930.csv and is an
* input to the analysis pipeline; this script documents how it was produced.
* The script is not invoked by the main pipeline driver. The source list is
* copyright-restricted and the geocoding step is manual, so a replicator cannot
* re-run the prep step end-to-end. It reads only the shipped 1930 county
* shapefile and the union-source files under $unionsrc, and writes its
* single deliverable to data/public/unions/.
*
* Workflow:
*   manual - the IWW locals list was geocoded with the ArcGIS "Geocode
*            Addresses" tool against a U.S. address locator. The result is
*            IWW_unions_geocoded.csv (the input below).
*   main   - read the geocoded list, clean it, point-in-polygon match to 1930
*            county boundaries (geoinpoly), and aggregate to county level.
*
* Input (raw, shipped):           $rawdata/USmap_1930/US_county_1930_WGS84.shp
* Input (working file, not shipped): $unionsrc/IWW_unions_geocoded.csv
* Output (shipped raw input):     $rawdata/unions/IWW_unions_county1930.csv
*==============================================================================*

clear all
set more off, perm

* $rawdata is the package raw-input folder. $unionsrc is a working directory for
* this one-time prep script; it lives inside the package folder but is not part
* of the shipped package (exclude data/_raw_local/ when building the public zip).
if "$root" == "" global root "set-this-to-the-replication-package-path"
global rawdata "$root/data/public"
global unionsrc    "$root/data/_raw_local/union_sources"
cap mkdir "$unionsrc"


*------------------------------------------------------------------------------*
* Convert the 1930 county shapefile for geoinpoly (self-contained; output
* kept under $unionsrc, not in the package intermediate folder)
*------------------------------------------------------------------------------*

shp2dta using "$rawdata/USmap_1930/US_county_1930_WGS84.shp", ///
    database("$unionsrc/US_county_1930_WGS84_dbase")              ///
    coordinates("$unionsrc/US_county_1930_WGS84_coord") replace


*------------------------------------------------------------------------------*
* Read the geocoded locals list and clean it
*------------------------------------------------------------------------------*

import delimited "$unionsrc/IWW_unions_geocoded.csv", clear

* ArcGIS prefixes the original input columns with "user_" and adds its own
* geocoding output fields (longlabel, x, y, score, type); strip the prefix.
keep user_* longlabel x y score type
order user_*, first
rename user_* *

* Drop locals geocoded outside the United States
replace state = strtrim(state)
drop if inlist(state,"Alberta","B.C.","B.C.Â ","England","New YorkÂ ") ///
      | inlist(state,"Nova Scotia","Ontario","Panama","Quebec","Saskatchewon")

* Blank out coordinates for low ArcGIS match scores (< 85) and for non-point
* geocodes (state- or county-level results)
replace x = . if inlist(type,"State or Province","County") | score < 85
replace y = . if inlist(type,"State or Province","County") | score < 85

foreach var of varlist longlabel type {
	rename `var' geocode_`var'
}

rename x longitude
rename y latitude

drop if longitude == . | latitude == .


*------------------------------------------------------------------------------*
* Point-in-polygon match to 1930 counties and aggregate to county level.
* Note: geoinpoly may assign a small number of boundary-adjacent localities to a
* neighboring county across package versions; the deposited county counts in
* data/public/unions/IWW_unions_county1930.csv are the reference values.
*------------------------------------------------------------------------------*

geoinpoly latitude longitude using "$unionsrc/US_county_1930_WGS84_coord"
merge m:1 _ID using "$unionsrc/US_county_1930_WGS84_dbase", keepusing(GISJOIN*)
drop if _merge == 2
drop _merge
drop _ID

rename (GISJOIN GISJOIN2) (gisjoin_1930 countynhg_1930)

gen IWW_locals = 1
gcollapse (count) IWW_locals, by(gisjoin_1930 countynhg_1930)
drop if gisjoin_1930 == ""

destring countynhg_1930, replace

* Final output -- this is the shipped raw input. b13_iww.do is its
* documented producer; the auto-run pipeline never regenerates it.
export delimited "$rawdata/unions/IWW_unions_county1930.csv", replace
