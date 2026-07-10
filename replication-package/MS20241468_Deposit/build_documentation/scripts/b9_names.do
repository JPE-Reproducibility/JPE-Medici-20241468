*==============================================================================*
* b9_names.do
*
* One-time prep script. Builds the surname-level origin and ancestry
* tabulations from the IPUMS Restricted Full Count with Names. For census
* years 1900, 1910, and 1920 it reads the restricted person-level microdata,
* classifies each man by his own and his father's birthplace, and collapses to
* one row per surname giving, for each European-origin group, the share of men
* with that surname in that group.
*
* The outputs are aggregates -- surname-level counts and shares, with no
* person records -- which IPUMS permits redistributing (unlike the raw
* microdata). They ship under data/public/IPUMS_surname_aggregates/ and are
* inputs to the analysis pipeline; this script documents how they were
* produced. It runs only inside the secure-server environment (the
* restricted microdata is available nowhere else) and so is not invoked by the
* main pipeline driver. Each restricted .dat is read straight through to the
* aggregates; the multi-GB person-level intermediates are never written.
*
* Input (secure server):
*   <ipums_root>/<year>_2.5/<file>.dat  - IPUMS Restricted Full Count w/ Names
*
* Outputs (export, via disclosure review, to data/public/IPUMS_surname_aggregates/):
*   names_origin.dta    - surname x origin shares  (one row per year x surname)
*   names_ancestry.dta  - surname x ancestry shares (one row per surname)
*==============================================================================*

clear all
set more off

*-- Secure-server paths -- set these for the secure-server environment.
local ipums_root "<path-to-restricted-fullcount-name-extracts>"     // folder holding the restricted .dat files
local outdir     "<path-to-output-folder-for-surname-aggregates>"   // the two surname aggregates are written here

*-- Year-to-filename mapping (the .dat filename differs by year).
local f1900 "us1900m_usa_res"
local f1910 "us1910m_usa_res"
local f1920 "us1920c_usa_res"
local f1930 "us1930d_usa_res"   // used for the origin tabulation only


*------------------------------------------------------------------------------*
* Per-year extraction and surname classification
*------------------------------------------------------------------------------*

foreach year in 1900 1910 1920 1930 {

di as result _newline "*** Processing `year' ***"

clear                                    // drop the prior year's data: infix requires an empty dataset

tempfile origin_`year' ancestry_`year'

* Read the restricted full-count-with-names microdata. Column positions
* (record type, sex, birthplace, father's birthplace, last name) are the same
* across years; verified against the IPUMS layout do-files.
quietly infix                            ///
    str  rectype   1-1                   ///
    byte sex       61-61                 ///
    long bpl       73-77                 ///
    long fbpl      2332-2336             ///
    str  namelast  1756-1826             ///
    using "`ipums_root'/`year'_2.5/`f`year''.dat"

keep if rectype == "P"                                  // person records only
drop rectype
gen year = `year'
keep if sex == 1                                        // men
compress


*------------------------------------------------------------------------------*
* Origin: classify every man by his own or his father's birthplace
*------------------------------------------------------------------------------*

preserve

* Put birthplaces on the general 3-digit scale used by the classification below.
* IPUMS DETAILED codes are 5-digit (e.g. 45312 Bavaria -> 453 Germany) and are
* floored; older general-coded extracts are already 3-digit and need no change.
* Detect which by the maximum code (detailed foreign codes are >= 10000).
qui summarize bpl
if r(max) >= 10000 {
    replace bpl  = floor(bpl/100)
    replace fbpl = floor(fbpl/100)
}

* Origin = own country of birth only, over the entire male population. Per the paper's
* Appendix (app:names_delegates), the birthplace mapping does not use the father's
* birthplace -- that is the ancestry measure, constructed separately below. So U.S.-born
* counts a man's own U.S. birth regardless of his father's birthplace.
gen euro   = (inrange(bpl,400,465))
gen native = (bpl < 100)
gen other  = (euro == 0 & native == 0)

* Birthplace-country dummies: own birthplace only.
gen denmark     = (bpl == 400)
gen finland     = (bpl == 401)
gen norway      = (bpl == 404)
gen sweden      = (bpl == 405)
gen uk          = (inrange(bpl,410,413))
gen ireland     = (bpl == 414)
gen oth_northeu = (inlist(bpl,402,403,419))
gen belgium     = (bpl == 420)
gen france      = (bpl == 421)
gen luxemb      = (bpl == 423)
gen nether      = (bpl == 425)
gen switz       = (bpl == 426)
gen oth_westeu  = (inlist(bpl,422,424,429))
gen italy       = (bpl == 434)
gen gr_pt_es    = (inlist(bpl,433,436,438))
gen oth_southeu = (inlist(bpl,430,431,432,435,437,439,440))
gen aus_hung    = (inlist(bpl,450,454))
gen czech       = (bpl == 452)
gen germany     = (bpl == 453)
gen poland      = (bpl == 455)
gen oth_easteu  = (inlist(bpl,451,456,457,459))
gen oth_centereu= (inlist(bpl,458))
gen russia      = (bpl == 465)
gen oth_russeu  = (inlist(bpl,460,461,462,463))

* Standardize the surname so it matches the delegate names in the exact merge (b10/b11).
replace namelast = lower(namelast)
replace namelast = subinstr(namelast,"'","",.)
replace namelast = subinstr(namelast," ","",.)
replace namelast = subinstr(namelast,"st.","st",.)
replace namelast = subinstr(namelast,",","",.)
replace namelast = subinstr(namelast,"-","",.)
replace namelast = subinstr(namelast,"_","",.)

* Count, per surname, the men in each group; nameprob_* is the share.
gen tot = 1
gcollapse (sum) native other ///
                denmark finland norway sweden uk ireland oth_northeu ///
                belgium france luxemb nether switz oth_westeu ///
                italy gr_pt_es oth_southeu ///
                aus_hung czech germany poland oth_easteu oth_centereu ///
                russia oth_russeu ///
                tot, by(year namelast)

foreach group in native other ///
                 denmark finland norway sweden uk ireland oth_northeu ///
                 belgium france luxemb nether switz oth_westeu ///
                 italy gr_pt_es oth_southeu ///
                 aus_hung czech germany poland oth_easteu oth_centereu ///
                 russia oth_russeu {
    gen nameprob_`group' = `group' / tot
}

save "`origin_`year''"

restore

* 1930 is tabulated for origin only -- the year-specific birthplace bracket used to
* interpolate 1920 delegate composition for counties without a 1920 convention. The
* ancestry measure pools surnames across 1900-1920, so 1930 is not added to it.
if "`year'" == "1930" continue


*------------------------------------------------------------------------------*
* Ancestry: classify men born abroad (or with a foreign-born father)
*------------------------------------------------------------------------------*

* Restrict to men born abroad or with a foreign-born father, then put codes on
* the general 3-digit scale. Detailed extracts mark foreign codes with >= 10000
* and are floored; older general-coded extracts already use >= 100 and need no
* conversion. Detect which by the maximum code.
qui summarize bpl
if r(max) >= 10000 {
    keep if bpl >= 10000 | fbpl >= 10000
    replace bpl  = floor(bpl/100)
    replace fbpl = floor(fbpl/100)
}
else {
    keep if bpl >= 100 | fbpl >= 100
}

keep if bpl > 100 | fbpl > 100                          // born abroad, or foreign-born father
drop if bpl > 100 & fbpl <= 100                         // exclude foreign-born men of a U.S.-born father
drop if fbpl == 150 & (bpl < 100 | bpl == 150)          // exclude U.S./Canada-born men of a Canadian father

* Ancestry = own birthplace, or the father's if the man is U.S./Canada-born.
clonevar ancestry = bpl
replace  ancestry = .
replace  ancestry = bpl  if bpl  >= 100
replace  ancestry = fbpl if fbpl >= 100 & (bpl < 100 | bpl == 150)

gen euro  = (inrange(ancestry,400,465) == 1)
gen other = (inrange(ancestry,400,465) == 0)

gen denmark     = (ancestry == 400)
gen finland     = (ancestry == 401)
gen norway      = (ancestry == 404)
gen sweden      = (ancestry == 405)
gen uk          = (inrange(ancestry,410,413))
gen ireland     = (ancestry == 414)
gen oth_northeu = (inlist(ancestry,402,403,419))
gen belgium     = (ancestry == 420)
gen france      = (ancestry == 421)
gen luxemb      = (ancestry == 423)
gen nether      = (ancestry == 425)
gen switz       = (ancestry == 426)
gen oth_westeu  = (inlist(ancestry,422,424,429))
gen italy       = (ancestry == 434)
gen gr_pt_es    = (inlist(ancestry,433,436,438))
gen oth_southeu = (inlist(ancestry,430,431,432,435,437,439,440))
gen aus_hung    = (inlist(ancestry,450,454))
gen czech       = (ancestry == 452)
gen germany     = (ancestry == 453)
gen poland      = (ancestry == 455)
gen oth_easteu  = (inlist(ancestry,451,456,457,459))
gen oth_centereu= (inlist(ancestry,458))
gen russia      = (ancestry == 465)
gen oth_russeu  = (inlist(ancestry,460,461,462,463))

* Standardize the surname (as in the origin pass).
replace namelast = lower(namelast)
replace namelast = subinstr(namelast,"'","",.)
replace namelast = subinstr(namelast," ","",.)
replace namelast = subinstr(namelast,"st.","st",.)
replace namelast = subinstr(namelast,",","",.)
replace namelast = subinstr(namelast,"-","",.)
replace namelast = subinstr(namelast,"_","",.)

save "`ancestry_`year''"

}


*------------------------------------------------------------------------------*
* names_origin: pool the per-year surname tabulations
*------------------------------------------------------------------------------*

clear
foreach year in 1900 1910 1920 1930 {
append using "`origin_`year''"
}

rename nameprob_* nameprob_bpl_*                 // ship self-describing prefixed names (origin = own birthplace)
save "`outdir'/names_origin.dta", replace


*------------------------------------------------------------------------------*
* names_ancestry: pool the per-year person files, then collapse by surname
*------------------------------------------------------------------------------*

clear
foreach year in 1900 1910 1920 {
append using "`ancestry_`year''"
}

gen tot = 1
gcollapse (sum) other ///
                denmark finland norway sweden uk ireland oth_northeu ///
                belgium france luxemb nether switz oth_westeu ///
                italy gr_pt_es oth_southeu ///
                aus_hung czech germany poland oth_easteu oth_centereu ///
                russia oth_russeu ///
                tot, by(namelast)

foreach group in other ///
                 denmark finland norway sweden uk ireland oth_northeu ///
                 belgium france luxemb nether switz oth_westeu ///
                 italy gr_pt_es oth_southeu ///
                 aus_hung czech germany poland oth_easteu oth_centereu ///
                 russia oth_russeu {
    gen nameprob_`group' = `group' / tot
}

rename nameprob_* nameprob_anc_*                 // ship self-describing prefixed names (ancestry-based)
save "`outdir'/names_ancestry.dta", replace
