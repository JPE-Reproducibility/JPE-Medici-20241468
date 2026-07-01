*==============================================================================*
* 2e_results_robustness.do
*
* Robustness of the main 2SLS estimates: a battery of alternative
* specifications, samples, standard-error corrections, and instrument
* definitions summarized in the robustness figures; the initial-stock
* interaction check; controlling for additional baseline characteristics; and
* the pre-trends tests.
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


preserve 

*------------------------------------------------------------------------------*
* Test of pre-trends
* Paper: Test of Pre-Trends (Table B.2; top-Rotemberg origins in Table G.2);
*        outputs rob_pretrends_euro and rob_pretrends_<country>
*------------------------------------------------------------------------------*

* Average and change predicted immigration 1900-1920
foreach c in euro aus_hung italy russia gr_pt_es sweden {
bysort countynhg_1930 (year): egen avg0020_sh_`c' = mean(sh_`c'_wa_10yr_m) if insample_balanced == 1 & inrange(year,1900,1920) == 1
bysort countynhg_1930 (year): egen avg0020_pr1890_sh_`c' = mean(pr1890_sh_`c'_wa_10yr_m) if insample_balanced == 1 & inrange(year,1900,1920) == 1
}

* Change Knights of Labor 1880-1890
gen kol_d_1880 = (locals_kol_1880 > 0) if locals_kol_1880 != .
gen kol_d_1890 = (locals_kol_1890 > 0) if locals_kol_1890 != .
gen kol_d = (locals_kol > 0) if locals_kol != .
foreach var in kol_d locals_kol ihs_locals_kol ihs_locals_kol_perpop locals_kol_perpop locals_kol_perurbpop {
	gen d8090_`var' = `var'_1890 - `var'_1880 if year == 1900
}

* Change pop. and mfg. variables 1880-1890
gen rail_conn_1880 = (year_conn_rr < 1880)	
foreach var in log_popdens_mw ihs_all_totpop_mw urban_share_mw euro_imm_share_mw mfglabor_share_mw ihs_mfgestab_pw_ip_mw ihs_mfgestab_ip ihs_mfgwages_pw_mw_ip_defl ihs_mfgout_ip_defl ihs_mfgout_pw_mw_ip_defl rail_conn {
gen d8090_`var' = `var'_1890 - `var'_1880 if year == 1900
}

* 1880 controls
gen farm_share_mw_1880_temp = (all_lf_farmer_m + all_lf_farmlab_m + all_lf_farmer_w + all_lf_farmlab_w) / (all_lf_tot_m + all_lf_tot_w) if year == 1880
bysort countynhg_1930 (year): egen farm_share_mw_1880 = max(farm_share_mw_1880_temp)
gen all_lf_mining_mw = all_lf_mining_m + all_lf_mining_w 
gen mining_1880_temp = (all_lf_mining_mw > 0) if all_lf_mining_mw != . & year == 1880
bysort countynhg_1930 (year): egen mining_1880 = max(mining_1880_temp)
gen mining_share_mw_1880_temp = (all_lf_mining_mw / (all_lf_tot_m + all_lf_tot_w)) if year == 1880
bysort countynhg_1930 (year): egen mining_share_mw_1880 = max(mining_share_mw_1880_temp)


foreach c in euro aus_hung italy russia gr_pt_es sweden {
	
local filename = "rob_pretrends_`c'"
foreach fmt in txt xml {	
cap erase "$tables/`filename'`fmt'"	
cap erase "$tables/`filename'_1880imm.`fmt'"			
}

keep if d8090_kol_d != . & d8090_urban_share_mw != . & d8090_ihs_mfgout_pw_mw_ip_defl != .

foreach var in d8090_kol_d d8090_ihs_locals_kol ///
			   d8090_urban_share_mw ///
			   d8090_ihs_mfgout_pw_mw_ip_defl d8090_ihs_mfgestab_pw_ip_mw {	
		
ivreghdfe `var' (avg0020_sh_`c' = avg0020_pr1890_sh_`c') ///
					  farmfams_share_1890 mfglabor_share_mw_1890 mining_1890 ///
					  euro_imm_share_mw_1880 ///
					  if year == 1900 & insample_balanced == 1, cluster(countynhg_1930) first
					  
local fstat = string(`e(widstat)',"%6.2fc")								   								
outreg2 using "$tables/`filename'", append dec(3) label nor2 nocons stats(coef se) paren(se) ///
									   addtext(KP F-stat, "`fstat'") excel nonotes keep(avg0020_* sh_*) 	

}

foreach fmt in txt {	
cap erase "$tables/`filename'.`fmt'"		
cap erase "$tables/`filename'_1880imm.`fmt'"		
}

}
									   
restore											   
									   



* Control for initial 1890 shares from each country

foreach outcome in pres ihsloc dens avgmemb {
	
local n = 4
	
local var = "afl_comb_all_`outcome'"

ivreghdfe `var'						 (sh_euro_wa_10yr_m = pr1890_sh_euro_wa_10yr_m) ///
									 if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
									 a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}")  
									 
est store baseline_`outcome'
	
preserve
	
foreach country in aus_hung belgium czech denmark ///
				   france germany gr_pt_es ///
				   ireland italy luxemb nether norway ///
				   poland russia sweden switz uk {
				   	 				   
ivreghdfe `var' 	 		(sh_euro_wa_10yr_m = pr1890_sh_euro_wa_10yr_m)  ///
							if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
							a("${idfe} ${tfe} ${controls`n'}" year#c.sh_`country'_mw_1890) cluster("${idfe}")  

est store sh_`country'_`outcome'	

}


restore

}


foreach outcome in pres ihsloc dens avgmemb {

local filename = "initstock_`outcome'"

if "`outcome'" == "pres" {
local graphtitle = "Any Union Present"
local gap = 1
local resc = ""
local resclab = ""
local extraoptions = ""
}
if "`outcome'" == "ihsloc" {
local graphtitle = "Number of Union Branches"
local gap = 1
local resc = ""
local resclab = ""
local extraoptions = ""
}
if "`outcome'" == "dens" {
local graphtitle = "Union Density (Members / Labor Force)"
local gap = 1
local resc = ""
local resclab = ""
local extraoptions = ""
}
if "`outcome'" == "avgmemb" {
local graphtitle = "Union Members per Branch"
local gap = 1
local resc = ""
local resclab = ""
local extraoptions = "xlabel(0(200)1200) xscale(range(-50 1200))"
}	

coefplot 	(baseline_`outcome', msymbol(O) lcolor("178 65 0") mcolor("178 65 0") ///
			msize(medsmall) ciopt(recast(rcap) msymbol(none) lpattern(solid) lwidth(medthin) lcolor("178 65 0"))) ///
			(sh_*_`outcome', msymbol(O) lcolor("navy*0.9") mcolor("navy*0.9") ///
			msize(medsmall) ciopt(recast(rcap) msymbol(none) lpattern(solid) lwidth(medthin) lcolor("navy*0.9"))), ///
			xline(0, lwidth(vthin) lcolor("178 65 0")) ///
			aseq swapnames ///
			xtitle("2SLS Coeff. {it:Share of Immigrants}", size(vsmall)) ///
			ytitle("", size(small)) ///
			ylabel(, labsize(vsmall) angle(0) glcolor(gs16)) yscale(titlegap(*-1.5)) ///
			xlabel(, labsize(vsmall)) ciopt(recast(rline) lpattern(dot) lcolor(red)) ///
			graphregion(color(white)) plotregion(color(white)) legend(off) grid(none) ///
			keep(sh_euro_wa_10yr_m) title(`graphtitle', size(small)) name(`filename', replace) ///
			ci(95) ///
			eqrename(baseline_`outcome' = "Baseline" ///
					 sh_aus_hung_`outcome' = "Austria-Hungary    –     1" ///
					 sh_belgium_`outcome' = "Belgium    –     2" ///		
					 sh_czech_`outcome' = "Czechoslovakia    –     3" ///
					 sh_denmark_`outcome' = "Denmark    –     4" ///
					 sh_france_`outcome' = "France    –     5" ///
					 sh_germany_`outcome' = "Germany    –     6" ///
					 sh_gr_pt_es_`outcome' = "Greece-Portugal-Spain    –     7" ///					 
					 sh_ireland_`outcome' = "Ireland    –     8" ///
					 sh_italy_`outcome' = "Italy    –     9" ///
					 sh_luxemb_`outcome' = "Luxembourg    – 10" ///
					 sh_nether_`outcome' = "Netherlands    – 11" ///
				 	 sh_norway_`outcome' = "Norway    – 12" ///
					 sh_poland_`outcome' = "Poland    – 13" ///
					 sh_russia_`outcome' = "Russia    – 14" ///
					 sh_sweden_`outcome' = "Sweden    – 15" ///
					 sh_switz_`outcome' = "Switzerland    – 16" ///
					 sh_uk_`outcome' = "United Kingdom    – 17" ///
					  ) ///
					 `extraoptions'

}	

graph combine initstock_pres initstock_ihsloc initstock_dens initstock_avgmemb, graphregion(color(white) margin(zero)) ///
																					plotregion(color(white) margin(zero)) 
graph export "$figures/rob_initstock.pdf", replace





*------------------------------------------------------------------------------*
* Controlling for additional baseline characteristics
* Paper: Robustness Check -- Controlling for Additional Baseline Characteristics (Figure 4); output rob_controls.pdf
*------------------------------------------------------------------------------*

foreach outcome in pres ihsloc dens avgmemb  {

local filename = "rob_controls_`outcome'"
local n = 4	

foreach fmt in txt xml {	
cap erase "$tables/`filename'.`fmt'"		
}

preserve

egen demshare_1890_avg = rowmean(demshare_1888 demshare_1892)
gen afloccs_share_m_1880 = all_lf_afloccs_m_1880 / all_lf_tot_m_1880
gen mfgout_growth_1890 = (mfgout_ip_defl_1890 - mfgout_ip_defl_1880) / mfgout_ip_defl_1880

local robcontrols " "year#c.urban_share_mw_1890" "year#c.log_popdens_mw_1890" "year#c.imm_share_mw_1890" "year#c.imm_share_mw_1880" "year#c.black_share_mw_1890" "year#c.agric_share_m_1880 year#c.mining_share_m_1880 year#c.constr_share_m_1880 year#c.mfg_share_m_1880 year#c.transp_share_m_1880 year#c.trade_share_m_1880 year#c.fin_share_m_1880 year#c.biz_share_m_1880 year#c.persserv_share_m_1880 year#c.ent_share_m_1880 year#c.profserv_share_m_1880 year#c.pubadm_share_m_1880" "year#c.highskill2_share_m_1880 year#c.midskill2_share_m_1880 year#c.lowskill_share_m_1880" "year#c.log_all_occsc_m_1880" "year#c.mfgout_growth_1890" "year#c.rail_conn_1890" "year#c.demshare_1890_avg" "

local var = "afl_comb_all_`outcome'"

ivreghdfe "`var'"					 (sh_euro_wa_10yr_m = pr1890_sh_euro_wa_10yr_m) ///
									 if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
									 a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}")  
									 
est store baseline_`outcome'
local fstat = string(`e(widstat)',"%6.2fc")
local obs = string(e(N),"%15.0f")									 
qui sum `var' if e(sample) == 1
if "`var'" == "afl_comb_all_ihsloc" {
qui sum afl_comb_all_locals if e(sample) == 1
}
local depvarmean = string(r(mean),"%6.3fc")
qui sum sh_euro_wa_10yr_m if e(sample) == 1
local sheuromean = string(r(mean),"%6.3fc")
local sheurostdev = string(r(sd),"%6.3fc")

local i = 0
foreach robcontrol of local robcontrols {    

local i = `i' + 1
local n = 4

ivreghdfe "`var'"				   (sh_euro_wa_10yr_m  = pr1890_sh_euro_wa_10yr_m) ///
								   if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
								   a("${idfe} ${tfe} ${controls`n'}" `robcontrol') cluster("${idfe}") 	

est store robctrl_`outcome'_`i'								   
local fstat = string(`e(widstat)',"%6.2fc")
local obs = string(e(N),"%15.0f")									 
qui sum `var' if e(sample) == 1
if "`var'" == "afl_comb_all_ihsloc" {
qui sum afl_comb_all_locals if e(sample) == 1
}
local depvarmean = string(r(mean),"%6.3fc")
qui sum sh_euro_wa_10yr_m if e(sample) == 1
local sheuromean = string(r(mean),"%6.3fc")
local sheurostdev = string(r(sd),"%6.3fc")
								
}
restore

}

foreach fmt in txt {	
cap erase "$tables/`filename'.`fmt'"		
}


foreach outcome in pres ihsloc dens avgmemb {

if "`outcome'" == "pres" {
local graphtitle = "Any Union Present"
local gap = 1
local resc = ""
local resclab = ""
local extraoptions = ""
}
if "`outcome'" == "ihsloc" {
local graphtitle = "Number of Union Branches"
local gap = 1
local resc = ""
local resclab = ""
local extraoptions = ""
}
if "`outcome'" == "dens" {
local graphtitle = "Union Density (Members / Labor Force)"
local gap = 1
local resc = ""
local resclab = ""
local extraoptions = ""
}
if "`outcome'" == "avgmemb" {
local graphtitle = "Union Members per Branch"
local gap = 1
local resc = ""
local resclab = ""
local extraoptions = "xlabel(0(200)1200) xscale(range(-50 1200))"
}	
	

coefplot 	(baseline_`outcome', msymbol(O) lcolor("178 65 0") mcolor("178 65 0") msize(medsmall) ciopt(recast(rcap) msymbol(none) ///
			lpattern(solid) lwidth(medthin) lcolor("178 65 0"))) ///
			(robctrl_`outcome'_*, msymbol(O) lcolor("navy*0.9") mcolor("navy*0.9") msize(medsmall) ciopt(recast(rcap) msymbol(none) ///
			lpattern(solid) lwidth(medthin) lcolor("navy*0.9"))), ///
			title("Coefficient", size(small)) ylabel(, labsize(vsmall) angle(0) glcolor(gs16)) ///
			graphregion(color(white)) plotregion(color(white)) legend(off) xlabel(, labsize(vsmall)) ///
			xline(0, lwidth(vthin) lcolor("178 65 0")) ///
			drop (_cons) title("`graphtitle'", size(small)) name(`outcome'_robcontrols, replace) ///
			xtitle("2SLS Coeff. {it:Share of Immigrants}", size(vsmall)) ///
			asequation swapnames grid(none) ///
			ci(95) ///
			eqrename(baseline_`outcome' = "Baseline" ///
					 robctrl_`outcome'_1 = "Urban pop. share    –     1" ///
					 robctrl_`outcome'_2 = `"Pop. density    –     2"' ///					 
					 robctrl_`outcome'_3 = `"Imm. pop. share    –     3"' ///
					 robctrl_`outcome'_4 = `"Imm. pop. share (1880)    –     4"' ///					 
					 robctrl_`outcome'_5 = `"Black pop. share    –     5"' ///
					 robctrl_`outcome'_6 = `"Share LF by industry (1880)    –     6"' ///
					 robctrl_`outcome'_7 = `"Share LF by skill (1880)    –     7"' ///
					 robctrl_`outcome'_8 = `"Occ. inc. score (1880)   –     8"' ///
					 robctrl_`outcome'_9 = `"Mfg. outp. growth    –     9"' ///
					 robctrl_`outcome'_10 = `"Railroad presence    –     10"' ///
					 robctrl_`outcome'_11 = `"Dem. vote share    – 11"' ///
					  ) ///
					 `extraoptions'
					 
					 		
}

graph combine pres_robcontrols ihsloc_robcontrols dens_robcontrols avgmemb_robcontrols, graphregion(color(white) margin(zero)) ///
																							plotregion(color(white) margin(zero))

graph export "$figures/rob_controls.pdf", replace



*------------------------------------------------------------------------------*
* Alternative baseline specification
* Paper: contributes to the robustness summary (Figure 3, rob_summary.pdf)
*------------------------------------------------------------------------------*

foreach outcome in pres ihsloc dens avgmemb  {

local filename = "rob_altbasespec_`outcome'"

foreach fmt in txt xml {	
cap erase "$tables/`filename'.`fmt'"		
}

local var = "afl_comb_all_`outcome'"


foreach n in 1 2 3 4 {

				
ivreghdfe `var'					   (sh_euro_wa_10yr_m  = pr1890_sh_euro_wa_10yr_m) ///
									 if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
									 a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}")
								   
if `n' == 1 {
est store robnobasectrls_`outcome'	
} 								   
										 
local fstat = string(`e(widstat)',"%6.2fc")
local obs = string(e(N),"%15.0f")									 
qui sum `var' if e(sample) == 1
if "`var'" == "afl_comb_all_ihsloc" {
qui sum afl_comb_all_locals if e(sample) == 1
}
local depvarmean = string(r(mean),"%6.3fc")
qui sum sh_euro_wa_10yr_m if e(sample) == 1
local sheuromean = string(r(mean),"%6.3fc")
local sheurostdev = string(r(sd),"%6.3fc")

}


foreach n in 1 2 3 4  {

				
ivreghdfe `var'					   (sh_euro_wa_10yr_m  = pr1890_sh_euro_wa_10yr_m) ///
								   if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
								   a("${idfe} ${tfe} ${controls`n'}" state_year) cluster("${idfe}") 
								   
								   
if `n' == 4 {
est store robstateyear_`outcome'	
} 								   
										 
local fstat = string(`e(widstat)',"%6.2fc")
local obs = string(e(N),"%15.0f")									 
qui sum `var' if e(sample) == 1
if "`var'" == "afl_comb_all_ihsloc" {
qui sum afl_comb_all_locals if e(sample) == 1
}
local depvarmean = string(r(mean),"%6.3fc")
qui sum sh_euro_wa_10yr_m if e(sample) == 1
local sheuromean = string(r(mean),"%6.3fc")
local sheurostdev = string(r(sd),"%6.3fc")

}

foreach fmt in txt {	
cap erase "$tables/`filename'.`fmt'"		
}
									
}



*------------------------------------------------------------------------------*
* Drop outliers of the dependent variable
* Paper: contributes to the robustness summary (Figure 3, rob_summary.pdf)
*------------------------------------------------------------------------------*

local filename = "rob_outliers_depvar"

preserve 

foreach fmt in txt xml {	
cap erase "$tables/`filename'.`fmt'"		
}

foreach outcome in ihsloc dens avgmemb {
local var = "afl_comb_all_`outcome'"
winsor2 `var', cuts(1 99) trim
}
gen afl_comb_all_pres_tr = (afl_comb_all_dens_tr > 0) if afl_comb_all_dens_tr != .

foreach outcome in pres ihsloc dens avgmemb {

local var = "afl_comb_all_`outcome'"

local n = 4	
			
ivreghdfe `var'_tr				   (sh_euro_wa_10yr_m  = pr1890_sh_euro_wa_10yr_m) ///
								   if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
								   a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}") first

est store roboutdepvar_`outcome'	
								   
local fstat = string(`e(widstat)',"%6.2fc")
local obs = string(e(N),"%15.0f")									 
qui sum `var' if e(sample) == 1
if "`var'" == "afl_comb_all_ihsloc" {
qui sum afl_comb_all_locals if e(sample) == 1
}
local depvarmean = string(r(mean),"%6.3fc")
qui sum sh_euro_wa_10yr_m if e(sample) == 1
local sheuromean = string(r(mean),"%6.3fc")
local sheurostdev = string(r(sd),"%6.3fc")
									
}

foreach fmt in txt {	
cap erase "$tables/`filename'.`fmt'"		
}

restore


*------------------------------------------------------------------------------*
* Drop outliers of the immigrant share
* Paper: contributes to the robustness summary (Figure 3, rob_summary.pdf)
*------------------------------------------------------------------------------*

local filename = "rob_outliers_immshare"

preserve 

winsor2 sh_euro_wa_10yr_m, cuts(1 99) trim replace

foreach fmt in txt xml {	
cap erase "$tables/`filename'.`fmt'"		
}

foreach outcome in pres ihsloc dens avgmemb {

local var = "afl_comb_all_`outcome'"
local n = 4
	
		
ivreghdfe `var'					   (sh_euro_wa_10yr_m  = pr1890_sh_euro_wa_10yr_m) ///
								   if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
								   a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}") first
	
est store roboutindepvar_`outcome'	
	
local fstat = string(`e(widstat)',"%6.2fc")
local obs = string(e(N),"%15.0f")									 
qui sum `var' if e(sample) == 1
if "`var'" == "afl_comb_all_ihsloc" {
qui sum afl_comb_all_locals if e(sample) == 1
}
local depvarmean = string(r(mean),"%6.3fc")
qui sum sh_euro_wa_10yr_m if e(sample) == 1
local sheuromean = string(r(mean),"%6.3fc")
local sheurostdev = string(r(sd),"%6.3fc")
									
}

foreach fmt in txt {	
cap erase "$tables/`filename'.`fmt'"		
}

restore



*------------------------------------------------------------------------------*
* Cluster standard errors by SEA
* Paper: contributes to the robustness summary (Figure 3, rob_summary.pdf)
*------------------------------------------------------------------------------*

local filename = "rob_clustersea"

foreach fmt in txt xml {	
cap erase "$tables/`filename'.`fmt'"		
}

foreach outcome in pres ihsloc dens avgmemb {

local var = "afl_comb_all_`outcome'"	
local n = 4	
			
ivreghdfe `var'					   (sh_euro_wa_10yr_m  = pr1890_sh_euro_wa_10yr_m) ///
								   if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
								   a("${idfe} ${tfe} ${controls`n'}") cluster(sea)
	
est store robclustsea_`outcome'	
	
local fstat = string(`e(widstat)',"%6.2fc")
local obs = string(e(N),"%15.0f")									 
qui sum `var' if e(sample) == 1
if "`var'" == "afl_comb_all_ihsloc" {
qui sum afl_comb_all_locals if e(sample) == 1
}
local depvarmean = string(r(mean),"%6.3fc")
qui sum sh_euro_wa_10yr_m if e(sample) == 1
local sheuromean = string(r(mean),"%6.3fc")
local sheurostdev = string(r(sd),"%6.3fc")

									
}

foreach fmt in txt {	
cap erase "$tables/`filename'.`fmt'"		
}


*------------------------------------------------------------------------------*
* Account for spatial correlation (Conley 1999)
* Paper: contributes to the robustness summary (Figure 3, rob_summary.pdf)
*------------------------------------------------------------------------------*

preserve

drop if centroid_y == . | centroid_x == .

foreach y in 1910 1920 {
	gen d_`y' = (year == `y')
}
foreach var in farmfams_share_1890 mfglabor_share_mw_1890 mining_1890 rail_conn_1890 {
	gen `var'_d1910 = `var' * d_1910
	gen `var'_d1920 = `var' * d_1920
}

foreach dist in 200 500 {
	
local filename = "rob_conley`dist'km"
local n = 4

foreach fmt in txt xml {	
cap erase "$tables/`filename'.`fmt'"		
}

foreach outcome in pres ihsloc dens avgmemb {

local var = "afl_comb_all_`outcome'"
	
acreg `var'								(sh_euro_wa_10yr_m  = pr1890_sh_euro_wa_10yr_m) ///
										farmfams_share_1890_d* mfglabor_share_mw_1890_d* mining_1890_d* ///
										if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
										pfe1("${idfe}") pfe2("${tfe}") id("${idfe}") time("${tfe}") ///
										spatial latitude(centroid_y) longitude(centroid_x) hac dist(`dist') lag(0) dropsingletons
									
est store robconley`dist'_`outcome'	
									
local fstat = string(`e(widstat)',"%6.2fc")
local obs = string(e(N),"%15.0f")									 
qui sum `var' if e(sample) == 1
if "`var'" == "afl_comb_all_ihsloc" {
qui sum afl_comb_all_locals if e(sample) == 1
}
local depvarmean = string(r(mean),"%6.3fc")
qui sum sh_euro_wa_10yr_m if e(sample) == 1
local sheuromean = string(r(mean),"%6.3fc")
local sheurostdev = string(r(sd),"%6.3fc")


}

foreach fmt in txt {	
cap erase "$tables/`filename'.`fmt'"		
}

}

restore



*------------------------------------------------------------------------------*
* Standard-error correction for shift-share instruments (Adao et al. 2019)
* Paper: contributes to the robustness summary (Figure 3, rob_summary.pdf)
*------------------------------------------------------------------------------*

local filename = "rob_adaose"
local n = 4

foreach fmt in txt xml {	
cap erase "$tables/`filename'.`fmt'"		
}

foreach outcome in pres ihsloc dens avgmemb {

preserve

keep if insample_balanced == 1 & inrange(year,1900,1920) == 1

qui tab countynhg_1930, gen(countynhg_1930_d)
foreach y in 1910 1920 {
	gen d_`y' = (year == `y')
}

foreach var in farmfams_share_1890 mfglabor_share_mw_1890 mining_1890 rail_conn_1890 {
	gen `var'_d1910 = `var' * d_1910
	gen `var'_d1920 = `var' * d_1920
}

global shares_countries_ivregss "sh_denmark_mw_1890 sh_norway_mw_1890 sh_sweden_mw_1890 sh_uk_mw_1890 sh_ireland_mw_1890 sh_belgium_mw_1890 sh_france_mw_1890 sh_luxemb_mw_1890 sh_nether_mw_1890 sh_switz_mw_1890 sh_italy_mw_1890 sh_gr_pt_es_mw_1890 sh_aus_hung_mw_1890 sh_czech_mw_1890 sh_germany_mw_1890 sh_poland_mw_1890 sh_russia_mw_1890"

global controls_ivregss "farmfams_share_1890_d* mfglabor_share_mw_1890_d* mining_1890_d*"
						   
ivreg_ss afl_comb_all_`outcome', endogenous_var(sh_euro_wa_10yr_m) shiftshare_iv(pr1890_sh_euro_wa_10yr_m) ///
								 share_varlist(${shares_countries_ivregss}) ///
								 control_varlist(countynhg_1930_d* d_1910 d_1920 ${controls_ivregss}) cluster_var(countynhg_1930)

est store robadaose_`outcome'	
													   
					   
restore

}

foreach fmt in txt {	
cap erase "$tables/`filename'.`fmt'"		
}





*------------------------------------------------------------------------------*
* Urban and rural sample, balanced
* Paper: contributes to the robustness summary (Figure 3, rob_summary.pdf)
*------------------------------------------------------------------------------*

bysort countynhg_1930 (year): gegen comb_nrobs_urbrur_temp = count(afl_comb_all_dens) if inlist(year,1900,1910,1920) == 1
bysort countynhg_1930 (year): gegen comb_nrobs_urbrur = max(comb_nrobs_urbrur_temp)
drop comb_nrobs_urbrur_temp

local filename = "rob_urbruralsample"

foreach fmt in txt xml {	
cap erase "$tables/`filename'.`fmt'"		
}

foreach outcome in pres ihsloc dens avgmemb {

local var = "afl_comb_all_`outcome'"	
local n = 4
			
ivreghdfe `var'					   (sh_euro_wa_10yr_m  = pr1890_sh_euro_wa_10yr_m) ///
								   if afl_comb_all_dens != . & comb_nrobs_urbrur == 3 & inrange(year,1900,1920) == 1, ///
								   a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}")  	

est store roburbrur_`outcome'	
								   
local fstat = string(`e(widstat)',"%6.2fc")
local obs = string(e(N),"%15.0f")									 
qui sum `var' if e(sample) == 1
if "`var'" == "afl_comb_all_ihsloc" {
qui sum afl_comb_all_locals if e(sample) == 1
}
local depvarmean = string(r(mean),"%6.3fc")
qui sum sh_euro_wa_10yr_m if e(sample) == 1
local sheuromean = string(r(mean),"%6.3fc")
local sheurostdev = string(r(sd),"%6.3fc")

									
}

foreach fmt in txt {	
cap erase "$tables/`filename'.`fmt'"		
}


*------------------------------------------------------------------------------*
* Unbalanced sample
* Paper: contributes to the robustness summary (Figure 3, rob_summary.pdf)
*------------------------------------------------------------------------------*

local filename = "rob_unbalanced"

foreach fmt in txt xml {	
cap erase "$tables/`filename'.`fmt'"		
}

foreach outcome in pres ihsloc dens avgmemb {

local var = "afl_comb_all_`outcome'"	
local n = 4
			
ivreghdfe `var'					   (sh_euro_wa_10yr_m  = pr1890_sh_euro_wa_10yr_m) ///
								   if insample == 1 & inrange(year,1900,1920) == 1, ///
								   a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}") 

est store robunbalan_`outcome'	
								   
local fstat = string(`e(widstat)',"%6.2fc")
local obs = string(e(N),"%15.0f")									 
qui sum `var' if e(sample) == 1
if "`var'" == "afl_comb_all_ihsloc" {
qui sum afl_comb_all_locals if e(sample) == 1
}
local depvarmean = string(r(mean),"%6.3fc")
qui sum sh_euro_wa_10yr_m if e(sample) == 1
local sheuromean = string(r(mean),"%6.3fc")
local sheurostdev = string(r(sd),"%6.3fc")

									
}

foreach fmt in txt {	
cap erase "$tables/`filename'.`fmt'"		
}


*------------------------------------------------------------------------------*
* Urban and rural sample, unbalanced
* Paper: contributes to the robustness summary (Figure 3, rob_summary.pdf)
*------------------------------------------------------------------------------*

local filename = "rob_urbruralsample_unbalanced"

foreach fmt in txt xml {	
cap erase "$tables/`filename'.`fmt'"		
}

foreach outcome in pres ihsloc dens avgmemb {

local var = "afl_comb_all_`outcome'"	
local n = 4
			
ivreghdfe `var'					   (sh_euro_wa_10yr_m  = pr1890_sh_euro_wa_10yr_m) ///
								   if afl_comb_all_dens != . & inrange(year,1900,1920) == 1, ///
								   a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}")  	

est store roburbruunb_`outcome'	
								   
local fstat = string(`e(widstat)',"%6.2fc")
local obs = string(e(N),"%15.0f")									 
qui sum `var' if e(sample) == 1
if "`var'" == "afl_comb_all_ihsloc" {
qui sum afl_comb_all_locals if e(sample) == 1
}
local depvarmean = string(r(mean),"%6.3fc")
qui sum sh_euro_wa_10yr_m if e(sample) == 1
local sheuromean = string(r(mean),"%6.3fc")
local sheurostdev = string(r(sd),"%6.3fc")

									
}

foreach fmt in txt {	
cap erase "$tables/`filename'.`fmt'"		
}


*------------------------------------------------------------------------------*
* Excluding the South
* Paper: contributes to the robustness summary (Figure 3, rob_summary.pdf)
*------------------------------------------------------------------------------*

local filename = "rob_nosouth"

foreach fmt in txt xml {	
cap erase "$tables/`filename'.`fmt'"		
}

foreach outcome in pres ihsloc dens avgmemb {

local var = "afl_comb_all_`outcome'"	
local n = 4	
			
ivreghdfe `var'					   (sh_euro_wa_10yr_m  = pr1890_sh_euro_wa_10yr_m) ///
								   if insample_balanced == 1 & inrange(year,1900,1920) == 1 & inrange(region,31,33) == 0, ///
								   a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}")  	

est store robnosouth_`outcome'	
								   
local fstat = string(`e(widstat)',"%6.2fc")
local obs = string(e(N),"%15.0f")									 
qui sum `var' if e(sample) == 1
if "`var'" == "afl_comb_all_ihsloc" {
qui sum afl_comb_all_locals if e(sample) == 1
}
local depvarmean = string(r(mean),"%6.3fc")
qui sum sh_euro_wa_10yr_m if e(sample) == 1
local sheuromean = string(r(mean),"%6.3fc")
local sheurostdev = string(r(sd),"%6.3fc")

									
}

foreach fmt in txt {	
cap erase "$tables/`filename'.`fmt'"		
}




*------------------------------------------------------------------------------*
* Analysis at the SEA level
* Paper: contributes to the robustness summary (Figure 3, rob_summary.pdf)
*------------------------------------------------------------------------------*

local filename = "rob_sealevel"

foreach fmt in txt xml {	
cap erase "$tables/`filename'.`fmt'"		
}

preserve

keep if inrange(year,1890,1920) == 1

foreach var of varlist mfglabor_mw_ip nr_farmfams nr_fams {
gen `var'_1890_temp = `var' if year == 1890
bysort countynhg_1930 (year): egen `var'_1890  = max(`var'_1890_temp)
}

collapse (sum) afl_comb_memb_all afl_comb_all_locals ///
			   all_lf_lowskill_m all_lf_midskill2_m all_lf_highskill2_m ///
			   euro_wa_10yr_m all_wkgagepop_m pr1890_euro_10yr_m all_totpop_m_1890 ///
			   nr_farmfams_1890 nr_fams_1890 mfglabor_mw_ip_1890 all_totpop_mw_1890 coalmines_tot_1890 ///
		 (max) rail_conn_1890 mining_1890, ///
			   by(sea year insample_balanced)

gen afl_comb_all_dens 			= afl_comb_memb_all / (all_lf_lowskill_m + all_lf_midskill2_m + all_lf_highskill2_m)
replace afl_comb_all_dens 		= 1 if afl_comb_all_dens > 1 & afl_comb_all_dens != .	   
gen afl_comb_all_pres			= (afl_comb_all_dens > 0) if afl_comb_all_dens != .
gen afl_comb_all_avgmemb 		= afl_comb_memb_all / afl_comb_all_locals if afl_comb_all_dens != .		
replace afl_comb_all_avgmemb 	= 0 if afl_comb_all_dens == 0	
		 
winsor2 afl_comb_all_locals afl_comb_all_dens afl_comb_all_avgmemb, replace cuts(1 99)
gen afl_comb_all_ihsloc			= log(1 + afl_comb_all_locals)
		 
		 
gen sh_euro_wa_10yr_m 			= euro_wa_10yr_m / all_wkgagepop_m
gen pr1890_sh_euro_wa_10yr_m 	= pr1890_euro_10yr_m / all_totpop_m_1890
			   
gen farmfams_share_1890 		= nr_farmfams / nr_fams			   
gen mfglabor_share_mw_1890 		= mfglabor_mw_ip_1890 / all_totpop_mw_1890
gen coalmines_perpop_1890		= coalmines_tot_1890 / (all_totpop_mw_1890/1000)


foreach outcome in pres ihsloc dens avgmemb {

local var = "afl_comb_all_`outcome'"
local n = 4

ivreghdfe `var'			 (sh_euro_wa_10yr_m = pr1890_sh_euro_wa_10yr_m) ///
						 if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
						 a(sea ${tfe} ${controls`n'}) cluster(sea)

est store robsealevel_`outcome'	
								   
local fstat = string(`e(widstat)',"%6.2fc")
local obs = string(e(N),"%15.0f")									 
qui sum `var' if e(sample) == 1
if "`var'" == "afl_comb_all_ihsloc" {
qui sum afl_comb_all_locals if e(sample) == 1
}
local depvarmean = string(r(mean),"%6.3fc")
qui sum sh_euro_wa_10yr_m if e(sample) == 1
local sheuromean = string(r(mean),"%6.3fc")
local sheurostdev = string(r(sd),"%6.3fc")
									
}

restore


foreach fmt in txt {	
cap erase "$tables/`filename'.`fmt'"		
}



*------------------------------------------------------------------------------*
* Using only AFL state-convention data
* Paper: contributes to the robustness summary (Figure 3, rob_summary.pdf)
*------------------------------------------------------------------------------*

local filename = "rob_onlyafldata"

foreach fmt in txt xml {	
cap erase "$tables/`filename'.`fmt'"		
}

foreach outcome in pres ihsloc dens avgmemb {

local var = "afl_all_`outcome'"	
local n = 4	
			
ivreghdfe `var'					   (sh_euro_wa_10yr_m  = pr1890_sh_euro_wa_10yr_m) ///
								   if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
								   a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}")  	

est store robafldata_`outcome'	
								   
local fstat = string(`e(widstat)',"%6.2fc")
local obs = string(e(N),"%15.0f")									 
qui sum `var' if e(sample) == 1
if "`var'" == "afl_comb_all_ihsloc" {
qui sum afl_comb_all_locals if e(sample) == 1
}
local depvarmean = string(r(mean),"%6.3fc")
qui sum sh_euro_wa_10yr_m if e(sample) == 1
local sheuromean = string(r(mean),"%6.3fc")
local sheurostdev = string(r(sd),"%6.3fc")
									
}

foreach fmt in txt {	
cap erase "$tables/`filename'.`fmt'"		
}

				

*------------------------------------------------------------------------------*
* Matching
* Paper: contributes to the robustness summary (Figure 3, rob_summary.pdf)
*------------------------------------------------------------------------------*

foreach year in 1880 1890 {
	
if `year' == 1880 {
local sortingvar3 = "mfglabor_share_mw_`year'"
local sortingvar4 = "farm_share_mw_`year'"
local sortingvar5 = "mining_`year'"
}

if `year' == 1890 {
local sortingvar3 = "mfglabor_share_mw_`year'"
local sortingvar4 = "farmfams_share_`year'"
local sortingvar5 = "mining_`year'"
}	


*Match on 1890 presence of KOL locals
preserve

gen farm_share_mw_1880_temp = (all_lf_farmer_m + all_lf_farmlab_m + all_lf_farmer_w + all_lf_farmlab_w) / (all_lf_tot_m + all_lf_tot_w) if year == 1880
bysort countynhg_1930 (year): egen farm_share_mw_1880 = max(farm_share_mw_1880_temp)

gen mining_share_mw_1880_temp = (all_lf_mining_m + all_lf_mining_w) / (all_lf_tot_m + all_lf_tot_w) if year == 1880
bysort countynhg_1930 (year): egen mining_share_mw_1880 = max(mining_share_mw_1880_temp)
gen mining_1880 = (mining_share_mw_1880 > 0) if mining_share_mw_1880 != .

gen rail_conn_1880 = (year_conn_rr < 1880)	
gen 	rail_conn_nryears_1880 = (1880 - year_conn_rr)							// nr. of years since connection to rr as of 1880
replace rail_conn_nryears_1880 = 0 if year_conn_rr > 1880								

keep if year == 1920 & insample_balanced == 1
keep countynhg_1930 statefip ///
	 locals_kol_1880 locals_kol_perpop_1880 locals_kol_perurbpop_1880  ///
	 locals_kol_1890 locals_kol_perpop_1890 locals_kol_perurbpop_1890 all_totpop_m_1890 ///
	 mfg_share_m_1880 agric_share_m_1880 mining_1880 ///
	 mfglabor_share_mw_1890 farmfams_share_1890 coalmines_perpop_1890 mining_1890 rail_conn_1890 rail_conn_nryears_1890 ///
	 mfglabor_share_mw_1880 farm_share_mw_1880 mining_share_mw_1880 rail_conn_1880 rail_conn_nryears_1880 ///
	 euro_imm_share_mw_1890 euro_imm_totpop_mw_1890 all_totpop_mw_1890 ///
	 euro_imm_share_mw_1880 euro_imm_totpop_mw_1880 all_totpop_mw_1880
	 
local sortingvar1 = "locals_kol_perpop_`year'"
local sortingvar2 = "locals_kol_`year'"

*Sort on number of KOL branches in the county, from the highest to the lowest
gen sortingvar1 = - `sortingvar1'
gen sortingvar2 = - `sortingvar2'
gen sortingvar3 = - `sortingvar3'
gen sortingvar4 = - `sortingvar4'
gen sortingvar5 = - `sortingvar5'

set seed 824159
gen sortingvar7 = runiform()

*Within each state, sort counties according to the share (and, if there are ties, on the levels), and create a ranking  
bysort statefip (sortingvar1 sortingvar2 sortingvar3 sortingvar4 sortingvar5  sortingvar7): gen n = _n 				  
																				
*Match counties within states, assigning the same value to the first two counties in each state
gen pair = 1 if n == 1 | n == 2

*Keep assigning values with an iterative procedure
qui sum n
local N=r(max)
forvalues i=3(2)`N' {
replace pair = `i' if n == `i' | n == `=`i'+1'
}

*Create the pairs for each state
egen idmatch_kol = group(statefip pair)  
keep idmatch_kol countynhg_1930 

tempfile matching_kol
save `matching_kol', replace
restore

cap drop idmatch_kol
merge m:1 countynhg_1930 using `matching_kol', keepusing(idmatch_kol)
drop _merge




*Replicate 2SLS analysis controlling for county-pair FE interacted w/ year dummies
local n = 1

foreach match in match_kol {
		
local filename = "rob_`match'`year'"

foreach fmt in xml txt {	
cap erase "$tables/`filename'.`fmt'"
cap erase "$tables/`filename'_baseline.`fmt'"						
}	

foreach outcome in pres ihsloc dens avgmemb {

local var = "afl_comb_all_`outcome'"
	
* Matching
ivreghdfe `var'					   (sh_euro_wa_10yr_m  = pr1890_sh_euro_wa_10yr_m) ///
								   if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
								   a("${idfe} ${tfe} ${controls`n'}" id`match'#year) cluster(id`match')  	
						
est store rob`match'`year'_`outcome'	
								   							 
local fstat = string(`e(widstat)',"%6.2fc")
local obs = string(e(N),"%15.0f")									 
qui sum `var' if e(sample) == 1
if "`var'" == "afl_comb_all_ihsloc" {
qui sum afl_comb_all_locals if e(sample) == 1
}
local depvarmean = string(r(mean),"%6.3fc")
qui sum sh_euro_wa_10yr_m if e(sample) == 1
local sheuromean = string(r(mean),"%6.3fc")
local sheurostdev = string(r(sd),"%6.3fc")
	
	
* Repeat baseline on same sample
ivreghdfe `var'					   (sh_euro_wa_10yr_m  = pr1890_sh_euro_wa_10yr_m) ///
								   if insample_balanced == 1 & inrange(year,1900,1920) == 1 & e(sample) == 1, ///
								   a("${idfe} ${tfe} ${controls3}") cluster("${idfe}")  	
								   
local fstat = string(`e(widstat)',"%6.2fc")
local obs = string(e(N),"%15.0f")									 
qui sum `var' if e(sample) == 1
if "`var'" == "afl_comb_all_ihsloc" {
qui sum afl_comb_all_locals if e(sample) == 1
}
local depvarmean = string(r(mean),"%6.3fc")
qui sum sh_euro_wa_10yr_m if e(sample) == 1
local sheuromean = string(r(mean),"%6.3fc")
local sheurostdev = string(r(sd),"%6.3fc")

} 

}	

}

foreach fmt in txt {	
cap erase "$tables/`filename'.`fmt'"
cap erase "$tables/`filename'_baseline.`fmt'"				
}	
										 
	

* Weather-shocks alternative instrument

***First stage with alternative instrument	

foreach fmt in txt xml {	
cap erase "$tables/rob_weathershocks_firststage.`fmt'"		
}

foreach n in 1 2 3 4 {

ivreghdfe afl_comb_all_dens			 (sh_euro_wa_10yr_m = pr_temp_sh_euro_10yr_m) ///
									 if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
								     a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}")  	
local fstat = string(`e(widstat)',"%6.2fc")
									 
reghdfe sh_euro_wa_10yr_m			 pr_temp_sh_euro_10yr_m ///
									 if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
								     a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}")  	

local obs = string(e(N),"%15.0f")									 
qui sum sh_euro_wa_10yr_m if e(sample) == 1
local depvarmean = string(r(mean),"%6.3fc")
qui sum pr_temp_sh_euro_10yr_m if e(sample) == 1
local indepvarmean = string(r(mean),"%6.3fc")
local indepvarstdev = string(r(sd),"%6.3fc")
outreg2 using "$tables/rob_weathershocks_firststage", append dec(3) label nor2 nocons stats(coef se) bracket(beta) paren(se) ///
									addtext(Outcome mean, "`depvarmean'", Imm. Share mean, "`indepvarmean'", ///
									KP F-stat, "`fstat'", "${fetext}, ${controlstext`n'}") ///
									excel nonotes keep(sh_euro* pr*_sh_euro*) 	
}
									
foreach fmt in txt {	
cap erase "$tables/rob_weathershocks_firststage.`fmt'"		
}



***2SLS with alternative instrument

local filename = "rob_weathershocks"
local n = 4	

foreach fmt in txt xml {	
cap erase "$tables/`filename'.`fmt'"		
}

foreach outcome in pres ihsloc dens avgmemb {
	
foreach union in all {
	
local var = "afl_comb_`union'_`outcome'"

ivreghdfe `var'						 (sh_euro_wa_10yr_m = pr_temp_sh_euro_10yr_m) ///
									 if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
								     a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}")  	

est store robweathinstr_`outcome'										 
									 
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

}

	
}

foreach fmt in txt {	
cap erase "$tables/`filename'.`fmt'"	
			
}



* Alternative definition of immigrant share (endogenous variable)

local filename = "rob_euroimmdef"
local n = 4	

foreach k in 1 2 3 4 {
foreach fmt in txt xml {	
cap erase "$tables/`filename'`k'.`fmt'"	
}			
}
foreach outcome in pres ihsloc dens avgmemb {

local union = "all"
local var = "afl_comb_`union'_`outcome'"
							

*All working-age immigrants, men only
preserve

replace sh_euro_wa_10yr_m = euro_imm_wkgagepop_m / all_wkgagepop_m if sh_euro_wa_10yr_m != .

ivreghdfe `var'						 (sh_euro_wa_10yr_m = pr1890_sh_euro_wa_10yr_m) ///
									 if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
									 a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}")

est store robeuroimmdef1_`outcome'										 
									 
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
									
restore
									
*Recent working-age immigrants, men and women
preserve

replace sh_euro_wa_10yr_m = (euro_wa_10yr_m + euro_wa_10yr_w) / all_wkgagepop_mw if sh_euro_wa_10yr_m != .
replace pr1890_sh_euro_wa_10yr_m = pr1890_euro_10yr_mw / (all_totpop_mw_1890) if pr1890_sh_euro_wa_10yr_m != .

ivreghdfe `var'						 (sh_euro_wa_10yr_m = pr1890_sh_euro_wa_10yr_m) ///
									 if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
									 a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}")

est store robeuroimmdef2_`outcome'										 
									 
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

restore									
																					 
*All working-age immigrants, men and women
preserve

replace sh_euro_wa_10yr_m = euro_imm_wkgagepop_mw / all_wkgagepop_mw
replace pr1890_sh_euro_wa_10yr_m = pr1890_euro_10yr_mw / (all_totpop_mw_1890) if pr1890_sh_euro_wa_10yr_m != .

ivreghdfe `var'						 (sh_euro_wa_10yr_m = pr1890_sh_euro_wa_10yr_m) ///
									 if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
									 a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}")

est store robeuroimmdef3_`outcome'										 
									 
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
	
restore

*All immigrants, men and women
preserve

replace sh_euro_wa_10yr_m = euro_imm_share_mw if sh_euro_wa_10yr_m != .
replace pr1890_sh_euro_wa_10yr_m = pr1890_euro_10yr_mw / (all_totpop_mw_1890) if pr1890_sh_euro_wa_10yr_m != .

ivreghdfe `var'						 (sh_euro_wa_10yr_m = pr1890_sh_euro_wa_10yr_m) ///
									 if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
									 a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}")

est store robeuroimmdef4_`outcome'										 
									 
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
										
restore

}

foreach k in 1 2 3 4 {
foreach fmt in txt {	
cap erase "$tables/`filename'`k'.`fmt'"	
}			
}




* Interpolated observations

local filename = "rob_interp"
local n = 4	

foreach k in 1 2 {
foreach fmt in txt xml {	
cap erase "$tables/`filename'`k'.`fmt'"	
}			
}	


foreach outcome in pres ihsloc dens avgmemb {	
	
local union = "all"
local var = "afl_comb_`union'_`outcome'"
	
ivreghdfe `var'						 (sh_euro_wa_10yr_m = pr1890_sh_euro_wa_10yr_m)  ///
									 if insample_balanced == 1 & inrange(year,1900,1920) == 1 & afl_comb_interp != 1, ///
									 a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}")									 

est store robinterp1_`outcome'										 
									 
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
									
									
ivreghdfe `var'						 (sh_euro_wa_10yr_m = pr1890_sh_euro_wa_10yr_m) afl_comb_interp ///
									 if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
									 a("${idfe} ${tfe} ${controls5}") cluster("${idfe}")										
									
est store robinterp2_`outcome'										 
									 
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
																	 									 
}
									 
foreach k in 1 2 {
foreach fmt in txt {	
cap erase "$tables/`filename'`k'.`fmt'"	
}			
}										 
													
									
			
*Also, no correlation between immigration and missing union data 									 
reghdfe afl_comb_interp 			 sh_euro_wa_10yr_m ///
									 if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
									 a("${idfe} ${tfe} ${controls5}") cluster("${idfe}")
			
			
			
			

* Alternative definition of union density

local filename = "rob_altdefuniondens"
local n = 4	

foreach fmt in txt xml {	
cap erase "$tables/`filename'.`fmt'"	
}			

foreach outcome in dens_2 dens_3 dens_4 {

local union = "all"
local var = "afl_comb_`union'_`outcome'"
							
ivreghdfe `var'						 (sh_euro_wa_10yr_m = pr1890_sh_euro_wa_10yr_m) ///
									 if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
									 a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}")

est store rob_altdefuniondens_`outcome'										 
									 
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
			

}

foreach fmt in txt {	
cap erase "$tables/`filename'.`fmt'"	
}	




* Exclude year 1920

local filename = "rob_no1920"
local n = 4	

foreach fmt in txt xml {	
cap erase "$tables/`filename'.`fmt'"	
}			

foreach outcome in pres ihsloc dens avgmemb {

local union = "all"
local var = "afl_comb_`union'_`outcome'"
							
ivreghdfe `var'						 (sh_euro_wa_10yr_m = pr1890_sh_euro_wa_10yr_m) ///
									 if insample_balanced == 1 & inrange(year,1900,1910) == 1, ///
									 a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}")

est store rob_no1920_`outcome'										 
									 
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
			

}

foreach fmt in txt {	
cap erase "$tables/`filename'.`fmt'"	
}	
		
		
	

*------------------------------------------------------------------------------*
* tF-adjusted standard errors (Lee et al. 2022)
* Paper: contributes to the robustness summary (Figure 3, rob_summary.pdf)
*------------------------------------------------------------------------------*

foreach outcome in pres ihsloc dens avgmemb {
	
local var = "afl_comb_all_`outcome'"
local n = 4

ivreghdfe `var'						 (sh_euro_wa_10yr_m = pr1890_sh_euro_wa_10yr_m) ///
									 if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
									 a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}")		 

est store baseline_`outcome'	


* 1. Restore model and pull coefficients + VCV
est restore baseline_`outcome'	
matrix b_`outcome'	 = e(b)
matrix V_`outcome'	 = e(V)

* 2. Compute standard errors and adjusted ones (via Mata)

* Scaled by 1.0504102 (0.05 tF adjustment from Lee et al., based on first-stage F of 67.363)
mata: st_matrix("se_tF95_`outcome'", sqrt(diagonal(st_matrix("V_`outcome'")))':*1.0504102)

* 3. Compute 95% CIs
local z = 1.96
matrix ll_tF95_`outcome'	 = b_`outcome' - `z'*se_tF95_`outcome'
matrix ul_tF95_`outcome'	 = b_`outcome' + `z'*se_tF95_`outcome'



* 4. Build matrices for coefplot (3 rows: b, lower, upper)
matrix tF_se_`outcome' = b_`outcome' \ ll_tF95_`outcome' \ ul_tF95_`outcome'
matrix rownames tF_se_`outcome' = b ll ul
matrix colnames tF_se_`outcome' = `: colnames b_`outcome''

}
			
				
*------------------------------------------------------------------------------*
* Plot the summary of robustness checks
* Paper: Summary of Robustness Checks (Figure 3); output rob_summary.pdf
*------------------------------------------------------------------------------*

foreach outcome in pres ihsloc dens avgmemb {
	
local var = "afl_comb_all_`outcome'"
local n = 4

ivreghdfe `var'						 (sh_euro_wa_10yr_m = pr1890_sh_euro_wa_10yr_m) ///
									 if insample_balanced == 1 & inrange(year,1900,1920) == 1, ///
									 a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}")		 

est store baseline_`outcome'	

}



*Plot coefficients

foreach outcome in pres ihsloc dens avgmemb {
	
if "`outcome'" == "pres" {
local graphtitle = "Any Union Present"
local gap = 1
local resc = ""
local resclab = ""
local extraoptions = ""
}
if "`outcome'" == "ihsloc" {
local graphtitle = "Number of Union Branches"
local gap = 1
local resc = ""
local resclab = ""
local extraoptions = ""
}
if "`outcome'" == "dens" {
local graphtitle = "Union Density (Members / LF)"
local gap = 1
local resc = ""
local resclab = ""
local extraoptions = ""
}
if "`outcome'" == "avgmemb" {
local graphtitle = "Union Members per Branch"
local gap = 1
local resc = ""
local resclab = ""
local extraoptions = "" 
}	

coefplot 	(baseline_`outcome', msymbol(O) lcolor("178 65 0") mcolor("178 65 0") msize(medsmall) ciopt(recast(rcap) msymbol(none) ///
			lpattern(solid) lwidth(medthin) lcolor("178 65 0"))) ///
			(robweathinstr_`outcome' ///
			robmatch_kol1880_`outcome' ///
			robnobasectrls_`outcome' robstateyear_`outcome' ///
			robadaose_`outcome' robconley200_`outcome' robconley500_`outcome' robclustsea_`outcome', ///
			msymbol(O) lcolor("navy*0.9") mcolor("navy*0.9") msize(medsmall) ciopt(recast(rcap) msymbol(none) ///
			lpattern(solid) lwidth(medthin) lcolor("navy*0.9"))) ///
			(matrix(tF_se_`outcome'), ci((2 3)) ///
			msymbol(O) lcolor("navy*0.9") mcolor("navy*0.9") msize(medsmall) ciopt(recast(rcap) msymbol(none) ///
			lpattern(solid) lwidth(medthin) lcolor("navy*0.9"))) ///
			(roboutdepvar_`outcome' roboutindepvar_`outcome' ///
			robeuroimmdef1_`outcome' robeuroimmdef2_`outcome' robeuroimmdef3_`outcome' robeuroimmdef4_`outcome' ///
			robunbalan_`outcome' roburbrur_`outcome' roburbruunb_`outcome' robnosouth_`outcome' ///
			robsealevel_`outcome' ///
			robinterp1_`outcome'  ///
			robafldata_`outcome' ///
			rob_no1920_`outcome', ///
			msymbol(O) lcolor("navy*0.9") mcolor("navy*0.9") msize(medsmall) ciopt(recast(rcap) msymbol(none) ///
			lpattern(solid) lwidth(medthin) lcolor("navy*0.9"))), ///
			title("Coefficient", size(small)) ylabel(, labsize(vsmall) angle(0) glcolor(gs16)) ///
			graphregion(color(white)) plotregion(color(white)) legend(off) xlabel(, labsize(vsmall)) ///
			xline(0, lwidth(vthin) lcolor("178 65 0")) ///
			drop (_cons) title("`graphtitle'", size(small)) name(`outcome'_robsummary, replace) ///
			xtitle("2SLS Coeff. {it:Share of Immigrants}", size(vsmall)) ///
			asequation swapnames grid(none) keep(sh_euro_wa_10yr_m) ///
			ci(95) ///
			eqrename(baseline_`outcome' = "Baseline" ///
					robweathinstr_`outcome' = `"Alternative shift-share IV    –     1"' ///
					robmatch_kol1880_`outcome' = `"IV + matching    –     2"' ///
					robnobasectrls_`outcome' = `"No controls    –     3"' ///
					robstateyear_`outcome' = `"State x year FE    –     4"' ///
					robadaose_`outcome' = `"Adao et al. (2019) s.e.    –     5"' ///					 
					robconley200_`outcome' = `"Conley (1999) s.e. (200 km)    –     6"' ///					 
					robconley500_`outcome' = `"Conley (1999) s.e. (500 km)    –     7"' ///					 
					robclustsea_`outcome' = `"Cluster s.e. by SEA    –     8"' ///
					tF_se_`outcome' = `"Lee et al. (2022) s.e.   –     9"' ///
					roboutdepvar_`outcome' = `"Drop outliers dep. var.    – 10"' ///
					roboutindepvar_`outcome' = `"Drop outliers indep. var.    – 11"' ///
					robeuroimmdef1_`outcome' = `"Imm.: 16-64yo men    – 12"' ///		
					robeuroimmdef2_`outcome' = `"Imm.: 16-64yo m. & w. <10yrs in US    – 13"' ///	
					robeuroimmdef3_`outcome' = `"Imm.: 16-64yo men & women    – 14"' ///								 
					robeuroimmdef4_`outcome' = `"Imm.: all men & women    – 15"' ///
					robunbalan_`outcome' = `"Unbal. panel (non-rural)    – 16"' ///
					roburbrur_`outcome' = `"Bal. panel (all counties)    – 17"' ///
					roburbruunb_`outcome' = `"Unbal. panel (all counties)    – 18"' ///
					robnosouth_`outcome' = `"Exclude U.S. South    – 19"' ///
					robsealevel_`outcome' = `"Analysis at SEA level    – 20"' ///
					robinterp1_`outcome' = `"Drop interpolated data    – 21"' ///
					robafldata_`outcome' = `"AFL conv. data only    – 22"' ///
					rob_no1920_`outcome' = `"Exclude the 1910s    – 23"') ///
					`extraoptions'
					
}				 

graph combine pres_robsummary ihsloc_robsummary dens_robsummary avgmemb_robsummary, graphregion(color(white) margin(zero)) ///
																							plotregion(color(white) margin(zero))
																							
graph export "$figures/rob_summary.pdf", replace
		
	


* Remove outreg2 .txt/.tmp byproducts left in the tables folder.
foreach pat in "*.txt" "*.tmp" {
    local junk : dir "$tables" files "`pat'"
    foreach f of local junk {
        cap erase "$tables/`f'"
    }
}
