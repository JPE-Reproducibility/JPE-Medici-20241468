*==============================================================================*
* 1a_reference_inputs.do
*
* Imports small reference datasets used across the analysis: the 1930 county
* shapefile, IPUMS OCC1950 occupation labels, 1930 State Economic Area (SEA)
* identifiers, the StateFIP-StateICP crosswalk, 1900 NHGIS county identifiers,
* annual U.S. immigration flows, and historical union membership.
*
* INPUTS  (in $rawdata/):
*   USmap_1930/US_county_1930_WGS84.shp        - 1930 county boundaries (NHGIS)
*   IPUMS/xwalk_occ1950_occnames.csv           - IPUMS OCC1950 occupation labels
*   IPUMS/xwalk_1930_countynhg_SEA.csv         - IPUMS county-to-SEA crosswalk
*   MPI_immflows/flows_imm_1820-2021.csv       - Migration Policy Institute
*   Freeman_1998/uniondensity_freeman1998.csv  - Freeman (1998), NBER WP
*   crosswalks/xwalk_statefip_stateicp.csv     - StateFIP-to-StateICP crosswalk
*   crosswalks/xwalk_1900_countynhg_countyicp.csv  - 1900 county NHGIS-id lookup
*   foreignborn_byorigin/ustotals_byorigin_1850-1920.csv  - foreign-born by region
*
* OUTPUTS:
*   $intmdata/US_county_1930_WGS84_dbase.dta
*   $intmdata/US_county_1930_WGS84_coord.dta
*   $intmdata/US_county_1930_WGS84_dbase_spmap.dta
*   $intmdata/xwalk_occ1950_occnames.dta
*   $intmdata/xwalk_1930_countynhg_SEA.dta
*   $intmdata/xwalk_statefip_stateicp.dta
*   $intmdata/xwalk_1900_countynhg_countyicp.dta
*   $data/flows_imm_1820-2021.dta
*   $data/uniondensity_freeman1998.dta
*   $intmdata/ustotals_byorigin_1850-1920.dta
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
* County shapefile - 1930 boundaries (WGS84)
*
* shp2dta splits the shapefile into the database + coordinate .dta pair that
* geoinpoly and spmap consume downstream. GISJOIN2 (the NHGIS GISJOIN string
* with its "G" prefix removed) is the numeric county ID, already present in
* the 1930 NHGIS file; countynhg_1930 is its numeric form, the key used to
* merge county data downstream.
*------------------------------------------------------------------------------*

clear all
shp2dta using "$rawdata/USmap_1930/US_county_1930_WGS84.shp", database("$intmdata/US_county_1930_WGS84_dbase") coordinates("$intmdata/US_county_1930_WGS84_coord") replace

use "$intmdata/US_county_1930_WGS84_dbase", clear
gen countynhg_1930 = real(GISJOIN2)
save "$intmdata/US_county_1930_WGS84_dbase_spmap.dta", replace


*------------------------------------------------------------------------------*
* IPUMS OCC1950 occupation names
*------------------------------------------------------------------------------*

import delimited using "$rawdata/IPUMS/xwalk_occ1950_occnames.csv", clear
save "$intmdata/xwalk_occ1950_occnames.dta", replace


*------------------------------------------------------------------------------*
* 1930 State Economic Area (SEA) identifiers
*------------------------------------------------------------------------------*

import delimited using "$rawdata/IPUMS/xwalk_1930_countynhg_SEA.csv", clear
rename countynhg countynhg_1930
save "$intmdata/xwalk_1930_countynhg_SEA.dta", replace


*------------------------------------------------------------------------------*
* StateFIP <-> StateICP crosswalk
*------------------------------------------------------------------------------*

import delimited "$rawdata/crosswalks/xwalk_statefip_stateicp.csv", clear
save "$intmdata/xwalk_statefip_stateicp.dta", replace


*------------------------------------------------------------------------------*
* 1900 NHGIS county identifiers
*
* The 1900 full count carries no NHGIS county identifier (countynhg). This
* county lookup -- one row per county, keyed on year/stateicp/countyicp -- was
* built offline from the IPUMS 1900 5% sample (which does carry countynhg) and
* is shipped ready-made; 1b_merge_preadjust merges it onto the 1900 panel.
*------------------------------------------------------------------------------*

import delimited "$rawdata/crosswalks/xwalk_1900_countynhg_countyicp.csv", clear
save "$intmdata/xwalk_1900_countynhg_countyicp.dta", replace


*------------------------------------------------------------------------------*
* Annual U.S. immigration flows, 1820-2021 (Migration Policy Institute)
*------------------------------------------------------------------------------*

import delimited "$rawdata/MPI_immflows/flows_imm_1820-2021.csv", clear
save "$data/flows_imm_1820-2021.dta", replace


*------------------------------------------------------------------------------*
* Union membership over time (Freeman 1998)
*------------------------------------------------------------------------------*

import delimited "$rawdata/Freeman_1998/uniondensity_freeman1998.csv", clear
save "$data/uniondensity_freeman1998.dta", replace


*------------------------------------------------------------------------------*
* US foreign-born population by region of origin, 1850-1920
*
* Eight census-year rows of full-population counts (see
* data/public/foreignborn_byorigin/README.md for column definitions and source).
* The CSV stores three regions; the fourth, "other", is the residual so the
* origin regions add up to foreignborn by construction rather than by hand.
* Feeds 2b_figures_descriptives.do (Figure A.1, immigrmix_1850-1920.pdf).
*------------------------------------------------------------------------------*

import delimited "$rawdata/foreignborn_byorigin/ustotals_byorigin_1850-1920.csv", clear

assert _N == 8
assert !missing(year, totpop, foreignborn, canada_australia, northwest_europe, southeast_europe)
* origin regions cannot exceed the foreign-born total (guards the residual below)
assert canada_australia + northwest_europe + southeast_europe <= foreignborn

gen double other = foreignborn - canada_australia - northwest_europe - southeast_europe

label var year             "census year"
label var totpop           "total US population"
label var foreignborn      "total foreign-born population"
label var canada_australia "foreign-born, Canada + Australia"
label var northwest_europe "foreign-born, Northwest Europe"
label var southeast_europe "foreign-born, Southeast Europe"
label var other            "foreign-born, other origins (residual)"

order year totpop foreignborn canada_australia northwest_europe southeast_europe other
sort year
save "$intmdata/ustotals_byorigin_1850-1920.dta", replace


*==============================================================================*
* IWW and KoL county inputs -> .dta intermediates
*
* Converts the shipped county-year IWW and KoL union CSVs into the .dta
* intermediates used downstream when the analysis dataset is assembled.
*   IN  ($rawdata/unions/): IWW_unions_county1930.csv, KoL_unions_county1930.csv
*   OUT ($intmdata/):       IWW_unions_1906-1917_county1930.dta,
*                           KOL_locals_1880-1890_county1930.dta
*==============================================================================*

clear all
set more off, perm

if "$root" == "" global root "set-this-to-the-replication-package-path"
global rawdata  "$root/data/public"
global intmdata "$root/data/intermediate"
cap mkdir "$intmdata"


*------------------------------------------------------------------------------*
* IWW: county-year locals counts, 1906-1917
*------------------------------------------------------------------------------*

import delimited "$rawdata/unions/IWW_unions_county1930.csv", clear varnames(1) stringcols(1) case(preserve)

label data "IWW county-year locals counts (1906-1917)"
label var gisjoin_1930   "GISJOIN, 1930 county boundaries"
label var countynhg_1930 "NHGIS county code, 1930 boundaries"
label var IWW_locals     "Number of IWW locals in county across 1906-1917"

save "$intmdata/IWW_unions_1906-1917_county1930.dta", replace


*------------------------------------------------------------------------------*
* KoL: county-year locals counts, 1880 and 1890
*------------------------------------------------------------------------------*

import delimited "$rawdata/unions/KoL_unions_county1930.csv", clear varnames(1) stringcols(2) case(preserve)

label data "Knights of Labor county-year locals counts (1880, 1890)"
label var year           "Year"
label var gisjoin_1930   "GISJOIN, 1930 county boundaries"
label var countynhg_1930 "NHGIS county code, 1930 boundaries"
label var locals_kol     "Number of Knights of Labor locals in county-year"

save "$intmdata/KOL_locals_1880-1890_county1930.dta", replace
