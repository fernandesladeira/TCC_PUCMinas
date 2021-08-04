clear all
set more off

//Importação e tratamento dataset insumos (capital, pessoal e custeio)
use "C:\Users\Lenovo\Desktop\ArtigoPUC\CeTa\BALANCETES POR FILIAL 2007 A 2017\basecontabil.dta", clear

collapse (mean) anterior debitos creditos saldoatual, by(id conta ano)

sort id ano
drop if id>34|id==1
by id ano: egen i_pessoal = sum(saldoatual) if conta==32201|conta==322040007|conta==32204008|conta==3101|conta==31050009|conta==31050010
by id ano: egen i_capital = sum(saldoatual) if conta==3107|conta==31040002|conta==331010005|conta==322040011|conta==322040012
by id ano: egen i_custeio = sum(saldoatual) if conta==3102|conta==3103|conta==31040001|conta==31040003|conta==31040004|conta==31040005| ///
conta==31040006|conta==31040007|conta==31040008|conta==31040009|conta==31040010|conta==31050001|conta==31050002|conta==31050003| ///
conta==31050004|conta==31050005|conta==31050006|conta==31050007|conta==31050008|conta==31050099|conta==3106| ///
conta==32202|conta==32203|conta==322040001|conta==322040002|conta==322040003|conta==322040004|conta==322040005|conta==322040006| ///
conta==322040010|conta==322040013|conta==322040014|conta==322040099
by id ano: egen receita = sum(saldoatual) if conta==41|conta==4105
by id ano: replace receita = 0 if receita ==.
by id ano: egen ded_rec = sum(saldoatual) if conta==412|conta==4106
by id ano: replace ded_rec = 0 if ded_rec ==.

keep if i_pessoal!=.|i_capital!=.|i_custeio!=.|rec!=.|ded_rec!=.

collapse (mean) i_* rec ded_rec, by(id ano)
by id ano: gen rec_liq = receita-ded_rec
foreach x of varlist i_* {
replace `x' = 0 if(`x'==.)
}

by id ano: replace i_custeio = i_custeio-rec_liq

gen str nome = "sede" if id == 1
replace  nome = "pitangui" if id == 2
replace  nome = "juiz de fora" if id == 3
replace  nome = "santa rita" if id == 4
replace  nome = "gorutuba" if id == 5
replace  nome = "cela" if id == 6
replace  nome = "uberaba" if id == 7
replace  nome = "sudeste vicosa" if id == 8
replace  nome = "felixlandia" if id == 9
replace  nome = "lambari" if id == 10
replace  nome = "arcos" if id == 11     
replace  nome = "tres pontas" if id == 12
replace  nome = "caldas" if id == 13
replace  nome = "sao sebastiao do paraiso" if id == 14
replace  nome = "maria da fe" if id == 15
replace  nome = "machado" if id == 16
replace  nome = "leopoldina" if id == 18
replace  nome = "vale do piranga" if id == 19
replace  nome = "patos de minas" if id == 20
replace  nome = "patrocinio" if id == 21
replace  nome = "acaua" if id == 22
replace  nome = "sao joao del rei" if id == 23
replace  nome = "jaiba" if id == 24
replace  nome = "mocambinho" if id == 25
replace  nome = "itabira" if id == 26
replace  nome = "pouso alegre" if id == 27
replace  nome = "pitangui" if id == 28
replace  nome = "uberlandia" if id == 29
replace  nome = "buritizeiro" if id == 30
replace  nome = "montes claros" if id == 31
replace  nome = "araxa" if id == 32
replace  nome = "dr silvio menicucci" if id == 33
replace  nome = "tres coracoes" if id == 34

xtset id ano
move nome ano

sort id ano

drop id
save "C:\Users\Lenovo\Desktop\ArtigoPUC\CeTa\BALANCETES POR FILIAL 2007 A 2017\base_insumos.dta", replace
**************************************************************************************************************
