library(dplyr)
library(ggplot2)
library(openxlsx)
library(forcats)
#Ici on rajoute la table de base qu'on va modif 
# jobs <- read.csv("Z:/BUT 2/SAE Composant Décisonnel/jobs_in_data.csv",sep = ";")

pays <- jobs %>% distinct(job_title)

# Europe
Europe <- c("Germany", "United Kingdom", "Spain", "Ireland", "Poland", "France", 
            "Netherlands", "Luxembourg", "Lithuania", "Portugal", "Gibraltar", 
            "Ukraine", "Slovenia", "Romania", "Greece", "Latvia", "Russia", 
            "Italy", "Estonia", "Czech Republic", "Denmark", "Sweden", 
            "Switzerland", "Andorra", "Austria", "Finland", "Croatia", 
            "Bosnia and Herzegovina", "Moldova", "Malta", "Armenia","Belgium")
# North America
North_America <- c("United States", "Canada", "Mexico", "Honduras", 
                   "Puerto Rico", "Bahamas")
# South America
South_America <- c("Brazil", "Colombia", "Argentina", "Chile", "Ecuador", 
                   "Uruguay", "Paraguay")
# Africa
Africa <- c("South Africa", "Nigeria", "Kenya", "Ghana", "Mauritius", "Algeria", 
            "Egypt", "Central African Republic")
# Asia
Asia <- c("India", "South Korea", "Pakistan", "Iran", "Israel", "Saudi Arabia", 
          "Qatar", "Turkey", "Iraq", "China", "Japan", "Philippines", "Indonesia", 
          "Thailand", "Singapore", "Malaysia", "United Arab Emirates")
# Oceania
Oceania <- c("Australia", "New Zealand", "Fiji", "American Samoa")

#Création des continents
jobs <- jobs %>%
  mutate(Continent = case_when(
    company_location %in% Oceania ~ "Oceania",
    company_location %in% Europe ~ "Europe",
    company_location %in% Asia ~ "Asia",
    company_location %in% Africa ~ "Africa",
    company_location %in% North_America ~ "North America",
    company_location %in% South_America ~ "South America",
    TRUE ~ NA_character_
    ))

write.xlsx(jobs, "Z:/BUT 2/SAE Composant Décisonnel/jobs_in_data_continent.xlsx")