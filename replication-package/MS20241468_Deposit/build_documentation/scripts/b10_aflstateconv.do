*==============================================================================*
* b10_aflstateconv.do
*
* One-time prep script. Builds the county-level dataset of American Federation
* of Labor (AFL) locals from hand-collected, geocoded AFL state-convention
* delegate records.
*
* Steps: (1) parse delegate surnames; (2) classify each delegate's likely
* birthplace and ancestry by surname (merge to the IPUMS name-probability
* tables); (3) impute each local's union membership from its delegate / vote
* count using each state federation's constitutional apportionment rules (the
* long state-by-state block); (4) split the measures by national union; and
* (5) collapse to 1930 counties.
*
* The output (AFL_members_county1930.csv, written to data/intermediate/) is a
* build intermediate: b12 combines it with the national-union aggregates into
* the shipped unions_combined_county1930.csv that the analysis pipeline reads.
* This script documents how it was produced; it is not invoked by the main
* pipeline driver.
* The delegate-level records are hand-collected and the geocoding step is
* manual, so a replicator cannot re-run the prep step end-to-end.
*
* Workflow:
*   manual - the AFL state-convention proceedings were digitized and the
*            local addresses geocoded with ArcGIS's "Geocode Addresses"
*            tool. The geocoded CSV is the input to this script.
*   main   - parse surnames, merge surname-origin/ancestry probabilities,
*            invert the state-federation apportionment rules to recover
*            membership, split the measures by national union, and
*            aggregate to 1930 county boundaries.
*
* Inputs (raw, shipped):
*   $rawdata/USmap_1930/US_county_1930_WGS84.shp
*   $rawdata/IPUMS_surname_aggregates/names_origin.dta    - surname x origin shares
*   $rawdata/IPUMS_surname_aggregates/names_ancestry.dta  - surname x ancestry shares
*
* Input (working file, not shipped):
*   $unionsrc/AFL_stateconv_delegates_geocoded.csv  - raw ArcGIS geocoded delegate
*       records (columns: score, shortlabel, addr_type, type, placename,
*       region, regionabbr, x, y, plus the original input columns prefixed
*       user_*). Match-score and state-region filtering happens inside.
*
* Output (build intermediate, in data/intermediate/):
*   AFL_members_county1930.csv  (combined into the shipped file by b12)
*==============================================================================*

clear all
set more off, perm

* $rawdata is the package's raw-input folder. $unionsrc is a working directory
* for this one-time prep script; the geocoded CSV input lives there but is
* not part of the shipped package.
if "$root" == "" global root "set-this-to-the-replication-package-path"
global rawdata "$root/data/public"
global intmdata "$root/data/intermediate"
global unionsrc    "$root/data/_raw_local/union_sources"
cap mkdir "$unionsrc"


*------------------------------------------------------------------------------*
* Convert the 1930 county shapefile for geoinpoly (self-contained; output
* kept under $unionsrc, not in the package intermediate folder)
*------------------------------------------------------------------------------*

shp2dta using "$rawdata/USmap_1930/US_county_1930_WGS84.shp", ///
    database("$unionsrc/US_county_1930_WGS84_dbase")              ///
    coordinates("$unionsrc/US_county_1930_WGS84_coord") replace

use "$unionsrc/US_county_1930_WGS84_dbase", clear
gen countynhg_1930 = real(GISJOIN2)
save "$unionsrc/US_county_1930_WGS84_dbase_spmap.dta", replace


*------------------------------------------------------------------------------*
* Stash the IPUMS names tables in tempfiles. The shipped names_origin.dta /
* names_ancestry.dta carry self-describing prefixed columns -- nameprob_bpl_<group>
* (own/father birthplace) and nameprob_anc_<group> (ancestry) -- so the two
* families stay distinct and can coexist in the master after the ancestry merge
* without a wildcard collision.
*------------------------------------------------------------------------------*

tempfile names_bpl names_anc

use "$rawdata/IPUMS_surname_aggregates/names_origin.dta", clear
save `names_bpl'

use "$rawdata/IPUMS_surname_aggregates/names_ancestry.dta", clear
save `names_anc'


*------------------------------------------------------------------------------*
* Load delegate records: raw ArcGIS output, drop poorly-geocoded rows, then
* strip the geocoding columns
*------------------------------------------------------------------------------*

import delimited "$unionsrc/AFL_stateconv_delegates_geocoded.csv", clear

* Discard the ArcGIS columns we don't need; keep the score+region pair used
* for filtering, plus the original input columns (user_* prefix). The
* AFL raw data carries two state abbreviations per delegate row: `state`
* (the local union's state, used as the geocode address) and `state_source`
* (the state hosting the AFL convention, which is what the apportionment
* rules key on -- a delegate from MO attending a KS convention has
* state=MO but state_source=KS, and KS's 1920 rule applies). The
* geocode-quality block below uses `state`; the subsequent rename swaps
* `state_source` into `state` so the apportionment block reads correctly.
keep score shortlabel addr_type type placename regionabbr x y user_*
order user_*, first
rename user_* *

* Blank coordinates for low-quality matches (ArcGIS score < 85) and where
* the geocoded state abbreviation disagrees with the input state -- these
* are ArcGIS picking a same-named place in another state. AFL conventions
* were U.S.-domestic, so no foreign-country filter is needed. We do not
* filter on geocode `type`: when ArcGIS cannot pinpoint a city it returns
* the county centroid, which still lands the row in the correct county at
* the point-in-polygon step below.
* `state` here is the local union's state, used to validate the geocode
* against ArcGIS's `regionabbr`. The apportionment rules need the
* convention-host state, which is in `state_source`; the rename right
* below makes `state_source` the working `state' for the remainder of
* this script.
replace x = . if score < 85
replace y = . if score < 85
replace x = . if (state != regionabbr)
replace y = . if (state != regionabbr)

drop score shortlabel addr_type type placename regionabbr state
rename state_source state
rename x longitude
rename y latitude

* Drop rows that ended up with no usable coordinates (low-quality matches or
* discarded cross-state geocodes)
drop if longitude == . | latitude == .


* Isolate each delegate's last name: strip "jr"/"sr" suffixes and punctuation,
* and parse entries formatted "first; last" on the semicolon.
foreach var of varlist deleg_name_* {
	gen `var'_last = `var'
	replace `var'_last = subinword(`var'_last,"jr","",.)
	replace `var'_last = subinword(`var'_last,"sr","",.)
	replace `var'_last  = strtrim(stritrim(`var'_last))
	replace `var'_last = substr(`var'_last,strrpos(`var'_last," ")+1,strlen(`var'_last)-strrpos(`var'_last," ")) if strpos(`var'_last,"; ") == 0
	replace `var'_last = substr(`var'_last,strpos(`var'_last,"; ")+2,strlen(`var'_last)-strpos(`var'_last,"; ")-1) if strpos(`var'_last,"; ") > 0
	replace `var'_last = `var' if strpos(`var'," ") == 0 & `var'_last == ""
	replace `var'_last = subinstr(`var'_last,"'","",.)
	replace `var'_last = subinstr(`var'_last," ","",.)
	replace `var'_last = subinstr(`var'_last,"st.","st",.)
	replace `var'_last = subinstr(`var'_last,",","",.)
	replace `var'_last = subinstr(`var'_last,"-","",.)
	replace `var'_last = subinstr(`var'_last,"_","",.)	
	replace `var'_last = subinstr(`var'_last,":","",.)	
	replace `var'_last = subinstr(`var'_last,"(millmen)","",.)	
	replace `var'_last = subinstr(`var'_last,"`","",.)		
	replace `var'_last  = strtrim(stritrim(`var'_last))
} 

rename deleg_name_*_last deleg_lastname_*
drop deleg_name_*

gen id = _n
order id, first
reshape long deleg_lastname_, i(id) j(deleg_nr)
drop if deleg_lastname_ == ""

* Bucket each convention into a decade (1900 / 1910 / 1920 / 1930); conventions
* did not all fall on round years. The geocoded delegate records span convention
* years within +/-2 of each census year (1900-1902, 1908-1912, 1918-1922,
* 1928-1932), so every observation falls in exactly one bucket. year_orig keeps
* the actual convention year, which the state apportionment rules below key on.
clonevar year_orig = year
order year_orig, after(year)
replace year = 1900 if inrange(year,1900,1902) == 1
replace year = 1910 if inrange(year,1908,1912) == 1
replace year = 1920 if inrange(year,1918,1922) == 1
replace year = 1930 if inrange(year,1928,1932) == 1

*Merge last names (exact string matching) w/ probability of birthplace
rename deleg_lastname_ namelast
merge m:1 year namelast using `names_bpl', keepusing(nameprob_bpl_*)
drop if _merge == 2
drop _merge
foreach var of varlist nameprob_bpl_* {
	replace `var' = . if namelast == ""
}

*Merge last names (exact string matching) w/ ancestry
merge m:1 namelast using `names_anc', keepusing(nameprob_anc_*)
drop if _merge == 2
drop _merge
foreach var of varlist nameprob_anc_* {
	replace `var' = . if namelast == ""
}		

*Compute nr. of delegates from each group (natives or European) in a local, based on the last name of delegates
bysort id: gegen nr_del_bpl_native = total(nameprob_bpl_native), missing	

foreach j in bpl anc {
		
bysort id: gegen nr_del_`j'_other = total(nameprob_`j'_other), missing	
		
bysort id: gegen nr_del_`j'_euroall = total(nameprob_`j'_denmark nameprob_`j'_finland nameprob_`j'_norway ///
											nameprob_`j'_sweden nameprob_`j'_uk nameprob_`j'_ireland nameprob_`j'_oth_northeu ///
											nameprob_`j'_belgium nameprob_`j'_france nameprob_`j'_luxemb nameprob_`j'_nether ///
											nameprob_`j'_switz nameprob_`j'_oth_westeu ///
											nameprob_`j'_italy nameprob_`j'_gr_pt_es nameprob_`j'_oth_southeu ///
											nameprob_`j'_aus_hung nameprob_`j'_czech nameprob_`j'_germany nameprob_`j'_poland ///
											nameprob_`j'_oth_easteu nameprob_`j'_oth_centereu ///
											nameprob_`j'_russia nameprob_`j'_oth_russeu), missing	

bysort id: gegen nr_del_`j'_euronw = total(nameprob_`j'_denmark nameprob_`j'_finland nameprob_`j'_norway ///
											nameprob_`j'_sweden nameprob_`j'_uk nameprob_`j'_ireland nameprob_`j'_oth_northeu ///
											nameprob_`j'_belgium nameprob_`j'_france nameprob_`j'_luxemb nameprob_`j'_nether ///
											nameprob_`j'_switz nameprob_`j'_oth_westeu ///
											nameprob_`j'_germany), missing	
											
bysort id: gegen nr_del_`j'_eurose = total(nameprob_`j'_italy nameprob_`j'_gr_pt_es nameprob_`j'_oth_southeu ///
											nameprob_`j'_aus_hung nameprob_`j'_czech nameprob_`j'_poland ///
											nameprob_`j'_oth_easteu nameprob_`j'_oth_centereu ///
											nameprob_`j'_russia nameprob_`j'_oth_russeu), missing	
											
}

drop nameprob*
rename namelast deleg_namelast_
reshape wide deleg_namelast_, i(id) j(deleg_nr)
order deleg_namelast_*, last


*------------------------------------------------------------------------------*
* Impute union membership from the state federations' apportionment rules
*
* Each AFL state federation's constitution fixed how a local's membership
* translated into convention votes / delegates. The long state-by-state block
* below inverts those rules to recover the membership variable "members".
* For each observed (vote / delegate count) the imputed membership is the
* midpoint of the membership band implied by the rule; open-ended bands
* ("X or more") are extended at the rule's regular step. States whose
* constitution apportioned non-proportionally (a flat number of delegates
* per local) leave members missing.
*
* The constitutional representation rules summarised in each state block below
* are taken from the state federations' published constitutions.
*------------------------------------------------------------------------------*

* nr_votes_delegates is the count the rules are applied to: the delegate head-
* count in every state except California, which apportioned by votes cast.
gen 	nr_votes_delegates = .
replace nr_votes_delegates = nr_delegates if state != "CA"
replace nr_votes_delegates = nr_votes if nr_votes != .
order	nr_votes_delegates, after(nr_delegates)

gen 	members 	= .
replace members = 0 if nr_votes_delegates == 0




*1911 (rules from 1905 and 1915)
replace members	= 75 									if state == "AL" & nr_votes_delegates == 1 & year_orig == 1911
replace members = nr_votes_delegates * 100 				if state == "AL" & nr_votes_delegates > 1 & year_orig == 1911



*1920 (rules from 1919)
replace members	= 38 									if state == "AL" & nr_votes_delegates == 1 & year_orig == 1920
replace members = nr_votes_delegates * 50 				if state == "AL" & nr_votes_delegates > 1 & year_orig == 1920



*1929 (rules from 1929)
replace members = 25									if state == "AL" & inrange(nr_votes_delegates,1,2) == 1 & year_orig == 1929
replace members = 75									if state == "AL" & nr_votes_delegates == 3 & year_orig == 1929
replace members = 175									if state == "AL" & nr_votes_delegates == 4 & year_orig == 1929
replace members = 500									if state == "AL" & nr_votes_delegates == 5 & year_orig == 1929
replace members = 1000 + (500 * (nr_votes_delegates-6)) if state == "AL" & nr_votes_delegates > 5 & year_orig == 1929




*********** AR ***********

*1910 and 1922
replace members	= 38 									if state == "AR" & nr_votes_delegates == 1 & inlist(year_orig,1910,1922) == 1
replace members = nr_votes_delegates * 50 				if state == "AR" & nr_votes_delegates > 1 & inlist(year_orig,1910,1922) == 1



*********** AZ ***********

*1920 and 1930 (rules from 1925)
replace members = 50									if state == "AZ" & nr_votes_delegates == 1 & inlist(year_orig,1920,1930) == 1
replace members = 150									if state == "AZ" & nr_votes_delegates > 1 & inlist(year_orig,1920,1930) == 1




*********** CA ***********

*1903, 1910, 1920 and 1930 (rules from 1903, 1910, 1920, 1926)
replace members = nr_votes_delegates					if state == "CA" & inlist(year_orig,1903,1910,1920,1930) == 1
replace members = 75									if state == "CA" & inlist(year_orig,1903,1910,1920,1930) == 1 & nr_delegates <= 2 & nr_votes == .
replace members = 100 * (nr_delegates - 1)				if state == "CA" & inlist(year_orig,1903,1910,1920,1930) == 1 & nr_delegates > 2 & nr_votes == .




*********** CO ***********

*1902, 1911 and 1930 (rules from 1902, 1905, 1915, 1925)
replace members = 38									if state == "CO" & nr_votes_delegates == 1 & inlist(year_orig,1902,1911,1930) == 1
replace members = nr_votes_delegates * 50				if state == "CO" & nr_votes_delegates > 1 & inlist(year_orig,1902,1911,1930) == 1




*********** CT ***********

*1909 (rules from 1887)
replace members = 150									if state == "CT" & nr_votes_delegates == 1 & year_orig == 1909
replace members = nr_votes_delegates * 200				if state == "CT" & nr_votes_delegates > 1 & year_orig == 1909



*1932 (rules from 1932)
replace members = 75									if state == "CT" & nr_votes_delegates == 1 & year_orig == 1932
replace members = nr_votes_delegates * 100				if state == "CT" & nr_votes_delegates > 1 & year_orig == 1932




*********** FL ***********

*1902, 1908 and 1920 (rules from 1902, 1908 and 1920)
replace members = 75									if state == "FL" & nr_votes_delegates == 1 & inlist(year_orig,1902,1908,1920) == 1
replace members = nr_votes_delegates * 100				if state == "FL" & nr_votes_delegates > 1 & inlist(year_orig,1902,1908,1920) == 1




*********** GA ***********

*1920 and 1931 (rules from 1920 and 1931)
replace members = nr_votes_delegates * 50				if state == "GA" & nr_votes_delegates > 0 & inlist(year_orig,1920,1931) == 1




*********** IA ***********

*1902 (rules from 1902)
replace members = nr_votes_delegates * 100				if state == "IA" & nr_votes_delegates > 0 & year_orig == 1902



*1911, 1919 and 1930 (rules from 1911, 1919 and 1930)
replace members = 75									if state == "IA" & nr_votes_delegates == 1 & inlist(year_orig,1911,1919,1930)
replace members = nr_votes_delegates * 100				if state == "IA" & nr_votes_delegates > 1 & inlist(year_orig,1911,1919,1930)




*********** ID ***********

*1920 and 1930 (rules from 1926 and 1930)
replace members = 75									if state == "ID" & nr_votes_delegates == 1 & inlist(year_orig,1920,1930)
replace members = nr_votes_delegates * 100				if state == "ID" & nr_votes_delegates > 1 & inlist(year_orig,1920,1930)




*********** IL ***********

*1901, 1910, 1920 and 1930 (rules from 1901, 1910 and 1921)
replace members = 75									if state == "IL" & nr_votes_delegates == 1 & inlist(year_orig,1901,1910,1920,1930) == 1
replace members = nr_votes_delegates * 100				if state == "IL" & nr_votes_delegates > 1 & inlist(year_orig,1901,1910,1920,1930) == 1




*********** IN ***********

*1900, 1910, 1920 and 1930 (rules from 1900, 1910 and 1920 and 1930)
replace members = 25 + ((nr_votes_delegates-1) * 50)	if state == "IN" & nr_votes_delegates > 0 & inlist(year_orig,1900,1910,1920,1930) == 1




*********** KS ***********

*1920 (rules from 1920) -- not proportional
replace members = .										if state == "KS"




*********** KY ***********

*1900 and 1911 (rules from 1911) -- not proportional
replace members = .										if state == "KY"




*********** LA ***********

*1920 and 1930 (rules from 1920 and 1930) -- not proportional
replace members = .										if state == "LA"




*********** MA ***********

*1901, 1910, 1921 and 1930 (rules from 1901, 1910, 1921 and 1930)
replace members = 150									if state == "MA" & nr_votes_delegates == 1 & inlist(year_orig,1901,1910,1921,1930) == 1
replace members = nr_votes_delegates * 200				if state == "MA" & nr_votes_delegates > 1 & inlist(year_orig,1901,1910,1921,1930) == 1




*********** MD and DC ***********

*1910, 1922 and 1930 (rules from 1910) -- not proportional
replace members = .										if state == "MD" | state == "DC"




*********** ME ***********

*1912, 1920 and 1930 (rules from 1896)
replace members = 75									if state == "ME" & nr_votes_delegates == 1 & inlist(year_orig,1912,1920,1930) == 1
replace members = nr_votes_delegates * 100				if state == "ME" & nr_votes_delegates > 1 & inlist(year_orig,1912,1920,1930) == 1




*********** MI ***********

*1910 (rules from 1910) -- not proportional
replace members = .										if state == "MI" & year_orig == 1910



*1920 and 1930 (rules from 1925)
replace members = 75									if state == "MI" & nr_votes_delegates == 1 & inlist(year_orig,1920,1930) == 1
replace members = nr_votes_delegates * 100				if state == "MI" & nr_votes_delegates > 1 & inlist(year_orig,1920,1930) == 1




*********** MN ***********

*1900, 1912, 1920 and 1928 (rules from 1900, 1912 and 1920)
replace members = 19									if state == "MN" & nr_votes_delegates == 1 & inlist(year_orig,1900,1912,1920,1928)
replace members = (nr_votes_delegates * 25)				if state == "MN" & nr_votes_delegates > 1 & inlist(year_orig,1900,1912,1920,1928)




*********** MO ***********

*1903, 1909, 1921 and 1930
replace members = 75									if state == "MO" & nr_votes_delegates == 1 & inlist(year_orig,1903,1909,1921,1930) == 1
replace members = nr_votes_delegates * 100				if state == "MO" & nr_votes_delegates > 1 & inlist(year_orig,1903,1909,1921,1930) == 1




*********** MS ***********

*1918 (rules from 1918)
replace members = 13									if state == "MS" & inrange(nr_votes_delegates,1,2) == 1 & year_orig == 1918
replace members = 63									if state == "MS" & nr_votes_delegates == 3 & year_orig == 1918
replace members = 150									if state == "MS" & nr_votes_delegates == 4 & year_orig == 1918
replace members = 300									if state == "MS" & nr_votes_delegates == 5 & year_orig == 1918
replace members = 600									if state == "MS" & nr_votes_delegates == 6 & year_orig == 1918
replace members = 1250									if state == "MS" & nr_votes_delegates == 7 & year_orig == 1918
replace members = 1800									if state == "MS" & nr_votes_delegates == 8 & year_orig == 1918
replace members = 2000									if state == "MS" & nr_votes_delegates == 9 & year_orig == 1918
replace members = 2200									if state == "MS" & nr_votes_delegates == 10 & year_orig == 1918
replace members = 2400									if state == "MS" & nr_votes_delegates == 11 & year_orig == 1918
replace members = 2600									if state == "MS" & nr_votes_delegates == 12 & year_orig == 1918




*********** MT ***********

*1910 (rules from 1910)
replace members = 25									if state == "MT" & nr_votes_delegates == 1 & inlist(year_orig,1910) == 1
replace members = 100 * (nr_votes_delegates - 1)		if state == "MT" & inrange(nr_votes_delegates,2,10) == 1 & inlist(year_orig,1910) == 1
replace members = 1100									if state == "MT" & nr_votes_delegates == 11 & inlist(year_orig,1910) == 1
replace members = 1500 + (500*(nr_votes_delegates-12))	if state == "MT" & nr_votes_delegates > 11 & inlist(year_orig,1910) == 1




*1921 and 1931 (rules from 1921 and 1931)
replace members = 25									if state == "MT" & nr_votes_delegates == 1 & inlist(year_orig,1921,1931) == 1
replace members = 100 * (nr_votes_delegates - 1)		if state == "MT" & inrange(nr_votes_delegates,2,10) == 1 & inlist(year_orig,1921,1931) == 1
replace members = 1475									if state == "MT" & nr_votes_delegates == 11 & inlist(year_orig,1921,1931) == 1
replace members = 2500 + (1000*(nr_votes_delegates-12))	if state == "MT" & nr_votes_delegates > 11 & inlist(year_orig,1921,1931) == 1




*********** NC ***********

*1919 (rules from 1919)
replace members = 19									if state == "NC" & nr_votes_delegates == 1 & year_orig == 1919
replace members = (nr_votes_delegates * 25)				if state == "NC" & nr_votes_delegates > 1 & year_orig == 1919




*********** ND ***********

*1921 and 1930 (rules from 1921 and 1930) -- not proportional
replace members = .										if state == "ND"




*********** NH ***********

*1908, 1920 and 1930 (rules from 1922)
replace members = 25									if state == "NH" & inrange(nr_votes_delegates,1,2) == 1 & inlist(year_orig,1908,1920,1930) == 1
replace members = 100 * (nr_votes_delegates - 2)		if state == "NH" & nr_votes_delegates > 2 & inlist(year_orig,1908,1920,1930) == 1




*********** NM ***********

*1921 and 1930 (rules from 1921 and 1926) -- not proportional
replace members = .										if state == "NM"




*********** NY ***********

*1903, 1910, 1920 and 1930 (rules from 1893 and 1919)
replace members = 150									if state == "NY" & nr_votes_delegates == 1 & inlist(year_orig,1903,1910,1920,1930) == 1
replace members = 450									if state == "NY" & nr_votes_delegates == 2 & inlist(year_orig,1903,1910,1920,1930) == 1
replace members = 1050									if state == "NY" & nr_votes_delegates == 3 & inlist(year_orig,1903,1910,1920,1930) == 1
replace members = 1750 + (500 * (nr_votes_delegates-4))	if state == "NY" & nr_votes_delegates > 3 & inlist(year_orig,1903,1910,1920,1930) == 1




*********** OH ***********

*1902, 1910, 1920 and 1930 (rules from 1902 and 1910)
replace members = 75									if state == "OH" & nr_votes_delegates == 1 & inlist(year_orig,1902,1910,1920,1930) == 1
replace members = nr_votes_delegates * 100				if state == "OH" & nr_votes_delegates > 1 & inlist(year_orig,1902,1910,1920,1930) == 1




*********** OK ***********

*1909, 1920 and 1929 (rules from 1914)
replace members	= 38 									if state == "OK" & nr_votes_delegates == 1 & inlist(year_orig,1909,1920,1929) == 1
replace members = nr_votes_delegates * 50 				if state == "OK" & nr_votes_delegates > 1 & inlist(year_orig,1909,1920,1929) == 1




*********** OR ***********

*1902, 1912, 1919 and 1930 (rules from 1902)
replace members = 75									if state == "OR" & inrange(nr_votes_delegates,1,2) == 1 & inlist(year_orig,1902,1912,1919,1930) == 1
replace members = (nr_votes_delegates - 1) * 100		if state == "OR" & nr_votes_delegates > 2 & inlist(year_orig,1902,1912,1919,1930) == 1




*********** PA ***********

*1902 -- not proportional (locals sent 1 delegate each; no info on representation rule is available)
replace members = .										if state == "PA" & year_orig == 1902



*1912 (rules from 1910)
replace members = 150 + 300*(nr_votes_delegates-1)		if state == "PA" & nr_votes_delegates > 0 & year_orig == 1912



*1921 and 1932 (rules from 1917 and 1932)
replace members = 75									if state == "PA" & nr_votes_delegates == 1 & inlist(year_orig,1921,1932) == 1
replace members = nr_votes_delegates * 100				if state == "PA" & nr_votes_delegates > 1 & inlist(year_orig,1921,1932) == 1




*********** SC ***********

*1921 and 1930 (rules from 1921)
replace members = 19									if state == "SC" & nr_votes_delegates == 1 & inlist(year_orig,1921,1930)
replace members = (nr_votes_delegates * 25)				if state == "SC" & nr_votes_delegates > 1 & inlist(year_orig,1921,1930)




*********** TN ***********

**1910, 1920 and 1931 -- not proportional
replace members = .										if state == "TN"




*********** TX ***********

*1910 and 1922 (rules from 1908 and 1914)
replace members = 75									if state == "TX" & nr_votes_delegates == 1 & inlist(year_orig,1910,1922) == 1
replace members = nr_votes_delegates * 100				if state == "TX" & nr_votes_delegates > 1 & inlist(year_orig,1910,1922) == 1




*********** UT ***********

*1920 (rules from 1920)
replace members = 38									if state == "UT" & inrange(nr_votes_delegates,1,2) == 1 & year_orig == 1920
replace members = 113									if state == "UT" & nr_votes_delegates == 3 & year_orig == 1920
replace members = 100 * (nr_votes_delegates - 2)		if state == "UT" & nr_votes_delegates > 3 & year_orig == 1920




*********** VA ***********

*1900 (rules from 1900)
replace members = 75									if state == "VA" & nr_votes_delegates == 1 & year_orig == 1900
replace members = 150									if state == "VA" & nr_votes_delegates == 2 & year_orig == 1900



*1911 and 1929 (rules from 1911 and 1929)
replace members = 38									if state == "VA" & nr_votes_delegates == 1 & inrange(year_orig,1911,1929) == 1
replace members = 50 * nr_votes_delegates				if state == "VA" & nr_votes_delegates > 1 & inrange(year_orig,1911,1929) == 1




*********** VT ***********

*1904 and 1922 (rules from 1904 and 1922)
replace members = 75									if state == "VT" & nr_votes_delegates == 1 & inlist(year_orig,1904,1922) == 1
replace members = nr_votes_delegates * 100				if state == "VT" & nr_votes_delegates > 1 & inlist(year_orig,1904,1922) == 1




*********** WA ***********

*1903, 1910, 1920, and 1931 (rules from 1917, 1922, and 1931)
replace members = 75									if state == "WA" & inrange(nr_votes_delegates,1,2) == 1 & inlist(year_orig,1903,1910,1920,1931) == 1
replace members = 100 * (nr_votes_delegates - 1)		if state == "WA" & nr_votes_delegates > 2 & inlist(year_orig,1903,1910,1920,1931) == 1




*********** WI ***********

*1900, 1910, 1920 and 1930 (rules from 1900, 1910, 1920 and 1930)
replace members = 75									if state == "WI" & nr_votes_delegates == 1 & inlist(year_orig,1900,1910,1920,1930) == 1
replace members = nr_votes_delegates * 100				if state == "WI" & nr_votes_delegates > 1 & inlist(year_orig,1900,1910,1920,1930) == 1




*********** WV ***********

*1913, 1920 and 1931 (rules from 1925)
replace members = 75									if state == "WV" & nr_votes_delegates == 1 & inlist(year_orig,1913,1920,1931) == 1
replace members = nr_votes_delegates * 100				if state == "WV" & nr_votes_delegates > 1 & inlist(year_orig,1913,1920,1931) == 1




*********** WY ***********

*1910 (rules from 1911)
replace members = 25									if state == "WY" & nr_votes_delegates == 1 & year_orig == 1910
replace members = 100 * (nr_votes_delegates - 1)		if state == "WY" & inrange(nr_votes_delegates,2,10) == 1 & year_orig == 1910
replace members = 1100									if state == "WY" & nr_votes_delegates == 11 & year_orig == 1910
replace members = 1500 + (500*(nr_votes_delegates-12))	if state == "WY" & nr_votes_delegates > 11 & year_orig == 1910



*1922 and 1930 (rules from 1922)
replace members = 75									if state == "WY" & nr_votes_delegates == 1 & inlist(year_orig,1922,1930) == 1
replace members = nr_votes_delegates * 100				if state == "WY" & nr_votes_delegates > 1 & inlist(year_orig,1922,1930) == 1



*Members of specific unions
rename nr_delegates* nr_del*

* For each measure j, split the local-year value across national unions by
* keyword-matching the free-text "union" string: `j'_<u> = `j' if the local
* belongs to <u>, else 0. Aggregated to county-year below, this gives the
* per-union total of j in each county.
*
* The four unions whose own national-convention delegate records have also
* been digitized -- UMWA, UBC, IAM, BMPIU -- get the split for every j: the
* AFL state-convention ethnic delegate counts here are merged with the
* parallel national-convention counts into a single per-union ethnic
* measure used in the analysis. The remaining national unions get the
* split only for j=members; their per-union membership feeds per-union
* density measures but there is no parallel national-convention record to
* combine into a per-union ethnic measure.

foreach j in members ///
			 nr_del_bpl_native nr_del_bpl_other nr_del_bpl_euroall nr_del_bpl_euronw nr_del_bpl_eurose ///
			 nr_del_anc_other nr_del_anc_euroall nr_del_anc_euronw nr_del_anc_eurose ///
			 {

gen		`j'_ubc = 0
replace `j'_ubc = `j' if strpos(union,"carpenters") > 0	| strpos(union,"u b of c") > 0 | ///
								 strpos(union,"u b c") > 0

gen		`j'_iam = 0
replace `j'_iam = `j' if strpos(union,"machinist") > 0 | strpos(union,"i a m") > 0 ///
								 | strpos(union,"i a of m") > 0

gen		`j'_bmpiu = 0
replace `j'_bmpiu = `j' if strpos(union,"bricklayer") > 0 | strpos(union,"mason") > 0 | ///
								   strpos(union,"plaster") > 0
replace	`j'_bmpiu = 0		if strpos(union,"operative plaster") > 0 | strpos(union,"finisher") > 0

gen	 	`j'_umwa = 0
replace	`j'_umwa = `j' if strpos(union,"united mine") > 0 | strpos(union,"umwa") > 0 | ///
								  strpos(union,"u m w a") > 0 | strpos(union,"u m w of a") > 0 | ///
								  strpos(union,"u m w") > 0 | strpos(union,"m w a") > 0 | ///
								  strpos(union,"mine worker") > 0 | strpos(union,"miner") > 0 | ///
								  strpos(union,"minors") > 0 | strpos(union,"minner") > 0

if "`j'" == "members" {

gen		`j'_bpd = 0
replace	`j'_bpd = `j'  if strpos(union,"painter") > 0 | strpos(union,"decorat") > 0

gen		`j'_brsc = 0
replace	`j'_brsc = `j' if strpos(union,"railway clerk") > 0 | strpos(union,"ry clerk") > 0 | ///
								  strpos(union,"railway steamship") > 0 | strpos(union,"freight clerks") > 0 | ///
								  strpos(union,"freight handlers") > 0

gen		`j'_ibt = 0
replace	`j'_ibt = `j' if strpos(union,"teamster") > 0

gen		`j'_ibew = 0
replace	`j'_ibew = `j' if strpos(union,"electrical") > 0 | strpos(union,"electrician") > 0 | ///
								  strpos(union,"i b e w") > 0 | strpos(union,"i b electrical") > 0 | ///
								  strpos(union,"i b of electr") > 0

gen 	`j'_itu = 0
replace `j'_itu = `j' if strpos(union,"typog") > 0

gen		`j'_brca = 0
replace `j'_brca = `j' if strpos(union,"carmen") > 0 | strpos(union,"railway car men") > 0 | ///
								  strpos(union,"b r c of a") > 0 | strpos(union,"b r c a") > 0
replace `j'_brca = 0	   if strpos(union,"street carmen") > 0

gen 	`j'_brew = 0
replace `j'_brew = `j' if strpos(union,"brewery") > 0 | strpos(union,"brewers") > 0 | strpos(union,"drink") > 0 | ///
								  strpos(union,"soft") > 0 | strpos(union,"beverage") > 0 | ///
								  strpos(union,"brewflour") > 0 | ///
								  (strpos(union,"bev") > 0 & (strpos(union,"hotel") == 0 | (strpos(union,"dispensers") == 0)))

gen 	`j'_amc = 0
replace `j'_amc = `j' if strpos(union,"meat") > 0 | strpos(union,"butcher") > 0 | strpos(union,"a m c") > 0

gen 	`j'_ila = 0
replace `j'_ila = `j' if strpos(union,"shore") > 0


gen 	`j'_iummsw = 0
replace `j'_iummsw = `j' if strpos(union,"smelter") > 0	| (strpos(union,"mill") > 0 & strpos(union,"mine") > 0)


gen 	`j'_aaser = 0
replace `j'_aaser = `j' if strpos(union,"street") > 0 | strpos(union,"electric rail") > 0 | strpos(union,"a a s e") > 0

gen 	`j'_ugwa = 0
replace `j'_ugwa = `j' if strpos(union,"garment") > 0	| strpos(union,"u g w") > 0

gen 	`j'_utw = 0
replace `j'_utw = `j' if strpos(union,"text") > 0	| strpos(union,"u t w") > 0

}

foreach var of varlist `j'_* {
	replace `var' = . if `j' == .
}

}


*Compute number of locals 
gen locals_tot = 1 if members != .
foreach union in ubc iam bpd bmpiu ibt ibew itu umwa brca brew amc ila iummsw aaser ugwa utw {
gen locals_`union' = (members_`union' > 0) if members != .
}


* Collapse to 1930 counties: point-in-polygon match each geocoded local to its
* 1930 county, then total every measure within county-year.

geoinpoly latitude longitude using "$unionsrc/US_county_1930_WGS84_coord"
merge m:1 _ID using "$unionsrc/US_county_1930_WGS84_dbase_spmap", keepusing(GISJOIN*)
drop if _merge == 2
drop _merge
drop _ID

rename (GISJOIN GISJOIN2) (gisjoin_1930 countynhg_1930)
foreach var of varlist members* locals_* nr_votes_delegates nr_del* {
bysort year gisjoin_1930 countynhg_1930: gegen `var'_tot = total(`var'), missing
rename `var' `var'_dr
}
gegen tag = tag(year gisjoin_1930 countynhg_1930)
keep if tag == 1
drop *_dr
rename *_tot afl_*

* Drop the vote-count bookkeeping (afl_nr_votes_delegates and any
* total_nr_votes_delegates carried over from the collapse): not used downstream.
capture drop afl_nr_votes_delegates
capture drop total_nr_votes_delegates

drop if gisjoin_1930 == ""

keep gisjoin_1930 countynhg_1930 year year_orig afl_*

destring countynhg_1930, replace


export delimited "$intmdata/AFL_members_county1930.csv", replace nolabel


