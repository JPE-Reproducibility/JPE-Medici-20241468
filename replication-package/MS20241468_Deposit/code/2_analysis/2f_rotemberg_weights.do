*==============================================================================*
* 2f_rotemberg_weights.do
*
* Rotemberg-weight diagnostics for the shift-share instrument (Goldsmith-Pinkham,
* Sorkin & Swift 2020): per-origin just-identified IV estimates, first-stage
* F-statistics and confidence intervals; the bartik_weight decomposition into
* per-origin Rotemberg weights; the summary table; and the overidentification /
* first-stage heterogeneity figure.
*
* INPUTS:
*   $data/analysis_dataset_county1930.dta          - analysis dataset (1h)
*   $code/2_analysis/2_sample_specifications.do   - sample definition
*
* OUTPUTS:
*   $tables/rotemberg_summary.tex   (Table G.1)
*   $figures/rotemberg_weights.pdf  (Figure G.1)
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

* Goldsmith-Pinkham, Sorkin & Swift (2020) helper programs (bartik_weight,
* ch_weak, btsls, overid_chao), bundled in code/ado/ under BSD-3-Clause.
adopath ++ "$code/ado"

use "$data/analysis_dataset_county1930.dta", clear
do "$code/2_analysis/2_sample_specifications.do"

keep if insample_balanced == 1 & inrange(year,1900,1920) == 1

qui tab year, gen(year_)
drop year_1

local controls mfglabor_share_mw_1890 farmfams_share_1890 mining_1890

local y afl_comb_all_pres
local x sh_euro_wa_10yr_m

local ind_vars sh_denmark_mw_1890 sh_norway_mw_1890 sh_sweden_mw_1890 sh_uk_mw_1890 sh_ireland_mw_1890 sh_belgium_mw_1890 sh_france_mw_1890 sh_luxemb_mw_1890 sh_nether_mw_1890 sh_switz_mw_1890 sh_italy_mw_1890 sh_gr_pt_es_mw_1890 sh_aus_hung_mw_1890 sh_czech_mw_1890 sh_germany_mw_1890 sh_poland_mw_1890 sh_russia_mw_1890

local time_var year
local id_var countynhg_1930

foreach var of local ind_vars {
	replace `var' = `var' / all_totpop_m_1890
}

levelsof `time_var', local(years)

rename *_lvout *_lvo
local growth_vars denmark_US_wa_10yr_m_lvo norway_US_wa_10yr_m_lvo sweden_US_wa_10yr_m_lvo uk_US_wa_10yr_m_lvo ireland_US_wa_10yr_m_lvo belgium_US_wa_10yr_m_lvo france_US_wa_10yr_m_lvo luxemb_US_wa_10yr_m_lvo nether_US_wa_10yr_m_lvo switz_US_wa_10yr_m_lvo italy_US_wa_10yr_m_lvo gr_pt_es_US_wa_10yr_m_lvo aus_hung_US_wa_10yr_m_lvo czech_US_wa_10yr_m_lvo germany_US_wa_10yr_m_lvo poland_US_wa_10yr_m_lvo russia_US_wa_10yr_m_lvo

foreach year of local years {
	foreach ind_var of local ind_vars {
		gen t`year'_`ind_var' = `ind_var' * (year == `year')
		}
	foreach var of local growth_vars {
		gen t`year'_`var'b = `var' if year == `year'
		egen t`year'_`var' = max(t`year'_`var'b), by(`id_var')
		drop t`year'_`var'b
		replace t`year'_`var' = 0 if t`year'_`var' == .
		}
	foreach var of local controls {
		if `year' != 1900 {
			gen t`year'_`var' = `var' * (year == `year')
			}
		}
	}

local controls t*_mfglabor_share_mw_1890 t*_farmfams_share_1890 t*_mining_1890 year_2 year_3
 
foreach ind in denmark norway sweden uk ireland belgium france luxemb nether switz italy gr_pt_es aus_hung czech germany poland russia {

	tempvar temp
	qui gen `temp' = sh_`ind'_mw_1890 * `ind'_US_wa_10yr_m_lvo
	qui reghdfe `x' `temp' `controls', cluster(`id_var') absorb(`id_var')
	local pi_`ind' = _b[`temp']
	qui test `temp'
	local F_`ind' = string(r(F), "%9.3f")
	qui reghdfe  `y' `temp' `controls', cluster(`id_var') absorb(`id_var') 
	local gamma_`ind' = _b[`temp']
	qui ivreghdfe  `y' `controls' (`x'=`temp'), cluster(`id_var') absorb(`id_var')
	local beta_`ind' = string(_b[`x'], "%9.3f") 
	drop `temp'
	
}

foreach ind in aus_hung italy russia gr_pt_es sweden {

	tempvar temp
	qui gen `temp' = sh_`ind'_mw_1890 * `ind'_US_wa_10yr_m_lvo
	ch_weak, p(.05) beta_range(-60(.1)60)   y(`y') x(`x') z(`temp') controls(`controls') cluster(`id_var') absorb(`id_var')
	local ci_min_`ind' = string( r(beta_min), "%9.3f")
	local ci_max_`ind' = string( r(beta_max), "%9.3f")
	drop `temp'

}

preserve

keep `ind_vars' `id_var' `time_var' 
reshape long sh_, i(`id_var' `time_var') j(ind) string
replace ind = subinstr(ind,"_mw_1890","",.)
gen sh_pop = sh_
collapse (sd) sh_sd = sh_ (rawsum) sh_pop, by(ind year)
tempfile tmp
save `tmp'
restore

bartik_weight, z(t*_sh_*_mw_1890) weightstub(t*_US_wa_10yr_m_lvo) x(`x') y(`y') controls(`controls') absorb(`id_var') 

mat beta = r(beta)
mat alpha = r(alpha)
mat gamma = r(gam)
mat pi = r(pi)
mat G = r(G)
qui desc t*_sh_*_mw_1890, varlist
local varlist = r(varlist)

clear
svmat beta
svmat alpha
svmat gamma
svmat pi
svmat G

gen ind = ""
gen year = ""
local t = 1
foreach var in `varlist' {
	if regexm("`var'", "t(.*)_sh_(.*)_mw_1890") {
		qui replace year = regexs(1) if _n == `t'
		qui replace ind = regexs(2) if _n == `t'
		}
	local t = `t' + 1
	}
	
* Calculate Panel C: Variation across years in alpha
total alpha1 if year == "1900"
mat b = e(b)
local sum_1900_alpha = string(b[1,1], "%9.3f")
total alpha1 if year == "1910"
mat b = e(b)
local sum_1910_alpha = string(b[1,1], "%9.3f")
total alpha1 if year == "1920"
mat b = e(b)
local sum_1920_alpha = string(b[1,1], "%9.3f")

sum alpha1 if year == "1900"
local mean_1900_alpha = string(r(mean), "%9.3f")
sum alpha1 if year == "1910"
local mean_1910_alpha = string(r(mean), "%9.3f")
sum alpha1 if year == "1920"
local mean_1920_alpha = string(r(mean), "%9.3f")

destring year, replace
merge 1:1 ind year using `tmp'
gen beta2 = alpha1 * beta1
gen indshare2 = alpha1 * (sh_pop)
gen indshare_sd2 = alpha1 * sh_sd
gen G2 = alpha1 * G1

collapse (sum) alpha1 beta2 indshare2 indshare_sd2 G2 (mean) G1 , by(ind)
gen agg_beta = beta2 / alpha1
gen agg_indshare = indshare2 / alpha1
gen agg_indshare_sd = indshare_sd2 / alpha1
gen agg_g = G2/alpha1

gen ind_name = proper(ind)
replace ind_name = "Austria-Hungary" if ind_name == "Aus_Hung"
replace ind_name = "Czechoslovakia" if ind_name == "Czech"
replace ind_name = "Greece-Portugal-Spain" if ind_name == "Gr_Pt_Es"
replace ind_name = "Luxembourg" if ind_name == "Luxemb"
replace ind_name = "Netherlands" if ind_name == "Nether"
replace ind_name = "Switzerland" if ind_name == "Switz"
replace ind_name = "United Kingdom" if ind_name == "Uk"

gsort -alpha1

capture file close fh
*------------------------------------------------------------------------------*
* Summary table of Rotemberg weights
* Paper: Summary of Rotemberg Weights (Table G.1); output rotemberg_summary.tex
*------------------------------------------------------------------------------*
file open fh  using "$tables/rotemberg_summary.tex", write replace
file write fh "\toprule" _n

* Panel A: Negative and Positive Weights
total alpha1 if alpha1 > 0
mat b = e(b)
local sum_pos_alpha = string(b[1,1], "%9.3f")
total alpha1 if alpha1 < 0
mat b = e(b)
local sum_neg_alpha = string(b[1,1], "%9.3f")

sum alpha1 if alpha1 > 0
local mean_pos_alpha = string(r(mean), "%9.3f")
sum alpha1 if alpha1 < 0
local mean_neg_alpha = string(r(mean), "%9.3f")

local share_pos_alpha = string(abs(`sum_pos_alpha')/(abs(`sum_pos_alpha') + abs(`sum_neg_alpha')), "%9.3f")
local share_neg_alpha = string(abs(`sum_neg_alpha')/(abs(`sum_pos_alpha') + abs(`sum_neg_alpha')), "%9.3f")

* Panel B: Correlations of Industry Aggregates
gen F = .
gen agg_pi = .
gen agg_gamma = .
levelsof ind, local(industries)
foreach ind in `industries' {
	capture replace F = `F_`ind'' if ind == "`ind'"
	capture replace agg_pi = `pi_`ind'' if ind == "`ind'"
	capture replace agg_gamma = `gamma_`ind'' if ind == "`ind'"		
	}
corr alpha1 agg_g agg_beta F agg_indshare_sd
mat corr = r(C)
forvalues i =1/5 {
	forvalues j = `i'/5 {
		local c_`i'_`j' = string(corr[`i',`j'], "%9.3f")
		}
	}

* Panel  C: Top 5 Rotemberg Weight Industries
foreach ind in aus_hung italy russia gr_pt_es sweden {
	qui sum alpha1 if ind == "`ind'"
   local alpha_`ind' = string(r(mean), "%9.3f")
	qui sum agg_g if ind == "`ind'"
	local g_`ind' = string(r(mean), "%9.3f")
	qui sum agg_beta if ind == "`ind'"	 
	local beta_`ind' = string(r(mean), "%9.3f") 
	qui sum agg_indshare if ind == "`ind'"	
	local share_`ind' = string(r(mean)*100, "%9.3f")
	tempvar temp
	qui gen `temp' = ind == "`ind'"
	gsort -`temp'
	local ind_name_`ind' = ind_name[1]
	drop `temp'
	}

*------------------------------------------------------------------------------*
* Overidentification and first-stage heterogeneity figure
* Paper: Heterogeneity by Rotemberg Weights (Figure G.1); output rotemberg_weights.pdf
*------------------------------------------------------------------------------*
gen omega = alpha1*agg_beta
total omega
mat b = e(b)
local b = b[1,1]

gen label_var = ind 
gen beta_lab = string(agg_beta, "%9.3f")

gen abs_alpha = abs(alpha1) 
gen positive_weight = alpha1 > 0
gen agg_beta_pos = agg_beta if positive_weight == 1
gen agg_beta_neg = agg_beta if positive_weight == 0
twoway (scatter agg_beta_pos agg_beta_neg F if F >= 5 [aweight=abs_alpha ], msymbol(Oh Dh)), legend(label(1 "Positive Weights") label(2 "Negative Weights") size(small) region(lstyle(none))) yline(`b', lcolor(black) lpattern(dash)) xtitle("First stage F-statistic", size(small))  ytitle("{&beta}{subscript:j} estimate", size(small)) graphregion(color(white) margin(medsmall)) plotregion(color(white) margin(medsmall)) name(rotemberg_weights_overid, replace) title("Panel A: Heterogeneity of {&beta}{subscript:j} estimate", size(medium)) ylabel(, labsize(small) nogrid) xlabel(, labsize(small))

gsort -alpha1
twoway (scatter F alpha1 if _n <= 5, mcolor(dblue) mlabel(ind_name) mlabposition(12) msize(0.5) mlabsize(2) ) (scatter F alpha1 if _n > 5, mcolor(dblue) msize(0.5) ), xtitle("Rotemberg weight", size(small)) ytitle("First stage F-statistic", size(small)) yline(10, lcolor(black) lpattern(dash)) legend(off) graphregion(color(white) margin(medsmall)) plotregion(color(white) margin(medsmall)) name(F_vs_rotemberg_weights, replace) title("Panel B: Heterogeneity of First Stage", size(medium)) ylabel(, labsize(small) nogrid) xlabel(, labsize(small))

graph combine rotemberg_weights_overid F_vs_rotemberg_weights, ///
	  graphregion(color(white) margin(medsmall)) plotregion(color(white) margin(medsmall)) xsize(12) ysize(6) 
graph export "$figures/rotemberg_weights.pdf", replace

* Panel D: Weighted Betas by alpha weights

gen agg_beta_weight = agg_beta * alpha1
collapse (sum) agg_beta_weight alpha1 (mean)  agg_beta, by(positive_weight)
egen total_agg_beta = total(agg_beta_weight)
gen share = agg_beta_weight / total_agg_beta
gsort -positive_weight
local agg_beta_pos = string(agg_beta_weight[1], "%9.3f")
local agg_beta_neg = string(agg_beta_weight[2], "%9.3f")
local agg_beta_pos2 = string(agg_beta[1], "%9.3f")
local agg_beta_neg2 = string(agg_beta[2], "%9.3f")
local agg_beta_pos_share = string(share[1], "%9.3f")
local agg_beta_neg_share = string(share[2], "%9.3f")

* Write final table
* Panel A
file write fh "\multicolumn{3}{l}{\textbf{Panel A: Negative and positive weights}}\\" _n
file write fh  " & Sum & Mean & Share \\  \cmidrule(lr){2-4}" _n
file write fh  "Negative & `sum_neg_alpha' & `mean_neg_alpha' & `share_neg_alpha' \\" _n
file write fh  "Positive & `sum_pos_alpha' & `mean_pos_alpha' & `share_pos_alpha' \\" _n

* Panel B
file write fh "\multicolumn{5}{l}{\textbf{Panel B: Correlations} }\\" _n
file write fh  " &$\alpha_k$ & \$g_{k}$ & $\beta_k$ & \$F_{k}$ & Var(\$z_k$) \\" _n
file write fh  "\cmidrule(lr){2-6} " _n
file write fh " & \\" _n
file write fh " $\alpha_k$             & 1\\" _n
file write fh " \$g_{k}$                &   `c_1_2'  & 1\\" _n
file write fh " $\beta_{k}$             &   `c_1_3'  & `c_2_3'    &1\\" _n
file write fh " \$F_{k}$                &   `c_1_4'  & `c_2_4'    &  `c_3_4'  & 1\\" _n
file write fh " Var(\$z_{k}$)           &   `c_1_5'  & `c_2_5'    &  `c_3_5'  &  `c_4_5'   &1\\" _n

* Panel C
file write fh "\multicolumn{5}{l}{\textbf{Panel C: Top 5 Rotemberg weight countries of origin}}\\" _n
file write fh  " & $\hat{\alpha}_{k}$ & \$g_{k}$ & $\hat{\beta}_{k}$ & 95 \% CI & \\ \cmidrule(lr){2-6}" _n
foreach ind in aus_hung italy russia gr_pt_es sweden {
	if `ci_min_`ind'' != -10 & `ci_max_`ind'' != 10 {
		file write fh  "`ind_name_`ind'' & `alpha_`ind'' & `g_`ind'' & `beta_`ind'' & (`ci_min_`ind'',`ci_max_`ind'')  &  \\ " _n
		}
	else  {
		file write fh  "`ind_name_`ind'' & `alpha_`ind'' & `g_`ind'' & `beta_`ind'' & \multicolumn{1}{c}{N/A}  &   \\ " _n
		}
	}
file write fh "\multicolumn{5}{l}{\textbf{Panel D: Estimates of $\beta_{k}$ for positive and negative weights}}\\" _n
file write fh  " & $\alpha$-weighted Sum & Share of overall $\beta$ & Mean  \\ \cmidrule(lr){2-3}" _n
file write fh  " Negative & `agg_beta_neg' & `agg_beta_neg_share' &`agg_beta_neg2' \\" _n
file write fh  " Positive & `agg_beta_pos' & `agg_beta_pos_share' & `agg_beta_pos2' \\" _n
file write fh  "\bottomrule" _n
file close fh


* Remove outreg2 .txt/.tmp byproducts left in the tables folder.
foreach pat in "*.txt" "*.tmp" {
    local junk : dir "$tables" files "`pat'"
    foreach f of local junk {
        cap erase "$tables/`f'"
    }
}
