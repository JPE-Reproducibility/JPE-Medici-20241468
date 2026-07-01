# build_documentation

This folder documents how the shipped aggregates in `data/public/` were constructed.
It is not part of the replication run: to reproduce the paper, a replicator runs
`code/00_master.do`, which reads the aggregates in `data/public/` and needs nothing
from this folder.

## What this is

The build code lives in `scripts/`: the driver `00_master_build.do` and `b1`–`b16`
build the county and national aggregates in `data/public/` (census, elections,
by-origin series, surname origin/ancestry tables, and the union aggregates) from
primary sources. They are the authoritative record of how those aggregates were
produced.

## Why it cannot be run from the deposit

These scripts read inputs that are not part of the deposit:

- IPUMS USA complete-count microdata (public but not redistributable; obtain from IPUMS).
- IPUMS restricted full-count microdata with surnames (restricted access, secure
  server only), read by `b9_names.do`.
- ICPSR studies (00001 elections, 02896 Haines, 00029 Knights of Labor).
- Manually geocoded union records and other working files under `data/_raw_local/`.

See the top-level `README.md` (Data Availability Statement) and
`data/extract_definitions/` for the exact extracts a researcher would need to rebuild
the aggregates from scratch.

## Manual step: geocoding

The union, IWW, and Knights of Labor branch locations were geocoded outside Stata,
using the ArcGIS *Geocode Addresses* tool against the ArcGIS "USA Locator" (a
street-level U.S. address locator). The build scripts then read the geocoded CSVs,
drop low-quality matches (match score below 85, non-point or cross-state results),
and assign each point to a 1930 county. The exact inputs, outputs, and filters are
documented in the headers of `scripts/b10_aflstateconv.do`,
`scripts/b11_natunions.do`, `scripts/b13_iww.do`, and `scripts/b14_kol.do`.

## Outputs

Running this stage writes the aggregates into `data/public/` (and per-union build
intermediates into `data/intermediate/`), which the runnable pipeline in `code/` then
reads.

## Runtimes

Author-only; not part of the replicator's path. On the reference machine (hardware
and software as in `../runtimes.md`), a clean sequential run is about 6h 15m,
dominated by b9.

| step | script | approx. runtime |
|---|---|---|
| b1–b8 | census aggregates + elections | ~1h 25m total |
| b9 | restricted-names tabulation | ~4h 45m |
| b10–b15 | union/IWW/KoL/by-origin aggregates | ~5 min total |
| b16 | ship aggregates to `data/public/` | < 5 min |

