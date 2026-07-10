*------------------------------------------------------------------------------*
* 00_master.do
*
* Master orchestrator for the replication package of
*   "Closing Ranks: Organized Labor and Immigration"
*   (Journal of Political Economy, MS 20241468)
*
* Running this file end-to-end reproduces every table and figure in the paper
* from the data shipped under data/public/. The county and national aggregates
* it reads are produced by the build stage in build_documentation/ (driver
* 00_master_build.do), which is not part of this pipeline: those scripts read
* sources that cannot travel in the deposit -- IPUMS complete-count microdata
* and ICPSR studies (the census/elections/by-origin aggregates), the IWW and
* Knights-of-Labor county aggregates, the AFL and per-national-union county
* aggregates (UMWA, UBC, IAM, BMPIU, ITU), and the surname origin/ancestry
* tabulations from the IPUMS Restricted Full Count with Names. See the README
* Data Availability Statement. A replicator runs only this file.
*
* Software: run under Stata 19.5 (the version the deposited results were produced
*           under). `version 17` is set below for syntax compatibility and does not
*           change numerical results. weakivtest2 (Lewis-Mertens effective F)
*           requires Stata 17+ and the SSC commands weakivtest/avar/distinct.
*           Coefficients and figures reproduce on any recent release; on releases
*           other than 19.5 the cluster-robust SEs and weak-IV F-statistics may
*           differ in the last reported digit (numerical-library differences), with
*           no effect on point estimates or conclusions.
*
* -- To run --
* 1. Set the path under "global root" below to the location of this
*    replication package on your machine.
* 2. Run this file.
*------------------------------------------------------------------------------*

clear all
set more off, perm
set maxvar 120000, perm
version 17
set scheme s2color   // published figures use the legacy s2color scheme; Stata 18+
                     // defaults to stcolor, so set it explicitly for reproducibility


*------------------------------------------------------------------------------*
* 1. Paths
*------------------------------------------------------------------------------*

global root "set-this-to-the-replication-package-path"
* (Set the path above to the local path of the replication package.)

global code      "$root/code"
global rawdata   "$root/data/public"
global intmdata  "$root/data/intermediate"
global data      "$root/data/clean"
global output    "$root/output"
global tables    "$output/tables"
global figures   "$output/figures"

cap mkdir "$intmdata"
cap mkdir "$data"
cap mkdir "$output"
cap mkdir "$tables"
cap mkdir "$figures"

* Intermediate data is kept flat; the one subfolder holds the restricted-names
* tabulations, which are conceptually separate from the census intermediates.
cap mkdir "$intmdata/IPUMS_surname_aggregates"


*------------------------------------------------------------------------------*
* Logging — a timestamped text log of the whole run. runstep wraps `do` and
* prints a dated banner before each script, so per-step runtimes can be read
* straight off the log.
*------------------------------------------------------------------------------*
cap mkdir "$output/logs"
cap log close
log using "$output/logs/00_master.log", replace text

capture program drop runstep
program define runstep
    di as result _n(2) "{hline 78}" _n `"[`=c(current_date)' `=c(current_time)'] running `0'"' _n "{hline 78}"
    do `0'
end


*------------------------------------------------------------------------------*
* 2. Package dependencies — install if missing
*------------------------------------------------------------------------------*

* SSC packages used by the runnable pipeline. ivreg2/ranktest are dependencies
* of ivreghdfe; grc1leg2 (combined-legend graphs) and weakivtest2 (Lewis-Mertens
* effective F) are used in 2_analysis; weakivtest2 in turn calls weakivtest, which
* requires avar. `cap` on the install so a single unavailable package warns rather
* than halting the whole run.
local packages ftools gtools reghdfe ivreghdfe ivreg2 ranktest outreg2 coefplot ///
               grc1leg2 weakivtest2 weakivtest avar distinct estout grstyle palettes colrspace fre egenmore ///
               acreg spmap binscatter hdfe winsor2 shp2dta geoinpoly
foreach pkg of local packages {
    cap which `pkg'
    if _rc cap ssc install `pkg', replace
}
cap reghdfe, compile    // compile reghdfe's Mata library


*------------------------------------------------------------------------------*
* 3. Construction — assemble the analysis dataset
*------------------------------------------------------------------------------*

* The census, elections, and by-origin county/national aggregates that
* 1b_merge_preadjust merges are built offline by the build_documentation/ stage and ship
* under data/public/census_aggregates/ (and data/public/foreignborn_byorigin/);
* this pipeline reads them, it does not rebuild them.
runstep "$code/1_construction/1a_reference_inputs.do"
runstep "$code/1_construction/1b_merge_preadjust.do"
runstep "$code/1_construction/1c_boundary_adjustment.do"
runstep "$code/1_construction/1d_county_panel.do"
runstep "$code/1_construction/1e_weather_shocks.do"
runstep "$code/1_construction/1f_shiftshare.do"
runstep "$code/1_construction/1g_crowdout.do"
runstep "$code/1_construction/1h_final_dataset.do"


*------------------------------------------------------------------------------*
* 4. Analysis — tables and figures
*------------------------------------------------------------------------------*

runstep "$code/2_analysis/2a_sumstats.do"
runstep "$code/2_analysis/2b_figures_descriptives.do"
runstep "$code/2_analysis/2c_results_main.do"
runstep "$code/2_analysis/2d_results_extra.do"
runstep "$code/2_analysis/2e_results_robustness.do"
runstep "$code/2_analysis/2f_rotemberg_weights.do"


*------------------------------------------------------------------------------*
* 5. Remove the outreg2 .txt byproducts (the tables are saved as .xml). The
* per-table erases in 2a-2f clear these; this final sweep removes any that remain.
*------------------------------------------------------------------------------*
foreach pat in "*.txt" "*.tmp" {
    local byproducts : dir "$root/output/tables" files "`pat'"
    foreach f of local byproducts {
        cap erase "$root/output/tables/`f'"
    }
}


*------------------------------------------------------------------------------*
di as result _newline "Master orchestrator complete."
*------------------------------------------------------------------------------*
cap log close
