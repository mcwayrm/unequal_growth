log using h:\intldata\africaed\resource, replace text
 
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

* Next, merge in Sachs-Warner resource data (after getting names to match)
replace country=upper(country)
replace country="MYANMAR" if country=="BURMA"
replace country="CENTRAL AFR.R." if country=="CENTRAL AFR. REP."
replace country="CONGO" if country=="CONGO, PEOPLE. REP"
replace country="GAMBIA" if country=="GAMBIA, THE"
replace country="GERMANY, WEST" if country=="GERMANY, FED. REP."
replace country="KOREA, REP." if country=="KOREA, REP. OF"
replace country="PAPUA N.GUINEA" if country=="PAPUA NEW GUINEA"
replace country="SOUTH AFRICA" if country=="S. AFRICA"
replace country="WESTERN SAMOA" if country=="SAMOA (WESTERN SAMOA)"
replace country="SOLOMON IS." if country=="SOLOMON ISLANDS"
replace country="ST.KITTS&NEVIS" if country=="ST. KITTS AND NEVIS"
replace country="ST.LUCIA" if country=="ST. LUCIA"
replace country="ST.VINCENT&GRE" if country=="ST. VINCENT AND THE GRENADINES"
replace country="SURINAME" if country=="SURINAM"
replace country="SYRIA" if country=="SYRIAN ARAB REP."
replace country="TRINIDAD&TOBAGO" if country=="TRINIDAD & TOBAGO"
replace country="UNITED ARAB E." if country=="U. ARAB EMIRATES"
replace country="U.K." if country=="UNITED KINGDOM"
replace country="U.S.A." if country=="UNITED STATES"
replace country="VIET NAM" if country=="VIETNAM"

sort country
merge country using h:\intldata\africaed\Sachnr97.dta
tab _m
l country if _m==1
l country if _m==2
keep if _m==3
d,s
* Check means of Sachs and Warner natural resource variables
su sxp pxi70 snr
des sxp pxi70 snr

* Finally, try these on the MRW regressions

* Column 1 ... They are signficant, but no big change on educ. investment
reg lggl1985 lgngdelta lgIY lgSCHOOL sxp if nsample==1
reg lggl1985 lgngdelta lgIY lgSCHOOL pxi if nsample==1
reg lggl1985 lgngdelta lgIY lgSCHOOL snr if nsample==1

* Column 2 ... mostly significant, but no big change to educ or Africa dummy
reg lggl1985 lgngdelta lgIY lgSCHOOL asample sxp if nsample==1
reg lggl1985 lgngdelta lgIY lgSCHOOL asample pxi if nsample==1
reg lggl1985 lgngdelta lgIY lgSCHOOL asample snr if nsample==1

* Column 3 ...
reg lggl1985 lgngdelta lgIY lgSCHOOL asample lgSCHOOLAF sxp if nsample==1
reg lggl1985 lgngdelta lgIY lgSCHOOL asample lgSCHOOLAF pxi if nsample==1
reg lggl1985 lgngdelta lgIY lgSCHOOL asample lgSCHOOLAF snr if nsample==1



log close

