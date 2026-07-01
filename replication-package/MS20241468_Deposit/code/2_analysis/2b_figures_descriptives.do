*==============================================================================*
* 2b_figures_descriptives.do
*
* Descriptive figures for the paper: the composition of the US foreign-born
* population by region of origin, 1850-1920; and a two-panel trend combining
* union membership (Freeman 1998) with the annual inflow of immigrants
* (Migration Policy Institute), 1850-1920.
*
* INPUTS:
*   $intmdata/ustotals_byorigin_1850-1920.dta   - US foreign-born totals by origin
*   $data/uniondensity_freeman1998.dta          - union membership series (1a)
*   $data/flows_imm_1820-2021.dta               - annual immigrant inflows (1a)
*
* OUTPUTS:
*   $figures/immigrmix_1850-1920.pdf
*   $figures/trends_unions_immigrants.pdf
*       (built from intermediate panels freeman_membership_1880-1920.gph and
*        yearly_immflows_1850-1920.gph)
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


*------------------------------------------------------------------------------*
* Composition of the foreign-born population by origin, 1850-1920
* Paper: Origin Regions within the Foreign Born Population, 1850-1920 (Figure A.1); output immigrmix_1850-1920.pdf
*------------------------------------------------------------------------------*
use "$intmdata/ustotals_byorigin_1850-1920.dta", clear

foreach var in northwest_europe southeast_europe canada_australia other {
gen `var'_sh = `var' / foreignborn
}

gen _northwest_europe_sh = northwest_europe_sh
gen _southeast_europe_sh = _northwest_europe_sh + southeast_europe_sh
gen _canada_australia_sh = _southeast_europe_sh + canada_australia_sh
gen _other_sh			 = _canada_australia_sh + other_sh

sort year
twoway (area _other_sh _canada_australia_sh _southeast_europe_sh _northwest_europe_sh year, color(black*0.45 navy*0 navy*1.4 navy*0.15) lcolor(navy navy navy navy navy) lwidth(thin thin thin thin)), ///
	   xlabel(1850(10)1920, labsize(small) angle(0) glcolor(gs16)) xtitle("") ///	   
	   ylabel(0(0.1)1, labsize(small) angle(0)) ///
	   ytitle(Percentage of the Foreign-Born Population, size(small) margin(medium)) ///
	   graphregion(color(white)) plotregion(color(white) margin(zero)) ///
	   legend(order(4 "N/W Europe" 3 "S/E Europe" 2 "Canada + Australia" 1 "Other Countries") size(vsmall) rows(1) region(lstyle(none)) bmargin(medium)) ///
	   name(, replace) title(, size(small))

graph export "$figures/immigrmix_1850-1920.pdf", replace	   

*------------------------------------------------------------------------------*
* Union membership (Freeman 1998) and immigrant inflows (MPI), 1850-1920
* Paper: Trends in Union Membership and Immigration (Figure 1); output trends_unions_immigrants.pdf
*------------------------------------------------------------------------------*
preserve
use "$data/uniondensity_freeman1998.dta", clear
keep if inrange(year,1880,1920)
twoway (connect membership year, msize(small) lcolor("navy*0.9") mcolor("navy*0.9") ///
	   lcolor("navy*0.9") mcolor("navy*0.9") msymbol(S) msize(small) lwidth(medthick)), ///
	   xtitle("", size(small)) ///
	   xlabel(1880(10)1920, labsize(small) angle(0) glcolor(gs16)) ///	   
	   ytitle(Union Membership (thousands), size(small)) ///
	   ylabel(, labsize(small) angle(0) glcolor(gs16)) ///
	   graphregion(color(white)) plotregion(color(white)) ///
	   legend(order() ///
	   size(vsmall) keygap(.8) symysize(.6) rows(1)) ///
	   name(union_membership_freeman, replace) title("Panel A: Union Members", size(medsmall))
graph save "$figures/freeman_membership_1880-1920", replace	   
restore

use "$data/flows_imm_1820-2021.dta", clear
keep if inrange(year,1850,1920)
replace flow = flow / 1000
twoway (connect flow year, msize(small) lcolor("navy*0.9") mcolor("navy*0.9") ///
	   lcolor("navy*0.9") mcolor("navy*0.9") msymbol(S) msize(small) lwidth(medthick)), ///
	   xtitle("", size(small)) ///
	   xlabel(1850(10)1920, labsize(small) angle(0) glcolor(gs16)) ///	   
	   ytitle(Number of Immigrants (thousands), size(small)) ///
	   ylabel(, labsize(small) angle(0) glcolor(gs16)) ///
	   graphregion(color(white)) plotregion(color(white)) ///
	   legend(order() ///
	   size(vsmall) keygap(.8) symysize(.6) rows(1)) ///
	   name(union_membership_freeman, replace) title("Panel B: Inflow of Immigrants", size(medsmall))
graph save "$figures/yearly_immflows_1850-1920", replace   

graph combine "$figures/freeman_membership_1880-1920" "$figures/yearly_immflows_1850-1920", ///
			  graphregion(color(white)) plotregion(color(white) margin(zero)) xsize(12) ysize(6)
graph export "$figures/trends_unions_immigrants.pdf", replace

* The two panels above are intermediate .gph files used only for the combine;
* remove them so only the final figure remains in $figures.
erase "$figures/freeman_membership_1880-1920.gph"
erase "$figures/yearly_immflows_1850-1920.gph"
