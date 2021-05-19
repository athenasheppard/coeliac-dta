# coeliac-dta #
*All data and statistical code to recreate analysis for our systematic review of serological test accuracy for coeliac disease*

## data ##
* **qry_studychar.xlsx** - study characteristic data, one row per study
* **qry_dta.xlsx** - diagnostic test accuracy data, one row per set of 2x2 data

## code ##
* **metandi.ado** - run metandi.ado before **coeliac_ma.do**; includes option for univariate fixed effects meta-analysis where there are few (2-3) studies in a data set
* **coeliac_studychar.do** - summarise study characteristics and risk of bias assessments
* **coeliac_allthresholds.do** - summarise study test accuracy (table 1)
* **coeliac_ma.do** - meta-analyse test accuracy data (table 2, figures 2, 3 & 4)
* **coeliac_sensanalysis.do** - perform sensitivity analyses (table 3)
* **coeliac_directcompar.do** - summarise comparative accuracy data (table 4)
