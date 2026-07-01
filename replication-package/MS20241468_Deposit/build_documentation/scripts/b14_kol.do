*==============================================================================*
* b14_kol.do
*
* One-time prep script. Builds the county-level dataset of Knights of Labor
* (KoL) locals from ICPSR Study 29, "Knights of Labor Assemblies, 1879-1889"
* (Garlock).
*
* The output ships under data/public/unions/KoL_unions_county1930.csv and is an
* input to the analysis pipeline; this script documents how it was produced.
* The script is not invoked by the main pipeline driver. The ICPSR 29 microdata
* is third-party and the geocoding step is manual, so a replicator cannot
* re-run the prep step end-to-end. It reads only the shipped 1930 county
* shapefile and the union-source files under $unionsrc, and writes its
* single deliverable to data/public/unions/.
*
* Workflow:
*   part 1 - read and clean ICPSR 29, build a list of KoL-local locations, and
*            export it for geocoding.
*   manual - geocode the location list with the ArcGIS "Geocode Addresses" tool
*            against a U.S. address locator. The result -- one row per location,
*            each with a match score -- is KoL_unions_geocoded.csv (input to
*            part 2; low-score matches are filtered in part 2).
*   part 2 - read the geocoded list, point-in-polygon match to 1930 county
*            boundaries (geoinpoly), and aggregate to county level.
*
* Input (raw, shipped):              $rawdata/USmap_1930/US_county_1930_WGS84.shp
* Input (working file, not shipped): $rawlocal/ICPSR_00029/DS0001/00029-0001-Data.txt
* Input (working file, not shipped): $unionsrc/KoL_unions_geocoded.csv
* Output (shipped raw input):        $rawdata/unions/KoL_unions_county1930.csv
*==============================================================================*

clear all
set more off, perm

* $rawdata is the package raw-input folder. $unionsrc is a working directory for
* this one-time prep script; it lives inside the package folder but is not part
* of the shipped package (exclude data/_raw_local/ when building the public zip).
if "$root" == "" global root "set-this-to-the-replication-package-path"
global rawdata "$root/data/public"
global rawlocal "$root/data/_raw_local"   // unshippable raw (IPUMS micro, ICPSR); excluded from deposit zip
global unionsrc    "$root/data/_raw_local/union_sources"
cap mkdir "$unionsrc"


*------------------------------------------------------------------------------*
* Part 1 - read ICPSR 29 and build the location list to geocode
*------------------------------------------------------------------------------*

import delimited "$rawlocal/ICPSR_00029/DS0001/00029-0001-Data.txt", clear

* Create variables (fixed-width fields)
gen V1 = substr(v1,1,5)
gen V2 = substr(v1,6,2)
gen V3 = substr(v1,8,20)
gen V4 = substr(v1,28,2)
gen V5 = substr(v1,30,3)
gen V6 = substr(v1,33,1)
gen V7 = substr(v1,34,3)
gen V8 = substr(v1,37,1)
gen V9 = substr(v1,38,3)
gen V10 = substr(v1,41,1)
gen V11 = substr(v1,42,2)
gen V12 = substr(v1,44,2)
gen V13 = substr(v1,46,2)
gen V14 = substr(v1,48,4)
gen V15 = substr(v1,52,4)
gen V16 = substr(v1,56,4)
gen V17 = substr(v1,60,4)
gen V18 = substr(v1,64,4)
gen V19 = substr(v1,68,4)
gen V20 = substr(v1,72,4)
gen V21 = substr(v1,76,4)
gen V22 = substr(v1,80,2)
gen V23 = substr(v1,82,2)
gen V24 = substr(v1,84,1)
gen V25 = substr(v1,85,4)
gen V26 = substr(v1,89,4)
gen V27 = substr(v1,93,4)
drop v1

* Recode ICPSR missing-value codes (9-fills) to blank
replace V1  = "" if V1  == "99999"
replace V2  = "" if V2  == "99"
replace V4  = "" if V4  == "99"
replace V5  = "" if V5  == "0"
replace V7  = "" if V7  == "999"
replace V9  = "" if V9  == "999"
replace V11 = "" if V11 == "99"
replace V12 = "" if V12 == "99"
replace V13 = "" if V13 == "99"
replace V14 = "" if V14 == "9999"
replace V15 = "" if V15 == "9999"
replace V16 = "" if V16 == "9999"
replace V17 = "" if V17 == "9999"
replace V18 = "" if V18 == "9999"
replace V19 = "" if V19 == "9999"
replace V20 = "" if V20 == "9999"
replace V21 = "" if V21 == "9999"
replace V22 = "" if V22 == "99"
replace V23 = "" if V23 == "99"
replace V24 = "" if V24 == "0"
replace V25 = "" if V25 == "9999"
replace V26 = "" if V26 == "9999"
replace V27 = "" if V27 == "9999"

* Label variables
label var V1 "Local assembly number"
label var V2 "Duplicate local assembly number indicator"
label var V3 "Name of location"
label var V4 "State"
label var V5 "County"
label var V6 "Date created criterion"
label var V7 "Date created"
label var V8 "Date terminated criterion"
label var V9 "Date terminated"
label var V10 "Occupational category criterion"
label var V11 "Occupational category (general)"
label var V12 "Occupational category (specific)"
label var V13 "Race, sex, ethnicity"
label var V14 "Membership 1879"
label var V15 "Membership 1880"
label var V16 "Membership 1881"
label var V17 "Membership 1882"
label var V18 "Membership 1883"
label var V19 "Membership 1884"
label var V20 "Membership 1885"
label var V21 "Membership 1886"
label var V22 "Population 1880"
label var V23 "Population 1890"
label var V24 "Additional data"
label var V25 "Membership 1887"
label var V26 "Membership 1888"
label var V27 "Membership 1889"

* Destring all numeric fields (V3, the location name, stays a string)
foreach var of varlist V1 V2 V4-V27 {
	destring `var', replace
}

* V7 (year created) and V9 (year terminated) carry the year as 2 digits;
* expand to a 4-digit year -- 00-20 -> 1900-1920, 60-99 -> 1860-1899.
foreach var of varlist V7 V9 {
	replace `var' = `var' + 1900 if inrange(`var',0,20)
	replace `var' = `var' + 1800 if inrange(`var',60,99)
}

* Drop non-U.S. assemblies (V4 50-63) and locals with no county (V5 == 0)
drop if inrange(V4,50,63) == 1
drop if V5 == 0

keep V1 V3 V4 V5 V7 V9

gen 	statecode = ""
replace statecode = "AL" if V4 == 1
replace statecode = "AZ" if V4 == 2
replace statecode = "AR" if V4 == 3
replace statecode = "CA" if V4 == 4
replace statecode = "CO" if V4 == 5
replace statecode = "CT" if V4 == 6
replace statecode = "DE" if V4 == 7
replace statecode = "DC" if V4 == 8
replace statecode = "FL" if V4 == 9
replace statecode = "GA" if V4 == 10
replace statecode = "ID" if V4 == 11
replace statecode = "IL" if V4 == 12
replace statecode = "IN" if V4 == 13
replace statecode = "IA" if V4 == 14
replace statecode = "KS" if V4 == 15
replace statecode = "KY" if V4 == 16
replace statecode = "LA" if V4 == 17
replace statecode = "ME" if V4 == 18
replace statecode = "MD" if V4 == 19
replace statecode = "MA" if V4 == 20
replace statecode = "MI" if V4 == 21
replace statecode = "MN" if V4 == 22
replace statecode = "MS" if V4 == 23
replace statecode = "MO" if V4 == 24
replace statecode = "MT" if V4 == 25
replace statecode = "NE" if V4 == 26
replace statecode = "NV" if V4 == 27
replace statecode = "NH" if V4 == 28
replace statecode = "NJ" if V4 == 29
replace statecode = "NM" if V4 == 30
replace statecode = "NY" if V4 == 31
replace statecode = "NC" if V4 == 32
replace statecode = "ND" if V4 == 33
replace statecode = "OH" if V4 == 34
replace statecode = "OK" if V4 == 35
replace statecode = "OR" if V4 == 36
replace statecode = "PA" if V4 == 37
replace statecode = "RI" if V4 == 38
replace statecode = "SC" if V4 == 39
replace statecode = "SD" if V4 == 40
replace statecode = "TN" if V4 == 41
replace statecode = "TX" if V4 == 42
replace statecode = "UT" if V4 == 43
replace statecode = "VT" if V4 == 44
replace statecode = "VA" if V4 == 45
replace statecode = "WA" if V4 == 46
replace statecode = "WV" if V4 == 47
replace statecode = "WI" if V4 == 48
replace statecode = "WY" if V4 == 49

* Expand to a local x {1880, 1890} panel and keep each local only in the
* census years when it was active -- created by then (V7) and not yet
* terminated (V9).
expand 2, gen(expanded)
gen year = .
replace year = 1880 if expanded == 0
replace year = 1890 if expanded == 1
drop if year == 1880 & (V9 <= 1880 | V7 > 1880)
drop if year == 1890 & (V9 <= 1890 | V7 > 1890)

* V1 (the local assembly number) becomes the unit to count below. collapse
* (count) ignores missings, so locals with no assembly number are set to a
* sentinel (99999) to ensure every local is counted.
rename (V1 V5 V3) (nr_locals_kol county city)
replace nr_locals_kol = 99999 if nr_locals_kol == .

gcollapse (count) nr_locals_kol, by(year city statecode)

* Export the location list for geocoding
export delimited "$unionsrc/KoL_unions_togeocode.csv", replace


*------------------------------------------------------------------------------*
* [MANUAL STEP] Geocode KoL_unions_togeocode.csv with the ArcGIS "Geocode
* Addresses" tool against a U.S. address locator. The result -- one geocoded
* row per location, each carrying an ArcGIS match score -- is
* $unionsrc/KoL_unions_geocoded.csv (input to Part 2).
*------------------------------------------------------------------------------*


*------------------------------------------------------------------------------*
* Convert the 1930 county shapefile for geoinpoly (self-contained; output
* kept under $unionsrc, not in the package intermediate folder)
*------------------------------------------------------------------------------*

shp2dta using "$rawdata/USmap_1930/US_county_1930_WGS84.shp", ///
    database("$unionsrc/US_county_1930_WGS84_dbase")              ///
    coordinates("$unionsrc/US_county_1930_WGS84_coord") replace


*------------------------------------------------------------------------------*
* Part 2 - read the geocoded list and aggregate to 1930 counties
*------------------------------------------------------------------------------*

import delimited "$unionsrc/KoL_unions_geocoded.csv", clear

* ArcGIS prefixes the original input columns with "user_" and adds its own
* geocoding output fields; strip the prefix.
keep score shortlabel addr_type type placename regionabbr x y user_*

order user_*, first
rename user_* *

* Drop poorly geocoded locations: a low ArcGIS match score (< 85) combined
* with a geocoded region that disagrees with the stated state.
drop if score < 85 & state != regionabbr
drop score shortlabel addr_type type regionabbr

foreach var of varlist placename x y {
	rename `var' geocode_`var'
}
rename geocode_x geocode_longitude
rename geocode_y geocode_latitude
order(geocode_*), after(statecode)

geoinpoly geocode_latitude geocode_longitude using "$unionsrc/US_county_1930_WGS84_coord"
merge m:1 _ID using "$unionsrc/US_county_1930_WGS84_dbase", keepusing(GISJOIN*)
drop if _merge == 2
drop _merge
drop _ID

rename (GISJOIN GISJOIN2) (gisjoin_1930 countynhg_1930)
foreach var of varlist nr_locals_* {
	bysort year gisjoin_1930 countynhg_1930: gegen `var'_tot = total(`var'), missing
	rename `var' `var'_dr
}
gegen tag = tag(year gisjoin_1930 countynhg_1930)
keep if tag == 1
drop *_dr

rename (nr_locals_kol_tot) (locals_kol)

drop if gisjoin_1930 == ""
keep gisjoin_1930 countynhg_1930 year locals_kol

destring countynhg_1930, replace

* Final output -- this is the shipped raw input. b14_kol.do is its
* documented producer; the auto-run pipeline never regenerates it.
export delimited "$rawdata/unions/KoL_unions_county1930.csv", replace
