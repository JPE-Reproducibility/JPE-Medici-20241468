*==============================================================================*
* b6_census_segregation.do
*
* Builds the county-level inputs to the 1880 residential-segregation index of
* European immigrants (Logan and Parman 2017; see Appendix D of the paper).
* Working at the household-head level in IPUMS full-count 1880 microdata, it
* identifies each household's next-door neighbors -- the household heads at
* the adjacent census serial numbers within the same enumeration district --
* and counts, per county, how many European-immigrant households have a
* native-born next-door neighbor. The index itself is assembled downstream.
*
* INPUT  (in $rawlocal/):
*   IPUMS/IPUMS_fullcount_1880.dta  - IPUMS full-count census microdata.
*                                     Not shipped; see the README.
*
* OUTPUT (in $intmdata/; b16 ships these to data/public/census_aggregates/):
*   resid_segr_1880.dta  - county counts feeding the residential-segregation
*                          index; read by 1b_merge_preadjust.
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
* Residential segregation: next-door-neighbor counts, 1880
*------------------------------------------------------------------------------*

* Household heads only (relate == 1): the segregation index is defined over
* households, each represented by its head.
use year relate serial stateicp countyicp countynhg bpl nativity enumdist supdist ///
    if relate == 1 ///
    using "$rawlocal/IPUMS/IPUMS_fullcount_1880.dta", clear

* Household groups, following Logan and Parman (2017) adapted to immigration:
* European foreign-born, U.S.-born of U.S.-born parents, and all others.
gen euro_hh   = (inrange(bpl,400,465) == 1)
gen nat_np_hh = (bpl < 150 & nativity == 1)
gen other_hh  = (euro_hh == 0 & nat_np_hh == 0)
gen all_hh    = 1

* Next-door neighbors are the households at the adjacent serial numbers.
* Census serial numbers run in enumeration order, so xtset by serial lets the
* l1/f1 operators reach the previous/next household; a neighbor counts only if
* it falls in the same enumeration district (enum).
xtset year serial
gegen enum = group(stateicp enumdist supdist)

* For each European-immigrant household, flag (a) whether a next-door neighbor
* is U.S.-born of U.S.-born parents, and (b) whether it has two next-door
* neighbors or only one -- households at an enumeration-district edge have a
* neighbor on one side only. The per-county sums of these flags feed the
* residential-segregation index assembled downstream.
gen euro_natneighb_enum = ((l1.nat_np_hh == 1 & enum == l1.enum) | (f1.nat_np_hh == 1 & enum == f1.enum)) if euro_hh == 1
gen euro_1neighb_enum   = ((l1.serial == . | enum != l1.enum) | (f1.serial == . | enum != f1.enum))       if euro_hh == 1
gen euro_2neighb_enum   = ((l1.serial != . & enum == l1.enum) & (f1.serial != . & enum == f1.enum))       if euro_hh == 1

gcollapse (sum) euro_hh euro_natneighb_enum euro_1neighb_enum euro_2neighb_enum other_hh all_hh, ///
         by(stateicp countyicp countynhg year)

save "$intmdata/resid_segr_1880.dta", replace
