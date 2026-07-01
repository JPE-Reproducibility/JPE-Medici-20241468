*==============================================================================*
* b15_byorigin.do   (build stage — not part of the runnable pipeline)
*
* Builds data/public/foreignborn_byorigin/ustotals_byorigin_1850-1920.csv, the
* US foreign-born stock by region of origin used for appendix Figure A.1
* (immigrmix_1850-1920.pdf). The runnable pipeline imports this CSV in
* 1a_reference_inputs.do (which derives `other`, labels, and asserts the
* adding-up identity); this build script is its producer.
*
* Method. Seven census years with surviving microdata (1850-1880, 1900-1920)
* are read from the IPUMS complete-count files, birthplace (bpl) is recoded into
* four origin regions, and the data are collapsed to national totals. 1890 has
* no microdata (the schedules were destroyed) and is built from the published
* 1890 county table in ICPSR 02896 (county/state file DS0018), summing the
* county rows to the nation under the identical region rule.
*
* Region rule (bpl ranges follow the IPUMS BPL codes; Germany is counted
* with Northwest Europe, matching the 1890 country detail):
*   northwest_europe = northEU(400-419) + westEU(420-429) + Germany(453)
*   southeast_europe = southEU(430-440) + cen/east EU(450-459 ex-453)
*                                       + Russian Empire(460-465)
*   canada_australia = Canada(150) + St-Pierre(155) + Australia/NZ(700)
*   other            = residual (built in 1a)
*
* Validation: the full-count tabulation matches the Census foreign-born-by-origin
* counts to the person for 1880 (Canada+Australia differs by 1); the ICPSR 1890
* figures match exactly. totpop is the IPUMS-counted population.
*
* INPUTS (pointer raw under data/_raw_local/, excluded from the deposit zip):
*   IPUMS/IPUMS_fullcount_<year>.dta   - complete count, 1850/60/70/80/1900/10/20
*   ICPSR_02896/DS0018/02896-0018-Data.dta - ICPSR 02896, 1890 county file
*
* OUTPUT (shipped):
*   data/public/foreignborn_byorigin/ustotals_byorigin_1850-1920.csv
*==============================================================================*

clear all
set more off

if "$root" == "" global root "set-this-to-the-replication-package-path"
global rawdata  "$root/data/public"          // shipped package data (read by the pipeline)
global rawlocal "$root/data/_raw_local"   // unshippable raw (IPUMS micro, ICPSR); excluded from deposit zip
global pubdir   "$rawdata/foreignborn_byorigin"
cap mkdir "$pubdir"

local icpsr1890 "$rawlocal/ICPSR_02896/DS0018/02896-0018-Data.dta"


*------------------------------------------------------------------------------*
* Microdata years: recode bpl and collapse to national origin totals
*------------------------------------------------------------------------------*

tempfile master
local first = 1

foreach year in 1850 1860 1870 1880 1900 1910 1920 {

    use year perwt bpl using "$rawlocal/IPUMS/IPUMS_fullcount_`year'.dta", clear

    * birthplace groups (bpl ranges follow the IPUMS BPL codes)
    gen byte northEU   = inrange(bpl,400,419)   // Scandinavia, British Isles, N Eur n.s.
    gen byte westEU    = inrange(bpl,420,429)   // France, Benelux, Switzerland, W Eur n.s.
    gen byte germany   = bpl == 453
    gen byte southEU   = inrange(bpl,430,440)   // Italy, Greece, Iberia, S Eur n.s.
    gen byte ceneastEU = inrange(bpl,450,459)   // Austria, Hungary, Czech, Poland, ... (incl. Germany 453)
    gen byte russempEU = inrange(bpl,460,465)   // Russia, Baltics

    * four figure regions; Germany (453) sits in NW, not cen/east
    gen byte foreignborn      = bpl > 120
    gen byte northwest_europe = northEU | westEU | germany
    gen byte southeast_europe = southEU | (ceneastEU & !germany) | russempEU
    gen byte canada_australia = inlist(bpl,150,155,700)
    gen double totpop         = 1

    gcollapse (sum) totpop foreignborn northwest_europe southeast_europe ///
                   canada_australia [pw=perwt], by(year)

    if `first' {
        save "`master'", replace
        local first = 0
    }
    else {
        append using "`master'"
        save "`master'", replace
    }
}


*------------------------------------------------------------------------------*
* 1890: ICPSR 02896 county file (DS0018), summed to the nation
*------------------------------------------------------------------------------*

use "`icpsr1890'", clear
keep if level == 1                              // county rows (2 = state, 3 = US total)

gcollapse (sum) totpop fbmtot fbftot                                            ///
    pbdenmar pbnorway pbnorden pbsweden pbenglan pbscot pbwales pbirelan        ///
    pbgerman pbfrance pbbelg pbhollan pbswitz pbluxemb                          ///
    pbaustri pbbohem pbhungar pbpoland pbrussia pbitaly pbgreece pbspain pbportug ///
    pbcanada pbaustra

gen double foreignborn      = fbmtot + fbftot
gen double northwest_europe = pbdenmar + pbnorway + pbnorden + pbsweden +       ///
                              pbenglan + pbscot + pbwales + pbirelan +          ///
                              pbgerman +                                        ///
                              pbfrance + pbbelg + pbhollan + pbswitz + pbluxemb
gen double southeast_europe = pbaustri + pbbohem + pbhungar + pbpoland + pbrussia + ///
                              pbitaly + pbgreece + pbspain + pbportug
gen double canada_australia = pbcanada + pbaustra
gen int    year             = 1890

keep year totpop foreignborn canada_australia northwest_europe southeast_europe
append using "`master'"


*------------------------------------------------------------------------------*
* Finalize and export the public CSV (1a_reference_inputs.do imports it, derives
* `other`, labels, and asserts the adding-up identity)
*------------------------------------------------------------------------------*

sort year
order year totpop foreignborn canada_australia northwest_europe southeast_europe

foreach v of varlist totpop foreignborn canada_australia northwest_europe southeast_europe {
    replace `v' = round(`v')
    recast long `v', force
}

assert _N == 8
assert !missing(year, totpop, foreignborn, canada_australia, northwest_europe, southeast_europe)
assert canada_australia + northwest_europe + southeast_europe <= foreignborn

export delimited using "$pubdir/ustotals_byorigin_1850-1920.csv", replace
