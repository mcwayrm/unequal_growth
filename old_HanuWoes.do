log using h:\intldata\AfricaEd\HanuWoes.log, replace text

* This program replicates Table 2 in Hanushek and Woessmann (2008)
* and adds some regressions that focus on Africa

use h:\intldata\AfricaEd\HanuWoes

* First, replicate their 4 regressions

reg ypcgr ypc60 ed60
reg ypcgr ypc60 ed60 tmeanmsagay 
xi: reg ypcgr ypc60 ed60 tmeanmsagay i.region
reg ypcgr ypc60 ed60 tmeanmsagay open exprop

* Second, add Africa variables

reg ypcgr ypc60 ed60 Africa Asia LatinAm Mideast
test Africa Asia LatinAm Mideast
reg ypcgr ypc60 ed60 tmeanmsagay Africa Asia LatinAm Mideast
test Africa Asia LatinAm Mideast

log close

