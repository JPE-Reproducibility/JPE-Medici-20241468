# Bundled third-party Stata programs (`code/ado/`)

Helper commands used by `code/2_analysis/2f_rotemberg_weights.do` for the
shift-share (Bartik) Rotemberg-weight diagnostics:

- `bartik_weight.ado` — Rotemberg-weight decomposition
- `ch_weak.ado` — Chernozhukov–Hansen weak-IV-robust confidence intervals
- `btsls.ado`, `overid_chao.ado` — bias-corrected 2SLS / overidentification helpers

Source: Goldsmith-Pinkham, Paul, Isaac Sorkin, and Henry Swift. 2020.
"Bartik Instruments: What, When, Why, and How." *American Economic Review*
110 (8): 2586–2624. Replication code, AEA Data and Code Repository.

License: Modified BSD (BSD-3-Clause), which permits redistribution with the
copyright/license notice retained — see `LICENSE_from_GoldsmithPinkham_etal.txt`
(the original license file shipped with their package, authored by them, not by us).
Copyright 2018 American Economic Association.

`bartik_weight.ado`, `btsls.ado`, and `overid_chao.ado` are bundled unmodified
from the Goldsmith-Pinkham–Sorkin–Swift replication package. `ch_weak.ado`
carries a single documented change: its `absorb()` branch calls `areg` instead of
`reg` (the upstream `reg ..., absorb()` is not valid Stata and cannot run), so the
program absorbs fixed effects with the correct degrees of freedom. No other
changes were made.

`2f_rotemberg_weights.do` adds this folder to the ado path (`adopath ++ "$code/ado"`).
