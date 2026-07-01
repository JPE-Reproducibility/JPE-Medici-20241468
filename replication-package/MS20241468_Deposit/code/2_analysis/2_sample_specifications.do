*==============================================================================*
* 2_sample_specifications.do
*
* Defines the estimation sample and the regression objects shared by the 2.*
* analysis scripts, operating on the county-year union dataset already in
* memory. Sets the fixed-effect and control-set globals; builds the in-sample
* and balanced-panel indicators (1900-1920, with the dependent variable, the
* instrument, and the 1890 controls non-missing, and an urban-or-mining 1890
* screen); zero-fills the immigrant-share variables inside the sample;
* rebuilds the AFL combined delegate-origin counts and shares from the per-
* union components; constructs union presence, average-membership, inverse-
* hyperbolic-sine, and log transforms; winsorizes the density, locals, and
* average-membership measures; and forms the immigrant-share interaction terms
* used by the heterogeneity tables.
*
* Included via `do` from the 2_analysis scripts (2a-2f) after they load
* analysis_dataset_county1930.dta. It modifies the data in memory and writes no
* files, so it neither clears nor reloads the data.
*
* Input (in memory):
*   analysis_dataset_county1930.dta   - loaded by the calling 2.* script
*
* Output:
*   none (defines globals and adds variables to the dataset in memory)
*==============================================================================*

* Project root. 00_master.do sets \$root for the full run; the line below also
* lets this file run on its own -- set it to the local path of the package.
if "$root" == "" global root "set-this-to-the-replication-package-path"
global code     "$root/code"
global rawdata  "$root/data/public"
global intmdata "$root/data/intermediate"
global data     "$root/data/clean"
global output   "$root/output"
global tables   "$output/tables"
global figures  "$output/figures"


*------------------------------------------------------------------------------*
* Labels, fixed effects, and control sets
*------------------------------------------------------------------------------*

label var sh_euro_wa_10yr_m "Immigrant Share"

global idfe countynhg_1930
global tfe  year
global fetext "County FE, Y, Year FE, Y"

drop coalmines_d*

gen coalmines_perpop_1890 = coalmines_tot_1890 / (all_totpop_mw_1890/1000)

global controls1
global controls2 year#c.mfglabor_share_mw_1890
global controls3 year#c.mfglabor_share_mw_1890 year#c.farmfams_share_1890
global controls4 year#c.mfglabor_share_mw_1890 year#c.farmfams_share_1890 year#c.mining_1890

global controlstext1 "Share Manufacturing, N, Share Agriculture, N, Active Coal Mines, N"
global controlstext2 "Share Manufacturing, Y, Share Agriculture, N, Active Coal Mines, N"
global controlstext3 "Share Manufacturing, Y, Share Agriculture, Y, Active Coal Mines, N"
global controlstext4 "Share Manufacturing, Y, Share Agriculture, Y, Active Coal Mines, Y"

global distcutoff 50


*------------------------------------------------------------------------------*
* Estimation sample
*
* In sample: census years 1900-1920 with the dependent variable, the
* instrument, and the 1890 controls non-missing, and either some urban
* population or at least one coal mine in 1890. The balanced sample keeps
* counties observed in all three years.
*------------------------------------------------------------------------------*

gen urban_1880 = (urban_share_mw_1880 > 0) if urban_share_mw_1880 != .
gen urban_1890 = (urban_share_mw_1890 > 0) if urban_share_mw_1890 != .
gen urban_0020_temp = (urban_share_mw > 0) if urban_share_mw != . & inrange(year,1900,1920) == 1
bysort countynhg (year): egen urban_0020 = max(urban_0020_temp)
drop urban_0020_temp

gen mining_1890  = (coalmines_tot_1890 > 0) if coalmines_tot_1890 != .
gen nonfarm_1890 = (farmarea_share_1890 < .8999075) if farmarea_share_1890 != .

foreach y in 1900 1910 {
    gen d`y'_mfgctrl = (year == `y') * mfglabor_share_mw_1890
    gen d`y'_agrctrl = (year == `y') * farmfams_share_1890
    gen d`y'_minctrl = (year == `y') * mining_1890
}

gen insample = (inlist(year,1900,1910,1920) == 1 & ///       census years 1900-1920
                afl_comb_all_dens != . & ///                 dependent variable non-missing
                sh_euro_wa_10yr_m != . & ///                 immigrant share non-missing
                pr1890_sh_euro_wa_10yr_m != . & ///          instrument non-missing
                urban_share_mw_1890 != . & ///
                coalmines_tot_1890 != . & ///
                mfglabor_share_mw_1890 != . & ///
                farmfams_share_1890 != . & ///
                (urban_1890 == 1 | mining_1890 == 1))      // some urban population or a coal mine in 1890

bysort countynhg (year): gegen comb_nrobs_temp = count(afl_comb_all_dens) if insample == 1
bysort countynhg (year): gegen comb_nrobs = max(comb_nrobs_temp)
drop comb_nrobs_temp

gen insample_balanced = (comb_nrobs == 3 & insample == 1)

* County ever in sample 1900-1920 and observed more than once (enters the panel)
bysort countynhg (year): egen insample_panel_ever = max(insample)
replace insample_panel_ever = 0 if comb_nrobs == 1

foreach var of varlist sh_*_wa_10yr_m {
    replace `var' = 0 if `var' == . & insample == 1
}


*------------------------------------------------------------------------------*
* Union density, locals, and presence
*------------------------------------------------------------------------------*

foreach union in all sk unsk ubc iam bmpiu itu umwa {
    replace afl_comb_locals_`union' = . if afl_comb_`union'_dens == .
    replace afl_locals_`union'      = . if afl_`union'_dens == .
}

foreach union in afl_comb_all afl_comb_sk afl_comb_unsk ///
                 afl_comb_ubc afl_comb_iam afl_comb_bmpiu afl_comb_itu afl_comb_umwa ///
                 afl_all afl_sk afl_unsk ///
                 afl_ubc afl_iam afl_bmpiu afl_ibt afl_itu afl_umwa {

    gen `union'_pres = (`union'_dens > 0) if `union'_dens != .
    bysort countynhg (year): gegen always_`union' = min(`union'_pres) if inlist(year,1900,1910,1920) & `union'_dens != .
    gen notalways_`union' = (always_`union' == 0) if always_`union' != .

    gen `union'_pres_1900_temp = (`union'_dens > 0) if `union'_dens != . & year == 1900
    bysort countynhg (year): gegen `union'_pres_1900_y = max(`union'_pres_1900_temp) if `union'_dens != .
    gen `union'_pres_1900_n = (`union'_pres_1900_y == 0) if `union'_pres_1900_y != .
}

rename afl_comb_locals_* afl_comb_*_locals
rename afl_locals_*      afl_*_locals


*------------------------------------------------------------------------------*
* Average membership per branch
*------------------------------------------------------------------------------*

foreach union in all sk unsk ubc iam bmpiu itu umwa {

    gen afl_comb_`union'_avgmemb = afl_comb_memb_`union' / afl_comb_`union'_locals if afl_comb_`union'_dens != .
    replace afl_comb_`union'_avgmemb = 0 if afl_comb_`union'_dens == 0
    gen afl_comb_`union'_ihs_avgmemb = asinh(afl_comb_`union'_avgmemb)

    gen afl_`union'_avgmemb = afl_memb_`union' / afl_`union'_locals if afl_`union'_dens != .
    replace afl_`union'_avgmemb = 0 if afl_`union'_dens == 0
    gen afl_`union'_ihs_avgmemb = asinh(afl_`union'_avgmemb)
}


*------------------------------------------------------------------------------*
* Combined delegate origins
*
* For each origin definition (bpl = birthplace, anc = ancestry), the combined
* count adds the per-union convention counts (UBC, IAM, BMPIU, UMWA) to the
* AFL state-convention count, netting out the AFL component already attributed
* to those unions, and divides by the combined total to form origin shares.
*------------------------------------------------------------------------------*

foreach j in bpl anc {

    rename *_`j'_euronw* *_`j'_eunw*
    rename *_`j'_eurose* *_`j'_euse*
    rename *_`j'_euro*   *_`j'_eu*
    rename *_`j'_other*  *_`j'_oth*

    gen afl_comb_del_`j'_denom = afl_del_`j'_denom + ///
                                 afl_comb_ubc_del_`j'_denom   - afl_ubc_del_`j'_denom + ///
                                 afl_comb_iam_del_`j'_denom   - afl_iam_del_`j'_denom + ///
                                 afl_comb_bmpiu_del_`j'_denom - afl_bmpiu_del_`j'_denom + ///
                                 afl_comb_umwa_del_`j'_denom  - afl_umwa_del_`j'_denom

    foreach group in oth eu eunw euse {
        gen afl_comb_del_`j'_`group' = afl_del_`j'_`group' + ///
                                       afl_comb_ubc_del_`j'_`group'   - afl_ubc_del_`j'_`group' + ///
                                       afl_comb_iam_del_`j'_`group'   - afl_iam_del_`j'_`group' + ///
                                       afl_comb_bmpiu_del_`j'_`group' - afl_bmpiu_del_`j'_`group' + ///
                                       afl_comb_umwa_del_`j'_`group'  - afl_umwa_del_`j'_`group'

        gen afl_comb_del_sh_`j'_`group' = afl_comb_del_`j'_`group' / afl_comb_del_`j'_denom
        replace afl_comb_del_sh_`j'_`group' = 0 if afl_comb_del_`j'_denom == 0
    }
}

foreach j in bpl {

    rename *_`j'_native* *_`j'_nat*

    foreach group in nat {
        gen afl_comb_del_`j'_`group' = afl_del_`j'_`group' + ///
                                       afl_comb_ubc_del_`j'_`group'   - afl_ubc_del_`j'_`group' + ///
                                       afl_comb_iam_del_`j'_`group'   - afl_iam_del_`j'_`group' + ///
                                       afl_comb_bmpiu_del_`j'_`group' - afl_bmpiu_del_`j'_`group' + ///
                                       afl_comb_umwa_del_`j'_`group'  - afl_umwa_del_`j'_`group'

        gen afl_comb_del_sh_`j'_`group' = afl_comb_del_`j'_`group' / afl_comb_del_`j'_denom
        replace afl_comb_del_sh_`j'_`group' = 0 if afl_comb_del_`j'_denom == 0
    }
}


*------------------------------------------------------------------------------*
* Immigrant-share interaction terms
*
* sh_wa_<group> is the within-European share of arrivals from a given country
* group; the interaction sh_euro_wa_<group> scales the immigrant share by it,
* with the instrumented counterpart built from the 1890 predicted shares.
*------------------------------------------------------------------------------*

foreach i in oldsend newsend prot nonprot nonsoc10 nonsoc20 soc10 soc20 ///
             nonsoc10r nonsoc20r soc10r soc20r lingclose lingfar unionh unionl {
    gen sh_wa_`i' = `i'_wa_10yr_m / euro_wa_10yr_m
    replace sh_wa_`i' = 0 if euro_wa_10yr_m == 0
    gen pr1890_sh_wa_`i' = pr1890_`i'_wa_10yr_m / pr1890_euro_wa_10yr_m
    replace pr1890_sh_wa_`i' = 0 if pr1890_euro_wa_10yr_m == 0
}

foreach i in oldsend newsend prot nonprot nonsoc10 nonsoc20 soc10 soc20 ///
             nonsoc10r nonsoc20r soc10r soc20r lingclose lingfar unionh unionl {
    gen sh_euro_wa_`i' = sh_euro_wa_10yr_m * sh_wa_`i'
    gen pr1890_sh_euro_wa_`i' = pr1890_sh_euro_wa_10yr_m * pr1890_sh_wa_`i'
}

label var sh_euro_wa_oldsend "Immigrant Share x Fr. Old Countries"
label var sh_euro_wa_prot    "Immigrant Share x Fr. Protestant"
label var sh_euro_wa_unionh  "Immigrant Share x Fr. Unions Experience"


*------------------------------------------------------------------------------*
* Winsorize and transform locals
*------------------------------------------------------------------------------*

foreach var of varlist afl_*_dens afl_*_locperlf afl_*_locals afl_*_avgmemb {
    winsor2 `var', cuts(1 99) replace
}

foreach union in all sk unsk ubc iam bmpiu itu umwa {
    gen afl_comb_`union'_ihsloc = asinh(afl_comb_`union'_locals)
    gen afl_comb_`union'_logloc = log(1 + afl_comb_`union'_locals)
    gen afl_`union'_ihsloc = asinh(afl_`union'_locals)
    gen afl_`union'_logloc = log(1 + afl_`union'_locals)
}
