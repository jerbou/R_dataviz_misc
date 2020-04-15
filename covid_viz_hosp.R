# chargement des librairies
require(ggplot2)
require(ggpubr)
require(ggtheme)
require(readr)

# chargement des donnees ouvertes etalab ----------------------------------

# https://www.data.gouv.fr/fr/datasets/donnees-hospitalieres-relatives-a-lepidemie-de-covid-19/
# df_hosp <- read_delim("G:/00_data_ref/data_gouv_fr/covid19/donnees-hospitalieres-covid19-2020-03-27-19h10.csv",";", escape_double = FALSE, trim_ws = TRUE)
df_hosp <- read_delim("https://static.data.gouv.fr/resources/donnees-hospitalieres-relatives-a-lepidemie-de-covid-19/20200414-190013/donnees-hospitalieres-covid19-2020-04-14-19h00.csv", ";", escape_double = FALSE, trim_ws = TRUE)

df_quot <- read_delim("https://static.data.gouv.fr/resources/donnees-hospitalieres-relatives-a-lepidemie-de-covid-19/20200414-190015/donnees-hospitalieres-nouveaux-covid19-2020-04-14-19h00.csv", ";", escape_double = FALSE, trim_ws = TRUE)


# COG
dep <- read_csv("G:/00_data_ref/insee/COG/departement2020.csv")
reg <- read_csv("G:/00_data_ref/insee/COG/region2020.csv")

cog <- merge(dep, reg, by="reg", all.x = TRUE) # nouvo df

df_hospr <- merge(df_hosp, cog, by="dep", all.x = TRUE) # nouvo df
df_quotr <- merge(df_quot, cog, by="dep", all.x = TRUE) # nouvo df
dim(df_hosp)
dim(df_hospr)

df_hosp$dc_taux <- df_hosp$dc/df_hosp$hosp

efcum <- ggplot(subset(df_hospr, sexe==0)) + geom_bar(aes(x=jour, y=hosp,fill=ncc.y),stat="identity", width=1) + facet_wrap(ncc.y~.) +
  theme_light() + theme(legend.position = "none", axis.text.x = element_text(angle = 90, vjust = 0.5)) + gghighlight()+
  labs(x="date", y="Nb hosp", caption="Source:Santé Pulique France", title = "Nombre d'hospitalisations par journée (effectifs cumulés)")

efquot <- ggplot(df_quotr) + geom_bar(aes(x=jour, y=incid_hosp,fill=ncc.y),stat="identity", width=1) + facet_wrap(ncc.y~.) +
  theme_light()+ theme(legend.position = "none", axis.text.x = element_text(angle = 90, vjust = 0.5)) + gghighlight()+
  labs(x="date", y="Nb hosp", caption="Source:Santé Pulique France", title = "Nombre d'hospitalisations par journée (effectifs)")

ggpubr::ggarrange(efquot,efcum,  align = "v") 
