log using h:\intldata\africaed\barrolee, replace text
 
/* This program does some regressions, following Barro-Lee book */

use h:\intldata\africaed\barrolee.dta

* First try to replicate their Table 12.3, column 2

replace lf_WDI = lf_E if lf_E~=.

rename saa ssa

* Keep variables that will be used (before reshaping)
keep av_grgdpch year lg_rgdpch IVlg_rgdpch up_sch_25 lf_WDI lg_fertility av_kg IVav_kg /*
 */ rol av_demo av_2demo IV_demo IV_2demo av_ropenness tot av_ki IVav_ki/*
 */ av_inflation_c colony_sp colony_other code up_sch_15 ssa

* First try xtivreg (with random effects) (This was a waste of time.)

/*

sort code
gen countrynum=round((_n+1)/3)

list code countrynum

xtset countrynum

xtivreg av_grgdpch up_sch_25 lf_WDI lg_fertility rol av_ropenness av_inflation_c /*
 */ (lg_rgdpch av_kg av_demo av_2demo av_ki = IVlg_rgdpch IVav_kg IV_demo IV_2demo IVav_ki)

*/

su

drop if year==. /* not sure what these 9 observations are */

gen up_sch_25AF=up_sch_25*ssa

reshape wide av_grgdpch lg_rgdpch IVlg_rgdpch up_sch_25 lf_WDI lg_fertility av_kg IVav_kg /*
 */ rol av_demo av_2demo IV_demo IV_2demo av_ropenness tot av_ki IVav_ki av_inflation_c /*
 */ up_sch_15 up_sch_25AF ssa, i(code) j(year)

constr 1 [av_grgdpch1965]lg_rgdpch1965=[av_grgdpch1975]lg_rgdpch1975
constr 2 [av_grgdpch1975]lg_rgdpch1975=[av_grgdpch1985]lg_rgdpch1985
constr 3 [av_grgdpch1965]up_sch_251965=[av_grgdpch1975]up_sch_251975
constr 4 [av_grgdpch1975]up_sch_251975=[av_grgdpch1985]up_sch_251985
constr 5 [av_grgdpch1965]lf_WDI1965=[av_grgdpch1975]lf_WDI1975
constr 6 [av_grgdpch1975]lf_WDI1975=[av_grgdpch1985]lf_WDI1985
constr 7 [av_grgdpch1965]lg_fertility1965=[av_grgdpch1975]lg_fertility1975
constr 8 [av_grgdpch1975]lg_fertility1975=[av_grgdpch1985]lg_fertility1985
constr 9 [av_grgdpch1965]av_kg1965=[av_grgdpch1975]av_kg1975
constr 10 [av_grgdpch1975]av_kg1975=[av_grgdpch1985]av_kg1985
constr 11 [av_grgdpch1965]rol1965=[av_grgdpch1975]rol1975
constr 12 [av_grgdpch1975]rol1975=[av_grgdpch1985]rol1985
constr 13 [av_grgdpch1965]av_demo1965=[av_grgdpch1975]av_demo1975
constr 14 [av_grgdpch1975]av_demo1975=[av_grgdpch1985]av_demo1985
constr 15 [av_grgdpch1965]av_2demo1965=[av_grgdpch1975]av_2demo1975
constr 16 [av_grgdpch1975]av_2demo1975=[av_grgdpch1985]av_2demo1985
constr 17 [av_grgdpch1965]av_ropenness1965=[av_grgdpch1975]av_ropenness1975
constr 18 [av_grgdpch1975]av_ropenness1975=[av_grgdpch1985]av_ropenness1985
constr 19 [av_grgdpch1965]av_ki1965=[av_grgdpch1975]av_ki1975
constr 20 [av_grgdpch1975]av_ki1975=[av_grgdpch1985]av_ki1985
constr 21 [av_grgdpch1965]av_inflation_c1965=[av_grgdpch1975]av_inflation_c1975
constr 22 [av_grgdpch1975]av_inflation_c1975=[av_grgdpch1985]av_inflation_c1985

reg3 (av_grgdpch1965 lg_rgdpch1965 up_sch_251965 lf_WDI1965 lg_fertility1965 av_kg1965 /*
 */ /*rol1965*/ av_demo1965 av_2demo1965 av_ropenness1965 av_ki1965 av_inflation_c1965) /*
 */ (av_grgdpch1975 lg_rgdpch1975 up_sch_251975 lf_WDI1975 lg_fertility1975 av_kg1975 /*
 */ /*rol1975*/ av_demo1975 av_2demo1975 av_ropenness1975 av_ki1975 av_inflation_c1975) /*
 */ (av_grgdpch1985 lg_rgdpch1985 up_sch_251985 lf_WDI1985 lg_fertility1985 av_kg1985 /*
 */ /*rol1985*/ av_demo1985 av_2demo1985 av_ropenness1985 av_ki1985 av_inflation_c1985), /*
 */ endog(lg_rgdpch1965 lg_rgdpch1975 lg_rgdpch1985 av_kg1965 av_kg1975 av_kg1985 /*
 */ av_demo1965 av_demo1975 av_demo1985 av_2demo1965 av_2demo1975 av_2demo1985 /*
 */ av_ki1965 av_ki1975 av_ki1985) /*
 */ exog(IVlg_rgdpch1965 IVlg_rgdpch1975 IVlg_rgdpch1985 IVav_kg1965 IVav_kg1975 /*
 */ IVav_kg1985 IV_demo1965 IV_demo1975 IV_demo1985 IV_2demo1965 IV_2demo1975 /*
 */ IV_2demo1985 IVav_ki1965 IVav_ki1975 IVav_ki1985) /*
 */ constr(1 2 3 4 5 6 7 8 9 10 /* 11 12 */ 13 14 15 16 17 18 19 20 21 22)

* Repeat above allowing separate education coefficients for Sub-Saharan Africa

constr 23 [av_grgdpch1965]up_sch_25AF1965=[av_grgdpch1975]up_sch_25AF1975
constr 24 [av_grgdpch1975]up_sch_25AF1975=[av_grgdpch1985]up_sch_25AF1985
constr 25 [av_grgdpch1965]ssa1965=[av_grgdpch1975]ssa1975
constr 26 [av_grgdpch1975]ssa1975=[av_grgdpch1985]ssa1985

* First just put in African dummy variable

reg3 (av_grgdpch1965 lg_rgdpch1965 up_sch_251965 lf_WDI1965 lg_fertility1965 av_kg1965 /*
 */ /*rol1965*/ av_demo1965 av_2demo1965 av_ropenness1965 av_ki1965 av_inflation_c1965 /*
 */ ssa1965) /*
 */ (av_grgdpch1975 lg_rgdpch1975 up_sch_251975 lf_WDI1975 lg_fertility1975 av_kg1975 /*
 */ /*rol1975*/ av_demo1975 av_2demo1975 av_ropenness1975 av_ki1975 av_inflation_c1975 /*
 */ ssa1975) /*
 */ (av_grgdpch1985 lg_rgdpch1985 up_sch_251985 lf_WDI1985 lg_fertility1985 av_kg1985 /*
 */ /*rol1985*/ av_demo1985 av_2demo1985 av_ropenness1985 av_ki1985 av_inflation_c1985 /*
 */ ssa1985), /*
 */ endog(lg_rgdpch1965 lg_rgdpch1975 lg_rgdpch1985 av_kg1965 av_kg1975 av_kg1985 /*
 */ av_demo1965 av_demo1975 av_demo1985 av_2demo1965 av_2demo1975 av_2demo1985 /*
 */ av_ki1965 av_ki1975 av_ki1985) /*
 */ exog(IVlg_rgdpch1965 IVlg_rgdpch1975 IVlg_rgdpch1985 IVav_kg1965 IVav_kg1975 /*
 */ IVav_kg1985 IV_demo1965 IV_demo1975 IV_demo1985 IV_2demo1965 IV_2demo1975 /*
 */ IV_2demo1985 IVav_ki1965 IVav_ki1975 IVav_ki1985 ssa1965 ssa1975 ssa1985) /*
 */ constr(1 2 3 4 5 6 7 8 9 10 /* 11 12 */ 13 14 15 16 17 18 19 20 21 22 25 26)

* Second, just a difference in slope, with no dummy variable

reg3 (av_grgdpch1965 lg_rgdpch1965 up_sch_251965 lf_WDI1965 lg_fertility1965 av_kg1965 /*
 */ /*rol1965*/ av_demo1965 av_2demo1965 av_ropenness1965 av_ki1965 av_inflation_c1965 /*
 */ up_sch_25AF1965) /*
 */ (av_grgdpch1975 lg_rgdpch1975 up_sch_251975 lf_WDI1975 lg_fertility1975 av_kg1975 /*
 */ /*rol1975*/ av_demo1975 av_2demo1975 av_ropenness1975 av_ki1975 av_inflation_c1975 /*
 */ up_sch_25AF1975) /*
 */ (av_grgdpch1985 lg_rgdpch1985 up_sch_251985 lf_WDI1985 lg_fertility1985 av_kg1985 /*
 */ /*rol1985*/ av_demo1985 av_2demo1985 av_ropenness1985 av_ki1985 av_inflation_c1985 /*
 */ up_sch_25AF1985), /*
 */ endog(lg_rgdpch1965 lg_rgdpch1975 lg_rgdpch1985 av_kg1965 av_kg1975 av_kg1985 /*
 */ av_demo1965 av_demo1975 av_demo1985 av_2demo1965 av_2demo1975 av_2demo1985 /*
 */ av_ki1965 av_ki1975 av_ki1985) /*
 */ exog(IVlg_rgdpch1965 IVlg_rgdpch1975 IVlg_rgdpch1985 IVav_kg1965 IVav_kg1975 /*
 */ IVav_kg1985 IV_demo1965 IV_demo1975 IV_demo1985 IV_2demo1965 IV_2demo1975 /*
 */ IV_2demo1985 IVav_ki1965 IVav_ki1975 IVav_ki1985 up_sch_25AF1965 up_sch_25AF1975 /*
 */ up_sch_25AF1985) /*
 */ constr(1 2 3 4 5 6 7 8 9 10 /* 11 12 */ 13 14 15 16 17 18 19 20 21 22 23 24)

lincom up_sch_251965 + up_sch_25AF1965 /* not statistically signif. for Africa */

* Third, both a difference in slope and an Africa dummy variable

reg3 (av_grgdpch1965 lg_rgdpch1965 up_sch_251965 lf_WDI1965 lg_fertility1965 av_kg1965 /*
 */ /*rol1965*/ av_demo1965 av_2demo1965 av_ropenness1965 av_ki1965 av_inflation_c1965 /*
 */ up_sch_25AF1965 ssa1965) /*
 */ (av_grgdpch1975 lg_rgdpch1975 up_sch_251975 lf_WDI1975 lg_fertility1975 av_kg1975 /*
 */ /*rol1975*/ av_demo1975 av_2demo1975 av_ropenness1975 av_ki1975 av_inflation_c1975 /*
 */ up_sch_25AF1975 ssa1975) /*
 */ (av_grgdpch1985 lg_rgdpch1985 up_sch_251985 lf_WDI1985 lg_fertility1985 av_kg1985 /*
 */ /*rol1985*/ av_demo1985 av_2demo1985 av_ropenness1985 av_ki1985 av_inflation_c1985 /*
 */ up_sch_25AF1985 ssa1985), /*
 */ endog(lg_rgdpch1965 lg_rgdpch1975 lg_rgdpch1985 av_kg1965 av_kg1975 av_kg1985 /*
 */ av_demo1965 av_demo1975 av_demo1985 av_2demo1965 av_2demo1975 av_2demo1985 /*
 */ av_ki1965 av_ki1975 av_ki1985) /*
 */ exog(IVlg_rgdpch1965 IVlg_rgdpch1975 IVlg_rgdpch1985 IVav_kg1965 IVav_kg1975 /*
 */ IVav_kg1985 IV_demo1965 IV_demo1975 IV_demo1985 IV_2demo1965 IV_2demo1975 /*
 */ IV_2demo1985 IVav_ki1965 IVav_ki1975 IVav_ki1985 up_sch_25AF1965 up_sch_25AF1975 /*
 */ up_sch_25AF1985 ssa1965 ssa1975 ssa1985) /*
 */ constr(1 2 3 4 5 6 7 8 9 10 /* 11 12 */ 13 14 15 16 17 18 19 20 21 22 23 24 25 26)

lincom up_sch_251965 + up_sch_25AF1965 /* not statistically signif. for Africa */

* Fourth, African countries only

keep if ssa1965==1 | ssa1975==1 | ssa1985==1

reg3 (av_grgdpch1965 lg_rgdpch1965 up_sch_251965 lf_WDI1965 lg_fertility1965 av_kg1965 /*
 */ /*rol1965*/ av_demo1965 av_2demo1965 av_ropenness1965 av_ki1965 av_inflation_c1965) /*
 */ (av_grgdpch1975 lg_rgdpch1975 up_sch_251975 lf_WDI1975 lg_fertility1975 av_kg1975 /*
 */ /*rol1975*/ av_demo1975 av_2demo1975 av_ropenness1975 av_ki1975 av_inflation_c1975) /*
 */ (av_grgdpch1985 lg_rgdpch1985 up_sch_251985 lf_WDI1985 lg_fertility1985 av_kg1985 /*
 */ /*rol1985*/ av_demo1985 av_2demo1985 av_ropenness1985 av_ki1985 av_inflation_c1985), /*
 */ endog(lg_rgdpch1965 lg_rgdpch1975 lg_rgdpch1985 av_kg1965 av_kg1975 av_kg1985 /*
 */ av_demo1965 av_demo1975 av_demo1985 av_2demo1965 av_2demo1975 av_2demo1985 /*
 */ av_ki1965 av_ki1975 av_ki1985) /*
 */ exog(IVlg_rgdpch1965 IVlg_rgdpch1975 IVlg_rgdpch1985 IVav_kg1965 IVav_kg1975 /*
 */ IVav_kg1985 IV_demo1965 IV_demo1975 IV_demo1985 IV_2demo1965 IV_2demo1975 /*
 */ IV_2demo1985 IVav_ki1965 IVav_ki1975 IVav_ki1985) /*
 */ constr(1 2 3 4 5 6 7 8 9 10 /* 11 12 */ 13 14 15 16 17 18 19 20 21 22)

/*

* See what sample sizes are when each equation is estimated separately. 

ivreg av_grgdpch1965 up_sch_251965 lf_WDI1965 lg_fertility1965 rol1965 av_ropenness1965 /*
 */ av_inflation_c1965 (lg_rgdpch1965 av_kg1965 av_demo1965 av_2demo1965 av_ki1965 = /*
 */ IVlg_rgdpch1965 IVav_kg1965 IV_demo1965 IV_2demo1965 IVav_ki1965)

ivreg av_grgdpch1975 up_sch_251975 lf_WDI1975 lg_fertility1975 rol1975 av_ropenness1975 /*
 */ av_inflation_c1975 (lg_rgdpch1975 av_kg1975 av_demo1975 av_2demo1975 av_ki1975 = /*
 */ IVlg_rgdpch1975 IVav_kg1975 IV_demo1975 IV_2demo1975 IVav_ki1975)

ivreg av_grgdpch1985 up_sch_251985 lf_WDI1985 lg_fertility1985 rol1985 av_ropenness1985 /*
 */ av_inflation_c1985 (lg_rgdpch1985 av_kg1985 av_demo1985 av_2demo1985 av_ki1985 = /*
 */ IVlg_rgdpch1985 IVav_kg1985 IV_demo1985 IV_2demo1985 IVav_ki1985)

*/

log close

