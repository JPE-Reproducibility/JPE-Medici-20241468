*==============================================================================*
* 00_master_build.do   —   build-stage driver (documents how the deposited aggregates were built; not run by replicators)
*
* Runs every construction step that reads a non-shippable source (IPUMS
* complete-count microdata, ICPSR) or needs a manual step (ArcGIS geocoding,
* secure-server environment). Each script writes its deliverable -- a county
* (or national) aggregate -- into data/public/, which is what the runnable
* pipeline (code/00_master.do) then reads. A replicator cannot run this stage
* (the raw inputs are not in the deposit); it documents how the shipped
* aggregates were produced and lets the author rebuild them.
*
* Reads from : data/_raw_local/ -- non-shippable inputs (IPUMS complete-count
*              microdata, ICPSR) and the geocoded union sources ($unionsrc),
*              all excluded from the deposit zip.
* Writes to  : data/public/  (the shipped aggregates: census_aggregates/,
*              foreignborn_byorigin/, unions/, IPUMS_surname_aggregates/).
*==============================================================================*

clear all
set more off

global root "set-this-to-the-replication-package-path"
global build "$root/build_documentation/scripts"

* --- logging — timestamped text log + a dated banner before each script -------*
* runstep wraps `do` so per-script runtimes can be read straight off the log.
cap mkdir "$root/output"
cap mkdir "$root/output/logs"
cap log close
log using "$root/output/logs/00_master_build.log", replace text

capture program drop runstep
program define runstep
    di as result _n(2) "{hline 78}" _n `"[`=c(current_date)' `=c(current_time)'] running `0'"' _n "{hline 78}"
    do `0'
end

* --- package dependencies — install if missing ------------------------------*
* SSC packages the build stage relies on: gtools (gcollapse/gegen — the fast
* collapses b8-b15 use); geoinpoly (point-in-polygon assignment of geocoded
* union/IWW/KoL locals to 1930 county boundaries, b3-b6); shp2dta (converts the
* 1930 county shapefile geoinpoly reads). ftools is a gtools dependency. `cap`
* on the install so an already-present or unreachable package warns rather than
* halting the run. (On a secure server without SSC access, pre-install these.)
local packages ftools gtools geoinpoly shp2dta
foreach pkg of local packages {
    cap which `pkg'
    if _rc cap ssc install `pkg', replace
}

* --- census aggregates (IPUMS complete-count) + elections (ICPSR) ------------
runstep "$build/b1_census_base.do"           // IPUMS full count
runstep "$build/b2_census_immigration.do"    // IPUMS full count
runstep "$build/b3_census_occupations.do"    // IPUMS full count
runstep "$build/b4_census_industries.do"     // IPUMS full count
runstep "$build/b5_census_population.do"     // IPUMS full count
runstep "$build/b6_census_segregation.do"    // IPUMS full count, 1880
runstep "$build/b7_economic_railroads.do"    // IPUMS full count + ICPSR 2896
runstep "$build/b8_elections.do"             // ICPSR 1

* --- surname / union aggregates (manual ArcGIS, restricted, or secure-server sources) --
runstep "$build/b9_names.do"                 // restricted names (secure server); must precede b10-b12
runstep "$build/b10_aflstateconv.do"         // manual ArcGIS
runstep "$build/b11_natunions.do"            // manual ArcGIS
runstep "$build/b12_unions_combine.do"       // AFL + nationals -> combined union counts
runstep "$build/b13_iww.do"                  // copyright source + manual ArcGIS
runstep "$build/b14_kol.do"                  // ICPSR 29 + manual ArcGIS

* --- national foreign-born-by-origin series (appendix Figure A.1) ------------
runstep "$build/b15_byorigin.do"             // IPUMS full count 1850-1920 + ICPSR 2896 (1890)

* --- copy the deposit-boundary county aggregates into data/public ------------
runstep "$build/b16_ship_aggregates.do"      // $intmdata census aggregates -> data/public/census_aggregates

cap log close
