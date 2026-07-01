# Replication Package — "Closing Ranks: Organized Labor and Immigration"

Carlo Medici. *Journal of Political Economy*, MS 20241468.

This README documents the data and code that reproduce every table and figure in
the paper. It is organized following the AEA/JPE Data and Code Availability
Standard (DCAS).

---

## 1. Overview

The package has two stages.

- **Runnable pipeline — `code/00_master.do`.** This is what a replicator runs. It
  reads the shipped aggregates in `data/public/`, builds the analysis dataset, and
  produces every exhibit in the paper into `output/tables/` (`.xml`) and
  `output/figures/` (`.pdf`). It requires no restricted or non-shipped data.

- **Build stage — `build_documentation/scripts/00_master_build.do` (author-only).** This documents
  how the shipped aggregates in `data/public/` were produced from sources that
  cannot travel in the deposit (IPUMS complete-count microdata; the IPUMS restricted
  full-count *with surnames*; ICPSR studies). A replicator cannot run this stage
  without obtaining those sources and is not expected to; it is provided for
  transparency and for the authors to rebuild the aggregates.

Expected total runtime of the runnable pipeline is ≈ 12.5 hours; see
[`runtimes.md`](runtimes.md) for per-script timings, software, and hardware.

---

## 2. Data Availability Statement and provenance

### 2.1 Statement of rights

The author certifies that he has legitimate access to, and permission to use, all
data used in this manuscript. The author further certifies that he has permission to
redistribute the data included in this deposit. Data that cannot be redistributed
(the IPUMS restricted full-count microdata with surnames) are not included; only
name-free aggregates derived from them are shipped (see §2.3).

### 2.2 Summary of availability

- All data required to run `code/00_master.do` and reproduce the paper's exhibits
  are included in `data/public/`.
- One underlying source is restricted and is not included: the IPUMS restricted
  full-count microdata with surnames. The runnable pipeline does not need it; it
  reads only the name-free aggregates derived from it.
- The build stage additionally relies on public-but-large microdata (IPUMS
  complete-count files; ICPSR studies) that are not redistributed here but are freely
  obtainable from IPUMS and ICPSR. See `data/extract_definitions/` for exact extract
  definitions and variable lists.

### 2.3 Restricted data — IPUMS full count with surnames

The surname→origin and surname→ancestry probability tables in
`data/public/IPUMS_surname_aggregates/` are built (by `build_documentation/scripts/b9_names.do`) from
the IPUMS USA restricted full-count microdata including the name fields, accessed
under restricted-use terms on a secure server. The raw name microdata are not
redistributable and were processed locally only. Only the aggregated probability
tables — which contain no names, just `namelast`-keyed origin/ancestry shares — are
shipped. A researcher seeking to rebuild these tables from scratch must apply to
IPUMS for restricted full-count access; the required extract is documented in
`data/extract_definitions/README.md` (§2). No restricted name data are required to
run `code/00_master.do`.

### 2.4 Data sources

Each shipped folder under `data/public/` carries its own `README.md` with the full
source citation and a column glossary. Summary:

| Folder (`data/public/…`) | Source | Provided | Built by |
|---|---|---|---|
| `census_aggregates/` | IPUMS USA complete count (1880–1930); Haines, ICPSR 02896 (1890 population, manufacturing, agriculture) | aggregates (microdata not shipped) | b1–b8, b16 |
| `foreignborn_byorigin/` | IPUMS USA complete count (1850–1920); Haines, ICPSR 02896 (1890) | aggregates | b15 |
| `IPUMS_surname_aggregates/` | IPUMS USA restricted full count with surnames | name-free aggregates only (see §2.3) | b9 |
| `unions/` | Author-digitized convention proceedings of the state federations of labor and five national unions; IWW (Gregory 2015); Knights of Labor (Garlock 2009, ICPSR 00029) | yes (authors' construction) | b10–b14 |
| `cpi/` | Federal Reserve Bank of Minneapolis, CPI 1800– | yes | b7 |
| `MPI_immflows/` | Migration Policy Institute tabulation of DHS *Yearbook of Immigration Statistics* | yes | — (read directly) |
| `Willcox_1929/` | Willcox (1929), *International Migrations, Vol. I*, NBER | yes | — |
| `Freeman_1998/` | Freeman (1998), "Spurts in Union Growth," NBER WP 6012 | yes | — |
| `county_crosswalks/` | Ferrara, Testa & Zhou (2022), openICPSR 150101 V4 | yes (`.dta` + `.csv`) | b12; 1c, 1d |
| `crosswalks/` | Identifier crosswalks (StateFIP↔ICP; 1900 county NHGIS↔ICP) | yes | 1a |
| `IPUMS/` | IPUMS-derived crosswalks (OCC1950 labels; 1930 county↔SEA) | yes | 1a |
| `USmap_1930/` | 1930 U.S. county boundaries shapefile, IPUMS NHGIS | yes | 1a, b13 |
| `census_mines/` | Day (1892), *Report on Mineral Industries … 1890* | yes | b7 |
| `railroad_maps/` | See `data/public/railroad_maps/README.md` | yes | b7 |

Full citations are in §8. Non-shipped sources used only by the build stage (IPUMS
complete-count microdata; ICPSR 00001 elections; ICPSR 02896 Haines; ICPSR 00029
KoL) are documented in `data/extract_definitions/`.

---

## 3. Computational requirements

- **Software:** Stata. Results were produced under **Stata 19.5**; `00_master.do`
  sets `version 17` for syntax compatibility (it does not change numerical results).
  Point estimates and figures reproduce on any recent release; cluster-robust SEs and
  weak-IV F-statistics may differ in the last reported digit on releases other than 19.5.
- **Stata packages** are installed from SSC at the top of each master file
  (`reghdfe`, `ivreghdfe`, `ivreg2`, `ranktest`, `weakivtest2`/`weakivtest`, `avar`,
  `distinct`, `gtools`/`ftools`, `outreg2`, `coefplot`, `estout`, `grc1leg2`,
  `spmap`, `geoinpoly`, `shp2dta`, and others). Third-party `.ado` files that are not
  on SSC are bundled in `code/ado/` (see `code/ado/README.md`). A live SSC connection
  is needed only on first run.
- **Runtime / hardware:** see [`runtimes.md`](runtimes.md). The runnable pipeline
  takes ≈ 12.5 hours on the reference machine, dominated by the boundary
  harmonization (`1c`) and the shift-share/Rotemberg inference (`2e`, `2f`).

---

## 4. Directory structure

```
MS20241468_Deposit/
├── README.md                 ← this file
├── runtimes.md               ← computational requirements / runtimes
├── code/                     ← the replication package — run code/00_master.do
│   ├── 00_master.do          ← run this (runnable pipeline)
│   ├── 1_construction/       ← 1a–1h: assemble the analysis dataset
│   ├── 2_analysis/           ← 2a–2f: tables and figures
│   └── ado/                  ← bundled third-party .ado (non-SSC)
├── build_documentation/      ← author-only: how data/public/ was built (not run by replicators)
│   ├── README.md
│   └── scripts/               ← 00_master_build.do, b1–b16
├── data/
│   ├── public/               ← shipped aggregates the pipeline reads (per-folder READMEs)
│   ├── extract_definitions/  ← how to obtain the non-shipped microdata
│   ├── clean/                ← author working datasets (regenerated; ships empty)
│   ├── intermediate/         ← scratch space (regenerated; ships empty)
│   └── _raw_local/           ← author-only raw inputs (not shipped)
└── output/
    ├── tables/   (.xml)   ├── figures/   (.pdf)   └── logs/
```

---

## 5. Description of code

### 5.1 Runnable pipeline — `code/00_master.do`

**Construction (`1_construction/`)** assembles the analysis dataset:

| script | role |
|---|---|
| `1a_reference_inputs` | load reference inputs and crosswalks; convert the 1930 shapefile |
| `1b_merge_preadjust` | merge census, elections, and by-origin aggregates onto counties |
| `1c_boundary_adjustment` | harmonize all years to 1930 county boundaries (area overlap) |
| `1d_county_panel` | build the county panel (incl. occupation cells) |
| `1e_weather_shocks` | construct origin-country weather shocks (Willcox flows) |
| `1f_shiftshare` | build the shift-share immigration instrument |
| `1g_crowdout` | crowd-out / labor-market competition measures |
| `1h_final_dataset` | merge controls and CPI; produce `analysis_dataset_county1930.dta` |

**Analysis (`2_analysis/`)** produces the exhibits. Each script's header lists its
exact output files; the output filenames are self-describing.

| script | produces |
|---|---|
| `2a_sumstats` | union-density county maps; summary-statistics table; correlates of the 1890 immigrant share; long-difference inflow↔union-strength (Table A.7); data-source correlations; correlation with Farber et al. (2021); leading occupations of immigrants vs. US-born |
| `2b_figures_descriptives` | foreign-born composition by origin, 1850–1920; union-membership (Freeman 1998) vs. immigrant-inflow (MPI) trends |
| `2c_results_main` | first stage; baseline OLS/reduced-form/2SLS on presence, branches, density, average membership; share of unionization explained; by-skill; intensive/extensive margins; labor-market competition; heterogeneity (origin, Know-Nothing vote, segregation); convention-delegate composition (`share_deleg`) |
| `2d_results_extra` | control-function IV; heterogeneity by origin-country traits (labor movement, socialist support); other unions (KoL, IWW); local economic outcomes |
| `2e_results_robustness` | robustness battery (`rob_summary`); initial-stock interaction (`rob_initstock`); additional baseline controls (`rob_controls`); pre-trends |
| `2f_rotemberg_weights` | Rotemberg-weight diagnostics and AKM shift-share inference (`rotemberg_weights`, `rotemberg_summary`) |

`2_sample_specifications.do` is a helper file that the `2*` scripts load with `do`
to define the estimation samples; it is not run on its own.

### 5.2 Build stage — `build_documentation/scripts/00_master_build.do` (author-only)

Regenerates the shipped aggregates from non-shippable sources. Scripts `b1`–`b8`
build the census/elections aggregates from IPUMS complete count and ICPSR; `b9`
builds the surname probability tables from the restricted names; `b10`–`b14` build
the union aggregates; `b15` the by-origin series; `b16` ships the aggregates into
`data/public/`. Not part of the replicator's path.

---

## 6. Instructions to replicators

1. **Obtain the data.** Everything needed to run `00_master.do` is already in
   `data/public/`. Nothing else is required for the runnable pipeline. (Only the
   author-only build stage needs the non-shipped microdata in §2.)
2. **Set the path.** Open `code/00_master.do` and set `global root` (near the top) to
   the local path of this package.
3. **Run** `code/00_master.do` in Stata 19.5. On first run, leave an SSC connection
   available so the dependency installer can fetch any missing packages. Expect
   ≈ 12.5 hours (see `runtimes.md`).
4. **Outputs** are written to `output/tables/` (`.xml`, pasted into the manuscript)
   and `output/figures/` (`.pdf`), and a full run log to `output/logs/00_master.log`.

The build stage and the analysis scripts can also each be run standalone: every
script sets `$root` itself if the master has not, so set that one line and run.

---

## 7. Reproducibility notes

- `00_master.do` pins `version 17`, fixes the figure scheme (`set scheme s2color`),
  and writes a timestamped log with per-script banners.
- `data/intermediate/` and `data/clean/` both ship empty and are regenerated by a run.

---

## 8. References (data sources)

- Day, David T. 1892. *Report on Mineral Industries in the United States at the
  Eleventh Census, 1890.* Vol. 14. Norman Ross Pub.
- Ferrara, Andreas, Patrick A. Testa, and Liyang Zhou. 2022. *New Area- and
  Population-based Geographic Crosswalks for U.S. Counties and Congressional
  Districts, 1790–2020.* Ann Arbor, MI: ICPSR [distributor]. openICPSR 150101, V4.
  https://doi.org/10.3886/E150101V4
- Freeman, Richard B. 1998. "Spurts in Union Growth: Defining Moments and Social
  Processes." NBER Working Paper 6012. https://doi.org/10.3386/w6012
- Garlock, Jonathan. 2009. *Knights of Labor Assemblies, 1879–1889 (ICPSR 29).*
  Inter-University Consortium for Political and Social Research [distributor].
- Gregory, James N. 2015. *IWW History Project.* http://depts.washington.edu/iww/
- Haines, Michael R. 2010. *Historical, Demographic, Economic, and Social Data: The
  United States, 1790–2002 (ICPSR 2896).* (Source for the 1890 population,
  manufacturing, and agriculture aggregates.)
- Federal Reserve Bank of Minneapolis. *Consumer Price Index (CPI), 1800–.*
  https://www.minneapolisfed.org/about-us/monetary-policy/inflation-calculator/consumer-price-index-1800-
- Migration Policy Institute. Tabulation of U.S. Department of Homeland Security,
  Office of Homeland Security Statistics, *Yearbook of Immigration Statistics, 2023.*
  https://ohss.dhs.gov/topics/immigration/yearbook
- IPUMS NHGIS, University of Minnesota. 1930 U.S. county boundary file.
- Ruggles, Steven, et al. 2022. *IPUMS USA / IPUMS Full Count Data: Version 3.0
  [dataset].* Minneapolis, MN: IPUMS.
- Willcox, Walter F. 1929. "Statistics of Migrations, National Tables, United
  States." In *International Migrations, Volume I: Statistics.* NBER.

See each `data/public/<folder>/README.md` and `data/extract_definitions/README.md`
for source-level detail. For the substantive description of the union data, see the
paper's Data section, "Dataset on Union Presence and Membership."
