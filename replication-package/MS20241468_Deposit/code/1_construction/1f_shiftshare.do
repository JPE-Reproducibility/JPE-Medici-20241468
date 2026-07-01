*==============================================================================*
* 1f_shiftshare.do
*
* Builds the county-year shift-share instrument for European immigration.
* Combines each county's 1890 settlement share of a given national-origin
* group with the national-level inflow of that group in subsequent decades
* (main instrument, pr1890_*). A weather-pushed variant (pr_temp_*) uses
* the same 1890 settlement share interacted with temperature shocks at the
* origin country.
*
* INPUTS (in $data/, $intmdata/):
*   county_panel_1880-1920_county1930.dta  - assembled county panel
*   predicted_flows_weather.dta                - origin-country temperature
*                                                push shocks
*
* OUTPUT (in $data/):
*   shiftshare_county1930.dta                  - county-year shift-share
*                                                series (pr1890_*, pr_temp_*)
*
* Run via 00_master.do, or standalone.
*==============================================================================*

clear all
set more off, perm
set maxvar 32767

if "$root" == "" global root "set-this-to-the-replication-package-path"
global data     "$root/data/clean"
global intmdata "$root/data/intermediate"

use if inrange(year,1880,1930) using "$data/county_panel_1880-1920_county1930.dta", clear

drop *_occ*

rename *_wkgagepop_* *_wa_*
rename *_wkgage_* *_wa_*

*Region variable
gen 	region = .
replace region = 11 if inlist(statefip,9,23,25,33,44,50) == 1
replace region = 12 if inlist(statefip,34,36,42) == 1
replace region = 21 if inlist(statefip,17,18,26,39,55) == 1
replace region = 22 if inlist(statefip,19,20,27,29,31,38,46) == 1
replace region = 31 if inlist(statefip,10,11,12,13,24,37,45,51,54) == 1
replace region = 32 if inlist(statefip,1,21,28,47) == 1
replace region = 33 if inlist(statefip,5,22,40,48) == 1
replace region = 41 if inlist(statefip,4,8,16,30,32,35,49,56) == 1
replace region = 42 if inlist(statefip,2,6,15,41,53) == 1
order region, after(statefip)

	
* Variables at baseline year

foreach var of varlist all_totpop_mw all_totpop_m all_totpop_w {
	
	gen `var'_1890_temp = `var' if year == 1890
	bysort countynhg_1930 (year): gegen `var'_1890 = max(`var'_1890_temp)	// population in 1890
	drop `var'_1890_temp
	
}

	
* Variables at baseline year

foreach var of varlist all_wa_m all_wa_w all_wa_mw {
	
	gen `var'_1880_temp = `var' if year == 1880
	bysort countynhg_1930 (year): gegen `var'_1880 = max(`var'_1880_temp)	// LF in 1880
	drop `var'_1880_temp
	
}

* US population and LF
foreach var in all_totpop_mw all_totpop_m all_totpop_w all_wa_m all_wa_w all_wa_mw {
	
	bysort year: 		gegen US_`var' = sum(`var')								// total US by year
	bysort year region: gegen region_`var' = sum(`var')							// total in region by year
	
	gen US_`var'_lvout = US_`var' - `var'										// leave-out by year
	
	xtset countynhg_1930 year
	gen l10_US_`var'_lvout = l10.US_`var'_lvout									

}

*------------------------------------------------------------------------------*
* Migration flows from Europe (SHIFT)
*------------------------------------------------------------------------------*

*Population flows	
foreach s in m w mw {

* All Europe
gegen euro_10yr_`s' = rowtotal(denmark_10yr_`s' norway_10yr_`s' finland_10yr_`s' sweden_10yr_`s' ///
								uk_10yr_`s' ireland_10yr_`s' oth_northeu_10yr_`s' ///
								belgium_10yr_`s' france_10yr_`s' luxemb_10yr_`s' ///
								nether_10yr_`s' switz_10yr_`s' oth_westeu_10yr_`s' ///
								italy_10yr_`s' gr_pt_es_10yr_`s' oth_southeu_10yr_`s' ///
								aus_hung_10yr_`s' czech_10yr_`s' germany_10yr_`s' poland_10yr_`s' ///
								oth_easteu_10yr_`s' oth_centereu_10yr_`s' ///
								russia_10yr_`s' oth_russeu_10yr_`s'), missing
								
* By country
foreach country in denmark norway finland sweden uk ireland oth_northeu ///
				   belgium france luxemb nether switz oth_westeu ///
				   italy gr_pt_es oth_southeu ///
				   aus_hung czech germany poland oth_easteu oth_centereu ///
				   russia oth_russeu {
	
	bysort year: gegen `country'_US_10yr_`s' = sum(`country'_10yr_`s') 
	gen `country'_US_10yr_`s'_lvout  		= `country'_US_10yr_`s' - `country'_10yr_`s' 

}
							
* Non-Protestant countries
gegen nonprot_10yr_`s' 	= rowtotal(ireland_10yr_`s' ///
								       belgium_10yr_`s' france_10yr_`s' luxemb_10yr_`s' oth_westeu_10yr_`s' ///
									   italy_10yr_`s' gr_pt_es_10yr_`s' oth_southeu_10yr_`s' ///
									   aus_hung_10yr_`s' czech_10yr_`s' poland_10yr_`s' oth_easteu_10yr_`s' oth_centereu_10yr_`s' ///
									   russia_10yr_`s' oth_russeu_10yr_`s'), missing

* Protestant countries
gegen prot_10yr_`s' 		= rowtotal(denmark_10yr_`s' norway_10yr_`s' finland_10yr_`s' sweden_10yr_`s' uk_10yr_`s' oth_northeu_10yr_`s' ///
									   nether_10yr_`s' switz_10yr_`s' ///
									   germany_10yr_`s'), missing

* New sending countries
gegen newsend_10yr_`s' 	= rowtotal(italy_10yr_`s' gr_pt_es_10yr_`s' oth_southeu_10yr_`s' ///
									   aus_hung_10yr_`s' czech_10yr_`s' poland_10yr_`s' oth_easteu_10yr_`s' oth_centereu_10yr_`s' ///
									   russia_10yr_`s' oth_russeu_10yr_`s'), missing

* Old sending countries
gegen oldsend_10yr_`s' 	= rowtotal(denmark_10yr_`s' norway_10yr_`s' finland_10yr_`s' sweden_10yr_`s' ///
									   uk_10yr_`s' ireland_10yr_`s' oth_northeu_10yr_`s' ///
									   belgium_10yr_`s' france_10yr_`s' luxemb_10yr_`s' ///
									   nether_10yr_`s' switz_10yr_`s' oth_westeu_10yr_`s' ///
									   germany_10yr_`s'), missing

* Linguistically far countries
gegen lingfar_10yr_`s' 	= rowtotal(denmark_10yr_`s' finland_10yr_`s'  ///
									   gr_pt_es_10yr_`s' ///
									   aus_hung_10yr_`s' czech_10yr_`s' germany_10yr_`s' poland_10yr_`s' ///
									   oth_easteu_10yr_`s' oth_centereu_10yr_`s' ///
									   russia_10yr_`s' oth_russeu_10yr_`s'), missing

* Linguistically close countries
gegen lingclose_10yr_`s' 	= rowtotal(norway_10yr_`s' sweden_10yr_`s' uk_10yr_`s' ireland_10yr_`s' oth_northeu_10yr_`s' ///
									   belgium_10yr_`s' france_10yr_`s' luxemb_10yr_`s' ///
									   nether_10yr_`s' switz_10yr_`s' oth_westeu_10yr_`s' ///
									   italy_10yr_`s' oth_southeu_10yr_`s'), missing
							 
* Countries w/ strong unions in 1870
gegen unionh_10yr_`s' 	= rowtotal(uk_10yr_`s' ireland_10yr_`s'), missing
		   
* Countries w/ weak or no unions in 1870
gegen unionl_10yr_`s' 	= rowtotal(denmark_10yr_`s' ///
									   germany_10yr_`s' belgium_10yr_`s' ///
									   france_10yr_`s' ///
									   aus_hung_10yr_`s' ///
									   norway_10yr_`s' switz_10yr_`s' nether_10yr_`s' ///
									   italy_10yr_`s' ///
									   sweden_10yr_`s' ///
									finland_10yr_`s' oth_northeu_10yr_`s' ///
									luxemb_10yr_`s' oth_westeu_10yr_`s' ///
								    gr_pt_es_10yr_`s' oth_southeu_10yr_`s' ///
								   czech_10yr_`s' poland_10yr_`s' oth_easteu_10yr_`s' oth_centereu_10yr_`s' ///
								   russia_10yr_`s' oth_russeu_10yr_`s'), missing
								
* Actual shares
foreach country in denmark norway finland sweden uk ireland oth_northeu ///
				   belgium france luxemb nether switz oth_westeu ///
				   italy gr_pt_es oth_southeu ///
				   aus_hung czech germany poland oth_easteu oth_centereu ///
				   russia oth_russeu ///
				   euro nonprot prot newsend oldsend lingfar lingclose unionh unionl {

	gen sh_`country'_10yr_`s' 		= `country'_10yr_`s' / all_totpop_`s'

}

}

*Labor force flows
foreach s in m w {

* All Europe
gegen euro_wa_10yr_`s' = rowtotal(denmark_wa_10yr_`s' norway_wa_10yr_`s' finland_wa_10yr_`s' sweden_wa_10yr_`s' ///
								uk_wa_10yr_`s' ireland_wa_10yr_`s' oth_northeu_wa_10yr_`s' ///
								belgium_wa_10yr_`s' france_wa_10yr_`s' luxemb_wa_10yr_`s' ///
								nether_wa_10yr_`s' switz_wa_10yr_`s' oth_westeu_wa_10yr_`s' ///
								italy_wa_10yr_`s' gr_pt_es_wa_10yr_`s' oth_southeu_wa_10yr_`s' ///
								aus_hung_wa_10yr_`s' czech_wa_10yr_`s' germany_wa_10yr_`s' poland_wa_10yr_`s' ///
								oth_easteu_wa_10yr_`s' oth_centereu_wa_10yr_`s' ///
								russia_wa_10yr_`s' oth_russeu_wa_10yr_`s'), missing
								
* By country
foreach country in denmark norway finland sweden uk ireland oth_northeu ///
				   belgium france luxemb nether switz oth_westeu ///
				   italy gr_pt_es oth_southeu ///
				   aus_hung czech germany poland oth_easteu oth_centereu ///
				   russia oth_russeu {
	
	bysort year: gegen `country'_US_wa_10yr_`s' = sum(`country'_wa_10yr_`s') 
	gen `country'_US_wa_10yr_`s'_lvout  		= `country'_US_wa_10yr_`s' - `country'_wa_10yr_`s' 

}
							
* Non-Protestant countries
gegen nonprot_wa_10yr_`s' 	= rowtotal(ireland_wa_10yr_`s' ///
								       belgium_wa_10yr_`s' france_wa_10yr_`s' luxemb_wa_10yr_`s' oth_westeu_wa_10yr_`s' ///
									   italy_wa_10yr_`s' gr_pt_es_wa_10yr_`s' oth_southeu_wa_10yr_`s' ///
									   aus_hung_wa_10yr_`s' czech_wa_10yr_`s' poland_wa_10yr_`s' oth_easteu_wa_10yr_`s' oth_centereu_wa_10yr_`s' ///
									   russia_wa_10yr_`s' oth_russeu_wa_10yr_`s'), missing

* Protestant countries
gegen prot_wa_10yr_`s' 		= rowtotal(denmark_wa_10yr_`s' norway_wa_10yr_`s' finland_wa_10yr_`s' sweden_wa_10yr_`s' uk_wa_10yr_`s' oth_northeu_wa_10yr_`s' ///
									   nether_wa_10yr_`s' switz_wa_10yr_`s' ///
									   germany_wa_10yr_`s'), missing

* New sending countries
gegen newsend_wa_10yr_`s' 	= rowtotal(italy_wa_10yr_`s' gr_pt_es_wa_10yr_`s' oth_southeu_wa_10yr_`s' ///
									   aus_hung_wa_10yr_`s' czech_wa_10yr_`s' poland_wa_10yr_`s' oth_easteu_wa_10yr_`s' oth_centereu_wa_10yr_`s' ///
									   russia_wa_10yr_`s' oth_russeu_wa_10yr_`s'), missing

* Old sending countries
gegen oldsend_wa_10yr_`s' 	= rowtotal(denmark_wa_10yr_`s' norway_wa_10yr_`s' finland_wa_10yr_`s' sweden_wa_10yr_`s' ///
									   uk_wa_10yr_`s' ireland_wa_10yr_`s' oth_northeu_wa_10yr_`s' ///
									   belgium_wa_10yr_`s' france_wa_10yr_`s' luxemb_wa_10yr_`s' ///
									   nether_wa_10yr_`s' switz_wa_10yr_`s' oth_westeu_wa_10yr_`s' ///
									   germany_wa_10yr_`s'), missing

* Linguistically far countries
gegen lingfar_wa_10yr_`s' 	= rowtotal(denmark_wa_10yr_`s' finland_wa_10yr_`s'  ///
									   gr_pt_es_wa_10yr_`s' ///
									   aus_hung_wa_10yr_`s' czech_wa_10yr_`s' germany_wa_10yr_`s' poland_wa_10yr_`s' ///
									   oth_easteu_wa_10yr_`s' oth_centereu_wa_10yr_`s' ///
									   russia_wa_10yr_`s' oth_russeu_wa_10yr_`s'), missing

* Linguistically close countries
gegen lingclose_wa_10yr_`s' 	= rowtotal(norway_wa_10yr_`s' sweden_wa_10yr_`s' uk_wa_10yr_`s' ireland_wa_10yr_`s' oth_northeu_wa_10yr_`s' ///
									   belgium_wa_10yr_`s' france_wa_10yr_`s' luxemb_wa_10yr_`s' ///
									   nether_wa_10yr_`s' switz_wa_10yr_`s' oth_westeu_wa_10yr_`s' ///
									   italy_wa_10yr_`s' oth_southeu_wa_10yr_`s'), missing
							 
* Non-Socialist (soc. parties below 10%, avg. 1890-1919)

gegen nonsoc10_wa_10yr_`s'		= rowtotal(uk_wa_10yr_`s' ireland_wa_10yr_`s' ///
									      oth_northeu_wa_10yr_`s' ///
									   nether_wa_10yr_`s'  oth_westeu_wa_10yr_`s' /// 
									    gr_pt_es_wa_10yr_`s' oth_southeu_wa_10yr_`s' ///
									    czech_wa_10yr_`s' poland_wa_10yr_`s' oth_easteu_wa_10yr_`s' oth_centereu_wa_10yr_`s' ///
									   ), missing
									   
* Socialist (soc. parties above 10%, avg. 1890-1919)
gegen soc10_wa_10yr_`s'				= rowtotal(aus_hung_wa_10yr_`s' belgium_wa_10yr_`s' denmark_wa_10yr_`s' finland_wa_10yr_`s' ///
											   france_wa_10yr_`s' germany_wa_10yr_`s' italy_wa_10yr_`s' luxemb_wa_10yr_`s' ///
											   norway_wa_10yr_`s' sweden_wa_10yr_`s' switz_wa_10yr_`s' ///
											   russia_wa_10yr_`s' oth_russeu_wa_10yr_`s'), missing
											   
* Non-Socialist (soc. parties below 10%, avg. 1890-1919) + Russia

gegen nonsoc10r_wa_10yr_`s'		= rowtotal(uk_wa_10yr_`s' ireland_wa_10yr_`s' ///
									      oth_northeu_wa_10yr_`s' ///
									   nether_wa_10yr_`s'  oth_westeu_wa_10yr_`s' /// 
									    gr_pt_es_wa_10yr_`s' oth_southeu_wa_10yr_`s' ///
									    czech_wa_10yr_`s' poland_wa_10yr_`s' oth_easteu_wa_10yr_`s' oth_centereu_wa_10yr_`s' ///
									   russia_wa_10yr_`s' oth_russeu_wa_10yr_`s'), missing
									   
* Socialist (soc. parties above 10%, avg. 1890-1919) No Russia
gegen soc10r_wa_10yr_`s'				= rowtotal(aus_hung_wa_10yr_`s' belgium_wa_10yr_`s' denmark_wa_10yr_`s' finland_wa_10yr_`s' ///
											   france_wa_10yr_`s' germany_wa_10yr_`s' italy_wa_10yr_`s' luxemb_wa_10yr_`s' ///
											   norway_wa_10yr_`s' sweden_wa_10yr_`s' switz_wa_10yr_`s' ///
											   ), missing
											   
* Non-Socialist (soc. parties below 20%, avg. 1890-1919)
gegen nonsoc20_wa_10yr_`s'		= rowtotal(uk_wa_10yr_`s' ireland_wa_10yr_`s' ///
									      oth_northeu_wa_10yr_`s' ///
									   nether_wa_10yr_`s'  oth_westeu_wa_10yr_`s' /// 
									    gr_pt_es_wa_10yr_`s' oth_southeu_wa_10yr_`s' ///
									    czech_wa_10yr_`s' poland_wa_10yr_`s' oth_easteu_wa_10yr_`s' oth_centereu_wa_10yr_`s' ///
									   belgium_wa_10yr_`s' france_wa_10yr_`s' italy_wa_10yr_`s' luxemb_wa_10yr_`s' ///
									   norway_wa_10yr_`s' sweden_wa_10yr_`s' switz_wa_10yr_`s'), missing
											   
* Socialist (soc. parties above 20%, avg. 1890-1919)
gegen soc20_wa_10yr_`s'				= rowtotal(aus_hung_wa_10yr_`s' denmark_wa_10yr_`s' finland_wa_10yr_`s' ///
											    germany_wa_10yr_`s' russia_wa_10yr_`s' oth_russeu_wa_10yr_`s'), missing											   
* Non-Socialist (soc. parties below 20%, avg. 1890-1919) + Russia
gegen nonsoc20r_wa_10yr_`s'		= rowtotal(uk_wa_10yr_`s' ireland_wa_10yr_`s' ///
									      oth_northeu_wa_10yr_`s' ///
									   nether_wa_10yr_`s'  oth_westeu_wa_10yr_`s' /// 
									    gr_pt_es_wa_10yr_`s' oth_southeu_wa_10yr_`s' ///
									    czech_wa_10yr_`s' poland_wa_10yr_`s' oth_easteu_wa_10yr_`s' oth_centereu_wa_10yr_`s' ///
									   belgium_wa_10yr_`s' france_wa_10yr_`s' italy_wa_10yr_`s' luxemb_wa_10yr_`s' ///
									   norway_wa_10yr_`s' sweden_wa_10yr_`s' switz_wa_10yr_`s' ///
									   russia_wa_10yr_`s' oth_russeu_wa_10yr_`s'), missing
											   
* Socialist (soc. parties above 20%, avg. 1890-1919) No Russia
gegen soc20r_wa_10yr_`s'				= rowtotal(aus_hung_wa_10yr_`s' denmark_wa_10yr_`s' finland_wa_10yr_`s' ///
											    germany_wa_10yr_`s' ), missing											   
											   
* Countries w/ unions in 1870
gegen unionh_wa_10yr_`s' 	= rowtotal(uk_wa_10yr_`s' ireland_wa_10yr_`s'), missing
		   
* Countries w/ no unions in 1870
gegen unionl_wa_10yr_`s' 	= rowtotal(denmark_wa_10yr_`s' ///
									   germany_wa_10yr_`s' belgium_wa_10yr_`s' ///
									   france_wa_10yr_`s' ///
									   aus_hung_wa_10yr_`s' ///
									   norway_wa_10yr_`s' switz_wa_10yr_`s' nether_wa_10yr_`s' ///
									   italy_wa_10yr_`s' ///
									   sweden_wa_10yr_`s'  ///
									finland_wa_10yr_`s' oth_northeu_wa_10yr_`s' ///
									luxemb_wa_10yr_`s' oth_westeu_wa_10yr_`s' ///
								    gr_pt_es_wa_10yr_`s' oth_southeu_wa_10yr_`s' ///
								   czech_wa_10yr_`s' poland_wa_10yr_`s' oth_easteu_wa_10yr_`s' oth_centereu_wa_10yr_`s' ///
								   russia_wa_10yr_`s' oth_russeu_wa_10yr_`s'), missing

* Countries w/ unions in 1870
gegen unionh_2_wa_10yr_`s' 	= rowtotal(aus_hung_wa_10yr_`s' denmark_wa_10yr_`s' ///
										   belgium_wa_10yr_`s' france_wa_10yr_`s' ///
										   germany_wa_10yr_`s' italy_wa_10yr_`s' ///
										   norway_wa_10yr_`s' sweden_wa_10yr_`s'  ///
										   uk_wa_10yr_`s' ireland_wa_10yr_`s'), missing
		   
* Countries w/ no unions in 1870
gegen unionl_2_wa_10yr_`s' 	= rowtotal(switz_wa_10yr_`s' nether_wa_10yr_`s' ///
									finland_wa_10yr_`s' oth_northeu_wa_10yr_`s' ///
									luxemb_wa_10yr_`s' oth_westeu_wa_10yr_`s' ///
								    gr_pt_es_wa_10yr_`s' oth_southeu_wa_10yr_`s' ///
								   czech_wa_10yr_`s' poland_wa_10yr_`s' oth_easteu_wa_10yr_`s' oth_centereu_wa_10yr_`s' ///
								   russia_wa_10yr_`s' oth_russeu_wa_10yr_`s'), missing								   
								   
* Actual shares
foreach country in denmark norway finland sweden uk ireland oth_northeu ///
				   belgium france luxemb nether switz oth_westeu ///
				   italy gr_pt_es oth_southeu ///
				   aus_hung czech germany poland oth_easteu oth_centereu ///
				   russia oth_russeu ///
				   euro nonprot prot newsend oldsend lingfar lingclose ///
				   soc10 soc20 nonsoc10 nonsoc20 soc10r soc20r nonsoc10r nonsoc20r unionh unionl unionh_2 unionl_2 {	

	gen sh_`country'_wa_10yr_`s' 		= `country'_wa_10yr_`s' / all_wa_`s'

}

}

*------------------------------------------------------------------------------*
* Predicted variables
*------------------------------------------------------------------------------*

* Predicted population

foreach var of varlist all_totpop_mw all_totpop_m all_totpop_w {
	
gen US_`var'_lvout_1890_temp = US_`var' - `var' if year == 1890
bysort countynhg_1930 (year): gegen US_`var'_lvout_1890 = max(US_`var'_lvout_1890_temp)
gen `var'_growth_1890 = US_`var'_lvout / US_`var'_lvout_1890	

gen 	pr1890_`var' = `var'_1890 * `var'_growth_1890 if year > 1890	

}

* Predicted LF
	
gen US_all_wa_m_lvout_1880_temp = US_all_wa_m - all_wa_m if year == 1880
bysort countynhg_1930 (year): gegen US_all_wa_m_lvout_1880 = max(US_all_wa_m_lvout_1880_temp)
gen lfgrowth_1880 = US_all_wa_m_lvout / US_all_wa_m_lvout_1880	

gen 	pr1880_all_wa_m = all_wa_m_1880 * lfgrowth_1880 if year > 1880	

*Merge predicted immigrant flows (based on weather)
merge m:1 year using "$intmdata/predicted_flows_weather.dta"
drop if _merge == 2
drop _merge

	
* Initial settlement shares by country

foreach country in denmark norway sweden uk ireland belgium france luxemb nether switz ///
				   italy gr_pt_es aus_hung czech germany poland russia {
				   	
	gegen `country'_mw_US_1890_temp 	= sum(`country'_mw) if year == 1890
	gegen `country'_mw_US_1890		= max(`country'_mw_US_1890_temp)
	drop  `country'_mw_US_1890_temp
	
	gen sh_`country'_mw_1890_temp 		= `country'_mw / `country'_mw_US_1890 if year == 1890
	bysort countynhg_1930 (year): gegen sh_`country'_mw_1890 = max(sh_`country'_mw_1890_temp)
	drop sh_`country'_mw_1890_temp

}

foreach s in m w mw {
	

	
* By country
foreach country in denmark norway sweden uk ireland belgium france luxemb nether switz ///
				   italy gr_pt_es aus_hung czech germany poland russia {
	
	gen pr1890_`country'_10yr_`s' = sh_`country'_mw_1890 * `country'_US_10yr_`s'_lvout if year > 1890
	
	gen pr_temp_`country'_10yr_`s' = sh_`country'_mw_1890 * `country'_temp_US_10yr_mw if year > 1890
	
} 

foreach prtype in pr1890 pr_temp {	

* All Europe
gegen `prtype'_euro_10yr_`s' 	= rowtotal(`prtype'_*_10yr_`s') if year > 1890, missing 

* Non-Protestant countries
gegen `prtype'_nonprot_10yr_`s' 	= rowtotal(`prtype'_ireland_10yr_`s' ///
											   `prtype'_belgium_10yr_`s' `prtype'_france_10yr_`s' ///
											   `prtype'_luxemb_10yr_`s' ///
											   `prtype'_italy_10yr_`s' `prtype'_gr_pt_es_10yr_`s' ///
											   `prtype'_aus_hung_10yr_`s' `prtype'_czech_10yr_`s' `prtype'_poland_10yr_`s' ///
											   `prtype'_russia_10yr_`s'), missing

* Protestant countries
gegen `prtype'_prot_10yr_`s' 		= rowtotal(`prtype'_denmark_10yr_`s' `prtype'_norway_10yr_`s' `prtype'_sweden_10yr_`s' ///
											   `prtype'_uk_10yr_`s' ///
											   `prtype'_nether_10yr_`s' `prtype'_switz_10yr_`s' ///
											   `prtype'_germany_10yr_`s'), missing

* New sending countries
gegen `prtype'_newsend_10yr_`s' 	= rowtotal(`prtype'_italy_10yr_`s' `prtype'_gr_pt_es_10yr_`s' ///
											   `prtype'_aus_hung_10yr_`s' `prtype'_czech_10yr_`s' `prtype'_poland_10yr_`s' ///
											   `prtype'_russia_10yr_`s'), missing

* Old sending countries
gegen `prtype'_oldsend_10yr_`s' 	= rowtotal(`prtype'_denmark_10yr_`s' `prtype'_norway_10yr_`s' `prtype'_sweden_10yr_`s' ///
											   `prtype'_uk_10yr_`s' `prtype'_ireland_10yr_`s' ///
											   `prtype'_belgium_10yr_`s' `prtype'_france_10yr_`s' `prtype'_luxemb_10yr_`s' ///
											   `prtype'_nether_10yr_`s' `prtype'_switz_10yr_`s' ///
											   `prtype'_germany_10yr_`s'), missing

* Linguistically far countries
gegen `prtype'_lingfar_10yr_`s' 	= rowtotal(`prtype'_denmark_10yr_`s' ///
											   `prtype'_gr_pt_es_10yr_`s' ///
											   `prtype'_aus_hung_10yr_`s' `prtype'_czech_10yr_`s' `prtype'_germany_10yr_`s' ///
											   `prtype'_poland_10yr_`s' ///
											   `prtype'_russia_10yr_`s'), missing

* Linguistically close countries
gegen `prtype'_lingclose_10yr_`s' 	= rowtotal(`prtype'_norway_10yr_`s' `prtype'_sweden_10yr_`s' ///
											   `prtype'_uk_10yr_`s' `prtype'_ireland_10yr_`s' ///
											   `prtype'_belgium_10yr_`s' `prtype'_france_10yr_`s' `prtype'_luxemb_10yr_`s' ///
											   `prtype'_nether_10yr_`s' `prtype'_switz_10yr_`s' /// 
											   `prtype'_italy_10yr_`s'), missing
							 
* Countries w/ unions in 1870
gegen `prtype'_unionh_10yr_`s' 	= rowtotal(`prtype'_uk_10yr_`s' `prtype'_ireland_10yr_`s'), missing

* Countries w/ no unions in 1870
gegen `prtype'_unionl_10yr_`s' 	= rowtotal(`prtype'_denmark_10yr_`s' ///
											   `prtype'_germany_10yr_`s' `prtype'_belgium_10yr_`s' ///
											   `prtype'_france_10yr_`s' ///
											   `prtype'_aus_hung_10yr_`s' ///
											   `prtype'_norway_10yr_`s' `prtype'_switz_10yr_`s' `prtype'_nether_10yr_`s' ///
											   `prtype'_italy_10yr_`s' ///
											   `prtype'_sweden_10yr_`s' ///
											   `prtype'_luxemb_10yr_`s' ///
											    `prtype'_gr_pt_es_10yr_`s' ///
											   `prtype'_czech_10yr_`s' `prtype'_poland_10yr_`s' ///
											   `prtype'_russia_10yr_`s'), missing
	
* Predicted shares
foreach country in denmark norway sweden uk ireland nether belgium luxemb france switz ///
				   italy gr_pt_es aus_hung czech poland germany russia ///
				   euro nonprot prot newsend oldsend lingfar lingclose unionh unionl {

	gen `prtype'_sh_`country'_10yr_`s' = `prtype'_`country'_10yr_`s' / all_totpop_`s'_1890 if year > 1890
											
}		
		
}

}

* Predicted working-age population flows

* By country
foreach country in denmark norway sweden uk ireland belgium france luxemb nether switz ///
				   italy gr_pt_es aus_hung czech germany poland russia {

	gen pr1890_`country'_wa_10yr_m = sh_`country'_mw_1890 * `country'_US_wa_10yr_m_lvout if year > 1890

}

foreach prtype in pr1890 {

* All Europe
gegen `prtype'_euro_wa_10yr_m 	= rowtotal(`prtype'_*_wa_10yr_m) if year > 1890, missing

* Non-Protestant countries
gegen `prtype'_nonprot_wa_10yr_m 	= rowtotal(`prtype'_ireland_wa_10yr_m ///
												   `prtype'_belgium_wa_10yr_m `prtype'_france_wa_10yr_m ///
												   `prtype'_luxemb_wa_10yr_m ///
												   `prtype'_italy_wa_10yr_m `prtype'_gr_pt_es_wa_10yr_m ///
												   `prtype'_aus_hung_wa_10yr_m `prtype'_czech_wa_10yr_m `prtype'_poland_wa_10yr_m ///
												   `prtype'_russia_wa_10yr_m), missing

* Protestant countries
gegen `prtype'_prot_wa_10yr_m 		= rowtotal(`prtype'_denmark_wa_10yr_m `prtype'_norway_wa_10yr_m `prtype'_sweden_wa_10yr_m ///
												   `prtype'_uk_wa_10yr_m ///
											       `prtype'_nether_wa_10yr_m `prtype'_switz_wa_10yr_m ///
											       `prtype'_germany_wa_10yr_m), missing

* New sending countries
gegen `prtype'_newsend_wa_10yr_m 	= rowtotal(`prtype'_italy_wa_10yr_m `prtype'_gr_pt_es_wa_10yr_m ///
												   `prtype'_aus_hung_wa_10yr_m `prtype'_czech_wa_10yr_m `prtype'_poland_wa_10yr_m ///
												   `prtype'_russia_wa_10yr_m), missing

* Old sending countries
gegen `prtype'_oldsend_wa_10yr_m 	= rowtotal(`prtype'_denmark_wa_10yr_m `prtype'_norway_wa_10yr_m `prtype'_sweden_wa_10yr_m ///
												   `prtype'_uk_wa_10yr_m `prtype'_ireland_wa_10yr_m ///
												   `prtype'_belgium_wa_10yr_m `prtype'_france_wa_10yr_m `prtype'_luxemb_wa_10yr_m ///
												   `prtype'_nether_wa_10yr_m `prtype'_switz_wa_10yr_m ///
												   `prtype'_germany_wa_10yr_m), missing

* Linguistically far countries
gegen `prtype'_lingfar_wa_10yr_m 	= rowtotal(`prtype'_denmark_wa_10yr_m ///
												   `prtype'_gr_pt_es_wa_10yr_m ///
												   `prtype'_aus_hung_wa_10yr_m `prtype'_czech_wa_10yr_m `prtype'_germany_wa_10yr_m ///
												   `prtype'_poland_wa_10yr_m ///
												   `prtype'_russia_wa_10yr_m), missing

* Linguistically close countries
gegen `prtype'_lingclose_wa_10yr_m 	= rowtotal(`prtype'_norway_wa_10yr_m `prtype'_sweden_wa_10yr_m ///
												   `prtype'_uk_wa_10yr_m `prtype'_ireland_wa_10yr_m ///
												   `prtype'_belgium_wa_10yr_m `prtype'_france_wa_10yr_m `prtype'_luxemb_wa_10yr_m ///
												   `prtype'_nether_wa_10yr_m `prtype'_switz_wa_10yr_m /// 
												   `prtype'_italy_wa_10yr_m), missing
							 
* Non-Socialist (soc. parties below 10%, avg. 1890-1919)
gegen `prtype'_nonsoc10_wa_10yr_m		= rowtotal(`prtype'_uk_wa_10yr_m `prtype'_ireland_wa_10yr_m ///
												   `prtype'_nether_wa_10yr_m  /// 
												   `prtype'_gr_pt_es_wa_10yr_m ///
												   `prtype'_czech_wa_10yr_m `prtype'_poland_wa_10yr_m), missing

* Socialist (soc. parties above 10%, avg. 1890-1919)
gegen `prtype'_soc10_wa_10yr_m		= rowtotal(`prtype'_aus_hung_wa_10yr_m `prtype'_belgium_wa_10yr_m ///
											   `prtype'_denmark_wa_10yr_m `prtype'_france_wa_10yr_m ///
											   `prtype'_germany_wa_10yr_m ///
											   `prtype'_italy_wa_10yr_m `prtype'_luxemb_wa_10yr_m ///
											   `prtype'_norway_wa_10yr_m `prtype'_sweden_wa_10yr_m ///
											   `prtype'_switz_wa_10yr_m `prtype'_russia_wa_10yr_m), missing
									   
* Non-Socialist (soc. parties below 10%, avg. 1890-1919) + Russia
gegen `prtype'_nonsoc10r_wa_10yr_m		= rowtotal(`prtype'_uk_wa_10yr_m `prtype'_ireland_wa_10yr_m ///
												   `prtype'_nether_wa_10yr_m  /// 
												   `prtype'_gr_pt_es_wa_10yr_m ///
												   `prtype'_czech_wa_10yr_m `prtype'_poland_wa_10yr_m ///
												    `prtype'_russia_wa_10yr_m), missing

* Socialist (soc. parties above 10%, avg. 1890-1919) No Russia
gegen `prtype'_soc10r_wa_10yr_m		= rowtotal(`prtype'_aus_hung_wa_10yr_m `prtype'_belgium_wa_10yr_m ///
											   `prtype'_denmark_wa_10yr_m `prtype'_france_wa_10yr_m ///
											   `prtype'_germany_wa_10yr_m ///
											   `prtype'_italy_wa_10yr_m `prtype'_luxemb_wa_10yr_m ///
											   `prtype'_norway_wa_10yr_m `prtype'_sweden_wa_10yr_m ///
											   `prtype'_switz_wa_10yr_m), missing
											   
* Non-Socialist (soc. parties below 20%, avg. 1890-1919)
gegen `prtype'_nonsoc20_wa_10yr_m		= rowtotal(`prtype'_uk_wa_10yr_m `prtype'_ireland_wa_10yr_m ///
												   `prtype'_nether_wa_10yr_m  /// 
												   `prtype'_gr_pt_es_wa_10yr_m ///
												   `prtype'_czech_wa_10yr_m `prtype'_poland_wa_10yr_m ///
												   `prtype'_belgium_wa_10yr_m `prtype'_france_wa_10yr_m ///
												   `prtype'_italy_wa_10yr_m `prtype'_luxemb_wa_10yr_m ///
												   `prtype'_norway_wa_10yr_m `prtype'_sweden_wa_10yr_m ///
											       `prtype'_switz_wa_10yr_m), missing

* Socialist (soc. parties above 20%, avg. 1890-1919)
gegen `prtype'_soc20_wa_10yr_m		= rowtotal(`prtype'_aus_hung_wa_10yr_m  ///
											   `prtype'_denmark_wa_10yr_m  ///
											   `prtype'_germany_wa_10yr_m ///
											    `prtype'_russia_wa_10yr_m), missing
												
* Non-Socialist (soc. parties below 20%, avg. 1890-1919) + Russia
gegen `prtype'_nonsoc20r_wa_10yr_m		= rowtotal(`prtype'_uk_wa_10yr_m `prtype'_ireland_wa_10yr_m ///
												   `prtype'_nether_wa_10yr_m  /// 
												   `prtype'_gr_pt_es_wa_10yr_m ///
												   `prtype'_czech_wa_10yr_m `prtype'_poland_wa_10yr_m ///
												   `prtype'_belgium_wa_10yr_m `prtype'_france_wa_10yr_m ///
												   `prtype'_italy_wa_10yr_m `prtype'_luxemb_wa_10yr_m ///
												   `prtype'_norway_wa_10yr_m `prtype'_sweden_wa_10yr_m ///
											       `prtype'_switz_wa_10yr_m ///
												   `prtype'_russia_wa_10yr_m), missing

* Socialist (soc. parties above 20%, avg. 1890-1919) No Russia
gegen `prtype'_soc20r_wa_10yr_m		= rowtotal(`prtype'_aus_hung_wa_10yr_m  ///
											   `prtype'_denmark_wa_10yr_m  ///
											   `prtype'_germany_wa_10yr_m) ///
											    , missing												
											   
* Countries w/ unions in 1870
gegen `prtype'_unionh_wa_10yr_m 	= rowtotal(`prtype'_uk_wa_10yr_m `prtype'_ireland_wa_10yr_m), missing

* Countries w/ no unions in 1870
gegen `prtype'_unionl_wa_10yr_m 	= rowtotal(`prtype'_denmark_wa_10yr_m ///
											   `prtype'_germany_wa_10yr_m `prtype'_belgium_wa_10yr_m ///
											   `prtype'_france_wa_10yr_m ///
											   `prtype'_aus_hung_wa_10yr_m ///
											   `prtype'_norway_wa_10yr_m `prtype'_switz_wa_10yr_m `prtype'_nether_wa_10yr_m ///
											   `prtype'_italy_wa_10yr_m ///
											   `prtype'_sweden_wa_10yr_m ///
											   `prtype'_luxemb_wa_10yr_m ///
											    `prtype'_gr_pt_es_wa_10yr_m ///
											   `prtype'_czech_wa_10yr_m `prtype'_poland_wa_10yr_m ///
											   `prtype'_russia_wa_10yr_m), missing

* Countries w/ some unions as of 1900
gegen `prtype'_unionh_2_wa_10yr_m 	= rowtotal(`prtype'_aus_hung_wa_10yr_m `prtype'_belgium_wa_10yr_m ///
												   `prtype'_denmark_wa_10yr_m `prtype'_france_wa_10yr_m ///
												   `prtype'_germany_wa_10yr_m `prtype'_italy_wa_10yr_m ///
												   `prtype'_norway_wa_10yr_m `prtype'_sweden_wa_10yr_m ///
												   `prtype'_uk_wa_10yr_m `prtype'_ireland_wa_10yr_m), missing

* Countries w/ no unions as of 1900
gegen `prtype'_unionl_2_wa_10yr_m 	= rowtotal(`prtype'_switz_wa_10yr_m `prtype'_nether_wa_10yr_m ///
											   `prtype'_luxemb_wa_10yr_m ///
											    `prtype'_gr_pt_es_wa_10yr_m ///
											   `prtype'_czech_wa_10yr_m `prtype'_poland_wa_10yr_m ///
											   `prtype'_russia_wa_10yr_m), missing											   
											   
* Predicted shares
foreach country in denmark norway sweden uk ireland nether belgium luxemb france switz ///
				   italy gr_pt_es aus_hung czech poland germany russia ///
				   euro nonprot prot newsend oldsend lingfar lingclose ///
				   soc10 soc20 soc10r soc20r nonsoc10 nonsoc20 nonsoc10r nonsoc20r ///
				   unionh unionl unionh_2 unionl_2 {	
	   
	gen `prtype'_sh_`country'_wa_10yr_m = `prtype'_`country'_wa_10yr_m / all_totpop_m_1890 if year > 1890
											
}		
		
}

keep year countynhg_1930 ///
     pr1890_* pr_temp_* ///
     *_wa_10yr_* sh_*_10yr* sh_*_1890

label data "County-year shift-share instruments (1890 settlement shares x national flows; pr1890_* main, pr_temp_* weather)"
label var year "Year"
label var countynhg_1930 "NHGIS county code, 1930 boundaries"

save "$data/shiftshare_county1930.dta", replace
