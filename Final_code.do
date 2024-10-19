
clear all

set more off, permanently

use "C:\Users\...\Donnees.dta", clear

ssc install estout, replace
ssc install asdoc
ssc inst sepscatter

********************************************************************************
* NOS VARIABLES
********************************************************************************
//VARIABLE INDEPENDANTE
//Linéaire: ln_real_GDP_percapita
//quadratique: ln_RGDP_percapita_sq

//VARIABLE DEPENDANTE
//avec CO2: ln_CO2_emissions_percapita
//total: ln_GHG_percapita

//VARIABLES DE CONTROLE
//fossil_cons_perc life_exp net_migr patent_app_residents tax_revenue_perc trade_pct_GDP unempl_national clean_energy_percent pop_density_km2


********************************************************************************
// STATISTIQUES DESCRIPTIVES
********************************************************************************

// Corrélations

// variables dépendantes avec variable indépendante
asdoc correlate ln_CO2_emissions_percapita ln_real_GDP_percapita ln_RGDP_percapita_sq

asdoc correlate ln_GHG_percapita ln_real_GDP_percapita ln_RGDP_percapita_sq

// variable indépendante et variables de contrôle
asdoc correlate ln_real_GDP_percapita fossil_cons_perc life_exp net_migr patent_app_residents tax_revenue_perc trade_pct_GDP unempl_national clean_energy_percent pop_density_km2

//variables dépendantes avec 3 variables de contrôle
asdoc correlate ln_CO2_emissions_percapita fossil_cons_perc life_exp net_migr patent_app_residents tax_revenue_perc trade_pct_GDP unempl_national clean_energy_percent pop_density_km2

asdoc correlate ln_GHG_percapita fossil_cons_perc life_exp net_migr patent_app_residents tax_revenue_perc trade_pct_GDP unempl_national clean_energy_percent pop_density_km2

//variables dépendantes
asdoc correlate CO2_emissions_percapita GHG_percapita

********************************************************************************
// Tableaux descriptifs

// variables indépendantes
estpost tabstat ln_real_GDP_percapita ln_RGDP_percapita_sq, c(stat) stat(mean sd min max n)
esttab using "C:\Users\...\tab_var_indep.tex", replace cells("mean(fmt(%6.2fc)) sd(fmt(%6.2fc)) min max count") nonumber nomtitle nonote noobs label booktabs collabels("Mean" "SD" "Min" "Max" "N")


// variable dépendante 
estpost tabstat ln_CO2_emissions_percapita ln_GHG_percapita, c(stat) stat(mean sd min max n)
esttab using "C:\Users\...\tab_var_dep.tex", replace cells("mean(fmt(%6.2fc)) sd(fmt(%6.2fc)) min max count") nonumber nomtitle nonote noobs label booktabs collabels("Mean" "SD" "Min" "Max" "N")

// variables de contrôle
estpost tabstat fossil_cons_perc life_exp net_migr patent_app_residents tax_revenue_perc trade_pct_GDP unempl_national clean_energy_percent pop_density_km2, c(stat) stat(mean sd min max n)
esttab using "C:\Users\...\tab_VC.tex", replace cells("mean(fmt(%6.2fc)) sd(fmt(%6.2fc)) min max count") nonumber nomtitle nonote noobs label booktabs collabels("Mean" "SD" "Min" "Max" "N")

// variable indépendante sans log
estpost tabstat real_GDP_percapita_USD, c(stat) stat(mean sd min max n)
esttab using "C:\Users\...\tab_AD1.tex", replace cells("mean(fmt(%6.2fc)) sd(fmt(%6.2fc)) min max count") nonumber nomtitle nonote noobs label booktabs collabels("Mean" "SD" "Min" "Max" "N")

// variables dépendantes sans log
estpost tabstat CO2_emissions_percapita GHG_percapita, c(stat) stat(mean sd min max n)
esttab using "C:\Users\...\tab_AD2.tex", replace cells("mean(fmt(%6.2fc)) sd(fmt(%6.2fc)) min max count") nonumber nomtitle nonote noobs label booktabs collabels("Mean" "SD" "Min" "Max" "N")

estpost tabstat real_GDP_percapita_USD CO2_emissions_percapita GHG_percapita, by(country_id) c(stat) stat(mean sd min max n)
esttab using "C:\Users\...\tab_AD_country.tex", replace cells("mean(fmt(%6.2fc)) sd(fmt(%6.2fc)) min max count") nonumber nomtitle nonote noobs label booktabs collabels("Mean" "SD" "Min" "Max" "N")

********************************************************************************
// GRAPHIQUES CO2

//graphique des émissions de CO2 sur le PIB réel, régression globale
graph twoway scatter CO2_emissions_percapita real_GDP_percapita_USD, msize(vtiny) mcolor(black) || qfit CO2_emissions_percapita real_GDP_percapita_USD, lpattern(shortdash) ytitle("Emissions de CO2 par personne") xtitle("PIB par habitant") graphregion(color(white)) legend(off) name(EKC_CO2, replace) title("Courbe de Kuznets environnementale") //nodraw 

//graphique des émissions de CO2 sur le PIB réel, régression globale et par pays
graph twoway scatter CO2_emissions_percapita real_GDP_percapita_USD if real_GDP_percapita_USD > 0, msize(vtiny) mcolor(black) || qfit CO2_emissions_percapita real_GDP_percapita_USD, lwidth(large) lcolor(black) lwidth(medthick) || qfit CO2_emissions_percapita real_GDP_percapita_USD if country_id == 7, lcolor(red) lwidth(medthick) || qfit CO2_emissions_percapita real_GDP_percapita_USD if country_id == 8, lcolor(green) lwidth(medthick) || qfit CO2_emissions_percapita real_GDP_percapita_USD if country_id == 14, lcolor(purple) lwidth(medthick) || qfit CO2_emissions_percapita real_GDP_percapita_USD if country_id == 27, lcolor(pink) lwidth(medthick) || qfit CO2_emissions_percapita real_GDP_percapita_USD if country_id == 13, lcolor(blue) lwidth(medthick) ytitle("Emissions de CO2 par personne") xtitle("PIB par habitant") graphregion(color(white)) name(EKC_CO2_qfit, replace) legend(pos(1) col(1) ring(0)) legend(order(2 "tous les pays" 3 "Suisse" 4 "Chili" 5 "Espagne" 6 "Corée du Sud" 7 "Danemark")) title("Courbe de Kuznets environnementale") subtitle("avec les émissions de CO2") //nodraw

//autre forme du graphique
set scheme s1color
sepscatter CO2_emissions_percapita real_GDP_percapita_USD if country_id < 20, separate(country_id) legend(pos(1) col(1) ring(0)) ytitle("Emissions de CO2 par personne") xtitle("PIB par habitant") title("Courbe de Kuznets environnementale") graphregion(color(white)) name(EKC_CO2_sep1, replace) //nodraw

********************************************************************************
// GRAPHIQUES GES

//graphique des émissions de GES sur le PIB réel, régression globale
graph twoway scatter GHG_percapita real_GDP_percapita_USD, msize(vtiny) mcolor(black) || qfit GHG_percapita real_GDP_percapita_USD, lpattern(shortdash) ytitle("Emissions de gaz à effets de serre par personne (éq. CO2)") xtitle("PIB par habitant") graphregion(color(white)) legend(off) name(EKC_GHG, replace) title("Courbe de Kuznets environnementale") //nodraw

//graphique des émissions de GES sur le PIB réel, régression globale et par pays
graph twoway scatter GHG_percapita real_GDP_percapita_USD if real_GDP_percapita_USD > 0, msize(vtiny) mcolor(black) || qfit GHG_percapita real_GDP_percapita_USD, lwidth(large) lcolor(black) lwidth(medthick) || qfit GHG_percapita real_GDP_percapita_USD if country_id == 7, lcolor(red) lwidth(medthick) || qfit GHG_percapita real_GDP_percapita_USD if country_id == 8, lcolor(green) lwidth(medthick) || qfit GHG_percapita real_GDP_percapita_USD if country_id == 14, lcolor(purple) lwidth(medthick) || qfit GHG_percapita real_GDP_percapita_USD if country_id == 27, lcolor(pink) lwidth(medthick) || qfit GHG_percapita real_GDP_percapita_USD if country_id == 13, lcolor(blue) lwidth(medthick) ytitle("Emissions de GES par personne (éq. CO2)") xtitle("PIB par habitant") graphregion(color(white)) name(EKC_GHG_qfit, replace) legend(pos(1) col(1) ring(0)) legend(order(2 "tous les pays" 3 "Suisse" 4 "Chili" 5 "Espagne" 6 "Corée du Sud" 7 "Danemark")) title("Courbe de Kuznets environnementale") subtitle("avec les émissions de GES") //nodraw

********************************************************************************
// Régressions des graphiques

generate real_GDP_percapita_USD_square = real_GDP_percapita_USD^2

// Régression globale des émissions de CO2 sur le PIB réel 
regress CO2_emissions_percapita real_GDP_percapita_USD real_GDP_percapita_USD_square, robust
estimates store regression1

// Régression globale des émissions de GES sur le PIB réel
regress GHG_percapita real_GDP_percapita_USD real_GDP_percapita_USD_square, robust
estimates store regression2

esttab regression1 regression2 using "C:\Users\...\reg_AD.tex", replace se star(* 0.1 ** 0.05 *** 0.01) mtitle("CO2" "GES")

********************************************************************************
// TEST DE HAUSMANN (alpha i souvent corrélé avec x donc utiliser quand même les fe (re trop restrictif))
********************************************************************************

// Linéaire CO2
xtreg ln_CO2_emissions_percapita ln_real_GDP_percapita, re
	estimate store re_CO2_realGDP1
xtreg ln_CO2_emissions_percapita ln_real_GDP_percapita, fe
	estimate store fe_CO2_realGDP1
hausman fe_CO2_realGDP1 re_CO2_realGDP1, sigmaless
// -> rejet H0 à tous les seuils -> préfère FE

// Linéaire GES
xtreg ln_GHG_percapita ln_real_GDP_percapita, re
	estimate store re_GHG_realGDP1
xtreg ln_GHG_percapita ln_real_GDP_percapita, fe
	estimate store fe_GHG_realGDP1
hausman fe_GHG_realGDP1 re_GHG_realGDP1, sigmaless
// -> rejet H0 à tous les seuils -> préfère FE

// Linéaire, VC, CO2
xtreg ln_CO2_emissions_percapita ln_real_GDP_percapita fossil_cons_perc life_exp net_migr patent_app_residents tax_revenue_perc trade_pct_GDP unempl_national pop_density_km2, re
	estimate store re_CO2_realGDP2
xtreg ln_CO2_emissions_percapita ln_real_GDP_percapita fossil_cons_perc life_exp net_migr patent_app_residents tax_revenue_perc trade_pct_GDP unempl_national pop_density_km2, fe
	estimate store fe_CO2_realGDP2
hausman fe_CO2_realGDP2 re_CO2_realGDP2, sigmaless
// -> rejet H0 à tous les seuils -> préfère FE

// Linéaire, VC, GES
xtreg ln_GHG_percapita ln_real_GDP_percapita fossil_cons_perc life_exp net_migr patent_app_residents tax_revenue_perc trade_pct_GDP unempl_national pop_density_km2, re
	estimate store re_GHG_realGDP2
xtreg ln_GHG_percapita ln_real_GDP_percapita fossil_cons_perc life_exp net_migr patent_app_residents tax_revenue_perc trade_pct_GDP unempl_national pop_density_km2, fe
	estimate store fe_GHG_realGDP2
hausman fe_GHG_realGDP2 re_GHG_realGDP2, sigmaless
// -> rejet H0 à tous les seuils -> préfère FE

// QUADRATIQUE, CO2
xtreg ln_CO2_emissions_percapita ln_real_GDP_percapita ln_RGDP_percapita_sq, re
	estimate store re_CO2_realGDP3
xtreg ln_CO2_emissions_percapita ln_real_GDP_percapita ln_RGDP_percapita_sq, fe
	estimate store fe_CO2_realGDP3
hausman fe_CO2_realGDP3 re_CO2_realGDP3, sigmaless
// -> rejet H0 à tous les seuils -> préfère FE

// QUADRATIQUE, GES
xtreg ln_GHG_percapita ln_real_GDP_percapita ln_RGDP_percapita_sq, re
	estimate store re_GHG_realGDP3
xtreg ln_GHG_percapita ln_real_GDP_percapita ln_RGDP_percapita_sq, fe
	estimate store fe_GHG_realGDP3
hausman fe_GHG_realGDP3 re_GHG_realGDP3, sigmaless
// -> rejet H0 à tous les seuils -> préfère FE

// QUADRATIQUE, VC, CO2
xtreg ln_CO2_emissions_percapita ln_real_GDP_percapita ln_RGDP_percapita_sq fossil_cons_perc life_exp net_migr patent_app_residents tax_revenue_perc trade_pct_GDP unempl_national pop_density_km2, fe
	estimate store fe_CO2_realGDP4
xtreg ln_CO2_emissions_percapita ln_real_GDP_percapita ln_RGDP_percapita_sq fossil_cons_perc life_exp net_migr patent_app_residents tax_revenue_perc trade_pct_GDP unempl_national pop_density_km2, re
	estimate store re_CO2_realGDP4
hausman fe_CO2_realGDP4 re_CO2_realGDP4, sigmaless
// -> rejet H0 à tous les seuils -> préfère FE

// QUADRATIQUE, VC, GES
xtreg ln_GHG_percapita ln_real_GDP_percapita ln_RGDP_percapita_sq fossil_cons_perc life_exp net_migr patent_app_residents tax_revenue_perc trade_pct_GDP unempl_national pop_density_km2, fe
	estimate store fe_GHG_realGDP4
xtreg ln_GHG_percapita ln_real_GDP_percapita ln_RGDP_percapita_sq fossil_cons_perc life_exp net_migr patent_app_residents tax_revenue_perc trade_pct_GDP unempl_national pop_density_km2, re
	estimate store re_GHG_realGDP4
hausman fe_GHG_realGDP4 re_GHG_realGDP4, sigmaless
// -> rejet H0 à tous les seuils -> préfère FE

********************************************************************************
// Analyse des régressions
********************************************************************************

// ANALYSE AVEC VARIABLE DEPENDANTE = EMISSIONS DE CO2

// REGRESSION SANS EFFETS FIXES; FORME LINEAIRE

// SANS VAR DE CONTROLE

regress ln_CO2_emissions_percapita ln_real_GDP_percapita, vce(cluster country_id)

estimates store reg1

// AVEC VAR DE CONTROLE

regress ln_CO2_emissions_percapita ln_real_GDP_percapita fossil_cons_perc life_exp net_migr patent_app_residents tax_revenue_perc trade_pct_GDP unempl_national pop_density_km2, vce(cluster country_id)

estimates store reg2

// REGRESSION SANS EFFETS FIXES; FORME QUADRATIQUE

// SANS VAR DE CONTROLE
regress ln_CO2_emissions_percapita ln_real_GDP_percapita ln_RGDP_percapita_sq, vce(cluster country_id)

estimates store reg3

// AVEC VAR DE CONTROLE
regress ln_CO2_emissions_percapita ln_real_GDP_percapita ln_RGDP_percapita_sq fossil_cons_perc life_exp net_migr patent_app_residents tax_revenue_perc trade_pct_GDP unempl_national pop_density_km2, vce(cluster country_id)

estimates store reg4

esttab reg1 reg2 reg3 reg4 using "C:\Users\...\reg_CO2_pooled.tex", replace se star(* 0.1 ** 0.05 *** 0.01) mtitle("Linéaire" "Linéaire" "Quadratique" "Quadratique") title("Régressions 'pooled' des émissions de CO2 sans effet fixe") note(Note : Ce tableau contient les coefficients de régression pour les émissions de CO2, en utilisant les clusters et avec/sans variable de contrôle. Les écarts-type sont entre parenthèses. Les données proviennent du site de l'OCDE et de la World Bank (1990-2018).)


********************************************************************************
// ANALYSE AVEC VARIABLE DEPENDANTE = EMISSIONS GAZ A EFFETS DE SERRE TOTALES (EQ. CO2)

// REGRESSION SANS EFFETS FIXES; FORME LINEAIRE

// SANS VAR DE CONTROLE

regress ln_GHG_percapita ln_real_GDP_percapita, vce(cluster country_id)

estimates store reg9

// AVEC VAR DE CONTROLE

regress ln_GHG_percapita ln_real_GDP_percapita fossil_cons_perc life_exp net_migr patent_app_residents tax_revenue_perc trade_pct_GDP unempl_national pop_density_km2, vce(cluster country_id)

estimates store reg10

// REGRESSION SANS EFFETS FIXES; FORME QUADRATIQUE

// SANS VAR DE CONTROLE
regress ln_GHG_percapita ln_real_GDP_percapita ln_RGDP_percapita_sq, vce(cluster country_id)

estimates store reg11

// AVEC VAR DE CONTROLE
regress ln_GHG_percapita ln_real_GDP_percapita ln_RGDP_percapita_sq fossil_cons_perc life_exp net_migr patent_app_residents tax_revenue_perc trade_pct_GDP unempl_national pop_density_km2, vce(cluster country_id)

estimates store reg12

esttab reg9 reg10 reg11 reg12 using "C:\Users\...\reg_GHG_pooled.tex", replace se star(* 0.1 ** 0.05 *** 0.01) mtitle("Linéaire" "Linéaire" "Quadratique" "Quadratique") title(Régressions "pooled" des émissions de GES sans effet fixe) note(Ce tableau contient les coefficients de régression pour les émissions de GHG, en utilisant les clusters et avec/sans variable de contrôle. Les écarts-type sont entre parenthèses. Les données proviennent du site de l'OCDE et de la World Bank (1990-2018).)


********************************************************************************
// EFFETS FIXES

// ANALYSE AVEC CO2

// REGRESSION AVEC EFFETS FIXES; FORME Linéaire
xtset country_id year
xtdescribe
// -> dataset strongly balanced (100% balanced)


// SANS VAR DE CONTROLE
xtreg ln_CO2_emissions_percapita ln_real_GDP_percapita, fe vce(cluster country_id)

estimates store reg25

// AVEC VAR DE CONTROLE
xtreg ln_CO2_emissions_percapita ln_real_GDP_percapita fossil_cons_perc life_exp net_migr patent_app_residents tax_revenue_perc trade_pct_GDP unempl_national pop_density_km2, fe vce(cluster country_id)

estimates store reg26

//REGRESSION AVEC EFFETS FIXES; FORME QUADRATIQUE

// SANS VAR DE CONTROLE
xtreg ln_CO2_emissions_percapita ln_real_GDP_percapita ln_RGDP_percapita_sq, fe vce(cluster country_id)

estimates store reg27

// AVEC VAR DE CONTROLE
xtreg ln_CO2_emissions_percapita ln_real_GDP_percapita ln_RGDP_percapita_sq fossil_cons_perc life_exp net_migr patent_app_residents tax_revenue_perc trade_pct_GDP unempl_national pop_density_km2, fe vce(cluster country_id)

estimates store reg28

esttab reg25 reg26 reg27 reg28 using "C:\Users\...\reg_CO2_fe.tex", replace se star(* 0.1 ** 0.05 *** 0.01) mtitle("Linéaire" "Linéaire" "Quadratique" "Quadratique") title(Régressions des émissions de CO2 avec effets fixes et clustering) note(Ce tableau contient les coefficients de régression pour les émissions de CO2, en utilisant les clusters et avec/sans variable de contrôle. Les écarts-type sont entre parenthèses. Les données proviennent du site de l'OCDE et de la World Bank (1990-2018).)


********************************************************************************
// EFFETS TEMPORELS

// REGRESSION AVEC EFFETS FIXES + TEMPORELS; FORME LINEAIRE

// SANS VAR DE CONTROLE
xtreg ln_CO2_emissions_percapita ln_real_GDP_percapita i.year, fe vce(cluster country_id)

estimates store reg29

// AVEC VAR DE CONTROLE
xtreg ln_CO2_emissions_percapita ln_real_GDP_percapita fossil_cons_perc life_exp net_migr patent_app_residents tax_revenue_perc trade_pct_GDP unempl_national pop_density_km2 i.year, fe vce(cluster country_id)

estimates store reg30

//REGRESSION AVEC EFFETS FIXES + TEMPORELS; FORME QUADRATIQUE

// SANS VAR DE CONTROLE
xtreg ln_CO2_emissions_percapita ln_real_GDP_percapita ln_RGDP_percapita_sq i.year, fe vce(cluster country_id)

estimates store reg31

// AVEC VAR DE CONTROLE
xtreg ln_CO2_emissions_percapita ln_real_GDP_percapita ln_RGDP_percapita_sq fossil_cons_perc life_exp net_migr patent_app_residents tax_revenue_perc trade_pct_GDP unempl_national pop_density_km2 i.year, fe vce(cluster country_id)

estimates store reg32

esttab reg29 reg30 reg31 reg32 using "C:\Users\...\reg_CO2_fete.tex", replace se star(* 0.1 ** 0.05 *** 0.01) mtitle("Linéaire" "Linéaire" "Quadratique" "Quadratique") keep(ln_real_GDP_percapita_USD ln_RGDP_percapita_sq fossil_cons_perc life_exp net_migr patent_app_residents tax_revenue_perc trade_pct_GDP unempl_national pop_density_km2) title(Régressions des émissions de CO2 avec effets fixes, effets temporels et clustering) note(Ce tableau contient les coefficients de régression pour les émissions de CO2, en utilisant les clusters, avec effets fixes, effets temporels et avec/sans variable de contrôle. Les écarts-type sont entre parenthèses. Certains coeffients ont été retirés. Les données proviennent du site de l'OCDE et de la World Bank (1990-2018).)


********************************************************************************
// ANALYSE AVEC GHG

// REGRESSION AVEC EFFETS FIXES; FORME Linéaire

// SANS VAR DE CONTROLE
xtreg ln_GHG_percapita ln_real_GDP_percapita, fe vce(cluster country_id)

estimates store reg33

// AVEC VAR DE CONTROLE
xtreg ln_GHG_percapita ln_real_GDP_percapita fossil_cons_perc life_exp net_migr patent_app_residents tax_revenue_perc trade_pct_GDP unempl_national pop_density_km2, fe vce(cluster country_id)

estimates store reg34

// REGRESSION AVEC EFFETS FIXES; FORME QUADRATIQUE

// SANS VAR DE CONTROLE
xtreg ln_GHG_percapita ln_real_GDP_percapita ln_RGDP_percapita_sq, fe vce(cluster country_id)

estimates store reg35

// AVEC VAR DE CONTROLE
xtreg ln_GHG_percapita ln_real_GDP_percapita ln_RGDP_percapita_sq fossil_cons_perc life_exp net_migr patent_app_residents tax_revenue_perc trade_pct_GDP unempl_national pop_density_km2, fe vce(cluster country_id)

estimates store reg36

esttab reg33 reg34 reg35 reg36 using "C:\Users\...\reg_GHG_fe.tex", replace se star(* 0.1 ** 0.05 *** 0.01) mtitle("Linéaire" "Linéaire" "Quadratique" "Quadratique") title(Régressions des émissions de GES avec effets fixes et clustering) note(Ce tableau contient les coefficients de régression pour les émissions de GES, en utilisant les clusters et avec/sans variable de contrôle. Les écarts-type sont entre parenthèses. Les données proviennent du site de l'OCDE et de la World Bank (1990-2018).)

****************************************************************************
//REGRESSION AVEC EFFETS FIXES + TEMPORELS; FORME Linéaire

// SANS VAR DE CONTROLE
xtreg ln_GHG_percapita ln_real_GDP_percapita i.year, fe vce(cluster country_id)

estimates store reg37

// AVEC VAR DE CONTROLE
xtreg ln_GHG_percapita ln_real_GDP_percapita fossil_cons_perc life_exp net_migr patent_app_residents tax_revenue_perc trade_pct_GDP unempl_national pop_density_km2 i.year, fe vce(cluster country_id)

estimates store reg38

//REGRESSION AVEC EFFETS FIXES + TEMPORELS; FORME QUADRATIQUE

// SANS VAR DE CONTROLE
xtreg ln_GHG_percapita ln_real_GDP_percapita ln_RGDP_percapita_sq i.year, fe vce(cluster country_id)

estimates store reg39

// AVEC VAR DE CONTROLE
xtreg ln_GHG_percapita ln_real_GDP_percapita ln_RGDP_percapita_sq fossil_cons_perc life_exp net_migr patent_app_residents tax_revenue_perc trade_pct_GDP unempl_national pop_density_km2 i.year, fe vce(cluster country_id)

estimates store reg40

esttab reg37 reg38 reg39 reg40 using "C:\Users\...\reg_GHG_fete.tex", replace se star(* 0.1 ** 0.05 *** 0.01) mtitle("Linéaire" "Linéaire" "Quadratique" "Quadratique") keep(ln_real_GDP_percapita_USD ln_RGDP_percapita_sq fossil_cons_perc life_exp net_migr patent_app_residents tax_revenue_perc trade_pct_GDP unempl_national pop_density_km2) title(Régressions des émissions de GES avec effets fixes, effets temporels et clustering) note(Ce tableau contient les coefficients de régression pour les émissions de GES, en utilisant les clusters, avec effets fixes, effets temporels et avec/sans variable de contrôle. Les écarts-type sont entre parenthèses. Certains coeffients ont été retirés. Les données proviennent du site de l'OCDE et de la World Bank (1990-2018).)


********************************************************************************
// TABLEAUX RESUME
********************************************************************************

esttab reg28 reg36 reg32 reg40 using "C:\Users\...\tab_resume_quadra.tex", replace se star(* 0.1 ** 0.05 *** 0.01) mtitle("CO2, fixes" "GES, fixes" "CO2, fixes/temporels" "GES, fixes/temporels") keep(ln_real_GDP_percapita_USD ln_RGDP_percapita_sq fossil_cons_perc life_exp net_migr patent_app_residents tax_revenue_perc trade_pct_GDP unempl_national pop_density_km2) title(Comparaison des coefficients avec/sans effet temporel) note(Ce tableau résume les coefficients de régression pour les régressions quadratiques des émissions de CO2 et de GES, en utilisant les clusters, variables de contrôle, effets fixes et avec/sans effet temporel. Les écarts-type sont entre parenthèses. Certains coeffients ont été retirés. Les données proviennent du site de l'OCDE et de la World Bank (1990-2018).)

esttab reg26 reg34 reg30 reg38 using "C:\Users\...\tab_resume_lin.tex", replace se star(* 0.1 ** 0.05 *** 0.01) mtitle("CO2, fixes" "GES, fixes" "CO2, fixes/temporels" "GES, fixes/temporels") keep(ln_real_GDP_percapita_USD fossil_cons_perc life_exp net_migr patent_app_residents tax_revenue_perc trade_pct_GDP unempl_national pop_density_km2) title(Comparaison des coefficients avec/sans effet temporel) note(Ce tableau résume les coefficients de régression pour les régressions linéaires des émissions de CO2 et de GES, en utilisant les clusters, variables de contrôle, effets fixes et avec/sans effet temporel. Les écarts-type sont entre parenthèses. Certains coeffients ont été retirés. Les données proviennent du site de l'OCDE et de la World Bank (1990-2018).)

esttab reg30 reg38 reg32 reg40 using "C:\Users\...\tab_resume_lin_quadra.tex", replace se star(* 0.1 ** 0.05 *** 0.01) mtitle("CO2, Linéaire" "GES, Linéaire" "CO2, Quadratique" "GES, Quadratique") keep(ln_real_GDP_percapita_USD ln_RGDP_percapita_sq fossil_cons_perc life_exp net_migr patent_app_residents tax_revenue_perc trade_pct_GDP unempl_national pop_density_km2) title(Comparaison des coefficients pour les régressions linéaires et quadratiques) note(Ce tableau résume les coefficients de régression pour les régressions linéaires et quadratiques des émissions de CO2 et de GES, en utilisant les clusters, variable de contrôle, effets fixes et effets temporels. Les écarts-type sont entre parenthèses. Certains coeffients ont été retirés. Les données proviennent du site de l'OCDE et de la World Bank (1990-2018).)


********************************************************************************
// obtention des R2
********************************************************************************

// CO2, FE, QUADRATIQUE, VC, clustering
areg ln_CO2_emissions_percapita ln_real_GDP_percapita ln_RGDP_percapita_sq fossil_cons_perc life_exp net_migr patent_app_residents tax_revenue_perc trade_pct_GDP unempl_national pop_density_km2, vce(cluster country_id) absorb(country_id)

// GHG, FE, QUADRATIQUE, VC, clustering
areg ln_GHG_percapita ln_real_GDP_percapita ln_RGDP_percapita_sq fossil_cons_perc life_exp net_migr patent_app_residents tax_revenue_perc trade_pct_GDP unempl_national pop_density_km2, vce(cluster country_id) absorb(country_id)

// CO2, FE + TE, QUADRATIQUE, VC, clustering
areg ln_CO2_emissions_percapita ln_real_GDP_percapita ln_RGDP_percapita_sq fossil_cons_perc life_exp net_migr patent_app_residents tax_revenue_perc trade_pct_GDP unempl_national pop_density_km2 i.year, vce(cluster country_id) absorb(country_id)

// GHG, FE + TE, QUADRATIQUE, VC, clustering
areg ln_GHG_percapita ln_real_GDP_percapita ln_RGDP_percapita_sq fossil_cons_perc life_exp net_migr patent_app_residents tax_revenue_perc trade_pct_GDP unempl_national pop_density_km2 i.year, vce(cluster country_id) absorb(country_id)


********************************************************************************

save "C:\Users\...\Données_modifiées.dta", replace

