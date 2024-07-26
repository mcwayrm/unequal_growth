log using h:\intldata\africaed\paulreg, replace text
 
/* This program does some regressions for the Africa Educ.paper */

use h:\intldata\africaed\MRWwGINI.dta
reg lggl1985 lgngdelta lgIY lgSCHOOL if nsample==1

* See if school coefficient is significantly smaller for Africa
gen lgngdeltaAF = lgngdelta*asample
gen lgIYAF = lgIY*asample
gen lgSCHOOLAF = lgSCHOOL*asample

* It is VERY significantly lower
reg lggl1985 lgngdelta lgIY lgSCHOOL lgSCHOOLAF if nsample==1

* See what happens instead if one puts in only an Africa dummy variable
reg lggl1985 lgngdelta lgIY lgSCHOOL asample if nsample==1

* See what happens instead with an Africa dummy variable AND separate school slope.
reg lggl1985 lgngdelta lgIY lgSCHOOL asample lgSCHOOLAF if nsample==1

* Repeat above regression with pop. growth and investment, see if diff. is important.
reg lggl1985 lgngdelta lgIY lgSCHOOL asample lgngdeltaAF if nsample==1
reg lggl1985 lgngdelta lgIY lgSCHOOL asample lgIYAF if nsample==1

* Letting all parameters vary is less significant, but still jointly significant.
reg lggl1985 lgngdelta lgIY lgSCHOOL lgngdeltaAF lgIYAF lgSCHOOLAF /*
  */ asample if nsample==1
test lgngdeltaAF lgIYAF lgSCHOOLAF /* jointly significant at 5% level */
test lgngdeltaAF lgIYAF /* not jointly significant */
test lgSCHOOLAF lgIYAF
test lgngdeltaAF lgSCHOOLAF

* Let only lgIY and lgSCHOOL vary for African and non-African countries.
reg lggl1985 lgngdelta lgIY lgSCHOOL lgIYAF lgSCHOOLAF asample if nsample==1


* Separate estimates for African and non-African countries
reg lggl1985 lgngdelta lgIY lgSCHOOL if nsample==1 & asample==0
reg lggl1985 lgngdelta lgIY lgSCHOOL if nsample==1 & asample==1

stop

* Fix errors in colonial data

gen English=(country=="Botswana" | country=="Gambia, The" | country=="Ghana" /*
 */ | country=="Guinea" | country=="Kenya" | country=="Lesotho" | country=="Malawi" /*
 */ | country=="Mauritius" | country=="Namibie" | country=="Nigeria" /*
 */ | country=="S. Africa" | country=="Seychelles" | country=="Sierra Leone" /*
 */ | country=="Swaziland" | country=="Tanzania" | country=="Uganda" /*
 */ | country=="Zambia" | country=="Zimbabwe")

gen French=(country=="Benin" | country=="Burkina Faso" | country=="Cameroon" /*
 */ | country=="Central Afr. Rep." | country=="Chad" | country=="Congo, People. Rep" /*
 */ | country=="Ivory Coast" | country=="Madagascar" | country=="Mali" /*
 */ | country=="Mauritania" | country=="Niger" | country=="Senegal" /*
 */ | country=="Togo")

gen Belgian=(country=="Burundi" | country=="Rwanda") 

gen Portug=(country=="Angola" | country=="Guinee Bissau" | country=="Mozambique" /*
 */ | country=="Sao Tome & princ.")

* Former English colonies no longer so bad
gen lgSCHAF_UK = lgSCHOOLAF*English
reg lggl1985 lgngdelta lgIY lgSCHOOL lgSCHOOLAF lgSCHAF_UK if nsample==1



stop

* Using Woessman data, check if test scores have explanatory power
sort country
merge country using h:\intldata\africaed\Woessman
tab _m
l country if _m==2 /* None of these 8 are in Mankiw et al. data */
reg lggl1985 lgngdelta lgIY lgSCHOOL if nsample==1 & _m==3
reg lggl1985 lgngdelta lgIY lgSCHOOL cognitive if nsample==1 & _m==3

* They are significant if we include 3 oil producers
l country if nsample~=1 & _m==3 & cognitive~=. & lgngdelta~=.
reg lggl1985 lgngdelta lgIY lgSCHOOL if _m==3
reg lggl1985 lgngdelta lgIY lgSCHOOL cognitive if _m==3
clear

* Try to replicate Hanushek and Woessmann, 2008, Table 2.
use h:\intldata\africaed\sotoeduc.dta   /* From Cohen and Soto, 2007 */
drop if year~=1960
corr ty*  /* these are so highly correlated that is does not matter which we use */
keep country ty15
replace country="Central African Republic" if country=="Central African republic"
replace country="Cote d'Ivoire" if country=="Cote dIvoire"
replace country="Egypt, Arab Rep." if country=="Egypt"
replace country="Iran, Islamic Rep." if country=="Iran"
replace country="Korea, Rep." if country=="Korea"
replace country="Syrian Arab Republic" if country=="Syria"
replace country="Trinidad and Tobago" if country=="Trinidad & Tobago"
replace country="Venezuela, RB" if country=="Venezuela"
sort country

merge country using h:\intldata\wdigdppcdollar.dta /* from WDI data in h:\intldata */
tab _m
l country if _m==1
keep if _m==3 
keep country ty15 gdppc1960 gdppc1961 gdppc1965 gdppc1970 gdppc2000
replace country="Egypt" if country=="Egypt, Arab Rep."
replace country="Germany, Fed. Rep." if country=="Germany"
replace country="Iran" if country=="Iran, Islamic Rep."
replace country="Korea, Rep. of" if country=="Korea, Rep."
replace country="S. Africa" if country=="South Africa"
sort country
merge country using h:\Intldata\AfricaEd\Woessman.dta /* Woessmann's website */
tab _m

* Finally, the regressions
gen pcgrowth=((gdppc2000/gdppc1960)^(1/40)) - 1 
reg pcgrowth gdppc1960 ty15 if cognitive~=.
reg pcgrowth gdppc1960 ty15 cognitive

sort country
l country if pcgrowth~=. & gdppc1960~=. & ty15~=. & cognitive~=. /* the 42 obs. */ 
l country if pcgrowth==. & gdppc1960==. & ty15~=. & cognitive~=. /* the other 8? */

* Add some countries that are missing a few early years
replace pcgrowth=((gdppc2000/gdppc1965)^(1/35))-1 if country=="Australia"
replace pcgrowth=((gdppc2000/gdppc1970)^(1/30))-1 if country=="Germany, Fed. Rep." 
replace pcgrowth=((gdppc2000/gdppc1965)^(1/35))-1 if country=="Iran"
replace pcgrowth=((gdppc2000/gdppc1961)^(1/39))-1 if country=="Tunisia"

reg pcgrowth gdppc1965 ty15 if cognitive~=.
reg pcgrowth gdppc1965 ty15 cognitive

*check for interaction term
gen schxtest=ty15*cognitive
reg pcgrowth gdppc1965 ty15 cognitive schxtest /* no sign of interaction */


* Look for some variation for African countries 
gen africa=(country=="Ghana" | country=="Nigeria" | country=="S. Africa" /*
  */ | country=="Zimbabwe" | country=="Benin" | country=="Burkina Faso" /*
  */ | country=="Burundi" | country=="Cameroon" | country=="Cote d'Ivoire" /*
  */ | country=="Central African Republic" | country=="Gabon" /*
  */ | country=="Kenya" | country=="Madagascar" | country=="Malawi" /*
  */ | country=="Niger" | country=="Senegal" | country=="Sierra Leone" /*
  */ | country=="Sudan" | country=="Zambia")
gen ty15afr=ty15*africa
gen gdppc60afr=gdppc1960*africa

reg pcgrowth gdppc1960 ty15
reg pcgrowth gdppc1960 ty15 ty15afr
reg pcgrowth gdppc1960 ty15 ty15afr africa
reg pcgrowth gdppc1960 gdppc60afr ty15 ty15afr africa
reg pcgrowth gdppc1960 ty15 if africa~=1
reg pcgrowth gdppc1960 ty15 if africa==1

* Now check re test scores

gen cognafr=cognitive*africa
reg pcgrowth gdppc1960 ty15 cognitive
reg pcgrowth gdppc1960 ty15 cognitive cognafr
reg pcgrowth gdppc1960 ty15 cognitive cognafr africa
reg pcgrowth gdppc1960 ty15 cognitive africa

log close

