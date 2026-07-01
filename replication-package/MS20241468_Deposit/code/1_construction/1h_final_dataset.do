*==============================================================================*
* 1h_final_dataset.do
*
* Builds the master county-year analysis dataset for the union analyses, on
* constant 1930 county boundaries, 1880-1920. Starts from the county panel
* produced by 1d_county_panel, attaches the shift-share instruments (1f),
* crowdout shocks (1g), per-national-union and AFL state-convention county
* aggregates (the _build stage, combined by b12), and a series of construction-pipeline
* intermediates (1b onward), and writes the master analysis dataset
* (analysis_dataset_county1930) that the 2_analysis scripts (2a-2f) consume.
*
* Organized into five sections (use the section banners below to navigate):
*   0. Setup                       globals, load, region/state/SEA merges
*   1. Labor force aggregates      ethnic x occupation, industry, skill bins
*   2. Shift-share and crowdout    shift-share merge, crowdout merge,
*                                  per-occupation crowdout aggregated to
*                                  low-skill / mid-and-high-skill bins
*   3. Controls and base-year      KOL/IWW counts, control shares, CPI and
*                                  manufacturing interpolation, Logan-Parman
*                                  segregation, base-year snapshots, election
*                                  vote shares, railroad connection
*   4. Union measures              AFL state-convention and per-national-union
*                                  merges, interpolation, zero-fills, combined
*                                  densities and ethnic shares, AFL
*                                  locals/members derivations, final renames
*
* INPUTS:
*   $data/county_panel_1880-1920_county1930.dta   - county panel (1d)
*   $data/shiftshare_county1930.dta                   - shift-share (1f)
*   $data/crowdout_county1930.dta            - crowdout shocks (1g)
*   $intmdata/xwalk_statefip_stateicp.dta             - state crosswalk (1a)
*   $intmdata/xwalk_1930_countynhg_SEA.dta            - county-to-SEA (1a)
*   $intmdata/KOL_locals_1880-1890_county1930.dta     - KoL locals
*   $intmdata/IWW_unions_1906-1917_county1930.dta     - IWW union counts
*   $intmdata/cpi_u.dta                               - CPI series (b7)
*   $intmdata/railroad_connection_1930countyboundaries.dta - rail conn. (b7)
*   $rawdata/unions/unions_combined_county1930.csv    - combined union counts (b12)
*
* OUTPUT (in $data/):
*   analysis_dataset_county1930.dta
*
* Run via 00_master.do, or standalone.
*==============================================================================*

clear all
set more off, perm
set maxvar 120000, perm

* Project root. 00_master.do sets \$root for the full run; the line below also
* lets this file run on its own -- set it to the local path of the package.
if "$root" == "" global root "set-this-to-the-replication-package-path"
global rawdata  "$root/data/public"
global intmdata "$root/data/intermediate"
global data     "$root/data/clean"
global censusagg "$rawdata/census_aggregates"   // shipped aggregates built by build_documentation/


*==============================================================================*
* 0. Setup: load the panel, attach state/region/SEA identifiers
*==============================================================================*

use "$data/county_panel_1880-1920_county1930.dta", clear

gen census = year if inlist(year,1880,1890,1900,1910,1920) == 1

gen     region = .
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

merge m:1 statefip using "$intmdata/xwalk_statefip_stateicp.dta", keepusing(statename statecode)
order statename statecode, after(statefip)
drop if _merge == 2
drop _merge

merge m:1 countynhg_1930 using "$intmdata/xwalk_1930_countynhg_SEA.dta", keepusing(sea)
drop if _merge == 2
drop _merge


*==============================================================================*
* 1. Labor force aggregates: ethnic x occupation, industry, skill bins
*
* Builds European old- and new-sending totals; ethnic-group x OCC1950
* occupation cells aggregated into "European immigrant", "European
* old-sending", and "European new-sending" supersets; labor force in
* specific unionized occupations by ethnic group; labor force by 1-digit
* IND1950 industry; labor force in the AFL-union and any-union occupation
* sets; total labor force by Katz-Margo (2014) skill bin (with operatives
* variants); non-farm labor-force aggregate. Drops the per-occupation
* columns at the end since the aggregates above are the only downstream
* consumers.
*==============================================================================*


*------------------------------------------------------------------------------*
* European immigrant totals per OCC1950 occupation
*------------------------------------------------------------------------------*

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
			 760 761 762 763 764 770 771 772 773 780 781 782 783 784 785 790 810 820 830 840 910 920 930 940 950 960 970 971 972 973 {

egen euro_imm_occ`o'_m = rowtotal(denmark_occ`o'_m finland_occ`o'_m norway_occ`o'_m sweden_occ`o'_m ///
								  uk_occ`o'_m ireland_occ`o'_m oth_northeu_occ`o'_m ///
								  belgium_occ`o'_m france_occ`o'_m luxemb_occ`o'_m ///
								  nether_occ`o'_m switz_occ`o'_m oth_westeu_occ`o'_m ///
								  italy_occ`o'_m gr_pt_es_occ`o'_m oth_southeu_occ`o'_m ///
								  aus_hung_occ`o'_m czech_occ`o'_m germany_occ`o'_m ///
								  poland_occ`o'_m oth_easteu_occ`o'_m oth_centereu_occ`o'_m ///
								  russia_occ`o'_m oth_russeu_occ`o'_m)
}


*------------------------------------------------------------------------------*
* Labor force in specific unionized occupations, by ethnic group
*------------------------------------------------------------------------------*

foreach i in all euro_imm {

gegen `i'_lf_miner_m = rowtotal(`i'_occ650_m), missing							// mine operatives and laborers
gegen `i'_lf_carpen_m = rowtotal(`i'_occ510_m `i'_occ602_m `i'_occ505_m `i'_occ560_m), missing // carpenters, cabinetmakers, millwrights, apprentice carpenters
gegen `i'_lf_machinist_m = rowtotal(`i'_occ544_m `i'_occ604_m), missing			// machinists, apprentice machinists
gegen `i'_lf_painter_m = rowtotal(`i'_occ564_m `i'_occ670_m `i'_occ514_m `i'_occ530_m `i'_occ565_m), missing // painters, decorators, glaziers, paperhangers
gegen `i'_lf_electrical_m = rowtotal(`i'_occ515_m `i'_occ603_m `i'_occ540_m `i'_occ370_m `i'_occ44_m), missing // electricians, apprentice electricians, linemen and servicemen, telephone operators, electrical engineers
gegen `i'_lf_ryclerk_m = rowtotal(`i'_occ304_m `i'_occ380_m `i'_occ325_m), missing // baggagemen, ticket station agents, railway mail clerks
gegen `i'_lf_brickl_m = rowtotal(`i'_occ504_m `i'_occ601_m `i'_occ573_m), missing // brickmasons and stonemasons, apprentice bricklayers and masons, plasterers
gegen `i'_lf_teamster_m = rowtotal(`i'_occ960_m `i'_occ682_m `i'_occ683_m), missing // teamsters, chauffeurs, truck and tractor drivers
gegen `i'_lf_typogr_m	= rowtotal(`i'_occ575_m `i'_occ613_m), missing			// pressmen and plate printers, apprentice printing trades
gegen `i'_lf_carman_m = rowtotal(`i'_occ553_m), missing							// mechanics and repairmen - railroad and car shop
gegen `i'_lf_tailor_m = rowtotal(`i'_occ590_m), missing							// tailors

gegen `i'_lf_fireman_m = rowtotal(`i'_occ680_m), missing						// stationary firemen
gegen `i'_lf_streetrail_m = rowtotal(`i'_occ631_m `i'_occ661_m), missing		// street railway conductors and motormen
gegen `i'_lf_laundry_m = rowtotal(`i'_occ643_m), missing						// laundry operatives
gegen `i'_lf_longshoreman_m = rowtotal(`i'_occ940_m), missing					// longshoremen
gegen `i'_lf_retailclerk_m = rowtotal(`i'_occ490_m), missing					// salesmen and sales clerks
gegen `i'_lf_hotelrest_m = rowtotal(`i'_occ784_m), missing						// waiters
gegen `i'_lf_rytelegraph_m = rowtotal(`i'_occ322_m), missing					// dispatchers and starters, vehicles

gegen `i'_lf_textlab_m = rowtotal(`i'_occ971_m), missing						// laborers in textile industry
gegen `i'_lf_meatlab_m = rowtotal(`i'_occ972_m), missing						// laborers in meat-packing industry
gegen `i'_lf_beverlab_m = rowtotal(`i'_occ973_m), missing						// laborers in beverage industry

}


*------------------------------------------------------------------------------*
* Labor force by 1-digit IND1950 industry
*------------------------------------------------------------------------------*

foreach i in all euro_imm {

foreach j in agric mining constr mfg transp trade fin biz persserv ent profserv pubadm {
cap drop `i'_lf_`j'_m
}

egen `i'_lf_agric_m = rowtotal(`i'_lf_ind105_m `i'_lf_ind116_m `i'_lf_ind126_m), missing
egen `i'_lf_mining_m = rowtotal(`i'_lf_ind206_m `i'_lf_ind216_m `i'_lf_ind226_m `i'_lf_ind236_m `i'_lf_ind239_m), missing
egen `i'_lf_constr_m = rowtotal(`i'_lf_ind246_m), missing
egen `i'_lf_mfg_m = rowtotal(`i'_lf_ind306_m `i'_lf_ind307_m `i'_lf_ind308_m `i'_lf_ind309_m `i'_lf_ind316_m `i'_lf_ind317_m ///
						     `i'_lf_ind318_m `i'_lf_ind319_m `i'_lf_ind326_m `i'_lf_ind336_m `i'_lf_ind337_m `i'_lf_ind338_m ///
							 `i'_lf_ind346_m `i'_lf_ind347_m `i'_lf_ind348_m `i'_lf_ind356_m `i'_lf_ind357_m `i'_lf_ind358_m ///
							 `i'_lf_ind367_m `i'_lf_ind376_m `i'_lf_ind377_m `i'_lf_ind378_m `i'_lf_ind379_m `i'_lf_ind386_m ///
							 `i'_lf_ind387_m `i'_lf_ind388_m `i'_lf_ind399_m `i'_lf_ind406_m `i'_lf_ind407_m `i'_lf_ind408_m ///
							 `i'_lf_ind409_m `i'_lf_ind416_m `i'_lf_ind417_m `i'_lf_ind418_m `i'_lf_ind419_m `i'_lf_ind426_m ///
							 `i'_lf_ind429_m `i'_lf_ind436_m `i'_lf_ind437_m `i'_lf_ind438_m `i'_lf_ind439_m `i'_lf_ind446_m ///
							 `i'_lf_ind448_m `i'_lf_ind449_m `i'_lf_ind456_m `i'_lf_ind457_m `i'_lf_ind458_m `i'_lf_ind459_m ///
							 `i'_lf_ind466_m `i'_lf_ind467_m `i'_lf_ind468_m `i'_lf_ind469_m `i'_lf_ind476_m `i'_lf_ind477_m ///
							 `i'_lf_ind478_m `i'_lf_ind487_m `i'_lf_ind488_m `i'_lf_ind489_m `i'_lf_ind499_m), missing
egen `i'_lf_transp_m = rowtotal(`i'_lf_ind506_m `i'_lf_ind516_m `i'_lf_ind526_m `i'_lf_ind527_m `i'_lf_ind536_m `i'_lf_ind546_m ///
								`i'_lf_ind556_m `i'_lf_ind567_m `i'_lf_ind568_m `i'_lf_ind578_m `i'_lf_ind579_m `i'_lf_ind586_m ///
								`i'_lf_ind587_m `i'_lf_ind588_m `i'_lf_ind596_m `i'_lf_ind597_m `i'_lf_ind598_m), missing
egen `i'_lf_trade_m = rowtotal(`i'_lf_ind606_m `i'_lf_ind607_m `i'_lf_ind608_m `i'_lf_ind609_m `i'_lf_ind616_m `i'_lf_ind617_m ///
							   `i'_lf_ind618_m `i'_lf_ind619_m `i'_lf_ind626_m `i'_lf_ind627_m `i'_lf_ind636_m `i'_lf_ind637_m ///
							   `i'_lf_ind646_m `i'_lf_ind647_m `i'_lf_ind656_m `i'_lf_ind657_m `i'_lf_ind658_m `i'_lf_ind659_m ///
							   `i'_lf_ind667_m `i'_lf_ind668_m `i'_lf_ind669_m `i'_lf_ind679_m `i'_lf_ind686_m `i'_lf_ind687_m ///
							   `i'_lf_ind688_m `i'_lf_ind689_m `i'_lf_ind696_m `i'_lf_ind697_m `i'_lf_ind698_m `i'_lf_ind699_m), missing
egen `i'_lf_fin_m = rowtotal(`i'_lf_ind716_m `i'_lf_ind726_m `i'_lf_ind736_m `i'_lf_ind746_m `i'_lf_ind756_m), missing
egen `i'_lf_biz_m = rowtotal(`i'_lf_ind806_m `i'_lf_ind807_m `i'_lf_ind808_m `i'_lf_ind816_m `i'_lf_ind817_m), missing
egen `i'_lf_persserv_m = rowtotal(`i'_lf_ind826_m `i'_lf_ind836_m `i'_lf_ind846_m `i'_lf_ind847_m `i'_lf_ind848_m `i'_lf_ind849_m), missing
egen `i'_lf_ent_m = rowtotal(`i'_lf_ind856_m `i'_lf_ind857_m `i'_lf_ind858_m `i'_lf_ind859_m), missing
egen `i'_lf_profserv_m = rowtotal(`i'_lf_ind868_m `i'_lf_ind869_m `i'_lf_ind879_m `i'_lf_ind888_m `i'_lf_ind896_m `i'_lf_ind897_m ///
								  `i'_lf_ind898_m `i'_lf_ind899_m), missing
egen `i'_lf_pubadm_m = rowtotal(`i'_lf_ind906_m `i'_lf_ind916_m `i'_lf_ind926_m `i'_lf_ind936_m `i'_lf_ind946_m), missing

drop `i'_lf_ind*_m

}


*------------------------------------------------------------------------------*
* Labor force in AFL-union occupations
*------------------------------------------------------------------------------*

gegen all_lf_afloccs_m = rowtotal(all_occ1_m all_occ4_m all_occ46_m all_occ47_m all_occ48_m ///
								  all_occ49_m all_occ57_m all_occ310_m all_occ322_m all_occ325_m ///
								  all_occ335_m all_occ340_m all_occ342_m all_occ350_m all_occ360_m ///
								  all_occ365_m all_occ370_m all_occ500_m all_occ501_m all_occ502_m ///
								  all_occ503_m all_occ504_m all_occ505_m all_occ510_m all_occ511_m ///
								  all_occ512_m all_occ513_m all_occ514_m all_occ515_m all_occ520_m ///
								  all_occ521_m all_occ522_m all_occ523_m all_occ524_m all_occ525_m ///
								  all_occ530_m all_occ531_m all_occ532_m all_occ533_m all_occ534_m ///
								  all_occ535_m all_occ540_m all_occ541_m all_occ542_m all_occ543_m ///
								  all_occ544_m all_occ545_m all_occ550_m all_occ551_m all_occ552_m ///
								  all_occ553_m all_occ554_m all_occ555_m all_occ560_m all_occ561_m ///
								  all_occ562_m all_occ563_m all_occ564_m all_occ565_m all_occ570_m ///
								  all_occ571_m all_occ572_m all_occ573_m all_occ574_m all_occ575_m ///
								  all_occ580_m all_occ581_m all_occ582_m all_occ583_m all_occ584_m all_occ585_m ///
								  all_occ590_m all_occ591_m all_occ592_m all_occ593_m all_occ594_m ///
								  all_occ600_m all_occ601_m all_occ602_m all_occ603_m all_occ604_m ///
								  all_occ605_m all_occ610_m all_occ611_m all_occ612_m all_occ613_m ///
								  all_occ614_m all_occ615_m all_occ620_m all_occ621_m all_occ622_m ///
								  all_occ623_m all_occ624_m all_occ630_m all_occ631_m all_occ632_m ///
								  all_occ633_m all_occ634_m all_occ635_m all_occ641_m all_occ642_m ///
								  all_occ643_m all_occ644_m all_occ645_m all_occ650_m all_occ660_m ///
								  all_occ661_m all_occ662_m all_occ670_m all_occ671_m all_occ672_m ///
								  all_occ673_m all_occ674_m all_occ675_m all_occ680_m all_occ681_m ///
								  all_occ682_m all_occ683_m all_occ684_m all_occ685_m all_occ690_m ///
								  all_occ730_m all_occ731_m all_occ732_m all_occ740_m all_occ750_m ///
								  all_occ751_m all_occ752_m all_occ753_m all_occ754_m all_occ760_m ///
								  all_occ761_m all_occ762_m all_occ764_m all_occ770_m all_occ784_m ///
								  all_occ910_m all_occ940_m all_occ950_m all_occ960_m ///
								  all_occ971_m all_occ972_m all_occ973_m) if year != 1890, missing


*------------------------------------------------------------------------------*
* Total labor force by skill bin (Katz-Margo, 2014) and non-farm aggregate.
* Excluded categories: managers, farmers, farm laborers, household service.
*------------------------------------------------------------------------------*

foreach i in all {

**Low skill: laborers [910,980], non-household service workers [730,790], operatives [600,690]
egen `i'_lf_lowskill_m = rowtotal(`i'_occ910_m `i'_occ920_m `i'_occ930_m `i'_occ940_m `i'_occ950_m `i'_occ960_m `i'_occ970_m ///
								`i'_occ730_m `i'_occ731_m `i'_occ732_m `i'_occ740_m ///
								`i'_occ750_m `i'_occ751_m `i'_occ752_m `i'_occ753_m `i'_occ754_m `i'_occ760_m `i'_occ761_m  ///
								`i'_occ762_m `i'_occ763_m `i'_occ764_m `i'_occ770_m `i'_occ771_m `i'_occ772_m `i'_occ773_m  ///
								`i'_occ780_m `i'_occ781_m `i'_occ782_m `i'_occ783_m `i'_occ784_m `i'_occ785_m `i'_occ790_m ///
								`i'_occ600_m `i'_occ601_m `i'_occ602_m `i'_occ603_m `i'_occ604_m `i'_occ605_m `i'_occ610_m ///
								`i'_occ611_m `i'_occ612_m `i'_occ613_m `i'_occ614_m `i'_occ615_m `i'_occ620_m `i'_occ621_m ///
								`i'_occ622_m `i'_occ623_m `i'_occ624_m `i'_occ625_m `i'_occ630_m `i'_occ631_m `i'_occ632_m ///
								`i'_occ633_m `i'_occ634_m `i'_occ635_m `i'_occ640_m `i'_occ641_m `i'_occ642_m `i'_occ643_m ///
								`i'_occ644_m `i'_occ645_m `i'_occ650_m `i'_occ660_m `i'_occ661_m `i'_occ662_m `i'_occ670_m ///
								`i'_occ671_m `i'_occ672_m `i'_occ673_m `i'_occ674_m `i'_occ675_m `i'_occ680_m `i'_occ681_m ///
								`i'_occ682_m `i'_occ683_m `i'_occ684_m `i'_occ685_m `i'_occ690_m) ///
								if year != 1890, missing

**Low skill alternative (operatives excluded): laborers [910,980], non-household service workers [730,790]
egen `i'_lf_lowskillalt_m = rowtotal(`i'_occ910_m `i'_occ920_m `i'_occ930_m `i'_occ940_m `i'_occ950_m `i'_occ960_m `i'_occ970_m ///
								`i'_occ730_m `i'_occ731_m `i'_occ732_m `i'_occ740_m ///
								`i'_occ750_m `i'_occ751_m `i'_occ752_m `i'_occ753_m `i'_occ754_m `i'_occ760_m `i'_occ761_m  ///
								`i'_occ762_m `i'_occ763_m `i'_occ764_m `i'_occ770_m `i'_occ771_m `i'_occ772_m `i'_occ773_m  ///
								`i'_occ780_m `i'_occ781_m `i'_occ782_m `i'_occ783_m `i'_occ784_m `i'_occ785_m `i'_occ790_m) ///
								if year != 1890, missing

**Middle skill 1 (blue collar): craft workers and apprentices [500,615]
egen `i'_lf_midskill1_m = rowtotal(`i'_occ500_m `i'_occ501_m `i'_occ502_m `i'_occ503_m `i'_occ504_m `i'_occ505_m `i'_occ510_m ///
								`i'_occ511_m `i'_occ512_m `i'_occ513_m `i'_occ514_m `i'_occ515_m `i'_occ520_m `i'_occ521_m  ///
								`i'_occ522_m `i'_occ523_m `i'_occ524_m `i'_occ525_m `i'_occ530_m `i'_occ531_m `i'_occ532_m  ///
								`i'_occ533_m `i'_occ534_m `i'_occ535_m `i'_occ540_m `i'_occ541_m `i'_occ542_m `i'_occ543_m  ///
								`i'_occ544_m `i'_occ545_m `i'_occ550_m `i'_occ551_m `i'_occ552_m `i'_occ553_m `i'_occ554_m ///
								`i'_occ555_m `i'_occ560_m `i'_occ561_m `i'_occ562_m `i'_occ563_m `i'_occ564_m `i'_occ565_m ///
								`i'_occ570_m `i'_occ571_m `i'_occ572_m `i'_occ573_m `i'_occ574_m `i'_occ575_m `i'_occ580_m  ///
								`i'_occ581_m `i'_occ582_m `i'_occ583_m `i'_occ584_m `i'_occ585_m `i'_occ590_m `i'_occ591_m  ///
								`i'_occ592_m `i'_occ593_m `i'_occ594_m) if year != 1890, missing

**Middle skill 1 alternative (operatives included): mid-skill 1 plus operatives [600,690]
egen `i'_lf_midskill1alt_m = rowtotal(`i'_lf_midskill1_m ///
									`i'_occ600_m `i'_occ601_m `i'_occ602_m `i'_occ603_m `i'_occ604_m `i'_occ605_m `i'_occ610_m ///
									`i'_occ611_m `i'_occ612_m `i'_occ613_m `i'_occ614_m `i'_occ615_m `i'_occ620_m `i'_occ621_m ///
									`i'_occ622_m `i'_occ623_m `i'_occ624_m `i'_occ625_m `i'_occ630_m `i'_occ631_m `i'_occ632_m ///
									`i'_occ633_m `i'_occ634_m `i'_occ635_m `i'_occ640_m `i'_occ641_m `i'_occ642_m `i'_occ643_m ///
									`i'_occ644_m `i'_occ645_m `i'_occ650_m `i'_occ660_m `i'_occ661_m `i'_occ662_m `i'_occ670_m ///
									`i'_occ671_m `i'_occ672_m `i'_occ673_m `i'_occ674_m `i'_occ675_m `i'_occ680_m `i'_occ681_m ///
									`i'_occ682_m `i'_occ683_m `i'_occ684_m `i'_occ685_m `i'_occ690_m) if year != 1890, missing

**Middle skill 2: middle skill 1 plus clerical [300,390] and sales workers [400,490]
egen `i'_lf_midskill2_m = rowtotal(`i'_lf_midskill1_m ///
								`i'_occ300_m `i'_occ301_m `i'_occ302_m `i'_occ304_m `i'_occ305_m `i'_occ310_m `i'_occ320_m  ///
								`i'_occ321_m `i'_occ322_m `i'_occ325_m `i'_occ335_m `i'_occ340_m `i'_occ341_m `i'_occ342_m ///
								`i'_occ350_m `i'_occ360_m `i'_occ365_m `i'_occ370_m `i'_occ380_m `i'_occ390_m ///
								`i'_occ400_m `i'_occ410_m `i'_occ420_m `i'_occ430_m `i'_occ450_m `i'_occ460_m `i'_occ470_m ///
								`i'_occ480_m `i'_occ490_m) if year != 1890, missing

**Middle skill 2 alternative (operatives included): mid-skill 2 plus operatives [600,690]
egen `i'_lf_midskill2alt_m = rowtotal(`i'_lf_midskill2_m ///
									`i'_occ600_m `i'_occ601_m `i'_occ602_m `i'_occ603_m `i'_occ604_m `i'_occ605_m `i'_occ610_m ///
									`i'_occ611_m `i'_occ612_m `i'_occ613_m `i'_occ614_m `i'_occ615_m `i'_occ620_m `i'_occ621_m ///
									`i'_occ622_m `i'_occ623_m `i'_occ624_m `i'_occ625_m `i'_occ630_m `i'_occ631_m `i'_occ632_m ///
									`i'_occ633_m `i'_occ634_m `i'_occ635_m `i'_occ640_m `i'_occ641_m `i'_occ642_m `i'_occ643_m ///
									`i'_occ644_m `i'_occ645_m `i'_occ650_m `i'_occ660_m `i'_occ661_m `i'_occ662_m `i'_occ670_m ///
									`i'_occ671_m `i'_occ672_m `i'_occ673_m `i'_occ674_m `i'_occ675_m `i'_occ680_m `i'_occ681_m ///
									`i'_occ682_m `i'_occ683_m `i'_occ684_m `i'_occ685_m `i'_occ690_m) if year != 1890, missing

**High skilled 2: professionals and technical workers [0,99]
egen `i'_lf_highskill2_m = rowtotal(`i'_occ0_m `i'_occ1_m `i'_occ2_m `i'_occ3_m `i'_occ4_m `i'_occ5_m `i'_occ6_m `i'_occ7_m  ///
								`i'_occ8_m `i'_occ9_m `i'_occ10_m `i'_occ12_m `i'_occ13_m `i'_occ14_m `i'_occ15_m ///
								`i'_occ16_m `i'_occ17_m `i'_occ18_m `i'_occ19_m `i'_occ23_m `i'_occ24_m `i'_occ25_m ///
								`i'_occ26_m `i'_occ27_m `i'_occ28_m `i'_occ29_m `i'_occ31_m `i'_occ32_m `i'_occ33_m ///
								`i'_occ34_m `i'_occ35_m `i'_occ36_m `i'_occ41_m `i'_occ42_m `i'_occ43_m `i'_occ44_m ///
								`i'_occ45_m `i'_occ46_m `i'_occ47_m `i'_occ48_m `i'_occ49_m `i'_occ51_m `i'_occ52_m ///
								`i'_occ53_m `i'_occ54_m `i'_occ55_m `i'_occ56_m `i'_occ57_m `i'_occ58_m `i'_occ59_m ///
								`i'_occ61_m `i'_occ62_m `i'_occ63_m `i'_occ67_m `i'_occ68_m `i'_occ69_m `i'_occ70_m ///
								`i'_occ71_m `i'_occ72_m `i'_occ73_m `i'_occ74_m `i'_occ75_m `i'_occ76_m `i'_occ77_m ///
								`i'_occ78_m `i'_occ79_m `i'_occ81_m `i'_occ82_m `i'_occ83_m `i'_occ84_m `i'_occ91_m ///
								`i'_occ92_m `i'_occ93_m `i'_occ94_m `i'_occ95_m `i'_occ96_m `i'_occ97_m `i'_occ98_m `i'_occ99_m) ///
								if year != 1890, missing

**High skilled 1 (all white collar): high-skill 2 plus clerical [300,399] and sales workers [400,490]
egen `i'_lf_highskill1_m = rowtotal(`i'_lf_highskill2_m ///
									`i'_occ300_m `i'_occ301_m `i'_occ302_m `i'_occ304_m `i'_occ305_m `i'_occ310_m `i'_occ320_m  ///
								`i'_occ321_m `i'_occ322_m `i'_occ325_m `i'_occ335_m `i'_occ340_m `i'_occ341_m `i'_occ342_m ///
								`i'_occ350_m `i'_occ360_m `i'_occ365_m `i'_occ370_m `i'_occ380_m `i'_occ390_m ///
								`i'_occ400_m `i'_occ410_m `i'_occ420_m `i'_occ430_m `i'_occ450_m `i'_occ460_m `i'_occ470_m ///
								`i'_occ480_m `i'_occ490_m) if year != 1890, missing


gen `i'_lf_nonfarm_m = `i'_lf_tot_m - `i'_lf_farmer_m - `i'_lf_farmlab_m if year != 1890

}


*------------------------------------------------------------------------------*
* Drop the per-occupation columns now that the labor-force aggregates above
* are built; subsequent sections reference the aggregates, not the cells.
*------------------------------------------------------------------------------*

drop *_occ0*_m *_occ1*_m *_occ2*_m *_occ3*_m *_occ4*_m *_occ5*_m *_occ6*_m *_occ7*_m *_occ8*_m *_occ9*_m


*==============================================================================*
* 2. Shift-share instrument and crowdout shocks
*
* Attaches the shift-share immigration instrument (1f) and the crowdout
* shock measures (1g), and aggregates the per-occupation crowdout cells
* into low-skill and middle-and-high-skill bins (Katz-Margo 2014).
*==============================================================================*


*------------------------------------------------------------------------------*
* Shift-share instrument
*------------------------------------------------------------------------------*

merge 1:1 year countynhg_1930 using "$data/shiftshare_county1930.dta"
drop if _merge == 2
drop _merge


*------------------------------------------------------------------------------*
* Crowdout shocks
*------------------------------------------------------------------------------*

merge 1:1 year countynhg_1930 using "$data/crowdout_county1930.dta", ///
	keepusing(crowdout_euall_nat crowdout_euall_nat_*)
drop _merge

rename crowdout* co*

**Crowdout aggregates by skill bin (Katz-Margo 2014)
foreach crowdout in co_euall_nat {

**Low skill: laborers [910,970], non-household service workers [730,790], operatives [600,690]
egen `crowdout'_lsk = rowtotal(`crowdout'_occ910 `crowdout'_occ920 `crowdout'_occ930 `crowdout'_occ940 ///
							  `crowdout'_occ950 `crowdout'_occ960 `crowdout'_occ970 ///
							  `crowdout'_occ730 `crowdout'_occ731 `crowdout'_occ732 `crowdout'_occ740 ///
							  `crowdout'_occ750 `crowdout'_occ751 `crowdout'_occ752 `crowdout'_occ753 ///
							  `crowdout'_occ754 `crowdout'_occ760 `crowdout'_occ761  `crowdout'_occ762 ///
							  `crowdout'_occ763 `crowdout'_occ764 `crowdout'_occ770 `crowdout'_occ771 ///
							  `crowdout'_occ772 `crowdout'_occ773 `crowdout'_occ780 `crowdout'_occ781 `crowdout'_occ782 `crowdout'_occ783 `crowdout'_occ784 `crowdout'_occ785 `crowdout'_occ790 ///
							  `crowdout'_occ600 `crowdout'_occ601 `crowdout'_occ602 `crowdout'_occ603 ///
							  `crowdout'_occ604 `crowdout'_occ605 `crowdout'_occ610 `crowdout'_occ611 ///
							  `crowdout'_occ612 `crowdout'_occ613 `crowdout'_occ614 `crowdout'_occ615 ///
							  `crowdout'_occ620 `crowdout'_occ621 `crowdout'_occ622 `crowdout'_occ623 ///
							  `crowdout'_occ624 `crowdout'_occ625 `crowdout'_occ630 `crowdout'_occ631 ///
							  `crowdout'_occ632 `crowdout'_occ633 `crowdout'_occ634 `crowdout'_occ635 ///
							  `crowdout'_occ640 `crowdout'_occ641 `crowdout'_occ642 `crowdout'_occ643 ///
							  `crowdout'_occ644 `crowdout'_occ645 `crowdout'_occ650 `crowdout'_occ660 ///
							  `crowdout'_occ661 `crowdout'_occ662 `crowdout'_occ670 `crowdout'_occ671 ///
							  `crowdout'_occ672 `crowdout'_occ673 `crowdout'_occ674 `crowdout'_occ675 ///
							  `crowdout'_occ680 `crowdout'_occ681 `crowdout'_occ682 `crowdout'_occ683 ///
							  `crowdout'_occ684 `crowdout'_occ685 `crowdout'_occ690) if year > 1890, missing

**Middle and high skill: craft workers and apprentices [500,594],
**professionals and technical workers [0,99], clerical [300,390],
**sales workers [400,490]
egen `crowdout'_mhsk = rowtotal(`crowdout'_occ500 `crowdout'_occ501 `crowdout'_occ502 `crowdout'_occ503 ///
							   `crowdout'_occ504 `crowdout'_occ505 `crowdout'_occ510 `crowdout'_occ511 ///
							   `crowdout'_occ512 `crowdout'_occ513 `crowdout'_occ514 `crowdout'_occ515 ///
							   `crowdout'_occ520 `crowdout'_occ521 `crowdout'_occ522 `crowdout'_occ523 ///
							   `crowdout'_occ524 `crowdout'_occ525 `crowdout'_occ530 `crowdout'_occ531 ///
							   `crowdout'_occ532 `crowdout'_occ533 `crowdout'_occ534 `crowdout'_occ535 ///
							   `crowdout'_occ540 `crowdout'_occ541 `crowdout'_occ542 `crowdout'_occ543 ///
							   `crowdout'_occ544 `crowdout'_occ545 `crowdout'_occ550 `crowdout'_occ551 ///
							   `crowdout'_occ552 `crowdout'_occ553 `crowdout'_occ554 `crowdout'_occ555 ///
							   `crowdout'_occ560 `crowdout'_occ561 `crowdout'_occ562 `crowdout'_occ563 ///
							   `crowdout'_occ564 `crowdout'_occ565 `crowdout'_occ570 `crowdout'_occ571 ///
							   `crowdout'_occ572 `crowdout'_occ573 `crowdout'_occ574 `crowdout'_occ575 ///
							   `crowdout'_occ580 `crowdout'_occ581 `crowdout'_occ582 `crowdout'_occ583 ///
							   `crowdout'_occ584 `crowdout'_occ585 `crowdout'_occ590 `crowdout'_occ591 ///
							   `crowdout'_occ592 `crowdout'_occ593 `crowdout'_occ594 ///
							   `crowdout'_occ0 `crowdout'_occ1 `crowdout'_occ2 `crowdout'_occ3 ///
							   `crowdout'_occ4 `crowdout'_occ5 `crowdout'_occ6 `crowdout'_occ7 ///
							   `crowdout'_occ8 `crowdout'_occ9 `crowdout'_occ10 `crowdout'_occ12 ///
							   `crowdout'_occ13 `crowdout'_occ14 `crowdout'_occ15 `crowdout'_occ16 ///
							   `crowdout'_occ17 `crowdout'_occ18 `crowdout'_occ19 `crowdout'_occ23 ///
							   `crowdout'_occ24 `crowdout'_occ25 `crowdout'_occ26 `crowdout'_occ27 ///
							   `crowdout'_occ28 `crowdout'_occ29 `crowdout'_occ31 `crowdout'_occ32 ///
							   `crowdout'_occ33 `crowdout'_occ34 `crowdout'_occ35 `crowdout'_occ36 ///
							   `crowdout'_occ41 `crowdout'_occ42 `crowdout'_occ43 `crowdout'_occ44 ///
							   `crowdout'_occ45 `crowdout'_occ46 `crowdout'_occ47 `crowdout'_occ48 ///
							   `crowdout'_occ49 `crowdout'_occ51 `crowdout'_occ52 `crowdout'_occ53 ///
							   `crowdout'_occ54 `crowdout'_occ55 `crowdout'_occ56 `crowdout'_occ57 ///
							   `crowdout'_occ58 `crowdout'_occ59 `crowdout'_occ61 `crowdout'_occ62 ///
							   `crowdout'_occ63 `crowdout'_occ67 `crowdout'_occ68 `crowdout'_occ69 ///
							   `crowdout'_occ70 `crowdout'_occ71 `crowdout'_occ72 `crowdout'_occ73 ///
							   `crowdout'_occ74 `crowdout'_occ75 `crowdout'_occ76 `crowdout'_occ77 ///
							   `crowdout'_occ78 `crowdout'_occ79 `crowdout'_occ81 `crowdout'_occ82 ///
							   `crowdout'_occ83 `crowdout'_occ84 `crowdout'_occ91 `crowdout'_occ92 ///
							   `crowdout'_occ93 `crowdout'_occ94 `crowdout'_occ95 `crowdout'_occ96 ///
							   `crowdout'_occ97 `crowdout'_occ98 `crowdout'_occ99 ///
							   `crowdout'_occ300 `crowdout'_occ301 `crowdout'_occ302 `crowdout'_occ304 ///
							   `crowdout'_occ305 `crowdout'_occ310 `crowdout'_occ320 `crowdout'_occ321 ///
							   `crowdout'_occ322 `crowdout'_occ325 `crowdout'_occ335 `crowdout'_occ340 ///
							   `crowdout'_occ341 `crowdout'_occ342 `crowdout'_occ350 `crowdout'_occ360 ///
							   `crowdout'_occ365 `crowdout'_occ370 `crowdout'_occ380 `crowdout'_occ390 ///
							   `crowdout'_occ400 `crowdout'_occ410 `crowdout'_occ420 `crowdout'_occ430 ///
							   `crowdout'_occ450 `crowdout'_occ460 `crowdout'_occ470 `crowdout'_occ480 ///
							   `crowdout'_occ490) if year > 1890, missing

}


*------------------------------------------------------------------------------*
* Drop the per-occupation crowdout cells now that the aggregates are built
*------------------------------------------------------------------------------*

drop co_*_occ*


*==============================================================================*
* 3. Controls and base-year snapshots
*
* Attaches Knights-of-Labor and IWW union counts; builds occupation/industry/
* demographic control shares; merges the CPI series and produces interpolated
* and deflated manufacturing measures; constructs Logan-Parman (2017)
* residential segregation; snapshots all the
* control variables to 1880, 1890, and 1900 baselines for use as
* pre-treatment regressors; computes election vote shares and the
* Know-Nothing 1856 share; computes the 1890 share of US European
* immigrants residing in each county; and attaches railroad-connection year
* (Atack 2016).
*==============================================================================*


*------------------------------------------------------------------------------*
* Knights of Labor and IWW counts
*------------------------------------------------------------------------------*

**Add data on 1880 and 1890 nr of locals of Knights of Labor
merge 1:1 year countynhg_1930 using "$intmdata/KOL_locals_1880-1890_county1930"
drop if _merge == 2
replace locals_kol = 0 if _merge == 1 & inlist(year,1880,1890) == 1
drop _merge

**Add data on 1906-1917 nr of locals of IWW
merge m:1 countynhg_1930 using "$intmdata/IWW_unions_1906-1917_county1930.dta"
drop if _merge == 2
replace IWW_locals = 0 if _merge == 1
rename IWW_locals locals_IWW_0617
gen d_IWW_0617 = (locals_IWW_0617 > 0) if locals_IWW_0617 != .
drop _merge


*------------------------------------------------------------------------------*
* Control variables: occupation/industry/demographic shares
*------------------------------------------------------------------------------*

**Control variables
foreach sector in carpen miner machinist brickl typogr ///
				  midskill1 midskill1alt midskill2 midskill2alt highskill1 highskill2 lowskill lowskillalt {
	gen `sector'_share_m = all_lf_`sector'_m / all_lf_tot_m
}

egen all_lf_indtot_m = rowtotal(all_lf_agric_m all_lf_mining_m all_lf_constr_m all_lf_mfg_m ///
								all_lf_transp_m all_lf_trade_m all_lf_fin_m all_lf_biz_m ///
								all_lf_persserv_m all_lf_ent_m all_lf_profserv_m all_lf_pubadm_m), missing
foreach sector in agric mining constr mfg transp trade fin biz persserv ent profserv pubadm {
	gen `sector'_share_m = all_lf_`sector'_m / all_lf_indtot_m
}

gen urban_share_mw 		= all_urbanpop_mw / all_totpop_mw
gen euro_imm_share_mw	= euro_imm_totpop_mw / all_totpop_mw
gen imm_share_mw		= imm_totpop_mw / all_totpop_mw
gen black_share_mw		= black_totpop_mw / all_totpop_mw
gen log_popdens_mw		= log(all_totpop_mw/area)
gen lf_share_m			= all_lf_tot_m / all_totpop_m

gen lfpartrate_m = all_lf_tot_m / all_wkgagepop_m

gen farmarea_share		= farmarea / area
gen farmfams_share		= nr_farmfams / nr_fams


*------------------------------------------------------------------------------*
* CPI merge; manufacturing interpolation and deflation
*------------------------------------------------------------------------------*

***Merge with CPI
merge m:1 year using "$intmdata/cpi_u.dta"
drop if _merge == 2
drop _merge

***Interpolate values for 1910: the 1910 Census of Manufacturing was not
***published at the county level, so the 1910 mfg measures are filled from
***the 1900 and 1920 census-of-manufacturing observations.
xtset countynhg_1930 year

foreach var of varlist mfgwages* mfgout mfgestab mfglabor_* {
gen 	`var'_ip = `var'
replace	`var'_ip = (l10.`var' + f10.`var') / 2 ///
					  if year == 1910
}

***Deflate variables (in 1900 USD)
foreach var of varlist mfgwages*_ip mfgout_ip {
	gen `var'_defl = `var' * (25 / cpi_u_1967)
}

***Interpolate values of mfg labor from mfg Census if mfg labor appears as zero, but mfg wages are positive

foreach s in m w mw {

replace	mfglabor_`s'_ip = (l10.mfglabor_`s' + f10.mfglabor_`s') / 2 ///
					  if year == 1890 & mfglabor_`s' == 0 & mfgwages_`s' != .
replace	mfglabor_`s'_ip = mfglabor_`s' if mfglabor_`s' != . & mfglabor_`s'_ip == .

}

***Generate per-worker variables for mfg
foreach s in m w mw {

gen 	mfgwages_pw_`s'_ip_defl			= mfgwages_`s'_ip_defl / mfglabor_`s'_ip
replace	mfgwages_pw_`s'_ip_defl			= 0 if mfglabor_`s'_ip == 0 & mfgwages_`s'_ip_defl == 0

gen		mfgout_pw_`s'_ip_defl			= mfgout_ip_defl / mfglabor_`s'_ip
replace	mfgout_pw_`s'_ip_defl			= 0 if mfglabor_`s'_ip == 0 & mfgout_ip_defl == 0

gen		mfgestab_pw_ip_`s'				= mfgestab_ip / mfglabor_`s'_ip
replace mfgestab_pw_ip_`s'				= 0 if mfglabor_`s'_ip == 0 & mfgestab_ip == 0

gen 	mfglabor_share_`s'				= mfglabor_`s'_ip / all_totpop_`s'

}

gen log_all_occsc_m = log(all_occsc_n_m / all_occsc_d_m)


*------------------------------------------------------------------------------*
* Knights-of-Labor locals per population
*------------------------------------------------------------------------------*

**Locals of KOL divided by male population
gen locals_kol_perpop = locals_kol / all_totpop_m if inlist(year,1880,1890) == 1
gen locals_kol_perurbpop = locals_kol / all_urbanpop_mw if inlist(year,1880,1890) == 1


*------------------------------------------------------------------------------*
* Logan-Parman (2017) residential segregation index
*------------------------------------------------------------------------------*

foreach group in euro {
foreach j in enum {

gen `group'_natneighb_`j'_ub = `group'_2neighb_`j' * (1 - (`group'_hh + other_hh - 1)/(all_hh - 1) * (`group'_hh + other_hh - 2)/(all_hh - 2)) + ///
						`group'_1neighb_`j' * (1 - (`group'_hh + other_hh - 1)/(all_hh - 1))
replace `group'_natneighb_`j'_ub = . if `group'_natneighb_`j'_ub < 0

gen `group'_natneighb_`j'_lb = 2*(`group'_2neighb_`j'/`group'_hh) + 1*(`group'_1neighb_`j'/`group'_hh) if `group'_natneighb_`j'_ub != .
replace `group'_natneighb_`j'_lb = . if `group'_natneighb_`j'_lb >= `group'_natneighb_`j'_ub & `group'_natneighb_`j'_lb != .
replace `group'_natneighb_`j'_lb = `group'_natneighb_`j' if `group'_natneighb_`j'_lb > `group'_natneighb_`j' & `group'_natneighb_`j'_lb != .


gen resid_segr_`group'_`j'_n = (`group'_natneighb_`j'_ub - `group'_natneighb_`j')
replace resid_segr_`group'_`j'_n = 0 if `group'_natneighb_`j'_ub < `group'_natneighb_`j' 				// adjustment for rounding from the county border adjustments

gen resid_segr_`group'_`j'_d = (`group'_natneighb_`j'_ub - `group'_natneighb_`j'_lb)
replace resid_segr_`group'_`j'_d = . if resid_segr_`group'_`j'_d > 0 & resid_segr_`group'_`j'_d < 1		// adjustment for rounding from the county border adjustments

gen resid_segr_`group'_`j'_1880_tp = resid_segr_`group'_`j'_n / resid_segr_`group'_`j'_d
bysort countynhg_1930 (year): gegen resid_segr_`group'_`j'_1880 = max(resid_segr_`group'_`j'_1880_tp)
drop resid_segr_`group'_`j'_n resid_segr_`group'_`j'_d resid_segr_`group'_`j'_1880_tp

}
}


*------------------------------------------------------------------------------*
* Base-year snapshots: 1900, 1880, 1890 + asinh transforms
*------------------------------------------------------------------------------*

***Generate base-year variables (for 1880, 1890, 1900)
foreach var of varlist	all_totpop_mw log_popdens_*mw all_totpop_m all_lf_tot_m all_lf_miner_m ///
						all_lf_carpen_m all_lf_machinist_m all_lf_typogr_m ///
						all_lf_afl*_m ///
						all_urbanpop_mw imm_totpop_mw euro_imm_totpop_mw *_share_m *_share_mw lfpartrate_m log_all_occsc_m ///
						mfgestab_ip mfgestab_pw_ip_m mfgestab_pw_ip_w mfgestab_pw_ip_mw ///
						mfgwages*_m_ip_defl mfgwages*_w_ip_defl mfgwages*_mw_ip_defl ///
						mfgout_ip_defl mfgout*_m_ip_defl mfgout*_w_ip_defl mfgout*_mw_ip_defl {

foreach year in 1900 {

	gen `var'_`year'_temp = `var' if year == `year'
	bysort countynhg_1930 (year): gegen `var'_`year' = max(`var'_`year'_temp)
	drop `var'_`year'_temp

	gen log_`var'_`year' = log(1 + `var'_`year')

}
}

foreach var of varlist	all_totpop_mw log_popdens_*mw all_totpop_m all_lf_tot_m all_lf_miner_m ///
						all_lf_carpen_m all_lf_machinist_m all_lf_typogr_m ///
						all_lf_afl*_m ///
						all_urbanpop_mw imm_totpop_mw euro_imm_totpop_mw *_share_m *_share_mw lfpartrate_m log_all_occsc_m ///
						mfgestab_ip mfgestab_pw_ip_m mfgestab_pw_ip_w mfgestab_pw_ip_mw ///
						mfgwages*_m_ip_defl mfgwages*_w_ip_defl mfgwages*_mw_ip_defl ///
						mfgout_ip_defl mfgout*_m_ip_defl mfgout*_w_ip_defl mfgout*_mw_ip_defl ///
						locals_kol locals_kol_perpop locals_kol_perurbpop {

foreach year in 1880 {

	gen `var'_`year'_temp = `var' if year == `year'
	bysort countynhg_1930 (year): gegen `var'_`year' = max(`var'_`year'_temp)
	drop `var'_`year'_temp

}
}

foreach var of varlist all_totpop_mw imm_totpop_mw euro_imm_totpop_mw all_lf_tot_m ///
					   mfgestab_ip mfgestab_pw_ip_m mfgestab_pw_ip_w mfgestab_pw_ip_mw ///
					   mfgwages*_m_ip_defl mfgwages*_w_ip_defl mfgwages*_mw_ip_defl ///
					   mfgout_ip_defl mfgout*_m_ip_defl mfgout*_w_ip_defl mfgout*_mw_ip_defl ///
					   locals_kol locals_kol_perpop locals_kol_perurbpop {
	gen ihs_`var'_1880 = asinh(`var'_1880)
}


foreach var of varlist all_totpop_mw log_popdens_*mw all_totpop_m all_urbanpop_mw black_totpop_mw imm_totpop_mw ///
					   euro_imm_totpop_mw urban_share_mw imm_share_mw euro_imm_share_mw black_share_mw ///
					   mfgestab_ip mfgestab_pw_ip_m mfgestab_pw_ip_w mfgestab_pw_ip_mw ///
					   mfgwages*_m_ip_defl mfgwages*_w_ip_defl mfgwages*_mw_ip_defl ///
					   mfgout_ip_defl mfgout*_m_ip_defl mfgout*_w_ip_defl mfgout*_mw_ip_defl ///
					   mfglabor_share_m mfglabor_share_w mfglabor_share_mw ///
					   farmarea_share farmfams_share ///
					   locals_kol locals_kol_perpop locals_kol_perurbpop ///
					   coalmines_reg coalmines_loc coalmines_tot {

foreach year in 1890 {

	gen `var'_`year'_temp = `var' if year == `year'
	bysort countynhg_1930 (year): gegen `var'_`year' = max(`var'_`year'_temp)
	drop `var'_`year'_temp

}
}

foreach var of varlist all_totpop_mw imm_totpop_mw euro_imm_totpop_mw ///
					   mfgestab_ip mfgestab_pw_ip_m mfgestab_pw_ip_w mfgestab_pw_ip_mw ///
					   mfgwages*_m_ip_defl mfgwages*_w_ip_defl mfgwages*_mw_ip_defl ///
					   mfgout_ip_defl mfgout*_m_ip_defl mfgout*_w_ip_defl mfgout*_mw_ip_defl ///
					   locals_kol locals_kol_perpop locals_kol_perurbpop ///
					   coalmines_reg coalmines_loc coalmines_tot {
	gen ihs_`var'_1890 = asinh(`var'_1890)
}


*------------------------------------------------------------------------------*
* Election vote shares; Know-Nothing 1856 share
*------------------------------------------------------------------------------*

**Election vote shares (controls and outcomes)
foreach party in dem soc {
forvalues year=1888(4)1924 {
	gen `party'share_`year'_temp = `party'vote_`year' / totvote_`year'
}
foreach year in 1888 1892 1896 {
	bysort countynhg_1930 (year): gegen `party'share_`year' = max(`party'share_`year'_temp)
}

gegen `party'share_avg_1890 = rowmean(`party'share_1892_temp `party'share_1896_temp)
gegen `party'share_avg_1900 = rowmean(`party'share_1900_temp `party'share_1904_temp)
gegen `party'share_avg_1910 = rowmean(`party'share_1912_temp `party'share_1916_temp)
gegen `party'share_avg_1920 = rowmean(`party'share_1920_temp `party'share_1924_temp)

gen 	`party'share_avg = .
foreach year in 1890 1900 1910 1920 {
replace `party'share_avg = `party'share_avg_`year' if year == `year'
}
drop `party'share_avg_* `party'share_*_temp
}


foreach j in knownotvote totvote {
	replace `j'_1856 = . if year != 1890
	rename `j'_1856 `j'_1856_temp
	bysort countynhg_1930 (year): egen `j'_1856 = max(`j'_1856_temp)
}
gen knownotshare_1856 = knownotvote_1856 / totvote_1856


*------------------------------------------------------------------------------*
* 1890 share of US European immigrants residing in each county
*------------------------------------------------------------------------------*

***Number of Euro immigrants in county c as a share of all immigrants in the US, in 1890
gegen euro_imm_mw_US_1890_temp = total(norway_mw denmark_mw sweden_mw uk_mw ireland_mw ///
									   belgium_mw france_mw luxemb_mw nether_mw switz_mw ///
									   italy_mw gr_pt_es_mw ///
									   aus_hung_mw czech_mw germany_mw poland_mw ///
									   russia_mw) if year == 1890
gegen euro_imm_mw_US_1890 = max(euro_imm_mw_US_1890_temp)

gen sh_euro_mw_1890_temp = euro_imm_totpop_mw_1890 / euro_imm_mw_US_1890 if year == 1890
bysort countynhg_1930 (year): gegen sh_euro_mw_1890 = max(sh_euro_mw_1890_temp)

drop euro_imm_mw_US_1890_temp sh_euro_mw_1890_temp


*------------------------------------------------------------------------------*
* Railroad connection (Atack 2016)
*------------------------------------------------------------------------------*

merge m:1 countynhg_1930 using  "$intmdata/railroad_connection_1930countyboundaries.dta", keepusing(year_conn_rr)
drop if _merge == 2
drop _merge

gen 	rail_conn_nryears_1890 = (1890 - year_conn_rr)							// nr. of years since connection to rr as of 1890
replace rail_conn_nryears_1890 = 0 if year_conn_rr > 1890

gen 	rail_conn_1890 = (year_conn_rr < 1890)									//= 1 if connected to rr as of 1890



*==============================================================================*
* 4. Union measures: combined union counts and densities
*
* Merges the combined union membership and locals counts (built by the
* build_documentation/ stage, b12_unions_combine, and shipped at
* data/public/unions/unions_combined_county1930.csv) and constructs union
* densities -- membership over the corresponding occupational labor force -- for
* each county and census year.
*==============================================================================*

preserve
import delimited "$rawdata/unions/unions_combined_county1930.csv", clear case(preserve)
tempfile unions_comb
save `unions_comb'
restore
merge 1:1 year countynhg_1930 using `unions_comb'
drop if _merge == 2
drop _merge
xtset countynhg_1930 year

*------------------------------------------------------------------------------*
* Per-union densities (UMWA, UBC, IAM, BMPIU, ITU)
*
* Denominator is the corresponding occupational labor force built in
* section 1 (miners, carpenters, machinists, bricklayers, typographers).
* Densities capped at 1 (occasional small-county overshoots).
*------------------------------------------------------------------------------*

*UMWA
foreach j in votes {
gen 	umwa_density_`j' 	 = umwa_memb_proxy_`j' / all_lf_mining_m
replace umwa_density_`j' 	 = 1 if umwa_density_`j' > 1 & umwa_density_`j' != .
}

foreach var of varlist umwa_density* {
	gen log_`var' = log(1 + `var')
}

*UBC
gen 	ubc_density_votes = ubc_memb_proxy_votes / all_lf_carpen_m
replace ubc_density_votes = 1 if ubc_density_votes > 1 & ubc_density_votes != .

foreach var of varlist ubc_density* {
	gen log_`var' = log(1 + `var')
}

*IAM
gen 	iam_density_votes = iam_memb_proxy_votes / all_lf_machinist_m
replace iam_density_votes = 1 if iam_density_votes > 1 & iam_density_votes != .

foreach var of varlist iam_density* {
	gen log_`var' = log(1 + `var')
}

*BMPIU
gen 	bmpiu_density_votes = bmpiu_memb_proxy_votes / all_lf_brickl_m
replace bmpiu_density_votes = 1 if bmpiu_density_votes > 1 & bmpiu_density_votes != .

foreach var of varlist bmpiu_density* {
	gen log_`var' = log(1 + `var')
}

*ITU
gen 	itu_density_votes = itu_members / all_lf_typogr_m
replace itu_density_votes = 1 if itu_density_votes > 1 & itu_density_votes != .

foreach var of varlist itu_density* {
	gen log_`var' = log(1 + `var')
}


*------------------------------------------------------------------------------*
* State-year groups
*------------------------------------------------------------------------------*

egen state_year = group(statefip year)


*------------------------------------------------------------------------------*

foreach i in all comb {

gen afl_`i'_density				= (afl_members_`i') / (all_lf_highskill2_m + all_lf_midskill2_m + all_lf_lowskill_m) if inlist(year,1900,1910,1920)

gen afl_`i'_density_2			= (afl_members_`i') / all_lf_nonfarm_m if inlist(year,1900,1910,1920)
gen afl_`i'_density_3			= (afl_members_`i') / all_lf_tot_m 		if inlist(year,1900,1910,1920)
gen afl_`i'_density_4			= (afl_members_`i') / (all_lf_tot_m + all_lf_tot_w)	if inlist(year,1900,1910,1920)

gen afl_`i'_locperlf			= ((afl_locals_`i') / (all_lf_highskill2_m + all_lf_midskill2_m + all_lf_lowskill_m)) * 1000 if inlist(year,1900,1910,1920)

}


foreach i in sk {

gen afl_comb_`i'_density		= (afl_members_comb_`i') / (all_lf_highskill2_m + all_lf_midskill2_m) if inlist(year,1900,1910,1920)

gen afl_comb_`i'_density_2		= (afl_members_comb_`i') / (all_lf_nonfarm_m) if inlist(year,1900,1910,1920)
gen afl_comb_`i'_density_3		= (afl_members_comb_`i') / (all_lf_tot_m)	   if inlist(year,1900,1910,1920)
gen afl_comb_`i'_density_4		= (afl_members_comb_`i') / (all_lf_tot_m + all_lf_tot_w)	   if inlist(year,1900,1910,1920)


gen afl_`i'_density				= (afl_members_`i') / (all_lf_highskill2_m + all_lf_midskill2_m) if inlist(year,1900,1910,1920)

gen afl_`i'_density_2			= (afl_members_`i') / (all_lf_nonfarm_m) if inlist(year,1900,1910,1920)
gen afl_`i'_density_3			= (afl_members_`i') / (all_lf_tot_m)	   if inlist(year,1900,1910,1920)
gen afl_`i'_density_4			= (afl_members_`i') / (all_lf_tot_m + all_lf_tot_w)	   if inlist(year,1900,1910,1920)


gen afl_comb_`i'_locperlf		= ((afl_locals_comb_`i') / (all_lf_highskill2_m + all_lf_midskill2_m)) * 1000 if inlist(year,1900,1910,1920)
gen afl_`i'_locperlf			= ((afl_locals_`i') / (all_lf_highskill2_m + all_lf_midskill2_m)) * 1000 if inlist(year,1900,1910,1920)

}

foreach i in unsk {

gen afl_comb_`i'_density		= (afl_members_comb_`i') / (all_lf_lowskill_m) if inlist(year,1900,1910,1920)

gen afl_comb_`i'_density_2		= (afl_members_comb_`i') / (all_lf_nonfarm_m) if inlist(year,1900,1910,1920)
gen afl_comb_`i'_density_3		= (afl_members_comb_`i') / (all_lf_tot_m)	   if inlist(year,1900,1910,1920)
gen afl_comb_`i'_density_4		= (afl_members_comb_`i') / (all_lf_tot_m + all_lf_tot_w)	   if inlist(year,1900,1910,1920)


gen afl_`i'_density				= (afl_members_`i') / (all_lf_lowskill_m) if inlist(year,1900,1910,1920)

gen afl_`i'_density_2			= (afl_members_`i') / (all_lf_nonfarm_m) if inlist(year,1900,1910,1920)
gen afl_`i'_density_3			= (afl_members_`i') / (all_lf_tot_m)	   if inlist(year,1900,1910,1920)
gen afl_`i'_density_4			= (afl_members_`i') / (all_lf_tot_m + all_lf_tot_w)	   if inlist(year,1900,1910,1920)


gen afl_comb_`i'_locperlf		= ((afl_locals_comb_`i') / (all_lf_lowskill_m)) * 1000 if inlist(year,1900,1910,1920)
gen afl_`i'_locperlf			= ((afl_locals_`i') / (all_lf_lowskill_m)) * 1000 if inlist(year,1900,1910,1920)


}


gen umwa_combined_density		= (umwa_members_combined) / all_lf_miner_m if inlist(year,1900,1910,1920)
gen ubc_combined_density		= (ubc_members_combined) / all_lf_carpen_m if inlist(year,1900,1910,1920)
gen iam_combined_density		= (iam_members_combined) / all_lf_machinist_m if inlist(year,1900,1910,1920)
gen bmpiu_combined_density		= (bmpiu_members_combined) / all_lf_brickl_m if inlist(year,1900,1910,1920)
gen itu_combined_density		= (itu_members_combined) / all_lf_typogr_m if inlist(year,1900,1910,1920)


gen		afl_ubc_density			= (afl_members_ubc) / all_lf_carpen_m if inlist(year,1900,1910,1920)
gen		afl_iam_density			= (afl_members_iam) / all_lf_machinist_m if inlist(year,1900,1910,1920)
gen 	afl_bmpiu_density		= (afl_members_bmpiu) / all_lf_brickl_m if inlist(year,1900,1910,1920)
gen 	afl_itu_density			= (afl_members_itu) / all_lf_typogr_m if inlist(year,1900,1910,1920)
gen 	afl_ibt_density			= (afl_members_ibt) / all_lf_teamster_m if inlist(year,1900,1910,1920)

gen		afl_umwa_density		= (afl_members_umwa) / all_lf_miner_m if inlist(year,1900,1910,1920)

gen 	afl_brca_density		= (afl_members_brca) / all_lf_carman_m if inlist(year,1900,1910,1920)

gen		afl_aaser_density		= (afl_members_aaser) / all_lf_streetrail_m if inlist(year,1900,1910,1920)

gen 	afl_bpd_density			= (afl_members_bpd) / all_lf_painter_m if inlist(year,1900,1910,1920)
gen 	afl_brsc_density		= (afl_members_brsc) / all_lf_ryclerk_m if inlist(year,1900,1910,1920)
gen 	afl_ibew_density		= (afl_members_ibew) / all_lf_electrical_m if inlist(year,1900,1910,1920)

gen		afl_utw_density			= (afl_members_utw) / all_lf_textlab_m if inlist(year,1900,1910,1920)
gen		afl_ugwa_density		= (afl_members_ugwa) / all_lf_textlab_m if inlist(year,1900,1910,1920)
gen		afl_amc_density			= (afl_members_amc) / all_lf_meatlab_m if inlist(year,1900,1910,1920)
gen		afl_brew_density		= (afl_members_brew) / all_lf_beverlab_m if inlist(year,1900,1910,1920)
gen		afl_ila_density			= (afl_members_ila) / all_lf_longshoreman_m if inlist(year,1900,1910,1920)
gen		afl_iummsw_density		= (afl_members_iummsw) / all_lf_miner_m if inlist(year,1900,1910,1920)


foreach var of varlist afl_*_density afl_*_density_* umwa_combined_density ubc_combined_density ///
					   iam_combined_density bmpiu_combined_density itu_combined_density {
replace `var' = 1 if `var' > 1 & `var' != .
}


*------------------------------------------------------------------------------*
* Final rename cascade and save
*------------------------------------------------------------------------------*

rename (*_members_combined) (afl_memb_comb_*)
rename (*_combined_density*) (*_comb_dens*)
rename (*_locals_combined*) (*_comb_locals*)
rename (*_locals_comb*) (*_comb_locals*)
rename (afl_*_density*) (afl_*_dens*)
rename (*members*) (*memb*)
rename (afl_memb_comb*) (afl_comb_memb*)

foreach union in ubc iam bmpiu itu umwa {
rename `union'_comb_dens* afl_comb_`union'_dens*
rename `union'_comb_locals afl_comb_`union'_locals
}

rename (afl_comb_dens* *afl_comb_locals afl_comb_memb) (afl_comb_all_dens* *afl_comb_locals_all afl_comb_memb_all)
rename afl_comb_*_locals afl_comb_locals_*
rename afl_comb_locperlf afl_comb_all_locperlf



* Restrict to the variables used by the analysis: the county-year construction
* intermediates dropped below (per-country shift-share / weather instrument
* components, women-only census counts, per-worker manufacturing figures, and
* unused transforms) are not read by any analysis step.
unab present : _all
local dropvars ///
    nat_lf_tot_w nat_lf_mining_w nat_lf_craft_w nat_lf_farmer_w nat_lf_farmlab_w nat_np_lf_tot_w nat_np_lf_mining_w nat_np_lf_craft_w ///
    nat_np_lf_farmer_w nat_np_lf_farmlab_w euro_imm_lf_tot_w euro_imm_lf_mining_w euro_imm_lf_craft_w euro_imm_lf_farmer_w euro_imm_lf_farmlab_w all_occsc_n_w ///
    nat_np_occsc_n_w all_occsc_d_w nat_np_occsc_d_w all_totpop_w imm_totpop_w euro_imm_totpop_w all_urbanpop_w imm_urbanpop_w ///
    euro_imm_urbanpop_w all_wkgagepop_w imm_wkgagepop_w euro_imm_wkgagepop_w imm_totpop_mw euro_imm_totpop_mw all_urbanpop_mw imm_urbanpop_mw ///
    euro_imm_urbanpop_mw imm_wkgagepop_mw mfgout mfgestab mfglabor_mw mfglabor_w mfgwages_mw mfgwages_w ///
    euro_hh euro_natneighb_enum euro_1neighb_enum euro_2neighb_enum other_hh all_hh finland_w norway_w ///
    sweden_w uk_w ireland_w oth_northeu_w belgium_w france_w luxemb_w nether_w ///
    switz_w oth_westeu_w italy_w gr_pt_es_w oth_southeu_w aus_hung_w czech_w germany_w ///
    poland_w oth_easteu_w oth_centereu_w russia_w oth_russeu_w finland_mw norway_mw sweden_mw ///
    uk_mw ireland_mw oth_northeu_mw belgium_mw france_mw luxemb_mw nether_mw switz_mw ///
    oth_westeu_mw italy_mw gr_pt_es_mw oth_southeu_mw aus_hung_mw czech_mw germany_mw poland_mw ///
    oth_easteu_mw oth_centereu_mw russia_mw oth_russeu_mw finland oth_northeu oth_westeu oth_southeu ///
    oth_easteu oth_centereu oth_russeu farmarea socvote_1888 knownotvote_1888 socvote_1892 knownotvote_1892 ///
    knownotvote_1856_temp coalmines_reg coalmines_tot finland_10yr_w finland_wkgage_10yr_w norway_10yr_w norway_wkgage_10yr_w sweden_10yr_w ///
    sweden_wkgage_10yr_w uk_10yr_w uk_wkgage_10yr_w ireland_10yr_w ireland_wkgage_10yr_w oth_northeu_10yr_w oth_northeu_wkgage_10yr_w belgium_10yr_w ///
    belgium_wkgage_10yr_w france_10yr_w france_wkgage_10yr_w luxemb_10yr_w luxemb_wkgage_10yr_w nether_10yr_w nether_wkgage_10yr_w switz_10yr_w ///
    switz_wkgage_10yr_w oth_westeu_10yr_w oth_westeu_wkgage_10yr_w italy_10yr_w italy_wkgage_10yr_w gr_pt_es_10yr_w gr_pt_es_wkgage_10yr_w oth_southeu_10yr_w ///
    oth_southeu_wkgage_10yr_w aus_hung_10yr_w aus_hung_wkgage_10yr_w czech_10yr_w czech_wkgage_10yr_w germany_10yr_w germany_wkgage_10yr_w poland_10yr_w ///
    poland_wkgage_10yr_w oth_easteu_10yr_w oth_easteu_wkgage_10yr_w oth_centereu_10yr_w oth_centereu_wkgage_10yr_w russia_10yr_w russia_wkgage_10yr_w oth_russeu_10yr_w ///
    oth_russeu_wkgage_10yr_w finland_10yr_mw norway_10yr_mw sweden_10yr_mw uk_10yr_mw ireland_10yr_mw oth_northeu_10yr_mw belgium_10yr_mw ///
    france_10yr_mw luxemb_10yr_mw nether_10yr_mw switz_10yr_mw oth_westeu_10yr_mw italy_10yr_mw gr_pt_es_10yr_mw oth_southeu_10yr_mw ///
    aus_hung_10yr_mw czech_10yr_mw germany_10yr_mw poland_10yr_mw oth_easteu_10yr_mw oth_centereu_10yr_mw russia_10yr_mw oth_russeu_10yr_mw ///
    socvote_1896 knownotvote_1896 socvote_1900 knownotvote_1900 socvote_1904 knownotvote_1904 socvote_1908 knownotvote_1908 ///
    socvote_1912 knownotvote_1912 socvote_1916 knownotvote_1916 socvote_1920 knownotvote_1920 socvote_1924 knownotvote_1924 ///
    finland_wa_10yr_w norway_wa_10yr_w sweden_wa_10yr_w uk_wa_10yr_w ireland_wa_10yr_w oth_northeu_wa_10yr_w belgium_wa_10yr_w france_wa_10yr_w ///
    luxemb_wa_10yr_w nether_wa_10yr_w switz_wa_10yr_w oth_westeu_wa_10yr_w italy_wa_10yr_w gr_pt_es_wa_10yr_w oth_southeu_wa_10yr_w aus_hung_wa_10yr_w ///
    czech_wa_10yr_w germany_wa_10yr_w poland_wa_10yr_w oth_easteu_wa_10yr_w oth_centereu_wa_10yr_w russia_wa_10yr_w oth_russeu_wa_10yr_w norway_US_wa_10yr_w ///
    finland_US_wa_10yr_w sweden_US_wa_10yr_w uk_US_wa_10yr_w ireland_US_wa_10yr_w oth_northeu_US_wa_10yr_w belgium_US_wa_10yr_w france_US_wa_10yr_w luxemb_US_wa_10yr_w ///
    nether_US_wa_10yr_w switz_US_wa_10yr_w oth_westeu_US_wa_10yr_w italy_US_wa_10yr_w gr_pt_es_US_wa_10yr_w oth_southeu_US_wa_10yr_w aus_hung_US_wa_10yr_w czech_US_wa_10yr_w ///
    germany_US_wa_10yr_w poland_US_wa_10yr_w oth_easteu_US_wa_10yr_w oth_centereu_US_wa_10yr_w russia_US_wa_10yr_w oth_russeu_US_wa_10yr_w nonprot_wa_10yr_w newsend_wa_10yr_w ///
    oldsend_wa_10yr_w lingfar_wa_10yr_w lingclose_wa_10yr_w nonsoc10_wa_10yr_w soc10_wa_10yr_w nonsoc10r_wa_10yr_w soc10r_wa_10yr_w nonsoc20_wa_10yr_w ///
    soc20_wa_10yr_w nonsoc20r_wa_10yr_w soc20r_wa_10yr_w unionh_wa_10yr_w unionl_wa_10yr_w unionh_2_wa_10yr_w unionl_2_wa_10yr_w farmarea_share ///
    farmfams_share cpi_u_1967 mfgwages_mw_ip mfgwages_m_ip mfgwages_w_ip mfgout_ip mfgestab_ip mfglabor_m_ip ///
    mfglabor_w_ip mfgwages_mw_ip_defl mfgwages_m_ip_defl mfgwages_w_ip_defl mfgwages_pw_m_ip_defl mfgout_pw_m_ip_defl mfgwages_pw_w_ip_defl mfgout_pw_w_ip_defl ///
    mfgestab_pw_ip_w mfglabor_share_w mfgwages_pw_mw_ip_defl mfgestab_pw_ip_mw euro_natneighb_enum_ub euro_natneighb_enum_lb all_totpop_mw_1900 log_all_totpop_mw_1900 ///
    log_popdens_mw_1900 log_log_popdens_mw_1900 all_totpop_m_1900 log_all_totpop_m_1900 log_all_lf_tot_m_1900 log_all_lf_miner_m_1900 log_all_lf_carpen_m_1900 log_all_lf_machinist_m_1900 ///
    log_all_lf_typogr_m_1900 log_all_lf_afloccs_m_1900 all_urbanpop_mw_1900 log_all_urbanpop_mw_1900 imm_totpop_mw_1900 log_imm_totpop_mw_1900 euro_imm_totpop_mw_1900 log_euro_imm_totpop_mw_1900 ///
    carpen_share_m_1900 log_carpen_share_m_1900 miner_share_m_1900 log_miner_share_m_1900 machinist_share_m_1900 log_machinist_share_m_1900 brickl_share_m_1900 log_brickl_share_m_1900 ///
    log_typogr_share_m_1900 midskill1_share_m_1900 log_midskill1_share_m_1900 midskill1alt_share_m_1900 log_midskill1alt_share_m_1900 midskill2_share_m_1900 log_midskill2_share_m_1900 midskill2alt_share_m_1900 ///
    log_midskill2alt_share_m_1900 highskill1_share_m_1900 log_highskill1_share_m_1900 highskill2_share_m_1900 log_highskill2_share_m_1900 lowskill_share_m_1900 log_lowskill_share_m_1900 lowskillalt_share_m_1900 ///
    log_lowskillalt_share_m_1900 agric_share_m_1900 log_agric_share_m_1900 mining_share_m_1900 log_mining_share_m_1900 constr_share_m_1900 log_constr_share_m_1900 mfg_share_m_1900 ///
    log_mfg_share_m_1900 log_transp_share_m_1900 log_trade_share_m_1900 fin_share_m_1900 log_fin_share_m_1900 biz_share_m_1900 log_biz_share_m_1900 persserv_share_m_1900 ///
    log_persserv_share_m_1900 ent_share_m_1900 log_ent_share_m_1900 log_profserv_share_m_1900 pubadm_share_m_1900 log_pubadm_share_m_1900 lf_share_m_1900 log_lf_share_m_1900 ///
    mfglabor_share_m_1900 log_mfglabor_share_m_1900 urban_share_mw_1900 log_urban_share_mw_1900 euro_imm_share_mw_1900 log_euro_imm_share_mw_1900 imm_share_mw_1900 log_imm_share_mw_1900 ///
    log_black_share_mw_1900 mfglabor_share_mw_1900 log_mfglabor_share_mw_1900 lfpartrate_m_1900 log_lfpartrate_m_1900 log_all_occsc_m_1900 log_log_all_occsc_m_1900 mfgestab_ip_1900 ///
    log_mfgestab_ip_1900 mfgestab_pw_ip_m_1900 log_mfgestab_pw_ip_m_1900 mfgestab_pw_ip_w_1900 log_mfgestab_pw_ip_w_1900 mfgestab_pw_ip_mw_1900 log_mfgestab_pw_ip_mw_1900 mfgwages_m_ip_defl_1900 ///
    log_mfgwages_m_ip_defl_1900 mfgwages_pw_m_ip_defl_1900 log_mfgwages_pw_m_ip_defl_1900 mfgwages_w_ip_defl_1900 log_mfgwages_w_ip_defl_1900 mfgwages_pw_w_ip_defl_1900 log_mfgwages_pw_w_ip_defl_1900 mfgwages_mw_ip_defl_1900 ///
    log_mfgwages_mw_ip_defl_1900 mfgwages_pw_mw_ip_defl_1900 log_mfgwages_pw_mw_ip_defl_1900 mfgout_ip_defl_1900 log_mfgout_ip_defl_1900 mfgout_pw_m_ip_defl_1900 log_mfgout_pw_m_ip_defl_1900 mfgout_pw_w_ip_defl_1900 ///
    log_mfgout_pw_w_ip_defl_1900 mfgout_pw_mw_ip_defl_1900 log_mfgout_pw_mw_ip_defl_1900 all_totpop_m_1880 all_urbanpop_mw_1880 imm_totpop_mw_1880 carpen_share_m_1880 miner_share_m_1880 ///
    machinist_share_m_1880 brickl_share_m_1880 midskill1_share_m_1880 midskill1alt_share_m_1880 midskill2alt_share_m_1880 highskill1_share_m_1880 lowskillalt_share_m_1880 lf_share_m_1880 ///
    mfglabor_share_m_1880 mfgestab_ip_1880 mfgestab_pw_ip_m_1880 mfgestab_pw_ip_w_1880 mfgestab_pw_ip_mw_1880 mfgwages_m_ip_defl_1880 mfgwages_pw_m_ip_defl_1880 mfgwages_w_ip_defl_1880 ///
    mfgwages_pw_w_ip_defl_1880 mfgwages_mw_ip_defl_1880 mfgwages_pw_mw_ip_defl_1880 mfgout_pw_m_ip_defl_1880 mfgout_pw_w_ip_defl_1880 mfgout_pw_mw_ip_defl_1880 ihs_imm_totpop_mw_1880 ihs_euro_imm_totpop_mw_1880 ///
    ihs_all_lf_tot_m_1880 ihs_mfgestab_pw_ip_m_1880 ihs_mfgestab_pw_ip_w_1880 ihs_mfgwages_m_ip_defl_1880 ihs_mfgwages_pw_m_ip_defl_1880 ihs_mfgwages_w_ip_defl_1880 ihs_mfgwages_pw_w_ip_defl_1880 ihs_mfgwages_mw_ip_defl_1880 ///
    ihs_mfgout_pw_m_ip_defl_1880 ihs_mfgout_pw_w_ip_defl_1880 ihs_locals_kol_perurbpop_1880 mfgestab_ip_1890 mfgestab_pw_ip_m_1890 mfgestab_pw_ip_w_1890 mfgwages_m_ip_defl_1890 mfgwages_pw_m_ip_defl_1890 ///
    mfgwages_w_ip_defl_1890 mfgwages_pw_w_ip_defl_1890 mfgwages_mw_ip_defl_1890 mfgwages_pw_mw_ip_defl_1890 mfgout_pw_m_ip_defl_1890 mfgout_pw_w_ip_defl_1890 mfgout_pw_mw_ip_defl_1890 mfglabor_share_m_1890 ///
    mfglabor_share_w_1890 coalmines_reg_1890 coalmines_loc_1890 ihs_mfgestab_pw_ip_m_1890 ihs_mfgestab_pw_ip_w_1890 ihs_mfgwages_m_ip_defl_1890 ihs_mfgwages_pw_m_ip_defl_1890 ihs_mfgwages_w_ip_defl_1890 ///
    ihs_mfgwages_pw_w_ip_defl_1890 ihs_mfgwages_mw_ip_defl_1890 ihs_mfgout_pw_m_ip_defl_1890 ihs_mfgout_pw_w_ip_defl_1890 ihs_locals_kol_perurbpop_1890 ihs_coalmines_reg_1890 ihs_coalmines_loc_1890 ihs_coalmines_tot_1890 ///
    socshare_1888 socshare_1892 socshare_1896 socshare_avg knownotvote_1856 euro_imm_mw_US_1890 yr_afl_firstconv yr_afl_lastconv ///
    stateyear_nodata state_notinsample umwa_membhip umwa_interp ubc_interp iam_interp bmpiu_interp itu_interp ///
    umwa_density_votes log_umwa_density_votes ubc_density_votes log_ubc_density_votes iam_density_votes log_iam_density_votes bmpiu_density_votes log_bmpiu_density_votes ///
    itu_density_votes log_itu_density_votes
local dropvars : list dropvars & present
drop `dropvars'
compress

save "$data/analysis_dataset_county1930.dta", replace
