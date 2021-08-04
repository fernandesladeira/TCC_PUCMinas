clear all
set more off

use "C:\Users\Lenovo\Desktop\ArtigoPUC\CeTa\baseprod.dta", clear

sort identificador ano
foreach x of varlist tec esp grad mest doc {
by identificador ano, sort: gen `x'_nvals = _n == 1 if `x'==1
sort idunid ano
by idunid ano: egen cont_`x' = sum(`x'_nvals)
}


by identificador ano, sort: gen nvals = _n == 1
sort idunid ano
by idunid ano: egen numpesq = sum(nvals)

sort idunid ano

gen nvqtde = quantidade/10 if atividade=="Curso oferecido"|atividade=="Palestra"
replace quantidade= nvqtde if atividade=="Curso oferecido"|atividade=="Palestra"
drop nvqtde

gen str nome = "sede" if unidades=="SEDE BELO HORIZONTE"
replace  nome = "pitangui" if unidades=="CEPI PITANGUI"
replace  nome = "juiz de fora" if unidades=="EPAMIG ILCT JUIZ DE FORA"
replace  nome = "santa rita" if unidades=="CESR SANTA RITA"
replace  nome = "gorutuba" if unidades=="CEGR GORUTUBA"
replace  nome = "cela" if unidades=="CELA"
replace  nome = "uberaba" if unidades=="CEGT UBERABA"
replace  nome = "sudeste vicosa" if unidades=="EPAMIG SUDESTE VIÇOSA"
replace  nome = "felixlandia" if unidades=="CEFX  FELIXLÂNDIA"
replace  nome = "lambari" if unidades=="CELB LAMBARI"
replace  nome = "tres pontas" if unidades=="CETP TRÊS PONTAS"
replace  nome = "caldas" if unidades=="CECD CALDAS"
replace  nome = "maria da fe" if unidades=="CEMF MARIA DA FÉ"
replace  nome = "leopoldina" if unidades=="CELP LEOPOLDINA"
replace  nome = "patos de minas" if unidades=="CEST PATOS DE MINAS"
replace  nome = "acaua" if unidades=="CEAC ACAUA"
replace  nome = "sao joao del rei" if unidades=="CERN SAO JOAO DEL REI"
*replace  nome = "jaiba" if id == 23
replace  nome = "mocambinho" if unidades=="CEMO MOCAMBINHO"
replace  nome = "montes claros" if unidades=="CEMC MONTES CLAROS"

collapse(sum) quantidade (mean) numpesq cont* (first) tec esp grad mest doc (firstnm) codativ, ///
by(nome atividade ano)

move codativ atividade	

sort nome ano

by nome ano: egen o_ptc = sum(quantidade) if atividade=="Artigo em periódico indexado"|atividade=="Capítulo em livro técnico-científico"| ///
atividade=="Artigo em anais de congresso"|atividade=="Resumo em anais de congresso"|atividade=="Resumo em anais de congresso"

by nome ano: egen o_ppt = sum(quantidade) if atividade=="Sistema de produção"|atividade=="Circular técnica"| ///
atividade=="Comunicado técnico/recomendações técnicas"|atividade=="Boletim de pesquisa e desenvolvimento"|atividade=="Documentos"| ///
atividade=="Documentos"|atividade=="Organização/edição de livros"

by nome ano: egen o_dtpp = sum(quantidade) if atividade=="Cultivar gerada/lançada"|atividade=="Cultivar gerada/indicada"| ///
atividade=="Evento de elite"|atividade=="Prática/processo agropecuário"|atividade=="Raça/tipo"|atividade=="Insumo agropecuário"| ///
atividade=="Processo agroindustrial"|atividade=="Metodologia científica"|atividade=="Máquina, equipamento e instalação"| ///
atividade=="Estirpes"|atividade=="Monitaramento/zoneamento"|atividade=="Software"

by nome ano: egen o_ttpi = sum(quantidade) if atividade=="Dia de campo"|atividade=="Organização de eventos"| ///
atividade=="Participação em exposições e feiras"|atividade=="Palestra"|atividade=="Curso oferecido"|atividade=="Folder/folheto/cartilha produzidos"| ///
atividade=="Vídeo/DVD produzidos"|atividade=="Matéria jornalística"


collapse (sum) o_* (mean) numpesq cont*, by(nome ano)
egen id = group(nome)
xtset id ano

foreach x of varlist o_ptc o_ppt o_dtpp o_ttpi {
replace `x' = 0 if(`x'==.)
}


sort nome
foreach o of varlist o_ptc o_ppt o_dtpp o_ttpi {
by nome: egen med_`o' = mean(`o')	
}

by nome: gen denom = med_o_ptc+med_o_ppt+med_o_dtpp+med_o_ttpi

foreach o of varlist o_ptc o_ppt o_dtpp o_ttpi {
by nome: gen coef_`o' = `o'/denom
}

sort nome ano

by nome ano: gen y1 = coef_o_ptc*o_ptc
by nome ano: gen y2 = coef_o_ppt*o_ppt
by nome ano: gen y3 = coef_o_dtpp*o_dtpp
by nome ano: gen y4 = coef_o_ttpi*o_ttpi

by nome ano: gen o_y = (0.3*y1)+(0.3*y2)+(0.2*y3)+(0.2*y4) if nome!="pitangui"|nome!="juiz de fora"
by nome ano: replace o_y = (0.3*y1)+(0.1*y2)+(0.3*y3)+(0.3*y4) if nome=="pitangui"|nome=="juiz de fora"

drop id
save "C:\Users\Lenovo\Desktop\ArtigoPUC\CeTa\base_produtos.dta", replace
**************************************************************************************************************
