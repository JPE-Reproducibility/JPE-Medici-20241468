*==============================================================================*
* b7_economic_railroads.do
*
* Builds the county-level economic, demographic, and infrastructure datasets
* the panel draws on outside the IPUMS census microdata:
*   - 1890 population counts, by nativity group and birthplace country (the
*     1890 full count was destroyed by fire, so 1890 is built from published
*     county aggregates);
*   - manufacturing-census aggregates, pooled across census years;
*   - the 1890 agricultural and mining censuses;
*   - a CPI-U price deflator; and
*   - county railroad-connection years from Atack (2016).
*
* INPUTS:
*   $rawlocal/ICPSR_02896/DS####/02896-####-Data.dta  - ICPSR 2896 (Haines),
*                                  Historical Demographic/Economic/Social Data
*                                  (not shipped; stage under data/_raw_local/)
*   $rawdata/census_mines/coalmines_1890.csv  - 1890 coal-mine counts (shipped)
*   $rawdata/cpi/cpi_u_1967.csv               - CPI-U series (1967 = 100) (shipped)
*   $rawdata/railroad_maps/Railroad_Atack_1930countyboundaries.csv
*                                           - county railroad connection, Atack 2016
*
* OUTPUTS (in $intmdata/; b16 ships these to data/public/census_aggregates/):
*   ICPSR_1890_population_county.dta               - 1890 population
*   mfg_census.dta                                 - manufacturing census
*   agri_census_1890.dta                           - 1890 agriculture
*   mines_census_1890.dta                          - 1890 mining
*   cpi_u.dta                                      - CPI-U deflator
*   railroad_connection_1930countyboundaries.dta   - railroad connection year
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
* 1890 population, by nativity group and birthplace country (ICPSR 2896)
*------------------------------------------------------------------------------*

* The 1890 full-count census was destroyed by fire; 1890 county figures come
* from the published aggregates in ICPSR 2896 (DS0018). level == 1 is the
* county-level record.
use "$rawlocal/ICPSR_02896/DS0018/02896-0018-Data.dta", clear

keep if level == 1
gen year = 1890
order year, first

rename (state county totpop urb890 mtot ftot) ///
       (stateicp countyicp all_totpop_mw all_urbanpop_mw all_totpop_m all_totpop_w)

* Population counts by nativity: Black (negtot), all immigrants (foreign-born),
* and -- below -- European immigrants.
gen   black_totpop_mw = negtot

gen   imm_totpop_m  = fbmtot
gen   imm_totpop_w  = fbftot
gegen imm_totpop_mw = rowtotal(imm_totpop_m imm_totpop_w)

* For some counties the 1890 source reports Norway and Denmark only as a
* single combined birthplace count (pbnorden). Where a country-specific count
* is missing, split pbnorden 0.51/0.49 between Norway and Denmark. The ratio
* comes from the national Census totals: summing the counties that do report
* Norway and Denmark separately leaves 1,277 Norwegian-born and 1,221 Danish-
* born unaccounted for, and 1277 / (1277 + 1221) = 0.51.
replace pbnorway = round(pbnorden * 0.51) if pbnorway == .
replace pbdenmar = round(pbnorden * 0.49) if pbdenmar == .
drop pbnorden

* A missing birthplace count is a true zero.
foreach var of varlist pb* {
replace `var' = 0 if `var' == .
}

gegen euro_imm_totpop_mw = rowtotal(pbaustri pbbelg pbbohem pbdenmar pbenglan pbfrance pbgerman pbgreece pbhollan pbhungar pbirelan pbitaly pbluxemb pbnorway pbpoland pbportug pbrussia pbscot pbspain pbsweden pbswitz pbwales), missing

* Rename the birthplace counts to country names, then combine the components
* of the U.K., Iberia/Greece, and Austria-Hungary into the grouped countries
* used elsewhere in the pipeline.
rename (pbaustri pbbelg pbbohem pbdenmar pbenglan pbfrance pbgerman pbgreece pbhollan pbhungar pbirelan pbitaly pbluxemb pbnorway pbpoland pbportug pbrussia pbscot pbspain pbsweden pbswitz pbwales) ///
       (born_austria born_belgium born_czech born_denmark born_england born_france born_germany born_greece born_nether born_hungary born_ireland born_italy born_luxemb born_norway born_poland born_portugal born_russia born_scotland born_spain born_sweden born_switz born_wales)

gegen born_uk       = rowtotal(born_england born_scotland born_wales), missing
gegen born_gr_pt_es = rowtotal(born_greece born_portugal born_spain), missing
gegen born_aus_hung = rowtotal(born_austria born_hungary), missing

* Families and farm families. The source reports farm families directly for
* some years; where missing, recover them as total minus non-farm (home)
* families. Used downstream to build the share of farm families.
rename families nr_fams
gen     nr_farmfams = farmfams
replace nr_farmfams = nr_fams - homefams if nr_farmfams == .
label var nr_farmfams "# farm families"

* Keep the county counts; rename birthplace columns to <country>_mw and drop
* the components already folded into uk / gr_pt_es / aus_hung above.
keep year stateicp countyicp fips *_totpop* all_urbanpop_mw born_* nr_fams nr_farmfams
rename born_* *_mw
drop england_mw wales_mw scotland_mw austria_mw hungary_mw greece_mw portugal_mw spain_mw

order *_mw, sequential
order *totpop_m *totpop_w, after(all_totpop_mw)
order euro_imm_totpop_mw nr_fams nr_farmfams, last
order year fips stateicp countyicp, first

save "$intmdata/ICPSR_1890_population_county.dta", replace


*------------------------------------------------------------------------------*
* Manufacturing census, pooled across census years (ICPSR 2896)
*------------------------------------------------------------------------------*

* Each ICPSR 2896 manufacturing dataset covers one census year. Pool them: the
* census year is encoded in the name of the file's 5th variable (characters
* 4-6), so it is parsed out of that name and stored in `year'.
local n = 0
foreach num in 07 09 11 15 18 20 22 24 26 32 {
	local ++n
	use "$rawlocal/ICPSR_02896/DS00`num'/02896-00`num'-Data.dta", clear
	local t = 0
	foreach var of varlist _all {
		local ++t
		if `t' == 5 {
			gen year = "1" + substr("`var'", 4, 3)
			destring year, replace
		}
	}
	tempfile file_`n'
	save `file_`n''
}
clear
forvalues t = 1/`n' {
	append using `file_`t''
}

order year, first

keep if level == 1																// county-level records only
keep fips state county name totpop mfg* year
rename state  stateicp
rename county countyicp

* Manufacturing employment and wages were recorded under different variable
* names and age cutoffs across census years. Take the first non-missing of the
* available source variables, in order of preference.
gen     mfglabor_mw = mfglabor
replace mfglabor_mw = mfgavear if mi(mfglabor_mw)								// average # wage earners
replace mfglabor_mw = mfglabm + mfglabf if mi(mfglabor_mw)						// males + females in manufacturing
replace mfglabor_mw = mfglbm16 + mfglbf16 if mi(mfglabor_mw)					// males + females 16+
replace mfglabor_mw = mfglbm16 + mfglbf15 if mi(mfglabor_mw)					// males 16+ + females 15+

gen     mfglabor_m = mfglbm16
replace mfglabor_m = mfglabm if mi(mfglabor_m)

gen     mfglabor_w = mfglbf16
replace mfglabor_w = mfglbf15 if mi(mfglabor_w)

gen     mfgwages_mw = mfgwages
replace mfgwages_mw = mfglcost if mi(mfgwages_mw)								// cost of labor where wage data are missing (1860)

gen     mfgwages_m = mfgwgm16
gen     mfgwages_w = mfgwgf16
replace mfgwages_w = mfgwgf15 if mi(mfgwages_w)

order fips, after(year)
save "$intmdata/mfg_census.dta", replace


*------------------------------------------------------------------------------*
* 1890 agricultural census (ICPSR 2896)
*------------------------------------------------------------------------------*

use "$rawlocal/ICPSR_02896/DS0049/02896-0049-Data.dta", clear
keep if level == 1
gen year = 1890
order year, first
keep year fips state county name farmarea
rename state  stateicp
rename county countyicp

replace farmarea = farmarea / 247.105											// acres -> square kilometers
label var farmarea "Total area in farms (sq. km)"

save "$intmdata/agri_census_1890.dta", replace


*------------------------------------------------------------------------------*
* 1890 mining census
*------------------------------------------------------------------------------*

* Source: Day (1892), Report on Mineral Industries in the United States at the
* Eleventh Census, 1890.
import delimited "$rawdata/census_mines/coalmines_1890.csv", clear

gen year = 1890
order year, first

rename state  stateicp
rename county countyicp
rename *_1890 *

label var coalmines_reg "Number of regular coal mines"
label var coalmines_loc "Number of local coal mines"
label var coalmines_tot "Total number of coal mines"
label var coalmines_d   "=1 if at least a coal mine"

save "$intmdata/mines_census_1890.dta", replace


*------------------------------------------------------------------------------*
* CPI-U price deflator
*------------------------------------------------------------------------------*

* Source: Minneapolis Fed, "Consumer Price Index, 1800-" (inflation calculator)
* https://www.minneapolisfed.org/about-us/monetary-policy/inflation-calculator/consumer-price-index-1800-
import delimited "$rawdata/cpi/cpi_u_1967.csv", clear

label var cpi_u_1967 "CPI-U (1967=100)"

save "$intmdata/cpi_u.dta", replace


*------------------------------------------------------------------------------*
* Railroad connectivity (Atack 2016)
*------------------------------------------------------------------------------*

* Source: Jeremy Atack, "Historical GIS database of U.S. Railroads" (2016, rev.
* 2023). https://my.vanderbilt.edu/jeremyatack/data-downloads/
import delimited using "$rawdata/railroad_maps/Railroad_Atack_1930countyboundaries.csv", clear

keep nhgisnam nhgisst nhgiscty x_centroid y_centroid gisjoin gisjoin2 shape_area shape_len inopby

* inopby is the year a railroad first reached the county; one record per
* railroad segment, so take the earliest per county.
bysort gisjoin: gegen year_conn_rr = min(inopby)
duplicates drop gisjoin, force
drop inopby

rename gisjoin  gisjoin_1930
rename gisjoin2 countynhg_1930
order gisjoin_1930 countynhg_1930, first

label var year_conn_rr "Year of first RR in county (Atack 2016)"

save "$intmdata/railroad_connection_1930countyboundaries.dta", replace
