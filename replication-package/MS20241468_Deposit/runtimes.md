# Computational requirements and runtimes

This file records approximate wall-clock runtimes for the replication package, to
set expectations for the data editor and replicators.

## What a replicator runs

A replicator runs only `code/00_master.do`. It reads the shipped aggregates in
`data/public/` and reproduces every table and figure. The build stage
(`build_documentation/scripts/00_master_build.do`) is author-only: it regenerates the aggregates
from non-shippable sources (IPUMS complete-count microdata, ICPSR, restricted
names) and is not part of the replicator's path.

## Software

Stata 19.5 (the version the deposited results were produced under; `version 17` is set in `00_master.do` for syntax compatibility). SSC dependencies are
installed at the top of each master file (`reghdfe`, `ivreghdfe`, `weakivtest2`,
`gtools`, `grc1leg2`, `spmap`, etc.). First run incurs a one-time
`reghdfe, compile`.

## Hardware used for the timings below

Windows Server 2022 Standard (Version 21H2), 64-bit operating system, Intel(R) Xeon(R) Gold 6426Y 2.50 GHz (2 processors), 1TB RAM. 

## Runnable pipeline — `00_master.do`

Total wall time on the reference run: ≈ 5.5 hours.

| step | script | approx. runtime |
|---|---|---|
| 1a–1b | reference inputs, merge/pre-adjust | < 1 min each |
| 1c | boundary adjustment | ~2h |
| 1d–1h | panel, weather, shift-share, crowd-out, final | < 1 min each |
| 2a | summary statistics | ~3 min |
| 2b | descriptive figures | < 1 min |
| 2c | main results | ~19 min |
| 2d | extra results | ~1 min |
| 2e | robustness | ~2h 20m |
| 2f | Rotemberg weights | ~23 min |

Build-stage timings (the author-only `00_master_build.do`) are documented in
`build_documentation/README.md`.
