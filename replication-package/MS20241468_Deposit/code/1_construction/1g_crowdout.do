*==============================================================================*
* 1g_crowdout.do
*
* Builds county-year crowdout shocks: the predicted change in each county's
* occupational native labor force coming from the national-level inflow of
* recent European immigrants, computed under leave-one-out aggregation.
*
* For each year t, county c, and OCC1950 occupation o,
*   crowdout_euall_nat_occ_o(c,t)
*       = (US_recent_euro_occ_o(t) - county_recent_euro_occ_o(c,t))
*         / (US_recent_euro_lf(t)  - county_recent_euro_lf(c,t))
*         * (nat_occ_o(c, t-10) / nat_lf_tot(c, t-10))
*
* Aggregated across occupations:
*   crowdout_euall_nat(c,t) = sum_o crowdout_euall_nat_occ_o(c,t)
*
* INPUT  (in $data/):
*   county_panel_1880-1920_county1930.dta  - county panel 1880-1920+1930
*
* OUTPUT (in $data/):
*   crowdout_county1930.dta           - per-occupation + aggregate
*                                                crowdout shocks (_nat only)
*
* Run via 00_master.do, or standalone.
*==============================================================================*

clear all
set more off, perm

if "$root" == "" global root "set-this-to-the-replication-package-path"
global data "$root/data/clean"


use year countynhg_1930 gisjoin_1930 *_m if inrange(year,1880,1930) == 1 using "$data/county_panel_1880-1920_county1930.dta", clear
xtset countynhg_1930 year

rename *_wkgagepop_* *_wa_*
rename *_wkgage_* *_wa_*
rename *_m *


*------------------------------------------------------------------------------*
* Total European recent-arrival labor force per county-year, and US-wide
* leave-one-out version (subtracting the own-county count).
*------------------------------------------------------------------------------*

gegen euro_imm_lf_10yr = rowtotal(denmark_lf_10yr norway_lf_10yr finland_lf_10yr sweden_lf_10yr ///
                                  uk_lf_10yr ireland_lf_10yr oth_northeu_lf_10yr ///
                                  belgium_lf_10yr france_lf_10yr luxemb_lf_10yr nether_lf_10yr ///
                                  switz_lf_10yr oth_westeu_lf_10yr ///
                                  italy_lf_10yr gr_pt_es_lf_10yr oth_southeu_lf_10yr ///
                                  aus_hung_lf_10yr czech_lf_10yr germany_lf_10yr ///
                                  poland_lf_10yr oth_easteu_lf_10yr oth_centereu_lf_10yr ///
                                  russia_lf_10yr oth_russeu_lf_10yr), missing

bysort year (countynhg_1930): gegen euro_imm_lf_10yr_US = total(euro_imm_lf_10yr)
gen euro_imm_lf_10yr_US_lvout = euro_imm_lf_10yr_US - euro_imm_lf_10yr


*------------------------------------------------------------------------------*
* Per-occupation recent-arrival European counts (county + US leave-one-out).
*------------------------------------------------------------------------------*

local occs 0 1 2 3 4 5 6 7 8 9 10 12 13 14 15 16 17 18 19 23 24 25 26 27 28 29 ///
           31 32 33 34 35 36 41 42 43 44 45 46 47 48 49 51 52 53 54 55 56 57 58 59 ///
           61 62 63 67 68 69 70 71 72 73 74 75 76 77 78 79 81 82 83 84 91 92 93 94 95 96 97 98 99 ///
           100 123 200 201 203 204 205 210 230 240 250 260 270 280 290 300 301 302 304 305 310 320 ///
           321 322 325 335 340 341 342 350 360 365 370 380 390 400 410 420 430 450 460 470 480 490 ///
           500 501 502 503 504 505 510 511 512 513 514 515 520 521 522 523 524 525 530 531 532 533 534 535 ///
           540 541 542 543 544 545 550 551 552 553 554 555 560 561 562 563 564 565 570 571 572 573 574 575 ///
           580 581 582 583 584 585 590 591 592 593 594 595 600 601 602 603 604 605 610 611 612 613 614 615 ///
           620 621 622 623 624 625 630 631 632 633 634 635 640 641 642 643 644 645 650 660 661 662 ///
           670 671 672 673 674 675 680 681 682 683 684 685 690 700 710 720 730 731 732 740 750 751 752 753 754 ///
           760 761 762 763 764 770 771 772 773 780 781 782 783 784 785 790 810 820 830 840 910 920 930 940 950 960 970 971 972 973

foreach o of local occs {

egen euro_imm_occ`o'_10yr = rowtotal(denmark_occ`o'_10yr norway_occ`o'_10yr finland_occ`o'_10yr sweden_occ`o'_10yr ///
                                     uk_occ`o'_10yr ireland_occ`o'_10yr oth_northeu_occ`o'_10yr ///
                                     belgium_occ`o'_10yr france_occ`o'_10yr luxemb_occ`o'_10yr nether_occ`o'_10yr ///
                                     switz_occ`o'_10yr oth_westeu_occ`o'_10yr ///
                                     italy_occ`o'_10yr gr_pt_es_occ`o'_10yr oth_southeu_occ`o'_10yr ///
                                     aus_hung_occ`o'_10yr czech_occ`o'_10yr germany_occ`o'_10yr ///
                                     poland_occ`o'_10yr oth_easteu_occ`o'_10yr oth_centereu_occ`o'_10yr ///
                                     russia_occ`o'_10yr oth_russeu_occ`o'_10yr), missing

bysort year (countynhg_1930): gegen euro_imm_occ`o'_10yr_US = total(euro_imm_occ`o'_10yr)
gen euro_imm_occ`o'_10yr_US_lvout = euro_imm_occ`o'_10yr_US - euro_imm_occ`o'_10yr

}


*------------------------------------------------------------------------------*
* Native-side crowdout shock per occupation: standard 10-year lag for
* 1910/1920/1930; 20-year lag for 1900 (since 1890 lacks occupation-level
* labor force data).
*------------------------------------------------------------------------------*

xtset countynhg_1930 year

foreach o of local occs {

gen crowdout_euall_nat_occ`o' = (euro_imm_occ`o'_10yr_US_lvout / euro_imm_lf_10yr_US_lvout) * (l10.nat_occ`o' / l10.nat_lf_tot)
replace crowdout_euall_nat_occ`o' = (euro_imm_occ`o'_10yr_US_lvout / euro_imm_lf_10yr_US_lvout) * (l20.nat_occ`o' / l20.nat_lf_tot) if year == 1900

}


*------------------------------------------------------------------------------*
* Aggregate across occupations.
*------------------------------------------------------------------------------*

gegen crowdout_euall_nat = rowtotal(crowdout_euall_nat_occ*), missing


keep year gisjoin_1930 countynhg_1930 crowdout_euall_nat*

label data "County-year crowdout shock (native denominator, aggregate + per-occupation)"
label var year "Year"
label var gisjoin_1930 "GISJOIN, 1930 county boundaries"
label var countynhg_1930 "NHGIS county code, 1930 boundaries"
label var crowdout_euall_nat "Aggregate crowdout shock from recent European immigrants (native LF basis)"

save "$data/crowdout_county1930.dta", replace
