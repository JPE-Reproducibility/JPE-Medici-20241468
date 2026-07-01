*==============================================================================*
* 1b_merge_preadjust.do
*
* Merges the per-year component datasets built by 1a and the build stage into one
* county dataset per census year, ahead of the county-border harmonization
* in 1c. The panel is assembled in two blocks because the base data differ:
*   - 1880, 1900, 1910, 1920: IPUMS full-count census aggregates;
*   - 1890: ICPSR 2896 county aggregates (the 1890 full count was destroyed
*     by fire).
*
* INPUTS (in $intmdata/): the per-year intermediate datasets written by
*   1a and the build stage -- IPUMS labor-market, population, immigrant, occupation and
*   industry aggregates; the 1890 ICPSR aggregates; the manufacturing,
*   agricultural, and mining censuses; residential-segregation counts;
*   election results; the 1900 NHGIS county-identifier lookup; and the
*   StateFIP-StateICP crosswalk.
*
* OUTPUT (in $data/county_unadjusted/):
*   county_panel_<year>_unadjusted.dta  - one per census year (1880-1930);
*                                         read by 1c
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
global censusagg "$rawdata/census_aggregates"   // shipped county/national aggregates (CSV) built by build_documentation/
cap mkdir "$intmdata"
cap mkdir "$data"
cap mkdir "$data/county_unadjusted"


*------------------------------------------------------------------------------*
* Convert the deposited census aggregates (CSV, open format -- JPE 1.4) to .dta
* in $intmdata so the year-by-year merges below read them unchanged. Built by the
* build_documentation/ stage and shipped as CSV by b16_ship_aggregates.do.
* case(preserve) keeps the original variable-name case. The confirm-file guard
* skips aggregates a given run does not have (e.g. there is no 1930 industry file).
*------------------------------------------------------------------------------*

foreach year in 1880 1890 1900 1910 1920 1930 {
    foreach f in IPUMS_`year'_county IPUMS_`year'_euroimm_county         ///
                 IPUMS_`year'_ind1950counts_county IPUMS_`year'_occ_county_m ///
                 IPUMS_`year'_population_county ICPSR_`year'_population_county {
        cap confirm file "$censusagg/`f'.csv"
        if !_rc {
            import delimited "$censusagg/`f'.csv", clear case(preserve)
            save "$intmdata/`f'.dta", replace
        }
    }
}
foreach f in electionresults_1856_county electionresults_1886-1924_county ///
             resid_segr_1880 agri_census_1890 mfg_census mines_census_1890 cpi_u ///
             railroad_connection_1930countyboundaries {
    cap confirm file "$censusagg/`f'.csv"
    if !_rc {
        import delimited "$censusagg/`f'.csv", clear case(preserve)
        save "$intmdata/`f'.dta", replace
    }
}
clear


*------------------------------------------------------------------------------*
* County panels for 1880, 1900, 1910, 1920
*------------------------------------------------------------------------------*

foreach year in 1880 1900 1910 1920 {

* Base: IPUMS labor-market aggregates (b1). Add population counts (b5) and the
* manufacturing census (b7).
use if year == `year' using "$intmdata/IPUMS_`year'_county.dta", clear

merge 1:1 year stateicp countyicp using "$intmdata/IPUMS_`year'_population_county.dta"
drop if year != `year'
drop _merge

merge 1:1 year stateicp countyicp using "$intmdata/mfg_census.dta", keepusing(mfglabor_* mfgwages_* mfgout mfgestab)
drop if year != `year'
drop if _merge == 2
drop _merge

* The 1900 IPUMS full count has no NHGIS county identifier (countynhg); merge
* it in from the dedicated crosswalk.
if `year' == 1900 {
merge 1:1 year stateicp countyicp using "$intmdata/xwalk_1900_countynhg_countyicp.dta", keepusing(countynhg)
drop if _merge == 2
drop _merge
}

* Immigrant counts by birthplace country (b2). A county absent from the
* immigrant file is a true zero; build the men+women (and recent-arrival)
* totals from the men's and women's counts.
if `year' != 1880 {
merge 1:1 year stateicp countyicp using "$intmdata/IPUMS_`year'_euroimm_county.dta"
foreach country in denmark finland norway sweden uk ireland oth_northeu ///
				   belgium france luxemb nether switz oth_westeu ///
				   italy gr_pt_es oth_southeu ///
				   aus_hung czech germany poland oth_easteu oth_centereu ///
				   russia oth_russeu {
foreach s in m w {
replace `country'_`s' = 0 if _merge == 1 & `country'_`s' == .
}
gen `country'_mw      = `country'_m + `country'_w
gen `country'_10yr_mw = `country'_10yr_m + `country'_10yr_w
}
drop _merge
}

if `year' == 1880 {

* Residential-segregation counts (b6).
merge 1:1 year stateicp countyicp using "$intmdata/resid_segr_1880.dta"
drop if _merge == 2
drop _merge

* Immigrant counts by birthplace country (b2). The 1880 census has no
* year-of-immigration, so there are no recent-arrival counts -- only the
* men+women total is built.
merge 1:1 year stateicp countyicp using "$intmdata/IPUMS_`year'_euroimm_county.dta"
foreach country in denmark finland norway sweden uk ireland oth_northeu ///
				   belgium france luxemb nether switz oth_westeu ///
				   italy gr_pt_es oth_southeu ///
				   aus_hung czech germany poland oth_easteu oth_centereu ///
				   russia oth_russeu {
foreach s in m w {
replace `country'_`s' = 0 if _merge == 1 & `country'_`s' == .
}
gen `country'_mw = `country'_m + `country'_w
}
drop _merge

}

* Presidential-election returns: the decade's elections, plus the 1856
* American-Party (Know-Nothing) cross-section.
if `year' == 1900 {
merge 1:1 year stateicp countyicp using "$intmdata/electionresults_1886-1924_county.dta", keepusing(*vote_1896 *vote_1900 *vote_1904)
drop if _merge == 2
drop _merge
merge m:1 stateicp countyicp using "$intmdata/electionresults_1856_county.dta", keepusing(*vote_1856)
drop if _merge == 2
drop _merge
}
if `year' == 1910 {
merge 1:1 year stateicp countyicp using "$intmdata/electionresults_1886-1924_county.dta", keepusing(*vote_1908 *vote_1912)
drop if _merge == 2
drop _merge
merge m:1 stateicp countyicp using "$intmdata/electionresults_1856_county.dta", keepusing(*vote_1856)
drop if _merge == 2
drop _merge
}
if `year' == 1920 {
merge 1:1 year stateicp countyicp using "$intmdata/electionresults_1886-1924_county.dta", keepusing(*vote_1916 *vote_1920 *vote_1924)
drop if _merge == 2
drop _merge
merge m:1 stateicp countyicp using "$intmdata/electionresults_1856_county.dta", keepusing(*vote_1856)
drop if _merge == 2
drop _merge
}

* Occupation counts (b3) and IND1950 industry counts (b4).
merge 1:1 year stateicp countyicp using "$intmdata/IPUMS_`year'_occ_county_m.dta"
drop _merge

merge 1:1 year stateicp countyicp using "$intmdata/IPUMS_`year'_ind1950counts_county.dta"
drop _merge

* Correct miscoded / missing NHGIS county identifiers so the border
* adjustment in 1c matches counties cleanly.
if inlist(`year',1910,1920) == 1 {
replace countynhg = 5106500 if countynhg == 5100550 & statefip == 51 & countyicp == 6500
}

if `year' == 1900 {
replace countynhg = 5100130 if countynhg == 5100035 & countyicp == 130
replace countynhg = 5105100 if countynhg == 5100035 & countyicp == 5100
merge m:1 stateicp using "$intmdata/xwalk_statefip_stateicp.dta", keepusing(statefip)
drop if _merge == 2
drop _merge
replace countynhg = (statefip * 100000) + countyicp if countynhg == . & inlist(stateicp,33,35,37,40,49,53) & countyicp < 9000
}

drop statefip

sort year stateicp countyicp
order year countynhg stateicp countyicp, first

* Drop counties with no NHGIS identifier -- they cannot be border-adjusted.
drop if countynhg == . | countynhg == 9999999

drop if year != `year'

save "$data/county_unadjusted/county_panel_`year'_unadjusted.dta", replace

}


*------------------------------------------------------------------------------*
* County panel for 1890
*------------------------------------------------------------------------------*

* 1890 has no IPUMS full count (the returns were destroyed by fire), so the
* base is the ICPSR 2896 county aggregates (b7), with a narrower set of
* components than the other census years.
foreach year in 1890 {

use if year == `year' using "$intmdata/ICPSR_`year'_population_county.dta", clear

merge 1:1 year stateicp countyicp using "$intmdata/mfg_census.dta", keepusing(mfglabor_* mfgwages_* mfgout mfgestab)
drop if _merge == 2
drop _merge

merge 1:1 year stateicp countyicp using "$intmdata/agri_census_1890.dta", keepusing(farmarea)
drop if _merge == 2
drop _merge

merge 1:1 year stateicp countyicp using "$intmdata/electionresults_1886-1924_county.dta", keepusing(*vote_1888 *vote_1892)
drop if _merge == 2
drop _merge

merge m:1 stateicp countyicp using "$intmdata/electionresults_1856_county.dta", keepusing(*vote_1856)
drop if _merge == 2
drop _merge

merge m:1 stateicp countyicp using "$intmdata/mines_census_1890.dta", keepusing(coalmines_*)
drop if _merge == 2
drop _merge

drop if all_totpop_mw == .
drop fips

sort year stateicp countyicp
order year stateicp countyicp, first

drop if year != `year'

save "$data/county_unadjusted/county_panel_`year'_unadjusted.dta", replace

}


*------------------------------------------------------------------------------*
* County panel for 1930
*------------------------------------------------------------------------------*

* 1930 provides the t+10 (1930) values used in the analysis to interpolate 1920
* union membership and to form the one-decade-ahead immigrant share. The 1930
* IPUMS full count is aggregated for population and immigrant origin only; the
* labor-force, occupation, and industry tabulations are not needed for 1930. All
* outcomes are defined for 1900, 1910, and 1920, so 1930 enters only as the lead
* census year and not as an analysis observation.
foreach year in 1930 {

use if year == `year' using "$intmdata/IPUMS_`year'_population_county.dta", clear

* Immigrant counts by birthplace country (same processing as the main loop).
merge 1:1 year stateicp countyicp using "$intmdata/IPUMS_`year'_euroimm_county.dta"
foreach country in denmark finland norway sweden uk ireland oth_northeu ///
				   belgium france luxemb nether switz oth_westeu ///
				   italy gr_pt_es oth_southeu ///
				   aus_hung czech germany poland oth_easteu oth_centereu ///
				   russia oth_russeu {
foreach s in m w {
replace `country'_`s' = 0 if _merge == 1 & `country'_`s' == .
}
gen `country'_mw      = `country'_m + `country'_w
gen `country'_10yr_mw = `country'_10yr_m + `country'_10yr_w
}
drop _merge

sort year stateicp countyicp
order year countynhg stateicp countyicp, first

drop if countynhg == . | countynhg == 9999999
drop if year != `year'

save "$data/county_unadjusted/county_panel_`year'_unadjusted.dta", replace

}
