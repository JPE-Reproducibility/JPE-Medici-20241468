*==============================================================================*
* b16_ship_aggregates.do   (build stage — final step)
*
* Exports the county aggregates that the runnable pipeline consumes from the
* build stage's working area ($intmdata) into the shipped folder
* data/public/census_aggregates/, as CSV (open format, JPE section 1.4). These
* are the deposit-boundary files: a replicator gets them in the package and
* never re-runs b1-b15. 1b_merge_preadjust.do converts the CSVs back to .dta at
* the top of its run; 1h_final_dataset.do imports cpi_u directly. Run after
* b1-b15 in 00_master_build.do. (b15_byorigin writes its CSV straight to
* data/public/foreignborn_byorigin/, so it is not handled here.)
*
* The set below is exactly what 1b_merge_preadjust.do and 1h_final_dataset.do
* read. The confirm-file guard skips census years a given build run did not
* produce (e.g. there is no 1930 industry file) rather than erroring.
*==============================================================================*

clear all
set more off

if "$root" == "" global root "set-this-to-the-replication-package-path"
global intmdata  "$root/data/intermediate"
global censusagg "$root/data/public/census_aggregates"
cap mkdir "$censusagg"

* Year-varying county aggregates (b1-b5) + the 1890 ICPSR population (b7)
foreach year in 1880 1890 1900 1910 1920 1930 {
    foreach f in IPUMS_`year'_county              ///
                 IPUMS_`year'_euroimm_county       ///
                 IPUMS_`year'_ind1950counts_county ///
                 IPUMS_`year'_occ_county_m         ///
                 IPUMS_`year'_population_county     ///
                 ICPSR_`year'_population_county {
        cap confirm file "$intmdata/`f'.dta"
        if !_rc {
            use "$intmdata/`f'.dta", clear
            export delimited "$censusagg/`f'.csv", nolabel replace
        }
    }
}

* Static aggregates (b8 elections, b6 segregation, b7 economic/census)
foreach f in electionresults_1856_county      ///
             electionresults_1886-1924_county ///
             resid_segr_1880                  ///
             agri_census_1890                 ///
             mfg_census                       ///
             mines_census_1890                ///
             cpi_u                            ///
             railroad_connection_1930countyboundaries {
    cap confirm file "$intmdata/`f'.dta"
    if !_rc {
        use "$intmdata/`f'.dta", clear
        export delimited "$censusagg/`f'.csv", nolabel replace
    }
}
