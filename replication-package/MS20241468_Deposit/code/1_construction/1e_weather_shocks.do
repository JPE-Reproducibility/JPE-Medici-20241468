*==============================================================================*
* 1e_weather_shocks.do
*
* Builds the country-year predicted immigration flows driven by weather
* shocks in the origin country (used as a push-factor instrument in 1f's
* shift-share construction).
*
* Step 1: import Willcox (1929) yearly immigration counts by European
*         country of origin, 1890-1920.
*
* Step 2: load Sequeira et al. (2020) European weather-station data,
*         compute seasonal temperature shock dummies (positive/negative
*         standard-deviation bins), aggregate to country-year via
*         population-weighted means.
*
* Step 3: merge flows with shocks; for each country, regress log(imm_flow)
*         on lagged temperature shock dummies and predict the flow
*         attributable to weather. Diagnostic scatter saved to figures/.
*
* Step 4: aggregate predicted flows to 10-year decadal blocks (anchor
*         years 1900, 1910, 1920), reshape to one row per anchor year,
*         pad missing countries with .
*
* INPUTS:
*   $rawdata/Willcox_1929/willcox_immigration_bycountry.csv
*   $rawlocal/Replication_Sequeira_et_al_2020/Weather_Data.dta  (unshipped pointer data; see README)
*
* OUTPUT (in $intmdata/):
*   predicted_flows_weather.dta  - country-year predicted weather-driven
*                                  immigration flows (consumed by 1f)
*
* Run via 00_master.do, or standalone.
*==============================================================================*

clear all
set more off, perm

if "$root" == "" global root "set-this-to-the-replication-package-path"
global rawdata  "$root/data/public"
global rawlocal "$root/data/_raw_local"   // unshippable third-party POINTER data (obtain from source; excluded from deposit zip)
global intmdata "$root/data/intermediate"
global figures  "$root/output/figures"
cap mkdir "$intmdata"
cap mkdir "$figures"


*------------------------------------------------------------------------------*
* Willcox (1929) yearly immigration by European country of origin
*------------------------------------------------------------------------------*

import delimited "$rawdata/Willcox_1929/willcox_immigration_bycountry.csv", clear varnames(1)

reshape long immigr_, i(country) j(year)
rename immigr_ imm_flow

keep if inrange(year,1890,1920) == 1
drop if country == "czechoslovakia" | country == "finland" | country == "other uk" | ///
        country == "poland" | country == "other europe" | country == "_england" | ///
        country == "_scotland" | country == "_wales" | country == "_greece" | ///
        country == "_portugal" | country == "_spain" | country == "romania"

replace country = "aus_hung" if country == "austria-hungary"
replace country = "gr_pt_es" if country == "greece-portugal-spain"
replace country = "nether"   if country == "netherlands"
replace country = "switz"    if country == "switzerland"

tempfile willcox_flows
save `willcox_flows', replace


*------------------------------------------------------------------------------*
* European weather data (Sequeira et al. 2020): seasonal temperature shocks
* expressed as standardized-deviation bins. Standardization is per
* country-iso (ISO_ALPHA3) and per season (Fall=16, Spring=14, Summer=15,
* Winter=13).
*------------------------------------------------------------------------------*

use "$rawlocal/Replication_Sequeira_et_al_2020/Weather_Data.dta", clear

sort year country
keep if country == "Austria" | country == "Belgium" | ///
        country == "Czech Republic" | country == "Denmark" | ///
        country == "Finland" | country == "France" | country == "Germany" | country == "Greece" | ///
        country == "Hungary" | country == "Ireland" | country == "Italy" | ///
        country == "Luxembourg" | ///
        country == "Netherlands" | country == "Norway" | country == "Poland" | ///
        country == "Portugal" | country == "Russia" | ///
        country == "Spain" | country == "Sweden" | ///
        country == "Switzerland" | country == "United Kingdom"

replace country = lower(country)
replace country = "aus_hung" if country == "austria" | country == "hungary"
replace country = "czech"    if country == "czech republic"
replace country = "gr_pt_es" if country == "greece" | country == "portugal" | country == "spain"
replace country = "uk"       if country == "united kingdom"
replace country = "luxemb"   if country == "luxembourg"
replace country = "nether"   if country == "netherlands"
replace country = "switz"    if country == "switzerland"

* Build temperature shock indicators per season: a station-year is hit with
* a positive (negative) shock at level k if its standardized temperature is
* in the half-open interval (k, k+1] (resp. [-(k+1), -k)).
foreach season_code in 16 14 15 13 {

    if `season_code' == 16 local suffix = "f"   // Fall
    if `season_code' == 14 local suffix = "s"   // Spring
    if `season_code' == 15 local suffix = "su"  // Summer
    if `season_code' == 13 local suffix = "w"   // Winter

    cap drop temp_cstd
    bysort ISO_ALPHA3: center temp if season == `season_code', standardize gen(temp_cstd)

    gen tempshock_pos1`suffix' = (temp_cstd > 1 & temp_cstd <= 2 & temp_cstd != .)
    gen tempshock_pos2`suffix' = (temp_cstd > 2 & temp_cstd <= 3 & temp_cstd != .)
    gen tempshock_pos3`suffix' = (temp_cstd > 3 & temp_cstd != .)

    gen tempshock_neg1`suffix' = (temp_cstd < -1 & temp_cstd >= -2 & temp_cstd != .)
    gen tempshock_neg2`suffix' = (temp_cstd < -2 & temp_cstd >= -3 & temp_cstd != .)
    gen tempshock_neg3`suffix' = (temp_cstd < -3 & temp_cstd != .)

}

drop temp_cstd


*------------------------------------------------------------------------------*
* Aggregate shocks to country-year via station population-weighted means
*------------------------------------------------------------------------------*

collapse (mean) tempshock* [pweight=grid_code/100], by(year country)


*------------------------------------------------------------------------------*
* Per-country regression of log(imm_flow) on lagged temperature shocks;
* predict the weather-driven component of immigration.
*------------------------------------------------------------------------------*

merge 1:1 year country using `willcox_flows'
keep if _merge == 3
drop _merge

gen log_imm = log(imm_flow)

encode country, gen(country_n)
xtset country_n year

gen pred_temp_log_imm = .

levelsof country, local(countries) clean
foreach country of local countries {

    if "`country'" == "aus_hung" local titlename = "Austria-Hungary"
    if "`country'" == "belgium"  local titlename = "Belgium"
    if "`country'" == "denmark"  local titlename = "Denmark"
    if "`country'" == "france"   local titlename = "France"
    if "`country'" == "germany"  local titlename = "Germany"
    if "`country'" == "gr_pt_es" local titlename = "Greece-Portugal-Spain"
    if "`country'" == "ireland"  local titlename = "Ireland"
    if "`country'" == "italy"    local titlename = "Italy"
    if "`country'" == "nether"   local titlename = "Netherlands"
    if "`country'" == "norway"   local titlename = "Norway"
    if "`country'" == "russia"   local titlename = "Russia"
    if "`country'" == "sweden"   local titlename = "Sweden"
    if "`country'" == "switz"    local titlename = "Switzerland"
    if "`country'" == "uk"       local titlename = "United Kingdom"

    reg log_imm l1.tempshock* if country == "`country'" & inrange(year,1891,1920)
    predict pred_temp_log_imm_`country' if e(sample) == 1
    replace pred_temp_log_imm = pred_temp_log_imm_`country' if country == "`country'" & inrange(year,1891,1920)

    twoway (scatter pred_temp_log_imm log_imm, mcolor("navy*0.9") msize(medium)) ///
           (lfit pred_temp_log_imm log_imm, lcolor("navy*0.9") lwidth(medthin)) if country == "`country'", ///
            xtitle("Log Immigration", size(small)) ///
            xlabel(, labsize(small) glcolor(gs16)) ///
            ytitle("Predicted Log Immigration", size(small)) ///
            ylabel(, labsize(small) angle(0) glcolor(gs16)) ///
            graphregion(color(white) margin(small)) plotregion(color(white) margin(small)) ///
            legend(off) ///
            name(corr_logimm_`country', replace) title("`titlename'", size(small))

    drop pred_temp_log_imm_`country'

}

grc1leg2 corr_logimm_aus_hung corr_logimm_belgium corr_logimm_denmark corr_logimm_france corr_logimm_germany ///
         corr_logimm_gr_pt_es corr_logimm_ireland corr_logimm_italy corr_logimm_nether corr_logimm_norway ///
         corr_logimm_russia corr_logimm_sweden corr_logimm_switz corr_logimm_uk, ///
         graphregion(color(white) margin(small)) plotregion(color(white) margin(small)) loff
graph export "$figures/corr_logimm_tempshock.pdf", replace


*------------------------------------------------------------------------------*
* Aggregate predicted flows to 10-year blocks at anchor years (1900, 1910, 1920)
*------------------------------------------------------------------------------*

gen	    t_10 = .
replace t_10 = 1890 if inrange(year,1891,1900)
replace t_10 = 1900 if inrange(year,1901,1910)
replace t_10 = 1910 if inrange(year,1911,1920)

gen pred_temp_imm = exp(pred_temp_log_imm) if inrange(year,1891,1920)
bysort country t_10: egen pred_temp_imm_10yr = total(pred_temp_imm)

keep if inlist(year,1900,1910,1920)
keep year country pred_temp_imm_10yr

reshape wide pred_temp_imm_10yr, i(year) j(country) string

rename pred_temp_imm_10yr* *_temp_US_10yr_mw

* Pad countries with no observed flows in this period
foreach i in czech poland luxemb {
    gen `i'_temp_US_10yr_mw = .
}

label data "Country-year temperature-shock-driven predicted immigration flows"

save "$intmdata/predicted_flows_weather.dta", replace
