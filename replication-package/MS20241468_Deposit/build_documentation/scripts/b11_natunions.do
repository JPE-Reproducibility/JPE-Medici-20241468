*==============================================================================*
* b11_natunions.do
*
* One-time prep script. Builds the per-national-union county-level aggregates
* of locals, membership proxies, and delegate counts for the five national
* unions whose own convention proceedings feed the union-density panel:
*     UMWA, UBC, IAM, BMPIU, ITU.
* For each union the output is a 1930-county aggregate carrying
* <UNION>_locals_votes and <UNION>_memb_proxy_votes (plus UMWA_membership
* for UMWA and ITU_members for ITU). The outputs are build intermediates
* written to data/intermediate/; b12_unions_combine merges them into the
* shipped unions_combined_county1930.csv that the analysis pipeline reads.
* This script documents how they were produced.
*
* The script is not invoked by the main pipeline driver. The underlying
* delegate-level transcriptions are hand-collected and the geocoding step
* is manual, so a replicator cannot re-run the prep step end-to-end.
*
* Workflow (per union):
*   manual - the delegate/votes lists (and, for UMWA only, the locals list)
*            were transcribed from convention proceedings and then geocoded
*            with ArcGIS's "Geocode Addresses" tool against a U.S. address
*            locator. The geocoded CSVs are the inputs to this script.
*   main   - read the geocoded list, clean it, attach surname-based ethnic
*            shares, aggregate to local-year, apportion membership from
*            votes using each union's representation rule, point-in-polygon
*            match to 1930 county boundaries (geoinpoly), and aggregate to
*            the county level.
*
* Structure of each pipeline (all five follow the same shape):
*   (1) Import the raw ArcGIS geocoded CSV. Strip the ArcGIS metadata
*       columns (score, type, region, ...) after using them to discard
*       low-quality matches (score < 85, non-point geocodes, cross-state
*       placements). Restore the original input columns from the user_*
*       prefix.
*   (2) Parse delegate surnames: lowercase, strip punctuation and "jr"/"sr"
*       suffixes, isolate the last word as the family name.
*   (3) Bucket each delegate's convention year into a decade {1900, 1910,
*       1920} so that counts merge onto the decennial census panel.
*   (4) Merge on the surname x year origin shares (names_origin.dta) and
*       the surname x ancestry shares (names_ancestry.dta) from the IPUMS
*       Restricted Full Count with Names. Each delegate's surname carries
*       a probability of belonging to one of ~25 European-origin groups
*       plus "native" and "other"; row-totalling over delegates per
*       local-year produces nr_delegates_*_<group> -- the expected number
*       of delegates in each ethnic group at each local. (See nameprob_*
*       in build_documentation/scripts/b9_names.do.)
*   (5) Aggregate to the local-year level (one row per local x year).
*   (6) Invert each union's constitutional vote-to-membership rule to get
*       a per-local membership proxy: memb_proxy_votes. The rule differs
*       by union (and by year for some unions); the specifics are
*       documented inside each pipeline.
*   (7) Point-in-polygon match to 1930 county boundaries (via geoinpoly)
*       and aggregate to county. Save the five county1930 .csv files
*       listed under outputs.
*
* Inputs (raw, shipped):
*   $rawdata/USmap_1930/US_county_1930_WGS84.shp
*   $rawdata/IPUMS_surname_aggregates/names_origin.dta
*   $rawdata/IPUMS_surname_aggregates/names_ancestry.dta
*
* Inputs (working files, not shipped):
*   $unionsrc/UMWA_delegates_geocoded.csv
*   $unionsrc/UBC_delegates_geocoded.csv
*   $unionsrc/IAM_votes_geocoded.csv
*   $unionsrc/BMPIU_delegates_geocoded.csv
*   $unionsrc/ITU_members_geocoded.csv
*
* Outputs (build intermediates, in data/intermediate/; combined into the
* shipped unions_combined_county1930.csv by b12):
*   UMWA_votes_county1930.csv
*   UBC_votes_county1930.csv
*   IAM_votes_county1930.csv
*   BMPIU_votes_county1930.csv
*   ITU_members_county1930.csv
*==============================================================================*

clear all
set more off, perm

* $rawdata is the package's raw-input folder. $unionsrc is a working directory
* for this one-time prep script; the geocoded CSV inputs live there but are
* not part of the shipped package.
if "$root" == "" global root "set-this-to-the-replication-package-path"
global rawdata  "$root/data/public"
global intmdata "$root/data/intermediate"
global unionsrc     "$root/data/_raw_local/union_sources"
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
* UMWA -- United Mine Workers of America convention delegates
*
* Per UMWA Constitution, Article 12, Section 2: "one vote for one
* hundred members or less, and one additional vote for each one
* hundred members or majority fraction thereof". Code:
*   75  members if 1 vote,
*   100 members per vote thereafter.
* The local-level membership variable also appears in the delegate
* records and is carryforwarded across years for cross-validation.
*------------------------------------------------------------------------------*

* Votes/delegates *

import delimited "$unionsrc/UMWA_delegates_geocoded.csv", clear

keep score shortlabel addr_type type placename region regionabbr x y user_*
order user_*, first
rename user_* *

replace score = 100 if location == "n. philadelphia" & placename == "new philadelphia"

replace x = . if inlist(type,"State or Province","County") | score < 85 | state == "canada"
replace y = . if inlist(type,"State or Province","County") | score < 85 | state == "canada"

replace x = . if (state != lower(region) & state != region)
replace y = . if (state != lower(region) & state != region)


drop score shortlabel addr_type type region

foreach var of varlist placename {
	rename `var' geocode_`var'
} 
order(geocode_*), after(state)

drop pdf_page
rename regionabbr statecode
rename number lu_nr
rename location city
rename x longitude
rename y latitude

bysort lu_nr (year membership): carryforward membership if year == 1900, replace

*Isolate last names of delegates
foreach var of varlist delegate {
	gen `var'_last = lower(`var')
	replace `var'_last = subinstr(`var'_last,",","",.)
	replace `var'_last = subinstr(`var'_last,"-","",.)
	replace `var'_last = subinstr(`var'_last,"_","",.)	
	replace `var'_last = subinstr(`var'_last,":","",.)	
	replace `var'_last = subinstr(`var'_last,"`","",.)	
	replace `var'_last = subinstr(`var'_last,"'","",.)
	replace `var'_last = subinstr(`var'_last,"*","",.)	
	replace `var'_last = subinstr(`var'_last,".","",.)	
	replace `var'_last = subinword(`var'_last,"jr","",.)
	replace `var'_last = subinword(`var'_last,"sr","",.)	
	replace `var'_last  = strtrim(stritrim(`var'_last))
	replace `var'_last = `var' if strpos(`var'," ") == 0 & `var'_last == ""
	replace `var'_last = subinstr(`var'_last,"st.","st",.)
	replace `var'_last = substr(`var'_last,strrpos(`var'_last," ")+1,strlen(`var'_last)-strrpos(`var'_last," "))
	replace `var'_last  = strtrim(stritrim(`var'_last))
} 

rename delegate_last delegate_lastname
drop delegate

*Year variable
replace year = 1900 if inrange(year,1900,1902) == 1
replace year = 1910 if inrange(year,1908,1912) == 1
replace year = 1920 if inrange(year,1918,1922) == 1

keep if inlist(year,1900,1910,1920) == 1

*Merge last names (exact string matching) w/ probability of belonging to a specific ethnic group  
rename delegate_lastname namelast
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

*Compute nr. of delegates from each group (natives or European), based on the last name of delegates
gegen nr_delegates_bpl_native = rowtotal(nameprob_bpl_native), missing	

foreach j in bpl anc {
		
gegen nr_delegates_`j'_other = rowtotal(nameprob_`j'_other), missing	
		
gegen nr_delegates_`j'_euroall = rowtotal(nameprob_`j'_denmark nameprob_`j'_finland nameprob_`j'_norway ///
											nameprob_`j'_sweden nameprob_`j'_uk nameprob_`j'_ireland nameprob_`j'_oth_northeu ///
											nameprob_`j'_belgium nameprob_`j'_france nameprob_`j'_luxemb nameprob_`j'_nether ///
											nameprob_`j'_switz nameprob_`j'_oth_westeu ///
											nameprob_`j'_italy nameprob_`j'_gr_pt_es nameprob_`j'_oth_southeu ///
											nameprob_`j'_aus_hung nameprob_`j'_czech nameprob_`j'_germany nameprob_`j'_poland ///
											nameprob_`j'_oth_easteu nameprob_`j'_oth_centereu ///
											nameprob_`j'_russia nameprob_`j'_oth_russeu), missing	

gegen nr_delegates_`j'_euronw = rowtotal(nameprob_`j'_denmark nameprob_`j'_finland nameprob_`j'_norway ///
											nameprob_`j'_sweden nameprob_`j'_uk nameprob_`j'_ireland nameprob_`j'_oth_northeu ///
											nameprob_`j'_belgium nameprob_`j'_france nameprob_`j'_luxemb nameprob_`j'_nether ///
											nameprob_`j'_switz nameprob_`j'_oth_westeu ///
											nameprob_`j'_germany), missing	
											
gegen nr_delegates_`j'_eurose = rowtotal(nameprob_`j'_italy nameprob_`j'_gr_pt_es nameprob_`j'_oth_southeu ///
											nameprob_`j'_aus_hung nameprob_`j'_czech nameprob_`j'_poland ///
											nameprob_`j'_oth_easteu nameprob_`j'_oth_centereu ///
											nameprob_`j'_russia nameprob_`j'_oth_russeu), missing	
											
}

drop nameprob*


* Normalize city names so that spelling variants collapse to a single key:
* lowercase the string and strip common decorations (punctuation, "mt." -> "mount",
* "st." -> "saint", ward / township / district / etc. suffixes), so that the
* local-year aggregation below treats e.g. "Saint Louis" and "St. Louis" as
* the same place.
gen 	city_clean 	= lower(geocode_placename)
replace city_clean	= lower(city) if city_clean == ""
order city_clean, after(city)
replace city_clean 	= subinstr(city_clean,"mt.","mount",.)
replace city_clean 	= subinstr(city_clean,"mt ","mount ",.)
replace city_clean 	= subinstr(city_clean,"st.","saint",.)
replace city_clean 	= subinstr(city_clean,"st","saint",1) if substr(city_clean,1,3) == "st "
replace city_clean 	= subinstr(city_clean,"indian reservation","reservation",.)
replace city_clean 	= subinstr(city_clean,"0","",.)
replace city_clean 	= subinstr(city_clean,"1","",.)
replace city_clean 	= subinstr(city_clean,"2","",.)
replace city_clean 	= subinstr(city_clean,"3","",.)
replace city_clean 	= subinstr(city_clean,"4","",.)
replace city_clean 	= subinstr(city_clean,"5","",.)
replace city_clean 	= subinstr(city_clean,"6","",.)
replace city_clean 	= subinstr(city_clean,"7","",.)
replace city_clean 	= subinstr(city_clean,"8","",.)
replace city_clean 	= subinstr(city_clean,"9","",.)
replace city_clean 	= subinstr(city_clean,",","",.)
replace city_clean 	= subinstr(city_clean,"?","",.)
replace city_clean 	= subinstr(city_clean,".","",.)
replace city_clean 	= subinstr(city_clean,"(","",.)
replace city_clean 	= subinstr(city_clean,")","",.)
replace city_clean 	= subinstr(city_clean,"/","",.)
replace city_clean 	= subinstr(city_clean," range ","",.)
replace city_clean 	= subinstr(city_clean," range(s) ","",.)
replace city_clean 	= subinstr(city_clean," range","",.) if substr(city_clean,-6,6) == " range" 
replace city_clean 	= subinstr(city_clean," range(s)","",.) if substr(city_clean,-9,9) == " range(s)" 
replace city_clean 	= subinstr(city_clean,"police jury","",.)
replace city_clean 	= subinstr(city_clean,"justice ward","",.)
replace city_clean 	= subinstr(city_clean,"court house","",.)
replace city_clean 	= subinstr(city_clean,"militia district","",.)
replace city_clean 	= subinstr(city_clean,"civil district","",.)
replace city_clean 	= subinstr(city_clean,"justice precinct","",.)
replace city_clean 	= subinstr(city_clean,"election district","",.)
replace city_clean 	= subinstr(city_clean,"undetermined","",.)
replace city_clean 	= subinstr(city_clean,"not stated","",.)
replace city_clean 	= subinstr(city_clean," village","",.)
replace city_clean 	= subinstr(city_clean,"tract","",.)
replace city_clean 	= subinstr(city_clean," ward","",.)
replace city_clean 	= subinstr(city_clean,"assembly district","",.)
replace city_clean 	= subinstr(city_clean,"district","",.)
replace city_clean 	= subinstr(city_clean,"no.","",.)
replace city_clean 	= subinstr(city_clean,"precinct","",.)
replace city_clean 	= subinstr(city_clean,"subdivision","",.)
replace city_clean 	= subinstr(city_clean,"beat","",.)
replace city_clean 	= subinstr(city_clean,"plantation","",.)
replace city_clean 	= subinstr(city_clean,"census designated place","",.)
replace city_clean 	= subinstr(city_clean,"post office","",.)
replace city_clean 	= subinstr(city_clean,"township of","",.)
replace city_clean 	= subinstr(city_clean,"town of","",.)
replace city_clean 	= subinstr(city_clean,"borough of","",.)
replace city_clean 	= subinstr(city_clean,"city of","",.)
replace city_clean 	= subinstr(city_clean,"ward ","",1) if substr(city_clean,1,5) == "ward "
replace city_clean 	= subinstr(city_clean,"township ","",1) if substr(city_clean,1,9) == "township "
replace city_clean 	= "" if strpos(city_clean,"division") > 0
replace city_clean 	= subinstr(city_clean,"east side","",.)
replace city_clean 	= subinstr(city_clean,"west side","",.)
replace city_clean 	= subinstr(city_clean,"south side","",.)
replace city_clean 	= subinstr(city_clean,"north side","",.)
replace city_clean 	= subinstr(city_clean,"eastern side","",.)
replace city_clean 	= subinstr(city_clean,"western side","",.)
replace city_clean 	= subinstr(city_clean,"southern side","",.)
replace city_clean 	= subinstr(city_clean,"northern side","",.)
replace city_clean	= stritrim(city_clean)
replace city_clean	= "" if length(city_clean) < 2
replace city_clean	= strtrim(city_clean)
replace city_clean	= lower(city_clean)

replace city_clean 	= "east saint louis" if city_clean == "east st louis"
replace city_clean 	= "new york city" if city_clean == "long island city" & state == "NY"

replace city_clean 	= subinstr(city_clean,"-","",.)
replace city_clean 	= subinstr(city_clean,"south","",.)
replace city_clean 	= subinstr(city_clean,"north","",.)
replace city_clean 	= subinstr(city_clean,"east","",.)
replace city_clean 	= subinstr(city_clean,"west","",.)
replace city_clean 	= subinstr(city_clean,"southern","",.)
replace city_clean 	= subinstr(city_clean,"northern","",.)
replace city_clean 	= subinstr(city_clean,"eastern","",.)
replace city_clean 	= subinstr(city_clean,"western","",.)
replace city_clean 	= subinstr(city_clean," township","",.)
replace city_clean 	= subinstr(city_clean," point","",.)
replace city_clean 	= subinstr(city_clean," ","",.)

*Collapse at the local-year level
gen delegates_bpl_nonmissing = (nr_delegates_bpl_euroall != .)
gen delegates_anc_nonmissing = (nr_delegates_anc_euroall != .)
gcollapse (sum) votes nr_delegates_* delegates_bpl_nonmissing delegates_anc_nonmissing (firstnm) membership longitude latitude, by(lu_nr city_clean statecode district year)
foreach var of varlist nr_delegates_bpl_* {
replace `var' = . if delegates_bpl_nonmissing == 0
}
foreach var of varlist nr_delegates_anc_* {
replace `var' = . if delegates_anc_nonmissing == 0
}

gen 	memb_proxy_votes = .
replace memb_proxy_votes = 75 if votes == 1
replace memb_proxy_votes = 100*votes if votes > 1 & votes != .


*Collapse at the county-year level
geoinpoly latitude longitude using "$unionsrc/US_county_1930_WGS84_coord"
merge m:1 _ID using "$unionsrc/US_county_1930_WGS84_dbase_spmap", keepusing(GISJOIN*)
drop if _merge == 2
drop _merge
drop _ID
sort year lu_nr
rename (GISJOIN GISJOIN2) (gisjoin_1930 countynhg_1930)

replace lu_nr = 9999 if lu_nr == .
gcollapse (sum) votes membership memb_proxy_votes nr_delegates_* delegates_bpl_nonmissing delegates_anc_nonmissing (count) lu_nr, by(year gisjoin_1930 countynhg_1930)
drop if gisjoin_1930 == ""
replace votes = . if votes == 0
replace membership = . if votes == 0
replace membership = . if year > 1900
foreach var of varlist nr_delegates_bpl_* {
replace `var' = . if delegates_bpl_nonmissing == 0
}
foreach var of varlist nr_delegates_anc_* {
replace `var' = . if delegates_anc_nonmissing == 0
}

rename lu_nr locals_votes
foreach var of varlist locals membership memb_proxy_votes nr_delegates_* {
	rename `var' UMWA_`var'
}

destring countynhg_1930, replace
keep year gisjoin_1930 countynhg_1930 ///
	 UMWA_nr_delegates_bpl_* UMWA_nr_delegates_anc_* ///
	 UMWA_membership UMWA_memb_proxy_votes UMWA_locals_votes

label data "UMWA county-year totals from convention proceedings (1900-1920)"
label var year "Year"
label var gisjoin_1930 "GISJOIN, 1930 county boundaries"
label var countynhg_1930 "NHGIS county code, 1930 boundaries"
label var UMWA_locals_votes "Number of UMWA locals sending delegates"
label var UMWA_membership "UMWA membership reported in proceedings"
label var UMWA_memb_proxy_votes "UMWA membership proxy from voting strength"
label var UMWA_nr_delegates_bpl_native "UMWA delegates: native (last-name birthplace prob.)"
label var UMWA_nr_delegates_bpl_other "UMWA delegates: other origin (last-name birthplace prob.)"
label var UMWA_nr_delegates_bpl_euroall "UMWA delegates: any European (last-name birthplace prob.)"
label var UMWA_nr_delegates_bpl_euronw "UMWA delegates: NW European (last-name birthplace prob.)"
label var UMWA_nr_delegates_bpl_eurose "UMWA delegates: S/E European (last-name birthplace prob.)"
label var UMWA_nr_delegates_anc_other "UMWA delegates: other origin (last-name ancestry prob.)"
label var UMWA_nr_delegates_anc_euroall "UMWA delegates: any European (last-name ancestry prob.)"
label var UMWA_nr_delegates_anc_euronw "UMWA delegates: NW European (last-name ancestry prob.)"
label var UMWA_nr_delegates_anc_eurose "UMWA delegates: S/E European (last-name ancestry prob.)"

export delimited "$intmdata/UMWA_votes_county1930.csv", replace nolabel

*------------------------------------------------------------------------------*
* UBC -- United Brotherhood of Carpenters convention delegates
*
* Per UBC Constitution, Section 6, and UBC by-laws, Section C:
* "A Union having one hundred members or less shall be entitled
* to one Delegate; more than one hundred members and less than
* five hundred, two Delegates; more than five hundred members and
* less than one thousand, three Delegates. One thousand
* or any greater number of members, four Delegates." Code imputes
* an anchor within each constitutional bracket:
*   50    members if 1 vote,
*   250   members if 2 votes,
*   750   members if 3 votes,
*   1750  members if 4+ votes (the 1000+ bracket is open-ended).
*------------------------------------------------------------------------------*
* Votes/delegates *

import delimited "$unionsrc/UBC_delegates_geocoded.csv", clear

keep score shortlabel addr_type type placename region regionabbr x y user_*

order user_*, first
rename user_* *

replace state = "District of Columbia" if state == "D.C."

replace x = . if inlist(type,"State or Province","County") | score < 85 | state == "canada"
replace y = . if inlist(type,"State or Province","County") | score < 85 | state == "canada"

replace x = . if (state != lower(region) & state != region)
replace y = . if (state != lower(region) & state != region)

replace placename = "" if x == . & y == .

drop score shortlabel addr_type type region

foreach var of varlist placename {
	rename `var' geocode_`var'
} 
order(geocode_*), after(state)

rename regionabbr statecode
rename union_no_ lu_nr
rename x longitude
rename y latitude

*Isolate last names of delegates
foreach var of varlist name_of_delegate {
	gen `var'_last = lower(`var')
	replace `var'_last = subinstr(`var'_last,",","",.)
	replace `var'_last = subinstr(`var'_last,"-","",.)
	replace `var'_last = subinstr(`var'_last,"_","",.)	
	replace `var'_last = subinstr(`var'_last,":","",.)	
	replace `var'_last = subinstr(`var'_last,"`","",.)	
	replace `var'_last = subinstr(`var'_last,"'","",.)
	replace `var'_last = subinstr(`var'_last,"*","",.)	
	replace `var'_last = subinstr(`var'_last,".","",.)	
	replace `var'_last = subinword(`var'_last,"jr","",.)
	replace `var'_last = subinword(`var'_last,"sr","",.)	
	replace `var'_last  = strtrim(stritrim(`var'_last))
	replace `var'_last = `var' if strpos(`var'," ") == 0 & `var'_last == ""
	replace `var'_last = subinstr(`var'_last,"st.","st",.)
	replace `var'_last = substr(`var'_last,strrpos(`var'_last," ")+1,strlen(`var'_last)-strrpos(`var'_last," "))
	replace `var'_last  = strtrim(stritrim(`var'_last))
} 

rename name_of_delegate_last delegate_lastname
drop name_of_delegate

*Year variable
replace year = 1900 if inrange(year,1900,1902) == 1
replace year = 1910 if inrange(year,1908,1912) == 1
replace year = 1920 if inrange(year,1918,1922) == 1

keep if inlist(year,1900,1910,1920) == 1

*Merge last names (exact string matching) w/ probability of belonging to a specific ethnic group  
rename delegate_lastname namelast
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

*Compute nr. of delegates from each group (natives or European), based on the last name of delegates
gegen nr_delegates_bpl_native = rowtotal(nameprob_bpl_native), missing	

foreach j in bpl anc {
		
gegen nr_delegates_`j'_other = rowtotal(nameprob_`j'_other), missing	
		
gegen nr_delegates_`j'_euroall = rowtotal(nameprob_`j'_denmark nameprob_`j'_finland nameprob_`j'_norway ///
											nameprob_`j'_sweden nameprob_`j'_uk nameprob_`j'_ireland nameprob_`j'_oth_northeu ///
											nameprob_`j'_belgium nameprob_`j'_france nameprob_`j'_luxemb nameprob_`j'_nether ///
											nameprob_`j'_switz nameprob_`j'_oth_westeu ///
											nameprob_`j'_italy nameprob_`j'_gr_pt_es nameprob_`j'_oth_southeu ///
											nameprob_`j'_aus_hung nameprob_`j'_czech nameprob_`j'_germany nameprob_`j'_poland ///
											nameprob_`j'_oth_easteu nameprob_`j'_oth_centereu ///
											nameprob_`j'_russia nameprob_`j'_oth_russeu), missing	

gegen nr_delegates_`j'_euronw = rowtotal(nameprob_`j'_denmark nameprob_`j'_finland nameprob_`j'_norway ///
											nameprob_`j'_sweden nameprob_`j'_uk nameprob_`j'_ireland nameprob_`j'_oth_northeu ///
											nameprob_`j'_belgium nameprob_`j'_france nameprob_`j'_luxemb nameprob_`j'_nether ///
											nameprob_`j'_switz nameprob_`j'_oth_westeu ///
											nameprob_`j'_germany), missing	
											
gegen nr_delegates_`j'_eurose = rowtotal(nameprob_`j'_italy nameprob_`j'_gr_pt_es nameprob_`j'_oth_southeu ///
											nameprob_`j'_aus_hung nameprob_`j'_czech nameprob_`j'_poland ///
											nameprob_`j'_oth_easteu nameprob_`j'_oth_centereu ///
											nameprob_`j'_russia nameprob_`j'_oth_russeu), missing	
											
}

drop nameprob*


gen votes = 1

* Normalize city names so that spelling variants collapse to a single key:
* lowercase the string and strip common decorations (punctuation, "mt." -> "mount",
* "st." -> "saint", ward / township / district / etc. suffixes), so that the
* local-year aggregation below treats e.g. "Saint Louis" and "St. Louis" as
* the same place.
gen 	city_clean 	= lower(geocode_placename)
replace city_clean	= lower(city) if city_clean == ""
order city_clean, after(city)
replace city_clean 	= subinstr(city_clean,"mt.","mount",.)
replace city_clean 	= subinstr(city_clean,"mt ","mount ",.)
replace city_clean 	= subinstr(city_clean,"st.","saint",.)
replace city_clean 	= subinstr(city_clean,"st","saint",1) if substr(city_clean,1,3) == "st "
replace city_clean 	= subinstr(city_clean,"indian reservation","reservation",.)
replace city_clean 	= subinstr(city_clean,"0","",.)
replace city_clean 	= subinstr(city_clean,"1","",.)
replace city_clean 	= subinstr(city_clean,"2","",.)
replace city_clean 	= subinstr(city_clean,"3","",.)
replace city_clean 	= subinstr(city_clean,"4","",.)
replace city_clean 	= subinstr(city_clean,"5","",.)
replace city_clean 	= subinstr(city_clean,"6","",.)
replace city_clean 	= subinstr(city_clean,"7","",.)
replace city_clean 	= subinstr(city_clean,"8","",.)
replace city_clean 	= subinstr(city_clean,"9","",.)
replace city_clean 	= subinstr(city_clean,",","",.)
replace city_clean 	= subinstr(city_clean,"?","",.)
replace city_clean 	= subinstr(city_clean,".","",.)
replace city_clean 	= subinstr(city_clean,"(","",.)
replace city_clean 	= subinstr(city_clean,")","",.)
replace city_clean 	= subinstr(city_clean,"/","",.)
replace city_clean 	= subinstr(city_clean," range ","",.)
replace city_clean 	= subinstr(city_clean," range(s) ","",.)
replace city_clean 	= subinstr(city_clean," range","",.) if substr(city_clean,-6,6) == " range" 
replace city_clean 	= subinstr(city_clean," range(s)","",.) if substr(city_clean,-9,9) == " range(s)" 
replace city_clean 	= subinstr(city_clean,"police jury","",.)
replace city_clean 	= subinstr(city_clean,"justice ward","",.)
replace city_clean 	= subinstr(city_clean,"court house","",.)
replace city_clean 	= subinstr(city_clean,"militia district","",.)
replace city_clean 	= subinstr(city_clean,"civil district","",.)
replace city_clean 	= subinstr(city_clean,"justice precinct","",.)
replace city_clean 	= subinstr(city_clean,"election district","",.)
replace city_clean 	= subinstr(city_clean,"undetermined","",.)
replace city_clean 	= subinstr(city_clean,"not stated","",.)
replace city_clean 	= subinstr(city_clean," village","",.)
replace city_clean 	= subinstr(city_clean,"tract","",.)
replace city_clean 	= subinstr(city_clean," ward","",.)
replace city_clean 	= subinstr(city_clean,"assembly district","",.)
replace city_clean 	= subinstr(city_clean,"district","",.)
replace city_clean 	= subinstr(city_clean,"no.","",.)
replace city_clean 	= subinstr(city_clean,"precinct","",.)
replace city_clean 	= subinstr(city_clean,"subdivision","",.)
replace city_clean 	= subinstr(city_clean,"beat","",.)
replace city_clean 	= subinstr(city_clean,"plantation","",.)
replace city_clean 	= subinstr(city_clean,"census designated place","",.)
replace city_clean 	= subinstr(city_clean,"post office","",.)
replace city_clean 	= subinstr(city_clean,"township of","",.)
replace city_clean 	= subinstr(city_clean,"town of","",.)
replace city_clean 	= subinstr(city_clean,"borough of","",.)
replace city_clean 	= subinstr(city_clean,"city of","",.)
replace city_clean 	= subinstr(city_clean,"ward ","",1) if substr(city_clean,1,5) == "ward "
replace city_clean 	= subinstr(city_clean,"township ","",1) if substr(city_clean,1,9) == "township "
replace city_clean 	= "" if strpos(city_clean,"division") > 0
replace city_clean 	= subinstr(city_clean,"east side","",.)
replace city_clean 	= subinstr(city_clean,"west side","",.)
replace city_clean 	= subinstr(city_clean,"south side","",.)
replace city_clean 	= subinstr(city_clean,"north side","",.)
replace city_clean 	= subinstr(city_clean,"eastern side","",.)
replace city_clean 	= subinstr(city_clean,"western side","",.)
replace city_clean 	= subinstr(city_clean,"southern side","",.)
replace city_clean 	= subinstr(city_clean,"northern side","",.)
replace city_clean	= stritrim(city_clean)
replace city_clean	= "" if length(city_clean) < 2
replace city_clean	= strtrim(city_clean)
replace city_clean	= lower(city_clean)

replace city_clean 	= "east saint louis" if city_clean == "east st louis"
replace city_clean 	= "new york city" if city_clean == "long island city" & state == "NY"

replace city_clean 	= subinstr(city_clean,"-","",.)
replace city_clean 	= subinstr(city_clean,"south","",.)
replace city_clean 	= subinstr(city_clean,"north","",.)
replace city_clean 	= subinstr(city_clean,"east","",.)
replace city_clean 	= subinstr(city_clean,"west","",.)
replace city_clean 	= subinstr(city_clean,"southern","",.)
replace city_clean 	= subinstr(city_clean,"northern","",.)
replace city_clean 	= subinstr(city_clean,"eastern","",.)
replace city_clean 	= subinstr(city_clean,"western","",.)
replace city_clean 	= subinstr(city_clean," township","",.)
replace city_clean 	= subinstr(city_clean," point","",.)
replace city_clean 	= subinstr(city_clean," ","",.)

*Collapse at the local-year level
gen delegates_bpl_nonmissing = (nr_delegates_bpl_euroall != .)
gen delegates_anc_nonmissing = (nr_delegates_anc_euroall != .)
gcollapse (sum) votes nr_delegates_* delegates_bpl_nonmissing delegates_anc_nonmissing (firstnm) longitude latitude, by(lu_nr city_clean statecode year)
foreach var of varlist nr_delegates_bpl_* {
replace `var' = . if delegates_bpl_nonmissing == 0
}
foreach var of varlist nr_delegates_anc_* {
replace `var' = . if delegates_anc_nonmissing == 0
}

gen 	memb_proxy_votes = .
replace memb_proxy_votes = 50 if votes == 1
replace memb_proxy_votes = 250 if votes == 2
replace memb_proxy_votes = 750 if votes == 3
replace memb_proxy_votes = 1750 if votes > 3 & votes != .


*Collapse at the county-year level
geoinpoly latitude longitude using "$unionsrc/US_county_1930_WGS84_coord"
merge m:1 _ID using "$unionsrc/US_county_1930_WGS84_dbase_spmap", keepusing(GISJOIN*)
drop if _merge == 2
drop _merge
drop _ID
sort year lu_nr
rename (GISJOIN GISJOIN2) (gisjoin_1930 countynhg_1930)

gcollapse (sum) votes memb_proxy_votes nr_delegates_* delegates_bpl_nonmissing delegates_anc_nonmissing (count) lu_nr, by(year gisjoin_1930 countynhg_1930)
drop if gisjoin_1930 == ""
foreach var of varlist nr_delegates_bpl_* {
replace `var' = . if delegates_bpl_nonmissing == 0
}
foreach var of varlist nr_delegates_anc_* {
replace `var' = . if delegates_anc_nonmissing == 0
}
rename lu_nr locals_votes
foreach var of varlist locals memb_proxy_votes nr_delegates_* {
	rename `var' UBC_`var'
}

destring countynhg_1930, replace
keep year gisjoin_1930 countynhg_1930 ///
	 UBC_nr_delegates_bpl_* UBC_nr_delegates_anc_* ///
	 UBC_memb_proxy_votes UBC_locals_votes

label data "UBC county-year totals from convention proceedings (1900-1920)"
label var year "Year"
label var gisjoin_1930 "GISJOIN, 1930 county boundaries"
label var countynhg_1930 "NHGIS county code, 1930 boundaries"
label var UBC_locals_votes "Number of UBC locals sending delegates"
label var UBC_memb_proxy_votes "UBC membership proxy from voting strength"
label var UBC_nr_delegates_bpl_native "UBC delegates: native (last-name birthplace prob.)"
label var UBC_nr_delegates_bpl_other "UBC delegates: other origin (last-name birthplace prob.)"
label var UBC_nr_delegates_bpl_euroall "UBC delegates: any European (last-name birthplace prob.)"
label var UBC_nr_delegates_bpl_euronw "UBC delegates: NW European (last-name birthplace prob.)"
label var UBC_nr_delegates_bpl_eurose "UBC delegates: S/E European (last-name birthplace prob.)"
label var UBC_nr_delegates_anc_other "UBC delegates: other origin (last-name ancestry prob.)"
label var UBC_nr_delegates_anc_euroall "UBC delegates: any European (last-name ancestry prob.)"
label var UBC_nr_delegates_anc_euronw "UBC delegates: NW European (last-name ancestry prob.)"
label var UBC_nr_delegates_anc_eurose "UBC delegates: S/E European (last-name ancestry prob.)"

export delimited "$intmdata/UBC_votes_county1930.csv", replace nolabel


*------------------------------------------------------------------------------*
* IAM -- International Association of Machinists convention delegates
*
* Per IAM Constitution. The rule shifted across years:
*   1899 (in force for the 1900 convention, Article II Section 3):
*     "One (1) vote for every twenty-five (25) members or fraction
*     thereof, and one additional vote for every twenty-five (25) or
*     majority fraction thereof." Code: 19 members if 1 vote, 25*votes
*     thereafter.
*   1911 (in force for the 1910 and 1920 conventions, Article III
*     Section 3): "Each lodge shall be entitled to a delegate to the
*     Grand Lodge for every 200 members, or fraction thereof... voting
*     powers as follows: One vote for the first 100 members, or
*     fraction thereof, and one vote additional for every additional
*     100 members, or majority fraction thereof." Code: 125 if 1 vote,
*     100*(votes+1) thereafter.
*------------------------------------------------------------------------------*
* Votes/delegates *

import delimited "$unionsrc/IAM_votes_geocoded.csv", clear

keep score shortlabel addr_type type placename region regionabbr x y user_*

order user_*, first
rename user_* *

replace state = "District of Columbia" if state == "Dc" | state == "DC" | state == "D.C."

replace x = . if inlist(type,"State or Province","County") | score < 85 | state == "canada"
replace y = . if inlist(type,"State or Province","County") | score < 85 | state == "canada"

replace x = . if (state != lower(region) & state != region & proper(state) != proper(region))
replace y = . if (state != lower(region) & state != region & proper(state) != proper(region))

replace placename = "" if x == . & y == .

drop score shortlabel addr_type type region

foreach var of varlist placename {
	rename `var' geocode_`var'
} 
order(geocode_*), after(state)

rename regionabbr statecode
rename local_nr lu_nr
rename x longitude
rename y latitude

*Isolate last names of delegates
foreach var of varlist delegate {
	gen `var'_last = lower(`var')
	replace `var'_last = subinstr(`var'_last,"-","",.)
	replace `var'_last = subinstr(`var'_last,"_","",.)	
	replace `var'_last = subinstr(`var'_last,":","",.)	
	replace `var'_last = subinstr(`var'_last,"`","",.)	
	replace `var'_last = subinstr(`var'_last,"'","",.)
	replace `var'_last = subinstr(`var'_last,"*","",.)	
	replace `var'_last = subinstr(`var'_last,".","",.)	
	replace `var'_last = subinword(`var'_last,"jr","",.)
	replace `var'_last = subinword(`var'_last,"sr","",.)
	replace `var'_last = substr(`var'_last,strrpos(`var'_last," ")+1,strlen(`var'_last)-strrpos(`var'_last," ")) if strpos(`var'_last,", ") == 0
	replace `var'_last = substr(`var'_last,1,strpos(`var'_last,", ")-1) if strpos(`var'_last,", ") > 0
	replace `var'_last = subinstr(`var'_last,",","",.)	
	replace `var'_last  = strtrim(stritrim(`var'_last))
	replace `var'_last = `var' if strpos(`var'," ") == 0 & `var'_last == ""
	replace `var'_last = subinstr(`var'_last,"st.","st",.)
	replace `var'_last  = strtrim(stritrim(`var'_last))
} 

rename delegate_last delegate_lastname
drop delegate

*Year variable
replace year = 1900 if inrange(year,1900,1902) == 1
replace year = 1910 if inrange(year,1908,1912) == 1
replace year = 1920 if inrange(year,1918,1922) == 1

keep if inlist(year,1900,1910,1920) == 1

*Merge last names (exact string matching) w/ probability of belonging to a specific ethnic group  
rename delegate_lastname namelast
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

*Compute nr. of delegates from each group (natives or European), based on the last name of delegates
gegen nr_delegates_bpl_native = rowtotal(nameprob_bpl_native), missing	

foreach j in bpl anc {
		
gegen nr_delegates_`j'_other = rowtotal(nameprob_`j'_other), missing	
		
gegen nr_delegates_`j'_euroall = rowtotal(nameprob_`j'_denmark nameprob_`j'_finland nameprob_`j'_norway ///
											nameprob_`j'_sweden nameprob_`j'_uk nameprob_`j'_ireland nameprob_`j'_oth_northeu ///
											nameprob_`j'_belgium nameprob_`j'_france nameprob_`j'_luxemb nameprob_`j'_nether ///
											nameprob_`j'_switz nameprob_`j'_oth_westeu ///
											nameprob_`j'_italy nameprob_`j'_gr_pt_es nameprob_`j'_oth_southeu ///
											nameprob_`j'_aus_hung nameprob_`j'_czech nameprob_`j'_germany nameprob_`j'_poland ///
											nameprob_`j'_oth_easteu nameprob_`j'_oth_centereu ///
											nameprob_`j'_russia nameprob_`j'_oth_russeu), missing	

gegen nr_delegates_`j'_euronw = rowtotal(nameprob_`j'_denmark nameprob_`j'_finland nameprob_`j'_norway ///
											nameprob_`j'_sweden nameprob_`j'_uk nameprob_`j'_ireland nameprob_`j'_oth_northeu ///
											nameprob_`j'_belgium nameprob_`j'_france nameprob_`j'_luxemb nameprob_`j'_nether ///
											nameprob_`j'_switz nameprob_`j'_oth_westeu ///
											nameprob_`j'_germany), missing	
											
gegen nr_delegates_`j'_eurose = rowtotal(nameprob_`j'_italy nameprob_`j'_gr_pt_es nameprob_`j'_oth_southeu ///
											nameprob_`j'_aus_hung nameprob_`j'_czech nameprob_`j'_poland ///
											nameprob_`j'_oth_easteu nameprob_`j'_oth_centereu ///
											nameprob_`j'_russia nameprob_`j'_oth_russeu), missing	
											
}

drop nameprob*


* Normalize city names so that spelling variants collapse to a single key:
* lowercase the string and strip common decorations (punctuation, "mt." -> "mount",
* "st." -> "saint", ward / township / district / etc. suffixes), so that the
* local-year aggregation below treats e.g. "Saint Louis" and "St. Louis" as
* the same place.
gen 	city_clean 	= lower(geocode_placename)
replace city_clean	= lower(city) if city_clean == ""
order city_clean, after(city)
replace city_clean 	= subinstr(city_clean,"mt.","mount",.)
replace city_clean 	= subinstr(city_clean,"mt ","mount ",.)
replace city_clean 	= subinstr(city_clean,"st.","saint",.)
replace city_clean 	= subinstr(city_clean,"st","saint",1) if substr(city_clean,1,3) == "st "
replace city_clean 	= subinstr(city_clean,"indian reservation","reservation",.)
replace city_clean 	= subinstr(city_clean,"0","",.)
replace city_clean 	= subinstr(city_clean,"1","",.)
replace city_clean 	= subinstr(city_clean,"2","",.)
replace city_clean 	= subinstr(city_clean,"3","",.)
replace city_clean 	= subinstr(city_clean,"4","",.)
replace city_clean 	= subinstr(city_clean,"5","",.)
replace city_clean 	= subinstr(city_clean,"6","",.)
replace city_clean 	= subinstr(city_clean,"7","",.)
replace city_clean 	= subinstr(city_clean,"8","",.)
replace city_clean 	= subinstr(city_clean,"9","",.)
replace city_clean 	= subinstr(city_clean,",","",.)
replace city_clean 	= subinstr(city_clean,"?","",.)
replace city_clean 	= subinstr(city_clean,".","",.)
replace city_clean 	= subinstr(city_clean,"(","",.)
replace city_clean 	= subinstr(city_clean,")","",.)
replace city_clean 	= subinstr(city_clean,"/","",.)
replace city_clean 	= subinstr(city_clean," range ","",.)
replace city_clean 	= subinstr(city_clean," range(s) ","",.)
replace city_clean 	= subinstr(city_clean," range","",.) if substr(city_clean,-6,6) == " range" 
replace city_clean 	= subinstr(city_clean," range(s)","",.) if substr(city_clean,-9,9) == " range(s)" 
replace city_clean 	= subinstr(city_clean,"police jury","",.)
replace city_clean 	= subinstr(city_clean,"justice ward","",.)
replace city_clean 	= subinstr(city_clean,"court house","",.)
replace city_clean 	= subinstr(city_clean,"militia district","",.)
replace city_clean 	= subinstr(city_clean,"civil district","",.)
replace city_clean 	= subinstr(city_clean,"justice precinct","",.)
replace city_clean 	= subinstr(city_clean,"election district","",.)
replace city_clean 	= subinstr(city_clean,"undetermined","",.)
replace city_clean 	= subinstr(city_clean,"not stated","",.)
replace city_clean 	= subinstr(city_clean," village","",.)
replace city_clean 	= subinstr(city_clean,"tract","",.)
replace city_clean 	= subinstr(city_clean," ward","",.)
replace city_clean 	= subinstr(city_clean,"assembly district","",.)
replace city_clean 	= subinstr(city_clean,"district","",.)
replace city_clean 	= subinstr(city_clean,"no.","",.)
replace city_clean 	= subinstr(city_clean,"precinct","",.)
replace city_clean 	= subinstr(city_clean,"subdivision","",.)
replace city_clean 	= subinstr(city_clean,"beat","",.)
replace city_clean 	= subinstr(city_clean,"plantation","",.)
replace city_clean 	= subinstr(city_clean,"census designated place","",.)
replace city_clean 	= subinstr(city_clean,"post office","",.)
replace city_clean 	= subinstr(city_clean,"township of","",.)
replace city_clean 	= subinstr(city_clean,"town of","",.)
replace city_clean 	= subinstr(city_clean,"borough of","",.)
replace city_clean 	= subinstr(city_clean,"city of","",.)
replace city_clean 	= subinstr(city_clean,"ward ","",1) if substr(city_clean,1,5) == "ward "
replace city_clean 	= subinstr(city_clean,"township ","",1) if substr(city_clean,1,9) == "township "
replace city_clean 	= "" if strpos(city_clean,"division") > 0
replace city_clean 	= subinstr(city_clean,"east side","",.)
replace city_clean 	= subinstr(city_clean,"west side","",.)
replace city_clean 	= subinstr(city_clean,"south side","",.)
replace city_clean 	= subinstr(city_clean,"north side","",.)
replace city_clean 	= subinstr(city_clean,"eastern side","",.)
replace city_clean 	= subinstr(city_clean,"western side","",.)
replace city_clean 	= subinstr(city_clean,"southern side","",.)
replace city_clean 	= subinstr(city_clean,"northern side","",.)
replace city_clean	= stritrim(city_clean)
replace city_clean	= "" if length(city_clean) < 2
replace city_clean	= strtrim(city_clean)
replace city_clean	= lower(city_clean)

replace city_clean 	= "east saint louis" if city_clean == "east st louis"
replace city_clean 	= "new york city" if city_clean == "long island city" & state == "NY"

replace city_clean 	= subinstr(city_clean,"-","",.)
replace city_clean 	= subinstr(city_clean,"south","",.)
replace city_clean 	= subinstr(city_clean,"north","",.)
replace city_clean 	= subinstr(city_clean,"east","",.)
replace city_clean 	= subinstr(city_clean,"west","",.)
replace city_clean 	= subinstr(city_clean,"southern","",.)
replace city_clean 	= subinstr(city_clean,"northern","",.)
replace city_clean 	= subinstr(city_clean,"eastern","",.)
replace city_clean 	= subinstr(city_clean,"western","",.)
replace city_clean 	= subinstr(city_clean," township","",.)
replace city_clean 	= subinstr(city_clean," point","",.)
replace city_clean 	= subinstr(city_clean," ","",.)

*Collapse at the local-year level
gen delegates_bpl_nonmissing = (nr_delegates_bpl_euroall != .)
gen delegates_anc_nonmissing = (nr_delegates_anc_euroall != .)
gcollapse (sum) votes nr_delegates_* delegates_bpl_nonmissing delegates_anc_nonmissing (firstnm) longitude latitude, by(lu_nr city_clean statecode year)
foreach var of varlist nr_delegates_bpl_* {
replace `var' = . if delegates_bpl_nonmissing == 0
}
foreach var of varlist nr_delegates_anc_* {
replace `var' = . if delegates_anc_nonmissing == 0
}

gen 	memb_proxy_votes = .

replace memb_proxy_votes = 19 if votes == 1 & year == 1900
replace memb_proxy_votes = (votes * 25) if votes > 1 & votes != . & year == 1900

replace memb_proxy_votes = 125 if votes == 1 & inlist(year,1910,1920) == 1
replace memb_proxy_votes = 100*(votes+1) if votes > 1 & votes != . & inlist(year,1910,1920) == 1


*Collapse at the county-year level
geoinpoly latitude longitude using "$unionsrc/US_county_1930_WGS84_coord"
merge m:1 _ID using "$unionsrc/US_county_1930_WGS84_dbase_spmap", keepusing(GISJOIN*)
drop if _merge == 2
drop _merge
drop _ID
sort year lu_nr
rename (GISJOIN GISJOIN2) (gisjoin_1930 countynhg_1930)

replace lu_nr = 9999 if lu_nr == .
gcollapse (sum) votes memb_proxy_votes nr_delegates_* delegates_bpl_nonmissing delegates_anc_nonmissing (count) lu_nr, by(year gisjoin_1930 countynhg_1930)
drop if gisjoin_1930 == ""
foreach var of varlist nr_delegates_bpl_* {
replace `var' = . if delegates_bpl_nonmissing == 0
}
foreach var of varlist nr_delegates_anc_* {
replace `var' = . if delegates_anc_nonmissing == 0
}
rename lu_nr locals_votes
foreach var of varlist locals memb_proxy_votes nr_delegates_* {
	rename `var' IAM_`var'
}

destring countynhg_1930, replace
keep year gisjoin_1930 countynhg_1930 ///
	 IAM_nr_delegates_bpl_* IAM_nr_delegates_anc_* ///
	 IAM_memb_proxy_votes IAM_locals_votes

label data "IAM county-year totals from convention proceedings (1900-1920)"
label var year "Year"
label var gisjoin_1930 "GISJOIN, 1930 county boundaries"
label var countynhg_1930 "NHGIS county code, 1930 boundaries"
label var IAM_locals_votes "Number of IAM locals sending delegates"
label var IAM_memb_proxy_votes "IAM membership proxy from voting strength"
label var IAM_nr_delegates_bpl_native "IAM delegates: native (last-name birthplace prob.)"
label var IAM_nr_delegates_bpl_other "IAM delegates: other origin (last-name birthplace prob.)"
label var IAM_nr_delegates_bpl_euroall "IAM delegates: any European (last-name birthplace prob.)"
label var IAM_nr_delegates_bpl_euronw "IAM delegates: NW European (last-name birthplace prob.)"
label var IAM_nr_delegates_bpl_eurose "IAM delegates: S/E European (last-name birthplace prob.)"
label var IAM_nr_delegates_anc_other "IAM delegates: other origin (last-name ancestry prob.)"
label var IAM_nr_delegates_anc_euroall "IAM delegates: any European (last-name ancestry prob.)"
label var IAM_nr_delegates_anc_euronw "IAM delegates: NW European (last-name ancestry prob.)"
label var IAM_nr_delegates_anc_eurose "IAM delegates: S/E European (last-name ancestry prob.)"

export delimited "$intmdata/IAM_votes_county1930.csv", replace nolabel


*------------------------------------------------------------------------------*
* BMPIU -- Bricklayers, Masons & Plasterers' International Union
*          convention delegates
*
* Per BMPIU Constitution:
*   "Each union ... shall be entitled to three representatives for any
*   number of members up to two hundred and fifty, and an additional
*   representative or vote for each additional one hundred and fifty
*   members".
* So a local with N members has total votes = 3 + max(0, ceil((N-250)/150)),
* i.e., 3 votes for 1-250 members, 4 votes for 251-400, 5 for 401-550, ...
*
* Code:
*   163 members if 1-3 votes,
*   100*votes if votes > 3.
*------------------------------------------------------------------------------*
* Votes/delegates *

import delimited "$unionsrc/BMPIU_delegates_geocoded.csv", clear

keep score shortlabel addr_type type placename region regionabbr x y user_*

order user_*, first
rename user_* *

replace state = "District of Columbia" if state == "Dc" | state == "DC" | state == "D.C."

replace x = . if inlist(type,"State or Province","County") | score < 85 | state == "canada"
replace y = . if inlist(type,"State or Province","County") | score < 85 | state == "canada"

replace x = . if (state != lower(region) & state != region & proper(state) != proper(region))
replace y = . if (state != lower(region) & state != region & proper(state) != proper(region))

replace placename = "" if x == . & y == .

drop score shortlabel addr_type type region

foreach var of varlist placename {
	rename `var' geocode_`var'
} 
order(geocode_*), after(state)

rename regionabbr statecode
rename x longitude
rename y latitude

*Isolate last names of delegates
foreach var of varlist delegate {
	gen `var'_last = lower(`var')
	replace `var'_last = subinstr(`var'_last,",","",.)
	replace `var'_last = subinstr(`var'_last,"-","",.)
	replace `var'_last = subinstr(`var'_last,"_","",.)	
	replace `var'_last = subinstr(`var'_last,":","",.)	
	replace `var'_last = subinstr(`var'_last,"`","",.)	
	replace `var'_last = subinstr(`var'_last,"'","",.)
	replace `var'_last = subinstr(`var'_last,"*","",.)	
	replace `var'_last = subinstr(`var'_last,".","",.)	
	replace `var'_last = subinword(`var'_last,"jr","",.)
	replace `var'_last = subinword(`var'_last,"sr","",.)	
	replace `var'_last  = strtrim(stritrim(`var'_last))
	replace `var'_last = `var' if strpos(`var'," ") == 0 & `var'_last == ""
	replace `var'_last = subinstr(`var'_last,"st.","st",.)
	replace `var'_last = substr(`var'_last,strrpos(`var'_last," ")+1,strlen(`var'_last)-strrpos(`var'_last," "))
	replace `var'_last  = strtrim(stritrim(`var'_last))
} 

rename delegate_last delegate_lastname
drop delegate

*Year variable
replace year = 1900 if inrange(year,1900,1902) == 1
replace year = 1910 if inrange(year,1908,1912) == 1
replace year = 1920 if inrange(year,1918,1922) == 1

keep if inlist(year,1900,1910,1920) == 1

*Merge last names (exact string matching) w/ probability of belonging to a specific ethnic group  
rename delegate_lastname namelast
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

*Compute nr. of delegates from each group (natives or European), based on the last name of delegates
gegen nr_delegates_bpl_native = rowtotal(nameprob_bpl_native), missing	

foreach j in bpl anc {
		
gegen nr_delegates_`j'_other = rowtotal(nameprob_`j'_other), missing	
		
gegen nr_delegates_`j'_euroall = rowtotal(nameprob_`j'_denmark nameprob_`j'_finland nameprob_`j'_norway ///
											nameprob_`j'_sweden nameprob_`j'_uk nameprob_`j'_ireland nameprob_`j'_oth_northeu ///
											nameprob_`j'_belgium nameprob_`j'_france nameprob_`j'_luxemb nameprob_`j'_nether ///
											nameprob_`j'_switz nameprob_`j'_oth_westeu ///
											nameprob_`j'_italy nameprob_`j'_gr_pt_es nameprob_`j'_oth_southeu ///
											nameprob_`j'_aus_hung nameprob_`j'_czech nameprob_`j'_germany nameprob_`j'_poland ///
											nameprob_`j'_oth_easteu nameprob_`j'_oth_centereu ///
											nameprob_`j'_russia nameprob_`j'_oth_russeu), missing	

gegen nr_delegates_`j'_euronw = rowtotal(nameprob_`j'_denmark nameprob_`j'_finland nameprob_`j'_norway ///
											nameprob_`j'_sweden nameprob_`j'_uk nameprob_`j'_ireland nameprob_`j'_oth_northeu ///
											nameprob_`j'_belgium nameprob_`j'_france nameprob_`j'_luxemb nameprob_`j'_nether ///
											nameprob_`j'_switz nameprob_`j'_oth_westeu ///
											nameprob_`j'_germany), missing	
											
gegen nr_delegates_`j'_eurose = rowtotal(nameprob_`j'_italy nameprob_`j'_gr_pt_es nameprob_`j'_oth_southeu ///
											nameprob_`j'_aus_hung nameprob_`j'_czech nameprob_`j'_poland ///
											nameprob_`j'_oth_easteu nameprob_`j'_oth_centereu ///
											nameprob_`j'_russia nameprob_`j'_oth_russeu), missing	
											
}

drop nameprob*

gen votes = 1

* Normalize city names so that spelling variants collapse to a single key:
* lowercase the string and strip common decorations (punctuation, "mt." -> "mount",
* "st." -> "saint", ward / township / district / etc. suffixes), so that the
* local-year aggregation below treats e.g. "Saint Louis" and "St. Louis" as
* the same place.
gen 	city_clean 	= lower(geocode_placename)
replace city_clean	= lower(city) if city_clean == ""
order city_clean, after(city)
replace city_clean 	= subinstr(city_clean,"mt.","mount",.)
replace city_clean 	= subinstr(city_clean,"mt ","mount ",.)
replace city_clean 	= subinstr(city_clean,"st.","saint",.)
replace city_clean 	= subinstr(city_clean,"st","saint",1) if substr(city_clean,1,3) == "st "
replace city_clean 	= subinstr(city_clean,"indian reservation","reservation",.)
replace city_clean 	= subinstr(city_clean,"0","",.)
replace city_clean 	= subinstr(city_clean,"1","",.)
replace city_clean 	= subinstr(city_clean,"2","",.)
replace city_clean 	= subinstr(city_clean,"3","",.)
replace city_clean 	= subinstr(city_clean,"4","",.)
replace city_clean 	= subinstr(city_clean,"5","",.)
replace city_clean 	= subinstr(city_clean,"6","",.)
replace city_clean 	= subinstr(city_clean,"7","",.)
replace city_clean 	= subinstr(city_clean,"8","",.)
replace city_clean 	= subinstr(city_clean,"9","",.)
replace city_clean 	= subinstr(city_clean,",","",.)
replace city_clean 	= subinstr(city_clean,"?","",.)
replace city_clean 	= subinstr(city_clean,".","",.)
replace city_clean 	= subinstr(city_clean,"(","",.)
replace city_clean 	= subinstr(city_clean,")","",.)
replace city_clean 	= subinstr(city_clean,"/","",.)
replace city_clean 	= subinstr(city_clean," range ","",.)
replace city_clean 	= subinstr(city_clean," range(s) ","",.)
replace city_clean 	= subinstr(city_clean," range","",.) if substr(city_clean,-6,6) == " range" 
replace city_clean 	= subinstr(city_clean," range(s)","",.) if substr(city_clean,-9,9) == " range(s)" 
replace city_clean 	= subinstr(city_clean,"police jury","",.)
replace city_clean 	= subinstr(city_clean,"justice ward","",.)
replace city_clean 	= subinstr(city_clean,"court house","",.)
replace city_clean 	= subinstr(city_clean,"militia district","",.)
replace city_clean 	= subinstr(city_clean,"civil district","",.)
replace city_clean 	= subinstr(city_clean,"justice precinct","",.)
replace city_clean 	= subinstr(city_clean,"election district","",.)
replace city_clean 	= subinstr(city_clean,"undetermined","",.)
replace city_clean 	= subinstr(city_clean,"not stated","",.)
replace city_clean 	= subinstr(city_clean," village","",.)
replace city_clean 	= subinstr(city_clean,"tract","",.)
replace city_clean 	= subinstr(city_clean," ward","",.)
replace city_clean 	= subinstr(city_clean,"assembly district","",.)
replace city_clean 	= subinstr(city_clean,"district","",.)
replace city_clean 	= subinstr(city_clean,"no.","",.)
replace city_clean 	= subinstr(city_clean,"precinct","",.)
replace city_clean 	= subinstr(city_clean,"subdivision","",.)
replace city_clean 	= subinstr(city_clean,"beat","",.)
replace city_clean 	= subinstr(city_clean,"plantation","",.)
replace city_clean 	= subinstr(city_clean,"census designated place","",.)
replace city_clean 	= subinstr(city_clean,"post office","",.)
replace city_clean 	= subinstr(city_clean,"township of","",.)
replace city_clean 	= subinstr(city_clean,"town of","",.)
replace city_clean 	= subinstr(city_clean,"borough of","",.)
replace city_clean 	= subinstr(city_clean,"city of","",.)
replace city_clean 	= subinstr(city_clean,"ward ","",1) if substr(city_clean,1,5) == "ward "
replace city_clean 	= subinstr(city_clean,"township ","",1) if substr(city_clean,1,9) == "township "
replace city_clean 	= "" if strpos(city_clean,"division") > 0
replace city_clean 	= subinstr(city_clean,"east side","",.)
replace city_clean 	= subinstr(city_clean,"west side","",.)
replace city_clean 	= subinstr(city_clean,"south side","",.)
replace city_clean 	= subinstr(city_clean,"north side","",.)
replace city_clean 	= subinstr(city_clean,"eastern side","",.)
replace city_clean 	= subinstr(city_clean,"western side","",.)
replace city_clean 	= subinstr(city_clean,"southern side","",.)
replace city_clean 	= subinstr(city_clean,"northern side","",.)
replace city_clean	= stritrim(city_clean)
replace city_clean	= "" if length(city_clean) < 2
replace city_clean	= strtrim(city_clean)
replace city_clean	= lower(city_clean)

replace city_clean 	= "east saint louis" if city_clean == "east st louis"
replace city_clean 	= "new york city" if city_clean == "long island city" & state == "NY"

replace city_clean 	= subinstr(city_clean,"-","",.)
replace city_clean 	= subinstr(city_clean,"south","",.)
replace city_clean 	= subinstr(city_clean,"north","",.)
replace city_clean 	= subinstr(city_clean,"east","",.)
replace city_clean 	= subinstr(city_clean,"west","",.)
replace city_clean 	= subinstr(city_clean,"southern","",.)
replace city_clean 	= subinstr(city_clean,"northern","",.)
replace city_clean 	= subinstr(city_clean,"eastern","",.)
replace city_clean 	= subinstr(city_clean,"western","",.)
replace city_clean 	= subinstr(city_clean," township","",.)
replace city_clean 	= subinstr(city_clean," point","",.)
replace city_clean 	= subinstr(city_clean," ","",.)

*Collapse at the local-year level
gen delegates_bpl_nonmissing = (nr_delegates_bpl_euroall != .)
gen delegates_anc_nonmissing = (nr_delegates_anc_euroall != .)
gcollapse (sum) votes nr_delegates_* delegates_bpl_nonmissing delegates_anc_nonmissing (firstnm) longitude latitude union_order, by(lu_nr city_clean statecode year)
foreach var of varlist nr_delegates_bpl_* {
replace `var' = . if delegates_bpl_nonmissing == 0
}
foreach var of varlist nr_delegates_anc_* {
replace `var' = . if delegates_anc_nonmissing == 0
}

gen 	memb_proxy_votes = .
replace memb_proxy_votes = 163 if inrange(votes,1,3)
replace memb_proxy_votes = (votes * 100) if votes > 3 & votes != .

*Collapse at the county-year level
geoinpoly latitude longitude using "$unionsrc/US_county_1930_WGS84_coord"
merge m:1 _ID using "$unionsrc/US_county_1930_WGS84_dbase_spmap", keepusing(GISJOIN*)
drop if _merge == 2
drop _merge
drop _ID
sort year union_order lu_nr
rename (GISJOIN GISJOIN2) (gisjoin_1930 countynhg_1930)

gcollapse (sum) votes nr_delegates_* delegates_bpl_nonmissing delegates_anc_nonmissing memb_proxy_votes (count) lu_nr, by(year gisjoin_1930 countynhg_1930)
drop if gisjoin_1930 == ""
foreach var of varlist nr_delegates_bpl_* {
replace `var' = . if delegates_bpl_nonmissing == 0
}
foreach var of varlist nr_delegates_anc_* {
replace `var' = . if delegates_anc_nonmissing == 0
}

rename lu_nr locals_votes
foreach var of varlist locals memb_proxy_votes nr_delegates_* {
	rename `var' BMPIU_`var'
}

destring countynhg_1930, replace
keep year gisjoin_1930 countynhg_1930 ///
	 BMPIU_nr_delegates_bpl_* BMPIU_nr_delegates_anc_* ///
	 BMPIU_memb_proxy_votes BMPIU_locals_votes

label data "BMPIU county-year totals from convention proceedings (1900-1920)"
label var year "Year"
label var gisjoin_1930 "GISJOIN, 1930 county boundaries"
label var countynhg_1930 "NHGIS county code, 1930 boundaries"
label var BMPIU_locals_votes "Number of BMPIU locals sending delegates"
label var BMPIU_memb_proxy_votes "BMPIU membership proxy from voting strength"
label var BMPIU_nr_delegates_bpl_native "BMPIU delegates: native (last-name birthplace prob.)"
label var BMPIU_nr_delegates_bpl_other "BMPIU delegates: other origin (last-name birthplace prob.)"
label var BMPIU_nr_delegates_bpl_euroall "BMPIU delegates: any European (last-name birthplace prob.)"
label var BMPIU_nr_delegates_bpl_euronw "BMPIU delegates: NW European (last-name birthplace prob.)"
label var BMPIU_nr_delegates_bpl_eurose "BMPIU delegates: S/E European (last-name birthplace prob.)"
label var BMPIU_nr_delegates_anc_other "BMPIU delegates: other origin (last-name ancestry prob.)"
label var BMPIU_nr_delegates_anc_euroall "BMPIU delegates: any European (last-name ancestry prob.)"
label var BMPIU_nr_delegates_anc_euronw "BMPIU delegates: NW European (last-name ancestry prob.)"
label var BMPIU_nr_delegates_anc_eurose "BMPIU delegates: S/E European (last-name ancestry prob.)"

export delimited "$intmdata/BMPIU_votes_county1930.csv", replace nolabel

*------------------------------------------------------------------------------*
* ITU -- International Typographical Union, per-local membership
*
* The ITU convention proceedings list per-local membership directly,
* so no rep-rule inversion is needed. The pipeline aggregates the
* directly-recorded membership counts to the county level.
*------------------------------------------------------------------------------*
* Members *

import delimited "$unionsrc/ITU_members_geocoded.csv", clear

keep score shortlabel addr_type type placename region regionabbr x y user_*

order user_*, first
rename user_* *

replace state = "District of Columbia" if state == "Dc" | state == "DC" | state == "D.C."

replace x = . if inlist(type,"State or Province","County") | score < 85 | state == "canada"
replace y = . if inlist(type,"State or Province","County") | score < 85 | state == "canada"

replace x = . if (state != lower(region) & state != region & proper(state) != proper(region))
replace y = . if (state != lower(region) & state != region & proper(state) != proper(region))

replace placename = "" if x == . & y == .

drop score shortlabel addr_type type region

foreach var of varlist placename {
	rename `var' geocode_`var'
} 
order(geocode_*), after(state)

rename regionabbr statecode
rename x longitude
rename y latitude


replace year = 1900 if year == 1902


*Collapse at the county-year level
geoinpoly latitude longitude using "$unionsrc/US_county_1930_WGS84_coord"
merge m:1 _ID using "$unionsrc/US_county_1930_WGS84_dbase_spmap", keepusing(GISJOIN*)
drop if _merge == 2
drop _merge
drop _ID
sort year lu_nr
rename (GISJOIN GISJOIN2) (gisjoin_1930 countynhg_1930)

gcollapse (sum) members (count) lu_nr, by(year gisjoin_1930 countynhg_1930)
drop if gisjoin_1930 == ""

rename lu_nr locals_votes
foreach var of varlist locals members {
	rename `var' ITU_`var'
}

destring countynhg_1930, replace
keep year gisjoin_1930 countynhg_1930 ITU_locals_votes ITU_members

label data "ITU county-year totals from convention proceedings (1900-1920)"
label var year "Year"
label var gisjoin_1930 "GISJOIN, 1930 county boundaries"
label var countynhg_1930 "NHGIS county code, 1930 boundaries"
label var ITU_locals_votes "Number of ITU locals reporting members"
label var ITU_members "ITU membership reported per-local in proceedings"

export delimited "$intmdata/ITU_members_county1930.csv", replace nolabel
