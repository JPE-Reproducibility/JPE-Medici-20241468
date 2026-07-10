*==============================================================================*
* 2a_sumstats.do
*
* Summary statistics and descriptive exhibits for the union analysis: county
* maps of AFL combined union density over the balanced panel; the sample
* summary-statistics table; correlates of the 1890 European-immigrant share;
* the long-difference relationship between immigrant inflows and union strength;
* scatter correlations between the state-federation and national-
* union membership and branch counts; the correlation of the 1920 county
* union-density measure with the Farber et al. (2021) 1937-1941 series; and the
* leading occupations of European immigrants and US-born workers, 1900-1920.
*
* INPUTS:
*   $data/analysis_dataset_county1930.dta              - analysis dataset (1h)
*   $code/2_analysis/2_sample_specifications.do       - sample definition
*   $intmdata/US_county_1930_WGS84_dbase.dta          - county shapefile attributes (1a)
*   $intmdata/US_county_1930_WGS84_coord.dta          - county polygon coordinates (1a)
*   $intmdata/US_county_1930_WGS84_dbase_spmap.dta    - spmap identifier key (1a)
*   $data/county_panel_1880-1920_county1930.dta   - county panel with occupation cells (1d)
*   $intmdata/xwalk_occ1950_occnames.dta              - OCC1950 occupation labels (1a)
*   $rawdata/Farber_et_al_2021/unionshares.dta - Farber et al. (2021) (included; see README 2.5)
*
* OUTPUTS:
*   $figures/map_uniondens_1900-20.pdf  (three-panel 1900/1910/1920 map, combined)
*   $figures/datasources_memb_correlation.pdf, datasources_locals_correlation.pdf
*   $figures/corr_farberetal_mydata_balanced.pdf
*   $figures/occs_nat_euroimm_1900-1920.pdf
*   $tables/sumstats.xml, corr_euroimm1890.xml, immflow_unionstrength.xml
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
* Maps of union density
* Paper: Geographic Distribution of Union Density, 1900-1920 (Figure 2); output map_uniondens_1900-20.pdf
*------------------------------------------------------------------------------*
***Identify counties in balanced panel (main sample)****
use "$data/analysis_dataset_county1930.dta", clear
do "$code/2_analysis/2_sample_specifications.do"

keep if insample_balanced == 1
keep gisjoin_1930
duplicates drop
rename gisjoin_1930 GISJOIN
merge 1:1 GISJOIN using "$intmdata/US_county_1930_WGS84_dbase", keepusing(_ID)
keep if _merge == 3
drop _merge
tempfile balancedpanel_id 
save `balancedpanel_id', replace

use "$intmdata/US_county_1930_WGS84_coord", clear
gen order = _n
merge m:1 _ID using `balancedpanel_id'
keep if _merge == 3
drop _merge
sort order
keep _*
save "$intmdata/US_county_balancedpanel_1930_WGS84_coord", replace
***


***Plot maps
use "$data/analysis_dataset_county1930.dta", clear
do "$code/2_analysis/2_sample_specifications.do"
 
keep insample insample_balanced countynhg gisjoin afl_comb_all_dens afl_comb_all_locals year statefip ///
	 urban_share_mw_1890 lfpartrate_m_1880 sh_euro_mw_1890
rename gisjoin GISJOIN

merge m:1 GISJOIN using "$intmdata/US_county_1930_WGS84_dbase_spmap"
drop if inlist(ICPSRST,"81","82") == 1
drop _merge

foreach outcome in dens {

if "`outcome'" == "dens" {
local title = "Union Density = Union Members / Labor Force"
}


*All counties

preserve

**Generate deciles
forvalues i=10(10)90 {
egen p`i' = pctile(afl_comb_all_`outcome') if year == 1920 & afl_comb_all_`outcome' != ., p(`i')
sum p`i'
local p`i' = r(mean)
}
sum afl_comb_all_`outcome' if year == 1920
local max = `r(max)'
local clbreaks = "0"
foreach j in `p10' `p20' `p30' `p40' `p50' `p60' `p70' `p80' `p90' `max' {
if `j' > 0 {
local clbreaks "`clbreaks'" " " "`j'"
}	
}

format afl_comb_all_dens %12.2f
format afl_comb_all_locals %12.0f

**Plot maps
foreach year in 1900 1910 {
	
spmap afl_comb_all_`outcome' using "$intmdata/US_county_1930_WGS84_coord" if year == `year', ///
						   id(_ID) fcolor(Blues2) ndocolor(black*0.35) ndsize(vthin) ndlabel("No data") ndpattern(solid) ///
						   ocolor(black*0.35) osize(vthin) opattern(solid) ///
						   clmethod(custom) clbreaks("`clbreaks'") ///
						   graphregion(color(white) margin(zero)) plotregion(color(white) margin(zero)) ///
						   legtitle(`title') legend(off) title(`year', size(small)) name (union`outcome'_`year', replace) ///
						   polygon(data("$intmdata/US_county_balancedpanel_1930_WGS84_coord.dta") fcolor(none) ocolor(black) osize(medium) op(solid)) 
			   
}

foreach year in 1920 {
	
spmap afl_comb_all_`outcome' using "$intmdata/US_county_1930_WGS84_coord" if year == `year', ///
						   id(_ID) fcolor(Blues2) ndocolor(black*0.35) ndsize(vthin) ndlabel("No data") ndpattern(solid) ///
						   ocolor(black*0.35) osize(vthin) opattern(solid) ///
						   clmethod(custom) clbreaks("`clbreaks'") ///
						   graphregion(color(white) margin(zero)) plotregion(color(white) margin(zero)) ///
						   legtitle(`title') title(`year', size(small)) name (union`outcome'_`year', replace) ///
						   polygon(data("$intmdata/US_county_balancedpanel_1930_WGS84_coord.dta") fcolor(none) ocolor(black) osize(medium) op(solid)) 
					   
}

graph combine uniondens_1900 union`outcome'_1910 union`outcome'_1920, imargin(medlarge) ///
			  graphregion(color(white) margin(zero)) plotregion(color(white) margin(zero)) rows(3) altshrink
												   
graph export "$figures/map_union`outcome'_1900-20.pdf", replace   // vector PDF

restore

}


*------------------------------------------------------------------------------*
* Summary statistics
* Paper: Summary Statistics (Table 1); output sumstats
*------------------------------------------------------------------------------*
use "$data/analysis_dataset_county1930.dta", clear

do "$code/2_analysis/2_sample_specifications.do"

gen share_lf_nat = nat_lf_tot_m / all_lf_tot_m
gen share_lf_euro_imm = euro_imm_lf_tot_m / all_lf_tot_m
gen popdens_mw_1890 = all_totpop_mw_1890 / area_1930

global sumstats_timevar		afl_comb_all_pres afl_comb_all_locals afl_comb_all_dens afl_comb_all_avgmemb ///
							all_totpop_mw urban_share_mw imm_share_mw euro_imm_share_mw sh_euro_10yr_mw ///
							all_lf_tot_m lfpartrate_m share_lf_nat share_lf_euro_imm
							
global sumstats_1890		euro_imm_share_mw_1890 farmfams_share_1890 mfglabor_share_mw_1890 mining_1890
							

foreach fmt in txt xml {
cap erase "$tables/sumstats.`fmt'"
}

preserve 
keep if insample_balanced == 1 & year == 1900
keep $sumstats_1890						

outreg2 using "$tables/sumstats", append sortvar($sumstats_1890) label sum(log) dec(2) eqkeep(N mean sd) excel

restore
							
preserve 
keep if insample_balanced == 1 & inrange(year,1900,1920)
keep $sumstats_timevar						

outreg2 using "$tables/sumstats", append sortvar($sumstats_timevar) label sum(log) dec(2) eqkeep(N mean sd) excel

restore	

foreach fmt in txt {
cap erase "$tables/sumstats.`fmt'" 
}


*------------------------------------------------------------------------------*
* Correlates of the 1890 European-immigrant share
* Paper: Correlation Between Immigration and County Characteristics in 1890 (Table A.2); output corr_euroimm1890
*------------------------------------------------------------------------------*

use "$data/analysis_dataset_county1930.dta", clear
do "$code/2_analysis/2_sample_specifications.do"

label var euro_imm_share_mw_1890 "Share of European Immigrant Population"							 							 
label var urban_share_mw_1890 "Share of Urban Population"							 
label var lfpartrate_m_1880 "LF Participation Rate"	


local correlates = "mfglabor_share_mw_1890 farmfams_share_1890 mining_1890"
local filename = "corr_euroimm1890"
	
foreach fmt in txt xml {	
cap erase "$tables/`filename'.`fmt'"		
}

xtset countynhg_1930 year
gen delta_uniondens = f20.afl_comb_all_dens - afl_comb_all_dens
gen delta_unionpres = f20.afl_comb_all_pres - afl_comb_all_pres	
gen delta_unionlocals = f20.afl_comb_all_ihsloc - afl_comb_all_ihsloc	

reghdfe euro_imm_share_mw_1890 `correlates' if year == 1900 & insample_balanced == 1, noabsorb cluster(countynhg)

outreg2 using "$tables/`filename'", append dec(3) label nor2 nocons stats(coef se) paren(se) ///
									///
									excel nonotes	
									
foreach fmt in txt {	
cap erase "$tables/`filename'.`fmt'"		
}	



*------------------------------------------------------------------------------*
* Immigrant flows and union strength
* Paper: Unionization and Immigration Flows (Table A.3); output immflow_unionstrength
*------------------------------------------------------------------------------*

use "$data/analysis_dataset_county1930.dta", clear
do "$code/2_analysis/2_sample_specifications.do"
preserve

local n = 4

foreach fmt in txt xml {	
cap erase "$tables/immflow_unionstrength.`fmt'"		
}

local var = "sh_euro_wa_10yr_m"
local filename = "immflow_unionstrength"

replace `var' = `var' * 100

xtset countynhg year

foreach indepvar in afl_comb_all_pres afl_comb_all_ihsloc afl_comb_all_dens afl_comb_all_avgmemb {
	
reghdfe f10.`var' `indepvar' if insample_balanced == 1, a("${idfe} ${tfe} ${controls`n'}") cluster("${idfe}")

qui sum `var' if e(sample) == 1
local depvarmean = string(r(mean),"%6.3fc")
qui sum `indepvar' if e(sample) == 1
if "`indepvar'" == "afl_comb_all_ihsloc" {
qui sum afl_comb_all_locals if e(sample) == 1
}
local `indepvar'mean = string(r(mean),"%6.3fc")
local `indepvar'stdev = string(r(sd),"%6.3fc")

outreg2 using "$tables/`filename'", append dec(3) label nor2 nocons stats(coef se) paren(se) ///
									addtext(Outcome mean, "`depvarmean'", Unionization mean, "``indepvar'mean'", ///
									"${fetext}, ${controlstext`n'}") ///
									excel nonotes	
																	
}

foreach fmt in txt {	
cap erase "$tables/`filename'.`fmt'"		
}

restore


*------------------------------------------------------------------------------*
* Correlation between AFL state-convention and national-union proceedings data
* Paper: Correlation Between Measures Across Data Sources (Figure A.4);
*        outputs datasources_memb_correlation.pdf, datasources_locals_correlation.pdf
*------------------------------------------------------------------------------*

use "$data/analysis_dataset_county1930.dta", clear
gen insample = (inlist(year,1900,1910,1920) == 1 & afl_comb_all_dens != . & lfpartrate_m_1880 != . & pr1890_sh_euro_wa_10yr_m != .)

rename itu_memb itu_memb_proxy_votes


foreach union in bmpiu iam itu ubc umwa {
	
if "`union'" == "bmpiu" {
local unionname = "Bricklayers, Masons, and Plasterers (BMPIU)"
}
if "`union'" == "iam" {
local unionname = "Machinists (IAM)"
}	
if "`union'" == "ibt" {
local unionname = "Teamsters (IBT)"
}
if "`union'" == "itu" {
local unionname = "Typographers (ITU)"
}	
if "`union'" == "ubc" {
local unionname = "Carpenters and Joiners (UBC)"
}	
if "`union'" == "umwa" {
local unionname = "Mine Workers (UMWA)"
}	
		
			
binscatter `union'_memb_proxy_votes afl_memb_`union' if insample == 1, n(500) reportreg ///
		mcolor("navy*0.9") lcolor("navy*0.9") ///
		ytitle("# members using national unions' proceedings", size(vsmall)) ///
		xlabel(, labsize(vsmall) glcolor(gs16)) ///	 
		xtitle("# members using state federations' proceedings", size(vsmall)) ///
		ylabel(, labsize(vsmall) angle(0) glcolor(gs16)) ///
		graphregion(color(white) margin(medsmall)) plotregion(color(white) margin(medsmall)) ///
		legend(off) ///
		name(`union'_memb_corr, replace) title("`unionname'", size(small))			
		
binscatter `union'_locals_votes afl_locals_`union' if insample == 1, n(500) reportreg ///
		mcolor("navy*0.9") lcolor("navy*0.9") ///
		ytitle("# branches  using national unions' proceedings", size(vsmall)) ///
		xlabel(, labsize(vsmall) glcolor(gs16)) ///	 
		xtitle("# branches using state federations' proceedings", size(vsmall)) ///
		ylabel(, labsize(vsmall) angle(0) glcolor(gs16)) ///
		graphregion(color(white) margin(medsmall)) plotregion(color(white) margin(medsmall)) ///
		legend(off) ///
		name(`union'_locals_corr, replace) title("`unionname'", size(small))	
		
}

graph combine bmpiu_memb_corr iam_memb_corr itu_memb_corr ubc_memb_corr umwa_memb_corr, ///
	  graphregion(color(white) margin(medsmall)) plotregion(color(white) margin(medsmall)) title("Panel A: Number of Union Members", size(vsmall))

graph export "$figures/datasources_memb_correlation.pdf", replace


graph combine bmpiu_locals_corr iam_locals_corr itu_locals_corr ubc_locals_corr umwa_locals_corr, ///
	  graphregion(color(white) margin(medsmall)) plotregion(color(white) margin(medsmall)) title("Panel B: Number of Union Branches", size(vsmall))

graph export "$figures/datasources_locals_correlation.pdf", replace




*------------------------------------------------------------------------------*
* Correlation with the Farber et al. (2021) union-density series
* Paper: Correlation Between Data of This Paper and State-Level Gallup Data (Figure H.1);
*        output corr_farberetal_mydata_balanced.pdf
*------------------------------------------------------------------------------*

use "$rawdata/Farber_et_al_2021/unionshares.dta", clear
keep if inrange(year,1937,1941)
keep year dataset state ushare_state
collapse (mean) ushare_state, by(state)
rename state statefip
duplicates drop

tempfile gallup_uniondens_1937 
save `gallup_uniondens_1937', replace

use "$data/analysis_dataset_county1930.dta", clear
do "$code/2_analysis/2_sample_specifications.do"

foreach sample in insample_balanced {

local filename = "farberetal_mydata_balanced"

preserve

keep if inrange(year,1920,1920) & `sample' == 1

collapse (sum) afl_memb_all afl_memb_noumwa afl_comb_memb_all all_lf_*_m, by(statefip statecode statenam region)
drop if afl_memb_all == 0

gen afl_comb_all_share = afl_comb_memb_all /  (all_lf_highskill2_m + all_lf_midskill2_m + all_lf_lowskill_m)


merge 1:1 statefip using `gallup_uniondens_1937'
drop if _merge == 2

reg ushare_state afl_comb_all_share
corr ushare_state afl_comb_all_share
twoway (scatter ushare_state afl_comb_all_share, mlabel(statecode) mlabsize(vsmall) mcolor("navy*0.9") msize(small)) ///
	   (lfit ushare_state afl_comb_all_share, lcolor("navy*0.9") lwidth(medthin)), ///
		ytitle("Union Density 1937-1941 (Farber et al., 2021)", size(small)) ///
		xlabel(, labsize(small) glcolor(gs16)) ///	 
		xtitle("Union Density 1920", size(small)) ///
		ylabel(, labsize(small) angle(0) glcolor(gs16)) ///
		graphregion(color(white) margin(medium)) plotregion(color(white) margin(medsmall)) ///
		legend(off) ///
		name(`filename'_all, replace) title("Panel A", size(small))	

drop if statecode == "WY"
reg ushare_state afl_comb_all_share
corr ushare_state afl_comb_all_share
twoway (scatter ushare_state afl_comb_all_share, mlabel(statecode) mlabsize(vsmall) mcolor("navy*0.9") msize(small)) ///
	   (lfit ushare_state afl_comb_all_share, lcolor("navy*0.9") lwidth(medthin)), ///
		ytitle("Union Density 1937-1941 (Farber et al., 2021)", size(small)) ///
		xlabel(, labsize(small) glcolor(gs16)) ///	 
		xtitle("Union Density 1920", size(small)) ///
		ylabel(, labsize(small) angle(0) glcolor(gs16)) ///
		graphregion(color(white) margin(medium)) plotregion(color(white) margin(medsmall)) ///
		legend(off) ///
		name(`filename'_noWY, replace) title("Panel B", size(small))	
		
graph combine `filename'_all `filename'_noWY, graphregion(color(white) margin(zero)) ///
											  plotregion(color(white) margin(zero)) ///
											  xsize(12) ysize(6)
graph export "$figures/corr_`filename'.pdf", replace	 

restore

}
		
	

*------------------------------------------------------------------------------*
* Main occupations of European immigrants
* Paper: Most Common Occupations Among Immigrant and U.S.-Born Workers (Figure 5); output occs_nat_euroimm_1900-1920.pdf
*------------------------------------------------------------------------------*

use "$data/analysis_dataset_county1930.dta", clear
do "$code/2_analysis/2_sample_specifications.do"

merge 1:1 countynhg_1930 year using "$data/county_panel_1880-1920_county1930.dta", keepusing(*_occ*)
drop if _merge == 2

keep year *_occ* *_lf_*
keep if inrange(year,1900,1920) == 1
								  
egen euro_imm_lf_10yr_tot_m = rowtotal(denmark_lf_10yr_m finland_lf_10yr_m norway_lf_10yr_m sweden_lf_10yr_m ///
								  uk_lf_10yr_m ireland_lf_10yr_m oth_northeu_lf_10yr_m ///
								  belgium_lf_10yr_m france_lf_10yr_m luxemb_lf_10yr_m ///
								  nether_lf_10yr_m switz_lf_10yr_m oth_westeu_lf_10yr_m ///
								  italy_lf_10yr_m gr_pt_es_lf_10yr_m oth_southeu_lf_10yr_m ///
								  aus_hung_lf_10yr_m czech_lf_10yr_m germany_lf_10yr_m ///
								  poland_lf_10yr_m oth_easteu_lf_10yr_m oth_centereu_lf_10yr_m ///
								  russia_lf_10yr_m oth_russeu_lf_10yr_m)

foreach o in 0 1 2 3 4 5 6 7 8 9 10 12 13 14 15 16 17 18 19 23 24 25 26 27 28 29 ///
			 31 32 33 34 35 36 41 42 43 44 45 46 47 48 49 51 52 53 54 55 56 57 58 59 ///
			 61 62 63 67 68 69 70 71 72 73 74 75 76 77 78 79 81 82 83 84 91 92 93 94 95 96 97 98 99 ///
			 100 123 200 201 203 204 205 210 230 240 250 260 270 280 290 300 301 302 304 305 310 320 ///
			 321 322 325 335 340 341 342 350 360 365 370 380 390 400 410 420 430 450 460 470 480 490 ///
			 500 501 502 503 504 505 510 511 512 513 514 515 520 521 522 523 524 525 530 531 532 533 534 535 ///
			 540 541 542 543 544 545 550 551 552 553 554 555 560 561 562 563 564 565 570 571 572 573 574 575 ///
			 580 581 582 583 584 585 590 591 592 593 594 595 600 601 602 603 604 605 610 611 612 613 614 615 ///
			 620 621 622 623 624 625 630 631 632 633 634 635 640 641 642 643 644 645 650 660 661 662 ///
			 670 671 672 673 674 675 680 681 682 683 684 685 690 700 710 720 730 731 732 740 750 751 752 753 754 ///
			 760 761 762 763 764 770 771 772 773 780 781 782 783 784 785 790 810 820 830 840 910 920 930 940 950 960 970 {	
egen euro_imm_occ`o'_10yr_m = rowtotal(denmark_occ`o'_10yr_m finland_occ`o'_10yr_m norway_occ`o'_10yr_m sweden_occ`o'_10yr_m ///
								  uk_occ`o'_10yr_m ireland_occ`o'_10yr_m oth_northeu_occ`o'_10yr_m ///
								  belgium_occ`o'_10yr_m france_occ`o'_10yr_m luxemb_occ`o'_10yr_m ///
								  nether_occ`o'_10yr_m switz_occ`o'_10yr_m oth_westeu_occ`o'_10yr_m ///
								  italy_occ`o'_10yr_m gr_pt_es_occ`o'_10yr_m oth_southeu_occ`o'_10yr_m ///
								  aus_hung_occ`o'_10yr_m czech_occ`o'_10yr_m germany_occ`o'_10yr_m ///
								  poland_occ`o'_10yr_m oth_easteu_occ`o'_10yr_m oth_centereu_occ`o'_10yr_m ///
								  russia_occ`o'_10yr_m oth_russeu_occ`o'_10yr_m)
}

keep year euro_imm_lf_10yr_tot_m euro_imm_occ*_10yr_m nat_occ*_m nat_lf_tot_m
collapse (sum) euro_imm_occ*_10yr_m euro_imm_lf_10yr_tot_m nat_occ*_m nat_lf_tot_m, by(year)
cap drop *occsc*

foreach var of varlist euro_imm_occ*_10yr_m {
gen share_`var' = `var' / euro_imm_lf_10yr_tot_m
drop `var'
}
foreach var of varlist nat_occ*_m {
gen share_`var' = `var' / nat_lf_tot_m
drop `var'
}

keep year share_*
rename *occ*_10yr_m *10yr_occ*
rename *occ*_m *tot_occ*
cap drop share_nat_10yr_*

reshape long share_euro_imm_10yr share_nat_tot, i(year) j(occ) string

rename occ occ1950
replace occ1950 = subinstr(occ,"_occ","",.)
destring occ1950, replace
merge m:1 occ1950 using "$intmdata/xwalk_occ1950_occnames.dta"
drop if _merge == 2
drop _merge
order occname, after(occ1950)

keep share_euro_imm_10yr share_nat_tot year occ*
reshape wide share*, i(occ1950 occname) j(year)

egen order_euro_imm_1900 = rank(share_euro_imm_10yr1900), field		 
egen order_euro_imm_1910 = rank(share_euro_imm_10yr1910), field		 
egen order_euro_imm_1920 = rank(share_euro_imm_10yr1920), field		 

egen order_nat_1900 = rank(share_nat_tot1900), field		 
egen order_nat_1910 = rank(share_nat_tot1910), field		 
egen order_nat_1920 = rank(share_nat_tot1920), field		 

egen share_euro_imm_mean = rowmean(share_euro_imm_10yr*)		 
egen order_euro_imm_mean = rank(share_euro_imm_mean) if strpos(occname,"Managers") == 0 & strpos(occname,"Farm laborers") == 0 & strpos(occname,"Farmers") == 0, field		 

egen share_nat_mean = rowmean(share_nat*)		 
egen order_nat_mean = rank(share_nat_mean) if strpos(occname,"Managers") == 0 & strpos(occname,"Farm laborers") == 0 & strpos(occname,"Farmers") == 0, field		 

graph hbar share_euro_imm_10yr1900 share_euro_imm_10yr1910 share_euro_imm_10yr1920 ///
		  if order_euro_imm_mean < 11, ///
		  over(occname, gap(150) label(labsize(small)) sort(order_euro_imm_mean)) ///
		  legend(order(1 "1891-1900" 2 "1901-1910" 3 "1911-1920") size(small) rows(1) region(lstyle(none))) ///
		  bar(1, lcolor(navy*1.4) fcolor(navy*0.9)) bar(2, lcolor(navy*1.4) fcolor(navy*0.4)) bar(3, lcolor(navy*1.4) fcolor(navy*0.05)) ///
		  bargap(5) ylabel(, labsize(vsmall) nogrid) ytitle("Fraction of Workers in Occupation", size(small)) title(Panel A: Immigrant Workers, size(small)) ///
		  graphregion(color(white)) plotregion(color(white)) name(euroimm_main_occ_1900_1920, replace)
		   
		  
graph hbar share_nat_tot1900 share_nat_tot1910 share_nat_tot1920 ///
		  if order_nat_mean < 11, ///
		  over(occname, gap(150) label(labsize(small)) sort(order_euro_imm_mean)) ///
		  legend(order(1 "1900" 2 "1910" 3 "1920") size(small) rows(1) region(lstyle(none))) ///
		  bar(1, lcolor(navy*1.4) fcolor(navy*0.9)) bar(2, lcolor(navy*1.4) fcolor(navy*0.4)) bar(3, lcolor(navy*1.4) fcolor(navy*0.05)) ///
		  bargap(5) ylabel(, labsize(vsmall) nogrid) ytitle("Fraction of Workers in Occupation", size(small)) title(Panel B: U.S.-Born Workers, size(small)) ///
		  graphregion(color(white)) plotregion(color(white)) name(nat_main_occ_1900_1920, replace)
		  
		  
grc1leg2	  euroimm_main_occ_1900_1920 nat_main_occ_1900_1920, ///
			  graphregion(color(white) margin(zero)) plotregion(color(white) margin(zero)) rows(2) ///
			  legendfrom(nat_main_occ_1900_1920) xcommon	
graph export "$figures/occs_nat_euroimm_1900-1920.pdf", replace		  
 
		  
		  





* Remove outreg2 .txt/.tmp byproducts left in the tables folder.
foreach pat in "*.txt" "*.tmp" {
    local junk : dir "$tables" files "`pat'"
    foreach f of local junk {
        cap erase "$tables/`f'"
    }
}
