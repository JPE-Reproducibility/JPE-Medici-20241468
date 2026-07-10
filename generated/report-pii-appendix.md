## Appendix: Detailed PII Detection Results

*Generated on 2026-07-10 13:46:28*

This appendix lists all detected instances of potential personally identifiable information (PII) in the project files. Each entry shows the matched PII terms and, for data files, sample values to help verify whether the flagged content is indeed sensitive.

### Full Summary Table

| File Type | File | Variables/References | PII Categories |
|-----------|------|----------------------|----------------|
| Data | `Crosswalk_1880_1930.dta` | 1 | lat |
| Data | `Crosswalk_1890_1930.dta` | 1 | lat |
| Data | `Crosswalk_1900_1930.dta` | 1 | lat |
| Data | `Crosswalk_1910_1930.dta` | 1 | lat |
| Data | `Crosswalk_1920_1930.dta` | 1 | lat |
| Data | `IWW_unions_county1930.csv` | 1 | loc |
| Data | `KoL_unions_county1930.csv` | 1 | loc |
| Data | `Railroad_Atack_1930countyboundaries.csv` | 1 | name |
| Data | `Weather_Data.dta` | 8 | son, lat, lon, country, name |
| Data | `agri_census_1890.csv` | 1 | name |
| Data | `coalmines_1890.csv` | 2 | name, loc |
| Data | `electionresults_1856_county.csv` | 1 | name |
| Data | `electionresults_1886-1924_county.csv` | 1 | name |
| Data | `mfg_census.csv` | 1 | name |
| Data | `mines_census_1890.csv` | 2 | name, loc |
| Data | `names_ancestry.dta` | 26 | name |
| Data | `names_origin.dta` | 27 | name |
| Data | `unions_combined_county1930.csv` | 34 | loc |
| Data | `willcox_immigration_bycountry.csv` | 1 | country |
| Data | `xwalk_occ1950_occnames.csv` | 1 | name |
| Data | `xwalk_statefip_stateicp.csv` | 1 | name |
| Code | `00_master.do` | 12 | census, name, loc, location, lat |
| Code | `00_master_build.do` | 15 | census, name, loc, lat |
| Code | `1a_reference_inputs.do` | 22 | name, coord, lon, loc, lat, census |
| Code | `1b_merge_preadjust.do` | 35 | census, block, loc, lat, lon, name, country, birth |
| Code | `1c_boundary_adjustment.do` | 29 | census, lon, loc, name |
| Code | `1d_county_panel.do` | 9 | census, lon, loc, lat, name |
| Code | `1e_weather_shocks.do` | 82 | country, son, lat, block, loc, lon, name |
| Code | `1f_shiftshare.do` | 57 | country, lon, name, lat, social |
| Code | `1g_crowdout.do` | 7 | lon, name, loc |
| Code | `1h_final_dataset.do` | 73 | lat, loc, name, lon, census, phone, son, street, house, country |
| Code | `2_sample_specifications.do` | 25 | loc, census, lat, name, birth |
| Code | `2a_sumstats.do` | 83 | lat, lon, coord, name, loc, son |
| Code | `2b_figures_descriptives.do` | 9 | lat, lon, loc, name |
| Code | `2c_results_main.do` | 225 | country, lon, loc, name |
| Code | `2d_results_extra.do` | 87 | country, social, loc, lon, name |
| Code | `2e_results_robustness.do` | 436 | lon, loc, country, name, lat, lname |
| Code | `2f_rotemberg_weights.do` | 70 | lon, loc, name, lat |
| Code | `US_county_1930_WGS84.qmd` | 13 | block, census, lat, loc, second, social, city, district, parish, territory, address, country, name, fax, network, url, son |
| Code | `b10_aflstateconv.do` | 93 | name, birth, block, loc, lon, address, coord, father, country, city, lat, census, son, street |
| Code | `b11_natunions.do` | 610 | loc, address, name, lat, census, lon, coord, birth, father, location, city, district, house, precinct, village, son |
| Code | `b12_unions_combine.do` | 75 | loc, census, lat, name, block |
| Code | `b13_iww.do` | 21 | loc, address, zip, coord, lon, name, lat |
| Code | `b14_kol.do` | 39 | loc, location, address, zip, name, city, sex, lat, census, coord, lon |
| Code | `b15_byorigin.do` | 10 | census, country, lat, son, loc, birth, lon |
| Code | `b16_ship_aggregates.do` | 13 | census, lat |
| Code | `b1_census_base.do` | 18 | census, sex, lat, loc, lon, birth, son, second |
| Code | `b2_census_immigration.do` | 21 | census, birth, country, loc, lon, sex |
| Code | `b3_census_occupations.do` | 81 | census, lat, birth, country, second, loc, lon, sex, name, block |
| Code | `b4_census_industries.do` | 9 | census, loc, lon, lat, birth |
| Code | `b5_census_population.do` | 22 | census, lat, sex, loc, lon, birth |
| Code | `b6_census_segregation.do` | 21 | census, house, district, loc, lon, lat |
| Code | `b7_economic_railroads.do` | 62 | census, birth, country, lat, loc, social, lon, name |
| Code | `b8_elections.do` | 86 | loc, census, lon, block, social, name, son |
| Code | `b9_names.do` | 74 | name, son, birth, father, loc, lat, sex, lon, country |
| Code | `bartik_weight.ado` | 26 | name, loc |
| Code | `btsls.ado` | 34 | name, loc |
| Code | `ch_weak.ado` | 11 | degree, name, loc |
| Code | `overid_chao.ado` | 47 | name, loc, lon |
| Code | `rotemberg_summary.tex` | 1 | lat |

### Data Files

**/replication-package/MS20241468_Deposit/data/public/IPUMS/xwalk_occ1950_occnames.csv**

- Variable: `occname`
  - Matched terms: name
  - Sample values: Accountants and auditors, Actors and actresses, Airplane pilots and navigators

**/replication-package/MS20241468_Deposit/data/public/IPUMS_surname_aggregates/names_ancestry.dta**

- Variable: `namelast`
  - Matched terms: name
  - Sample values: , (...)nokler, (?)uidetti
- Variable: `nameprob_anc_aus_hung`
  - Matched terms: name
  - Sample values: 0.040433239191770554, 0.0, 1.0
- Variable: `nameprob_anc_belgium`
  - Matched terms: name
  - Sample values: 0.002855749800801277, 0.0, 1.0
- Variable: `nameprob_anc_czech`
  - Matched terms: name
  - Sample values: 0.012015044689178467, 0.0, 0.04285714402794838
- Variable: `nameprob_anc_denmark`
  - Matched terms: name
  - Sample values: 0.008654315024614334, 0.0, 0.014285714365541935
- Variable: `nameprob_anc_finland`
  - Matched terms: name
  - Sample values: 0.0063035450875759125, 0.0, 1.0
- Variable: `nameprob_anc_france`
  - Matched terms: name
  - Sample values: 0.015950407832860947, 0.0, 0.014285714365541935
- Variable: `nameprob_anc_germany`
  - Matched terms: name
  - Sample values: 0.2851048409938812, 0.0, 0.24285714328289032
- Variable: `nameprob_anc_gr_pt_es`
  - Matched terms: name
  - Sample values: 0.010413038544356823, 0.0, 1.0
- Variable: `nameprob_anc_ireland`
  - Matched terms: name
  - Sample values: 0.1407153308391571, 0.0, 0.08571428805589676
- Variable: `nameprob_anc_italy`
  - Matched terms: name
  - Sample values: 0.05363237485289574, 0.0, 1.0
- Variable: `nameprob_anc_luxemb`
  - Matched terms: name
  - Sample values: 0.00024378352100029588, 0.0, 1.0
- Variable: `nameprob_anc_nether`
  - Matched terms: name
  - Sample values: 0.01015184260904789, 0.0, 0.04285714402794838
- Variable: `nameprob_anc_norway`
  - Matched terms: name
  - Sample values: 0.02490074560046196, 0.0, 0.014285714365541935
- Variable: `nameprob_anc_oth_centereu`
  - Matched terms: name
  - Sample values: 5.2239327487768605e-5, 0.0, 1.0
- Variable: `nameprob_anc_oth_easteu`
  - Matched terms: name
  - Sample values: 0.001845789491198957, 0.0, 0.04285714402794838
- Variable: `nameprob_anc_oth_northeu`
  - Matched terms: name
  - Sample values: 0.0008880685199983418, 0.0, 1.0
- Variable: `nameprob_anc_oth_russeu`
  - Matched terms: name
  - Sample values: 0.00022637040819972754, 0.0, 1.0
- Variable: `nameprob_anc_oth_southeu`
  - Matched terms: name
  - Sample values: 1.7413109162589535e-5, 0.0
- Variable: `nameprob_anc_oth_westeu`
  - Matched terms: name
  - Sample values: 3.482621832517907e-5, 0.0
- Variable: `nameprob_anc_other`
  - Matched terms: name
  - Sample values: 0.1724768429994583, 0.0, 0.08571428805589676
- Variable: `nameprob_anc_poland`
  - Matched terms: name
  - Sample values: 0.030925679951906204, 1.0, 0.0
- Variable: `nameprob_anc_russia`
  - Matched terms: name
  - Sample values: 0.03543567657470703, 0.0, 1.0
- Variable: `nameprob_anc_sweden`
  - Matched terms: name
  - Sample values: 0.03745559602975845, 0.0, 1.0
- Variable: `nameprob_anc_switz`
  - Matched terms: name
  - Sample values: 0.011544890701770782, 0.0, 0.014285714365541935
- Variable: `nameprob_anc_uk`
  - Matched terms: name
  - Sample values: 0.0977223664522171, 0.0, 1.0

**/replication-package/MS20241468_Deposit/data/public/IPUMS_surname_aggregates/names_origin.dta**

- Variable: `namelast`
  - Matched terms: name
  - Sample values: , ""m""nabb""", (...)nokler
- Variable: `nameprob_bpl_aus_hung`
  - Matched terms: name
  - Sample values: 0.006676717661321163, 0.0, 1.0
- Variable: `nameprob_bpl_belgium`
  - Matched terms: name
  - Sample values: 0.00039649129030294716, 0.0, 1.0
- Variable: `nameprob_bpl_czech`
  - Matched terms: name
  - Sample values: 0.0014733811840415, 0.0, 0.5
- Variable: `nameprob_bpl_denmark`
  - Matched terms: name
  - Sample values: 0.0011062596458941698, 0.0, 0.3333333432674408
- Variable: `nameprob_bpl_finland`
  - Matched terms: name
  - Sample values: 0.0011552092619240284, 0.0, 1.0
- Variable: `nameprob_bpl_france`
  - Matched terms: name
  - Sample values: 0.001331427600234747, 0.0, 1.0
- Variable: `nameprob_bpl_germany`
  - Matched terms: name
  - Sample values: 0.028547372668981552, 0.0, 0.5
- Variable: `nameprob_bpl_gr_pt_es`
  - Matched terms: name
  - Sample values: 0.0007048734114505351, 0.0, 1.0
- Variable: `nameprob_bpl_ireland`
  - Matched terms: name
  - Sample values: 0.01070526521652937, 0.0, 0.5
- Variable: `nameprob_bpl_italy`
  - Matched terms: name
  - Sample values: 0.0077242376282811165, 0.0, 1.0
- Variable: `nameprob_bpl_luxemb`
  - Matched terms: name
  - Sample values: 2.4474771635141224e-5, 0.0
- Variable: `nameprob_bpl_native`
  - Matched terms: name
  - Sample values: 0.852960467338562, 1.0, 0.5
- Variable: `nameprob_bpl_nether`
  - Matched terms: name
  - Sample values: 0.0011356293689459562, 0.0, 1.0
- Variable: `nameprob_bpl_norway`
  - Matched terms: name
  - Sample values: 0.0029124978464096785, 0.0, 1.0
- Variable: `nameprob_bpl_oth_centereu`
  - Matched terms: name
  - Sample values: 1.4684862435387913e-5, 0.0
- Variable: `nameprob_bpl_oth_easteu`
  - Matched terms: name
  - Sample values: 0.00021537799329962581, 0.0
- Variable: `nameprob_bpl_oth_northeu`
  - Matched terms: name
  - Sample values: 0.00017132339417003095, 0.0, 0.3333333432674408
- Variable: `nameprob_bpl_oth_russeu`
  - Matched terms: name
  - Sample values: 3.4264681744389236e-5, 0.0, 1.0
- Variable: `nameprob_bpl_oth_southeu`
  - Matched terms: name
  - Sample values: 0.0
- Variable: `nameprob_bpl_oth_westeu`
  - Matched terms: name
  - Sample values: 9.789908290258609e-6, 0.0
- Variable: `nameprob_bpl_other`
  - Matched terms: name
  - Sample values: 0.05808842182159424, 0.0, 0.5
- Variable: `nameprob_bpl_poland`
  - Matched terms: name
  - Sample values: 0.004865584429353476, 0.0, 0.5
- Variable: `nameprob_bpl_russia`
  - Matched terms: name
  - Sample values: 0.004855794832110405, 0.0, 1.0
- Variable: `nameprob_bpl_sweden`
  - Matched terms: name
  - Sample values: 0.004939008969813585, 0.0, 1.0
- Variable: `nameprob_bpl_switz`
  - Matched terms: name
  - Sample values: 0.0014244316844269633, 0.0
- Variable: `nameprob_bpl_uk`
  - Matched terms: name
  - Sample values: 0.008527010679244995, 0.0, 0.3333333432674408

**/replication-package/MS20241468_Deposit/data/public/Sequeira_et_al_2020/Weather_Data.dta**

- Variable: `Distance` (label: *Distance of gridcell from country in ?? (zero = inside)*)
  - Matched terms: country
  - Sample values: 0.0
- Variable: `ISO_ALPHA2` (label: *ISO Alpha2 code for country*)
  - Matched terms: country
  - Sample values: AX
- Variable: `ISO_ALPHA3` (label: *ISO Alpha3 code for country*)
  - Matched terms: country
  - Sample values: ALA
- Variable: `continent` (label: *Continent of country*)
  - Matched terms: country
  - Sample values: Europe
- Variable: `country` (label: *Country name*)
  - Matched terms: country, name
  - Sample values: �land Islands
- Variable: `latitude` (label: *Latitude*)
  - Matched terms: lat
  - Sample values: 60.25
- Variable: `longitude` (label: *Longitude*)
  - Matched terms: lon
  - Sample values: 20.25, 19.75
- Variable: `season` (label: *Season: 13 = Winter (DJF); 14 = Spring (MAM); 15 = Summer (JJA); 16 = Autumn (SO*)
  - Matched terms: son
  - Sample values: 16.0, 15.0, 14.0

**/replication-package/MS20241468_Deposit/data/public/Willcox_1929/willcox_immigration_bycountry.csv**

- Variable: `country`
  - Matched terms: country
  - Sample values: czechoslovakia, austria-hungary, belgium

**/replication-package/MS20241468_Deposit/data/public/census_aggregates/agri_census_1890.csv**

- Variable: `name`
  - Matched terms: name
  - Sample values: FAIRFIELD, HARTFORD, LITCHFIELD

**/replication-package/MS20241468_Deposit/data/public/census_aggregates/electionresults_1856_county.csv**

- Variable: `countyname`
  - Matched terms: name
  - Sample values: FAIRFIELD, HARTFORD, LITCHFIELD

**/replication-package/MS20241468_Deposit/data/public/census_aggregates/electionresults_1886-1924_county.csv**

- Variable: `countyname`
  - Matched terms: name
  - Sample values: FAIRFIELD, HARTFORD, LITCHFIELD

**/replication-package/MS20241468_Deposit/data/public/census_aggregates/mfg_census.csv**

- Variable: `name`
  - Matched terms: name
  - Sample values: FAIRFIELD, HARTFORD, LITCHFIELD

**/replication-package/MS20241468_Deposit/data/public/census_aggregates/mines_census_1890.csv**

- Variable: `coalmines_loc`
  - Matched terms: loc
  - Sample values: 0, 6, 1
- Variable: `name`
  - Matched terms: name
  - Sample values: AUTAUGA, BALDWIN, BARBOUR

**/replication-package/MS20241468_Deposit/data/public/census_mines/coalmines_1890.csv**

- Variable: `coalmines_loc_1890`
  - Matched terms: loc
  - Sample values: 0, 6, 1
- Variable: `name`
  - Matched terms: name
  - Sample values: AUTAUGA, BALDWIN, BARBOUR

**/replication-package/MS20241468_Deposit/data/public/county_crosswalks/crosswalks/CountyToCounty/1930/Crosswalk_1880_1930.dta**

- Variable: `m1_weight` (label: *Weight for count variables (model 1: population assumed homogeneous in counties)*)
  - Matched terms: lat
  - Sample values: 1.0, 1.5422077503934872e-10, 3.56914303667466e-10

**/replication-package/MS20241468_Deposit/data/public/county_crosswalks/crosswalks/CountyToCounty/1930/Crosswalk_1890_1930.dta**

- Variable: `m1_weight` (label: *Weight for count variables (model 1: population assumed homogeneous in counties)*)
  - Matched terms: lat
  - Sample values: 1.0, 1.5422077503934872e-10, 3.56914303667466e-10

**/replication-package/MS20241468_Deposit/data/public/county_crosswalks/crosswalks/CountyToCounty/1930/Crosswalk_1900_1930.dta**

- Variable: `m1_weight` (label: *Weight for count variables (model 1: population assumed homogeneous in counties)*)
  - Matched terms: lat
  - Sample values: 1.0, 1.5422077503934872e-10, 3.56914303667466e-10

**/replication-package/MS20241468_Deposit/data/public/county_crosswalks/crosswalks/CountyToCounty/1930/Crosswalk_1910_1930.dta**

- Variable: `m1_weight` (label: *Weight for count variables (model 1: population assumed homogeneous in counties)*)
  - Matched terms: lat
  - Sample values: 1.0, 1.5422077503934872e-10, 3.56914303667466e-10

**/replication-package/MS20241468_Deposit/data/public/county_crosswalks/crosswalks/CountyToCounty/1930/Crosswalk_1920_1930.dta**

- Variable: `m1_weight` (label: *Weight for count variables (model 1: population assumed homogeneous in counties)*)
  - Matched terms: lat
  - Sample values: 1.0, 1.5422077503934872e-10, 3.56914303667466e-10

**/replication-package/MS20241468_Deposit/data/public/crosswalks/xwalk_statefip_stateicp.csv**

- Variable: `statename`
  - Matched terms: name
  - Sample values: Alabama, Alaska, Arizona

**/replication-package/MS20241468_Deposit/data/public/railroad_maps/Railroad_Atack_1930countyboundaries.csv**

- Variable: `RRname`
  - Matched terms: name
  - Sample values: Paterson & Hudson, New Jersey, Northern Railroad of NJ

**/replication-package/MS20241468_Deposit/data/public/unions/IWW_unions_county1930.csv**

- Variable: `IWW_locals`
  - Matched terms: loc
  - Sample values: 1, 2, 3

**/replication-package/MS20241468_Deposit/data/public/unions/KoL_unions_county1930.csv**

- Variable: `locals_kol`
  - Matched terms: loc
  - Sample values: 3, 2, 1

**/replication-package/MS20241468_Deposit/data/public/unions/unions_combined_county1930.csv**

- Variable: `afl_locals_aaser`
  - Matched terms: loc
  - Sample values: 0.0, 1.0, 0.5
- Variable: `afl_locals_all`
  - Matched terms: loc
  - Sample values: 0.0, 1.0, 6.0
- Variable: `afl_locals_amc`
  - Matched terms: loc
  - Sample values: 0, 1
- Variable: `afl_locals_bmpiu`
  - Matched terms: loc
  - Sample values: 0.0, 1.0, 0.5
- Variable: `afl_locals_bpd`
  - Matched terms: loc
  - Sample values: 0.0, 1.0, 0.5
- Variable: `afl_locals_brca`
  - Matched terms: loc
  - Sample values: 0, 1, 2
- Variable: `afl_locals_brew`
  - Matched terms: loc
  - Sample values: 0.0, 1.0, 0.5
- Variable: `afl_locals_comb`
  - Matched terms: loc
  - Sample values: 0.0, 4.0, 10.0
- Variable: `afl_locals_comb_noumwa`
  - Matched terms: loc
  - Sample values: 0.0, 2.0, 1.0
- Variable: `afl_locals_comb_sk`
  - Matched terms: loc
  - Sample values: 0.0, 2.28, 5.6999998
- Variable: `afl_locals_comb_unsk`
  - Matched terms: loc
  - Sample values: 0.0, 1.72, 4.3000002
- Variable: `afl_locals_iam`
  - Matched terms: loc
  - Sample values: 0.0, 1.0, 2.0
- Variable: `afl_locals_ibew`
  - Matched terms: loc
  - Sample values: 0.0, 1.0, 2.0
- Variable: `afl_locals_ibt`
  - Matched terms: loc
  - Sample values: 0, 1, 2
- Variable: `afl_locals_ila`
  - Matched terms: loc
  - Sample values: 0, 2, 1
- Variable: `afl_locals_itu`
  - Matched terms: loc
  - Sample values: 0.0, 1.0, 2.0
- Variable: `afl_locals_iummsw`
  - Matched terms: loc
  - Sample values: 0
- Variable: `afl_locals_noumwa`
  - Matched terms: loc
  - Sample values: 0.0, 1.0, 6.0
- Variable: `afl_locals_sk`
  - Matched terms: loc
  - Sample values: 0.0, 1.0, 5.0
- Variable: `afl_locals_ubc`
  - Matched terms: loc
  - Sample values: 0.0, 1.0, 2.0
- Variable: `afl_locals_ugwa`
  - Matched terms: loc
  - Sample values: 0.0, 1.0, 0.5
- Variable: `afl_locals_umwa`
  - Matched terms: loc
  - Sample values: 0.0, 1.0, 2.0
- Variable: `afl_locals_unsk`
  - Matched terms: loc
  - Sample values: 0.0, 1.0, 0.43000001
- Variable: `afl_locals_utw`
  - Matched terms: loc
  - Sample values: 0, 1
- Variable: `bmpiu_locals_combined`
  - Matched terms: loc
  - Sample values: 0.0, 1.0, 1.5
- Variable: `bmpiu_locals_votes`
  - Matched terms: loc
  - Sample values: 0, 1, 2
- Variable: `iam_locals_combined`
  - Matched terms: loc
  - Sample values: 0.0, 1.0, 1.5
- Variable: `iam_locals_votes`
  - Matched terms: loc
  - Sample values: 0, 1, 3
- Variable: `itu_locals_combined`
  - Matched terms: loc
  - Sample values: 0.0, 1.0, 1.5
- Variable: `itu_locals_votes`
  - Matched terms: loc
  - Sample values: 0, 1, 2
- Variable: `ubc_locals_combined`
  - Matched terms: loc
  - Sample values: 0.0, 1.0, 1.5
- Variable: `ubc_locals_votes`
  - Matched terms: loc
  - Sample values: 0, 1, 2
- Variable: `umwa_locals_combined`
  - Matched terms: loc
  - Sample values: 0.0, 4.0, 10.0
- Variable: `umwa_locals_votes`
  - Matched terms: loc
  - Sample values: 0, 4, 10

### Code Files

**/replication-package/MS20241468_Deposit/build_documentation/scripts/00_master_build.do**

- Line 15: census
  ```
  * Writes to  : data/public/  (the shipped aggregates: census_aggregates/,
  ```
- Line 16: name
  ```
  *              foreignborn_byorigin/, unions/, IPUMS_surname_aggregates/).
  ```
- Line 41: loc
  ```
  * union/IWW/KoL locals to 1930 county boundaries, b3-b6); shp2dta (converts the
  ```
- Line 45: loc
  ```
  local packages ftools gtools geoinpoly shp2dta
  ```
- Line 46: loc
  ```
  foreach pkg of local packages {
  ```
- Line 51: census
  ```
  * --- census aggregates (IPUMS complete-count) + elections (ICPSR) ------------
  ```
- Line 52: census
  ```
  runstep "$build/b1_census_base.do"           // IPUMS full count
  ```
- Line 53: census
  ```
  runstep "$build/b2_census_immigration.do"    // IPUMS full count
  ```
- Line 54: census
  ```
  runstep "$build/b3_census_occupations.do"    // IPUMS full count
  ```
- Line 55: census
  ```
  runstep "$build/b4_census_industries.do"     // IPUMS full count
  ```
- Line 56: census, lat
  ```
  runstep "$build/b5_census_population.do"     // IPUMS full count
  ```
- Line 57: census
  ```
  runstep "$build/b6_census_segregation.do"    // IPUMS full count, 1880
  ```
- Line 61: name
  ```
  * --- surname / union aggregates (manual ArcGIS, restricted, or secure-server sources) --
  ```
- Line 62: name
  ```
  runstep "$build/b9_names.do"                 // restricted names (secure server); must precede b10-b
  ```
- Line 73: census
  ```
  runstep "$build/b16_ship_aggregates.do"      // $intmdata census aggregates -> data/public/census_ag
  ```

**/replication-package/MS20241468_Deposit/build_documentation/scripts/b10_aflstateconv.do**

- Line 8: name
  ```
  * Steps: (1) parse delegate surnames; (2) classify each delegate's likely
  ```
- Line 9: birth, name
  ```
  * birthplace and ancestry by surname (merge to the IPUMS name-probability
  ```
- Line 12: block, loc, lon
  ```
  * long state-by-state block); (4) split the measures by national union; and
  ```
- Line 25: address, loc
  ```
  *            local addresses geocoded with ArcGIS's "Geocode Addresses"
  ```
- Line 27: name
  ```
  *   main   - parse surnames, merge surname-origin/ancestry probabilities,
  ```
- Line 34: name
  ```
  *   $rawdata/IPUMS_surname_aggregates/names_origin.dta    - surname x origin shares
  ```
- Line 35: name
  ```
  *   $rawdata/IPUMS_surname_aggregates/names_ancestry.dta  - surname x ancestry shares
  ```
- Line 39: name
  ```
  *       records (columns: score, shortlabel, addr_type, type, placename,
  ```
- Line 56: loc
  ```
  global unionsrc    "$root/data/_raw_local/union_sources"
  ```
- Line 67: coord
  ```
  coordinates("$unionsrc/US_county_1930_WGS84_coord") replace
  ```
- Line 75: name
  ```
  * Stash the IPUMS names tables in tempfiles. The shipped names_origin.dta /
  ```
- Line 76: name
  ```
  * names_ancestry.dta carry self-describing prefixed columns -- nameprob_bpl_<group>
  ```
- Line 77: birth, father, name
  ```
  * (own/father birthplace) and nameprob_anc_<group> (ancestry) -- so the two
  ```
- Line 82: name
  ```
  tempfile names_bpl names_anc
  ```
- Line 84: name
  ```
  use "$rawdata/IPUMS_surname_aggregates/names_origin.dta", clear
  ```
- Line 85: name
  ```
  save `names_bpl'
  ```
- Line 87: name
  ```
  use "$rawdata/IPUMS_surname_aggregates/names_ancestry.dta", clear
  ```
- Line 88: name
  ```
  save `names_anc'
  ```
- Line 101: address, loc
  ```
  * (the local union's state, used as the geocode address) and `state_source`
  ```
- Line 105: block, loc, name
  ```
  * geocode-quality block below uses `state`; the subsequent rename swaps
  ```
- Line 106: block, loc
  ```
  * `state_source` into `state` so the apportionment block reads correctly.
  ```
- Line 109: name
  ```
  rename user_* *
  ```
- Line 111: coord
  ```
  * Blank coordinates for low-quality matches (ArcGIS score < 85) and where
  ```
- Line 113: name
  ```
  * are ArcGIS picking a same-named place in another state. AFL conventions
  ```
- Line 114: country
  ```
  * were U.S.-domestic, so no foreign-country filter is needed. We do not
  ```
- Line 115: city
  ```
  * filter on geocode `type`: when ArcGIS cannot pinpoint a city it returns
  ```
- Line 118: loc
  ```
  * `state` here is the local union's state, used to validate the geocode
  ```
- Line 120: name
  ```
  * convention-host state, which is in `state_source`; the rename right
  ```
- Line 129: name
  ```
  rename state_source state
  ```
- Line 130: lon, name
  ```
  rename x longitude
  ```
- Line 131: lat, name
  ```
  rename y latitude
  ```
- Line 133: coord
  ```
  * Drop rows that ended up with no usable coordinates (low-quality matches or
  ```
- Line 135: lat, lon
  ```
  drop if longitude == . | latitude == .
  ```
- Line 138: lat, name
  ```
  * Isolate each delegate's last name: strip "jr"/"sr" suffixes and punctuation,
  ```
- Line 139: lon
  ```
  * and parse entries formatted "first; last" on the semicolon.
  ```
- Line 140: name
  ```
  foreach var of varlist deleg_name_* {
  ```
- Line 160: name
  ```
  rename deleg_name_*_last deleg_lastname_*
  ```
- Line 161: name
  ```
  drop deleg_name_*
  ```
- Line 165: lon, name
  ```
  reshape long deleg_lastname_, i(id) j(deleg_nr)
  ```
- Line 166: name
  ```
  drop if deleg_lastname_ == ""
  ```
- Line 170: census
  ```
  * years within +/-2 of each census year (1900-1902, 1908-1912, 1918-1922,
  ```
- Line 173: lon
  ```
  clonevar year_orig = year
  ```
- Line 180: birth, name
  ```
  *Merge last names (exact string matching) w/ probability of birthplace
  ```
- Line 181: name
  ```
  rename deleg_lastname_ namelast
  ```
- Line 185: name
  ```
  foreach var of varlist nameprob_bpl_* {
  ```
- Line 186: name
  ```
  replace `var' = . if namelast == ""
  ```
- Line 189: name
  ```
  *Merge last names (exact string matching) w/ ancestry
  ```
- Line 193: name
  ```
  foreach var of varlist nameprob_anc_* {
  ```
- Line 194: name
  ```
  replace `var' = . if namelast == ""
  ```
- Line 198: name
  ```
  bysort id: gegen nr_del_bpl_native = total(nameprob_bpl_native), missing
  ```
- Line 202: name
  ```
  bysort id: gegen nr_del_`j'_other = total(nameprob_`j'_other), missing
  ```
- Line 204: name
  ```
  bysort id: gegen nr_del_`j'_euroall = total(nameprob_`j'_denmark nameprob_`j'_finland nameprob_`j'_n
  ```
- Line 205: name
  ```
  nameprob_`j'_sweden nameprob_`j'_uk nameprob_`j'_ireland nameprob_`j'_oth_northeu ///
  ```
- Line 206: name
  ```
  nameprob_`j'_belgium nameprob_`j'_france nameprob_`j'_luxemb nameprob_`j'_nether ///
  ```
- Line 207: name
  ```
  nameprob_`j'_switz nameprob_`j'_oth_westeu ///
  ```
- Line 208: name
  ```
  nameprob_`j'_italy nameprob_`j'_gr_pt_es nameprob_`j'_oth_southeu ///
  ```
- Line 209: name
  ```
  nameprob_`j'_aus_hung nameprob_`j'_czech nameprob_`j'_germany nameprob_`j'_poland ///
  ```
- Line 210: name
  ```
  nameprob_`j'_oth_easteu nameprob_`j'_oth_centereu ///
  ```
- Line 211: name
  ```
  nameprob_`j'_russia nameprob_`j'_oth_russeu), missing
  ```
- Line 213: name
  ```
  bysort id: gegen nr_del_`j'_euronw = total(nameprob_`j'_denmark nameprob_`j'_finland nameprob_`j'_no
  ```
- Line 214: name
  ```
  nameprob_`j'_sweden nameprob_`j'_uk nameprob_`j'_ireland nameprob_`j'_oth_northeu ///
  ```
- Line 215: name
  ```
  nameprob_`j'_belgium nameprob_`j'_france nameprob_`j'_luxemb nameprob_`j'_nether ///
  ```
- Line 216: name
  ```
  nameprob_`j'_switz nameprob_`j'_oth_westeu ///
  ```
- Line 217: name
  ```
  nameprob_`j'_germany), missing
  ```
- Line 219: name
  ```
  bysort id: gegen nr_del_`j'_eurose = total(nameprob_`j'_italy nameprob_`j'_gr_pt_es nameprob_`j'_oth
  ```
- Line 220: name
  ```
  nameprob_`j'_aus_hung nameprob_`j'_czech nameprob_`j'_poland ///
  ```
- Line 221: name
  ```
  nameprob_`j'_oth_easteu nameprob_`j'_oth_centereu ///
  ```
- Line 222: name
  ```
  nameprob_`j'_russia nameprob_`j'_oth_russeu), missing
  ```
- Line 226: name
  ```
  drop nameprob*
  ```
- Line 227: name
  ```
  rename namelast deleg_namelast_
  ```
- Line 228: name
  ```
  reshape wide deleg_namelast_, i(id) j(deleg_nr)
  ```
- Line 229: name
  ```
  order deleg_namelast_*, last
  ```
- Line 235: loc
  ```
  * Each AFL state federation's constitution fixed how a local's membership
  ```
- Line 236: block, lat, loc, lon
  ```
  * translated into convention votes / delegates. The long state-by-state block
  ```
- Line 241: lat
  ```
  * constitution apportioned non-proportionally (a flat number of delegates
  ```
- Line 242: loc
  ```
  * per local) leave members missing.
  ```
- Line 244: block, loc
  ```
  * The constitutional representation rules summarised in each state block below
  ```
- Line 585: loc
  ```
  *1902 -- not proportional (locals sent 1 delegate each; no info on representation rule is available)
  ```
- Line 706: name
  ```
  rename nr_delegates* nr_del*
  ```
- Line 708: loc
  ```
  * For each measure j, split the local-year value across national unions by
  ```
- Line 709: loc
  ```
  * keyword-matching the free-text "union" string: `j'_<u> = `j' if the local
  ```
- Line 710: lon
  ```
  * belongs to <u>, else 0. Aggregated to county-year below, this gives the
  ```
- Line 736: son
  ```
  replace `j'_bmpiu = `j' if strpos(union,"bricklayer") > 0 | strpos(union,"mason") > 0 | ///
  ```
- Line 771: street
  ```
  replace `j'_brca = 0	   if strpos(union,"street carmen") > 0
  ```
- Line 791: street
  ```
  replace `j'_aaser = `j' if strpos(union,"street") > 0 | strpos(union,"electric rail") > 0 | strpos(u
  ```
- Line 808: loc
  ```
  *Compute number of locals
  ```
- Line 809: loc
  ```
  gen locals_tot = 1 if members != .
  ```
- Line 811: loc
  ```
  gen locals_`union' = (members_`union' > 0) if members != .
  ```
- Line 815: loc
  ```
  * Collapse to 1930 counties: point-in-polygon match each geocoded local to its
  ```
- Line 824: name
  ```
  rename (GISJOIN GISJOIN2) (gisjoin_1930 countynhg_1930)
  ```
- Line 825: loc
  ```
  foreach var of varlist members* locals_* nr_votes_delegates nr_del* {
  ```
- Line 827: name
  ```
  rename `var' `var'_dr
  ```
- Line 832: name
  ```
  rename *_tot afl_*
  ```

**/replication-package/MS20241468_Deposit/build_documentation/scripts/b11_natunions.do**

- Line 5: loc
  ```
  * of locals, membership proxies, and delegate counts for the five national
  ```
- Line 9: loc
  ```
  * <UNION>_locals_votes and <UNION>_memb_proxy_votes (plus UMWA_membership
  ```
- Line 20: loc
  ```
  *   manual - the delegate/votes lists (and, for UMWA only, the locals list)
  ```
- Line 22: address
  ```
  *            with ArcGIS's "Geocode Addresses" tool against a U.S. address
  ```
- Line 23: loc
  ```
  *            locator. The geocoded CSVs are the inputs to this script.
  ```
- Line 24: name
  ```
  *   main   - read the geocoded list, clean it, attach surname-based ethnic
  ```
- Line 36: name
  ```
  *   (2) Parse delegate surnames: lowercase, strip punctuation and "jr"/"sr"
  ```
- Line 37: lat, name
  ```
  *       suffixes, isolate the last word as the family name.
  ```
- Line 39: census
  ```
  *       1920} so that counts merge onto the decennial census panel.
  ```
- Line 40: name
  ```
  *   (4) Merge on the surname x year origin shares (names_origin.dta) and
  ```
- Line 42: name
  ```
  *       Restricted Full Count with Names. Each delegate's surname carries
  ```
- Line 43: lon
  ```
  *       a probability of belonging to one of ~25 European-origin groups
  ```
- Line 45: loc
  ```
  *       local-year produces nr_delegates_*_<group> -- the expected number
  ```
- Line 46: loc, name
  ```
  *       of delegates in each ethnic group at each local. (See nameprob_*
  ```
- Line 47: name
  ```
  *       in build_documentation/scripts/b9_names.do.)
  ```
- Line 48: loc
  ```
  *   (5) Aggregate to the local-year level (one row per local x year).
  ```
- Line 50: loc
  ```
  *       a per-local membership proxy: memb_proxy_votes. The rule differs
  ```
- Line 59: name
  ```
  *   $rawdata/IPUMS_surname_aggregates/names_origin.dta
  ```
- Line 60: name
  ```
  *   $rawdata/IPUMS_surname_aggregates/names_ancestry.dta
  ```
- Line 87: loc
  ```
  global unionsrc     "$root/data/_raw_local/union_sources"
  ```
- Line 98: coord
  ```
  coordinates("$unionsrc/US_county_1930_WGS84_coord") replace
  ```
- Line 106: name
  ```
  * Stash the IPUMS names tables in tempfiles. The shipped names_origin.dta /
  ```
- Line 107: name
  ```
  * names_ancestry.dta carry self-describing prefixed columns -- nameprob_bpl_<group>
  ```
- Line 108: birth, father, name
  ```
  * (own/father birthplace) and nameprob_anc_<group> (ancestry) -- so the two
  ```
- Line 113: name
  ```
  tempfile names_bpl names_anc
  ```
- Line 115: name
  ```
  use "$rawdata/IPUMS_surname_aggregates/names_origin.dta", clear
  ```
- Line 116: name
  ```
  save `names_bpl'
  ```
- Line 118: name
  ```
  use "$rawdata/IPUMS_surname_aggregates/names_ancestry.dta", clear
  ```
- Line 119: name
  ```
  save `names_anc'
  ```
- Line 131: loc
  ```
  * The local-level membership variable also appears in the delegate
  ```
- Line 141: name
  ```
  rename user_* *
  ```
- Line 143: loc, location, name
  ```
  replace score = 100 if location == "n. philadelphia" & placename == "new philadelphia"
  ```
- Line 154: name
  ```
  foreach var of varlist placename {
  ```
- Line 155: name
  ```
  rename `var' geocode_`var'
  ```
- Line 160: name
  ```
  rename regionabbr statecode
  ```
- Line 161: name
  ```
  rename number lu_nr
  ```
- Line 162: city, loc, location, name
  ```
  rename location city
  ```
- Line 163: lon, name
  ```
  rename x longitude
  ```
- Line 164: lat, name
  ```
  rename y latitude
  ```
- Line 168: lat, name
  ```
  *Isolate last names of delegates
  ```
- Line 188: name
  ```
  rename delegate_last delegate_lastname
  ```
- Line 198: lon, name
  ```
  *Merge last names (exact string matching) w/ probability of belonging to a specific ethnic group
  ```
- Line 199: name
  ```
  rename delegate_lastname namelast
  ```
- Line 203: name
  ```
  foreach var of varlist nameprob_bpl_* {
  ```
- Line 204: name
  ```
  replace `var' = . if namelast == ""
  ```
- Line 207: name
  ```
  *Merge last names (exact string matching) w/ ancestry
  ```
- Line 211: name
  ```
  foreach var of varlist nameprob_anc_* {
  ```
- Line 212: name
  ```
  replace `var' = . if namelast == ""
  ```
- Line 216: name
  ```
  gegen nr_delegates_bpl_native = rowtotal(nameprob_bpl_native), missing
  ```
- Line 220: name
  ```
  gegen nr_delegates_`j'_other = rowtotal(nameprob_`j'_other), missing
  ```
- Line 222: name
  ```
  gegen nr_delegates_`j'_euroall = rowtotal(nameprob_`j'_denmark nameprob_`j'_finland nameprob_`j'_nor
  ```
- Line 223: name
  ```
  nameprob_`j'_sweden nameprob_`j'_uk nameprob_`j'_ireland nameprob_`j'_oth_northeu ///
  ```
- Line 224: name
  ```
  nameprob_`j'_belgium nameprob_`j'_france nameprob_`j'_luxemb nameprob_`j'_nether ///
  ```
- Line 225: name
  ```
  nameprob_`j'_switz nameprob_`j'_oth_westeu ///
  ```
- Line 226: name
  ```
  nameprob_`j'_italy nameprob_`j'_gr_pt_es nameprob_`j'_oth_southeu ///
  ```
- Line 227: name
  ```
  nameprob_`j'_aus_hung nameprob_`j'_czech nameprob_`j'_germany nameprob_`j'_poland ///
  ```
- Line 228: name
  ```
  nameprob_`j'_oth_easteu nameprob_`j'_oth_centereu ///
  ```
- Line 229: name
  ```
  nameprob_`j'_russia nameprob_`j'_oth_russeu), missing
  ```
- Line 231: name
  ```
  gegen nr_delegates_`j'_euronw = rowtotal(nameprob_`j'_denmark nameprob_`j'_finland nameprob_`j'_norw
  ```
- Line 232: name
  ```
  nameprob_`j'_sweden nameprob_`j'_uk nameprob_`j'_ireland nameprob_`j'_oth_northeu ///
  ```
- Line 233: name
  ```
  nameprob_`j'_belgium nameprob_`j'_france nameprob_`j'_luxemb nameprob_`j'_nether ///
  ```
- Line 234: name
  ```
  nameprob_`j'_switz nameprob_`j'_oth_westeu ///
  ```
- Line 235: name
  ```
  nameprob_`j'_germany), missing
  ```
- Line 237: name
  ```
  gegen nr_delegates_`j'_eurose = rowtotal(nameprob_`j'_italy nameprob_`j'_gr_pt_es nameprob_`j'_oth_s
  ```
- Line 238: name
  ```
  nameprob_`j'_aus_hung nameprob_`j'_czech nameprob_`j'_poland ///
  ```
- Line 239: name
  ```
  nameprob_`j'_oth_easteu nameprob_`j'_oth_centereu ///
  ```
- Line 240: name
  ```
  nameprob_`j'_russia nameprob_`j'_oth_russeu), missing
  ```
- Line 244: name
  ```
  drop nameprob*
  ```
- Line 247: city, name
  ```
  * Normalize city names so that spelling variants collapse to a single key:
  ```
- Line 249: district
  ```
  * "st." -> "saint", ward / township / district / etc. suffixes), so that the
  ```
- Line 250: loc
  ```
  * local-year aggregation below treats e.g. "Saint Louis" and "St. Louis" as
  ```
- Line 252: city, name
  ```
  gen 	city_clean 	= lower(geocode_placename)
  ```
- Line 253: city
  ```
  replace city_clean	= lower(city) if city_clean == ""
  ```
- Line 254: city
  ```
  order city_clean, after(city)
  ```
- Line 255: city
  ```
  replace city_clean 	= subinstr(city_clean,"mt.","mount",.)
  ```
- Line 256: city
  ```
  replace city_clean 	= subinstr(city_clean,"mt ","mount ",.)
  ```
- Line 257: city
  ```
  replace city_clean 	= subinstr(city_clean,"st.","saint",.)
  ```
- Line 258: city
  ```
  replace city_clean 	= subinstr(city_clean,"st","saint",1) if substr(city_clean,1,3) == "st "
  ```
- Line 259: city
  ```
  replace city_clean 	= subinstr(city_clean,"indian reservation","reservation",.)
  ```
- Line 260: city
  ```
  replace city_clean 	= subinstr(city_clean,"0","",.)
  ```
- Line 261: city
  ```
  replace city_clean 	= subinstr(city_clean,"1","",.)
  ```
- Line 262: city
  ```
  replace city_clean 	= subinstr(city_clean,"2","",.)
  ```
- Line 263: city
  ```
  replace city_clean 	= subinstr(city_clean,"3","",.)
  ```
- Line 264: city
  ```
  replace city_clean 	= subinstr(city_clean,"4","",.)
  ```
- Line 265: city
  ```
  replace city_clean 	= subinstr(city_clean,"5","",.)
  ```
- Line 266: city
  ```
  replace city_clean 	= subinstr(city_clean,"6","",.)
  ```
- Line 267: city
  ```
  replace city_clean 	= subinstr(city_clean,"7","",.)
  ```
- Line 268: city
  ```
  replace city_clean 	= subinstr(city_clean,"8","",.)
  ```
- Line 269: city
  ```
  replace city_clean 	= subinstr(city_clean,"9","",.)
  ```
- Line 270: city
  ```
  replace city_clean 	= subinstr(city_clean,",","",.)
  ```
- Line 271: city
  ```
  replace city_clean 	= subinstr(city_clean,"?","",.)
  ```
- Line 272: city
  ```
  replace city_clean 	= subinstr(city_clean,".","",.)
  ```
- Line 273: city
  ```
  replace city_clean 	= subinstr(city_clean,"(","",.)
  ```
- Line 274: city
  ```
  replace city_clean 	= subinstr(city_clean,")","",.)
  ```
- Line 275: city
  ```
  replace city_clean 	= subinstr(city_clean,"/","",.)
  ```
- Line 276: city
  ```
  replace city_clean 	= subinstr(city_clean," range ","",.)
  ```
- Line 277: city
  ```
  replace city_clean 	= subinstr(city_clean," range(s) ","",.)
  ```
- Line 278: city
  ```
  replace city_clean 	= subinstr(city_clean," range","",.) if substr(city_clean,-6,6) == " range"
  ```
- Line 279: city
  ```
  replace city_clean 	= subinstr(city_clean," range(s)","",.) if substr(city_clean,-9,9) == " range(s)
  ```
- Line 280: city
  ```
  replace city_clean 	= subinstr(city_clean,"police jury","",.)
  ```
- Line 281: city
  ```
  replace city_clean 	= subinstr(city_clean,"justice ward","",.)
  ```
- Line 282: city, house
  ```
  replace city_clean 	= subinstr(city_clean,"court house","",.)
  ```
- Line 283: city, district
  ```
  replace city_clean 	= subinstr(city_clean,"militia district","",.)
  ```
- Line 284: city, district
  ```
  replace city_clean 	= subinstr(city_clean,"civil district","",.)
  ```
- Line 285: city, precinct
  ```
  replace city_clean 	= subinstr(city_clean,"justice precinct","",.)
  ```
- Line 286: city, district
  ```
  replace city_clean 	= subinstr(city_clean,"election district","",.)
  ```
- Line 287: city
  ```
  replace city_clean 	= subinstr(city_clean,"undetermined","",.)
  ```
- Line 288: city
  ```
  replace city_clean 	= subinstr(city_clean,"not stated","",.)
  ```
- Line 289: city, village
  ```
  replace city_clean 	= subinstr(city_clean," village","",.)
  ```
- Line 290: city
  ```
  replace city_clean 	= subinstr(city_clean,"tract","",.)
  ```
- Line 291: city
  ```
  replace city_clean 	= subinstr(city_clean," ward","",.)
  ```
- Line 292: city, district
  ```
  replace city_clean 	= subinstr(city_clean,"assembly district","",.)
  ```
- Line 293: city, district
  ```
  replace city_clean 	= subinstr(city_clean,"district","",.)
  ```
- Line 294: city
  ```
  replace city_clean 	= subinstr(city_clean,"no.","",.)
  ```
- Line 295: city, precinct
  ```
  replace city_clean 	= subinstr(city_clean,"precinct","",.)
  ```
- Line 296: city
  ```
  replace city_clean 	= subinstr(city_clean,"subdivision","",.)
  ```
- Line 297: city
  ```
  replace city_clean 	= subinstr(city_clean,"beat","",.)
  ```
- Line 298: city
  ```
  replace city_clean 	= subinstr(city_clean,"plantation","",.)
  ```
- Line 299: census, city
  ```
  replace city_clean 	= subinstr(city_clean,"census designated place","",.)
  ```
- Line 300: city
  ```
  replace city_clean 	= subinstr(city_clean,"post office","",.)
  ```
- Line 301: city
  ```
  replace city_clean 	= subinstr(city_clean,"township of","",.)
  ```
- Line 302: city
  ```
  replace city_clean 	= subinstr(city_clean,"town of","",.)
  ```
- Line 303: city
  ```
  replace city_clean 	= subinstr(city_clean,"borough of","",.)
  ```
- Line 304: city
  ```
  replace city_clean 	= subinstr(city_clean,"city of","",.)
  ```
- Line 305: city
  ```
  replace city_clean 	= subinstr(city_clean,"ward ","",1) if substr(city_clean,1,5) == "ward "
  ```
- Line 306: city
  ```
  replace city_clean 	= subinstr(city_clean,"township ","",1) if substr(city_clean,1,9) == "township "
  ```
- Line 307: city
  ```
  replace city_clean 	= "" if strpos(city_clean,"division") > 0
  ```
- Line 308: city
  ```
  replace city_clean 	= subinstr(city_clean,"east side","",.)
  ```
- Line 309: city
  ```
  replace city_clean 	= subinstr(city_clean,"west side","",.)
  ```
- Line 310: city
  ```
  replace city_clean 	= subinstr(city_clean,"south side","",.)
  ```
- Line 311: city
  ```
  replace city_clean 	= subinstr(city_clean,"north side","",.)
  ```
- Line 312: city
  ```
  replace city_clean 	= subinstr(city_clean,"eastern side","",.)
  ```
- Line 313: city
  ```
  replace city_clean 	= subinstr(city_clean,"western side","",.)
  ```
- Line 314: city
  ```
  replace city_clean 	= subinstr(city_clean,"southern side","",.)
  ```
- Line 315: city
  ```
  replace city_clean 	= subinstr(city_clean,"northern side","",.)
  ```
- Line 316: city
  ```
  replace city_clean	= stritrim(city_clean)
  ```
- Line 317: city
  ```
  replace city_clean	= "" if length(city_clean) < 2
  ```
- Line 318: city
  ```
  replace city_clean	= strtrim(city_clean)
  ```
- Line 319: city
  ```
  replace city_clean	= lower(city_clean)
  ```
- Line 321: city
  ```
  replace city_clean 	= "east saint louis" if city_clean == "east st louis"
  ```
- Line 322: city, lon
  ```
  replace city_clean 	= "new york city" if city_clean == "long island city" & state == "NY"
  ```
- Line 324: city
  ```
  replace city_clean 	= subinstr(city_clean,"-","",.)
  ```
- Line 325: city
  ```
  replace city_clean 	= subinstr(city_clean,"south","",.)
  ```
- Line 326: city
  ```
  replace city_clean 	= subinstr(city_clean,"north","",.)
  ```
- Line 327: city
  ```
  replace city_clean 	= subinstr(city_clean,"east","",.)
  ```
- Line 328: city
  ```
  replace city_clean 	= subinstr(city_clean,"west","",.)
  ```
- Line 329: city
  ```
  replace city_clean 	= subinstr(city_clean,"southern","",.)
  ```
- Line 330: city
  ```
  replace city_clean 	= subinstr(city_clean,"northern","",.)
  ```
- Line 331: city
  ```
  replace city_clean 	= subinstr(city_clean,"eastern","",.)
  ```
- Line 332: city
  ```
  replace city_clean 	= subinstr(city_clean,"western","",.)
  ```
- Line 333: city
  ```
  replace city_clean 	= subinstr(city_clean," township","",.)
  ```
- Line 334: city
  ```
  replace city_clean 	= subinstr(city_clean," point","",.)
  ```
- Line 335: city
  ```
  replace city_clean 	= subinstr(city_clean," ","",.)
  ```
- Line 337: loc
  ```
  *Collapse at the local-year level
  ```
- Line 340: city, district, lat, lon
  ```
  gcollapse (sum) votes nr_delegates_* delegates_bpl_nonmissing delegates_anc_nonmissing (firstnm) mem
  ```
- Line 360: name
  ```
  rename (GISJOIN GISJOIN2) (gisjoin_1930 countynhg_1930)
  ```
- Line 375: loc, name
  ```
  rename lu_nr locals_votes
  ```
- Line 376: loc
  ```
  foreach var of varlist locals membership memb_proxy_votes nr_delegates_* {
  ```
- Line 377: name
  ```
  rename `var' UMWA_`var'
  ```
- Line 383: loc
  ```
  UMWA_membership UMWA_memb_proxy_votes UMWA_locals_votes
  ```
- Line 389: loc
  ```
  label var UMWA_locals_votes "Number of UMWA locals sending delegates"
  ```
- Line 392: birth, name
  ```
  label var UMWA_nr_delegates_bpl_native "UMWA delegates: native (last-name birthplace prob.)"
  ```
- Line 393: birth, name
  ```
  label var UMWA_nr_delegates_bpl_other "UMWA delegates: other origin (last-name birthplace prob.)"
  ```
- Line 394: birth, name
  ```
  label var UMWA_nr_delegates_bpl_euroall "UMWA delegates: any European (last-name birthplace prob.)"
  ```
- Line 395: birth, name
  ```
  label var UMWA_nr_delegates_bpl_euronw "UMWA delegates: NW European (last-name birthplace prob.)"
  ```
- Line 396: birth, name
  ```
  label var UMWA_nr_delegates_bpl_eurose "UMWA delegates: S/E European (last-name birthplace prob.)"
  ```
- Line 397: name
  ```
  label var UMWA_nr_delegates_anc_other "UMWA delegates: other origin (last-name ancestry prob.)"
  ```
- Line 398: name
  ```
  label var UMWA_nr_delegates_anc_euroall "UMWA delegates: any European (last-name ancestry prob.)"
  ```
- Line 399: name
  ```
  label var UMWA_nr_delegates_anc_euronw "UMWA delegates: NW European (last-name ancestry prob.)"
  ```
- Line 400: name
  ```
  label var UMWA_nr_delegates_anc_eurose "UMWA delegates: S/E European (last-name ancestry prob.)"
  ```
- Line 426: name
  ```
  rename user_* *
  ```
- Line 428: district
  ```
  replace state = "District of Columbia" if state == "D.C."
  ```
- Line 436: name
  ```
  replace placename = "" if x == . & y == .
  ```
- Line 440: name
  ```
  foreach var of varlist placename {
  ```
- Line 441: name
  ```
  rename `var' geocode_`var'
  ```
- Line 445: name
  ```
  rename regionabbr statecode
  ```
- Line 446: name
  ```
  rename union_no_ lu_nr
  ```
- Line 447: lon, name
  ```
  rename x longitude
  ```
- Line 448: lat, name
  ```
  rename y latitude
  ```
- Line 450: lat, name
  ```
  *Isolate last names of delegates
  ```
- Line 451: name
  ```
  foreach var of varlist name_of_delegate {
  ```
- Line 470: name
  ```
  rename name_of_delegate_last delegate_lastname
  ```
- Line 471: name
  ```
  drop name_of_delegate
  ```
- Line 480: lon, name
  ```
  *Merge last names (exact string matching) w/ probability of belonging to a specific ethnic group
  ```
- Line 481: name
  ```
  rename delegate_lastname namelast
  ```
- Line 485: name
  ```
  foreach var of varlist nameprob_bpl_* {
  ```
- Line 486: name
  ```
  replace `var' = . if namelast == ""
  ```
- Line 489: name
  ```
  *Merge last names (exact string matching) w/ ancestry
  ```
- Line 493: name
  ```
  foreach var of varlist nameprob_anc_* {
  ```
- Line 494: name
  ```
  replace `var' = . if namelast == ""
  ```
- Line 498: name
  ```
  gegen nr_delegates_bpl_native = rowtotal(nameprob_bpl_native), missing
  ```
- Line 502: name
  ```
  gegen nr_delegates_`j'_other = rowtotal(nameprob_`j'_other), missing
  ```
- Line 504: name
  ```
  gegen nr_delegates_`j'_euroall = rowtotal(nameprob_`j'_denmark nameprob_`j'_finland nameprob_`j'_nor
  ```
- Line 505: name
  ```
  nameprob_`j'_sweden nameprob_`j'_uk nameprob_`j'_ireland nameprob_`j'_oth_northeu ///
  ```
- Line 506: name
  ```
  nameprob_`j'_belgium nameprob_`j'_france nameprob_`j'_luxemb nameprob_`j'_nether ///
  ```
- Line 507: name
  ```
  nameprob_`j'_switz nameprob_`j'_oth_westeu ///
  ```
- Line 508: name
  ```
  nameprob_`j'_italy nameprob_`j'_gr_pt_es nameprob_`j'_oth_southeu ///
  ```
- Line 509: name
  ```
  nameprob_`j'_aus_hung nameprob_`j'_czech nameprob_`j'_germany nameprob_`j'_poland ///
  ```
- Line 510: name
  ```
  nameprob_`j'_oth_easteu nameprob_`j'_oth_centereu ///
  ```
- Line 511: name
  ```
  nameprob_`j'_russia nameprob_`j'_oth_russeu), missing
  ```
- Line 513: name
  ```
  gegen nr_delegates_`j'_euronw = rowtotal(nameprob_`j'_denmark nameprob_`j'_finland nameprob_`j'_norw
  ```
- Line 514: name
  ```
  nameprob_`j'_sweden nameprob_`j'_uk nameprob_`j'_ireland nameprob_`j'_oth_northeu ///
  ```
- Line 515: name
  ```
  nameprob_`j'_belgium nameprob_`j'_france nameprob_`j'_luxemb nameprob_`j'_nether ///
  ```
- Line 516: name
  ```
  nameprob_`j'_switz nameprob_`j'_oth_westeu ///
  ```
- Line 517: name
  ```
  nameprob_`j'_germany), missing
  ```
- Line 519: name
  ```
  gegen nr_delegates_`j'_eurose = rowtotal(nameprob_`j'_italy nameprob_`j'_gr_pt_es nameprob_`j'_oth_s
  ```
- Line 520: name
  ```
  nameprob_`j'_aus_hung nameprob_`j'_czech nameprob_`j'_poland ///
  ```
- Line 521: name
  ```
  nameprob_`j'_oth_easteu nameprob_`j'_oth_centereu ///
  ```
- Line 522: name
  ```
  nameprob_`j'_russia nameprob_`j'_oth_russeu), missing
  ```
- Line 526: name
  ```
  drop nameprob*
  ```
- Line 531: city, name
  ```
  * Normalize city names so that spelling variants collapse to a single key:
  ```
- Line 533: district
  ```
  * "st." -> "saint", ward / township / district / etc. suffixes), so that the
  ```
- Line 534: loc
  ```
  * local-year aggregation below treats e.g. "Saint Louis" and "St. Louis" as
  ```
- Line 536: city, name
  ```
  gen 	city_clean 	= lower(geocode_placename)
  ```
- Line 537: city
  ```
  replace city_clean	= lower(city) if city_clean == ""
  ```
- Line 538: city
  ```
  order city_clean, after(city)
  ```
- Line 539: city
  ```
  replace city_clean 	= subinstr(city_clean,"mt.","mount",.)
  ```
- Line 540: city
  ```
  replace city_clean 	= subinstr(city_clean,"mt ","mount ",.)
  ```
- Line 541: city
  ```
  replace city_clean 	= subinstr(city_clean,"st.","saint",.)
  ```
- Line 542: city
  ```
  replace city_clean 	= subinstr(city_clean,"st","saint",1) if substr(city_clean,1,3) == "st "
  ```
- Line 543: city
  ```
  replace city_clean 	= subinstr(city_clean,"indian reservation","reservation",.)
  ```
- Line 544: city
  ```
  replace city_clean 	= subinstr(city_clean,"0","",.)
  ```
- Line 545: city
  ```
  replace city_clean 	= subinstr(city_clean,"1","",.)
  ```
- Line 546: city
  ```
  replace city_clean 	= subinstr(city_clean,"2","",.)
  ```
- Line 547: city
  ```
  replace city_clean 	= subinstr(city_clean,"3","",.)
  ```
- Line 548: city
  ```
  replace city_clean 	= subinstr(city_clean,"4","",.)
  ```
- Line 549: city
  ```
  replace city_clean 	= subinstr(city_clean,"5","",.)
  ```
- Line 550: city
  ```
  replace city_clean 	= subinstr(city_clean,"6","",.)
  ```
- Line 551: city
  ```
  replace city_clean 	= subinstr(city_clean,"7","",.)
  ```
- Line 552: city
  ```
  replace city_clean 	= subinstr(city_clean,"8","",.)
  ```
- Line 553: city
  ```
  replace city_clean 	= subinstr(city_clean,"9","",.)
  ```
- Line 554: city
  ```
  replace city_clean 	= subinstr(city_clean,",","",.)
  ```
- Line 555: city
  ```
  replace city_clean 	= subinstr(city_clean,"?","",.)
  ```
- Line 556: city
  ```
  replace city_clean 	= subinstr(city_clean,".","",.)
  ```
- Line 557: city
  ```
  replace city_clean 	= subinstr(city_clean,"(","",.)
  ```
- Line 558: city
  ```
  replace city_clean 	= subinstr(city_clean,")","",.)
  ```
- Line 559: city
  ```
  replace city_clean 	= subinstr(city_clean,"/","",.)
  ```
- Line 560: city
  ```
  replace city_clean 	= subinstr(city_clean," range ","",.)
  ```
- Line 561: city
  ```
  replace city_clean 	= subinstr(city_clean," range(s) ","",.)
  ```
- Line 562: city
  ```
  replace city_clean 	= subinstr(city_clean," range","",.) if substr(city_clean,-6,6) == " range"
  ```
- Line 563: city
  ```
  replace city_clean 	= subinstr(city_clean," range(s)","",.) if substr(city_clean,-9,9) == " range(s)
  ```
- Line 564: city
  ```
  replace city_clean 	= subinstr(city_clean,"police jury","",.)
  ```
- Line 565: city
  ```
  replace city_clean 	= subinstr(city_clean,"justice ward","",.)
  ```
- Line 566: city, house
  ```
  replace city_clean 	= subinstr(city_clean,"court house","",.)
  ```
- Line 567: city, district
  ```
  replace city_clean 	= subinstr(city_clean,"militia district","",.)
  ```
- Line 568: city, district
  ```
  replace city_clean 	= subinstr(city_clean,"civil district","",.)
  ```
- Line 569: city, precinct
  ```
  replace city_clean 	= subinstr(city_clean,"justice precinct","",.)
  ```
- Line 570: city, district
  ```
  replace city_clean 	= subinstr(city_clean,"election district","",.)
  ```
- Line 571: city
  ```
  replace city_clean 	= subinstr(city_clean,"undetermined","",.)
  ```
- Line 572: city
  ```
  replace city_clean 	= subinstr(city_clean,"not stated","",.)
  ```
- Line 573: city, village
  ```
  replace city_clean 	= subinstr(city_clean," village","",.)
  ```
- Line 574: city
  ```
  replace city_clean 	= subinstr(city_clean,"tract","",.)
  ```
- Line 575: city
  ```
  replace city_clean 	= subinstr(city_clean," ward","",.)
  ```
- Line 576: city, district
  ```
  replace city_clean 	= subinstr(city_clean,"assembly district","",.)
  ```
- Line 577: city, district
  ```
  replace city_clean 	= subinstr(city_clean,"district","",.)
  ```
- Line 578: city
  ```
  replace city_clean 	= subinstr(city_clean,"no.","",.)
  ```
- Line 579: city, precinct
  ```
  replace city_clean 	= subinstr(city_clean,"precinct","",.)
  ```
- Line 580: city
  ```
  replace city_clean 	= subinstr(city_clean,"subdivision","",.)
  ```
- Line 581: city
  ```
  replace city_clean 	= subinstr(city_clean,"beat","",.)
  ```
- Line 582: city
  ```
  replace city_clean 	= subinstr(city_clean,"plantation","",.)
  ```
- Line 583: census, city
  ```
  replace city_clean 	= subinstr(city_clean,"census designated place","",.)
  ```
- Line 584: city
  ```
  replace city_clean 	= subinstr(city_clean,"post office","",.)
  ```
- Line 585: city
  ```
  replace city_clean 	= subinstr(city_clean,"township of","",.)
  ```
- Line 586: city
  ```
  replace city_clean 	= subinstr(city_clean,"town of","",.)
  ```
- Line 587: city
  ```
  replace city_clean 	= subinstr(city_clean,"borough of","",.)
  ```
- Line 588: city
  ```
  replace city_clean 	= subinstr(city_clean,"city of","",.)
  ```
- Line 589: city
  ```
  replace city_clean 	= subinstr(city_clean,"ward ","",1) if substr(city_clean,1,5) == "ward "
  ```
- Line 590: city
  ```
  replace city_clean 	= subinstr(city_clean,"township ","",1) if substr(city_clean,1,9) == "township "
  ```
- Line 591: city
  ```
  replace city_clean 	= "" if strpos(city_clean,"division") > 0
  ```
- Line 592: city
  ```
  replace city_clean 	= subinstr(city_clean,"east side","",.)
  ```
- Line 593: city
  ```
  replace city_clean 	= subinstr(city_clean,"west side","",.)
  ```
- Line 594: city
  ```
  replace city_clean 	= subinstr(city_clean,"south side","",.)
  ```
- Line 595: city
  ```
  replace city_clean 	= subinstr(city_clean,"north side","",.)
  ```
- Line 596: city
  ```
  replace city_clean 	= subinstr(city_clean,"eastern side","",.)
  ```
- Line 597: city
  ```
  replace city_clean 	= subinstr(city_clean,"western side","",.)
  ```
- Line 598: city
  ```
  replace city_clean 	= subinstr(city_clean,"southern side","",.)
  ```
- Line 599: city
  ```
  replace city_clean 	= subinstr(city_clean,"northern side","",.)
  ```
- Line 600: city
  ```
  replace city_clean	= stritrim(city_clean)
  ```
- Line 601: city
  ```
  replace city_clean	= "" if length(city_clean) < 2
  ```
- Line 602: city
  ```
  replace city_clean	= strtrim(city_clean)
  ```
- Line 603: city
  ```
  replace city_clean	= lower(city_clean)
  ```
- Line 605: city
  ```
  replace city_clean 	= "east saint louis" if city_clean == "east st louis"
  ```
- Line 606: city, lon
  ```
  replace city_clean 	= "new york city" if city_clean == "long island city" & state == "NY"
  ```
- Line 608: city
  ```
  replace city_clean 	= subinstr(city_clean,"-","",.)
  ```
- Line 609: city
  ```
  replace city_clean 	= subinstr(city_clean,"south","",.)
  ```
- Line 610: city
  ```
  replace city_clean 	= subinstr(city_clean,"north","",.)
  ```
- Line 611: city
  ```
  replace city_clean 	= subinstr(city_clean,"east","",.)
  ```
- Line 612: city
  ```
  replace city_clean 	= subinstr(city_clean,"west","",.)
  ```
- Line 613: city
  ```
  replace city_clean 	= subinstr(city_clean,"southern","",.)
  ```
- Line 614: city
  ```
  replace city_clean 	= subinstr(city_clean,"northern","",.)
  ```
- Line 615: city
  ```
  replace city_clean 	= subinstr(city_clean,"eastern","",.)
  ```
- Line 616: city
  ```
  replace city_clean 	= subinstr(city_clean,"western","",.)
  ```
- Line 617: city
  ```
  replace city_clean 	= subinstr(city_clean," township","",.)
  ```
- Line 618: city
  ```
  replace city_clean 	= subinstr(city_clean," point","",.)
  ```
- Line 619: city
  ```
  replace city_clean 	= subinstr(city_clean," ","",.)
  ```
- Line 621: loc
  ```
  *Collapse at the local-year level
  ```
- Line 624: city, lat, lon
  ```
  gcollapse (sum) votes nr_delegates_* delegates_bpl_nonmissing delegates_anc_nonmissing (firstnm) lon
  ```
- Line 646: name
  ```
  rename (GISJOIN GISJOIN2) (gisjoin_1930 countynhg_1930)
  ```
- Line 656: loc, name
  ```
  rename lu_nr locals_votes
  ```
- Line 657: loc
  ```
  foreach var of varlist locals memb_proxy_votes nr_delegates_* {
  ```
- Line 658: name
  ```
  rename `var' UBC_`var'
  ```
- Line 664: loc
  ```
  UBC_memb_proxy_votes UBC_locals_votes
  ```
- Line 670: loc
  ```
  label var UBC_locals_votes "Number of UBC locals sending delegates"
  ```
- Line 672: birth, name
  ```
  label var UBC_nr_delegates_bpl_native "UBC delegates: native (last-name birthplace prob.)"
  ```
- Line 673: birth, name
  ```
  label var UBC_nr_delegates_bpl_other "UBC delegates: other origin (last-name birthplace prob.)"
  ```
- Line 674: birth, name
  ```
  label var UBC_nr_delegates_bpl_euroall "UBC delegates: any European (last-name birthplace prob.)"
  ```
- Line 675: birth, name
  ```
  label var UBC_nr_delegates_bpl_euronw "UBC delegates: NW European (last-name birthplace prob.)"
  ```
- Line 676: birth, name
  ```
  label var UBC_nr_delegates_bpl_eurose "UBC delegates: S/E European (last-name birthplace prob.)"
  ```
- Line 677: name
  ```
  label var UBC_nr_delegates_anc_other "UBC delegates: other origin (last-name ancestry prob.)"
  ```
- Line 678: name
  ```
  label var UBC_nr_delegates_anc_euroall "UBC delegates: any European (last-name ancestry prob.)"
  ```
- Line 679: name
  ```
  label var UBC_nr_delegates_anc_euronw "UBC delegates: NW European (last-name ancestry prob.)"
  ```
- Line 680: name
  ```
  label var UBC_nr_delegates_anc_eurose "UBC delegates: S/E European (last-name ancestry prob.)"
  ```
- Line 709: name
  ```
  rename user_* *
  ```
- Line 711: district
  ```
  replace state = "District of Columbia" if state == "Dc" | state == "DC" | state == "D.C."
  ```
- Line 719: name
  ```
  replace placename = "" if x == . & y == .
  ```
- Line 723: name
  ```
  foreach var of varlist placename {
  ```
- Line 724: name
  ```
  rename `var' geocode_`var'
  ```
- Line 728: name
  ```
  rename regionabbr statecode
  ```
- Line 729: loc, name
  ```
  rename local_nr lu_nr
  ```
- Line 730: lon, name
  ```
  rename x longitude
  ```
- Line 731: lat, name
  ```
  rename y latitude
  ```
- Line 733: lat, name
  ```
  *Isolate last names of delegates
  ```
- Line 754: name
  ```
  rename delegate_last delegate_lastname
  ```
- Line 764: lon, name
  ```
  *Merge last names (exact string matching) w/ probability of belonging to a specific ethnic group
  ```
- Line 765: name
  ```
  rename delegate_lastname namelast
  ```
- Line 769: name
  ```
  foreach var of varlist nameprob_bpl_* {
  ```
- Line 770: name
  ```
  replace `var' = . if namelast == ""
  ```
- Line 773: name
  ```
  *Merge last names (exact string matching) w/ ancestry
  ```
- Line 777: name
  ```
  foreach var of varlist nameprob_anc_* {
  ```
- Line 778: name
  ```
  replace `var' = . if namelast == ""
  ```
- Line 782: name
  ```
  gegen nr_delegates_bpl_native = rowtotal(nameprob_bpl_native), missing
  ```
- Line 786: name
  ```
  gegen nr_delegates_`j'_other = rowtotal(nameprob_`j'_other), missing
  ```
- Line 788: name
  ```
  gegen nr_delegates_`j'_euroall = rowtotal(nameprob_`j'_denmark nameprob_`j'_finland nameprob_`j'_nor
  ```
- Line 789: name
  ```
  nameprob_`j'_sweden nameprob_`j'_uk nameprob_`j'_ireland nameprob_`j'_oth_northeu ///
  ```
- Line 790: name
  ```
  nameprob_`j'_belgium nameprob_`j'_france nameprob_`j'_luxemb nameprob_`j'_nether ///
  ```
- Line 791: name
  ```
  nameprob_`j'_switz nameprob_`j'_oth_westeu ///
  ```
- Line 792: name
  ```
  nameprob_`j'_italy nameprob_`j'_gr_pt_es nameprob_`j'_oth_southeu ///
  ```
- Line 793: name
  ```
  nameprob_`j'_aus_hung nameprob_`j'_czech nameprob_`j'_germany nameprob_`j'_poland ///
  ```
- Line 794: name
  ```
  nameprob_`j'_oth_easteu nameprob_`j'_oth_centereu ///
  ```
- Line 795: name
  ```
  nameprob_`j'_russia nameprob_`j'_oth_russeu), missing
  ```
- Line 797: name
  ```
  gegen nr_delegates_`j'_euronw = rowtotal(nameprob_`j'_denmark nameprob_`j'_finland nameprob_`j'_norw
  ```
- Line 798: name
  ```
  nameprob_`j'_sweden nameprob_`j'_uk nameprob_`j'_ireland nameprob_`j'_oth_northeu ///
  ```
- Line 799: name
  ```
  nameprob_`j'_belgium nameprob_`j'_france nameprob_`j'_luxemb nameprob_`j'_nether ///
  ```
- Line 800: name
  ```
  nameprob_`j'_switz nameprob_`j'_oth_westeu ///
  ```
- Line 801: name
  ```
  nameprob_`j'_germany), missing
  ```
- Line 803: name
  ```
  gegen nr_delegates_`j'_eurose = rowtotal(nameprob_`j'_italy nameprob_`j'_gr_pt_es nameprob_`j'_oth_s
  ```
- Line 804: name
  ```
  nameprob_`j'_aus_hung nameprob_`j'_czech nameprob_`j'_poland ///
  ```
- Line 805: name
  ```
  nameprob_`j'_oth_easteu nameprob_`j'_oth_centereu ///
  ```
- Line 806: name
  ```
  nameprob_`j'_russia nameprob_`j'_oth_russeu), missing
  ```
- Line 810: name
  ```
  drop nameprob*
  ```
- Line 813: city, name
  ```
  * Normalize city names so that spelling variants collapse to a single key:
  ```
- Line 815: district
  ```
  * "st." -> "saint", ward / township / district / etc. suffixes), so that the
  ```
- Line 816: loc
  ```
  * local-year aggregation below treats e.g. "Saint Louis" and "St. Louis" as
  ```
- Line 818: city, name
  ```
  gen 	city_clean 	= lower(geocode_placename)
  ```
- Line 819: city
  ```
  replace city_clean	= lower(city) if city_clean == ""
  ```
- Line 820: city
  ```
  order city_clean, after(city)
  ```
- Line 821: city
  ```
  replace city_clean 	= subinstr(city_clean,"mt.","mount",.)
  ```
- Line 822: city
  ```
  replace city_clean 	= subinstr(city_clean,"mt ","mount ",.)
  ```
- Line 823: city
  ```
  replace city_clean 	= subinstr(city_clean,"st.","saint",.)
  ```
- Line 824: city
  ```
  replace city_clean 	= subinstr(city_clean,"st","saint",1) if substr(city_clean,1,3) == "st "
  ```
- Line 825: city
  ```
  replace city_clean 	= subinstr(city_clean,"indian reservation","reservation",.)
  ```
- Line 826: city
  ```
  replace city_clean 	= subinstr(city_clean,"0","",.)
  ```
- Line 827: city
  ```
  replace city_clean 	= subinstr(city_clean,"1","",.)
  ```
- Line 828: city
  ```
  replace city_clean 	= subinstr(city_clean,"2","",.)
  ```
- Line 829: city
  ```
  replace city_clean 	= subinstr(city_clean,"3","",.)
  ```
- Line 830: city
  ```
  replace city_clean 	= subinstr(city_clean,"4","",.)
  ```
- Line 831: city
  ```
  replace city_clean 	= subinstr(city_clean,"5","",.)
  ```
- Line 832: city
  ```
  replace city_clean 	= subinstr(city_clean,"6","",.)
  ```
- Line 833: city
  ```
  replace city_clean 	= subinstr(city_clean,"7","",.)
  ```
- Line 834: city
  ```
  replace city_clean 	= subinstr(city_clean,"8","",.)
  ```
- Line 835: city
  ```
  replace city_clean 	= subinstr(city_clean,"9","",.)
  ```
- Line 836: city
  ```
  replace city_clean 	= subinstr(city_clean,",","",.)
  ```
- Line 837: city
  ```
  replace city_clean 	= subinstr(city_clean,"?","",.)
  ```
- Line 838: city
  ```
  replace city_clean 	= subinstr(city_clean,".","",.)
  ```
- Line 839: city
  ```
  replace city_clean 	= subinstr(city_clean,"(","",.)
  ```
- Line 840: city
  ```
  replace city_clean 	= subinstr(city_clean,")","",.)
  ```
- Line 841: city
  ```
  replace city_clean 	= subinstr(city_clean,"/","",.)
  ```
- Line 842: city
  ```
  replace city_clean 	= subinstr(city_clean," range ","",.)
  ```
- Line 843: city
  ```
  replace city_clean 	= subinstr(city_clean," range(s) ","",.)
  ```
- Line 844: city
  ```
  replace city_clean 	= subinstr(city_clean," range","",.) if substr(city_clean,-6,6) == " range"
  ```
- Line 845: city
  ```
  replace city_clean 	= subinstr(city_clean," range(s)","",.) if substr(city_clean,-9,9) == " range(s)
  ```
- Line 846: city
  ```
  replace city_clean 	= subinstr(city_clean,"police jury","",.)
  ```
- Line 847: city
  ```
  replace city_clean 	= subinstr(city_clean,"justice ward","",.)
  ```
- Line 848: city, house
  ```
  replace city_clean 	= subinstr(city_clean,"court house","",.)
  ```
- Line 849: city, district
  ```
  replace city_clean 	= subinstr(city_clean,"militia district","",.)
  ```
- Line 850: city, district
  ```
  replace city_clean 	= subinstr(city_clean,"civil district","",.)
  ```
- Line 851: city, precinct
  ```
  replace city_clean 	= subinstr(city_clean,"justice precinct","",.)
  ```
- Line 852: city, district
  ```
  replace city_clean 	= subinstr(city_clean,"election district","",.)
  ```
- Line 853: city
  ```
  replace city_clean 	= subinstr(city_clean,"undetermined","",.)
  ```
- Line 854: city
  ```
  replace city_clean 	= subinstr(city_clean,"not stated","",.)
  ```
- Line 855: city, village
  ```
  replace city_clean 	= subinstr(city_clean," village","",.)
  ```
- Line 856: city
  ```
  replace city_clean 	= subinstr(city_clean,"tract","",.)
  ```
- Line 857: city
  ```
  replace city_clean 	= subinstr(city_clean," ward","",.)
  ```
- Line 858: city, district
  ```
  replace city_clean 	= subinstr(city_clean,"assembly district","",.)
  ```
- Line 859: city, district
  ```
  replace city_clean 	= subinstr(city_clean,"district","",.)
  ```
- Line 860: city
  ```
  replace city_clean 	= subinstr(city_clean,"no.","",.)
  ```
- Line 861: city, precinct
  ```
  replace city_clean 	= subinstr(city_clean,"precinct","",.)
  ```
- Line 862: city
  ```
  replace city_clean 	= subinstr(city_clean,"subdivision","",.)
  ```
- Line 863: city
  ```
  replace city_clean 	= subinstr(city_clean,"beat","",.)
  ```
- Line 864: city
  ```
  replace city_clean 	= subinstr(city_clean,"plantation","",.)
  ```
- Line 865: census, city
  ```
  replace city_clean 	= subinstr(city_clean,"census designated place","",.)
  ```
- Line 866: city
  ```
  replace city_clean 	= subinstr(city_clean,"post office","",.)
  ```
- Line 867: city
  ```
  replace city_clean 	= subinstr(city_clean,"township of","",.)
  ```
- Line 868: city
  ```
  replace city_clean 	= subinstr(city_clean,"town of","",.)
  ```
- Line 869: city
  ```
  replace city_clean 	= subinstr(city_clean,"borough of","",.)
  ```
- Line 870: city
  ```
  replace city_clean 	= subinstr(city_clean,"city of","",.)
  ```
- Line 871: city
  ```
  replace city_clean 	= subinstr(city_clean,"ward ","",1) if substr(city_clean,1,5) == "ward "
  ```
- Line 872: city
  ```
  replace city_clean 	= subinstr(city_clean,"township ","",1) if substr(city_clean,1,9) == "township "
  ```
- Line 873: city
  ```
  replace city_clean 	= "" if strpos(city_clean,"division") > 0
  ```
- Line 874: city
  ```
  replace city_clean 	= subinstr(city_clean,"east side","",.)
  ```
- Line 875: city
  ```
  replace city_clean 	= subinstr(city_clean,"west side","",.)
  ```
- Line 876: city
  ```
  replace city_clean 	= subinstr(city_clean,"south side","",.)
  ```
- Line 877: city
  ```
  replace city_clean 	= subinstr(city_clean,"north side","",.)
  ```
- Line 878: city
  ```
  replace city_clean 	= subinstr(city_clean,"eastern side","",.)
  ```
- Line 879: city
  ```
  replace city_clean 	= subinstr(city_clean,"western side","",.)
  ```
- Line 880: city
  ```
  replace city_clean 	= subinstr(city_clean,"southern side","",.)
  ```
- Line 881: city
  ```
  replace city_clean 	= subinstr(city_clean,"northern side","",.)
  ```
- Line 882: city
  ```
  replace city_clean	= stritrim(city_clean)
  ```
- Line 883: city
  ```
  replace city_clean	= "" if length(city_clean) < 2
  ```
- Line 884: city
  ```
  replace city_clean	= strtrim(city_clean)
  ```
- Line 885: city
  ```
  replace city_clean	= lower(city_clean)
  ```
- Line 887: city
  ```
  replace city_clean 	= "east saint louis" if city_clean == "east st louis"
  ```
- Line 888: city, lon
  ```
  replace city_clean 	= "new york city" if city_clean == "long island city" & state == "NY"
  ```
- Line 890: city
  ```
  replace city_clean 	= subinstr(city_clean,"-","",.)
  ```
- Line 891: city
  ```
  replace city_clean 	= subinstr(city_clean,"south","",.)
  ```
- Line 892: city
  ```
  replace city_clean 	= subinstr(city_clean,"north","",.)
  ```
- Line 893: city
  ```
  replace city_clean 	= subinstr(city_clean,"east","",.)
  ```
- Line 894: city
  ```
  replace city_clean 	= subinstr(city_clean,"west","",.)
  ```
- Line 895: city
  ```
  replace city_clean 	= subinstr(city_clean,"southern","",.)
  ```
- Line 896: city
  ```
  replace city_clean 	= subinstr(city_clean,"northern","",.)
  ```
- Line 897: city
  ```
  replace city_clean 	= subinstr(city_clean,"eastern","",.)
  ```
- Line 898: city
  ```
  replace city_clean 	= subinstr(city_clean,"western","",.)
  ```
- Line 899: city
  ```
  replace city_clean 	= subinstr(city_clean," township","",.)
  ```
- Line 900: city
  ```
  replace city_clean 	= subinstr(city_clean," point","",.)
  ```
- Line 901: city
  ```
  replace city_clean 	= subinstr(city_clean," ","",.)
  ```
- Line 903: loc
  ```
  *Collapse at the local-year level
  ```
- Line 906: city, lat, lon
  ```
  gcollapse (sum) votes nr_delegates_* delegates_bpl_nonmissing delegates_anc_nonmissing (firstnm) lon
  ```
- Line 930: name
  ```
  rename (GISJOIN GISJOIN2) (gisjoin_1930 countynhg_1930)
  ```
- Line 941: loc, name
  ```
  rename lu_nr locals_votes
  ```
- Line 942: loc
  ```
  foreach var of varlist locals memb_proxy_votes nr_delegates_* {
  ```
- Line 943: name
  ```
  rename `var' IAM_`var'
  ```
- Line 949: loc
  ```
  IAM_memb_proxy_votes IAM_locals_votes
  ```
- Line 955: loc
  ```
  label var IAM_locals_votes "Number of IAM locals sending delegates"
  ```
- Line 957: birth, name
  ```
  label var IAM_nr_delegates_bpl_native "IAM delegates: native (last-name birthplace prob.)"
  ```
- Line 958: birth, name
  ```
  label var IAM_nr_delegates_bpl_other "IAM delegates: other origin (last-name birthplace prob.)"
  ```
- Line 959: birth, name
  ```
  label var IAM_nr_delegates_bpl_euroall "IAM delegates: any European (last-name birthplace prob.)"
  ```
- Line 960: birth, name
  ```
  label var IAM_nr_delegates_bpl_euronw "IAM delegates: NW European (last-name birthplace prob.)"
  ```
- Line 961: birth, name
  ```
  label var IAM_nr_delegates_bpl_eurose "IAM delegates: S/E European (last-name birthplace prob.)"
  ```
- Line 962: name
  ```
  label var IAM_nr_delegates_anc_other "IAM delegates: other origin (last-name ancestry prob.)"
  ```
- Line 963: name
  ```
  label var IAM_nr_delegates_anc_euroall "IAM delegates: any European (last-name ancestry prob.)"
  ```
- Line 964: name
  ```
  label var IAM_nr_delegates_anc_euronw "IAM delegates: NW European (last-name ancestry prob.)"
  ```
- Line 965: name
  ```
  label var IAM_nr_delegates_anc_eurose "IAM delegates: S/E European (last-name ancestry prob.)"
  ```
- Line 971: son
  ```
  * BMPIU -- Bricklayers, Masons & Plasterers' International Union
  ```
- Line 979: loc
  ```
  * So a local with N members has total votes = 3 + max(0, ceil((N-250)/150)),
  ```
- Line 993: name
  ```
  rename user_* *
  ```
- Line 995: district
  ```
  replace state = "District of Columbia" if state == "Dc" | state == "DC" | state == "D.C."
  ```
- Line 1003: name
  ```
  replace placename = "" if x == . & y == .
  ```
- Line 1007: name
  ```
  foreach var of varlist placename {
  ```
- Line 1008: name
  ```
  rename `var' geocode_`var'
  ```
- Line 1012: name
  ```
  rename regionabbr statecode
  ```
- Line 1013: lon, name
  ```
  rename x longitude
  ```
- Line 1014: lat, name
  ```
  rename y latitude
  ```
- Line 1016: lat, name
  ```
  *Isolate last names of delegates
  ```
- Line 1036: name
  ```
  rename delegate_last delegate_lastname
  ```
- Line 1046: lon, name
  ```
  *Merge last names (exact string matching) w/ probability of belonging to a specific ethnic group
  ```
- Line 1047: name
  ```
  rename delegate_lastname namelast
  ```
- Line 1051: name
  ```
  foreach var of varlist nameprob_bpl_* {
  ```
- Line 1052: name
  ```
  replace `var' = . if namelast == ""
  ```
- Line 1055: name
  ```
  *Merge last names (exact string matching) w/ ancestry
  ```
- Line 1059: name
  ```
  foreach var of varlist nameprob_anc_* {
  ```
- Line 1060: name
  ```
  replace `var' = . if namelast == ""
  ```
- Line 1064: name
  ```
  gegen nr_delegates_bpl_native = rowtotal(nameprob_bpl_native), missing
  ```
- Line 1068: name
  ```
  gegen nr_delegates_`j'_other = rowtotal(nameprob_`j'_other), missing
  ```
- Line 1070: name
  ```
  gegen nr_delegates_`j'_euroall = rowtotal(nameprob_`j'_denmark nameprob_`j'_finland nameprob_`j'_nor
  ```
- Line 1071: name
  ```
  nameprob_`j'_sweden nameprob_`j'_uk nameprob_`j'_ireland nameprob_`j'_oth_northeu ///
  ```
- Line 1072: name
  ```
  nameprob_`j'_belgium nameprob_`j'_france nameprob_`j'_luxemb nameprob_`j'_nether ///
  ```
- Line 1073: name
  ```
  nameprob_`j'_switz nameprob_`j'_oth_westeu ///
  ```
- Line 1074: name
  ```
  nameprob_`j'_italy nameprob_`j'_gr_pt_es nameprob_`j'_oth_southeu ///
  ```
- Line 1075: name
  ```
  nameprob_`j'_aus_hung nameprob_`j'_czech nameprob_`j'_germany nameprob_`j'_poland ///
  ```
- Line 1076: name
  ```
  nameprob_`j'_oth_easteu nameprob_`j'_oth_centereu ///
  ```
- Line 1077: name
  ```
  nameprob_`j'_russia nameprob_`j'_oth_russeu), missing
  ```
- Line 1079: name
  ```
  gegen nr_delegates_`j'_euronw = rowtotal(nameprob_`j'_denmark nameprob_`j'_finland nameprob_`j'_norw
  ```
- Line 1080: name
  ```
  nameprob_`j'_sweden nameprob_`j'_uk nameprob_`j'_ireland nameprob_`j'_oth_northeu ///
  ```
- Line 1081: name
  ```
  nameprob_`j'_belgium nameprob_`j'_france nameprob_`j'_luxemb nameprob_`j'_nether ///
  ```
- Line 1082: name
  ```
  nameprob_`j'_switz nameprob_`j'_oth_westeu ///
  ```
- Line 1083: name
  ```
  nameprob_`j'_germany), missing
  ```
- Line 1085: name
  ```
  gegen nr_delegates_`j'_eurose = rowtotal(nameprob_`j'_italy nameprob_`j'_gr_pt_es nameprob_`j'_oth_s
  ```
- Line 1086: name
  ```
  nameprob_`j'_aus_hung nameprob_`j'_czech nameprob_`j'_poland ///
  ```
- Line 1087: name
  ```
  nameprob_`j'_oth_easteu nameprob_`j'_oth_centereu ///
  ```
- Line 1088: name
  ```
  nameprob_`j'_russia nameprob_`j'_oth_russeu), missing
  ```
- Line 1092: name
  ```
  drop nameprob*
  ```
- Line 1096: city, name
  ```
  * Normalize city names so that spelling variants collapse to a single key:
  ```
- Line 1098: district
  ```
  * "st." -> "saint", ward / township / district / etc. suffixes), so that the
  ```
- Line 1099: loc
  ```
  * local-year aggregation below treats e.g. "Saint Louis" and "St. Louis" as
  ```
- Line 1101: city, name
  ```
  gen 	city_clean 	= lower(geocode_placename)
  ```
- Line 1102: city
  ```
  replace city_clean	= lower(city) if city_clean == ""
  ```
- Line 1103: city
  ```
  order city_clean, after(city)
  ```
- Line 1104: city
  ```
  replace city_clean 	= subinstr(city_clean,"mt.","mount",.)
  ```
- Line 1105: city
  ```
  replace city_clean 	= subinstr(city_clean,"mt ","mount ",.)
  ```
- Line 1106: city
  ```
  replace city_clean 	= subinstr(city_clean,"st.","saint",.)
  ```
- Line 1107: city
  ```
  replace city_clean 	= subinstr(city_clean,"st","saint",1) if substr(city_clean,1,3) == "st "
  ```
- Line 1108: city
  ```
  replace city_clean 	= subinstr(city_clean,"indian reservation","reservation",.)
  ```
- Line 1109: city
  ```
  replace city_clean 	= subinstr(city_clean,"0","",.)
  ```
- Line 1110: city
  ```
  replace city_clean 	= subinstr(city_clean,"1","",.)
  ```
- Line 1111: city
  ```
  replace city_clean 	= subinstr(city_clean,"2","",.)
  ```
- Line 1112: city
  ```
  replace city_clean 	= subinstr(city_clean,"3","",.)
  ```
- Line 1113: city
  ```
  replace city_clean 	= subinstr(city_clean,"4","",.)
  ```
- Line 1114: city
  ```
  replace city_clean 	= subinstr(city_clean,"5","",.)
  ```
- Line 1115: city
  ```
  replace city_clean 	= subinstr(city_clean,"6","",.)
  ```
- Line 1116: city
  ```
  replace city_clean 	= subinstr(city_clean,"7","",.)
  ```
- Line 1117: city
  ```
  replace city_clean 	= subinstr(city_clean,"8","",.)
  ```
- Line 1118: city
  ```
  replace city_clean 	= subinstr(city_clean,"9","",.)
  ```
- Line 1119: city
  ```
  replace city_clean 	= subinstr(city_clean,",","",.)
  ```
- Line 1120: city
  ```
  replace city_clean 	= subinstr(city_clean,"?","",.)
  ```
- Line 1121: city
  ```
  replace city_clean 	= subinstr(city_clean,".","",.)
  ```
- Line 1122: city
  ```
  replace city_clean 	= subinstr(city_clean,"(","",.)
  ```
- Line 1123: city
  ```
  replace city_clean 	= subinstr(city_clean,")","",.)
  ```
- Line 1124: city
  ```
  replace city_clean 	= subinstr(city_clean,"/","",.)
  ```
- Line 1125: city
  ```
  replace city_clean 	= subinstr(city_clean," range ","",.)
  ```
- Line 1126: city
  ```
  replace city_clean 	= subinstr(city_clean," range(s) ","",.)
  ```
- Line 1127: city
  ```
  replace city_clean 	= subinstr(city_clean," range","",.) if substr(city_clean,-6,6) == " range"
  ```
- Line 1128: city
  ```
  replace city_clean 	= subinstr(city_clean," range(s)","",.) if substr(city_clean,-9,9) == " range(s)
  ```
- Line 1129: city
  ```
  replace city_clean 	= subinstr(city_clean,"police jury","",.)
  ```
- Line 1130: city
  ```
  replace city_clean 	= subinstr(city_clean,"justice ward","",.)
  ```
- Line 1131: city, house
  ```
  replace city_clean 	= subinstr(city_clean,"court house","",.)
  ```
- Line 1132: city, district
  ```
  replace city_clean 	= subinstr(city_clean,"militia district","",.)
  ```
- Line 1133: city, district
  ```
  replace city_clean 	= subinstr(city_clean,"civil district","",.)
  ```
- Line 1134: city, precinct
  ```
  replace city_clean 	= subinstr(city_clean,"justice precinct","",.)
  ```
- Line 1135: city, district
  ```
  replace city_clean 	= subinstr(city_clean,"election district","",.)
  ```
- Line 1136: city
  ```
  replace city_clean 	= subinstr(city_clean,"undetermined","",.)
  ```
- Line 1137: city
  ```
  replace city_clean 	= subinstr(city_clean,"not stated","",.)
  ```
- Line 1138: city, village
  ```
  replace city_clean 	= subinstr(city_clean," village","",.)
  ```
- Line 1139: city
  ```
  replace city_clean 	= subinstr(city_clean,"tract","",.)
  ```
- Line 1140: city
  ```
  replace city_clean 	= subinstr(city_clean," ward","",.)
  ```
- Line 1141: city, district
  ```
  replace city_clean 	= subinstr(city_clean,"assembly district","",.)
  ```
- Line 1142: city, district
  ```
  replace city_clean 	= subinstr(city_clean,"district","",.)
  ```
- Line 1143: city
  ```
  replace city_clean 	= subinstr(city_clean,"no.","",.)
  ```
- Line 1144: city, precinct
  ```
  replace city_clean 	= subinstr(city_clean,"precinct","",.)
  ```
- Line 1145: city
  ```
  replace city_clean 	= subinstr(city_clean,"subdivision","",.)
  ```
- Line 1146: city
  ```
  replace city_clean 	= subinstr(city_clean,"beat","",.)
  ```
- Line 1147: city
  ```
  replace city_clean 	= subinstr(city_clean,"plantation","",.)
  ```
- Line 1148: census, city
  ```
  replace city_clean 	= subinstr(city_clean,"census designated place","",.)
  ```
- Line 1149: city
  ```
  replace city_clean 	= subinstr(city_clean,"post office","",.)
  ```
- Line 1150: city
  ```
  replace city_clean 	= subinstr(city_clean,"township of","",.)
  ```
- Line 1151: city
  ```
  replace city_clean 	= subinstr(city_clean,"town of","",.)
  ```
- Line 1152: city
  ```
  replace city_clean 	= subinstr(city_clean,"borough of","",.)
  ```
- Line 1153: city
  ```
  replace city_clean 	= subinstr(city_clean,"city of","",.)
  ```
- Line 1154: city
  ```
  replace city_clean 	= subinstr(city_clean,"ward ","",1) if substr(city_clean,1,5) == "ward "
  ```
- Line 1155: city
  ```
  replace city_clean 	= subinstr(city_clean,"township ","",1) if substr(city_clean,1,9) == "township "
  ```
- Line 1156: city
  ```
  replace city_clean 	= "" if strpos(city_clean,"division") > 0
  ```
- Line 1157: city
  ```
  replace city_clean 	= subinstr(city_clean,"east side","",.)
  ```
- Line 1158: city
  ```
  replace city_clean 	= subinstr(city_clean,"west side","",.)
  ```
- Line 1159: city
  ```
  replace city_clean 	= subinstr(city_clean,"south side","",.)
  ```
- Line 1160: city
  ```
  replace city_clean 	= subinstr(city_clean,"north side","",.)
  ```
- Line 1161: city
  ```
  replace city_clean 	= subinstr(city_clean,"eastern side","",.)
  ```
- Line 1162: city
  ```
  replace city_clean 	= subinstr(city_clean,"western side","",.)
  ```
- Line 1163: city
  ```
  replace city_clean 	= subinstr(city_clean,"southern side","",.)
  ```
- Line 1164: city
  ```
  replace city_clean 	= subinstr(city_clean,"northern side","",.)
  ```
- Line 1165: city
  ```
  replace city_clean	= stritrim(city_clean)
  ```
- Line 1166: city
  ```
  replace city_clean	= "" if length(city_clean) < 2
  ```
- Line 1167: city
  ```
  replace city_clean	= strtrim(city_clean)
  ```
- Line 1168: city
  ```
  replace city_clean	= lower(city_clean)
  ```
- Line 1170: city
  ```
  replace city_clean 	= "east saint louis" if city_clean == "east st louis"
  ```
- Line 1171: city, lon
  ```
  replace city_clean 	= "new york city" if city_clean == "long island city" & state == "NY"
  ```
- Line 1173: city
  ```
  replace city_clean 	= subinstr(city_clean,"-","",.)
  ```
- Line 1174: city
  ```
  replace city_clean 	= subinstr(city_clean,"south","",.)
  ```
- Line 1175: city
  ```
  replace city_clean 	= subinstr(city_clean,"north","",.)
  ```
- Line 1176: city
  ```
  replace city_clean 	= subinstr(city_clean,"east","",.)
  ```
- Line 1177: city
  ```
  replace city_clean 	= subinstr(city_clean,"west","",.)
  ```
- Line 1178: city
  ```
  replace city_clean 	= subinstr(city_clean,"southern","",.)
  ```
- Line 1179: city
  ```
  replace city_clean 	= subinstr(city_clean,"northern","",.)
  ```
- Line 1180: city
  ```
  replace city_clean 	= subinstr(city_clean,"eastern","",.)
  ```
- Line 1181: city
  ```
  replace city_clean 	= subinstr(city_clean,"western","",.)
  ```
- Line 1182: city
  ```
  replace city_clean 	= subinstr(city_clean," township","",.)
  ```
- Line 1183: city
  ```
  replace city_clean 	= subinstr(city_clean," point","",.)
  ```
- Line 1184: city
  ```
  replace city_clean 	= subinstr(city_clean," ","",.)
  ```
- Line 1186: loc
  ```
  *Collapse at the local-year level
  ```
- Line 1189: city, lat, lon
  ```
  gcollapse (sum) votes nr_delegates_* delegates_bpl_nonmissing delegates_anc_nonmissing (firstnm) lon
  ```
- Line 1208: name
  ```
  rename (GISJOIN GISJOIN2) (gisjoin_1930 countynhg_1930)
  ```
- Line 1219: loc, name
  ```
  rename lu_nr locals_votes
  ```
- Line 1220: loc
  ```
  foreach var of varlist locals memb_proxy_votes nr_delegates_* {
  ```
- Line 1221: name
  ```
  rename `var' BMPIU_`var'
  ```
- Line 1227: loc
  ```
  BMPIU_memb_proxy_votes BMPIU_locals_votes
  ```
- Line 1233: loc
  ```
  label var BMPIU_locals_votes "Number of BMPIU locals sending delegates"
  ```
- Line 1235: birth, name
  ```
  label var BMPIU_nr_delegates_bpl_native "BMPIU delegates: native (last-name birthplace prob.)"
  ```
- Line 1236: birth, name
  ```
  label var BMPIU_nr_delegates_bpl_other "BMPIU delegates: other origin (last-name birthplace prob.)"
  ```
- Line 1237: birth, name
  ```
  label var BMPIU_nr_delegates_bpl_euroall "BMPIU delegates: any European (last-name birthplace prob.)
  ```
- Line 1238: birth, name
  ```
  label var BMPIU_nr_delegates_bpl_euronw "BMPIU delegates: NW European (last-name birthplace prob.)"
  ```
- Line 1239: birth, name
  ```
  label var BMPIU_nr_delegates_bpl_eurose "BMPIU delegates: S/E European (last-name birthplace prob.)"
  ```
- Line 1240: name
  ```
  label var BMPIU_nr_delegates_anc_other "BMPIU delegates: other origin (last-name ancestry prob.)"
  ```
- Line 1241: name
  ```
  label var BMPIU_nr_delegates_anc_euroall "BMPIU delegates: any European (last-name ancestry prob.)"
  ```
- Line 1242: name
  ```
  label var BMPIU_nr_delegates_anc_euronw "BMPIU delegates: NW European (last-name ancestry prob.)"
  ```
- Line 1243: name
  ```
  label var BMPIU_nr_delegates_anc_eurose "BMPIU delegates: S/E European (last-name ancestry prob.)"
  ```
- Line 1248: loc
  ```
  * ITU -- International Typographical Union, per-local membership
  ```
- Line 1250: loc
  ```
  * The ITU convention proceedings list per-local membership directly,
  ```
- Line 1261: name
  ```
  rename user_* *
  ```
- Line 1263: district
  ```
  replace state = "District of Columbia" if state == "Dc" | state == "DC" | state == "D.C."
  ```
- Line 1271: name
  ```
  replace placename = "" if x == . & y == .
  ```
- Line 1275: name
  ```
  foreach var of varlist placename {
  ```
- Line 1276: name
  ```
  rename `var' geocode_`var'
  ```
- Line 1280: name
  ```
  rename regionabbr statecode
  ```
- Line 1281: lon, name
  ```
  rename x longitude
  ```
- Line 1282: lat, name
  ```
  rename y latitude
  ```
- Line 1295: name
  ```
  rename (GISJOIN GISJOIN2) (gisjoin_1930 countynhg_1930)
  ```
- Line 1300: loc, name
  ```
  rename lu_nr locals_votes
  ```
- Line 1301: loc
  ```
  foreach var of varlist locals members {
  ```
- Line 1302: name
  ```
  rename `var' ITU_`var'
  ```
- Line 1306: loc
  ```
  keep year gisjoin_1930 countynhg_1930 ITU_locals_votes ITU_members
  ```
- Line 1312: loc
  ```
  label var ITU_locals_votes "Number of ITU locals reporting members"
  ```
- Line 1313: loc
  ```
  label var ITU_members "ITU membership reported per-local in proceedings"
  ```

**/replication-package/MS20241468_Deposit/build_documentation/scripts/b12_unions_combine.do**

- Line 6: loc
  ```
  * (UMWA, UBC, IAM, BMPIU, ITU). For each county, membership and locals counts
  ```
- Line 7: census
  ```
  * that are unobserved in a census year but bracketed by observed years are
  ```
- Line 8: lat
  ```
  * linearly interpolated; counties in state-years with observed conventions but no
  ```
- Line 12: census
  ```
  * are derived. The output is the combined union counts at the county-census-year
  ```
- Line 16: census
  ```
  * The construction is built on a frame of every 1930 county and census year
  ```
- Line 38: name
  ```
  rename gisjoin2 countynhg_1930
  ```
- Line 40: name
  ```
  rename state statefip
  ```
- Line 103: lat
  ```
  * AFL state-convention merge: no-data flags, interpolation, zero-fills
  ```
- Line 108: name
  ```
  * keeps the mixed-case variable names (UMWA*, UBC*, IAM*, BMPIU*, ITU*).
  ```
- Line 113: lat
  ```
  * The 1930 state-convention records are the t+10 bracket used to interpolate 1920
  ```
- Line 132: lat
  ```
  * Delegate-origin counts (afl_nr_del_*) are tabulated for 1900-1920 only. For a county
  ```
- Line 136: lat
  ```
  * interpolation resolves to 1920 = (1910 + 0)/2 rather than leaving 1920 missing.
  ```
- Line 197: lat
  ```
  **Pass 1: interpolate missing afl_* between t-10 and t+10 where both bracket years are observed
  ```
- Line 214: lat
  ```
  **Pass 2: re-interpolate now that the zero-fills have populated additional bracket years
  ```
- Line 226: lat
  ```
  * For each union: merge, drop master-only matches that violate 1:1
  ```
- Line 227: census
  ```
  * (_m_<UNION>dens == 2), flag census years that are missing but bracketed
  ```
- Line 228: lat
  ```
  * by observed proxies (the *_interp dummies), linearly interpolate those
  ```
- Line 237: loc
  ```
  foreach var of varlist UMWA_locals_votes UMWA_memb_proxy_votes {
  ```
- Line 240: loc
  ```
  foreach var of varlist UMWA_locals_votes UMWA_memb_proxy_votes {
  ```
- Line 251: loc
  ```
  foreach var of varlist UBC_locals_votes UBC_memb_proxy_votes {
  ```
- Line 254: loc
  ```
  foreach var of varlist UBC_locals_votes UBC_memb_proxy_votes {
  ```
- Line 262: loc
  ```
  foreach var of varlist IAM_locals_votes IAM_memb_proxy_votes {
  ```
- Line 265: loc
  ```
  foreach var of varlist IAM_locals_votes IAM_memb_proxy_votes {
  ```
- Line 273: loc
  ```
  foreach var of varlist BMPIU_locals_votes BMPIU_memb_proxy_votes {
  ```
- Line 276: loc
  ```
  foreach var of varlist BMPIU_locals_votes BMPIU_memb_proxy_votes {
  ```
- Line 284: loc
  ```
  foreach var of varlist ITU_locals_votes ITU_members {
  ```
- Line 287: loc
  ```
  foreach var of varlist ITU_locals_votes ITU_members {
  ```
- Line 296: name
  ```
  rename *nr_del* *del*
  ```
- Line 304: name
  ```
  rename (UMWA_* UBC_* IAM_* BMPIU_* ITU_*) (umwa_* ubc_* iam_* bmpiu_* itu_*)
  ```
- Line 309: loc
  ```
  *    AFL locals/members derivations
  ```
- Line 320: loc
  ```
  * 1900, 1910, 1920; computes AFL locals derivations (skilled/unskilled
  ```
- Line 323: loc
  ```
  * total LF, total LF including women) and locals per labor force; closes
  ```
- Line 324: name
  ```
  * with a final rename cascade ((*_members_combined) -> (afl_memb_comb_*),
  ```
- Line 331: loc
  ```
  * Combined union membership and locals (AFL aggregate + convention proceedings)
  ```
- Line 337: name
  ```
  rename itu_members itu_memb_proxy_votes
  ```
- Line 348: loc
  ```
  ***Locals
  ```
- Line 349: loc
  ```
  gegen 	`union'_locals_combined = rowmean(`union'_locals_votes afl_locals_`union') if inlist(year,190
  ```
- Line 350: loc
  ```
  replace `union'_locals_combined = `union'_locals_votes if afl_locals_`union' == 0 & `union'_locals_v
  ```
- Line 351: loc
  ```
  replace `union'_locals_combined = afl_locals_`union' if `union'_locals_votes == 0 & afl_locals_`unio
  ```
- Line 353: loc
  ```
  replace `union'_locals_combined = . if state_notinsample == 1
  ```
- Line 356: name
  ```
  rename itu_memb_proxy_votes itu_members
  ```
- Line 363: name
  ```
  * ethnic breakdown the AFL_members aggregate carries. Then rename the
  ```
- Line 371: name
  ```
  rename afl_del_bpl_*_`union' afl_`union'_del_bpl_*
  ```
- Line 372: name
  ```
  rename afl_del_anc_*_`union' afl_`union'_del_anc_*
  ```
- Line 375: name
  ```
  **Shorten convention-proceedings rename: delegates -> del
  ```
- Line 376: name
  ```
  rename (*_delegates_bpl_* *_delegates_anc_*) (*_del_bpl_* *_del_anc_*)
  ```
- Line 379: name
  ```
  rename *bpl_euroall *bpl_euro
  ```
- Line 380: name
  ```
  rename *anc_euroall *anc_euro
  ```
- Line 455: loc
  ```
  * AFL locals derivations: total, skilled/unskilled
  ```
- Line 458: census
  ```
  * Census of Mines (miners and mechanics vs. laborers and boys under 16).
  ```
- Line 462: loc
  ```
  **AFL locals
  ```
- Line 463: loc, name
  ```
  rename afl_locals_tot afl_locals_all
  ```
- Line 465: loc
  ```
  gen		afl_locals_noumwa		= afl_locals_all - afl_locals_umwa if inlist(year,1900,1910,1920)
  ```
- Line 467: loc
  ```
  gen		afl_locals_comb			= afl_locals_all ///
  ```
- Line 468: loc
  ```
  - afl_locals_umwa + umwa_locals_combined ///
  ```
- Line 469: loc
  ```
  - afl_locals_ubc + ubc_locals_combined ///
  ```
- Line 470: loc
  ```
  - afl_locals_iam + iam_locals_combined ///
  ```
- Line 471: loc
  ```
  - afl_locals_bmpiu + bmpiu_locals_combined ///
  ```
- Line 472: loc
  ```
  - afl_locals_itu + itu_locals_combined ///
  ```
- Line 475: loc
  ```
  gen		afl_locals_comb_noumwa	= afl_locals_comb - umwa_locals_combined if inlist(year,1900,1910,1920)
  ```
- Line 477: census, loc
  ```
  **UMWA locals apportionment: 57% skilled / 43% unskilled (1890 Census of Mines).
  ```
- Line 479: loc
  ```
  gen 	afl_locals_comb_unsk	= (umwa_locals_combined*0.43) + afl_locals_ibt + ///
  ```
- Line 480: loc
  ```
  afl_locals_ila + afl_locals_amc + afl_locals_iummsw + ///
  ```
- Line 481: loc
  ```
  afl_locals_ugwa + afl_locals_utw + afl_locals_brew ///
  ```
- Line 484: loc
  ```
  gen 	afl_locals_unsk			= (afl_locals_umwa*0.43) + afl_locals_ibt + ///
  ```
- Line 485: loc
  ```
  afl_locals_ila + afl_locals_amc + afl_locals_iummsw + ///
  ```
- Line 486: loc
  ```
  afl_locals_ugwa + afl_locals_utw + afl_locals_brew ///
  ```
- Line 489: loc
  ```
  gen 	afl_locals_comb_sk		= afl_locals_comb - afl_locals_comb_unsk if inlist(year,1900,1910,1920)
  ```
- Line 491: loc
  ```
  gen 	afl_locals_sk			= afl_locals_all - afl_locals_unsk if inlist(year,1900,1910,1920)
  ```
- Line 497: name
  ```
  * `afl_members` is renamed to `afl_members_all`. Skill variants applied as
  ```
- Line 498: block, loc
  ```
  * in the locals block above. Densities computed at four denominators:
  ```
- Line 505: name
  ```
  rename afl_members afl_members_all
  ```
- Line 519: census
  ```
  **UMWA members: 57% skilled / 43% unskilled (1890 Census of Mines).
  ```
- Line 520: block, loc
  ```
  **IBT treated as fully unskilled (see locals block above).
  ```
- Line 552: lat
  ```
  * delegate-interpolation bracket, already consumed in the interpolation above.
  ```

**/replication-package/MS20241468_Deposit/build_documentation/scripts/b13_iww.do**

- Line 5: loc
  ```
  * Industrial Workers of the World locals list (IWW History Project, Civil
  ```
- Line 17: loc
  ```
  *   manual - the IWW locals list was geocoded with the ArcGIS "Geocode
  ```
- Line 18: address, loc
  ```
  *            Addresses" tool against a U.S. address locator. The result is
  ```
- Line 33: loc, zip
  ```
  * of the shipped package (exclude data/_raw_local/ when building the public zip).
  ```
- Line 36: loc
  ```
  global unionsrc    "$root/data/_raw_local/union_sources"
  ```
- Line 47: coord
  ```
  coordinates("$unionsrc/US_county_1930_WGS84_coord") replace
  ```
- Line 51: loc
  ```
  * Read the geocoded locals list and clean it
  ```
- Line 57: lon
  ```
  * geocoding output fields (longlabel, x, y, score, type); strip the prefix.
  ```
- Line 58: lon
  ```
  keep user_* longlabel x y score type
  ```
- Line 60: name
  ```
  rename user_* *
  ```
- Line 62: loc
  ```
  * Drop locals geocoded outside the United States
  ```
- Line 67: coord
  ```
  * Blank out coordinates for low ArcGIS match scores (< 85) and for non-point
  ```
- Line 72: lon
  ```
  foreach var of varlist longlabel type {
  ```
- Line 73: name
  ```
  rename `var' geocode_`var'
  ```
- Line 76: lon, name
  ```
  rename x longitude
  ```
- Line 77: lat, name
  ```
  rename y latitude
  ```
- Line 79: lat, lon
  ```
  drop if longitude == . | latitude == .
  ```
- Line 84: loc
  ```
  * Note: geoinpoly may assign a small number of boundary-adjacent localities to a
  ```
- Line 95: name
  ```
  rename (GISJOIN GISJOIN2) (gisjoin_1930 countynhg_1930)
  ```
- Line 97: loc
  ```
  gen IWW_locals = 1
  ```
- Line 98: loc
  ```
  gcollapse (count) IWW_locals, by(gisjoin_1930 countynhg_1930)
  ```

**/replication-package/MS20241468_Deposit/build_documentation/scripts/b14_kol.do**

- Line 6: loc
  ```
  * (Garlock).
  ```
- Line 17: loc, location
  ```
  *   part 1 - read and clean ICPSR 29, build a list of KoL-local locations, and
  ```
- Line 19: address, loc, location
  ```
  *   manual - geocode the location list with the ArcGIS "Geocode Addresses" tool
  ```
- Line 20: address, loc, location
  ```
  *            against a U.S. address locator. The result -- one row per location,
  ```
- Line 27: loc
  ```
  * Input (working file, not shipped): $rawlocal/ICPSR_00029/DS0001/00029-0001-Data.txt
  ```
- Line 37: loc, zip
  ```
  * of the shipped package (exclude data/_raw_local/ when building the public zip).
  ```
- Line 41: loc
  ```
  global unionsrc    "$root/data/_raw_local/union_sources"
  ```
- Line 46: loc, location
  ```
  * Part 1 - read ICPSR 29 and build the location list to geocode
  ```
- Line 107: loc
  ```
  label var V1 "Local assembly number"
  ```
- Line 108: loc
  ```
  label var V2 "Duplicate local assembly number indicator"
  ```
- Line 109: loc, location, name
  ```
  label var V3 "Name of location"
  ```
- Line 119: city, sex
  ```
  label var V13 "Race, sex, ethnicity"
  ```
- Line 128: lat
  ```
  label var V22 "Population 1880"
  ```
- Line 129: lat
  ```
  label var V23 "Population 1890"
  ```
- Line 135: loc, location, name
  ```
  * Destring all numeric fields (V3, the location name, stays a string)
  ```
- Line 147: loc
  ```
  * Drop non-U.S. assemblies (V4 50-63) and locals with no county (V5 == 0)
  ```
- Line 204: loc
  ```
  * Expand to a local x {1880, 1890} panel and keep each local only in the
  ```
- Line 205: census
  ```
  * census years when it was active -- created by then (V7) and not yet
  ```
- Line 214: loc
  ```
  * V1 (the local assembly number) becomes the unit to count below. collapse
  ```
- Line 215: loc
  ```
  * (count) ignores missings, so locals with no assembly number are set to a
  ```
- Line 216: loc
  ```
  * sentinel (99999) to ensure every local is counted.
  ```
- Line 217: city, loc, name
  ```
  rename (V1 V5 V3) (nr_locals_kol county city)
  ```
- Line 218: loc
  ```
  replace nr_locals_kol = 99999 if nr_locals_kol == .
  ```
- Line 220: city, loc
  ```
  gcollapse (count) nr_locals_kol, by(year city statecode)
  ```
- Line 222: loc, location
  ```
  * Export the location list for geocoding
  ```
- Line 228: address, loc
  ```
  * Addresses" tool against a U.S. address locator. The result -- one geocoded
  ```
- Line 229: loc, location
  ```
  * row per location, each carrying an ArcGIS match score -- is
  ```
- Line 241: coord
  ```
  coordinates("$unionsrc/US_county_1930_WGS84_coord") replace
  ```
- Line 255: name
  ```
  rename user_* *
  ```
- Line 257: loc, location
  ```
  * Drop poorly geocoded locations: a low ArcGIS match score (< 85) combined
  ```
- Line 262: name
  ```
  foreach var of varlist placename x y {
  ```
- Line 263: name
  ```
  rename `var' geocode_`var'
  ```
- Line 265: lon, name
  ```
  rename geocode_x geocode_longitude
  ```
- Line 266: lat, name
  ```
  rename geocode_y geocode_latitude
  ```
- Line 275: name
  ```
  rename (GISJOIN GISJOIN2) (gisjoin_1930 countynhg_1930)
  ```
- Line 276: loc
  ```
  foreach var of varlist nr_locals_* {
  ```
- Line 278: name
  ```
  rename `var' `var'_dr
  ```
- Line 284: loc, name
  ```
  rename (nr_locals_kol_tot) (locals_kol)
  ```
- Line 287: loc
  ```
  keep gisjoin_1930 countynhg_1930 year locals_kol
  ```

**/replication-package/MS20241468_Deposit/build_documentation/scripts/b15_byorigin.do**

- Line 10: census
  ```
  * Method. Seven census years with surviving microdata (1850-1880, 1900-1920)
  ```
- Line 18: country
  ```
  * with Northwest Europe, matching the 1890 country detail):
  ```
- Line 25: census, lat
  ```
  * Validation: the full-count tabulation matches the Census foreign-born-by-origin
  ```
- Line 26: son
  ```
  * counts to the person for 1880 (Canada+Australia differs by 1); the ICPSR 1890
  ```
- Line 27: lat
  ```
  * figures match exactly. totpop is the IPUMS-counted population.
  ```
- Line 46: loc
  ```
  local icpsr1890 "$rawlocal/ICPSR_02896/DS0018/02896-0018-Data.dta"
  ```
- Line 54: loc
  ```
  local first = 1
  ```
- Line 60: birth
  ```
  * birthplace groups (bpl ranges follow the IPUMS BPL codes)
  ```
- Line 80: loc
  ```
  local first = 0
  ```
- Line 126: lon
  ```
  recast long `v', force
  ```

**/replication-package/MS20241468_Deposit/build_documentation/scripts/b16_ship_aggregates.do**

- Line 6: census
  ```
  * data/public/census_aggregates/, as CSV (open format, JPE section 1.4). These
  ```
- Line 14: census
  ```
  * read. The confirm-file guard skips census years a given build run did not
  ```
- Line 23: census
  ```
  global censusagg "$root/data/public/census_aggregates"
  ```
- Line 24: census
  ```
  cap mkdir "$censusagg"
  ```
- Line 26: lat
  ```
  * Year-varying county aggregates (b1-b5) + the 1890 ICPSR population (b7)
  ```
- Line 32: lat
  ```
  IPUMS_`year'_population_county     ///
  ```
- Line 33: lat
  ```
  ICPSR_`year'_population_county {
  ```
- Line 37: census
  ```
  export delimited "$censusagg/`f'.csv", nolabel replace
  ```
- Line 42: census
  ```
  * Static aggregates (b8 elections, b6 segregation, b7 economic/census)
  ```
- Line 46: census
  ```
  agri_census_1890                 ///
  ```
- Line 47: census
  ```
  mfg_census                       ///
  ```
- Line 48: census
  ```
  mines_census_1890                ///
  ```
- Line 54: census
  ```
  export delimited "$censusagg/`f'.csv", nolabel replace
  ```

**/replication-package/MS20241468_Deposit/build_documentation/scripts/b1_census_base.do**

- Line 2: census
  ```
  * b1_census_base.do
  ```
- Line 5: census, sex
  ```
  * microdata, separately by census year and sex. For each county-year it counts
  ```
- Line 6: lat
  ```
  * working-age (16-64) people by population group and labor-market outcome, and
  ```
- Line 9: loc
  ```
  * INPUT  (in $rawlocal/):
  ```
- Line 10: census
  ```
  *   IPUMS/IPUMS_fullcount_<year>.dta  - IPUMS full-count census microdata, one file
  ```
- Line 15: census
  ```
  * OUTPUTS (in $intmdata/; b16 ships these to data/public/census_aggregates/):
  ```
- Line 19: lon
  ```
  * Build stage - run via build_documentation/scripts/00_master_build.do, or standalone.
  ```
- Line 26: loc
  ```
  * lets this file run on its own -- set it to the local path of the package.
  ```
- Line 37: census
  ```
  * Import individual-level Census data and collapse to county level
  ```
- Line 42: sex
  ```
  foreach sex in 1 2 {
  ```
- Line 44: sex
  ```
  if `sex' == 1 {
  ```
- Line 45: loc
  ```
  local s = "m"
  ```
- Line 47: sex
  ```
  if `sex' == 2 {
  ```
- Line 48: loc
  ```
  local s = "w"
  ```
- Line 54: birth, lat
  ```
  * Population groups. In IPUMS, birthplace codes (bpl) 1-120 are U.S. states /
  ```
- Line 55: son
  ```
  * territories and 400-465 are European countries; nativity == 1 flags a person
  ```
- Line 83: lat
  ```
  * Labor-market outcome counts, by population group. occsc_n and occsc_d are
  ```
- Line 85: second
  ```
  * second, so occsc_n / occsc_d recovers the county-mean income score.
  ```

**/replication-package/MS20241468_Deposit/build_documentation/scripts/b2_census_immigration.do**

- Line 2: census
  ```
  * b2_census_immigration.do
  ```
- Line 4: birth, country
  ```
  * Builds county-level counts of European immigrants by birthplace country,
  ```
- Line 10: loc
  ```
  * INPUT  (in $rawlocal/):
  ```
- Line 11: census
  ```
  *   IPUMS/IPUMS_fullcount_<year>.dta  - IPUMS full-count census microdata, one
  ```
- Line 15: census
  ```
  * OUTPUTS (in $intmdata/; b16 ships these to data/public/census_aggregates/):
  ```
- Line 19: lon
  ```
  * Build stage - run via build_documentation/scripts/00_master_build.do, or standalone.
  ```
- Line 26: loc
  ```
  * lets this file run on its own -- set it to the local path of the package.
  ```
- Line 37: birth, country
  ```
  * Count European immigrants by birthplace country and collapse to county level
  ```
- Line 42: sex
  ```
  foreach sex in 1 2 {
  ```
- Line 44: sex
  ```
  if `sex' == 1 {
  ```
- Line 45: loc
  ```
  local s = "m"
  ```
- Line 47: sex
  ```
  if `sex' == 2 {
  ```
- Line 48: loc
  ```
  local s = "w"
  ```
- Line 51: birth
  ```
  * European immigrants only (IPUMS birthplace codes 400-465)
  ```
- Line 54: census
  ```
  * The 1880 census has no year-of-immigration (yrimmig), so 1880 keeps fewer
  ```
- Line 57: sex
  ```
  keep stateicp year countyicp sex age bpl yrimmig lit speakeng histid
  ```
- Line 60: sex
  ```
  keep stateicp year countyicp sex age bpl histid
  ```
- Line 63: birth, country
  ```
  * Birthplace-country dummies, by IPUMS bpl code
  ```
- Line 101: country
  ```
  foreach country in denmark finland norway sweden uk ireland oth_northeu ///
  ```
- Line 106: country
  ```
  gen `country'_10yr_`s'        = (`country'_`s' == 1 & (year - yrimmig) < 10)
  ```
- Line 107: country
  ```
  gen `country'_wkgage_10yr_`s' = (`country'_`s' == 1 & (year - yrimmig < 10) & inrange(age,16,64) == 
  ```

**/replication-package/MS20241468_Deposit/build_documentation/scripts/b3_census_occupations.do**

- Line 2: census
  ```
  * b3_census_occupations.do
  ```
- Line 5: census
  ```
  * data, by census year, for working-age (16-64) men. For each county-year it
  ```
- Line 6: lat
  ```
  * counts men in each OCC1950 occupation, split by population group: natives
  ```
- Line 7: birth
  ```
  * (nat / nat_np / all) and -- for European immigrants -- by birthplace
  ```
- Line 8: country, second
  ```
  * country. A second pass restricts to immigrants who arrived within the last
  ```
- Line 10: census
  ```
  * dataset per census year.
  ```
- Line 12: loc
  ```
  * INPUT  (in $rawlocal/):
  ```
- Line 13: census
  ```
  *   IPUMS/IPUMS_fullcount_<year>.dta  - IPUMS full-count census microdata, one
  ```
- Line 16: census
  ```
  * OUTPUTS (in $intmdata/; b16 ships these to data/public/census_aggregates/):
  ```
- Line 18: country
  ```
  *   IPUMS_<year>_euroimm_occ_county_m.dta       - immigrants, by country x occ
  ```
- Line 23: lon
  ```
  * Build stage - run via build_documentation/scripts/00_master_build.do, or standalone.
  ```
- Line 30: loc
  ```
  * lets this file run on its own -- set it to the local path of the package.
  ```
- Line 41: birth, country
  ```
  * Occupation counts: all occupations, by nativity group / birthplace country
  ```
- Line 47: loc
  ```
  local condition = "bpl != ."
  ```
- Line 50: loc
  ```
  local condition = "inrange(bpl,400,465) == 1"
  ```
- Line 55: loc
  ```
  local s = "m"
  ```
- Line 64: sex
  ```
  keep stateicp year countyicp sex bpl nativity race occ1950 ind1950 occscore histid
  ```
- Line 67: sex
  ```
  keep stateicp year countyicp sex bpl nativity race occ1950 ind1950 labforce histid
  ```
- Line 78: birth, country
  ```
  * Birthplace-country dummies, by IPUMS bpl code
  ```
- Line 123: loc
  ```
  levelsof occ1950 if occ1950 < 979, local(occupationcodes)
  ```
- Line 131: loc
  ```
  if "`group'" == "nat_all" local groups nat nat_np all
  ```
- Line 132: loc
  ```
  if "`group'" == "euroimm" local groups denmark finland norway sweden uk ireland oth_northeu belgium 
  ```
- Line 137: loc
  ```
  foreach j of local groups {
  ```
- Line 140: country, lat
  ```
  * For euroimm, also carry the bare country population totals (count of working-
  ```
- Line 141: country
  ```
  * age men born in each country, by county).
  ```
- Line 153: loc
  ```
  local stubs ""
  ```
- Line 154: loc
  ```
  local k = 0
  ```
- Line 155: loc
  ```
  foreach j of local groups {
  ```
- Line 156: loc
  ```
  local ++k
  ```
- Line 157: loc
  ```
  local pad = string(`k', "%02.0f")
  ```
- Line 158: name
  ```
  rename `j' g`pad'
  ```
- Line 159: loc
  ```
  local stubs "`stubs' g`pad'"
  ```
- Line 163: loc
  ```
  local k = 0
  ```
- Line 164: loc
  ```
  foreach j of local groups {
  ```
- Line 165: loc
  ```
  local ++k
  ```
- Line 166: loc
  ```
  local pad = string(`k', "%02.0f")
  ```
- Line 167: name
  ```
  rename g`pad'* `j'_occ*_`s'
  ```
- Line 173: loc
  ```
  foreach j of local groups {
  ```
- Line 174: loc
  ```
  foreach o of local occupationcodes {
  ```
- Line 197: loc
  ```
  local s = "m"
  ```
- Line 208: sex
  ```
  keep stateicp year countyicp sex bpl nativity race occ1950 ind1950 occscore yrimmig histid
  ```
- Line 211: sex
  ```
  keep stateicp year countyicp sex bpl nativity race occ1950 ind1950 labforce yrimmig histid
  ```
- Line 214: birth, country
  ```
  * Birthplace-country dummies, by IPUMS bpl code
  ```
- Line 258: loc
  ```
  levelsof occ1950 if occ1950 < 979, local(occupationcodes)
  ```
- Line 261: birth, country
  ```
  * each occupation, by birthplace country, plus the labor-force total. Same narrow
  ```
- Line 264: loc
  ```
  local groups denmark finland norway sweden uk ireland oth_northeu belgium france luxemb nether switz
  ```
- Line 267: loc
  ```
  foreach j of local groups {
  ```
- Line 270: country, lat
  ```
  * Carry the bare country population totals too.
  ```
- Line 278: loc
  ```
  local stubs ""
  ```
- Line 279: loc
  ```
  local k = 0
  ```
- Line 280: loc
  ```
  foreach j of local groups {
  ```
- Line 281: loc
  ```
  local ++k
  ```
- Line 282: loc
  ```
  local pad = string(`k', "%02.0f")
  ```
- Line 283: name
  ```
  rename `j' g`pad'
  ```
- Line 284: loc
  ```
  local stubs "`stubs' g`pad'"
  ```
- Line 288: loc
  ```
  local k = 0
  ```
- Line 289: loc
  ```
  foreach j of local groups {
  ```
- Line 290: loc
  ```
  local ++k
  ```
- Line 291: loc
  ```
  local pad = string(`k', "%02.0f")
  ```
- Line 292: name
  ```
  rename g`pad'* `j'_occ*_10yr_`s'
  ```
- Line 296: loc
  ```
  foreach j of local groups {
  ```
- Line 297: loc
  ```
  foreach o of local occupationcodes {
  ```
- Line 313: census
  ```
  * Combine the per-group files into one occupation dataset per census year
  ```
- Line 320: country
  ```
  * Add the immigrant counts: total by country x occupation, and -- 1900 on --
  ```
- Line 322: census
  ```
  * census has no year-of-immigration, so the recent-arrival file starts in 1900.
  ```
- Line 347: census
  ```
  * 1880: the 1880 census never recorded year of arrival, so this script builds no 1880
  ```
- Line 348: block, loc
  ```
  * 10yr file and the whole 10yr block is absent for 1880 -- those cells are
  ```
- Line 351: loc
  ```
  if `year' == 1880 local fill10yr "."
  ```
- Line 352: loc
  ```
  if `year' != 1880 local fill10yr "0"
  ```
- Line 354: country
  ```
  foreach country in all nat nat_np ///
  ```
- Line 361: country
  ```
  capture confirm var `country'_lf_m, exact
  ```
- Line 363: country
  ```
  gen `country'_lf_m = 0
  ```
- Line 366: country
  ```
  if inlist("`country'","all","nat","nat_np") == 0 {
  ```
- Line 367: country
  ```
  capture confirm var `country'_lf_10yr_m, exact
  ```
- Line 369: country
  ```
  gen `country'_lf_10yr_m = `fill10yr'
  ```
- Line 386: country
  ```
  capture confirm var `country'_occ`o'_m, exact
  ```
- Line 388: country
  ```
  gen `country'_occ`o'_m = 0
  ```
- Line 391: country
  ```
  if inlist("`country'","all","nat","nat_np") == 0 {
  ```
- Line 392: country
  ```
  capture confirm var `country'_occ`o'_10yr_m, exact
  ```
- Line 394: country
  ```
  gen `country'_occ`o'_10yr_m = `fill10yr'
  ```
- Line 400: country
  ```
  order `country'_*_m, sequential last
  ```

**/replication-package/MS20241468_Deposit/build_documentation/scripts/b4_census_industries.do**

- Line 2: census
  ```
  * b4_census_industries.do
  ```
- Line 5: census
  ```
  * full-count census microdata, by census year, for working-age (16-64) men.
  ```
- Line 9: loc
  ```
  * INPUT  (in $rawlocal/):
  ```
- Line 10: census
  ```
  *   IPUMS/IPUMS_fullcount_<year>.dta  - IPUMS full-count census microdata, one
  ```
- Line 13: census
  ```
  * OUTPUT (in $intmdata/; b16 ships these to data/public/census_aggregates/):
  ```
- Line 17: lon
  ```
  * Build stage - run via build_documentation/scripts/00_master_build.do, or standalone.
  ```
- Line 24: loc
  ```
  * lets this file run on its own -- set it to the local path of the package.
  ```
- Line 43: lat
  ```
  * Population groups for the industry counts: everyone, and European
  ```
- Line 44: birth
  ```
  * immigrants (IPUMS birthplace codes 400-465).
  ```

**/replication-package/MS20241468_Deposit/build_documentation/scripts/b5_census_population.do**

- Line 2: census, lat
  ```
  * b5_census_population.do
  ```
- Line 5: census, lat
  ```
  * data. For each census year 1880-1930 it counts people by population group
  ```
- Line 6: sex
  ```
  * -- everyone, all immigrants, and European immigrants -- separately by sex,
  ```
- Line 9: loc
  ```
  * INPUT (in $rawlocal/):
  ```
- Line 14: census
  ```
  * OUTPUTS (in $intmdata/; b16 ships these to data/public/census_aggregates/):
  ```
- Line 15: lat
  ```
  *   IPUMS_<year>_population_county_m.dta / _w.dta  - men / women
  ```
- Line 16: lat
  ```
  *   IPUMS_<year>_population_county.dta             - the two merged
  ```
- Line 18: lon
  ```
  * Build stage - run via build_documentation/scripts/00_master_build.do, or standalone.
  ```
- Line 25: loc
  ```
  * lets this file run on its own -- set it to the local path of the package.
  ```
- Line 36: lat
  ```
  * County population counts, 1880-1930
  ```
- Line 41: sex
  ```
  foreach sex in 1 2 {
  ```
- Line 43: sex
  ```
  if `sex' == 1 {
  ```
- Line 44: loc
  ```
  local s = "m"
  ```
- Line 46: sex
  ```
  if `sex' == 2 {
  ```
- Line 47: loc
  ```
  local s = "w"
  ```
- Line 58: lat
  ```
  * Population groups: everyone; all immigrants (born outside the U.S. -- IPUMS
  ```
- Line 59: birth
  ```
  * birthplace codes above 120); and European immigrants (bpl 400-465).
  ```
- Line 64: lat
  ```
  * For each group, count total, urban, and working-age (16-64) population.
  ```
- Line 83: lat
  ```
  save "$intmdata/IPUMS_`year'_population_county_`s'.dta", replace
  ```
- Line 98: lat
  ```
  use "$intmdata/IPUMS_`year'_population_county_m.dta", clear
  ```
- Line 109: lat
  ```
  * Men + women, for each population group x measure.
  ```
- Line 116: lat
  ```
  save "$intmdata/IPUMS_`year'_population_county.dta", replace
  ```

**/replication-package/MS20241468_Deposit/build_documentation/scripts/b6_census_segregation.do**

- Line 2: census
  ```
  * b6_census_segregation.do
  ```
- Line 6: house
  ```
  * Working at the household-head level in IPUMS full-count 1880 microdata, it
  ```
- Line 7: house
  ```
  * identifies each household's next-door neighbors -- the household heads at
  ```
- Line 8: census, district
  ```
  * the adjacent census serial numbers within the same enumeration district --
  ```
- Line 9: house
  ```
  * and counts, per county, how many European-immigrant households have a
  ```
- Line 12: loc
  ```
  * INPUT  (in $rawlocal/):
  ```
- Line 13: census
  ```
  *   IPUMS/IPUMS_fullcount_1880.dta  - IPUMS full-count census microdata.
  ```
- Line 16: census
  ```
  * OUTPUT (in $intmdata/; b16 ships these to data/public/census_aggregates/):
  ```
- Line 20: lon
  ```
  * Build stage - run via build_documentation/scripts/00_master_build.do, or standalone.
  ```
- Line 27: loc
  ```
  * lets this file run on its own -- set it to the local path of the package.
  ```
- Line 41: house, lat
  ```
  * Household heads only (relate == 1): the segregation index is defined over
  ```
- Line 42: house
  ```
  * households, each represented by its head.
  ```
- Line 43: lat
  ```
  use year relate serial stateicp countyicp countynhg bpl nativity enumdist supdist ///
  ```
- Line 44: lat
  ```
  if relate == 1 ///
  ```
- Line 47: house
  ```
  * Household groups, following Logan and Parman (2017) adapted to immigration:
  ```
- Line 54: house
  ```
  * Next-door neighbors are the households at the adjacent serial numbers.
  ```
- Line 55: census
  ```
  * Census serial numbers run in enumeration order, so xtset by serial lets the
  ```
- Line 56: house
  ```
  * l1/f1 operators reach the previous/next household; a neighbor counts only if
  ```
- Line 57: district
  ```
  * it falls in the same enumeration district (enum).
  ```
- Line 61: house
  ```
  * For each European-immigrant household, flag (a) whether a next-door neighbor
  ```
- Line 63: district, house
  ```
  * neighbors or only one -- households at an enumeration-district edge have a
  ```

**/replication-package/MS20241468_Deposit/build_documentation/scripts/b7_economic_railroads.do**

- Line 5: census
  ```
  * the panel draws on outside the IPUMS census microdata:
  ```
- Line 6: birth, country, lat
  ```
  *   - 1890 population counts, by nativity group and birthplace country (the
  ```
- Line 9: census
  ```
  *   - manufacturing-census aggregates, pooled across census years;
  ```
- Line 10: census
  ```
  *   - the 1890 agricultural and mining censuses;
  ```
- Line 11: lat
  ```
  *   - a CPI-U price deflator; and
  ```
- Line 15: loc
  ```
  *   $rawlocal/ICPSR_02896/DS####/02896-####-Data.dta  - ICPSR 2896 (Haines),
  ```
- Line 16: social
  ```
  *                                  Historical Demographic/Economic/Social Data
  ```
- Line 17: loc
  ```
  *                                  (not shipped; stage under data/_raw_local/)
  ```
- Line 18: census
  ```
  *   $rawdata/census_mines/coalmines_1890.csv  - 1890 coal-mine counts (shipped)
  ```
- Line 23: census
  ```
  * OUTPUTS (in $intmdata/; b16 ships these to data/public/census_aggregates/):
  ```
- Line 24: lat
  ```
  *   ICPSR_1890_population_county.dta               - 1890 population
  ```
- Line 25: census
  ```
  *   mfg_census.dta                                 - manufacturing census
  ```
- Line 26: census
  ```
  *   agri_census_1890.dta                           - 1890 agriculture
  ```
- Line 27: census
  ```
  *   mines_census_1890.dta                          - 1890 mining
  ```
- Line 28: lat
  ```
  *   cpi_u.dta                                      - CPI-U deflator
  ```
- Line 31: lon
  ```
  * Build stage - run via build_documentation/scripts/00_master_build.do, or standalone.
  ```
- Line 38: loc
  ```
  * lets this file run on its own -- set it to the local path of the package.
  ```
- Line 49: birth, country, lat
  ```
  * 1890 population, by nativity group and birthplace country (ICPSR 2896)
  ```
- Line 52: census
  ```
  * The 1890 full-count census was destroyed by fire; 1890 county figures come
  ```
- Line 55: loc
  ```
  use "$rawlocal/ICPSR_02896/DS0018/02896-0018-Data.dta", clear
  ```
- Line 61: name
  ```
  rename (state county totpop urb890 mtot ftot) ///
  ```
- Line 64: lat
  ```
  * Population counts by nativity: Black (negtot), all immigrants (foreign-born),
  ```
- Line 73: birth, country
  ```
  * single combined birthplace count (pbnorden). Where a country-specific count
  ```
- Line 82: birth
  ```
  * A missing birthplace count is a true zero.
  ```
- Line 89: birth, country, name
  ```
  * Rename the birthplace counts to country names, then combine the components
  ```
- Line 92: name
  ```
  rename (pbaustri pbbelg pbbohem pbdenmar pbenglan pbfrance pbgerman pbgreece pbhollan pbhungar pbire
  ```
- Line 102: name
  ```
  rename families nr_fams
  ```
- Line 107: birth, country, name
  ```
  * Keep the county counts; rename birthplace columns to <country>_mw and drop
  ```
- Line 110: name
  ```
  rename born_* *_mw
  ```
- Line 118: lat
  ```
  save "$intmdata/ICPSR_1890_population_county.dta", replace
  ```
- Line 122: census
  ```
  * Manufacturing census, pooled across census years (ICPSR 2896)
  ```
- Line 125: census
  ```
  * Each ICPSR 2896 manufacturing dataset covers one census year. Pool them: the
  ```
- Line 126: census, name
  ```
  * census year is encoded in the name of the file's 5th variable (characters
  ```
- Line 127: name
  ```
  * 4-6), so it is parsed out of that name and stored in `year'.
  ```
- Line 128: loc
  ```
  local n = 0
  ```
- Line 130: loc
  ```
  local ++n
  ```
- Line 131: loc
  ```
  use "$rawlocal/ICPSR_02896/DS00`num'/02896-00`num'-Data.dta", clear
  ```
- Line 132: loc
  ```
  local t = 0
  ```
- Line 134: loc
  ```
  local ++t
  ```
- Line 151: name
  ```
  keep fips state county name totpop mfg* year
  ```
- Line 152: name
  ```
  rename state  stateicp
  ```
- Line 153: name
  ```
  rename county countyicp
  ```
- Line 156: census, name
  ```
  * names and age cutoffs across census years. Take the first non-missing of the
  ```
- Line 178: census
  ```
  save "$intmdata/mfg_census.dta", replace
  ```
- Line 182: census
  ```
  * 1890 agricultural census (ICPSR 2896)
  ```
- Line 185: loc
  ```
  use "$rawlocal/ICPSR_02896/DS0049/02896-0049-Data.dta", clear
  ```
- Line 189: name
  ```
  keep year fips state county name farmarea
  ```
- Line 190: name
  ```
  rename state  stateicp
  ```
- Line 191: name
  ```
  rename county countyicp
  ```
- Line 196: census
  ```
  save "$intmdata/agri_census_1890.dta", replace
  ```
- Line 200: census
  ```
  * 1890 mining census
  ```
- Line 204: census
  ```
  * Eleventh Census, 1890.
  ```
- Line 210: name
  ```
  rename state  stateicp
  ```
- Line 211: name
  ```
  rename county countyicp
  ```
- Line 212: name
  ```
  rename *_1890 *
  ```
- Line 215: loc
  ```
  label var coalmines_loc "Number of local coal mines"
  ```
- Line 219: census
  ```
  save "$intmdata/mines_census_1890.dta", replace
  ```
- Line 223: lat
  ```
  * CPI-U price deflator
  ```
- Line 226: lat
  ```
  * Source: Minneapolis Fed, "Consumer Price Index, 1800-" (inflation calculator)
  ```
- Line 227: lat
  ```
  * https://www.minneapolisfed.org/about-us/monetary-policy/inflation-calculator/consumer-price-index-
  ```
- Line 251: name
  ```
  rename gisjoin  gisjoin_1930
  ```
- Line 252: name
  ```
  rename gisjoin2 countynhg_1930
  ```

**/replication-package/MS20241468_Deposit/build_documentation/scripts/b8_elections.do**

- Line 8: loc
  ```
  * INPUTS  (in $rawlocal/):
  ```
- Line 12: census
  ```
  * OUTPUTS (in $intmdata/; b16 ships these to data/public/census_aggregates/):
  ```
- Line 18: loc
  ```
  *             downloads ICPSR Study 1 and places it under $rawlocal/ICPSR_00001/.
  ```
- Line 20: lon
  ```
  * Build stage - run via build_documentation/scripts/00_master_build.do, or standalone.
  ```
- Line 27: loc
  ```
  * lets this file run on its own -- set it to the local path of the package.
  ```
- Line 46: block, loc
  ```
  * (the scattered  if `n' == ...  blocks), extracts the presidential-vote
  ```
- Line 57: social
  ```
  *            0380 / 0511 -> Socialist
  ```
- Line 63: loc
  ```
  local dsfolder = "DS" + string(`n',"%04.0f")
  ```
- Line 64: loc
  ```
  local file: dir "$rawlocal/ICPSR_00001/`dsfolder'/" files "*.sav"
  ```
- Line 65: loc
  ```
  local count = 0
  ```
- Line 66: loc
  ```
  foreach i of local file {
  ```
- Line 67: loc
  ```
  local count = `count' + 1
  ```
- Line 124: name
  ```
  rename (V1 V2 V3) (stateicp countyname countyicp)
  ```
- Line 128: loc
  ```
  local vars = "`r(varlist)'"
  ```
- Line 129: loc
  ```
  local count = 0
  ```
- Line 130: loc
  ```
  foreach var of local vars {
  ```
- Line 131: loc
  ```
  local count = `count' + 1
  ```
- Line 133: name
  ```
  rename `var' demvote_1`year'
  ```
- Line 137: loc
  ```
  local vars = "`r(varlist)'"
  ```
- Line 138: loc
  ```
  local count = 0
  ```
- Line 139: loc
  ```
  foreach var of local vars {
  ```
- Line 140: loc
  ```
  local count = `count' + 1
  ```
- Line 142: name
  ```
  cap rename `r(varlist)' repvote_1`year'
  ```
- Line 146: loc
  ```
  local vars = "`r(varlist)'"
  ```
- Line 147: loc
  ```
  local count = 0
  ```
- Line 148: loc
  ```
  foreach var of local vars {
  ```
- Line 149: loc
  ```
  local count = `count' + 1
  ```
- Line 151: name
  ```
  cap rename `r(varlist)' socvote_1`year'
  ```
- Line 155: loc
  ```
  local vars = "`r(varlist)'"
  ```
- Line 156: loc
  ```
  local count = 0
  ```
- Line 157: loc
  ```
  foreach var of local vars {
  ```
- Line 158: loc
  ```
  local count = `count' + 1
  ```
- Line 160: name
  ```
  cap rename `r(varlist)' socvote_1`year'
  ```
- Line 164: loc
  ```
  local vars = "`r(varlist)'"
  ```
- Line 165: loc
  ```
  local count = 0
  ```
- Line 166: loc
  ```
  foreach var of local vars {
  ```
- Line 167: loc
  ```
  local count = `count' + 1
  ```
- Line 169: name
  ```
  cap rename `r(varlist)' knownotvote_1`year'
  ```
- Line 173: loc
  ```
  local vars = "`r(varlist)'"
  ```
- Line 174: loc
  ```
  local count = 0
  ```
- Line 175: loc
  ```
  foreach var of local vars {
  ```
- Line 176: loc
  ```
  local count = `count' + 1
  ```
- Line 178: name
  ```
  cap rename `r(varlist)' knownotvote_1`year'
  ```
- Line 182: loc
  ```
  local vars = "`r(varlist)'"
  ```
- Line 183: loc
  ```
  local count = 0
  ```
- Line 184: loc
  ```
  foreach var of local vars {
  ```
- Line 185: loc
  ```
  local count = `count' + 1
  ```
- Line 187: name
  ```
  cap rename `r(varlist)' totvote_1`year'
  ```
- Line 191: name
  ```
  * Dataset-specific fixes: hand-rename vote columns the label search above
  ```
- Line 194: name
  ```
  rename V135 demvote_1896
  ```
- Line 197: name
  ```
  rename V310 demvote_1892
  ```
- Line 200: name
  ```
  rename V402 demvote_1900
  ```
- Line 203: name
  ```
  rename V310 demvote_1896
  ```
- Line 204: name
  ```
  rename V343 demvote_1900
  ```
- Line 205: name
  ```
  rename V404 demvote_1908
  ```
- Line 211: name
  ```
  replace countyicp = 1570 if countyicp == 1510 & countyname == "TUSCOLA"
  ```
- Line 212: name
  ```
  replace countyicp = 1590 if countyicp == 1530 & countyname == "VAN BUREN"
  ```
- Line 213: name
  ```
  replace countyicp = 1610 if countyicp == 1550 & countyname == "WASHTENAW"
  ```
- Line 214: name
  ```
  replace countyicp = 1630 if countyicp == 1570 & countyname == "WAYNE"
  ```
- Line 215: name
  ```
  replace countyicp = 1650 if countyicp == 1590 & countyname == "WEXFORD"
  ```
- Line 218: name
  ```
  replace countyicp = 1350 if countyicp == 1370 & countyname == "NESS"
  ```
- Line 219: name
  ```
  replace countyicp = 1330 if countyicp == 1350 & countyname == "NEOSHO/DORN"
  ```
- Line 222: name
  ```
  rename V131 demvote_1900
  ```
- Line 225: name
  ```
  rename V81 demvote_1896
  ```
- Line 226: name
  ```
  rename V110 demvote_1900
  ```
- Line 229: name
  ```
  rename V176 demvote_1896
  ```
- Line 232: name
  ```
  rename V265 demvote_1900
  ```
- Line 235: name
  ```
  rename V65 demvote_1920
  ```
- Line 238: name
  ```
  rename V289 demvote_1900
  ```
- Line 239: name
  ```
  rename V324 demvote_1904
  ```
- Line 242: name
  ```
  rename V355 demvote_1900
  ```
- Line 248: name, son
  ```
  replace countyicp = 1570 if countyicp == 1510 & countyname == "JACKSON"
  ```
- Line 251: name
  ```
  replace countyicp = 490 if countyicp == 470 & countyname == "HINDS"
  ```
- Line 273: loc
  ```
  local file: dir "$intmdata/ICPSR_00001/" files "*.dta"
  ```
- Line 274: loc
  ```
  foreach i of local file {
  ```
- Line 281: loc
  ```
  foreach i of local file {
  ```
- Line 287: name
  ```
  order stateicp countyicp countyname, first
  ```
- Line 302: lon, name
  ```
  reshape long demvote_ repvote_ socvote_ knownotvote_ totvote_, i(stateicp countyicp countyname) j(ye
  ```
- Line 303: name
  ```
  rename *vote_ *vote
  ```
- Line 310: social
  ```
  * Republican vote is not used downstream. The Socialist party first fielded a
  ```
- Line 323: name
  ```
  reshape wide knownotvote totvote, i(stateicp countyicp countyname) j(year)
  ```
- Line 324: name
  ```
  keep stateicp countyicp countyname totvote1856 knownotvote1856
  ```
- Line 325: name
  ```
  rename *vote* *vote_*
  ```
- Line 338: name
  ```
  reshape wide demvote socvote knownotvote* totvote, i(stateicp countyicp countyname decade) j(year)
  ```
- Line 339: name
  ```
  rename *vote* *vote_*
  ```
- Line 340: name
  ```
  rename decade year
  ```

**/replication-package/MS20241468_Deposit/build_documentation/scripts/b9_names.do**

- Line 2: name
  ```
  * b9_names.do
  ```
- Line 4: name
  ```
  * One-time prep script. Builds the surname-level origin and ancestry
  ```
- Line 6: son
  ```
  * years 1900, 1910, and 1920 it reads the restricted person-level microdata,
  ```
- Line 7: birth, father
  ```
  * classifies each man by his own and his father's birthplace, and collapses to
  ```
- Line 8: name
  ```
  * one row per surname giving, for each European-origin group, the share of men
  ```
- Line 9: name
  ```
  * with that surname in that group.
  ```
- Line 11: name
  ```
  * The outputs are aggregates -- surname-level counts and shares, with no
  ```
- Line 12: son
  ```
  * person records -- which IPUMS permits redistributing (unlike the raw
  ```
- Line 13: name
  ```
  * microdata). They ship under data/public/IPUMS_surname_aggregates/ and are
  ```
- Line 18: son
  ```
  * aggregates; the multi-GB person-level intermediates are never written.
  ```
- Line 21: name
  ```
  *   <ipums_root>/<year>_2.5/<file>.dat  - IPUMS Restricted Full Count w/ Names
  ```
- Line 23: name
  ```
  * Outputs (export, via disclosure review, to data/public/IPUMS_surname_aggregates/):
  ```
- Line 24: name
  ```
  *   names_origin.dta    - surname x origin shares  (one row per year x surname)
  ```
- Line 25: name
  ```
  *   names_ancestry.dta  - surname x ancestry shares (one row per surname)
  ```
- Line 32: loc, name
  ```
  local ipums_root "<path-to-restricted-fullcount-name-extracts>"     // folder holding the restricted
  ```
- Line 33: loc, name
  ```
  local outdir     "<path-to-output-folder-for-surname-aggregates>"   // the two surname aggregates ar
  ```
- Line 35: name
  ```
  *-- Year-to-filename mapping (the .dat filename differs by year).
  ```
- Line 36: loc
  ```
  local f1900 "us1900m_usa_res"
  ```
- Line 37: loc
  ```
  local f1910 "us1910m_usa_res"
  ```
- Line 38: loc
  ```
  local f1920 "us1920c_usa_res"
  ```
- Line 39: lat, loc
  ```
  local f1930 "us1930d_usa_res"   // used for the origin tabulation only
  ```
- Line 43: name
  ```
  * Per-year extraction and surname classification
  ```
- Line 54: name
  ```
  * Read the restricted full-count-with-names microdata. Column positions
  ```
- Line 55: birth, father, name, sex
  ```
  * (record type, sex, birthplace, father's birthplace, last name) are the same
  ```
- Line 59: sex
  ```
  byte sex       61-61                 ///
  ```
- Line 60: lon
  ```
  long bpl       73-77                 ///
  ```
- Line 61: lon
  ```
  long fbpl      2332-2336             ///
  ```
- Line 62: name
  ```
  str  namelast  1756-1826             ///
  ```
- Line 65: son
  ```
  keep if rectype == "P"                                  // person records only
  ```
- Line 68: sex
  ```
  keep if sex == 1                                        // men
  ```
- Line 73: birth, father
  ```
  * Origin: classify every man by his own or his father's birthplace
  ```
- Line 78: birth
  ```
  * Put birthplaces on the general 3-digit scale used by the classification below.
  ```
- Line 88: birth, country, lat
  ```
  * Origin = own country of birth only, over the entire male population. Per the paper's
  ```
- Line 89: birth, father, name
  ```
  * Appendix (app:names_delegates), the birthplace mapping does not use the father's
  ```
- Line 90: birth
  ```
  * birthplace -- that is the ancestry measure, constructed separately below. So U.S.-born
  ```
- Line 91: birth, father
  ```
  * counts a man's own U.S. birth regardless of his father's birthplace.
  ```
- Line 96: birth, country
  ```
  * Birthplace-country dummies: own birthplace only.
  ```
- Line 122: name
  ```
  * Standardize the surname so it matches the delegate names in the exact merge (b10/b11).
  ```
- Line 123: name
  ```
  replace namelast = lower(namelast)
  ```
- Line 124: name
  ```
  replace namelast = subinstr(namelast,"'","",.)
  ```
- Line 125: name
  ```
  replace namelast = subinstr(namelast," ","",.)
  ```
- Line 126: name
  ```
  replace namelast = subinstr(namelast,"st.","st",.)
  ```
- Line 127: name
  ```
  replace namelast = subinstr(namelast,",","",.)
  ```
- Line 128: name
  ```
  replace namelast = subinstr(namelast,"-","",.)
  ```
- Line 129: name
  ```
  replace namelast = subinstr(namelast,"_","",.)
  ```
- Line 131: name
  ```
  * Count, per surname, the men in each group; nameprob_* is the share.
  ```
- Line 139: name
  ```
  tot, by(year namelast)
  ```
- Line 147: name
  ```
  gen nameprob_`group' = `group' / tot
  ```
- Line 154: birth, lat
  ```
  * 1930 is tabulated for origin only -- the year-specific birthplace bracket used to
  ```
- Line 155: lat
  ```
  * interpolate 1920 delegate composition for counties without a 1920 convention. The
  ```
- Line 156: name
  ```
  * ancestry measure pools surnames across 1900-1920, so 1930 is not added to it.
  ```
- Line 161: father
  ```
  * Ancestry: classify men born abroad (or with a foreign-born father)
  ```
- Line 164: father
  ```
  * Restrict to men born abroad or with a foreign-born father, then put codes on
  ```
- Line 178: father
  ```
  keep if bpl > 100 | fbpl > 100                          // born abroad, or foreign-born father
  ```
- Line 179: father
  ```
  drop if bpl > 100 & fbpl <= 100                         // exclude foreign-born men of a U.S.-born f
  ```
- Line 180: father
  ```
  drop if fbpl == 150 & (bpl < 100 | bpl == 150)          // exclude U.S./Canada-born men of a Canadia
  ```
- Line 182: birth, father
  ```
  * Ancestry = own birthplace, or the father's if the man is U.S./Canada-born.
  ```
- Line 183: lon
  ```
  clonevar ancestry = bpl
  ```
- Line 216: name
  ```
  * Standardize the surname (as in the origin pass).
  ```
- Line 217: name
  ```
  replace namelast = lower(namelast)
  ```
- Line 218: name
  ```
  replace namelast = subinstr(namelast,"'","",.)
  ```
- Line 219: name
  ```
  replace namelast = subinstr(namelast," ","",.)
  ```
- Line 220: name
  ```
  replace namelast = subinstr(namelast,"st.","st",.)
  ```
- Line 221: name
  ```
  replace namelast = subinstr(namelast,",","",.)
  ```
- Line 222: name
  ```
  replace namelast = subinstr(namelast,"-","",.)
  ```
- Line 223: name
  ```
  replace namelast = subinstr(namelast,"_","",.)
  ```
- Line 231: lat, name
  ```
  * names_origin: pool the per-year surname tabulations
  ```
- Line 239: birth, name
  ```
  rename nameprob_* nameprob_bpl_*                 // ship self-describing prefixed names (origin = ow
  ```
- Line 240: name
  ```
  save "`outdir'/names_origin.dta", replace
  ```
- Line 244: name, son
  ```
  * names_ancestry: pool the per-year person files, then collapse by surname
  ```
- Line 259: name
  ```
  tot, by(namelast)
  ```
- Line 267: name
  ```
  gen nameprob_`group' = `group' / tot
  ```
- Line 270: name
  ```
  rename nameprob_* nameprob_anc_*                 // ship self-describing prefixed names (ancestry-ba
  ```
- Line 271: name
  ```
  save "`outdir'/names_ancestry.dta", replace
  ```

**/replication-package/MS20241468_Deposit/code/00_master.do**

- Line 13: census
  ```
  * and ICPSR studies (the census/elections/by-origin aggregates), the IWW and
  ```
- Line 15: name
  ```
  * aggregates (UMWA, UBC, IAM, BMPIU, ITU), and the surname origin/ancestry
  ```
- Line 29: loc, location
  ```
  * 1. Set the path under "global root" below to the location of this
  ```
- Line 47: loc
  ```
  * (Set the path above to the local path of the replication package.)
  ```
- Line 63: lat, name
  ```
  * Intermediate data is kept flat; the one subfolder holds the restricted-names
  ```
- Line 65: name
  ```
  cap mkdir "$intmdata/IPUMS_surname_aggregates"
  ```
- Line 93: loc
  ```
  local packages ftools gtools reghdfe ivreghdfe ivreg2 ranktest outreg2 coefplot ///
  ```
- Line 96: loc
  ```
  foreach pkg of local packages {
  ```
- Line 107: census
  ```
  * The census, elections, and by-origin county/national aggregates that
  ```
- Line 109: census
  ```
  * under data/public/census_aggregates/ (and data/public/foreignborn_byorigin/);
  ```
- Line 138: loc
  ```
  local byproducts : dir "$root/output/tables" files "`pat'"
  ```
- Line 139: loc
  ```
  foreach f of local byproducts {
  ```

**/replication-package/MS20241468_Deposit/code/1_construction/1a_reference_inputs.do**

- Line 11: name
  ```
  *   IPUMS/xwalk_occ1950_occnames.csv           - IPUMS OCC1950 occupation labels
  ```
- Line 21: coord
  ```
  *   $intmdata/US_county_1930_WGS84_coord.dta
  ```
- Line 23: name
  ```
  *   $intmdata/xwalk_occ1950_occnames.dta
  ```
- Line 31: lon
  ```
  * Run via 00_master.do, or standalone.
  ```
- Line 38: loc
  ```
  * lets this file run on its own -- set it to the local path of the package.
  ```
- Line 50: coord
  ```
  * shp2dta splits the shapefile into the database + coordinate .dta pair that
  ```
- Line 66: name
  ```
  * IPUMS OCC1950 occupation names
  ```
- Line 70: name
  ```
  save "$intmdata/xwalk_occ1950_occnames.dta", replace
  ```
- Line 78: name
  ```
  rename countynhg countynhg_1930
  ```
- Line 120: lat
  ```
  * US foreign-born population by region of origin, 1850-1920
  ```
- Line 122: census, lat
  ```
  * Eight census-year rows of full-population counts (see
  ```
- Line 138: census
  ```
  label var year             "census year"
  ```
- Line 139: lat
  ```
  label var totpop           "total US population"
  ```
- Line 140: lat
  ```
  label var foreignborn      "total foreign-born population"
  ```
- Line 158: loc
  ```
  *                           KOL_locals_1880-1890_county1930.dta
  ```
- Line 171: loc
  ```
  * IWW: county-year locals counts, 1906-1917
  ```
- Line 176: loc
  ```
  label data "IWW county-year locals counts (1906-1917)"
  ```
- Line 179: loc
  ```
  label var IWW_locals     "Number of IWW locals in county across 1906-1917"
  ```
- Line 185: loc
  ```
  * KoL: county-year locals counts, 1880 and 1890
  ```
- Line 190: loc
  ```
  label data "Knights of Labor county-year locals counts (1880, 1890)"
  ```
- Line 194: loc
  ```
  label var locals_kol     "Number of Knights of Labor locals in county-year"
  ```
- Line 196: loc
  ```
  save "$intmdata/KOL_locals_1880-1890_county1930.dta", replace
  ```

**/replication-package/MS20241468_Deposit/code/1_construction/1b_merge_preadjust.do**

- Line 5: census
  ```
  * county dataset per census year, ahead of the county-border harmonization
  ```
- Line 6: block, loc
  ```
  * in 1c. The panel is assembled in two blocks because the base data differ:
  ```
- Line 7: census
  ```
  *   - 1880, 1900, 1910, 1920: IPUMS full-count census aggregates;
  ```
- Line 12: lat
  ```
  *   1a and the build stage -- IPUMS labor-market, population, immigrant, occupation and
  ```
- Line 14: census
  ```
  *   agricultural, and mining censuses; residential-segregation counts;
  ```
- Line 19: census
  ```
  *   county_panel_<year>_unadjusted.dta  - one per census year (1880-1930);
  ```
- Line 22: lon
  ```
  * Run via 00_master.do, or standalone.
  ```
- Line 29: loc
  ```
  * lets this file run on its own -- set it to the local path of the package.
  ```
- Line 34: census
  ```
  global censusagg "$rawdata/census_aggregates"   // shipped county/national aggregates (CSV) built by
  ```
- Line 41: census
  ```
  * Convert the deposited census aggregates (CSV, open format -- JPE 1.4) to .dta
  ```
- Line 44: name
  ```
  * case(preserve) keeps the original variable-name case. The confirm-file guard
  ```
- Line 51: lat
  ```
  IPUMS_`year'_population_county ICPSR_`year'_population_county {
  ```
- Line 52: census
  ```
  cap confirm file "$censusagg/`f'.csv"
  ```
- Line 60: census
  ```
  resid_segr_1880 agri_census_1890 mfg_census mines_census_1890 cpi_u ///
  ```
- Line 62: census
  ```
  cap confirm file "$censusagg/`f'.csv"
  ```
- Line 77: lat
  ```
  * Base: IPUMS labor-market aggregates (b1). Add population counts (b5) and the
  ```
- Line 78: census
  ```
  * manufacturing census (b7).
  ```
- Line 103: country
  ```
  foreach country in denmark finland norway sweden uk ireland oth_northeu ///
  ```
- Line 109: country
  ```
  replace `country'_`s' = 0 if _merge == 1 & `country'_`s' == .
  ```
- Line 111: country
  ```
  gen `country'_mw      = `country'_m + `country'_w
  ```
- Line 112: country
  ```
  gen `country'_10yr_mw = `country'_10yr_m + `country'_10yr_w
  ```
- Line 124: birth, census, country
  ```
  * Immigrant counts by birthplace country (b2). The 1880 census has no
  ```
- Line 128: country
  ```
  foreach country in denmark finland norway sweden uk ireland oth_northeu ///
  ```
- Line 134: country
  ```
  replace `country'_`s' = 0 if _merge == 1 & `country'_`s' == .
  ```
- Line 136: country
  ```
  gen `country'_mw = `country'_m + `country'_w
  ```
- Line 212: census
  ```
  * components than the other census years.
  ```
- Line 254: lat
  ```
  * 1930 provides the t+10 (1930) values used in the analysis to interpolate 1920
  ```
- Line 256: lat
  ```
  * IPUMS full count is aggregated for population and immigrant origin only; the
  ```
- Line 257: lat
  ```
  * labor-force, occupation, and industry tabulations are not needed for 1930. All
  ```
- Line 259: census
  ```
  * census year and not as an analysis observation.
  ```
- Line 264: birth, country
  ```
  * Immigrant counts by birthplace country (same processing as the main loop).
  ```
- Line 266: country
  ```
  foreach country in denmark finland norway sweden uk ireland oth_northeu ///
  ```
- Line 272: country
  ```
  replace `country'_`s' = 0 if _merge == 1 & `country'_`s' == .
  ```
- Line 274: country
  ```
  gen `country'_mw      = `country'_m + `country'_w
  ```
- Line 275: country
  ```
  gen `country'_10yr_mw = `country'_10yr_m + `country'_10yr_w
  ```

**/replication-package/MS20241468_Deposit/code/1_construction/1c_boundary_adjustment.do**

- Line 5: census
  ```
  * over time -- counties split, merge, and shift borders -- so each census
  ```
- Line 23: lon
  ```
  * Run via 00_master.do, or standalone.
  ```
- Line 30: loc
  ```
  * lets this file run on its own -- set it to the local path of the package.
  ```
- Line 45: census
  ```
  * For each census year, pull the county identifiers (ICPSR and NHGIS codes)
  ```
- Line 49: name
  ```
  rename decade year
  ```
- Line 57: census
  ```
  * Re-aggregate each census year's county data onto 1930 county boundaries
  ```
- Line 60: loc
  ```
  local baseyear 1930
  ```
- Line 63: loc
  ```
  local allyears `r(numlist)'
  ```
- Line 64: loc
  ```
  local years_notbase: list allyears - baseyear
  ```
- Line 66: loc
  ```
  foreach year of local years_notbase {
  ```
- Line 81: name
  ```
  rename (icpsrst icpsrcty gisjoin2) (stateicp countyicp countynhg)
  ```
- Line 96: name
  ```
  rename (icpsrst icpsrcty gisjoin2) (stateicp countyicp countynhg)
  ```
- Line 116: name
  ```
  rename (icpsrst icpsrcty gisjoin2) (stateicp countyicp countynhg)
  ```
- Line 120: name
  ```
  rename gisjoin_1910 gisjoin_`year'
  ```
- Line 138: loc
  ```
  local datavars `r(varlist)'
  ```
- Line 143: loc
  ```
  local chunksize 6000
  ```
- Line 144: loc
  ```
  local nc 0
  ```
- Line 145: loc
  ```
  local c  0
  ```
- Line 146: loc
  ```
  local chunkvars ""
  ```
- Line 147: loc
  ```
  local datavars `datavars' _flush_			// trailing sentinel flushes the last chunk
  ```
- Line 149: loc
  ```
  foreach var of local datavars {
  ```
- Line 151: loc
  ```
  local chunkvars `chunkvars' `var'
  ```
- Line 152: loc
  ```
  local ++nc
  ```
- Line 155: loc
  ```
  local ++c
  ```
- Line 160: loc
  ```
  foreach v of local chunkvars {
  ```
- Line 162: name
  ```
  rename `v' `v'_o
  ```
- Line 173: loc
  ```
  local chunkvars ""
  ```
- Line 174: loc
  ```
  local nc 0
  ```
- Line 203: name
  ```
  rename countynhg gisjoin2
  ```

**/replication-package/MS20241468_Deposit/code/1_construction/1d_county_panel.do**

- Line 8: census
  ```
  * census year, 1880-1920) that the downstream construction steps and the analysis read.
  ```
- Line 21: lon
  ```
  * Run via 00_master.do, or standalone.
  ```
- Line 28: loc
  ```
  * lets this file run on its own -- set it to the local path of the package.
  ```
- Line 41: loc
  ```
  local baseyear 1930
  ```
- Line 45: census, lat
  ```
  * 1930 provides the t+10 (1930) census year used in the analysis to interpolate
  ```
- Line 49: loc
  ```
  local allyears `r(numlist)'
  ```
- Line 52: loc
  ```
  foreach year of local allyears {
  ```
- Line 56: name
  ```
  * Attach the 1930-geography county identifiers (state/county names and codes,
  ```
- Line 66: name
  ```
  rename (gisjoin2 cnty_area_`baseyear' icpsrst icpsrcty state county) ///
  ```

**/replication-package/MS20241468_Deposit/code/1_construction/1e_weather_shocks.do**

- Line 4: country
  ```
  * Builds the country-year predicted immigration flows driven by weather
  ```
- Line 5: country
  ```
  * shocks in the origin country (used as a push-factor instrument in 1f's
  ```
- Line 9: country
  ```
  *         country of origin, 1890-1920.
  ```
- Line 12: son
  ```
  *         compute seasonal temperature shock dummies (positive/negative
  ```
- Line 13: country
  ```
  *         standard-deviation bins), aggregate to country-year via
  ```
- Line 14: lat
  ```
  *         population-weighted means.
  ```
- Line 16: country
  ```
  * Step 3: merge flows with shocks; for each country, regress log(imm_flow)
  ```
- Line 20: block, loc
  ```
  * Step 4: aggregate predicted flows to 10-year decadal blocks (anchor
  ```
- Line 25: country
  ```
  *   $rawdata/Willcox_1929/willcox_immigration_bycountry.csv
  ```
- Line 29: country
  ```
  *   predicted_flows_weather.dta  - country-year predicted weather-driven
  ```
- Line 32: lon
  ```
  * Run via 00_master.do, or standalone.
  ```
- Line 47: country
  ```
  * Willcox (1929) yearly immigration by European country of origin
  ```
- Line 52: country, lon
  ```
  reshape long immigr_, i(country) j(year)
  ```
- Line 53: name
  ```
  rename immigr_ imm_flow
  ```
- Line 56: country
  ```
  drop if country == "czechoslovakia" | country == "finland" | country == "other uk" | ///
  ```
- Line 57: country
  ```
  country == "poland" | country == "other europe" | country == "_england" | ///
  ```
- Line 58: country
  ```
  country == "_scotland" | country == "_wales" | country == "_greece" | ///
  ```
- Line 59: country
  ```
  country == "_portugal" | country == "_spain" | country == "romania"
  ```
- Line 61: country
  ```
  replace country = "aus_hung" if country == "austria-hungary"
  ```
- Line 62: country
  ```
  replace country = "gr_pt_es" if country == "greece-portugal-spain"
  ```
- Line 63: country
  ```
  replace country = "nether"   if country == "netherlands"
  ```
- Line 64: country
  ```
  replace country = "switz"    if country == "switzerland"
  ```
- Line 71: son
  ```
  * European weather data (Sequeira et al. 2020): seasonal temperature shocks
  ```
- Line 73: country, son
  ```
  * country-iso (ISO_ALPHA3) and per season (Fall=16, Spring=14, Summer=15,
  ```
- Line 79: country
  ```
  sort year country
  ```
- Line 80: country
  ```
  keep if country == "Austria" | country == "Belgium" | ///
  ```
- Line 81: country
  ```
  country == "Czech Republic" | country == "Denmark" | ///
  ```
- Line 82: country
  ```
  country == "Finland" | country == "France" | country == "Germany" | country == "Greece" | ///
  ```
- Line 83: country
  ```
  country == "Hungary" | country == "Ireland" | country == "Italy" | ///
  ```
- Line 84: country
  ```
  country == "Luxembourg" | ///
  ```
- Line 85: country
  ```
  country == "Netherlands" | country == "Norway" | country == "Poland" | ///
  ```
- Line 86: country
  ```
  country == "Portugal" | country == "Russia" | ///
  ```
- Line 87: country
  ```
  country == "Spain" | country == "Sweden" | ///
  ```
- Line 88: country
  ```
  country == "Switzerland" | country == "United Kingdom"
  ```
- Line 90: country
  ```
  replace country = lower(country)
  ```
- Line 91: country
  ```
  replace country = "aus_hung" if country == "austria" | country == "hungary"
  ```
- Line 92: country
  ```
  replace country = "czech"    if country == "czech republic"
  ```
- Line 93: country
  ```
  replace country = "gr_pt_es" if country == "greece" | country == "portugal" | country == "spain"
  ```
- Line 94: country
  ```
  replace country = "uk"       if country == "united kingdom"
  ```
- Line 95: country
  ```
  replace country = "luxemb"   if country == "luxembourg"
  ```
- Line 96: country
  ```
  replace country = "nether"   if country == "netherlands"
  ```
- Line 97: country
  ```
  replace country = "switz"    if country == "switzerland"
  ```
- Line 99: son
  ```
  * Build temperature shock indicators per season: a station-year is hit with
  ```
- Line 102: son
  ```
  foreach season_code in 16 14 15 13 {
  ```
- Line 104: loc, son
  ```
  if `season_code' == 16 local suffix = "f"   // Fall
  ```
- Line 105: loc, son
  ```
  if `season_code' == 14 local suffix = "s"   // Spring
  ```
- Line 106: loc, son
  ```
  if `season_code' == 15 local suffix = "su"  // Summer
  ```
- Line 107: loc, son
  ```
  if `season_code' == 13 local suffix = "w"   // Winter
  ```
- Line 110: son
  ```
  bysort ISO_ALPHA3: center temp if season == `season_code', standardize gen(temp_cstd)
  ```
- Line 126: country, lat
  ```
  * Aggregate shocks to country-year via station population-weighted means
  ```
- Line 129: country
  ```
  collapse (mean) tempshock* [pweight=grid_code/100], by(year country)
  ```
- Line 133: country
  ```
  * Per-country regression of log(imm_flow) on lagged temperature shocks;
  ```
- Line 143: country
  ```
  encode country, gen(country_n)
  ```
- Line 144: country
  ```
  xtset country_n year
  ```
- Line 148: country, loc
  ```
  levelsof country, local(countries) clean
  ```
- Line 149: country, loc
  ```
  foreach country of local countries {
  ```
- Line 151: country, loc, name
  ```
  if "`country'" == "aus_hung" local titlename = "Austria-Hungary"
  ```
- Line 152: country, loc, name
  ```
  if "`country'" == "belgium"  local titlename = "Belgium"
  ```
- Line 153: country, loc, name
  ```
  if "`country'" == "denmark"  local titlename = "Denmark"
  ```
- Line 154: country, loc, name
  ```
  if "`country'" == "france"   local titlename = "France"
  ```
- Line 155: country, loc, name
  ```
  if "`country'" == "germany"  local titlename = "Germany"
  ```
- Line 156: country, loc, name
  ```
  if "`country'" == "gr_pt_es" local titlename = "Greece-Portugal-Spain"
  ```
- Line 157: country, loc, name
  ```
  if "`country'" == "ireland"  local titlename = "Ireland"
  ```
- Line 158: country, loc, name
  ```
  if "`country'" == "italy"    local titlename = "Italy"
  ```
- Line 159: country, loc, name
  ```
  if "`country'" == "nether"   local titlename = "Netherlands"
  ```
- Line 160: country, loc, name
  ```
  if "`country'" == "norway"   local titlename = "Norway"
  ```
- Line 161: country, loc, name
  ```
  if "`country'" == "russia"   local titlename = "Russia"
  ```
- Line 162: country, loc, name
  ```
  if "`country'" == "sweden"   local titlename = "Sweden"
  ```
- Line 163: country, loc, name
  ```
  if "`country'" == "switz"    local titlename = "Switzerland"
  ```
- Line 164: country, loc, name
  ```
  if "`country'" == "uk"       local titlename = "United Kingdom"
  ```
- Line 166: country
  ```
  reg log_imm l1.tempshock* if country == "`country'" & inrange(year,1891,1920)
  ```
- Line 167: country
  ```
  predict pred_temp_log_imm_`country' if e(sample) == 1
  ```
- Line 168: country
  ```
  replace pred_temp_log_imm = pred_temp_log_imm_`country' if country == "`country'" & inrange(year,189
  ```
- Line 171: country
  ```
  (lfit pred_temp_log_imm log_imm, lcolor("navy*0.9") lwidth(medthin)) if country == "`country'", ///
  ```
- Line 178: country, name
  ```
  name(corr_logimm_`country', replace) title("`titlename'", size(small))
  ```
- Line 180: country
  ```
  drop pred_temp_log_imm_`country'
  ```
- Line 192: block, loc
  ```
  * Aggregate predicted flows to 10-year blocks at anchor years (1900, 1910, 1920)
  ```
- Line 201: country
  ```
  bysort country t_10: egen pred_temp_imm_10yr = total(pred_temp_imm)
  ```
- Line 204: country
  ```
  keep year country pred_temp_imm_10yr
  ```
- Line 206: country
  ```
  reshape wide pred_temp_imm_10yr, i(year) j(country) string
  ```
- Line 208: name
  ```
  rename pred_temp_imm_10yr* *_temp_US_10yr_mw
  ```
- Line 215: country
  ```
  label data "Country-year temperature-shock-driven predicted immigration flows"
  ```

**/replication-package/MS20241468_Deposit/code/1_construction/1f_shiftshare.do**

- Line 9: country
  ```
  * origin country.
  ```
- Line 13: country
  ```
  *   predicted_flows_weather.dta                - origin-country temperature
  ```
- Line 20: lon
  ```
  * Run via 00_master.do, or standalone.
  ```
- Line 35: name
  ```
  rename *_wkgagepop_* *_wa_*
  ```
- Line 36: name
  ```
  rename *_wkgage_* *_wa_*
  ```
- Line 57: lat
  ```
  bysort countynhg_1930 (year): gegen `var'_1890 = max(`var'_1890_temp)	// population in 1890
  ```
- Line 73: lat
  ```
  * US population and LF
  ```
- Line 90: lat
  ```
  *Population flows
  ```
- Line 103: country
  ```
  * By country
  ```
- Line 104: country
  ```
  foreach country in denmark norway finland sweden uk ireland oth_northeu ///
  ```
- Line 110: country
  ```
  bysort year: gegen `country'_US_10yr_`s' = sum(`country'_10yr_`s')
  ```
- Line 111: country
  ```
  gen `country'_US_10yr_`s'_lvout  		= `country'_US_10yr_`s' - `country'_10yr_`s'
  ```
- Line 170: country
  ```
  foreach country in denmark norway finland sweden uk ireland oth_northeu ///
  ```
- Line 177: country
  ```
  gen sh_`country'_10yr_`s' 		= `country'_10yr_`s' / all_totpop_`s'
  ```
- Line 196: country
  ```
  * By country
  ```
- Line 197: country
  ```
  foreach country in denmark norway finland sweden uk ireland oth_northeu ///
  ```
- Line 203: country
  ```
  bysort year: gegen `country'_US_wa_10yr_`s' = sum(`country'_wa_10yr_`s')
  ```
- Line 204: country
  ```
  gen `country'_US_wa_10yr_`s'_lvout  		= `country'_US_wa_10yr_`s' - `country'_wa_10yr_`s'
  ```
- Line 245: social
  ```
  * Non-Socialist (soc. parties below 10%, avg. 1890-1919)
  ```
- Line 254: social
  ```
  * Socialist (soc. parties above 10%, avg. 1890-1919)
  ```
- Line 260: social
  ```
  * Non-Socialist (soc. parties below 10%, avg. 1890-1919) + Russia
  ```
- Line 269: social
  ```
  * Socialist (soc. parties above 10%, avg. 1890-1919) No Russia
  ```
- Line 275: social
  ```
  * Non-Socialist (soc. parties below 20%, avg. 1890-1919)
  ```
- Line 284: social
  ```
  * Socialist (soc. parties above 20%, avg. 1890-1919)
  ```
- Line 287: social
  ```
  * Non-Socialist (soc. parties below 20%, avg. 1890-1919) + Russia
  ```
- Line 297: social
  ```
  * Socialist (soc. parties above 20%, avg. 1890-1919) No Russia
  ```
- Line 334: country
  ```
  foreach country in denmark norway finland sweden uk ireland oth_northeu ///
  ```
- Line 342: country
  ```
  gen sh_`country'_wa_10yr_`s' 		= `country'_wa_10yr_`s' / all_wa_`s'
  ```
- Line 352: lat
  ```
  * Predicted population
  ```
- Line 378: country
  ```
  * Initial settlement shares by country
  ```
- Line 380: country
  ```
  foreach country in denmark norway sweden uk ireland belgium france luxemb nether switz ///
  ```
- Line 383: country
  ```
  gegen `country'_mw_US_1890_temp 	= sum(`country'_mw) if year == 1890
  ```
- Line 384: country
  ```
  gegen `country'_mw_US_1890		= max(`country'_mw_US_1890_temp)
  ```
- Line 385: country
  ```
  drop  `country'_mw_US_1890_temp
  ```
- Line 387: country
  ```
  gen sh_`country'_mw_1890_temp 		= `country'_mw / `country'_mw_US_1890 if year == 1890
  ```
- Line 388: country
  ```
  bysort countynhg_1930 (year): gegen sh_`country'_mw_1890 = max(sh_`country'_mw_1890_temp)
  ```
- Line 389: country
  ```
  drop sh_`country'_mw_1890_temp
  ```
- Line 397: country
  ```
  * By country
  ```
- Line 398: country
  ```
  foreach country in denmark norway sweden uk ireland belgium france luxemb nether switz ///
  ```
- Line 401: country
  ```
  gen pr1890_`country'_10yr_`s' = sh_`country'_mw_1890 * `country'_US_10yr_`s'_lvout if year > 1890
  ```
- Line 403: country
  ```
  gen pr_temp_`country'_10yr_`s' = sh_`country'_mw_1890 * `country'_temp_US_10yr_mw if year > 1890
  ```
- Line 469: country
  ```
  foreach country in denmark norway sweden uk ireland nether belgium luxemb france switz ///
  ```
- Line 473: country
  ```
  gen `prtype'_sh_`country'_10yr_`s' = `prtype'_`country'_10yr_`s' / all_totpop_`s'_1890 if year > 189
  ```
- Line 481: lat
  ```
  * Predicted working-age population flows
  ```
- Line 483: country
  ```
  * By country
  ```
- Line 484: country
  ```
  foreach country in denmark norway sweden uk ireland belgium france luxemb nether switz ///
  ```
- Line 487: country
  ```
  gen pr1890_`country'_wa_10yr_m = sh_`country'_mw_1890 * `country'_US_wa_10yr_m_lvout if year > 1890
  ```
- Line 536: social
  ```
  * Non-Socialist (soc. parties below 10%, avg. 1890-1919)
  ```
- Line 542: social
  ```
  * Socialist (soc. parties above 10%, avg. 1890-1919)
  ```
- Line 550: social
  ```
  * Non-Socialist (soc. parties below 10%, avg. 1890-1919) + Russia
  ```
- Line 557: social
  ```
  * Socialist (soc. parties above 10%, avg. 1890-1919) No Russia
  ```
- Line 565: social
  ```
  * Non-Socialist (soc. parties below 20%, avg. 1890-1919)
  ```
- Line 575: social
  ```
  * Socialist (soc. parties above 20%, avg. 1890-1919)
  ```
- Line 581: social
  ```
  * Non-Socialist (soc. parties below 20%, avg. 1890-1919) + Russia
  ```
- Line 592: social
  ```
  * Socialist (soc. parties above 20%, avg. 1890-1919) No Russia
  ```
- Line 629: country
  ```
  foreach country in denmark norway sweden uk ireland nether belgium luxemb france switz ///
  ```
- Line 635: country
  ```
  gen `prtype'_sh_`country'_wa_10yr_m = `prtype'_`country'_wa_10yr_m / all_totpop_m_1890 if year > 189
  ```

**/replication-package/MS20241468_Deposit/code/1_construction/1g_crowdout.do**

- Line 24: lon
  ```
  * Run via 00_master.do, or standalone.
  ```
- Line 37: name
  ```
  rename *_wkgagepop_* *_wa_*
  ```
- Line 38: name
  ```
  rename *_wkgage_* *_wa_*
  ```
- Line 39: name
  ```
  rename *_m *
  ```
- Line 64: loc
  ```
  local occs 0 1 2 3 4 5 6 7 8 9 10 12 13 14 15 16 17 18 19 23 24 25 26 27 28 29 ///
  ```
- Line 76: loc
  ```
  foreach o of local occs {
  ```
- Line 101: loc
  ```
  foreach o of local occs {
  ```

**/replication-package/MS20241468_Deposit/code/1_construction/1h_final_dataset.do**

- Line 19: lat
  ```
  *                                  manufacturing interpolation, Logan-Parman
  ```
- Line 23: lat
  ```
  *                                  merges, interpolation, zero-fills, combined
  ```
- Line 25: loc, name
  ```
  *                                  locals/members derivations, final renames
  ```
- Line 33: loc
  ```
  *   $intmdata/KOL_locals_1880-1890_county1930.dta     - KoL locals
  ```
- Line 42: lon
  ```
  * Run via 00_master.do, or standalone.
  ```
- Line 50: loc
  ```
  * lets this file run on its own -- set it to the local path of the package.
  ```
- Line 55: census
  ```
  global censusagg "$rawdata/census_aggregates"   // shipped aggregates built by build_documentation/
  ```
- Line 64: census
  ```
  gen census = year if inlist(year,1880,1890,1900,1910,1920) == 1
  ```
- Line 79: name
  ```
  order statename statecode, after(statefip)
  ```
- Line 140: phone
  ```
  gegen `i'_lf_electrical_m = rowtotal(`i'_occ515_m `i'_occ603_m `i'_occ540_m `i'_occ370_m `i'_occ44_m
  ```
- Line 142: son
  ```
  gegen `i'_lf_brickl_m = rowtotal(`i'_occ504_m `i'_occ601_m `i'_occ573_m), missing // brickmasons and
  ```
- Line 144: lat
  ```
  gegen `i'_lf_typogr_m	= rowtotal(`i'_occ575_m `i'_occ613_m), missing			// pressmen and plate printer
  ```
- Line 149: street
  ```
  gegen `i'_lf_streetrail_m = rowtotal(`i'_occ631_m `i'_occ661_m), missing		// street railway conducto
  ```
- Line 151: lon
  ```
  gegen `i'_lf_longshoreman_m = rowtotal(`i'_occ940_m), missing					// longshoremen
  ```
- Line 211: loc
  ```
  gegen all_lf_afloccs_m = rowtotal(all_occ1_m all_occ4_m all_occ46_m all_occ47_m all_occ48_m ///
  ```
- Line 244: house
  ```
  * Excluded categories: managers, farmers, farm laborers, household service.
  ```
- Line 249: house
  ```
  **Low skill: laborers [910,980], non-household service workers [730,790], operatives [600,690]
  ```
- Line 264: house
  ```
  **Low skill alternative (operatives excluded): laborers [910,980], non-household service workers [73
  ```
- Line 373: name
  ```
  rename crowdout* co*
  ```
- Line 378: house
  ```
  **Low skill: laborers [910,970], non-household service workers [730,790], operatives [600,690]
  ```
- Line 460: lat
  ```
  * demographic control shares; merges the CPI series and produces interpolated
  ```
- Line 461: lat
  ```
  * and deflated manufacturing measures; constructs Logan-Parman (2017)
  ```
- Line 475: loc
  ```
  **Add data on 1880 and 1890 nr of locals of Knights of Labor
  ```
- Line 478: loc
  ```
  replace locals_kol = 0 if _merge == 1 & inlist(year,1880,1890) == 1
  ```
- Line 481: loc
  ```
  **Add data on 1906-1917 nr of locals of IWW
  ```
- Line 484: loc
  ```
  replace IWW_locals = 0 if _merge == 1
  ```
- Line 485: loc, name
  ```
  rename IWW_locals locals_IWW_0617
  ```
- Line 486: loc
  ```
  gen d_IWW_0617 = (locals_IWW_0617 > 0) if locals_IWW_0617 != .
  ```
- Line 521: lat
  ```
  * CPI merge; manufacturing interpolation and deflation
  ```
- Line 529: census, lat
  ```
  ***Interpolate values for 1910: the 1910 Census of Manufacturing was not
  ```
- Line 531: census
  ```
  ***the 1900 and 1920 census-of-manufacturing observations.
  ```
- Line 540: lat
  ```
  ***Deflate variables (in 1900 USD)
  ```
- Line 575: lat, loc
  ```
  * Knights-of-Labor locals per population
  ```
- Line 578: lat, loc
  ```
  **Locals of KOL divided by male population
  ```
- Line 579: loc
  ```
  gen locals_kol_perpop = locals_kol / all_totpop_m if inlist(year,1880,1890) == 1
  ```
- Line 580: loc
  ```
  gen locals_kol_perurbpop = locals_kol / all_urbanpop_mw if inlist(year,1880,1890) == 1
  ```
- Line 644: loc
  ```
  locals_kol locals_kol_perpop locals_kol_perurbpop {
  ```
- Line 659: loc
  ```
  locals_kol locals_kol_perpop locals_kol_perurbpop {
  ```
- Line 671: loc
  ```
  locals_kol locals_kol_perpop locals_kol_perurbpop ///
  ```
- Line 672: loc
  ```
  coalmines_reg coalmines_loc coalmines_tot {
  ```
- Line 687: loc
  ```
  locals_kol locals_kol_perpop locals_kol_perurbpop ///
  ```
- Line 688: loc
  ```
  coalmines_reg coalmines_loc coalmines_tot {
  ```
- Line 721: name
  ```
  rename `j'_1856 `j'_1856_temp
  ```
- Line 763: loc
  ```
  * Merges the combined union membership and locals counts (built by the
  ```
- Line 767: census
  ```
  * each county and census year.
  ```
- Line 848: loc
  ```
  gen afl_`i'_locperlf			= ((afl_locals_`i') / (all_lf_highskill2_m + all_lf_midskill2_m + all_lf_lows
  ```
- Line 869: loc
  ```
  gen afl_comb_`i'_locperlf		= ((afl_locals_comb_`i') / (all_lf_highskill2_m + all_lf_midskill2_m)) * 
  ```
- Line 870: loc
  ```
  gen afl_`i'_locperlf			= ((afl_locals_`i') / (all_lf_highskill2_m + all_lf_midskill2_m)) * 1000 if i
  ```
- Line 890: loc
  ```
  gen afl_comb_`i'_locperlf		= ((afl_locals_comb_`i') / (all_lf_lowskill_m)) * 1000 if inlist(year,190
  ```
- Line 891: loc
  ```
  gen afl_`i'_locperlf			= ((afl_locals_`i') / (all_lf_lowskill_m)) * 1000 if inlist(year,1900,1910,19
  ```
- Line 914: street
  ```
  gen		afl_aaser_density		= (afl_members_aaser) / all_lf_streetrail_m if inlist(year,1900,1910,1920)
  ```
- Line 924: lon
  ```
  gen		afl_ila_density			= (afl_members_ila) / all_lf_longshoreman_m if inlist(year,1900,1910,1920)
  ```
- Line 935: name
  ```
  * Final rename cascade and save
  ```
- Line 938: name
  ```
  rename (*_members_combined) (afl_memb_comb_*)
  ```
- Line 939: name
  ```
  rename (*_combined_density*) (*_comb_dens*)
  ```
- Line 940: loc, name
  ```
  rename (*_locals_combined*) (*_comb_locals*)
  ```
- Line 941: loc, name
  ```
  rename (*_locals_comb*) (*_comb_locals*)
  ```
- Line 942: name
  ```
  rename (afl_*_density*) (afl_*_dens*)
  ```
- Line 943: name
  ```
  rename (*members*) (*memb*)
  ```
- Line 944: name
  ```
  rename (afl_memb_comb*) (afl_comb_memb*)
  ```
- Line 947: name
  ```
  rename `union'_comb_dens* afl_comb_`union'_dens*
  ```
- Line 948: loc, name
  ```
  rename `union'_comb_locals afl_comb_`union'_locals
  ```
- Line 951: loc, name
  ```
  rename (afl_comb_dens* *afl_comb_locals afl_comb_memb) (afl_comb_all_dens* *afl_comb_locals_all afl_
  ```
- Line 952: loc, name
  ```
  rename afl_comb_*_locals afl_comb_locals_*
  ```
- Line 953: loc, name
  ```
  rename afl_comb_locperlf afl_comb_all_locperlf
  ```
- Line 958: country
  ```
  * intermediates dropped below (per-country shift-share / weather instrument
  ```
- Line 959: census
  ```
  * components, women-only census counts, per-worker manufacturing figures, and
  ```
- Line 962: loc
  ```
  local dropvars ///
  ```
- Line 999: loc
  ```
  log_all_lf_typogr_m_1900 log_all_lf_afloccs_m_1900 all_urbanpop_mw_1900 log_all_urbanpop_mw_1900 imm
  ```
- Line 1016: loc
  ```
  ihs_mfgout_pw_m_ip_defl_1880 ihs_mfgout_pw_w_ip_defl_1880 ihs_locals_kol_perurbpop_1880 mfgestab_ip_
  ```
- Line 1018: loc
  ```
  mfglabor_share_w_1890 coalmines_reg_1890 coalmines_loc_1890 ihs_mfgestab_pw_ip_m_1890 ihs_mfgestab_p
  ```
- Line 1019: loc
  ```
  ihs_mfgwages_pw_w_ip_defl_1890 ihs_mfgwages_mw_ip_defl_1890 ihs_mfgout_pw_m_ip_defl_1890 ihs_mfgout_
  ```
- Line 1024: loc
  ```
  local dropvars : list dropvars & present
  ```

**/replication-package/MS20241468_Deposit/code/2_analysis/2_sample_specifications.do**

- Line 12: loc
  ```
  * hyperbolic-sine, and log transforms; winsorizes the density, locals, and
  ```
- Line 28: loc
  ```
  * lets this file run on its own -- set it to the local path of the package.
  ```
- Line 69: census
  ```
  * In sample: census years 1900-1920 with the dependent variable, the
  ```
- Line 71: lat
  ```
  * population or at least one coal mine in 1890. The balanced sample keeps
  ```
- Line 90: census
  ```
  gen insample = (inlist(year,1900,1910,1920) == 1 & ///       census years 1900-1920
  ```
- Line 98: lat
  ```
  (urban_1890 == 1 | mining_1890 == 1))      // some urban population or a coal mine in 1890
  ```
- Line 116: loc
  ```
  * Union density, locals, and presence
  ```
- Line 120: loc
  ```
  replace afl_comb_locals_`union' = . if afl_comb_`union'_dens == .
  ```
- Line 121: loc
  ```
  replace afl_locals_`union'      = . if afl_`union'_dens == .
  ```
- Line 138: loc, name
  ```
  rename afl_comb_locals_* afl_comb_*_locals
  ```
- Line 139: loc, name
  ```
  rename afl_locals_*      afl_*_locals
  ```
- Line 148: loc
  ```
  gen afl_comb_`union'_avgmemb = afl_comb_memb_`union' / afl_comb_`union'_locals if afl_comb_`union'_d
  ```
- Line 152: loc
  ```
  gen afl_`union'_avgmemb = afl_memb_`union' / afl_`union'_locals if afl_`union'_dens != .
  ```
- Line 161: birth
  ```
  * For each origin definition (bpl = birthplace, anc = ancestry), the combined
  ```
- Line 169: name
  ```
  rename *_`j'_euronw* *_`j'_eunw*
  ```
- Line 170: name
  ```
  rename *_`j'_eurose* *_`j'_euse*
  ```
- Line 171: name
  ```
  rename *_`j'_euro*   *_`j'_eu*
  ```
- Line 172: name
  ```
  rename *_`j'_other*  *_`j'_oth*
  ```
- Line 194: name
  ```
  rename *_`j'_native* *_`j'_nat*
  ```
- Line 237: loc
  ```
  * Winsorize and transform locals
  ```
- Line 240: loc
  ```
  foreach var of varlist afl_*_dens afl_*_locperlf afl_*_locals afl_*_avgmemb {
  ```
- Line 245: loc
  ```
  gen afl_comb_`union'_ihsloc = asinh(afl_comb_`union'_locals)
  ```
- Line 246: loc
  ```
  gen afl_comb_`union'_logloc = log(1 + afl_comb_`union'_locals)
  ```
- Line 247: loc
  ```
  gen afl_`union'_ihsloc = asinh(afl_`union'_locals)
  ```
- Line 248: loc
  ```
  gen afl_`union'_logloc = log(1 + afl_`union'_locals)
  ```

**/replication-package/MS20241468_Deposit/code/2_analysis/2a_sumstats.do**

- Line 6: lat
  ```
  * summary-statistics table; correlates of the 1890 European-immigrant share;
  ```
- Line 7: lat, lon
  ```
  * the long-difference relationship between immigrant inflows and union strength;
  ```
- Line 8: lat
  ```
  * scatter correlations between the state-federation and national-
  ```
- Line 9: lat
  ```
  * union membership and branch counts; the correlation of the 1920 county
  ```
- Line 17: coord
  ```
  *   $intmdata/US_county_1930_WGS84_coord.dta          - county polygon coordinates (1a)
  ```
- Line 20: name
  ```
  *   $intmdata/xwalk_occ1950_occnames.dta              - OCC1950 occupation labels (1a)
  ```
- Line 25: lat, loc
  ```
  *   $figures/datasources_memb_correlation.pdf, datasources_locals_correlation.pdf
  ```
- Line 30: lon
  ```
  * Run via 00_master.do, or standalone.
  ```
- Line 37: loc
  ```
  * lets this file run on its own -- set it to the local path of the package.
  ```
- Line 58: name
  ```
  rename gisjoin_1930 GISJOIN
  ```
- Line 65: coord
  ```
  use "$intmdata/US_county_1930_WGS84_coord", clear
  ```
- Line 72: coord
  ```
  save "$intmdata/US_county_balancedpanel_1930_WGS84_coord", replace
  ```
- Line 80: loc
  ```
  keep insample insample_balanced countynhg gisjoin afl_comb_all_dens afl_comb_all_locals year statefi
  ```
- Line 82: name
  ```
  rename gisjoin GISJOIN
  ```
- Line 91: loc
  ```
  local title = "Union Density = Union Members / Labor Force"
  ```
- Line 103: loc
  ```
  local p`i' = r(mean)
  ```
- Line 106: loc
  ```
  local max = `r(max)'
  ```
- Line 107: loc
  ```
  local clbreaks = "0"
  ```
- Line 110: loc
  ```
  local clbreaks "`clbreaks'" " " "`j'"
  ```
- Line 115: loc
  ```
  format afl_comb_all_locals %12.0f
  ```
- Line 125: name
  ```
  legtitle(`title') legend(off) title(`year', size(small)) name (union`outcome'_`year', replace) ///
  ```
- Line 126: coord
  ```
  polygon(data("$intmdata/US_county_balancedpanel_1930_WGS84_coord.dta") fcolor(none) ocolor(black) os
  ```
- Line 137: name
  ```
  legtitle(`title') title(`year', size(small)) name (union`outcome'_`year', replace) ///
  ```
- Line 138: coord
  ```
  polygon(data("$intmdata/US_county_balancedpanel_1930_WGS84_coord.dta") fcolor(none) ocolor(black) os
  ```
- Line 164: loc
  ```
  global sumstats_timevar		afl_comb_all_pres afl_comb_all_locals afl_comb_all_dens afl_comb_all_avgmem
  ```
- Line 197: lat
  ```
  * Correlates of the 1890 European-immigrant share
  ```
- Line 198: lat
  ```
  * Paper: Correlation Between Immigration and County Characteristics in 1890 (Table A.2); output corr
  ```
- Line 204: lat
  ```
  label var euro_imm_share_mw_1890 "Share of European Immigrant Population"
  ```
- Line 205: lat
  ```
  label var urban_share_mw_1890 "Share of Urban Population"
  ```
- Line 209: lat, loc
  ```
  local correlates = "mfglabor_share_mw_1890 farmfams_share_1890 mining_1890"
  ```
- Line 210: loc, name
  ```
  local filename = "corr_euroimm1890"
  ```
- Line 213: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 219: loc
  ```
  gen delta_unionlocals = f20.afl_comb_all_ihsloc - afl_comb_all_ihsloc
  ```
- Line 221: lat
  ```
  reghdfe euro_imm_share_mw_1890 `correlates' if year == 1900 & insample_balanced == 1, noabsorb clust
  ```
- Line 228: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 242: loc
  ```
  local n = 4
  ```
- Line 248: loc
  ```
  local var = "sh_euro_wa_10yr_m"
  ```
- Line 249: loc, name
  ```
  local filename = "immflow_unionstrength"
  ```
- Line 255: loc
  ```
  foreach indepvar in afl_comb_all_pres afl_comb_all_ihsloc afl_comb_all_dens afl_comb_all_avgmemb {
  ```
- Line 260: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 262: loc
  ```
  if "`indepvar'" == "afl_comb_all_ihsloc" {
  ```
- Line 263: loc
  ```
  qui sum afl_comb_all_locals if e(sample) == 1
  ```
- Line 265: loc
  ```
  local `indepvar'mean = string(r(mean),"%6.3fc")
  ```
- Line 266: loc
  ```
  local `indepvar'stdev = string(r(sd),"%6.3fc")
  ```
- Line 276: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 283: lat
  ```
  * Correlation between AFL state-convention and national-union proceedings data
  ```
- Line 284: lat
  ```
  * Paper: Correlation Between Measures Across Data Sources (Figure A.4);
  ```
- Line 285: lat, loc
  ```
  *        outputs datasources_memb_correlation.pdf, datasources_locals_correlation.pdf
  ```
- Line 291: name
  ```
  rename itu_memb itu_memb_proxy_votes
  ```
- Line 297: loc, name, son
  ```
  local unionname = "Bricklayers, Masons, and Plasterers (BMPIU)"
  ```
- Line 300: loc, name
  ```
  local unionname = "Machinists (IAM)"
  ```
- Line 303: loc, name
  ```
  local unionname = "Teamsters (IBT)"
  ```
- Line 306: loc, name
  ```
  local unionname = "Typographers (ITU)"
  ```
- Line 309: loc, name
  ```
  local unionname = "Carpenters and Joiners (UBC)"
  ```
- Line 312: loc, name
  ```
  local unionname = "Mine Workers (UMWA)"
  ```
- Line 324: name
  ```
  name(`union'_memb_corr, replace) title("`unionname'", size(small))
  ```
- Line 326: loc
  ```
  binscatter `union'_locals_votes afl_locals_`union' if insample == 1, n(500) reportreg ///
  ```
- Line 334: loc, name
  ```
  name(`union'_locals_corr, replace) title("`unionname'", size(small))
  ```
- Line 341: lat
  ```
  graph export "$figures/datasources_memb_correlation.pdf", replace
  ```
- Line 344: loc
  ```
  graph combine bmpiu_locals_corr iam_locals_corr itu_locals_corr ubc_locals_corr umwa_locals_corr, //
  ```
- Line 347: lat, loc
  ```
  graph export "$figures/datasources_locals_correlation.pdf", replace
  ```
- Line 353: lat
  ```
  * Correlation with the Farber et al. (2021) union-density series
  ```
- Line 354: lat
  ```
  * Paper: Correlation Between Data of This Paper and State-Level Gallup Data (Figure H.1);
  ```
- Line 362: name
  ```
  rename state statefip
  ```
- Line 373: loc, name
  ```
  local filename = "farberetal_mydata_balanced"
  ```
- Line 398: name
  ```
  name(`filename'_all, replace) title("Panel A", size(small))
  ```
- Line 411: name
  ```
  name(`filename'_noWY, replace) title("Panel B", size(small))
  ```
- Line 413: name
  ```
  graph combine `filename'_all `filename'_noWY, graphregion(color(white) margin(zero)) ///
  ```
- Line 416: name
  ```
  graph export "$figures/corr_`filename'.pdf", replace
  ```
- Line 482: name
  ```
  rename *occ*_10yr_m *10yr_occ*
  ```
- Line 483: name
  ```
  rename *occ*_m *tot_occ*
  ```
- Line 486: lon
  ```
  reshape long share_euro_imm_10yr share_nat_tot, i(year) j(occ) string
  ```
- Line 488: name
  ```
  rename occ occ1950
  ```
- Line 494: name
  ```
  order occname, after(occ1950)
  ```
- Line 497: name
  ```
  reshape wide share*, i(occ1950 occname) j(year)
  ```
- Line 508: name
  ```
  egen order_euro_imm_mean = rank(share_euro_imm_mean) if strpos(occname,"Managers") == 0 & strpos(occ
  ```
- Line 511: name
  ```
  egen order_nat_mean = rank(share_nat_mean) if strpos(occname,"Managers") == 0 & strpos(occname,"Farm
  ```
- Line 515: name
  ```
  over(occname, gap(150) label(labsize(small)) sort(order_euro_imm_mean)) ///
  ```
- Line 519: name
  ```
  graphregion(color(white)) plotregion(color(white)) name(euroimm_main_occ_1900_1920, replace)
  ```
- Line 524: name
  ```
  over(occname, gap(150) label(labsize(small)) sort(order_euro_imm_mean)) ///
  ```
- Line 528: name
  ```
  graphregion(color(white)) plotregion(color(white)) name(nat_main_occ_1900_1920, replace)
  ```
- Line 545: loc
  ```
  local junk : dir "$tables" files "`pat'"
  ```
- Line 546: loc
  ```
  foreach f of local junk {
  ```

**/replication-package/MS20241468_Deposit/code/2_analysis/2b_figures_descriptives.do**

- Line 5: lat
  ```
  * population by region of origin, 1850-1920; and a two-panel trend combining
  ```
- Line 20: lon
  ```
  * Run via 00_master.do, or standalone.
  ```
- Line 27: loc
  ```
  * lets this file run on its own -- set it to the local path of the package.
  ```
- Line 39: lat
  ```
  * Composition of the foreign-born population by origin, 1850-1920
  ```
- Line 40: lat
  ```
  * Paper: Origin Regions within the Foreign Born Population, 1850-1920 (Figure A.1); output immigrmix
  ```
- Line 57: lat
  ```
  ytitle(Percentage of the Foreign-Born Population, size(small) margin(medium)) ///
  ```
- Line 60: name
  ```
  name(, replace) title(, size(small))
  ```
- Line 80: name
  ```
  name(union_membership_freeman, replace) title("Panel A: Union Members", size(medsmall))
  ```
- Line 96: name
  ```
  name(union_membership_freeman, replace) title("Panel B: Inflow of Immigrants", size(medsmall))
  ```

**/replication-package/MS20241468_Deposit/code/2_analysis/2c_results_main.do**

- Line 8: country
  ```
  * heterogeneity by immigrant country of origin, Know-Nothing vote share, and
  ```
- Line 18: lon
  ```
  * Run via 00_master.do, or standalone.
  ```
- Line 26: loc
  ```
  * lets this file run on its own -- set it to the local path of the package.
  ```
- Line 53: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 59: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 61: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 63: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 64: loc
  ```
  local sheurostdev = string(r(sd),"%6.3fc")
  ```
- Line 83: loc, name
  ```
  local filename = "baseline"
  ```
- Line 86: name
  ```
  cap erase "$tables/`filename'_ols.`fmt'"
  ```
- Line 87: name
  ```
  cap erase "$tables/`filename'_redform.`fmt'"
  ```
- Line 88: name
  ```
  cap erase "$tables/`filename'_2sls.`fmt'"
  ```
- Line 91: loc
  ```
  local n = 4
  ```
- Line 93: loc
  ```
  foreach outcome in pres ihsloc dens avgmemb {
  ```
- Line 95: loc
  ```
  local union = "all"
  ```
- Line 96: loc
  ```
  local var = "afl_comb_`union'_`outcome'"
  ```
- Line 103: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 105: loc
  ```
  if "`outcome'" == "ihsloc" {
  ```
- Line 106: loc
  ```
  qui sum afl_comb_`union'_locals if e(sample) == 1
  ```
- Line 108: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 110: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 111: loc
  ```
  local sheurostdev = string(r(sd),"%6.3fc")
  ```
- Line 124: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 126: loc
  ```
  if "`outcome'" == "ihsloc" {
  ```
- Line 127: loc
  ```
  qui sum afl_comb_`union'_locals if e(sample) == 1
  ```
- Line 129: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 131: loc
  ```
  local indepvarmean = string(r(mean),"%6.3fc")
  ```
- Line 132: loc
  ```
  local indepvarstdev = string(r(sd),"%6.3fc")
  ```
- Line 145: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 146: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 148: loc
  ```
  if "`outcome'" == "ihsloc" {
  ```
- Line 149: loc
  ```
  qui sum afl_comb_`union'_locals if e(sample) == 1
  ```
- Line 151: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 153: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 154: loc
  ```
  local sheurostdev = string(r(sd),"%6.3fc")
  ```
- Line 165: name
  ```
  cap erase "$tables/`filename'_ols.`fmt'"
  ```
- Line 166: name
  ```
  cap erase "$tables/`filename'_redform.`fmt'"
  ```
- Line 167: name
  ```
  cap erase "$tables/`filename'_2sls.`fmt'"
  ```
- Line 177: loc
  ```
  local n = 4
  ```
- Line 212: loc
  ```
  gen sheuro_extm_`union' = sh_euro_wa_10yr_m * (locals_kol_1890 == 0) if insample_balanced == 1 & loc
  ```
- Line 213: loc
  ```
  gen sheuro_intm_`union' = sh_euro_wa_10yr_m * (locals_kol_1890 > 0) if insample_balanced == 1 & loca
  ```
- Line 214: loc
  ```
  gen pr1890sheuro_extm_`union' = pr1890_sh_euro_wa_10yr_m * (locals_kol_1890 == 0) if insample_balanc
  ```
- Line 215: loc
  ```
  gen pr1890sheuro_intm_`union' = pr1890_sh_euro_wa_10yr_m * (locals_kol_1890 > 0) if insample_balance
  ```
- Line 217: loc, name
  ```
  local filename = "intextmargin_`union'"
  ```
- Line 218: loc
  ```
  local n = 4
  ```
- Line 221: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 224: loc
  ```
  local regcount = 0
  ```
- Line 226: loc
  ```
  foreach outcome in ihsloc dens avgmemb {
  ```
- Line 228: loc
  ```
  local regcount = `regcount' + 1
  ```
- Line 230: loc
  ```
  local var = "afl_comb_`union'_`outcome'"
  ```
- Line 241: loc
  ```
  local fstat_weakiv = string(r(stat),"%6.2fc")
  ```
- Line 244: loc
  ```
  local fstat_weakiv = "Stata 17+ required"
  ```
- Line 252: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 253: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 255: loc
  ```
  local partfstat1 = string(first[8,1],"%6.2fc")
  ```
- Line 256: loc
  ```
  local partfstat2 = string(first[8,2],"%6.2fc")
  ```
- Line 258: loc
  ```
  if "`outcome'" == "ihsloc" {
  ```
- Line 259: loc
  ```
  qui sum afl_comb_`union'_locals if e(sample) == 1
  ```
- Line 261: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 263: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 264: loc
  ```
  local sheurostdev = string(r(sd),"%6.3fc")
  ```
- Line 266: loc
  ```
  local alwaysunion`union'mean = string(r(mean),"%6.3fc")
  ```
- Line 280: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 295: loc
  ```
  local unions = "sk unsk"
  ```
- Line 297: loc
  ```
  foreach union of local unions {
  ```
- Line 299: loc, name
  ```
  local filename = "`unionclass'_`union'"
  ```
- Line 300: loc
  ```
  local n = 4
  ```
- Line 303: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 306: loc
  ```
  foreach outcome in pres ihsloc dens avgmemb  {
  ```
- Line 308: loc
  ```
  local var = "afl_comb_`union'_`outcome'"
  ```
- Line 314: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 315: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 317: loc
  ```
  if "`outcome'" == "ihsloc" {
  ```
- Line 318: loc
  ```
  qui sum afl_comb_`union'_locals if e(sample) == 1
  ```
- Line 320: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 322: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 323: loc
  ```
  local sheurostdev = string(r(sd),"%6.3fc")
  ```
- Line 332: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 346: loc
  ```
  local n = 4
  ```
- Line 353: loc
  ```
  local lfgroup = "mhsk"
  ```
- Line 356: loc
  ```
  local lfgroup = "lsk"
  ```
- Line 360: loc, name
  ```
  local filename = "het_crowdout_`union'"
  ```
- Line 364: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 367: loc
  ```
  local regcount = 0
  ```
- Line 369: loc
  ```
  foreach outcome in pres loc dens avgmemb {
  ```
- Line 371: loc
  ```
  local regcount = `regcount' + 1
  ```
- Line 373: loc
  ```
  local var = "afl_comb_`union'_`outcome'"
  ```
- Line 377: loc, name
  ```
  rename *_ihsloc *_loc
  ```
- Line 395: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 396: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 398: loc
  ```
  local partfstat1 = string(first[8,1],"%6.2fc")
  ```
- Line 399: loc
  ```
  local partfstat2 = string(first[8,2],"%6.2fc")
  ```
- Line 400: loc
  ```
  local partfstat3 = string(first[8,3],"%6.2fc")
  ```
- Line 402: loc
  ```
  if "`outcome'" == "loc" {
  ```
- Line 403: loc
  ```
  qui sum afl_comb_`union'_locals if e(sample) == 1
  ```
- Line 405: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 407: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 408: loc
  ```
  local sheurostdev = string(r(sd),"%6.3fc")
  ```
- Line 436: loc
  ```
  local fstat_weakiv = string(r(stat),"%6.2fc")
  ```
- Line 439: loc
  ```
  local fstat_weakiv = "Stata 17+ required"
  ```
- Line 447: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 448: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 450: loc
  ```
  local partfstat1 = string(first[8,1],"%6.2fc")
  ```
- Line 451: loc
  ```
  local partfstat2 = string(first[8,2],"%6.2fc")
  ```
- Line 453: loc
  ```
  if "`outcome'" == "loc" {
  ```
- Line 454: loc
  ```
  qui sum afl_comb_`union'_locals if e(sample) == 1
  ```
- Line 456: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 458: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 459: loc
  ```
  local sheurostdev = string(r(sd),"%6.3fc")
  ```
- Line 475: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 483: country
  ```
  * Heterogeneity by immigrant country of origin
  ```
- Line 489: loc
  ```
  local n = 4
  ```
- Line 490: loc, name
  ```
  local filename = "byorigin_`union'"
  ```
- Line 493: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 496: loc
  ```
  local regcount = 0
  ```
- Line 498: loc
  ```
  foreach outcome in pres ihsloc dens avgmemb {
  ```
- Line 500: loc
  ```
  local regcount = `regcount' + 1
  ```
- Line 504: loc
  ```
  local var = "afl_comb_`union'_`outcome'"
  ```
- Line 514: loc
  ```
  local fstat_weakiv = string(r(stat),"%6.2fc")
  ```
- Line 517: loc
  ```
  local fstat_weakiv = "Stata 17+ required"
  ```
- Line 524: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 525: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 527: loc
  ```
  local partfstat1 = string(first[8,1],"%6.2fc")
  ```
- Line 528: loc
  ```
  local partfstat2 = string(first[8,2],"%6.2fc")
  ```
- Line 530: loc
  ```
  if "`outcome'" == "ihsloc" {
  ```
- Line 531: loc
  ```
  qui sum afl_comb_`union'_locals if e(sample) == 1
  ```
- Line 533: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 535: loc
  ```
  local shseeuromean = string(r(mean),"%6.3fc")
  ```
- Line 537: loc
  ```
  local shnweuromean = string(r(mean),"%6.3fc")
  ```
- Line 552: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 566: loc
  ```
  local n = 4
  ```
- Line 568: loc, name
  ```
  local filename = "het_knownotshare_`union'"
  ```
- Line 570: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 571: name
  ```
  cap erase "$tables/`filename'_alt.`fmt'"
  ```
- Line 587: loc
  ```
  local regcount = 0
  ```
- Line 589: loc
  ```
  foreach outcome in pres ihsloc dens avgmemb {
  ```
- Line 591: loc
  ```
  local regcount = `regcount' + 1
  ```
- Line 593: loc
  ```
  local var = "afl_comb_`union'_`outcome'"
  ```
- Line 604: loc
  ```
  local fstat_weakiv = string(r(stat),"%6.2fc")
  ```
- Line 607: loc
  ```
  local fstat_weakiv = "Stata 17+ required"
  ```
- Line 617: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 618: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 620: loc
  ```
  local partfstat1 = string(first[8,1],"%6.2fc")
  ```
- Line 621: loc
  ```
  local partfstat2 = string(first[8,2],"%6.2fc")
  ```
- Line 623: loc
  ```
  if "`outcome'" == "ihsloc" {
  ```
- Line 624: loc
  ```
  qui sum afl_comb_`union'_locals if e(sample) == 1
  ```
- Line 626: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 628: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 629: loc
  ```
  local sheurostdev = string(r(sd),"%6.3fc")
  ```
- Line 631: loc
  ```
  local coef_lc = string(_b[lc],"%6.3fc")
  ```
- Line 632: loc
  ```
  local se_lc = string(_se[lc],"%6.3fc")
  ```
- Line 650: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 651: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 653: loc
  ```
  local partfstat1 = string(first[8,1],"%6.2fc")
  ```
- Line 654: loc
  ```
  local partfstat2 = string(first[8,2],"%6.2fc")
  ```
- Line 655: loc
  ```
  local partfstat3 = string(first[8,3],"%6.2fc")
  ```
- Line 657: loc
  ```
  if "`outcome'" == "ihsloc" {
  ```
- Line 658: loc
  ```
  qui sum afl_comb_`union'_locals if e(sample) == 1
  ```
- Line 660: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 662: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 663: loc
  ```
  local sheurostdev = string(r(sd),"%6.3fc")
  ```
- Line 676: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 677: name
  ```
  cap erase "$tables/`filename'_alt.`fmt'"
  ```
- Line 690: loc
  ```
  local n = 4
  ```
- Line 692: loc, name
  ```
  local filename = "het_residsegr_`union'"
  ```
- Line 694: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 695: name
  ```
  cap erase "$tables/`filename'_alt.`fmt'"
  ```
- Line 711: loc
  ```
  local regcount = 0
  ```
- Line 713: loc
  ```
  foreach outcome in pres ihsloc dens avgmemb {
  ```
- Line 715: loc
  ```
  local regcount =`regcount' + 1
  ```
- Line 717: loc
  ```
  local var = "afl_comb_`union'_`outcome'"
  ```
- Line 728: loc
  ```
  local fstat_weakiv = string(r(stat),"%6.2fc")
  ```
- Line 731: loc
  ```
  local fstat_weakiv = "Stata 17+ required"
  ```
- Line 741: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 742: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 744: loc
  ```
  local partfstat1 = string(first[8,1],"%6.2fc")
  ```
- Line 745: loc
  ```
  local partfstat2 = string(first[8,2],"%6.2fc")
  ```
- Line 747: loc
  ```
  if "`outcome'" == "ihsloc" {
  ```
- Line 748: loc
  ```
  qui sum afl_comb_`union'_locals if e(sample) == 1
  ```
- Line 750: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 752: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 753: loc
  ```
  local sheurostdev = string(r(sd),"%6.3fc")
  ```
- Line 755: loc
  ```
  local coef_lc = string(_b[lc],"%6.3fc")
  ```
- Line 756: loc
  ```
  local se_lc = string(_se[lc],"%6.3fc")
  ```
- Line 774: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 775: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 777: loc
  ```
  local partfstat1 = string(first[8,1],"%6.2fc")
  ```
- Line 778: loc
  ```
  local partfstat2 = string(first[8,2],"%6.2fc")
  ```
- Line 779: loc
  ```
  local partfstat3 = string(first[8,3],"%6.2fc")
  ```
- Line 781: loc
  ```
  if "`outcome'" == "ihsloc" {
  ```
- Line 782: loc
  ```
  qui sum afl_comb_`union'_locals if e(sample) == 1
  ```
- Line 784: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 786: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 787: loc
  ```
  local sheurostdev = string(r(sd),"%6.3fc")
  ```
- Line 800: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 801: name
  ```
  cap erase "$tables/`filename'_alt.`fmt'"
  ```
- Line 838: name
  ```
  name(share_deleg_bpl_eurodet, replace)
  ```
- Line 846: name
  ```
  name(share_deleg_anc, replace)
  ```
- Line 865: loc
  ```
  local groups eunw euse
  ```
- Line 868: loc
  ```
  local groups nat eunw euse
  ```
- Line 875: name
  ```
  rename *afl_del* *afl_all_del*
  ```
- Line 876: name
  ```
  rename *afl_comb_del* *afl_comb_all_del*
  ```
- Line 881: loc
  ```
  local n = 4
  ```
- Line 883: loc, name
  ```
  local filename = "share_deleg_`type'_fullsample"
  ```
- Line 886: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 889: loc
  ```
  foreach group of local groups {
  ```
- Line 891: loc
  ```
  local var = "afl_comb_`union'_del_sh_`type'_`group'"
  ```
- Line 897: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 898: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 900: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 902: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 903: loc
  ```
  local sheurostdev = string(r(sd),"%6.3fc")
  ```
- Line 913: loc
  ```
  local n = 4
  ```
- Line 915: loc, name
  ```
  local filename = "share_deleg_`type'_restrsample"
  ```
- Line 918: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 921: loc
  ```
  foreach group of local groups {
  ```
- Line 923: loc
  ```
  local var = "afl_comb_`union'_del_sh_`type'_`group'"
  ```
- Line 929: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 930: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 932: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 934: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 935: loc
  ```
  local sheurostdev = string(r(sd),"%6.3fc")
  ```
- Line 945: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 962: loc
  ```
  local junk : dir "$tables" files "`pat'"
  ```
- Line 963: loc
  ```
  foreach f of local junk {
  ```

**/replication-package/MS20241468_Deposit/code/2_analysis/2d_results_extra.do**

- Line 5: country
  ```
  * heterogeneity by origin-country traits (strength of the labor movement,
  ```
- Line 6: social
  ```
  * support for socialist parties); by the presence of other unions (KoL, IWW);
  ```
- Line 7: loc
  ```
  * and effects on local economic outcomes.
  ```
- Line 15: lon
  ```
  * Run via 00_master.do, or standalone.
  ```
- Line 22: loc
  ```
  * lets this file run on its own -- set it to the local path of the package.
  ```
- Line 41: loc
  ```
  local n = 4
  ```
- Line 53: loc, name
  ```
  local filename = "controlfunction"
  ```
- Line 54: loc
  ```
  local union = "all"
  ```
- Line 57: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 60: loc
  ```
  foreach outcome in pres ihsloc dens avgmemb {
  ```
- Line 62: loc
  ```
  local union = "all"
  ```
- Line 63: loc
  ```
  local var = "afl_comb_`union'_`outcome'"
  ```
- Line 69: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 71: loc
  ```
  if "`outcome'" == "ihsloc" {
  ```
- Line 72: loc
  ```
  qui sum afl_comb_`union'_locals if e(sample) == 1
  ```
- Line 74: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 76: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 77: loc
  ```
  local sheurostdev = string(r(sd),"%6.3fc")
  ```
- Line 87: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 93: country
  ```
  * Heterogeneity by strength of the labor movement in the origin country
  ```
- Line 94: country
  ```
  * Paper: Heterogeneous Effects by Strength of Labor Movement in Country of Origin (Table A.8); outpu
  ```
- Line 99: loc, name
  ```
  local filename = "het_unionseurope_`union'"
  ```
- Line 100: loc
  ```
  local n = 4
  ```
- Line 103: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 108: loc
  ```
  foreach outcome in pres ihsloc dens avgmemb {
  ```
- Line 110: loc
  ```
  local var = "afl_comb_`union'_`outcome'"
  ```
- Line 116: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 117: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 119: loc
  ```
  local partfstat1 = string(first[8,1],"%6.2fc")
  ```
- Line 120: loc
  ```
  local partfstat2 = string(first[8,2],"%6.2fc")
  ```
- Line 122: loc
  ```
  if "`outcome'" == "ihsloc" {
  ```
- Line 123: loc
  ```
  qui sum afl_comb_`union'_locals if e(sample) == 1
  ```
- Line 125: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 127: loc
  ```
  local sheuromean1 = string(r(mean),"%6.3fc")
  ```
- Line 129: loc
  ```
  local sheuromean2 = string(r(mean),"%6.3fc")
  ```
- Line 142: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 148: country, social
  ```
  * Heterogeneity by strength of socialist parties in the origin country
  ```
- Line 149: country, social
  ```
  * Paper: Heterogeneous Effects by Support for Socialist Parties in Country of Origin (Table A.9);
  ```
- Line 157: loc, name
  ```
  local filename = "het_socparteurope`q'_`union'"
  ```
- Line 158: loc
  ```
  local n = 4
  ```
- Line 161: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 166: loc
  ```
  foreach outcome in pres ihsloc dens avgmemb {
  ```
- Line 168: loc
  ```
  local var = "afl_comb_`union'_`outcome'"
  ```
- Line 175: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 176: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 178: loc
  ```
  local partfstat1 = string(first[8,1],"%6.2fc")
  ```
- Line 179: loc
  ```
  local partfstat2 = string(first[8,2],"%6.2fc")
  ```
- Line 181: loc
  ```
  if "`outcome'" == "ihsloc" {
  ```
- Line 182: loc
  ```
  qui sum afl_comb_`union'_locals if e(sample) == 1
  ```
- Line 184: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 186: loc
  ```
  local sheuromean1 = string(r(mean),"%6.3fc")
  ```
- Line 188: loc
  ```
  local sheuromean2 = string(r(mean),"%6.3fc")
  ```
- Line 190: social
  ```
  addtext(Outcome mean, "`depvarmean'", Imm. Share mean Socialist, "`sheuromean1'", ///
  ```
- Line 191: social
  ```
  Imm. Share mean Non-socialist, "`sheuromean2'", KP F-stat, "`fstat'", ///
  ```
- Line 201: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 215: loc
  ```
  local n = 4
  ```
- Line 217: loc, name
  ```
  local filename = "het_`unionhet'"
  ```
- Line 220: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 226: loc
  ```
  gen sheuro_IWW = sh_euro_wa_10yr_m * asinh(locals_IWW_0617)
  ```
- Line 227: loc
  ```
  gen pr1890sheuro_IWW = pr1890_sh_euro_wa_10yr_m * asinh(locals_IWW_0617)
  ```
- Line 230: loc
  ```
  gen sheuro_KOL = sh_euro_wa_10yr_m * asinh(locals_kol_1880)
  ```
- Line 231: loc
  ```
  gen pr1890sheuro_KOL = pr1890_sh_euro_wa_10yr_m * asinh(locals_kol_1880)
  ```
- Line 234: loc
  ```
  foreach outcome in pres ihsloc dens avgmemb {
  ```
- Line 236: loc
  ```
  local union = "all"
  ```
- Line 237: loc
  ```
  local var = "afl_comb_`union'_`outcome'"
  ```
- Line 244: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 245: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 247: loc
  ```
  local partfstat1 = string(first[8,1],"%6.2fc")
  ```
- Line 248: loc
  ```
  local partfstat2 = string(first[8,2],"%6.2fc")
  ```
- Line 250: loc
  ```
  if "`outcome'" == "ihsloc" {
  ```
- Line 251: loc
  ```
  qui sum afl_comb_`union'_locals if e(sample) == 1
  ```
- Line 254: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 256: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 271: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 277: loc
  ```
  * Effects on local economic outcomes
  ```
- Line 278: loc
  ```
  * Paper: Effect on Local Economic Outcomes (Table A.11); output economic_outcomes
  ```
- Line 281: loc
  ```
  local n = 4
  ```
- Line 283: loc, name
  ```
  local filename = "economic_outcomes"
  ```
- Line 286: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 304: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 305: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 310: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 312: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 313: loc
  ```
  local sheurostdev = string(r(sd),"%6.3fc")
  ```
- Line 325: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 331: loc
  ```
  local junk : dir "$tables" files "`pat'"
  ```
- Line 332: loc
  ```
  foreach f of local junk {
  ```

**/replication-package/MS20241468_Deposit/code/2_analysis/2e_results_robustness.do**

- Line 16: lon
  ```
  * Run via 00_master.do, or standalone.
  ```
- Line 23: loc
  ```
  * lets this file run on its own -- set it to the local path of the package.
  ```
- Line 45: country
  ```
  *        outputs rob_pretrends_euro and rob_pretrends_<country>
  ```
- Line 55: loc
  ```
  gen kol_d_1880 = (locals_kol_1880 > 0) if locals_kol_1880 != .
  ```
- Line 56: loc
  ```
  gen kol_d_1890 = (locals_kol_1890 > 0) if locals_kol_1890 != .
  ```
- Line 57: loc
  ```
  gen kol_d = (locals_kol > 0) if locals_kol != .
  ```
- Line 58: loc
  ```
  foreach var in kol_d locals_kol ihs_locals_kol ihs_locals_kol_perpop locals_kol_perpop locals_kol_pe
  ```
- Line 80: loc, name
  ```
  local filename = "rob_pretrends_`c'"
  ```
- Line 82: name
  ```
  cap erase "$tables/`filename'`fmt'"
  ```
- Line 83: name
  ```
  cap erase "$tables/`filename'_1880imm.`fmt'"
  ```
- Line 88: loc
  ```
  foreach var in d8090_kol_d d8090_ihs_locals_kol ///
  ```
- Line 97: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 104: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 105: name
  ```
  cap erase "$tables/`filename'_1880imm.`fmt'"
  ```
- Line 117: loc
  ```
  foreach outcome in pres ihsloc dens avgmemb {
  ```
- Line 119: loc
  ```
  local n = 4
  ```
- Line 121: loc
  ```
  local var = "afl_comb_all_`outcome'"
  ```
- Line 131: country
  ```
  foreach country in aus_hung belgium czech denmark ///
  ```
- Line 138: country
  ```
  a("${idfe} ${tfe} ${controls`n'}" year#c.sh_`country'_mw_1890) cluster("${idfe}")
  ```
- Line 140: country
  ```
  est store sh_`country'_`outcome'
  ```
- Line 150: loc
  ```
  foreach outcome in pres ihsloc dens avgmemb {
  ```
- Line 152: loc, name
  ```
  local filename = "initstock_`outcome'"
  ```
- Line 155: loc
  ```
  local graphtitle = "Any Union Present"
  ```
- Line 156: loc
  ```
  local gap = 1
  ```
- Line 157: loc
  ```
  local resc = ""
  ```
- Line 158: loc
  ```
  local resclab = ""
  ```
- Line 159: loc
  ```
  local extraoptions = ""
  ```
- Line 161: loc
  ```
  if "`outcome'" == "ihsloc" {
  ```
- Line 162: loc
  ```
  local graphtitle = "Number of Union Branches"
  ```
- Line 163: loc
  ```
  local gap = 1
  ```
- Line 164: loc
  ```
  local resc = ""
  ```
- Line 165: loc
  ```
  local resclab = ""
  ```
- Line 166: loc
  ```
  local extraoptions = ""
  ```
- Line 169: loc
  ```
  local graphtitle = "Union Density (Members / Labor Force)"
  ```
- Line 170: loc
  ```
  local gap = 1
  ```
- Line 171: loc
  ```
  local resc = ""
  ```
- Line 172: loc
  ```
  local resclab = ""
  ```
- Line 173: loc
  ```
  local extraoptions = ""
  ```
- Line 176: loc
  ```
  local graphtitle = "Union Members per Branch"
  ```
- Line 177: loc
  ```
  local gap = 1
  ```
- Line 178: loc
  ```
  local resc = ""
  ```
- Line 179: loc
  ```
  local resclab = ""
  ```
- Line 180: loc
  ```
  local extraoptions = "xlabel(0(200)1200) xscale(range(-50 1200))"
  ```
- Line 188: name
  ```
  aseq swapnames ///
  ```
- Line 194: name
  ```
  keep(sh_euro_wa_10yr_m) title(`graphtitle', size(small)) name(`filename', replace) ///
  ```
- Line 196: name
  ```
  eqrename(baseline_`outcome' = "Baseline" ///
  ```
- Line 219: loc
  ```
  graph combine initstock_pres initstock_ihsloc initstock_dens initstock_avgmemb, graphregion(color(wh
  ```
- Line 232: loc
  ```
  foreach outcome in pres ihsloc dens avgmemb  {
  ```
- Line 234: loc, name
  ```
  local filename = "rob_controls_`outcome'"
  ```
- Line 235: loc
  ```
  local n = 4
  ```
- Line 238: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 244: loc
  ```
  gen afloccs_share_m_1880 = all_lf_afloccs_m_1880 / all_lf_tot_m_1880
  ```
- Line 247: loc
  ```
  local robcontrols " "year#c.urban_share_mw_1890" "year#c.log_popdens_mw_1890" "year#c.imm_share_mw_1
  ```
- Line 249: loc
  ```
  local var = "afl_comb_all_`outcome'"
  ```
- Line 256: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 257: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 259: loc
  ```
  if "`var'" == "afl_comb_all_ihsloc" {
  ```
- Line 260: loc
  ```
  qui sum afl_comb_all_locals if e(sample) == 1
  ```
- Line 262: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 264: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 265: loc
  ```
  local sheurostdev = string(r(sd),"%6.3fc")
  ```
- Line 267: loc
  ```
  local i = 0
  ```
- Line 268: loc
  ```
  foreach robcontrol of local robcontrols {
  ```
- Line 270: loc
  ```
  local i = `i' + 1
  ```
- Line 271: loc
  ```
  local n = 4
  ```
- Line 278: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 279: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 281: loc
  ```
  if "`var'" == "afl_comb_all_ihsloc" {
  ```
- Line 282: loc
  ```
  qui sum afl_comb_all_locals if e(sample) == 1
  ```
- Line 284: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 286: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 287: loc
  ```
  local sheurostdev = string(r(sd),"%6.3fc")
  ```
- Line 295: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 299: loc
  ```
  foreach outcome in pres ihsloc dens avgmemb {
  ```
- Line 302: loc
  ```
  local graphtitle = "Any Union Present"
  ```
- Line 303: loc
  ```
  local gap = 1
  ```
- Line 304: loc
  ```
  local resc = ""
  ```
- Line 305: loc
  ```
  local resclab = ""
  ```
- Line 306: loc
  ```
  local extraoptions = ""
  ```
- Line 308: loc
  ```
  if "`outcome'" == "ihsloc" {
  ```
- Line 309: loc
  ```
  local graphtitle = "Number of Union Branches"
  ```
- Line 310: loc
  ```
  local gap = 1
  ```
- Line 311: loc
  ```
  local resc = ""
  ```
- Line 312: loc
  ```
  local resclab = ""
  ```
- Line 313: loc
  ```
  local extraoptions = ""
  ```
- Line 316: loc
  ```
  local graphtitle = "Union Density (Members / Labor Force)"
  ```
- Line 317: loc
  ```
  local gap = 1
  ```
- Line 318: loc
  ```
  local resc = ""
  ```
- Line 319: loc
  ```
  local resclab = ""
  ```
- Line 320: loc
  ```
  local extraoptions = ""
  ```
- Line 323: loc
  ```
  local graphtitle = "Union Members per Branch"
  ```
- Line 324: loc
  ```
  local gap = 1
  ```
- Line 325: loc
  ```
  local resc = ""
  ```
- Line 326: loc
  ```
  local resclab = ""
  ```
- Line 327: loc
  ```
  local extraoptions = "xlabel(0(200)1200) xscale(range(-50 1200))"
  ```
- Line 338: name
  ```
  drop (_cons) title("`graphtitle'", size(small)) name(`outcome'_robcontrols, replace) ///
  ```
- Line 340: name
  ```
  asequation swapnames grid(none) ///
  ```
- Line 342: name
  ```
  eqrename(baseline_`outcome' = "Baseline" ///
  ```
- Line 360: loc
  ```
  graph combine pres_robcontrols ihsloc_robcontrols dens_robcontrols avgmemb_robcontrols, graphregion(
  ```
- Line 372: loc
  ```
  foreach outcome in pres ihsloc dens avgmemb  {
  ```
- Line 374: loc, name
  ```
  local filename = "rob_altbasespec_`outcome'"
  ```
- Line 377: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 380: loc
  ```
  local var = "afl_comb_all_`outcome'"
  ```
- Line 394: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 395: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 397: loc
  ```
  if "`var'" == "afl_comb_all_ihsloc" {
  ```
- Line 398: loc
  ```
  qui sum afl_comb_all_locals if e(sample) == 1
  ```
- Line 400: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 402: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 403: loc
  ```
  local sheurostdev = string(r(sd),"%6.3fc")
  ```
- Line 420: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 421: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 423: loc
  ```
  if "`var'" == "afl_comb_all_ihsloc" {
  ```
- Line 424: loc
  ```
  qui sum afl_comb_all_locals if e(sample) == 1
  ```
- Line 426: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 428: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 429: loc
  ```
  local sheurostdev = string(r(sd),"%6.3fc")
  ```
- Line 434: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 446: loc, name
  ```
  local filename = "rob_outliers_depvar"
  ```
- Line 451: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 454: loc
  ```
  foreach outcome in ihsloc dens avgmemb {
  ```
- Line 455: loc
  ```
  local var = "afl_comb_all_`outcome'"
  ```
- Line 460: loc
  ```
  foreach outcome in pres ihsloc dens avgmemb {
  ```
- Line 462: loc
  ```
  local var = "afl_comb_all_`outcome'"
  ```
- Line 464: loc
  ```
  local n = 4
  ```
- Line 472: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 473: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 475: loc
  ```
  if "`var'" == "afl_comb_all_ihsloc" {
  ```
- Line 476: loc
  ```
  qui sum afl_comb_all_locals if e(sample) == 1
  ```
- Line 478: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 480: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 481: loc
  ```
  local sheurostdev = string(r(sd),"%6.3fc")
  ```
- Line 486: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 497: loc, name
  ```
  local filename = "rob_outliers_immshare"
  ```
- Line 504: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 507: loc
  ```
  foreach outcome in pres ihsloc dens avgmemb {
  ```
- Line 509: loc
  ```
  local var = "afl_comb_all_`outcome'"
  ```
- Line 510: loc
  ```
  local n = 4
  ```
- Line 519: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 520: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 522: loc
  ```
  if "`var'" == "afl_comb_all_ihsloc" {
  ```
- Line 523: loc
  ```
  qui sum afl_comb_all_locals if e(sample) == 1
  ```
- Line 525: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 527: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 528: loc
  ```
  local sheurostdev = string(r(sd),"%6.3fc")
  ```
- Line 533: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 545: loc, name
  ```
  local filename = "rob_clustersea"
  ```
- Line 548: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 551: loc
  ```
  foreach outcome in pres ihsloc dens avgmemb {
  ```
- Line 553: loc
  ```
  local var = "afl_comb_all_`outcome'"
  ```
- Line 554: loc
  ```
  local n = 4
  ```
- Line 562: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 563: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 565: loc
  ```
  if "`var'" == "afl_comb_all_ihsloc" {
  ```
- Line 566: loc
  ```
  qui sum afl_comb_all_locals if e(sample) == 1
  ```
- Line 568: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 570: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 571: loc
  ```
  local sheurostdev = string(r(sd),"%6.3fc")
  ```
- Line 577: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 582: lat
  ```
  * Account for spatial correlation (Conley 1999)
  ```
- Line 600: loc, name
  ```
  local filename = "rob_conley`dist'km"
  ```
- Line 601: loc
  ```
  local n = 4
  ```
- Line 604: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 607: loc
  ```
  foreach outcome in pres ihsloc dens avgmemb {
  ```
- Line 609: loc
  ```
  local var = "afl_comb_all_`outcome'"
  ```
- Line 615: lat, lon
  ```
  spatial latitude(centroid_y) longitude(centroid_x) hac dist(`dist') lag(0) dropsingletons
  ```
- Line 619: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 620: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 622: loc
  ```
  if "`var'" == "afl_comb_all_ihsloc" {
  ```
- Line 623: loc
  ```
  qui sum afl_comb_all_locals if e(sample) == 1
  ```
- Line 625: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 627: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 628: loc
  ```
  local sheurostdev = string(r(sd),"%6.3fc")
  ```
- Line 634: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 648: loc, name
  ```
  local filename = "rob_adaose"
  ```
- Line 649: loc
  ```
  local n = 4
  ```
- Line 652: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 655: loc
  ```
  foreach outcome in pres ihsloc dens avgmemb {
  ```
- Line 687: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 703: loc, name
  ```
  local filename = "rob_urbruralsample"
  ```
- Line 706: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 709: loc
  ```
  foreach outcome in pres ihsloc dens avgmemb {
  ```
- Line 711: loc
  ```
  local var = "afl_comb_all_`outcome'"
  ```
- Line 712: loc
  ```
  local n = 4
  ```
- Line 720: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 721: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 723: loc
  ```
  if "`var'" == "afl_comb_all_ihsloc" {
  ```
- Line 724: loc
  ```
  qui sum afl_comb_all_locals if e(sample) == 1
  ```
- Line 726: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 728: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 729: loc
  ```
  local sheurostdev = string(r(sd),"%6.3fc")
  ```
- Line 735: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 744: loc, name
  ```
  local filename = "rob_unbalanced"
  ```
- Line 747: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 750: loc
  ```
  foreach outcome in pres ihsloc dens avgmemb {
  ```
- Line 752: loc
  ```
  local var = "afl_comb_all_`outcome'"
  ```
- Line 753: loc
  ```
  local n = 4
  ```
- Line 761: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 762: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 764: loc
  ```
  if "`var'" == "afl_comb_all_ihsloc" {
  ```
- Line 765: loc
  ```
  qui sum afl_comb_all_locals if e(sample) == 1
  ```
- Line 767: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 769: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 770: loc
  ```
  local sheurostdev = string(r(sd),"%6.3fc")
  ```
- Line 776: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 785: loc, name
  ```
  local filename = "rob_urbruralsample_unbalanced"
  ```
- Line 788: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 791: loc
  ```
  foreach outcome in pres ihsloc dens avgmemb {
  ```
- Line 793: loc
  ```
  local var = "afl_comb_all_`outcome'"
  ```
- Line 794: loc
  ```
  local n = 4
  ```
- Line 802: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 803: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 805: loc
  ```
  if "`var'" == "afl_comb_all_ihsloc" {
  ```
- Line 806: loc
  ```
  qui sum afl_comb_all_locals if e(sample) == 1
  ```
- Line 808: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 810: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 811: loc
  ```
  local sheurostdev = string(r(sd),"%6.3fc")
  ```
- Line 817: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 826: loc, name
  ```
  local filename = "rob_nosouth"
  ```
- Line 829: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 832: loc
  ```
  foreach outcome in pres ihsloc dens avgmemb {
  ```
- Line 834: loc
  ```
  local var = "afl_comb_all_`outcome'"
  ```
- Line 835: loc
  ```
  local n = 4
  ```
- Line 843: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 844: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 846: loc
  ```
  if "`var'" == "afl_comb_all_ihsloc" {
  ```
- Line 847: loc
  ```
  qui sum afl_comb_all_locals if e(sample) == 1
  ```
- Line 849: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 851: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 852: loc
  ```
  local sheurostdev = string(r(sd),"%6.3fc")
  ```
- Line 858: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 869: loc, name
  ```
  local filename = "rob_sealevel"
  ```
- Line 872: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 884: loc
  ```
  collapse (sum) afl_comb_memb_all afl_comb_all_locals ///
  ```
- Line 894: loc
  ```
  gen afl_comb_all_avgmemb 		= afl_comb_memb_all / afl_comb_all_locals if afl_comb_all_dens != .
  ```
- Line 897: loc
  ```
  winsor2 afl_comb_all_locals afl_comb_all_dens afl_comb_all_avgmemb, replace cuts(1 99)
  ```
- Line 898: loc
  ```
  gen afl_comb_all_ihsloc			= log(1 + afl_comb_all_locals)
  ```
- Line 909: loc
  ```
  foreach outcome in pres ihsloc dens avgmemb {
  ```
- Line 911: loc
  ```
  local var = "afl_comb_all_`outcome'"
  ```
- Line 912: loc
  ```
  local n = 4
  ```
- Line 920: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 921: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 923: loc
  ```
  if "`var'" == "afl_comb_all_ihsloc" {
  ```
- Line 924: loc
  ```
  qui sum afl_comb_all_locals if e(sample) == 1
  ```
- Line 926: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 928: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 929: loc
  ```
  local sheurostdev = string(r(sd),"%6.3fc")
  ```
- Line 937: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 947: loc, name
  ```
  local filename = "rob_onlyafldata"
  ```
- Line 950: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 953: loc
  ```
  foreach outcome in pres ihsloc dens avgmemb {
  ```
- Line 955: loc
  ```
  local var = "afl_all_`outcome'"
  ```
- Line 956: loc
  ```
  local n = 4
  ```
- Line 964: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 965: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 967: loc
  ```
  if "`var'" == "afl_comb_all_ihsloc" {
  ```
- Line 968: loc
  ```
  qui sum afl_comb_all_locals if e(sample) == 1
  ```
- Line 970: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 972: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 973: loc
  ```
  local sheurostdev = string(r(sd),"%6.3fc")
  ```
- Line 978: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 991: loc
  ```
  local sortingvar3 = "mfglabor_share_mw_`year'"
  ```
- Line 992: loc
  ```
  local sortingvar4 = "farm_share_mw_`year'"
  ```
- Line 993: loc
  ```
  local sortingvar5 = "mining_`year'"
  ```
- Line 997: loc
  ```
  local sortingvar3 = "mfglabor_share_mw_`year'"
  ```
- Line 998: loc
  ```
  local sortingvar4 = "farmfams_share_`year'"
  ```
- Line 999: loc
  ```
  local sortingvar5 = "mining_`year'"
  ```
- Line 1003: loc
  ```
  *Match on 1890 presence of KOL locals
  ```
- Line 1019: loc
  ```
  locals_kol_1880 locals_kol_perpop_1880 locals_kol_perurbpop_1880  ///
  ```
- Line 1020: loc
  ```
  locals_kol_1890 locals_kol_perpop_1890 locals_kol_perurbpop_1890 all_totpop_m_1890 ///
  ```
- Line 1027: loc
  ```
  local sortingvar1 = "locals_kol_perpop_`year'"
  ```
- Line 1028: loc
  ```
  local sortingvar2 = "locals_kol_`year'"
  ```
- Line 1048: loc
  ```
  local N=r(max)
  ```
- Line 1069: loc
  ```
  local n = 1
  ```
- Line 1073: loc, name
  ```
  local filename = "rob_`match'`year'"
  ```
- Line 1076: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 1077: name
  ```
  cap erase "$tables/`filename'_baseline.`fmt'"
  ```
- Line 1080: loc
  ```
  foreach outcome in pres ihsloc dens avgmemb {
  ```
- Line 1082: loc
  ```
  local var = "afl_comb_all_`outcome'"
  ```
- Line 1091: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 1092: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 1094: loc
  ```
  if "`var'" == "afl_comb_all_ihsloc" {
  ```
- Line 1095: loc
  ```
  qui sum afl_comb_all_locals if e(sample) == 1
  ```
- Line 1097: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 1099: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 1100: loc
  ```
  local sheurostdev = string(r(sd),"%6.3fc")
  ```
- Line 1108: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 1109: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 1111: loc
  ```
  if "`var'" == "afl_comb_all_ihsloc" {
  ```
- Line 1112: loc
  ```
  qui sum afl_comb_all_locals if e(sample) == 1
  ```
- Line 1114: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 1116: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 1117: loc
  ```
  local sheurostdev = string(r(sd),"%6.3fc")
  ```
- Line 1126: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 1127: name
  ```
  cap erase "$tables/`filename'_baseline.`fmt'"
  ```
- Line 1145: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 1151: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 1153: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 1155: loc
  ```
  local indepvarmean = string(r(mean),"%6.3fc")
  ```
- Line 1156: loc
  ```
  local indepvarstdev = string(r(sd),"%6.3fc")
  ```
- Line 1171: loc, name
  ```
  local filename = "rob_weathershocks"
  ```
- Line 1172: loc
  ```
  local n = 4
  ```
- Line 1175: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 1178: loc
  ```
  foreach outcome in pres ihsloc dens avgmemb {
  ```
- Line 1182: loc
  ```
  local var = "afl_comb_`union'_`outcome'"
  ```
- Line 1190: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 1191: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 1193: loc
  ```
  if "`outcome'" == "ihsloc" {
  ```
- Line 1194: loc
  ```
  qui sum afl_comb_`union'_locals if e(sample) == 1
  ```
- Line 1196: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 1198: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 1199: loc
  ```
  local sheurostdev = string(r(sd),"%6.3fc")
  ```
- Line 1207: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 1215: loc, name
  ```
  local filename = "rob_euroimmdef"
  ```
- Line 1216: loc
  ```
  local n = 4
  ```
- Line 1220: name
  ```
  cap erase "$tables/`filename'`k'.`fmt'"
  ```
- Line 1223: loc
  ```
  foreach outcome in pres ihsloc dens avgmemb {
  ```
- Line 1225: loc
  ```
  local union = "all"
  ```
- Line 1226: loc
  ```
  local var = "afl_comb_`union'_`outcome'"
  ```
- Line 1240: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 1241: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 1243: loc
  ```
  if "`outcome'" == "ihsloc" {
  ```
- Line 1244: loc
  ```
  qui sum afl_comb_`union'_locals if e(sample) == 1
  ```
- Line 1246: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 1248: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 1249: loc
  ```
  local sheurostdev = string(r(sd),"%6.3fc")
  ```
- Line 1265: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 1266: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 1268: loc
  ```
  if "`outcome'" == "ihsloc" {
  ```
- Line 1269: loc
  ```
  qui sum afl_comb_`union'_locals if e(sample) == 1
  ```
- Line 1271: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 1273: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 1274: loc
  ```
  local sheurostdev = string(r(sd),"%6.3fc")
  ```
- Line 1290: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 1291: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 1293: loc
  ```
  if "`outcome'" == "ihsloc" {
  ```
- Line 1294: loc
  ```
  qui sum afl_comb_`union'_locals if e(sample) == 1
  ```
- Line 1296: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 1298: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 1299: loc
  ```
  local sheurostdev = string(r(sd),"%6.3fc")
  ```
- Line 1315: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 1316: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 1318: loc
  ```
  if "`outcome'" == "ihsloc" {
  ```
- Line 1319: loc
  ```
  qui sum afl_comb_`union'_locals if e(sample) == 1
  ```
- Line 1321: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 1323: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 1324: loc
  ```
  local sheurostdev = string(r(sd),"%6.3fc")
  ```
- Line 1332: name
  ```
  cap erase "$tables/`filename'`k'.`fmt'"
  ```
- Line 1339: lat
  ```
  * Interpolated observations
  ```
- Line 1341: loc, name
  ```
  local filename = "rob_interp"
  ```
- Line 1342: loc
  ```
  local n = 4
  ```
- Line 1346: name
  ```
  cap erase "$tables/`filename'`k'.`fmt'"
  ```
- Line 1351: loc
  ```
  foreach outcome in pres ihsloc dens avgmemb {
  ```
- Line 1353: loc
  ```
  local union = "all"
  ```
- Line 1354: loc
  ```
  local var = "afl_comb_`union'_`outcome'"
  ```
- Line 1362: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 1363: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 1365: loc
  ```
  if "`outcome'" == "ihsloc" {
  ```
- Line 1366: loc
  ```
  qui sum afl_comb_`union'_locals if e(sample) == 1
  ```
- Line 1368: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 1370: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 1371: loc
  ```
  local sheurostdev = string(r(sd),"%6.3fc")
  ```
- Line 1380: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 1381: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 1383: loc
  ```
  if "`outcome'" == "ihsloc" {
  ```
- Line 1384: loc
  ```
  qui sum afl_comb_`union'_locals if e(sample) == 1
  ```
- Line 1386: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 1388: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 1389: loc
  ```
  local sheurostdev = string(r(sd),"%6.3fc")
  ```
- Line 1395: name
  ```
  cap erase "$tables/`filename'`k'.`fmt'"
  ```
- Line 1401: lat
  ```
  *Also, no correlation between immigration and missing union data
  ```
- Line 1412: loc, name
  ```
  local filename = "rob_altdefuniondens"
  ```
- Line 1413: loc
  ```
  local n = 4
  ```
- Line 1416: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 1421: loc
  ```
  local union = "all"
  ```
- Line 1422: loc
  ```
  local var = "afl_comb_`union'_`outcome'"
  ```
- Line 1430: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 1431: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 1433: loc
  ```
  if "`outcome'" == "ihsloc" {
  ```
- Line 1434: loc
  ```
  qui sum afl_comb_`union'_locals if e(sample) == 1
  ```
- Line 1436: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 1438: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 1439: loc
  ```
  local sheurostdev = string(r(sd),"%6.3fc")
  ```
- Line 1445: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 1453: loc, name
  ```
  local filename = "rob_no1920"
  ```
- Line 1454: loc
  ```
  local n = 4
  ```
- Line 1457: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 1460: loc
  ```
  foreach outcome in pres ihsloc dens avgmemb {
  ```
- Line 1462: loc
  ```
  local union = "all"
  ```
- Line 1463: loc
  ```
  local var = "afl_comb_`union'_`outcome'"
  ```
- Line 1471: loc
  ```
  local obs = string(e(N),"%15.0f")
  ```
- Line 1472: loc
  ```
  local fstat = string(`e(widstat)',"%6.2fc")
  ```
- Line 1474: loc
  ```
  if "`outcome'" == "ihsloc" {
  ```
- Line 1475: loc
  ```
  qui sum afl_comb_`union'_locals if e(sample) == 1
  ```
- Line 1477: loc
  ```
  local depvarmean = string(r(mean),"%6.3fc")
  ```
- Line 1479: loc
  ```
  local sheuromean = string(r(mean),"%6.3fc")
  ```
- Line 1480: loc
  ```
  local sheurostdev = string(r(sd),"%6.3fc")
  ```
- Line 1486: name
  ```
  cap erase "$tables/`filename'.`fmt'"
  ```
- Line 1497: loc
  ```
  foreach outcome in pres ihsloc dens avgmemb {
  ```
- Line 1499: loc
  ```
  local var = "afl_comb_all_`outcome'"
  ```
- Line 1500: loc
  ```
  local n = 4
  ```
- Line 1520: loc
  ```
  local z = 1.96
  ```
- Line 1528: name
  ```
  matrix rownames tF_se_`outcome' = b ll ul
  ```
- Line 1529: lname, name
  ```
  matrix colnames tF_se_`outcome' = `: colnames b_`outcome''
  ```
- Line 1539: loc
  ```
  foreach outcome in pres ihsloc dens avgmemb {
  ```
- Line 1541: loc
  ```
  local var = "afl_comb_all_`outcome'"
  ```
- Line 1542: loc
  ```
  local n = 4
  ```
- Line 1556: loc
  ```
  foreach outcome in pres ihsloc dens avgmemb {
  ```
- Line 1559: loc
  ```
  local graphtitle = "Any Union Present"
  ```
- Line 1560: loc
  ```
  local gap = 1
  ```
- Line 1561: loc
  ```
  local resc = ""
  ```
- Line 1562: loc
  ```
  local resclab = ""
  ```
- Line 1563: loc
  ```
  local extraoptions = ""
  ```
- Line 1565: loc
  ```
  if "`outcome'" == "ihsloc" {
  ```
- Line 1566: loc
  ```
  local graphtitle = "Number of Union Branches"
  ```
- Line 1567: loc
  ```
  local gap = 1
  ```
- Line 1568: loc
  ```
  local resc = ""
  ```
- Line 1569: loc
  ```
  local resclab = ""
  ```
- Line 1570: loc
  ```
  local extraoptions = ""
  ```
- Line 1573: loc
  ```
  local graphtitle = "Union Density (Members / LF)"
  ```
- Line 1574: loc
  ```
  local gap = 1
  ```
- Line 1575: loc
  ```
  local resc = ""
  ```
- Line 1576: loc
  ```
  local resclab = ""
  ```
- Line 1577: loc
  ```
  local extraoptions = ""
  ```
- Line 1580: loc
  ```
  local graphtitle = "Union Members per Branch"
  ```
- Line 1581: loc
  ```
  local gap = 1
  ```
- Line 1582: loc
  ```
  local resc = ""
  ```
- Line 1583: loc
  ```
  local resclab = ""
  ```
- Line 1584: loc
  ```
  local extraoptions = ""
  ```
- Line 1610: name
  ```
  drop (_cons) title("`graphtitle'", size(small)) name(`outcome'_robsummary, replace) ///
  ```
- Line 1612: name
  ```
  asequation swapnames grid(none) keep(sh_euro_wa_10yr_m) ///
  ```
- Line 1614: name
  ```
  eqrename(baseline_`outcome' = "Baseline" ///
  ```
- Line 1635: lat
  ```
  robinterp1_`outcome' = `"Drop interpolated data    – 21"'
  ```
- Line 1642: loc
  ```
  graph combine pres_robsummary ihsloc_robsummary dens_robsummary avgmemb_robsummary, graphregion(colo
  ```
- Line 1652: loc
  ```
  local junk : dir "$tables" files "`pat'"
  ```
- Line 1653: loc
  ```
  foreach f of local junk {
  ```

**/replication-package/MS20241468_Deposit/code/2_analysis/2f_rotemberg_weights.do**

- Line 18: lon
  ```
  * Run via 00_master.do, or standalone.
  ```
- Line 25: loc
  ```
  * lets this file run on its own -- set it to the local path of the package.
  ```
- Line 47: loc
  ```
  local controls mfglabor_share_mw_1890 farmfams_share_1890 mining_1890
  ```
- Line 49: loc
  ```
  local y afl_comb_all_pres
  ```
- Line 50: loc
  ```
  local x sh_euro_wa_10yr_m
  ```
- Line 52: loc
  ```
  local ind_vars sh_denmark_mw_1890 sh_norway_mw_1890 sh_sweden_mw_1890 sh_uk_mw_1890 sh_ireland_mw_18
  ```
- Line 54: loc
  ```
  local time_var year
  ```
- Line 55: loc
  ```
  local id_var countynhg_1930
  ```
- Line 57: loc
  ```
  foreach var of local ind_vars {
  ```
- Line 61: loc
  ```
  levelsof `time_var', local(years)
  ```
- Line 63: name
  ```
  rename *_lvout *_lvo
  ```
- Line 64: loc
  ```
  local growth_vars denmark_US_wa_10yr_m_lvo norway_US_wa_10yr_m_lvo sweden_US_wa_10yr_m_lvo uk_US_wa_
  ```
- Line 66: loc
  ```
  foreach year of local years {
  ```
- Line 67: loc
  ```
  foreach ind_var of local ind_vars {
  ```
- Line 70: loc
  ```
  foreach var of local growth_vars {
  ```
- Line 76: loc
  ```
  foreach var of local controls {
  ```
- Line 83: loc
  ```
  local controls t*_mfglabor_share_mw_1890 t*_farmfams_share_1890 t*_mining_1890 year_2 year_3
  ```
- Line 90: loc
  ```
  local pi_`ind' = _b[`temp']
  ```
- Line 92: loc
  ```
  local F_`ind' = string(r(F), "%9.3f")
  ```
- Line 94: loc
  ```
  local gamma_`ind' = _b[`temp']
  ```
- Line 96: loc
  ```
  local beta_`ind' = string(_b[`x'], "%9.3f")
  ```
- Line 106: loc
  ```
  local ci_min_`ind' = string( r(beta_min), "%9.3f")
  ```
- Line 107: loc
  ```
  local ci_max_`ind' = string( r(beta_max), "%9.3f")
  ```
- Line 115: lon
  ```
  reshape long sh_, i(`id_var' `time_var') j(ind) string
  ```
- Line 131: loc
  ```
  local varlist = r(varlist)
  ```
- Line 142: loc
  ```
  local t = 1
  ```
- Line 148: loc
  ```
  local t = `t' + 1
  ```
- Line 151: lat
  ```
  * Calculate Panel C: Variation across years in alpha
  ```
- Line 154: loc
  ```
  local sum_1900_alpha = string(b[1,1], "%9.3f")
  ```
- Line 157: loc
  ```
  local sum_1910_alpha = string(b[1,1], "%9.3f")
  ```
- Line 160: loc
  ```
  local sum_1920_alpha = string(b[1,1], "%9.3f")
  ```
- Line 163: loc
  ```
  local mean_1900_alpha = string(r(mean), "%9.3f")
  ```
- Line 165: loc
  ```
  local mean_1910_alpha = string(r(mean), "%9.3f")
  ```
- Line 167: loc
  ```
  local mean_1920_alpha = string(r(mean), "%9.3f")
  ```
- Line 182: name
  ```
  gen ind_name = proper(ind)
  ```
- Line 183: name
  ```
  replace ind_name = "Austria-Hungary" if ind_name == "Aus_Hung"
  ```
- Line 184: name
  ```
  replace ind_name = "Czechoslovakia" if ind_name == "Czech"
  ```
- Line 185: name
  ```
  replace ind_name = "Greece-Portugal-Spain" if ind_name == "Gr_Pt_Es"
  ```
- Line 186: name
  ```
  replace ind_name = "Luxembourg" if ind_name == "Luxemb"
  ```
- Line 187: name
  ```
  replace ind_name = "Netherlands" if ind_name == "Nether"
  ```
- Line 188: name
  ```
  replace ind_name = "Switzerland" if ind_name == "Switz"
  ```
- Line 189: name
  ```
  replace ind_name = "United Kingdom" if ind_name == "Uk"
  ```
- Line 204: loc
  ```
  local sum_pos_alpha = string(b[1,1], "%9.3f")
  ```
- Line 207: loc
  ```
  local sum_neg_alpha = string(b[1,1], "%9.3f")
  ```
- Line 210: loc
  ```
  local mean_pos_alpha = string(r(mean), "%9.3f")
  ```
- Line 212: loc
  ```
  local mean_neg_alpha = string(r(mean), "%9.3f")
  ```
- Line 214: loc
  ```
  local share_pos_alpha = string(abs(`sum_pos_alpha')/(abs(`sum_pos_alpha') + abs(`sum_neg_alpha')), "
  ```
- Line 215: loc
  ```
  local share_neg_alpha = string(abs(`sum_neg_alpha')/(abs(`sum_pos_alpha') + abs(`sum_neg_alpha')), "
  ```
- Line 217: lat
  ```
  * Panel B: Correlations of Industry Aggregates
  ```
- Line 221: loc
  ```
  levelsof ind, local(industries)
  ```
- Line 231: loc
  ```
  local c_`i'_`j' = string(corr[`i',`j'], "%9.3f")
  ```
- Line 238: loc
  ```
  local alpha_`ind' = string(r(mean), "%9.3f")
  ```
- Line 240: loc
  ```
  local g_`ind' = string(r(mean), "%9.3f")
  ```
- Line 242: loc
  ```
  local beta_`ind' = string(r(mean), "%9.3f")
  ```
- Line 244: loc
  ```
  local share_`ind' = string(r(mean)*100, "%9.3f")
  ```
- Line 248: loc, name
  ```
  local ind_name_`ind' = ind_name[1]
  ```
- Line 259: loc
  ```
  local b = b[1,1]
  ```
- Line 268: name
  ```
  twoway (scatter agg_beta_pos agg_beta_neg F if F >= 5 [aweight=abs_alpha ], msymbol(Oh Dh)), legend(
  ```
- Line 271: name
  ```
  twoway (scatter F alpha1 if _n <= 5, mcolor(dblue) mlabel(ind_name) mlabposition(12) msize(0.5) mlab
  ```
- Line 284: loc
  ```
  local agg_beta_pos = string(agg_beta_weight[1], "%9.3f")
  ```
- Line 285: loc
  ```
  local agg_beta_neg = string(agg_beta_weight[2], "%9.3f")
  ```
- Line 286: loc
  ```
  local agg_beta_pos2 = string(agg_beta[1], "%9.3f")
  ```
- Line 287: loc
  ```
  local agg_beta_neg2 = string(agg_beta[2], "%9.3f")
  ```
- Line 288: loc
  ```
  local agg_beta_pos_share = string(share[1], "%9.3f")
  ```
- Line 289: loc
  ```
  local agg_beta_neg_share = string(share[2], "%9.3f")
  ```
- Line 299: lat
  ```
  file write fh "\multicolumn{5}{l}{\textbf{Panel B: Correlations} }\\" _n
  ```
- Line 314: name
  ```
  file write fh  "`ind_name_`ind'' & `alpha_`ind'' & `g_`ind'' & `beta_`ind'' & (`ci_min_`ind'',`ci_ma
  ```
- Line 317: name
  ```
  file write fh  "`ind_name_`ind'' & `alpha_`ind'' & `g_`ind'' & `beta_`ind'' & \multicolumn{1}{c}{N/A
  ```
- Line 330: loc
  ```
  local junk : dir "$tables" files "`pat'"
  ```
- Line 331: loc
  ```
  foreach f of local junk {
  ```

**/replication-package/MS20241468_Deposit/code/ado/bartik_weight.ado**

- Line 3: name
  ```
  syntax [if] [in], z(varlist) weightstub(varlist)  y(varname) x(varname) [absorb(varname)] [controls(
  ```
- Line 4: loc
  ```
  local share_stub `sharestub'
  ```
- Line 5: loc
  ```
  local weight_stub `weightstub'
  ```
- Line 6: loc
  ```
  local x `x'
  ```
- Line 7: loc
  ```
  local y `y'
  ```
- Line 17: name
  ```
  tempname abs
  ```
- Line 20: loc
  ```
  local absorb_var `abs'_*
  ```
- Line 21: loc
  ```
  local controls "`controls' `absorb_var'"
  ```
- Line 25: loc
  ```
  local by by(`by')
  ```
- Line 35: name
  ```
  tempname g
  ```
- Line 60: name
  ```
  void weights(string scalar yname, string scalar xname, string scalar Zname, string scalar Wname, str
  ```
- Line 62: name
  ```
  G = st_matrix(Gname)
  ```
- Line 64: name
  ```
  x = st_data(., xname)
  ```
- Line 65: name
  ```
  Z = st_data(., tokens(Zname))
  ```
- Line 66: name
  ```
  y = st_data(., yname)
  ```
- Line 67: name
  ```
  xbar = st_data(., (yname,xname) )
  ```
- Line 68: name
  ```
  W = st_data(., tokens(Wname))
  ```
- Line 69: name
  ```
  weight = diag(st_data(., weightname))
  ```
- Line 70: name
  ```
  weight2 = st_data(., weightname)
  ```
- Line 93: name
  ```
  void weights_nocontrols(string scalar yname, string scalar xname, string scalar Zname, string scalar
  ```
- Line 95: name
  ```
  G = st_matrix(Gname)
  ```
- Line 97: name
  ```
  x = st_data(., xname)
  ```
- Line 98: name
  ```
  Z = st_data(., tokens(Zname))
  ```
- Line 99: name
  ```
  y = st_data(., yname)
  ```
- Line 100: name
  ```
  xbar = st_data(., (yname,xname) )
  ```
- Line 101: name
  ```
  weight = diag(st_data(., weightname))
  ```

**/replication-package/MS20241468_Deposit/code/ado/btsls.ado**

- Line 4: name
  ```
  syntax [if] [in], z(varlist)  y(varname) x(varname) ktype(string) [absorb(varname)] [controls(varlis
  ```
- Line 5: loc
  ```
  local x `x'
  ```
- Line 6: loc
  ```
  local y `y'
  ```
- Line 24: name
  ```
  tempname abs
  ```
- Line 27: loc
  ```
  local absorb_var `abs'_*
  ```
- Line 28: loc
  ```
  local controls "`controls' `absorb_var'"
  ```
- Line 32: loc
  ```
  local z_list = r(varlist)
  ```
- Line 33: loc
  ```
  local wordcount = wordcount("`z_list'")
  ```
- Line 34: loc
  ```
  local new_z ""
  ```
- Line 35: loc
  ```
  local new_controls ""
  ```
- Line 37: loc
  ```
  local test_var = word("`z_list'", `i')
  ```
- Line 40: loc
  ```
  local new_z "`new_z' `test_var'"
  ```
- Line 43: loc
  ```
  local new_z "`new_z' `test_var'"
  ```
- Line 46: loc
  ```
  local new_controls "`new_controls' `test_var'"
  ```
- Line 51: loc
  ```
  local new_z "`z'"
  ```
- Line 52: loc
  ```
  local new_controls "`controls'"
  ```
- Line 53: loc
  ```
  local K = wordcount("`new_z'")
  ```
- Line 54: loc
  ```
  local L = wordcount("`new_controls'")
  ```
- Line 56: loc
  ```
  local N = r(N)
  ```
- Line 57: name
  ```
  tempname kappa
  ```
- Line 80: loc
  ```
  local beta = beta[1,1]
  ```
- Line 89: name
  ```
  void weights(string scalar yname, string scalar xname, string scalar Zname, string scalar Wname, str
  ```
- Line 91: name
  ```
  x = st_data(., xname)
  ```
- Line 92: name
  ```
  Z = st_data(., tokens(Zname))
  ```
- Line 93: name
  ```
  y = st_data(., yname)
  ```
- Line 94: name
  ```
  W = st_data(., tokens(Wname))
  ```
- Line 95: name
  ```
  weight = st_data(., weightname)
  ```
- Line 96: name
  ```
  kappa = st_numscalar(kappaname)
  ```
- Line 121: name
  ```
  void weights_nocontrols(string scalar yname, string scalar xname, string scalar Zname, string scalar
  ```
- Line 123: name
  ```
  x = st_data(., xname)
  ```
- Line 124: name
  ```
  Z = st_data(., tokens(Zname))
  ```
- Line 125: name
  ```
  y = st_data(., yname)
  ```
- Line 126: name
  ```
  weight = st_data(., weightname)
  ```
- Line 127: name
  ```
  kappa = st_numscalar(kappaname)
  ```

**/replication-package/MS20241468_Deposit/code/ado/ch_weak.ado**

- Line 5: degree
  ```
  * the fixed effects with the correct degrees of freedom. This is the only change.
  ```
- Line 8: name
  ```
  syntax [if] [in], p(numlist) beta_range(numlist)   y(name) x(name) z(varlist) [controls(varlist)] [a
  ```
- Line 9: loc
  ```
  local x `x'
  ```
- Line 10: loc
  ```
  local y `y'
  ```
- Line 12: loc
  ```
  local weight "[aw=`weight_var']"
  ```
- Line 15: loc
  ```
  local se "cluster(`cluster')"
  ```
- Line 18: loc
  ```
  local se "robust"
  ```
- Line 20: loc
  ```
  local beta_min = .
  ```
- Line 21: loc
  ```
  local beta_max = .
  ```
- Line 33: loc
  ```
  local beta_min = `beta'
  ```
- Line 36: loc
  ```
  local beta_max = `beta'
  ```

**/replication-package/MS20241468_Deposit/code/ado/overid_chao.ado**

- Line 2: name
  ```
  syntax [if] [in], y(name) x(name) z(varlist) [controls(varlist)] [absorb(varname)] [WEIGHT_var(strin
  ```
- Line 3: loc
  ```
  local x `x'
  ```
- Line 4: loc
  ```
  local y `y'
  ```
- Line 14: name
  ```
  tempname a
  ```
- Line 17: loc
  ```
  local controls2 "`controls' `a'_*"
  ```
- Line 20: loc
  ```
  local controls2 "`controls'"
  ```
- Line 23: loc
  ```
  local z_list = r(varlist)
  ```
- Line 24: loc
  ```
  local wordcount = wordcount("`z_list'")
  ```
- Line 25: loc
  ```
  local new_z ""
  ```
- Line 26: loc
  ```
  local new_controls ""
  ```
- Line 28: loc
  ```
  local test_var = word("`z_list'", `i')
  ```
- Line 31: loc
  ```
  local new_z "`new_z' `test_var'"
  ```
- Line 34: loc
  ```
  local new_z "`new_z' `test_var'"
  ```
- Line 37: loc
  ```
  local new_controls "`new_controls' `test_var'"
  ```
- Line 52: loc
  ```
  local delta = r(delta)
  ```
- Line 53: loc
  ```
  local beta = r(beta)
  ```
- Line 54: loc
  ```
  local T = r(T)
  ```
- Line 55: loc
  ```
  local p = r(p)
  ```
- Line 68: name
  ```
  void overid_chao(string scalar yname, string scalar xname, string scalar Zname, string scalar Wname,
  ```
- Line 70: name
  ```
  x = st_data(., xname)
  ```
- Line 71: name
  ```
  Z = st_data(., tokens(Zname))
  ```
- Line 72: name
  ```
  y = st_data(., yname)
  ```
- Line 73: name
  ```
  xbar = st_data(., (yname,xname) )
  ```
- Line 74: name
  ```
  W = st_data(., tokens(Wname))
  ```
- Line 75: name
  ```
  weight = diag(st_data(., weightname))
  ```
- Line 101: lon
  ```
  epsilon = yy - delta_hat2*xx
  ```
- Line 102: lon
  ```
  epsilon_2 = epsilon :* epsilon
  ```
- Line 105: lon
  ```
  gam = (xx' * weight* epsilon) / (epsilon'* weight*epsilon)
  ```
- Line 106: lon
  ```
  xx_hat = xx - epsilon* gam
  ```
- Line 110: lon
  ```
  Sigma1 =  xx_dot'* diag(epsilon_2) * weight *xx_dot - xx_hat' * weight*  diag(P_ii)  * diag(epsilon_
  ```
- Line 112: lon
  ```
  x_eps = xx_hat :* epsilon
  ```
- Line 122: lon
  ```
  V = (epsilon_2' * weight_2 * P_2 * epsilon_2 - epsilon_2' * weight_2 * diag(P_ii_2)  * epsilon_2) / 
  ```
- Line 123: lon
  ```
  T = K + ((epsilon' * weight*  P * epsilon - epsilon' * weight*  diag(P_ii) * epsilon) / sqrt(V))
  ```
- Line 131: name
  ```
  void overid_chao_nocons(string scalar yname, string scalar xname, string scalar Zname, string scalar
  ```
- Line 133: name
  ```
  x = st_data(., xname)
  ```
- Line 134: name
  ```
  Z = st_data(., tokens(Zname))
  ```
- Line 135: name
  ```
  y = st_data(., yname)
  ```
- Line 136: name
  ```
  xbar = st_data(., (yname,xname) )
  ```
- Line 137: name
  ```
  weight = diag(st_data(., weightname))
  ```
- Line 160: lon
  ```
  epsilon = yy - delta_hat2*xx
  ```
- Line 161: lon
  ```
  epsilon_2 = epsilon :* epsilon
  ```
- Line 164: lon
  ```
  gam = (xx' * weight* epsilon) / (epsilon'* weight*epsilon)
  ```
- Line 165: lon
  ```
  xx_hat = xx - epsilon* gam
  ```
- Line 169: lon
  ```
  Sigma1 =  xx_dot'* diag(epsilon_2) * weight *xx_dot - xx_hat' * weight*  diag(P_ii)  * diag(epsilon_
  ```
- Line 171: lon
  ```
  x_eps = xx_hat :* epsilon
  ```
- Line 181: lon
  ```
  V = (epsilon_2' * weight_2 * P_2 * epsilon_2 - epsilon_2' * weight_2 * diag(P_ii_2)  * epsilon_2) / 
  ```
- Line 182: lon
  ```
  T = K + ((epsilon' * weight*  P * epsilon - epsilon' * weight*  diag(P_ii) * epsilon) / sqrt(V))
  ```

**/replication-package/MS20241468_Deposit/data/public/USmap_1930/US_county_1930_WGS84.qmd**

- Line 10: block, census, lat, loc, second, social
  ```
  These data are based upon work supported by the National Science Foundation under Grant No. BCS00949
  ```
- Line 12: census, city, district, parish, territory
  ```
  Counties are the primary legal subdivisions of most states and territories. Louisiana uses the term 
  ```
- Line 17: address
  ```
  <contactAddress>
  ```
- Line 18: address
  ```
  <type>physical address</type>
  ```
- Line 19: address
  ```
  <address>50 Willey Hall
  ```
- Line 20: address
  ```
  225 19th Avenue South</address>
  ```
- Line 21: city
  ```
  <city>Minneapolis</city>
  ```
- Line 24: country
  ```
  <country>USA</country>
  ```
- Line 25: address
  ```
  </contactAddress>
  ```
- Line 26: name
  ```
  <name></name>
  ```
- Line 30: fax
  ```
  <fax></fax>
  ```
- Line 35: lat, loc, name, network, url
  ```
  <link url="file://\\thalia.socsci.umn.edu\popgis\labpcs\conflation\shapefiles\packing\gisjoin_gisjoi
  ```
- Line 38: son
  ```
  <constraints type="Access">All persons are granted a limited license to use and distribute this docu
  ```

**/replication-package/MS20241468_Deposit/output/tables/rotemberg_summary.tex**

- Line 6: lat
  ```
  \multicolumn{5}{l}{\textbf{Panel B: Correlations} }\\
  ```

