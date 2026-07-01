*------------------------------------------------------------------------------*
* b12_unions_combine.do
*
* Builds the combined union membership and locals dataset from the AFL
* state-convention county aggregate and the five national-union county aggregates
* (UMWA, UBC, IAM, BMPIU, ITU). For each county, membership and locals counts
* that are unobserved in a census year but bracketed by observed years are
* linearly interpolated; counties in state-years with observed conventions but no
* delegates are set to zero. The AFL and national-union counts are then combined
* (averaging where both sources report positive counts, otherwise taking the
* non-zero source), and delegate ethnic-origin and skilled/unskilled breakdowns
* are derived. The output is the combined union counts at the county-census-year
* level; union densities (counts over the occupational labor force) are
* constructed in the analysis pipeline, which reads this file.
*
* The construction is built on a frame of every 1930 county and census year
* (from the county-crosswalk 1930 identifiers), with statefip and statecode.
*
* Inputs:  $intmdata/{AFL_members, UMWA_votes, UBC_votes, IAM_votes,
*                     BMPIU_votes, ITU_members}_county1930.csv  (build intermediates)
* Output:  $rawdata/unions/unions_combined_county1930.csv  (shipped; 1900-1920)
*------------------------------------------------------------------------------*

clear all

if "$root" == "" global root "set-this-to-the-replication-package-path"
global rawdata  "$root/data/public"
global intmdata "$root/data/intermediate"

* State FIPS-to-state-code crosswalk, read from the source crosswalk file.
import delimited "$rawdata/crosswalks/xwalk_statefip_stateicp.csv", clear case(preserve)
tempfile statexwalk
save `statexwalk'

* County-year skeleton on 1930 boundaries, with statefip and statecode.
use "$rawdata/county_crosswalks/crosswalks/CountyToCounty/1930/Identifiers_1930.dta", clear
keep gisjoin2 state
rename gisjoin2 countynhg_1930
replace state = state / 10
rename state statefip
expand 6
bysort countynhg_1930: gen year = 1870 + 10*_n
merge m:1 statefip using `statexwalk', keepusing(statecode)
drop if _merge == 2
drop _merge
xtset countynhg_1930 year

* State AFL convention start dates (first year each state branch convened)
*------------------------------------------------------------------------------*

gen	 	yr_afl_firstconv = .
replace yr_afl_firstconv = 1901 if statefip == 1
replace yr_afl_firstconv = 1903 if statefip == 5
replace yr_afl_firstconv = 1912 if statefip == 4
replace yr_afl_firstconv = 1903 if statefip == 6
replace yr_afl_firstconv = 1896 if statefip == 8
replace yr_afl_firstconv = 1887 if statefip == 9
replace yr_afl_firstconv = 1923 if statefip == 10
replace yr_afl_firstconv = 1901 if statefip == 12
replace yr_afl_firstconv = 1899 if statefip == 13
replace yr_afl_firstconv = 1893 if statefip == 19
replace yr_afl_firstconv = 1916 if statefip == 16
replace yr_afl_firstconv = 1883 if statefip == 17
replace yr_afl_firstconv = 1885 if statefip == 18
replace yr_afl_firstconv = 1907 if statefip == 20
replace yr_afl_firstconv = 1900 if statefip == 21
replace yr_afl_firstconv = 1913 if statefip == 22
replace yr_afl_firstconv = 1886 if statefip == 25
replace yr_afl_firstconv = 1905 if statefip == 24 | statefip == 11
replace yr_afl_firstconv = 1891 if statefip == 23
replace yr_afl_firstconv = 1890 if statefip == 26
replace yr_afl_firstconv = 1883 if statefip == 27
replace yr_afl_firstconv = 1892 if statefip == 29
replace yr_afl_firstconv = 1918 if statefip == 28
replace yr_afl_firstconv = 1894 if statefip == 30
replace yr_afl_firstconv = 1907 if statefip == 37
replace yr_afl_firstconv = 1912 if statefip == 38
replace yr_afl_firstconv = 1909 if statefip == 31
replace yr_afl_firstconv = 1902 if statefip == 33
replace yr_afl_firstconv = 1879 if statefip == 34
replace yr_afl_firstconv = 1914 if statefip == 35
replace yr_afl_firstconv = 1921 if statefip == 32
replace yr_afl_firstconv = 1897 if statefip == 36
replace yr_afl_firstconv = 1884 if statefip == 39
replace yr_afl_firstconv = 1904 if statefip == 40
replace yr_afl_firstconv = 1902 if statefip == 41
replace yr_afl_firstconv = 1890 if statefip == 42
replace yr_afl_firstconv = 1901 if statefip == 44
replace yr_afl_firstconv = 1915 if statefip == 45
replace yr_afl_firstconv = 1920 if statefip == 46
replace yr_afl_firstconv = 1898 if statefip == 47
replace yr_afl_firstconv = 1898 if statefip == 48
replace yr_afl_firstconv = 1904 if statefip == 49
replace yr_afl_firstconv = 1896 if statefip == 51
replace yr_afl_firstconv = 1902 if statefip == 50
replace yr_afl_firstconv = 1902 if statefip == 53
replace yr_afl_firstconv = 1893 if statefip == 55
replace yr_afl_firstconv = 1903 if statefip == 54
replace yr_afl_firstconv = 1909 if statefip == 56


*------------------------------------------------------------------------------*
* AFL state-convention merge: no-data flags, interpolation, zero-fills
*------------------------------------------------------------------------------*

* The union aggregates are deposited as CSV (open format, JPE section 1.4).
* Import each into a tempfile so the merges below can read it; case(preserve)
* keeps the mixed-case variable names (UMWA*, UBC*, IAM*, BMPIU*, ITU*).
* Built by the build_documentation/ stage (b10_aflstateconv, b11_natunions).
preserve
tempfile afl_csv umwa_csv ubc_csv iam_csv bmpiu_csv itu_csv
import delimited "$intmdata/AFL_members_county1930.csv", clear case(preserve)
* The 1930 state-convention records are the t+10 bracket used to interpolate 1920
* membership for counties whose 1920 convention is unobserved (1920 = (1910 + 1930)/2),
* as described in the data appendix.
save `afl_csv'
import delimited "$intmdata/UMWA_votes_county1930.csv",  clear case(preserve)
save `umwa_csv'
import delimited "$intmdata/UBC_votes_county1930.csv",   clear case(preserve)
save `ubc_csv'
import delimited "$intmdata/IAM_votes_county1930.csv",   clear case(preserve)
save `iam_csv'
import delimited "$intmdata/BMPIU_votes_county1930.csv", clear case(preserve)
save `bmpiu_csv'
import delimited "$intmdata/ITU_members_county1930.csv", clear case(preserve)
save `itu_csv'
restore

merge 1:1 year countynhg_1930 using `afl_csv', keepusing(year_orig afl_*) gen(_m_AFL)
drop if _m_AFL == 2

* Delegate-origin counts (afl_nr_del_*) are tabulated for 1900-1920 only. For a county
* whose 1920 state convention is unobserved, 1920 is interpolated from the 1910 and 1930
* brackets, exactly as for membership below. The 1930 delegate bracket is set to 0 in
* observed state-years that recorded membership but yielded no delegate count, so that
* interpolation resolves to 1920 = (1910 + 0)/2 rather than leaving 1920 missing.
foreach var of varlist afl_nr_del* {
	replace `var' = 0 if afl_members != . & `var' == . & year >= 1900
}

*Last year of AFL convention data, by state
gen 	yr_afl_lastconv = .
replace yr_afl_lastconv = 1920 if inlist(statecode,"AR","FL","KS","MS","NJ","NC","TX","UT","VT")
replace yr_afl_lastconv = 1910 if inlist(statecode,"KY","NE")

**Identify state-years for which no AFL convention data is available
gen 	stateyear_nodata = 0
replace stateyear_nodata = 1 if statecode == "AL" & year == 1900
replace stateyear_nodata = 1 if statecode == "AZ" & inlist(year,1900,1910)
replace stateyear_nodata = 1 if statecode == "AR" & year == 1900
replace stateyear_nodata = 1 if statecode == "CO" & year == 1920
replace stateyear_nodata = 1 if statecode == "CT" & inlist(year,1900,1920)
replace stateyear_nodata = 1 if statecode == "DE"
replace stateyear_nodata = 1 if statecode == "DC"
replace stateyear_nodata = 1 if statecode == "GA" & inlist(year,1900,1910)
replace stateyear_nodata = 1 if statecode == "ID" & inlist(year,1900,1910)
replace stateyear_nodata = 1 if statecode == "KS" & year == 1900
replace stateyear_nodata = 1 if statecode == "KY" & year == 1920
replace stateyear_nodata = 1 if statecode == "LA" & inlist(year,1900,1910)
replace stateyear_nodata = 1 if statecode == "ME" & year == 1900
replace stateyear_nodata = 1 if statecode == "MD" & year == 1900
replace stateyear_nodata = 1 if statecode == "MI" & inlist(year,1900,1910)
replace stateyear_nodata = 1 if statecode == "MS" & inlist(year,1900,1910)
replace stateyear_nodata = 1 if statecode == "MT" & year == 1900
replace stateyear_nodata = 1 if statecode == "NE" & year == 1900
replace stateyear_nodata = 1 if statecode == "NV"
replace stateyear_nodata = 1 if statecode == "NH" & year == 1900
replace stateyear_nodata = 1 if statecode == "NJ" & inlist(year,1900,1910)
replace stateyear_nodata = 1 if statecode == "NM" & inlist(year,1900,1910)
replace stateyear_nodata = 1 if statecode == "NC" & inlist(year,1900,1910)
replace stateyear_nodata = 1 if statecode == "ND" & inlist(year,1900,1910)
replace stateyear_nodata = 1 if statecode == "OK" & year == 1900
replace stateyear_nodata = 1 if statecode == "PA" & year == 1900
replace stateyear_nodata = 1 if statecode == "RI"
replace stateyear_nodata = 1 if statecode == "SC" & inlist(year,1900,1910)
replace stateyear_nodata = 1 if statecode == "SD" & inlist(year,1900,1910)
replace stateyear_nodata = 1 if statecode == "TN" & year == 1900
replace stateyear_nodata = 1 if statecode == "TX" & year == 1900
replace stateyear_nodata = 1 if statecode == "UT" & inlist(year,1900,1910)
replace stateyear_nodata = 1 if statecode == "VT" & inlist(year,1900,1910)
replace stateyear_nodata = 1 if statecode == "VA" & year == 1920
replace stateyear_nodata = 1 if statecode == "WA" & year == 1900
replace stateyear_nodata = 1 if statecode == "WV" & year == 1900
replace stateyear_nodata = 1 if statecode == "WY" & year == 1900
replace stateyear_nodata = 1 if year > yr_afl_lastconv

**States out of sample: no data, or representation rule not proportional to membership
gen 	state_notinsample = 0
replace state_notinsample = 1 if inlist(statecode,"DE","DC","KS","KY","LA","MD")
replace state_notinsample = 1 if inlist(statecode,"ND","NM","NV","RI","TN","SD")

**Replace membership data to missing for states-years for which no data is available
foreach var of varlist afl_* {
replace `var' = . if stateyear_nodata == 1 | state_notinsample == 1
}

**Pass 1: interpolate missing afl_* between t-10 and t+10 where both bracket years are observed
xtset countynhg_1930 year
gen afl_interp = (afl_members == . & l10.afl_members != . & f10.afl_members != .)
foreach var of varlist afl_* {
replace	`var' = (l10.`var' + f10.`var') / 2  if `var' == . & l10.`var' != . & f10.`var' != .
}

**Set membership = 0 for counties in observed state-years with no delegates
foreach var of varlist afl_* {
	replace `var' = 0 if _m_AFL == 1 & `var' == . & stateyear_nodata == 0 & state_notinsample == 0 & year >= 1900
}

**Set membership = 0 for years preceding the first ever state AFL convention
foreach var of varlist afl_* {
	replace `var' = 0 if year < yr_afl_firstconv & state_notinsample == 0 & year >= 1900
}

**Pass 2: re-interpolate now that the zero-fills have populated additional bracket years
xtset countynhg_1930 year
replace afl_interp = (afl_members == . & l10.afl_members != . & f10.afl_members != .)
foreach var of varlist afl_* {
replace	`var' = (l10.`var' + f10.`var') / 2  if `var' == . & l10.`var' != . & f10.`var' != .
replace `var' = . if state_notinsample == 1
}


*------------------------------------------------------------------------------*
* Per-national-union merges (UMWA, UBC, IAM, BMPIU, ITU)
*
* For each union: merge, drop master-only matches that violate 1:1
* (_m_<UNION>dens == 2), flag census years that are missing but bracketed
* by observed proxies (the *_interp dummies), linearly interpolate those
* missing cells from t-10 and t+10, and zero-fill remaining missing cells
* in years for which the convention proceedings are observed.
*------------------------------------------------------------------------------*

merge 1:1 year countynhg_1930 using `umwa_csv', keepusing(UMWA*) gen(_m_UMWAdens)
drop if _m_UMWAdens == 2
xtset countynhg_1930 year
gen UMWA_interp = (UMWA_memb_proxy_votes == . & l10.UMWA_memb_proxy_votes != . & f10.UMWA_memb_proxy_votes != .)
foreach var of varlist UMWA_locals_votes UMWA_memb_proxy_votes {
replace	`var' = (l10.`var' + f10.`var') / 2  if `var' == . & l10.`var' != . & f10.`var' != .
}
foreach var of varlist UMWA_locals_votes UMWA_memb_proxy_votes {
	replace `var' = 0 if _m_UMWAdens == 1 & inrange(year,1900,1920)
}
foreach var of varlist UMWA_membership {
	replace `var' = 0 if _m_UMWAdens == 1 & year == 1900
}

merge 1:1 year countynhg_1930 using `ubc_csv', keepusing(UBC*) gen(_m_UBCdens)
drop if _m_UBCdens == 2
xtset countynhg_1930 year
gen UBC_interp = (UBC_memb_proxy_votes == . & l10.UBC_memb_proxy_votes != . & f10.UBC_memb_proxy_votes != .)
foreach var of varlist UBC_locals_votes UBC_memb_proxy_votes {
replace	`var' = (l10.`var' + f10.`var') / 2  if `var' == . & l10.`var' != . & f10.`var' != .
}
foreach var of varlist UBC_locals_votes UBC_memb_proxy_votes {
	replace `var' = 0 if _m_UBCdens == 1 & inrange(year,1900,1920)
}

merge 1:1 year countynhg_1930 using `iam_csv', keepusing(IAM*) gen(_m_IAMdens)
drop if _m_IAMdens == 2
xtset countynhg_1930 year
gen IAM_interp = (IAM_memb_proxy_votes == . & l10.IAM_memb_proxy_votes != . & f10.IAM_memb_proxy_votes != .)
foreach var of varlist IAM_locals_votes IAM_memb_proxy_votes {
replace	`var' = (l10.`var' + f10.`var') / 2  if `var' == . & l10.`var' != . & f10.`var' != .
}
foreach var of varlist IAM_locals_votes IAM_memb_proxy_votes {
	replace `var' = 0 if _m_IAMdens == 1 & inrange(year,1900,1920)
}

merge 1:1 year countynhg_1930 using `bmpiu_csv', keepusing(BMPIU*) gen(_m_BMPIUdens)
drop if _m_BMPIUdens == 2
xtset countynhg_1930 year
gen BMPIU_interp = (BMPIU_memb_proxy_votes == . & l10.BMPIU_memb_proxy_votes != . & f10.BMPIU_memb_proxy_votes != .)
foreach var of varlist BMPIU_locals_votes BMPIU_memb_proxy_votes {
replace	`var' = (l10.`var' + f10.`var') / 2  if `var' == . & l10.`var' != . & f10.`var' != .
}
foreach var of varlist BMPIU_locals_votes BMPIU_memb_proxy_votes {
	replace `var' = 0 if _m_BMPIUdens == 1 & inrange(year,1900,1920)
}

merge 1:1 year countynhg_1930 using `itu_csv', keepusing(ITU*) gen(_m_ITUdens)
drop if _m_ITUdens == 2
xtset countynhg_1930 year
gen ITU_interp = (ITU_members == . & l10.ITU_members != . & f10.ITU_members != .)
foreach var of varlist ITU_locals_votes ITU_members {
replace	`var' = (l10.`var' + f10.`var') / 2  if `var' == . & l10.`var' != . & f10.`var' != .
}
foreach var of varlist ITU_locals_votes ITU_members {
	replace `var' = 0 if _m_ITUdens == 1 & inrange(year,1900,1920)
}


*------------------------------------------------------------------------------*
* Strip the `nr_` prefix from delegate counts (AFL and per-union)
*------------------------------------------------------------------------------*

rename *nr_del* *del*


*------------------------------------------------------------------------------*
* Lowercase the per-union prefixes (UMWA_*, UBC_*, etc.) -- section 5 reads
* lowercase
*------------------------------------------------------------------------------*

rename (UMWA_* UBC_* IAM_* BMPIU_* ITU_*) (umwa_* ubc_* iam_* bmpiu_* itu_*)


*==============================================================================*
* 5. Union derivatives: combined densities, ethnic shares, distances,
*    AFL locals/members derivations
*
* Combines union membership and locals counts from the AFL state-convention
* aggregate (the afl_members_<u> series) with the per-national-union
* convention proceedings (umwa, ubc, iam, bmpiu, itu) via row-mean blending
* with zero-fallback; computes per-union densities (membership over the
* corresponding occupational labor force); reshapes the per-union delegate
* ethnic counts and computes ethnic shares for the four core unions and
* the AFL aggregate; blends the AFL and convention delegate ethnic counts
* into "comb" combined series; attaches state-year groupings and great-
* circle distances from each county to the national convention cities for
* 1900, 1910, 1920; computes AFL locals derivations (skilled/unskilled
* split, using the 1890 Census of Mines split for UMWA); computes AFL
* membership densities at four denominators (skill-weighted, non-farm LF,
* total LF, total LF including women) and locals per labor force; closes
* with a final rename cascade ((*_members_combined) -> (afl_memb_comb_*),
* (*_combined_density*) -> (*_comb_dens*), etc.) and writes the master
* analysis dataset.
*==============================================================================*


*------------------------------------------------------------------------------*
* Combined union membership and locals (AFL aggregate + convention proceedings)
*------------------------------------------------------------------------------*

**Combine union membership and nr locals from AFL documents with that from union convention proceedings
egen afl_comb_interp = rowmax(afl_interp umwa_interp ubc_interp iam_interp bmpiu_interp itu_interp)

rename itu_members itu_memb_proxy_votes

foreach union in umwa ubc iam bmpiu itu {

***Membership
gegen 	`union'_members_combined = rowmean(`union'_memb_proxy_votes afl_members_`union') if inlist(year,1900,1910,1920) == 1
replace `union'_members_combined = `union'_memb_proxy_votes if afl_members_`union' == 0 & `union'_memb_proxy_votes != . & inlist(year,1900,1910,1920) == 1
replace `union'_members_combined = afl_members_`union' if `union'_memb_proxy_votes == 0 & afl_members_`union' != . & inlist(year,1900,1910,1920) == 1

replace `union'_members_combined = . if state_notinsample == 1

***Locals
gegen 	`union'_locals_combined = rowmean(`union'_locals_votes afl_locals_`union') if inlist(year,1900,1910,1920) == 1
replace `union'_locals_combined = `union'_locals_votes if afl_locals_`union' == 0 & `union'_locals_votes != . & inlist(year,1900,1910,1920) == 1
replace `union'_locals_combined = afl_locals_`union' if `union'_locals_votes == 0 & afl_locals_`union' != . & inlist(year,1900,1910,1920) == 1

replace `union'_locals_combined = . if state_notinsample == 1

}
rename itu_memb_proxy_votes itu_members


* Per-union delegate ethnic shares
*
* Reshape `afl_del_bpl_<group>_<u>` (the AFL state-convention delegate
* counts) into `afl_<u>_del_bpl_<group>` for the four core unions whose
* ethnic breakdown the AFL_members aggregate carries. Then rename the
* convention-proceedings counts (umwa_delegates_bpl_native, ...) to the
* shorter del_ form. Then for each {AFL, AFL x core 4, convention x core 4}
* compute denominators and within-source ethnic shares.
*------------------------------------------------------------------------------*

**Reshape AFL per-union delegate ethnic counts (core 4 only)
foreach union in ubc iam bmpiu umwa {
rename afl_del_bpl_*_`union' afl_`union'_del_bpl_*
rename afl_del_anc_*_`union' afl_`union'_del_anc_*
}

**Shorten convention-proceedings rename: delegates -> del
rename (*_delegates_bpl_* *_delegates_anc_*) (*_del_bpl_* *_del_anc_*)

**Drop redundant "euroall" suffix (we keep the same euro aggregate under "euro")
rename *bpl_euroall *bpl_euro
rename *anc_euroall *anc_euro

**Compute within-source ethnic denominators and shares
foreach union in afl ///
				 afl_ubc afl_iam afl_bmpiu afl_umwa ///
				 umwa ubc iam bmpiu {

gegen `union'_del_bpl_denom = rowtotal(`union'_del_bpl_native `union'_del_bpl_euro `union'_del_bpl_other), missing
gegen `union'_del_anc_denom = rowtotal(`union'_del_anc_euro `union'_del_anc_other), missing

gen 	`union'_del_sh_bpl_native = `union'_del_bpl_native / `union'_del_bpl_denom
replace `union'_del_sh_bpl_native = 0 if `union'_del_bpl_denom == 0

foreach group in other ///
				 euro euronw eurose {

gen 	`union'_del_sh_bpl_`group' = `union'_del_bpl_`group' / `union'_del_bpl_denom
replace `union'_del_sh_bpl_`group' = 0 if `union'_del_bpl_denom == 0

gen 	`union'_del_sh_anc_`group' = `union'_del_anc_`group' / `union'_del_anc_denom
replace `union'_del_sh_anc_`group' = 0 if `union'_del_anc_denom == 0

}
}


*------------------------------------------------------------------------------*
* AFL + convention combined delegate ethnic shares (four core unions only)
*------------------------------------------------------------------------------*

**Combine nr. delegates by ethnic group from AFL documents with that from union convention proceedings
foreach union in umwa ubc iam bmpiu {

foreach group in native other ///
				 euro euronw eurose denom {

gegen 	afl_comb_`union'_del_bpl_`group' = rowtotal(`union'_del_bpl_`group' afl_`union'_del_bpl_`group') if inlist(year,1900,1910,1920) == 1, missing
replace afl_comb_`union'_del_bpl_`group' = . if state_notinsample == 1

}

foreach group in other ///
				 euro euronw eurose denom {

gegen 	afl_comb_`union'_del_anc_`group' = rowtotal(`union'_del_anc_`group' afl_`union'_del_anc_`group') if inlist(year,1900,1910,1920) == 1, missing
replace afl_comb_`union'_del_anc_`group' = . if state_notinsample == 1

}

}


foreach union in umwa ubc iam bmpiu {

foreach group in native other ///
				 euro euronw eurose {

gen 	afl_comb_`union'_del_sh_bpl_`group' = afl_comb_`union'_del_bpl_`group' / afl_comb_`union'_del_bpl_denom
replace afl_comb_`union'_del_sh_bpl_`group' = 0 if afl_comb_`union'_del_bpl_denom == 0
replace afl_comb_`union'_del_sh_bpl_`group' = . if state_notinsample == 1

}

foreach group in other ///
				 euro euronw eurose {

gen 	afl_comb_`union'_del_sh_anc_`group' = afl_comb_`union'_del_anc_`group' / afl_comb_`union'_del_anc_denom
replace afl_comb_`union'_del_sh_anc_`group' = 0 if afl_comb_`union'_del_anc_denom == 0
replace afl_comb_`union'_del_sh_anc_`group' = . if state_notinsample == 1

}

}


* AFL locals derivations: total, skilled/unskilled
*
* UMWA locals are apportioned 57% skilled / 43% unskilled, from the 1890
* Census of Mines (miners and mechanics vs. laborers and boys under 16).
* Teamsters (IBT) are treated as fully unskilled.
*------------------------------------------------------------------------------*

**AFL locals
rename afl_locals_tot afl_locals_all

gen		afl_locals_noumwa		= afl_locals_all - afl_locals_umwa if inlist(year,1900,1910,1920)

gen		afl_locals_comb			= afl_locals_all ///
								   - afl_locals_umwa + umwa_locals_combined ///
								   - afl_locals_ubc + ubc_locals_combined ///
								   - afl_locals_iam + iam_locals_combined ///
								   - afl_locals_bmpiu + bmpiu_locals_combined ///
								   - afl_locals_itu + itu_locals_combined ///
								   if inlist(year,1900,1910,1920)

gen		afl_locals_comb_noumwa	= afl_locals_comb - umwa_locals_combined if inlist(year,1900,1910,1920)

**UMWA locals apportionment: 57% skilled / 43% unskilled (1890 Census of Mines).
**IBT (teamsters) assigned 100% unskilled.
gen 	afl_locals_comb_unsk	= (umwa_locals_combined*0.43) + afl_locals_ibt + ///
								  afl_locals_ila + afl_locals_amc + afl_locals_iummsw + ///
								  afl_locals_ugwa + afl_locals_utw + afl_locals_brew ///
								  if inlist(year,1900,1910,1920)

gen 	afl_locals_unsk			= (afl_locals_umwa*0.43) + afl_locals_ibt + ///
								  afl_locals_ila + afl_locals_amc + afl_locals_iummsw + ///
								  afl_locals_ugwa + afl_locals_utw + afl_locals_brew ///
								  if inlist(year,1900,1910,1920)

gen 	afl_locals_comb_sk		= afl_locals_comb - afl_locals_comb_unsk if inlist(year,1900,1910,1920)

gen 	afl_locals_sk			= afl_locals_all - afl_locals_unsk if inlist(year,1900,1910,1920)


*------------------------------------------------------------------------------*
* AFL members derivations and densities
*
* `afl_members` is renamed to `afl_members_all`. Skill variants applied as
* in the locals block above. Densities computed at four denominators:
* skill-weighted (high-skill 2 + mid-skill 2 + low-skill, the "non-managerial"
* labor force), non-farm labor force, total male labor force, and total
* labor force including women.
*------------------------------------------------------------------------------*

**AFL union members and density
rename afl_members afl_members_all

gen 	afl_members_noumwa		= (afl_members_all - afl_members_umwa) if inlist(year,1900,1910,1920)

gen 	afl_members_comb	   = afl_members_all ///
								  - afl_members_umwa + umwa_members_combined ///
								  - afl_members_ubc + ubc_members_combined ///
								  - afl_members_iam + iam_members_combined ///
								  - afl_members_bmpiu + bmpiu_members_combined ///
								  - afl_members_itu + itu_members_combined ///
								  if inlist(year,1900,1910,1920)

gen		afl_members_comb_noumwa = (afl_members_comb - umwa_members_combined) if inlist(year,1900,1910,1920)

**UMWA members: 57% skilled / 43% unskilled (1890 Census of Mines).
**IBT treated as fully unskilled (see locals block above).
gen		afl_members_comb_unsk	 = (umwa_members_combined*0.43) + afl_members_ibt + ///
								 afl_members_ila + afl_members_amc + afl_members_iummsw + ///
								 afl_members_ugwa + afl_members_utw + afl_members_brew ///
								 if inlist(year,1900,1910,1920)

gen		afl_members_unsk 		= (afl_members_umwa*0.43) + afl_members_ibt + ///
								 afl_members_ila + afl_members_amc + afl_members_iummsw + ///
								 afl_members_ugwa + afl_members_utw + afl_members_brew ///
								 if inlist(year,1900,1910,1920)

gen		afl_members_comb_sk = (afl_members_comb - afl_members_comb_unsk) if inlist(year,1900,1910,1920)

gen		afl_members_sk = (afl_members_all - afl_members_unsk) if inlist(year,1900,1910,1920)


foreach i in all noumwa ubc iam bmpiu itu ibt umwa brca amc ila iummsw aaser ugwa utw {

gen log_afl_members_`i' = log(1 + afl_members_`i')  if inlist(year,1900,1910,1920)

}


*------------------------------------------------------------------------------*
* Keep the union count variables (+ flags 1h needs) and export the combined dataset.
* Shipped as CSV only (the open format 1h imports); no .dta companion.
*------------------------------------------------------------------------------*
keep year countynhg_1930 afl_* umwa_* ubc_* iam_* bmpiu_* itu_* yr_afl_* ///
     state_notinsample stateyear_nodata
order year countynhg_1930
sort countynhg_1930 year
* Ship only the analysis years: 1880/1890 are empty frame rows and 1930 is the
* delegate-interpolation bracket, already consumed in the interpolation above.
keep if inrange(year,1900,1920)
export delimited "$rawdata/unions/unions_combined_county1930.csv", replace nolabel
