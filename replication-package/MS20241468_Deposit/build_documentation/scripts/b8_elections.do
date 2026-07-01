*==============================================================================*
* b8_elections.do
*
* Builds county-level historical election-results datasets (Democratic,
* Socialist, and Know-Nothing vote shares) from ICPSR Study 1, the United
* States Historical Election Returns.
*
* INPUTS  (in $rawlocal/):
*   ICPSR_00001/DS####/   - U.S. Historical Election Returns, ICPSR Study 1  [pointer]
*                           (one SPSS .sav file per DS#### subfolder)
*
* OUTPUTS (in $intmdata/; b16 ships these to data/public/census_aggregates/):
*   ICPSR_00001/DS####.dta   - per-dataset intermediates
*   electionresults_1856_county.dta
*   electionresults_1886-1924_county.dta
*
* [pointer] = third-party data not shipped in the package; the replicator
*             downloads ICPSR Study 1 and places it under $rawlocal/ICPSR_00001/.
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

* Per-dataset intermediates are globbed by folder, so they need a dedicated
* subfolder (kept separate from the otherwise-flat intermediate directory).
cap mkdir "$intmdata/ICPSR_00001"


*------------------------------------------------------------------------------*
* Import each ICPSR dataset and extract the presidential-vote columns
*
* ICPSR Study 1 ships one SPSS (.sav) file per dataset, in folders DS0001 to
* DS0203. The loop below imports each file, applies any dataset-specific fixes
* (the scattered  if `n' == ...  blocks), extracts the presidential-vote
* columns, drops the state-total row (countyicp 9999) and unidentified
* counties, and saves a per-dataset .dta. They are merged into one panel
* further below.
*
* Within a file, returns sit in variables whose variable LABEL encodes the
* election year, office, and party. The  ds, has(varlabel ...)  searches pick
* the right column by label pattern. Codes the script looks for:
*   year   : 856, 888, 892, ... 926   -> elections 1856 and 1888-1924
*   office : PRES                      (presidential)
*   party  : 0100 Democratic    0200 Republican    TOTAL total vote cast
*            0380 / 0511 -> Socialist
*            0310 / 1235 -> Know-Nothing / American Party
*------------------------------------------------------------------------------*

forvalues n=1/203 {

	local dsfolder = "DS" + string(`n',"%04.0f")
	local file: dir "$rawlocal/ICPSR_00001/`dsfolder'/" files "*.sav"
	local count = 0
	foreach i of local file {
	local count = `count' + 1
	if `count' == 1 {
	import spss using "$rawlocal/ICPSR_00001/`dsfolder'/`i'", clear

	* Dataset-specific fixes for known quirks in particular ICPSR files
	* (combining vote columns the source splits, re-ordering or dropping
	* source variables) so the label-based extraction below works.
	if `n' == 87 {
	replace V360 = V360 + V362
	}
	if `n' == 88 {
	replace V23 = V23 + V25
	}	
	if `n' == 91 {
	replace V367 = V367 + V370
	}		
	if `n' == 100 {
	replace V20 = V20 + V25
	}	
	if `n' == 104 {
	replace V52 = V52 + V57
	}	
	if `n' == 170 {
	replace V183 = V183 + V185
	}	
	if `n' == 174 {
	replace V36 = V36 + V41
	replace V71 = V71 + V75	
	replace V221 = V222
	replace V222 = V223
	replace V223 = V224
	replace V224 = V219 + V220 + V221 + V222 + V223
	}	
	if `n' == 177 {
	replace V72 = V72 + V77
	}
	if `n' == 179 {
	replace V257 = V257 + V262
	}	
	if `n' == 188 {
	replace V39 = V39 + V42
	}
	if `n' == 190 {
	drop V114
	}
	if `n' == 191 {
	replace V7 = V7 + V9
	}	
	if `n' == 195 {
	replace V326 = V326 + V332
	}	
	if `n' == 124 {
	replace V105 = V102 + V103 + V104 if V105 == .
	}
	if `n' == 199 {
	replace V234 = V227 + V228 + V229 + V230 + V231 + V232 + V233 if V234 == .
	}
	rename (V1 V2 V3) (stateicp countyname countyicp)
	tostring V*, replace
	foreach year of numlist 856 888(4)926 {
	ds, has(varlabel "`year'*PRES*0100*")
	local vars = "`r(varlist)'"
	local count = 0
	foreach var of local vars {
	local count = `count' + 1
	if `count' == 1 {
	rename `var' demvote_1`year'		
	}
	}
	ds, has(varlabel "`year'*PRES*0200*")
	local vars = "`r(varlist)'"
	local count = 0
	foreach var of local vars {
	local count = `count' + 1
	if `count' == 1 {
	cap rename `r(varlist)' repvote_1`year'	
	}
	}	
	ds, has(varlabel "`year'*PRES*0380*")
	local vars = "`r(varlist)'"
	local count = 0
	foreach var of local vars {
	local count = `count' + 1
	if `count' == 1 {
	cap rename `r(varlist)' socvote_1`year'	
	}
	}	
	ds, has(varlabel "`year'*PRES*0511*")
	local vars = "`r(varlist)'"
	local count = 0
	foreach var of local vars {
	local count = `count' + 1
	if `count' == 1 {
	cap rename `r(varlist)' socvote_1`year'	
	}
	}	
	ds, has(varlabel "`year'*PRES*0310*")
	local vars = "`r(varlist)'"
	local count = 0
	foreach var of local vars {
	local count = `count' + 1
	if `count' == 1 {
	cap rename `r(varlist)' knownotvote_1`year'	
	}
	}	
	ds, has(varlabel "`year'*PRES*1235*")
	local vars = "`r(varlist)'"
	local count = 0
	foreach var of local vars {
	local count = `count' + 1
	if `count' == 1 {
	cap rename `r(varlist)' knownotvote_1`year'	
	}
	}		
	ds, has(varlabel "`year'*PRES*TOTAL*")	
	local vars = "`r(varlist)'"
	local count = 0
	foreach var of local vars {
	local count = `count' + 1
	if `count' == 1 {
	cap rename `r(varlist)' totvote_1`year'	
	}
	}		
	}
	* Dataset-specific fixes: hand-rename vote columns the label search above
	* missed, and correct miscoded county/state ICP identifiers.
	if `n' == 38 {
	rename V135 demvote_1896
	}	
	if `n' == 87 {
	rename V310 demvote_1892
	}
	if `n' == 91 {
	rename V402 demvote_1900
	}	
	if `n' == 99 {
	rename V310 demvote_1896
	rename V343 demvote_1900
	rename V404 demvote_1908	
	}		
	if `n' == 42 {
	replace stateicp = 13 if stateicp == .	
	}	
	if `n' == 64 | `n' == 65 {
	replace countyicp = 1570 if countyicp == 1510 & countyname == "TUSCOLA"
	replace countyicp = 1590 if countyicp == 1530 & countyname == "VAN BUREN"
	replace countyicp = 1610 if countyicp == 1550 & countyname == "WASHTENAW"
	replace countyicp = 1630 if countyicp == 1570 & countyname == "WAYNE"
	replace countyicp = 1650 if countyicp == 1590 & countyname == "WEXFORD"
	}
	if `n' == 87 | `n' == 88 {
	replace countyicp = 1350 if countyicp == 1370 & countyname == "NESS"
	replace countyicp = 1330 if countyicp == 1350 & countyname == "NEOSHO/DORN"
	}
	if `n' == 104 {
	rename V131 demvote_1900
	}	
	if `n' == 107 {
	rename V81 demvote_1896
	rename V110 demvote_1900
	}	
	if `n' == 139 {
	rename V176 demvote_1896
	}	
	if `n' == 170 {
	rename V265 demvote_1900
	}	
	if `n' == 172 {
	rename V65 demvote_1920
	}	
	if `n' == 179 {
	rename V289 demvote_1900
	rename V324 demvote_1904
	}
	if `n' == 195 {
	rename V355 demvote_1900
	}		
	if `n' == 146 {
	replace stateicp = 49 if stateicp == .	
	}
	if `n' == 126 | `n' == 127 {
	replace countyicp = 1570 if countyicp == 1510 & countyname == "JACKSON"
	}
	if `n' == 134 | `n' == 135 {
	replace countyicp = 490 if countyicp == 470 & countyname == "HINDS"
	}		
	drop if countyicp == .
	drop if countyicp == 9999
	drop V*
	save "$intmdata/ICPSR_00001/`dsfolder'.dta", replace

}
}
}


*------------------------------------------------------------------------------*
* Merge the per-dataset files into one county panel and build the outputs
*------------------------------------------------------------------------------*

* Start from a one-row seed keyed on stateicp x countyicp, then merge every
* saved DS file in turn (update lets each file fill cells the others lack).
clear all
set obs 1
gen stateicp = .
gen countyicp = .
local file: dir "$intmdata/ICPSR_00001/" files "*.dta"
foreach i of local file {
	merge 1:1 stateicp countyicp using "$intmdata/ICPSR_00001/`i'", update
	drop _merge
}

* The per-dataset files are intermediate -- needed only for the merge above.
* Erase them so $intmdata holds just the final election-results datasets.
foreach i of local file {
	erase "$intmdata/ICPSR_00001/`i'"
}
cap rmdir "$intmdata/ICPSR_00001"

order *demvote* *repvote* *socvote* *knownotvote* *totvote*, sequential
order stateicp countyicp countyname, first

destring stateicp countyicp *vote*, replace
drop if countyicp == .

* Know-Nothing / American Party returns are used only for 1856; drop the
* (otherwise empty) Know-Nothing columns for every other election year.
drop knownotvote_1924 knownotvote_1888 knownotvote_1916 knownotvote_1896 ///
	 knownotvote_1900 knownotvote_1904 knownotvote_1908 knownotvote_1912 knownotvote_1920
	 
* 9999999 is the ICPSR no-data code -> set those cells to missing.
foreach var of varlist *vote_* {
	replace `var' = . if `var' == 9999999
}	 

reshape long demvote_ repvote_ socvote_ knownotvote_ totvote_, i(stateicp countyicp countyname) j(year)
rename *vote_ *vote

* Drop county-years with no presidential election (no total vote) and rows
* where every party's vote is zero (no contest recorded).
drop if totvote == . | totvote == 0
drop if demvote == 0 & repvote == 0 & (socvote == 0 | socvote == .) & (knownotvote == 0 | knownotvote == .)

* Republican vote is not used downstream. The Socialist party first fielded a
* presidential ticket in 1900: blank socvote before 1900, and treat a missing
* cell from 1900 on as a true zero. Know-Nothing returns apply only to 1856.
drop repvote
replace socvote = . if year < 1900
replace socvote = 0 if socvote == . & year >= 1900
replace knownotvote = . if year > 1856
order year, first

* Output 1: the 1856 cross-section -- Know-Nothing and total vote, the inputs
* to the 1856 American-Party vote share.
preserve
keep if year == 1856
reshape wide knownotvote totvote, i(stateicp countyicp countyname) j(year)
keep stateicp countyicp countyname totvote1856 knownotvote1856
rename *vote* *vote_*
save "$intmdata/electionresults_1856_county.dta", replace
restore

* Output 2: the 1886-1924 county panel. Group each presidential election into
* its decade, then reshape to one row per county-decade with a column per
* election year in the decade.
gen 	decade = .
replace decade = 1890 if inrange(year,1886,1894)
replace decade = 1900 if inrange(year,1896,1904) 
replace decade = 1910 if inrange(year,1906,1914) 
replace decade = 1920 if inrange(year,1916,1924) 

reshape wide demvote socvote knownotvote* totvote, i(stateicp countyicp countyname decade) j(year)
rename *vote* *vote_*
rename decade year
order year, first

save "$intmdata/electionresults_1886-1924_county.dta", replace




