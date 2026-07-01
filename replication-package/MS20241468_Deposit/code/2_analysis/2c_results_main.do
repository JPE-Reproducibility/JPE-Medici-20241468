*==============================================================================*
* 2c_results_main.do
*
* Main results: the first stage; baseline OLS, reduced-form, and 2SLS estimates
* of immigration on AFL combined union presence, branches, density, and average
* membership; the share of unionization explained; by-skill estimates; the
* intensive/extensive-margin decomposition; immigrant labor-market competition;
* heterogeneity by immigrant country of origin, Know-Nothing vote share, and
* residential segregation; and the composition and evolution of convention-
* delegate origins.
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
set maxvar 32767

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
* First stage of the IV estimation
* Paper: First Stage of the Instrumental Variable Estimation (Table 2); output firststage
*------------------------------------------------------------------------------*
foreach fmt in txt xml {	
cap erase "$tables/firststage.`fmt'"		
}

foreach n in 1 2 3 4 {
	
ivreghdfe afl_comb_all_dens			 (sh_euro_wa_10yr_m = pr1890_sh_euro_wa_10yr_m) ///
									 if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
									 a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}") first  	
local fstat = string(`e(widstat)',"%6.2fc")
									 
reghdfe sh_euro_wa_10yr_m			 pr1890_sh_euro_wa_10yr_m ///
									 if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
									 a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}") 

local obs = string(e(N),"%15.0f")									 
qui sum sh_euro_wa_10yr_m if e(sample) == 1
local depvarmean = string(r(mean),"%6.3fc")
qui sum pr1890_sh_euro_wa_10yr_m if e(sample) == 1
local sheuromean = string(r(mean),"%6.3fc")
local sheurostdev = string(r(sd),"%6.3fc")
outreg2 using "$tables/firststage", noobs append dec(3) label nor2 nocons stats(coef se) paren(se) ///
									addtext("Nr. observations ", "`obs'", Outcome mean, "`depvarmean'", ///
									Imm. Share mean, "`sheuromean'", ///
									KP F-stat, "`fstat'", ///
									"${fetext}, ${controlstext`n'}") ///
									excel nonotes keep(pr*_sh_euro*) 									
									
}

foreach fmt in txt {	
cap erase "$tables/firststage.`fmt'"		
}

*------------------------------------------------------------------------------*
* Baseline regressions (OLS, reduced form, 2SLS)
* Paper: The Effect of Immigration on Organized Labor (Table 3);
*        outputs baseline_ols, baseline_redform, baseline_2sls
*------------------------------------------------------------------------------*
local filename = "baseline"

foreach fmt in txt xml {	
cap erase "$tables/`filename'_ols.`fmt'"	
cap erase "$tables/`filename'_redform.`fmt'"					
cap erase "$tables/`filename'_2sls.`fmt'"	
}

local n = 4	

foreach outcome in pres ihsloc dens avgmemb {

local union = "all"		
local var = "afl_comb_`union'_`outcome'"		
	
*OLS
reghdfe `var'						 sh_euro_wa_10yr_m ///
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
outreg2 using "$tables/`filename'_ols", noobs append dec(3) label nor2 nocons stats(coef se) paren(se) ///
									addtext("Nr. observations", "`obs'", Dep. var. mean, "`depvarmean'", ///
									Indep. var. mean, "`sheuromean'", ///
									Estimator, OLS, ///
									"${fetext}, ${controlstext`n'}") ///
									excel nonotes keep(sh_euro* pr*_sh_euro*)
							
*Reduced form
reghdfe `var'						 pr1890_sh_euro_wa_10yr_m ///
									 if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
									 a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}")  

local obs = string(e(N),"%15.0f")									 
qui sum `var' if e(sample) == 1
if "`outcome'" == "ihsloc" {
qui sum afl_comb_`union'_locals if e(sample) == 1
} 
local depvarmean = string(r(mean),"%6.3fc")
qui sum pr1890_sh_euro_wa_10yr_m if e(sample) == 1
local indepvarmean = string(r(mean),"%6.3fc")
local indepvarstdev = string(r(sd),"%6.3fc")
outreg2 using "$tables/`filename'_redform", noobs append dec(3) label nor2 nocons stats(coef se) paren(se) ///
									addtext("Nr. observations ", "`obs'", Dep. var. mean, "`depvarmean'", ///
									Indep. var. mean, "`sheuromean'", ///
									Estimator, Reduced Form, ///
									"${fetext}, ${controlstext`n'}") ///
									excel nonotes keep(sh_euro* pr*_sh_euro*) 									
							
*2SLS
ivreghdfe `var'						 (sh_euro_wa_10yr_m = pr1890_sh_euro_wa_10yr_m) ///
									 if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
									 a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}")  

local obs = string(e(N),"%15.0f")									 
local fstat = string(`e(widstat)',"%6.2fc")
qui sum `var' if e(sample) == 1
if "`outcome'" == "ihsloc" {
qui sum afl_comb_`union'_locals if e(sample) == 1
} 
local depvarmean = string(r(mean),"%6.3fc")
qui sum sh_euro_wa_10yr_m if e(sample) == 1
local sheuromean = string(r(mean),"%6.3fc")
local sheurostdev = string(r(sd),"%6.3fc")
outreg2 using "$tables/`filename'_2sls", noobs append dec(3) label nor2 nocons stats(coef se) paren(se) ///
									addtext("Nr. observations ", "`obs'", Dep. var. mean, "`depvarmean'", ///
									Indep. var. mean, "`sheuromean'", ///
									KP F-stat, "`fstat'", Estimator, 2SLS, /// 
									"${fetext}, ${controlstext`n'}") ///
									excel nonotes keep(sh_euro* pr*_sh_euro*) 
												
}
								
foreach fmt in txt {	
cap erase "$tables/`filename'_ols.`fmt'"	
cap erase "$tables/`filename'_redform.`fmt'"					
cap erase "$tables/`filename'_2sls.`fmt'"	
}									
	
*------------------------------------------------------------------------------*
* Share of unionization explained by immigration
* Paper: in-text statistic (share of unionization explained); no exported exhibit
*------------------------------------------------------------------------------*

preserve

local n = 4

use "$data/analysis_dataset_county1930.dta", clear
do "$code/2_analysis/2_sample_specifications.do"

foreach var of varlist afl_comb_all_dens afl_comb_sk_dens afl_comb_unsk_dens {
	
ivreghdfe `var'	 (sh_euro_wa_10yr_m = pr1890_sh_euro_wa_10yr_m) ///
									 if insample_balanced == 1 , ///
									 a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}")  

predict `var'_pred if e(sample) == 1
								 
}

keep if insample_balanced == 1 & inrange(year,1900,1920) == 1
collapse (mean) afl_comb_all_dens afl_comb_sk_dens afl_comb_unsk_dens afl_comb_*_dens_pred

disp afl_comb_all_dens_pred / afl_comb_all_dens
disp afl_comb_sk_dens_pred / afl_comb_sk_dens
disp afl_comb_unsk_dens_pred / afl_comb_unsk_dens

// 2SLS-predicted share explains ~22% of average union density over the period (~31% for skilled unions)

restore	

*------------------------------------------------------------------------------*
* Intensive and extensive margins
* Paper: Effects on the Intensive and Extensive Margins (Table 4); output intextmargin_all
*------------------------------------------------------------------------------*
	
foreach union in all {
	
preserve

gen sheuro_extm_`union' = sh_euro_wa_10yr_m * (locals_kol_1890 == 0) if insample_balanced == 1 & locals_kol_1890 != .
gen sheuro_intm_`union' = sh_euro_wa_10yr_m * (locals_kol_1890 > 0) if insample_balanced == 1 & locals_kol_1890 != .
gen pr1890sheuro_extm_`union' = pr1890_sh_euro_wa_10yr_m * (locals_kol_1890 == 0) if insample_balanced == 1 & locals_kol_1890 != .
gen pr1890sheuro_intm_`union' = pr1890_sh_euro_wa_10yr_m * (locals_kol_1890 > 0) if insample_balanced == 1	 & locals_kol_1890 != .
	
local filename = "intextmargin_`union'"
local n = 4	

foreach fmt in txt xml {	
cap erase "$tables/`filename'.`fmt'"		
}  

local regcount = 0

foreach outcome in ihsloc dens avgmemb {
	
local regcount = `regcount' + 1	
	
local var = "afl_comb_`union'_`outcome'"

***Regression to compute Lewis and Mertens (2022) F-stat (generalization of Montiel-Olea and Pflueger (2013) for multiple endogenous regressors)
if c(version) >= 17 & `regcount' == 1 {
qui ivreghdfe `var'					  (sheuro_intm_`union' sheuro_extm_`union' = ///
									  pr1890sheuro_intm_`union' pr1890sheuro_extm_`union') ///
									  d*_mfgctrl d*_agrctrl d*_minctrl ///
									 if inrange(year,1900,1920) == 1 & insample_balanced == 1, ///
									 a("${idfe} ${tfe}") cluster("${idfe}") first
									 
weakivtest2									 
local fstat_weakiv = string(r(stat),"%6.2fc")							 
}
if c(version) < 17 {
local fstat_weakiv = "Stata 17+ required"
}

ivreghdfe `var'						 (sheuro_intm_`union' sheuro_extm_`union' = ///
									  pr1890sheuro_intm_`union' pr1890sheuro_extm_`union') ///
									 if inrange(year,1900,1920) == 1 & insample_balanced == 1, ///
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
local sheurostdev = string(r(sd),"%6.3fc")
qui sum always_afl_comb_`union' if e(sample) == 1
local alwaysunion`union'mean = string(r(mean),"%6.3fc")
outreg2 using "$tables/`filename'", append dec(3) label nor2 nocons stats(coef se) bracket(beta) paren(se) ///
									addtext(Outcome mean, "`depvarmean'", ///
									Share Immigrants mean, "`sheuromean'", ///
									Always Unions mean, "`alwaysunion`union'mean'", ///									
									KP F-stat, "`fstat'", ///
									LM F-stat, "`fstat_weakiv'", ///
									SW F-stat 1, "`partfstat1'", SW F-stat 2, "`partfstat2'", ///
									"${fetext}, ${controlstext`n'}") ///
									excel nonotes keep(sheuro_* sh_euro* pr*_sh_euro*) 

}

foreach fmt in txt {	
cap erase "$tables/`filename'.`fmt'"		
}

restore

}

*------------------------------------------------------------------------------*
* Baseline by type of union (skill)
* Paper: Heterogeneous Effects by Workers' Skills (Table 5); outputs byskill_sk, byskill_unsk
*------------------------------------------------------------------------------*

foreach unionclass in byskill {
	
if "`unionclass'" == "byskill" {
local unions = "sk unsk"		
}
foreach union of local unions {

local filename = "`unionclass'_`union'"
local n = 4	

foreach fmt in txt xml {	
cap erase "$tables/`filename'.`fmt'"		
}

foreach outcome in pres ihsloc dens avgmemb  {
		
local var = "afl_comb_`union'_`outcome'"

ivreghdfe `var'						 (sh_euro_wa_10yr_m = pr1890_sh_euro_wa_10yr_m) ///
									 if insample_balanced == 1 & inrange(year,1900,1920) == 1 & insample_balanced == 1, ///
									 a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}")  

local obs = string(e(N),"%15.0f")									 
local fstat = string(`e(widstat)',"%6.2fc")
qui sum `var' if e(sample) == 1
if "`outcome'" == "ihsloc" {
qui sum afl_comb_`union'_locals if e(sample) == 1
} 
local depvarmean = string(r(mean),"%6.3fc")
qui sum sh_euro_wa_10yr_m if e(sample) == 1
local sheuromean = string(r(mean),"%6.3fc")
local sheurostdev = string(r(sd),"%6.3fc")
outreg2 using "$tables/`filename'", append dec(3) label nor2 nocons stats(coef se) bracket(beta) paren(se) ///
									addtext(Outcome mean, "`depvarmean'", Imm. Share mean, "`sheuromean'", ///
									KP F-stat, "`fstat'", "${fetext}, ${controlstext`n'}") ///
									excel nonotes keep(sh_euro* pr*_sh_euro*) 

}

foreach fmt in txt {	
cap erase "$tables/`filename'.`fmt'"			
}
	
}

}
	

*------------------------------------------------------------------------------*
* Immigrant labor-market competition
* Paper: Heterogeneous Effects by Immigrant Labor Competition (Table A.5, Table 6);
*        outputs het_crowdout_all, het_crowdout_sk, het_crowdout_unsk
*------------------------------------------------------------------------------*

local n = 4	

foreach crowdout in co_euall_nat {

foreach union in all sk unsk {
	
if "`union'" == "sk" {
local lfgroup = "mhsk"
}	
if "`union'" == "unsk" {
local lfgroup = "lsk"
}	
	
if "`crowdout'" == "co_euall_nat" {
local filename = "het_crowdout_`union'"
}

foreach fmt in txt xml {	
cap erase "$tables/`filename'.`fmt'"		
}

local regcount = 0

foreach outcome in pres loc dens avgmemb {

local regcount = `regcount' + 1	

local var = "afl_comb_`union'_`outcome'"

preserve

rename *_ihsloc *_loc

if "`union'" == "all" {

foreach lfgroup in mhsk lsk {
foreach j of varlist `crowdout'_`lfgroup' {	
qui sum `j' if insample_balanced == 1 & inrange(year,1900,1920) == 1
gen `j'_sd = (`j'- r(mean))/r(sd) if insample_balanced == 1 & inrange(year,1900,1920) == 1	
gen sheu_`crowdout'_`lfgroup'_s = sh_euro_wa_10yr_m * `crowdout'_`lfgroup'_sd
gen pr_sheu_`crowdout'_`lfgroup'_s = pr1890_sh_euro_wa_10yr_m * `crowdout'_`lfgroup'_sd
}
}

ivreghdfe `var'						 (sh_euro_wa_10yr_m sheu_`crowdout'_mhsk_s sheu_`crowdout'_lsk_s = ///
									  pr1890_sh_euro_wa_10yr_m pr_sheu_`crowdout'_mhsk_s pr_sheu_`crowdout'_lsk_s) `crowdout'_mhsk_sd `crowdout'_lsk_sd ///
									 if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
									 a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}") first
									 
local obs = string(e(N),"%15.0f")									 
local fstat = string(`e(widstat)',"%6.2fc")
mat first = e(first)
local partfstat1 = string(first[8,1],"%6.2fc")
local partfstat2 = string(first[8,2],"%6.2fc")
local partfstat3 = string(first[8,3],"%6.2fc")
qui sum `var' if e(sample) == 1
if "`outcome'" == "loc" {
qui sum afl_comb_`union'_locals if e(sample) == 1
} 
local depvarmean = string(r(mean),"%6.3fc")
qui sum sh_euro_wa_10yr_m if e(sample) == 1
local sheuromean = string(r(mean),"%6.3fc")
local sheurostdev = string(r(sd),"%6.3fc")
outreg2 using "$tables/`filename'", append dec(3) label nor2 nocons stats(coef se) bracket(beta) paren(se) ///
									addtext(Outcome mean, "`depvarmean'", Imm. Share mean, "`sheuromean'", ///
									KP F-stat, "`fstat'", ///
									SW F-stat 1, "`partfstat1'", SW F-stat 2, "`partfstat2'", SW F-stat 3, "`partfstat3'", ///
									"${fetext}, ${controlstext`n'}") ///
									excel nonotes keep(sh*) 
									
}

if "`union'" != "all" {

foreach j of varlist `crowdout'_`lfgroup' {	
qui sum `j' if insample_balanced == 1 & inrange(year,1900,1920) == 1
gen `j'_sd = (`j'- r(mean))/r(sd) if insample_balanced == 1 & inrange(year,1900,1920) == 1	
gen sheu_`crowdout'_`lfgroup'_s = sh_euro_wa_10yr_m * `crowdout'_`lfgroup'_sd
gen pr_sheu_`crowdout'_`lfgroup'_s = pr1890_sh_euro_wa_10yr_m * `crowdout'_`lfgroup'_sd
}

***Regression to compute Lewis and Mertens (2022) F-stat (generalization of Montiel-Olea and Pflueger (2013) for multiple endogenous regressors)
if c(version) >= 17 & `regcount' == 1 {
qui ivreghdfe `var'						 (sh_euro_wa_10yr_m sheu_`crowdout'_`lfgroup'_s = ///
									  pr1890_sh_euro_wa_10yr_m pr_sheu_`crowdout'_`lfgroup'_s) `crowdout'_`lfgroup'_sd ///
									  d*_mfgctrl d*_agrctrl d*_minctrl ///
									 if inrange(year,1900,1920) == 1 & insample_balanced == 1, ///
									 a("${idfe} ${tfe}") cluster("${idfe}") first
									 
weakivtest2									 
local fstat_weakiv = string(r(stat),"%6.2fc")							 
}
if c(version) < 17 {
local fstat_weakiv = "Stata 17+ required"
}

ivreghdfe `var'						 (sh_euro_wa_10yr_m sheu_`crowdout'_`lfgroup'_s = ///
									  pr1890_sh_euro_wa_10yr_m pr_sheu_`crowdout'_`lfgroup'_s) `crowdout'_`lfgroup'_sd ///
									 if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
									 a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}") first

local obs = string(e(N),"%15.0f")									 
local fstat = string(`e(widstat)',"%6.2fc")
mat first = e(first)
local partfstat1 = string(first[8,1],"%6.2fc")
local partfstat2 = string(first[8,2],"%6.2fc")
qui sum `var' if e(sample) == 1
if "`outcome'" == "loc" {
qui sum afl_comb_`union'_locals if e(sample) == 1
} 
local depvarmean = string(r(mean),"%6.3fc")
qui sum sh_euro_wa_10yr_m if e(sample) == 1
local sheuromean = string(r(mean),"%6.3fc")
local sheurostdev = string(r(sd),"%6.3fc")
outreg2 using "$tables/`filename'", append dec(3) label nor2 nocons stats(coef se) bracket(beta) paren(se) ///
									addtext(Outcome mean, "`depvarmean'", Imm. Share mean, "`sheuromean'", ///
									KP F-stat, "`fstat'", ///
									LM F-stat, "`fstat_weakiv'", ///
									SW F-stat 1, "`partfstat1'", SW F-stat 2, "`partfstat2'", ///
									"${fetext}, ${controlstext`n'}") ///
									excel nonotes keep(sh*) 
									
}
									 
restore
								
}

foreach fmt in txt {	
cap erase "$tables/`filename'.`fmt'"		
}

}

}		

*------------------------------------------------------------------------------*
* Heterogeneity by immigrant country of origin
* Paper: Heterogeneous Effects by Origin of Immigrants (Table 7); output byorigin_all
*------------------------------------------------------------------------------*

foreach union in all {

local n = 4	
local filename = "byorigin_`union'"

foreach fmt in txt xml {	
cap erase "$tables/`filename'.`fmt'"		
}

local regcount = 0

foreach outcome in pres ihsloc dens avgmemb {

local regcount = `regcount' + 1

preserve	

local var = "afl_comb_`union'_`outcome'"

***Regression to compute Lewis and Mertens (2022) F-stat (generalization of Montiel-Olea and Pflueger (2013) for multiple endogenous regressors)
if c(version) >= 17 & `regcount' == 1 {
qui ivreghdfe `var'						 (sh_newsend_wa_10yr_m sh_oldsend_wa_10yr_m = pr1890_sh_newsend_wa_10yr_m pr1890_sh_oldsend_wa_10yr_m) ///
									  d*_mfgctrl d*_agrctrl d*_minctrl ///
									 if inrange(year,1900,1920) == 1 & insample_balanced == 1, ///
									 a("${idfe} ${tfe}") cluster("${idfe}") first
									 
weakivtest2									 
local fstat_weakiv = string(r(stat),"%6.2fc")							 
}
if c(version) < 17 {
local fstat_weakiv = "Stata 17+ required"
}

ivreghdfe `var'					 (sh_newsend_wa_10yr_m sh_oldsend_wa_10yr_m = pr1890_sh_newsend_wa_10yr_m pr1890_sh_oldsend_wa_10yr_m) ///
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
qui sum sh_newsend_wa_10yr_m if e(sample) == 1
local shseeuromean = string(r(mean),"%6.3fc")
qui sum sh_oldsend_wa_10yr_m if e(sample) == 1
local shnweuromean = string(r(mean),"%6.3fc")
outreg2 using "$tables/`filename'", append dec(3) label nor2 nocons stats(coef se beta) bracket(beta) paren(se) ///
									addtext(Outcome mean, "`depvarmean'", ///
									Imm. Share S/E Europe mean, "`shseeuromean'", ///
									Imm. Share N/W Europe mean, "`shnweuromean'", ///									
									KP F-stat, "`fstat'", ///
									LM F-stat, "`fstat_weakiv'", ///
									SW F-stat 1, "`partfstat1'", SW F-stat 2, "`partfstat2'", ///
									"${fetext}, ${controlstext`n'}") ///
									excel nonotes keep(sh_*) 
restore
									
}

foreach fmt in txt {	
cap erase "$tables/`filename'.`fmt'"		
}

}	

*------------------------------------------------------------------------------*
* Heterogeneity by Know-Nothing vote share
* Paper: Heterogeneous Effects by Attitudes Towards Immigration, Panel A
*        (Table 8; terciles in Table A.6);
*        outputs het_knownotshare_all, het_knownotshare_all_alt
*------------------------------------------------------------------------------*

foreach union in all {
	
local n = 4	

local filename = "het_knownotshare_`union'"
foreach fmt in txt xml {	
cap erase "$tables/`filename'.`fmt'"		
cap erase "$tables/`filename'_alt.`fmt'"			
}
	
preserve
	
foreach i in knownotshare_1856 {
xtile `i'_t = `i' if insample_balanced == 1 & inrange(year,1900,1920) == 1, n(3)
tab `i'_t if insample_balanced == 1 & inrange(year,1900,1920) == 1, gen(`i'_t)
gen `i'_t23 = (`i'_t2 == 1 | `i'_t3 == 1) if insample_balanced == 1 & inrange(year,1900,1920) == 1 & `i'_t1 != .
}	

foreach q in 1 2 3 23 {
gen sh_euro_knownot_t`q' = sh_euro_wa_10yr_m * knownotshare_1856_t`q'
gen pr1890_sh_euro_knownot_t`q' = pr1890_sh_euro_wa_10yr_m * knownotshare_1856_t`q'
}

local regcount = 0

foreach outcome in pres ihsloc dens avgmemb {
	
local regcount = `regcount' + 1

local var = "afl_comb_`union'_`outcome'"						

***Regression to compute Lewis and Mertens (2022) F-stat (generalization of Montiel-Olea and Pflueger (2013) for multiple endogenous regressors)
if c(version) >= 17 & `regcount' == 1 {
qui ivreghdfe `var'						 (sh_euro_wa_10yr_m sh_euro_knownot_t23 = ///
								     pr1890_sh_euro_wa_10yr_m pr1890_sh_euro_knownot_t23) ///
									  d*_mfgctrl d*_agrctrl d*_minctrl ///
									 if inrange(year,1900,1920) == 1 & insample_balanced == 1, ///
									 a("${idfe} ${tfe}") cluster("${idfe}") first
									 
weakivtest2									 
local fstat_weakiv = string(r(stat),"%6.2fc")							 
}
if c(version) < 17 {
local fstat_weakiv = "Stata 17+ required"
}

***Regressions t2+t3 vs. t1
ivreghdfe `var'						 (sh_euro_wa_10yr_m sh_euro_knownot_t23 = ///
								     pr1890_sh_euro_wa_10yr_m pr1890_sh_euro_knownot_t23) ///
									 if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
									 a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}") first  
est store knownot_`union'_`outcome'

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
local sheurostdev = string(r(sd),"%6.3fc")
nlcom lc: _b[sh_euro_wa_10yr_m] + _b[sh_euro_knownot_t23], post
local coef_lc = string(_b[lc],"%6.3fc")
local se_lc = string(_se[lc],"%6.3fc")
est restore knownot_`union'_`outcome'									 

outreg2 using "$tables/`filename'", append dec(3) label nor2 nocons stats(coef se) bracket(beta) paren(se) ///
									addtext(Outcome mean, "`depvarmean'", Imm. Share mean, "`sheuromean'", ///
									KP F-stat, "`fstat'", ///
									LM F-stat, "`fstat_weakiv'", ///
									SW F-stat 1, "`partfstat1'", SW F-stat 2, "`partfstat2'", ///
									"${fetext}, ${controlstext`n'}", ///
									[1] + [2], "`coef_lc'", s.e., "`se_lc'") ///
									excel nonotes keep(sh_euro* pr*_sh_euro*) 
																	
***Regressions t1, t2, t3
ivreghdfe `var'						 (sh_euro_knownot_t1 sh_euro_knownot_t2 sh_euro_knownot_t3 = ///
								     pr1890_sh_euro_knownot_t1 pr1890_sh_euro_knownot_t2 pr1890_sh_euro_knownot_t3) ///
									 if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
									 a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}") first

local obs = string(e(N),"%15.0f")									 
local fstat = string(`e(widstat)',"%6.2fc")
mat first = e(first)
local partfstat1 = string(first[8,1],"%6.2fc")
local partfstat2 = string(first[8,2],"%6.2fc")
local partfstat3 = string(first[8,3],"%6.2fc")
qui sum `var' if e(sample) == 1
if "`outcome'" == "ihsloc" {
qui sum afl_comb_`union'_locals if e(sample) == 1
} 
local depvarmean = string(r(mean),"%6.3fc")
qui sum sh_euro_wa_10yr_m if e(sample) == 1
local sheuromean = string(r(mean),"%6.3fc")
local sheurostdev = string(r(sd),"%6.3fc")
outreg2 using "$tables/`filename'_alt", append dec(3) label nor2 nocons stats(coef se) bracket(beta) paren(se) ///
									addtext(Outcome mean, "`depvarmean'", Imm. Share mean, "`sheuromean'", ///
									KP F-stat, "`fstat'", ///
									SW F-stat 1, "`partfstat1'", SW F-stat 2, "`partfstat2'", SW F-stat 3, "`partfstat3'", ///
									"${fetext}, ${controlstext`n'}") ///
									excel nonotes keep(sh_euro* pr*_sh_euro*) 
																		
}

restore

foreach fmt in txt {	
cap erase "$tables/`filename'.`fmt'"		
cap erase "$tables/`filename'_alt.`fmt'"		
}

}	

*------------------------------------------------------------------------------*
* Heterogeneity by residential segregation
* Paper: Heterogeneous Effects by Attitudes Towards Immigration, Panel B
*        (Table 8; terciles in Table A.6);
*        outputs het_residsegr_all, het_residsegr_all_alt
*------------------------------------------------------------------------------*
foreach union in all {

local n = 4	

local filename = "het_residsegr_`union'"
foreach fmt in txt xml {	
cap erase "$tables/`filename'.`fmt'"		
cap erase "$tables/`filename'_alt.`fmt'"			
}

preserve

foreach i in resid_segr_euro_enum_1880 {
xtile `i'_t = `i' if insample_balanced == 1 & inrange(year,1900,1920) == 1, n(3)
tab `i'_t if insample_balanced == 1 & inrange(year,1900,1920) == 1, gen(`i'_t)
gen `i'_t23 = (`i'_t2 == 1 | `i'_t3 == 1) if insample_balanced == 1 & inrange(year,1900,1920) == 1 & `i'_t1 != .
}

foreach q in 1 2 3 23 {
gen sh_euro_segr_en_t`q' = sh_euro_wa_10yr_m * resid_segr_euro_enum_1880_t`q'
gen pr1890_sh_euro_segr_en_t`q' = pr1890_sh_euro_wa_10yr_m * resid_segr_euro_enum_1880_t`q'
}

local regcount = 0

foreach outcome in pres ihsloc dens avgmemb {

local regcount =`regcount' + 1

local var = "afl_comb_`union'_`outcome'"
	
***Regression to compute Lewis and Mertens (2022) F-stat (generalization of Montiel-Olea and Pflueger (2013) for multiple endogenous regressors)
if c(version) >= 17 & `regcount' == 1 {
qui ivreghdfe `var'						 (sh_euro_wa_10yr_m sh_euro_segr_en_t23 = ///
								     pr1890_sh_euro_wa_10yr_m pr1890_sh_euro_segr_en_t23) ///
									  d*_mfgctrl d*_agrctrl d*_minctrl ///
									 if inrange(year,1900,1920) == 1 & insample_balanced == 1, ///
									 a("${idfe} ${tfe}") cluster("${idfe}") first
									 
weakivtest2									 
local fstat_weakiv = string(r(stat),"%6.2fc")							 
}
if c(version) < 17 {
local fstat_weakiv = "Stata 17+ required"
}
	
***Regressions t2+t3 vs. t1
ivreghdfe `var'						 (sh_euro_wa_10yr_m sh_euro_segr_en_t23 = ///
								     pr1890_sh_euro_wa_10yr_m pr1890_sh_euro_segr_en_t23) ///
									 if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
									 a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}") first 
est store segr_`union'_`outcome'

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
local sheurostdev = string(r(sd),"%6.3fc")
nlcom lc: _b[sh_euro_wa_10yr_m] + _b[sh_euro_segr_en_t23], post
local coef_lc = string(_b[lc],"%6.3fc")
local se_lc = string(_se[lc],"%6.3fc")
est restore segr_`union'_`outcome'									 

outreg2 using "$tables/`filename'", append dec(3) label nor2 nocons stats(coef se) bracket(beta) paren(se) ///
									addtext(Outcome mean, "`depvarmean'", Imm. Share mean, "`sheuromean'", ///
									KP F-stat, "`fstat'", ///
									LM F-stat, "`fstat_weakiv'", ///
									SW F-stat 1, "`partfstat1'", SW F-stat 2, "`partfstat2'", ///
									"${fetext}, ${controlstext`n'}", ///
									[1] + [2], "`coef_lc'", s.e., "`se_lc'") ///
									excel nonotes keep(sh_euro* pr*_sh_euro*) 

***Regressions t1, t2, t3
ivreghdfe `var'						 (sh_euro_segr_en_t1 sh_euro_segr_en_t2 sh_euro_segr_en_t3 = ///
								     pr1890_sh_euro_segr_en_t1 pr1890_sh_euro_segr_en_t2 pr1890_sh_euro_segr_en_t3) ///
									 if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
									 a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}") first 

local obs = string(e(N),"%15.0f")									 
local fstat = string(`e(widstat)',"%6.2fc")
mat first = e(first)
local partfstat1 = string(first[8,1],"%6.2fc")
local partfstat2 = string(first[8,2],"%6.2fc")
local partfstat3 = string(first[8,3],"%6.2fc")
qui sum `var' if e(sample) == 1
if "`outcome'" == "ihsloc" {
qui sum afl_comb_`union'_locals if e(sample) == 1
} 
local depvarmean = string(r(mean),"%6.3fc")
qui sum sh_euro_wa_10yr_m if e(sample) == 1
local sheuromean = string(r(mean),"%6.3fc")
local sheurostdev = string(r(sd),"%6.3fc")
outreg2 using "$tables/`filename'_alt", append dec(3) label nor2 nocons stats(coef se) bracket(beta) paren(se) ///
									addtext(Outcome mean, "`depvarmean'", Imm. Share mean, "`sheuromean'", ///
									KP F-stat, "`fstat'", ///
									SW F-stat 1, "`partfstat1'", SW F-stat 2, "`partfstat2'", SW F-stat 3, "`partfstat3'", ///
									"${fetext}, ${controlstext`n'}") ///
									excel nonotes keep(sh_euro* pr*_sh_euro*) 
									
}

restore

foreach fmt in txt {	
cap erase "$tables/`filename'.`fmt'"		
cap erase "$tables/`filename'_alt.`fmt'"		
}

}	

*------------------------------------------------------------------------------*
* Shares of delegates by origin
* Paper: Shares of Union Leaders by Origin and Ancestry (Figure A.5); output share_deleg.pdf
*------------------------------------------------------------------------------*
foreach union in afl_comb {
	
preserve

keep if inrange(year,1900,1920) == 1 & insample_balanced == 1 & inrange(year,1900,1920) == 1

collapse (sum) `union'_del_bpl_nat `union'_del_bpl_oth `union'_del_bpl_eu `union'_del_bpl_eunw `union'_del_bpl_euse `union'_del_bpl_denom `union'_del_anc_oth `union'_del_anc_eu `union'_del_anc_eunw `union'_del_anc_euse `union'_del_anc_denom, by(year)
foreach group in nat oth eu eunw euse {
gen `union'_del_sh_bpl_`group' = `union'_del_bpl_`group' / `union'_del_bpl_denom
}
foreach group in oth eu eunw euse {
gen `union'_del_sh_anc_`group' = `union'_del_anc_`group' / `union'_del_anc_denom
}

sum *sh_bpl_* if year == 1900
sum *sh_bpl_* if year == 1910
sum *sh_bpl_* if year == 1920

sum *sh_anc_* if year == 1900
sum *sh_anc_* if year == 1910
sum *sh_anc_* if year == 1920

graph bar `union'_del_sh_bpl_nat `union'_del_sh_bpl_eunw `union'_del_sh_bpl_euse, ///
		  over(year, gap(250) label(labsize(medsmall))) ///
		  legend(order(1 "U.S.-Born" 2 "N/W Europe" 3 "S/E Europe") size(medsmall) rows(1) holes(2) region(lstyle(none))) ///
		  bar(1, lcolor(navy*1.4) fcolor(navy*0.9)) bar(2, lcolor(navy*1.4) fcolor(navy*0.4)) bar(3, lcolor(navy*1.4) fcolor(navy*0.05)) ///
		  bargap(5) ylabel(, labsize(medsmall) nogrid) ytitle("Share of Union Leaders", size(medsmall)) ///
		  graphregion(color(white)) plotregion(color(white)) title("Panel A: Country of origin inferred from last names", size(medsmall))  ///
		  name(share_deleg_bpl_eurodet, replace)
		  
graph bar `union'_del_sh_anc_eunw `union'_del_sh_anc_euse, ///
		  over(year, gap(250) label(labsize(medsmall))) ///
		  legend(order(1 "N/W Europe" 2 "S/E Europe") size(medsmall) rows(1) region(lstyle(none))) ///
		  bar(1, lcolor(navy*1.4) fcolor(navy*0.9)) bar(2, lcolor(navy*1.4) fcolor(navy*0.2)) ///
		  bargap(5) ylabel(, labsize(medsmall) nogrid) ytitle("Share of Union Leaders", size(medsmall)) ///
		  graphregion(color(white)) plotregion(color(white)) title("Panel B: Ancestry inferred from last names", size(medsmall)) ///
		  name(share_deleg_anc, replace)

graph combine share_deleg_bpl_eurodet share_deleg_anc, ///
					graphregion(color(white)) plotregion(color(white) margin(zero)) xsize(12) ysize(6)
graph export "$figures/share_deleg.pdf", replace
			
restore

}

*------------------------------------------------------------------------------*
* Effect on share of delegates by origin
* Paper: Effect on the Composition of Union Leaders (Table A.7);
*        outputs share_deleg_{anc,bpl}_{full,restr}sample
*------------------------------------------------------------------------------*

foreach type in anc bpl {
	
if "`type'" == "anc" {
local groups eunw euse
}
if "`type'" == "bpl" {
local groups nat eunw euse
}

foreach union in all {

preserve

rename *afl_del* *afl_all_del*
rename *afl_comb_del* *afl_comb_all_del*

bysort countynhg (year): gegen afl_comb_`union'_del_`type'_min = min(afl_comb_`union'_del_`type'_denom) if insample_balanced == 1 & inrange(year,1900,1920) == 1	

* All observations, including county-years with no delegates
local n = 4

local filename = "share_deleg_`type'_fullsample"

foreach fmt in txt xml {	
cap erase "$tables/`filename'.`fmt'"		
}	
	
foreach group of local groups {

local var = "afl_comb_`union'_del_sh_`type'_`group'"

ivreghdfe `var'						 (sh_euro_wa_10yr_m = pr1890_sh_euro_wa_10yr_m) ///
									 if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
									 a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}")    

local fstat = string(`e(widstat)',"%6.2fc")
local obs = string(e(N),"%15.0f")									 
qui sum `var' if e(sample) == 1
local depvarmean = string(r(mean),"%6.3fc")
qui sum sh_euro_wa_10yr_m if e(sample) == 1
local sheuromean = string(r(mean),"%6.3fc")
local sheurostdev = string(r(sd),"%6.3fc")
outreg2 using "$tables/`filename'", append dec(3) label nor2 nocons stats(coef se) paren(se) bracket(beta) ///
									addtext(Outcome mean, "`depvarmean'", Imm. Share mean, "`sheuromean'", ///
									KP F-stat, "`fstat'", ///
									"${fetext}, ${controlstext`n'}") ///
									excel nonotes keep(sh_euro* pr*_sh_euro*) 
		
}
		
* Only county-years with delegates in all three years
local n = 4

local filename = "share_deleg_`type'_restrsample"

foreach fmt in txt xml {	
cap erase "$tables/`filename'.`fmt'"		
}	
		
foreach group of local groups {

local var = "afl_comb_`union'_del_sh_`type'_`group'"

ivreghdfe `var'						 (sh_euro_wa_10yr_m = pr1890_sh_euro_wa_10yr_m) ///
									 if insample_balanced == 1 & inrange(year,1900,1920) == 1 & afl_comb_`union'_del_`type'_min > 0, ///
									 a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}")    

local fstat = string(`e(widstat)',"%6.2fc")
local obs = string(e(N),"%15.0f")									 
qui sum `var' if e(sample) == 1
local depvarmean = string(r(mean),"%6.3fc")
qui sum sh_euro_wa_10yr_m if e(sample) == 1
local sheuromean = string(r(mean),"%6.3fc")
local sheurostdev = string(r(sd),"%6.3fc")
outreg2 using "$tables/`filename'", append dec(3) label nor2 nocons stats(coef se) paren(se) bracket(beta) ///
									addtext(Outcome mean, "`depvarmean'", Imm. Share mean, "`sheuromean'", ///
									KP F-stat, "`fstat'", ///
									"${fetext}, ${controlstext`n'}") ///
									excel nonotes keep(sh_euro* pr*_sh_euro*) 
									
}
									
foreach fmt in txt {	
cap erase "$tables/`filename'.`fmt'"		
}	

restore

}

}

foreach fmt in txt {	
cap erase "$tables/share_deleg_bpl_fullsample.`fmt'"		
cap erase "$tables/share_deleg_anc_fullsample.`fmt'"		
}


* Remove outreg2 .txt/.tmp byproducts left in the tables folder.
foreach pat in "*.txt" "*.tmp" {
    local junk : dir "$tables" files "`pat'"
    foreach f of local junk {
        cap erase "$tables/`f'"
    }
}
