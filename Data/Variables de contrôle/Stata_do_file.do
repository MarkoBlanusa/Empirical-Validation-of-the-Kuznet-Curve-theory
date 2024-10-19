
clear all

cd "C:\Users\marko\OneDrive\Bureau\Marko documents\Etudes\HEC 3ème\2ème semestre\Recherche Empirique en Management et en Economie\Données questions de recherche\Variables de contrôle"

// Corrélation et stats des. entre les variables de contrôle

correlate fossil_cons_perc Gini life_exp net_migr patent_app_residents tax_revenue_perc trade_pct_GDP unempl_national 

sum fossil_cons_perc Gini life_exp net_migr patent_app_residents tax_revenue_perc trade_pct_GDP unempl_national 

// Corrélation et stats des. entre les variables dépendantes

correlate C02_total_emissions ln_C02_total_emissions C02_index_1990 C02_index_2000 C02_emissions_percapita ln_C02_emissions_percapita

sum C02_total_emissions ln_C02_total_emissions C02_index_1990 C02_index_2000 C02_emissions_percapita ln_C02_emissions_percapita


// Corrélation et stats des. entre les variables indépendantes

correlate GDP_current_USD GDP_percapita_current_USD real_GDP_USD real_GDP_percapita_USD ln_GDP_current_USD ln_GDP_percapita_current_USD ln_real_GDP_USD ln_real_GDP_percapita_USD GDP_deflator

sum GDP_current_USD GDP_percapita_current_USD real_GDP_USD real_GDP_percapita_USD ln_GDP_current_USD ln_GDP_percapita_current_USD ln_real_GDP_USD ln_real_GDP_percapita_USD GDP_deflator

// Corrélation et stats des. entre les variables dépendantes et indépendantes

correlate C02_total_emissions ln_C02_total_emissions C02_index_1990 C02_index_2000 C02_emissions_percapita ln_C02_emissions_percapita GDP_current_USD GDP_percapita_current_USD real_GDP_USD real_GDP_percapita_USD ln_GDP_current_USD ln_GDP_percapita_current_USD ln_real_GDP_USD ln_real_GDP_percapita_USD GDP_deflator

sum C02_total_emissions ln_C02_total_emissions C02_index_1990 C02_index_2000 C02_emissions_percapita ln_C02_emissions_percapita GDP_current_USD GDP_percapita_current_USD real_GDP_USD real_GDP_percapita_USD ln_GDP_current_USD ln_GDP_percapita_current_USD ln_real_GDP_USD ln_real_GDP_percapita_USD GDP_deflator

// Corrélation et stats des. entre les variables indépendantes et var. de contrôle

correlate GDP_current_USD GDP_percapita_current_USD real_GDP_USD real_GDP_percapita_USD ln_GDP_current_USD ln_GDP_percapita_current_USD ln_real_GDP_USD ln_real_GDP_percapita_USD GDP_deflator fossil_cons_perc Gini life_exp net_migr patent_app_residents tax_revenue_perc trade_pct_GDP unempl_national

// Corrélation et stats des. entre les variables dépendantes et var. de contrôle

correlate C02_total_emissions ln_C02_total_emissions C02_index_1990 C02_index_2000 C02_emissions_percapita ln_C02_emissions_percapita fossil_cons_perc Gini life_exp net_migr patent_app_residents tax_revenue_perc trade_pct_GDP unempl_national


generate real_GDP_percapita_USD_squared = real_GDP_percapita_USD^2
generate ln_RGDPP2 = ln(real_GDP_percapita_USD_squared)

describe country_id

correlate ln_real_GDP_percapita ln_RGDPP2



