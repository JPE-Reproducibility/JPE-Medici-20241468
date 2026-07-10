## Potentially Hardcoded Numeric Constants


We found the following set of hard coded numbers. This may be completely legitimate (parameter input, thresholds for computations, etc), and is hence only for information.

**/Users/florianoswald/actions-runner/_work/JPE-Medici-20241468/JPE-Medici-20241468/replication-package/MS20241468_Deposit/build_documentation/scripts/b7_economic_railroads.do**

- Line 193, : replace farmarea = farmarea / 247.105											// acres -> square kilometers

**/Users/florianoswald/actions-runner/_work/JPE-Medici-20241468/JPE-Medici-20241468/replication-package/MS20241468_Deposit/data/public/USmap_1930/US_county_1930_WGS84.qmd**

- Line 55, : <spatial miny="-1337508.07728000008501112" maxz="0" dimensions="2" minx="-2356113.74319900013506413" crs="EPSG:4326" minz="0" maxy="1565781.6593790000770241" maxx="2258224.79635699978098273"/>

**/Users/florianoswald/actions-runner/_work/JPE-Medici-20241468/JPE-Medici-20241468/replication-package/MS20241468_Deposit/output/tables/rotemberg_summary.tex**

- Line 4, : Negative & -0.062 & -0.015 & 0.055 \\
- Line 5, : Positive & 1.062 & 0.082 & 0.945 \\
- Line 11, : $g_{k}$                &   0.918  & 1\\
- Line 12, : $\beta_{k}$             &   0.119  & -0.079    &1\\
- Line 13, : $F_{k}$                &   0.115  & 0.124    &  0.053  & 1\\
- Line 14, : Var($z_{k}$)           &   -0.222  & -0.391    &  0.496  &  -0.383   &1\\
- Line 17, : Austria-Hungary & 0.267 & 7.55e+05 & 0.391 & (-2.200,3.300)  &  \\
- Line 18, : Italy & 0.258 & 7.36e+05 & -1.072 & (-4.800,1.100)  &  \\
- Line 19, : Russia & 0.227 & 6.62e+05 & 4.511 & (1.800,15.200)  &  \\
- Line 20, : Greece-Portugal-Spain & 0.100 & 1.06e+05 & 13.427 & (0.500,56.200)  &  \\
- Line 21, : Sweden & 0.063 & 1.20e+05 & 1.189 & (-2.600,4.600)  &  \\
- Line 24, : Negative & 0.168 & 0.062 &2.424 \\
- Line 25, : Positive & 2.547 & 0.938 & 1.683 \\

**/Users/florianoswald/actions-runner/_work/JPE-Medici-20241468/JPE-Medici-20241468/replication-package/MS20241468_Deposit/code/2_analysis/2e_results_robustness.do**

- Line 1516, : * Scaled by 1.0504102 (0.05 tF adjustment from Lee et al., based on first-stage F of 67.363)
- Line 1517, : mata: st_matrix("se_tF95_`outcome'", sqrt(diagonal(st_matrix("V_`outcome'")))':*1.0504102)

