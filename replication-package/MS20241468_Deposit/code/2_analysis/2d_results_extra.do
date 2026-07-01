*==============================================================================*
* 2d_results_extra.do
*
* Additional results: a control-function specification of the baseline IV;
* heterogeneity by origin-country traits (strength of the labor movement,
* support for socialist parties); by the presence of other unions (KoL, IWW);
* and effects on local economic outcomes.
*
* INPUTS:
*   $data/analysis_dataset_county1930.dta          - analysis dataset (1h)
*   $code/2_analysis/2_sample_specifications.do   - sample definition
*
* OUTPUT: tables in $tables/ and figures in $figures/ (see section banners).
*
* Run via 00_master.do, or standalone.
*==============================================================================*

clear all
set more off, perm

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

use "$data/analysis_dataset_county1930.dta", clear

do "$code/2_analysis/2_sample_specifications.do"

*------------------------------------------------------------------------------*
* Control function: first-stage residual entered in the baseline equation
* Paper: Control Function Estimates (Table A.4); outputs controlfunction
*------------------------------------------------------------------------------*

local n = 4

preserve

* First-stage residual: regress the immigrant share on the shift-share
* instrument under the baseline specification and store the residual.
reghdfe sh_euro_wa_10yr_m			 pr1890_sh_euro_wa_10yr_m ///
									 if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
									 a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}") residuals(res_sh_euro_wa_10yr_m)
label var res_sh_euro_wa_10yr_m "Share of Immigrants (first-stage residuals)"

* Outcome regressed on the immigrant share and the first-stage residual
local filename = "controlfunction"
local union = "all"

foreach fmt in txt xml {
cap erase "$tables/`filename'.`fmt'"
}

foreach outcome in pres ihsloc dens avgmemb {

local union = "all"
local var = "afl_comb_`union'_`outcome'"

reghdfe `var'						 sh_euro_wa_10yr_m res_sh_euro_wa_10yr_m ///
									 if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
									 a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}")

local obs = string(e(N),"%15.0f")
qui sum `var' if e(sample) == 1
if "`outcome'" == "ihsloc" {
qui sum afl_comb_`union'_locals if e(sample) == 1
}
local depvarmean = string(r(mean),"%6.3fc")
qui sum sh_euro_wa_10yr_m if e(sample) == 1
local sheuromean = string(r(mean),"%6.3fc")
local sheurostdev = string(r(sd),"%6.3fc")
outreg2 using "$tables/`filename'", noobs append dec(3) label nor2 nocons stats(coef se) paren(se) ///
									addtext("Nr. observations", "`obs'", Dep. var. mean, "`depvarmean'", ///
									Indep. var. mean, "`sheuromean'", ///
									"${fetext}, ${controlstext`n'}") ///
									excel nonotes keep(*sh_euro*)

}

foreach fmt in txt {
cap erase "$tables/`filename'.`fmt'"
}

restore

*------------------------------------------------------------------------------*
* Heterogeneity by strength of the labor movement in the origin country
* Paper: Heterogeneous Effects by Strength of Labor Movement in Country of Origin (Table A.8); output het_unionseurope_all
*------------------------------------------------------------------------------*

foreach union in all {

local filename = "het_unionseurope_`union'"
local n = 4	

foreach fmt in txt xml {	
cap erase "$tables/`filename'.`fmt'"		
}

preserve

foreach outcome in pres ihsloc dens avgmemb {	

local var = "afl_comb_`union'_`outcome'"

ivreghdfe `var'						 (sh_unionh_wa_10yr_m sh_unionl_wa_10yr_m = pr1890_sh_unionh_wa_10yr_m pr1890_sh_unionl_wa_10yr_m) ///
									 if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
									 a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}") first

local obs = string(e(N),"%15.0f")									 
local fstat = string(`e(widstat)',"%6.2fc")
mat first = e(first)
local partfstat1 = string(first[8,1],"%6.2fc")
local partfstat2 = string(first[8,2],"%6.2fc")
qui sum `var' if e(sample) == 1
if "`outcome'" == "ihsloc" {
qui sum afl_comb_`union'_locals if e(sample) == 1
} 
local depvarmean = string(r(mean),"%6.3fc")
qui sum sh_unionh_wa_10yr_m if e(sample) == 1
local sheuromean1 = string(r(mean),"%6.3fc")
qui sum sh_unionl_wa_10yr_m if e(sample) == 1
local sheuromean2 = string(r(mean),"%6.3fc")
outreg2 using "$tables/`filename'", append dec(3) label nor2 nocons stats(coef se beta) bracket(beta) paren(se) ///
									addtext(Outcome mean, "`depvarmean'", Imm. Share mean UK-Ireland, "`sheuromean1'", ///
									Imm. Share mean Other countries, "`sheuromean2'", KP F-stat, "`fstat'", ///
									SW F-stat 1, "`partfstat1'", SW F-stat 2, "`partfstat2'", ///
									"${fetext}, ${controlstext`n'}") ///
									excel nonotes keep(sh_*) 
								
}

restore

foreach fmt in txt {	
cap erase "$tables/`filename'.`fmt'"		
}

}

*------------------------------------------------------------------------------*
* Heterogeneity by strength of socialist parties in the origin country
* Paper: Heterogeneous Effects by Support for Socialist Parties in Country of Origin (Table A.9);
*        outputs het_socparteurope10_all, het_socparteurope20_all
*------------------------------------------------------------------------------*

foreach q in 10 20 {
	
foreach union in all {

local filename = "het_socparteurope`q'_`union'"
local n = 4	

foreach fmt in txt xml {	
cap erase "$tables/`filename'.`fmt'"		
}

preserve

foreach outcome in pres ihsloc dens avgmemb {	

local var = "afl_comb_`union'_`outcome'"

ivreghdfe `var'						 (sh_soc`q'_wa_10yr_m sh_nonsoc`q'_wa_10yr_m = ///
									  pr1890_sh_soc`q'_wa_10yr_m pr1890_sh_nonsoc`q'_wa_10yr_m) ///
									 if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
									 a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}") first

local obs = string(e(N),"%15.0f")									 
local fstat = string(`e(widstat)',"%6.2fc")
mat first = e(first)
local partfstat1 = string(first[8,1],"%6.2fc")
local partfstat2 = string(first[8,2],"%6.2fc")
qui sum `var' if e(sample) == 1
if "`outcome'" == "ihsloc" {
qui sum afl_comb_`union'_locals if e(sample) == 1
} 
local depvarmean = string(r(mean),"%6.3fc")
qui sum sh_soc`q'_wa_10yr_m if e(sample) == 1
local sheuromean1 = string(r(mean),"%6.3fc")
qui sum sh_nonsoc`q'_wa_10yr_m if e(sample) == 1
local sheuromean2 = string(r(mean),"%6.3fc")
outreg2 using "$tables/`filename'", append dec(3) label nor2 nocons stats(coef se beta) bracket(beta) paren(se) ///
									addtext(Outcome mean, "`depvarmean'", Imm. Share mean Socialist, "`sheuromean1'", ///
									Imm. Share mean Non-socialist, "`sheuromean2'", KP F-stat, "`fstat'", ///
									SW F-stat 1, "`partfstat1'", SW F-stat 2, "`partfstat2'", ///
									"${fetext}, ${controlstext`n'}") ///
									excel nonotes keep(sh_*) 
								
}

restore

foreach fmt in txt {	
cap erase "$tables/`filename'.`fmt'"		
}

}

}

*------------------------------------------------------------------------------*
* Heterogeneity by the number of other unions' branches (KoL, IWW)
* Paper: Heterogeneous Effects by the Number of Other Unions' Branches (Table A.10); outputs het_KOL, het_IWW
*------------------------------------------------------------------------------*

foreach unionhet in KOL IWW {

local n = 4

local filename = "het_`unionhet'"

foreach fmt in txt xml {	
cap erase "$tables/`filename'.`fmt'"		
}

preserve

if "`unionhet'" == "IWW" {
gen sheuro_IWW = sh_euro_wa_10yr_m * asinh(locals_IWW_0617)
gen pr1890sheuro_IWW = pr1890_sh_euro_wa_10yr_m * asinh(locals_IWW_0617)
}
if "`unionhet'" == "KOL" {
gen sheuro_KOL = sh_euro_wa_10yr_m * asinh(locals_kol_1880)
gen pr1890sheuro_KOL = pr1890_sh_euro_wa_10yr_m * asinh(locals_kol_1880)
}

foreach outcome in pres ihsloc dens avgmemb {

local union = "all"
local var = "afl_comb_`union'_`outcome'"

ivreghdfe `var'						 (sh_euro_wa_10yr_m sheuro_`unionhet' = ///
									  pr1890_sh_euro_wa_10yr_m pr1890sheuro_`unionhet') ///
									  if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
									 a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}") first

local obs = string(e(N),"%15.0f")									 
local fstat = string(`e(widstat)',"%6.2fc")
mat first = e(first)
local partfstat1 = string(first[8,1],"%6.2fc")
local partfstat2 = string(first[8,2],"%6.2fc")
qui sum `var' if e(sample) == 1
if "`outcome'" == "ihsloc" {
qui sum afl_comb_`union'_locals if e(sample) == 1
} 

local depvarmean = string(r(mean),"%6.3fc")
qui sum sh_euro_wa_10yr_m if e(sample) == 1
local sheuromean = string(r(mean),"%6.3fc")

outreg2 using "$tables/`filename'", append dec(3) label nor2 nocons stats(coef se) bracket(beta) paren(se) ///
									addtext(Outcome mean, "`depvarmean'", ///
									Share Immigrants, "`sheuromean'", ///
									KP F-stat, "`fstat'", ///
									SW F-stat 1, "`partfstat1'", SW F-stat 2, "`partfstat2'", ///
									"${fetext}, ${controlstext`n'}") ///
									excel nonotes keep(sh_* sh*) 

} 

restore

foreach fmt in txt {	
cap erase "$tables/`filename'.`fmt'"		
}

}

*------------------------------------------------------------------------------*
* Effects on local economic outcomes
* Paper: Effect on Local Economic Outcomes (Table A.11); output economic_outcomes
*------------------------------------------------------------------------------*

local n = 4	

local filename = "economic_outcomes"

foreach fmt in txt xml {	
cap erase "$tables/`filename'.`fmt'"		
}

foreach depvar in lfpartrate_m log_mfgout_pw share_mfgout sharelf_midhighsk2_m {

preserve

gen log_mfgout_pw = log(mfgout_pw_mw_ip_defl) 

bysort year (countynhg): gegen mfgout_ip_defl_US = total(mfgout_ip_defl) if inrange(year,1900,1920) == 1
gen share_mfgout = mfgout_ip_defl / mfgout_ip_defl_US 

gen sharelf_midhighsk2_m = (all_lf_midskill2_m + all_lf_highskill2_m)/all_lf_tot_m

ivreghdfe `depvar'					 (sh_euro_wa_10yr_m = pr1890_sh_euro_wa_10yr_m) ///
									 if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
									 a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}") first

local obs = string(e(N),"%15.0f")									 
local fstat = string(`e(widstat)',"%6.2fc")
qui sum `depvar' if e(sample) == 1
if "`depvar'" == "log_mfgout_pw" {
qui sum mfgout_pw_mw_ip_defl if e(sample) == 1
} 
local depvarmean = string(r(mean),"%6.3fc")
qui sum sh_euro_wa_10yr_m if e(sample) == 1
local sheuromean = string(r(mean),"%6.3fc")
local sheurostdev = string(r(sd),"%6.3fc")
outreg2 using "$tables/`filename'", append dec(3) label nor2 nocons stats(coef se beta) bracket(beta) paren(se) ///
									addtext(Outcome mean, "`depvarmean'", Imm. Share mean, "`sheuromean'", ///
									KP F-stat, "`fstat'", ///
									"${controlstext`n'}") ///
									excel nonotes keep(sh_*) 
									
restore
					 
}

foreach fmt in txt {	
cap erase "$tables/`filename'.`fmt'"		
}


* Remove outreg2 .txt/.tmp byproducts left in the tables folder.
foreach pat in "*.txt" "*.tmp" {
    local junk : dir "$tables" files "`pat'"
    foreach f of local junk {
        cap erase "$tables/`f'"
    }
}
