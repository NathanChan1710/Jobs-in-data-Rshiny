# install.packages(c("tidyverse", "dplyr", "tidyr", "ggplot2", "bslib", "openxlsx", "shiny"))

library(tidyverse)
library(dplyr)
library(tidyr)
library(ggplot2)
library(bslib)
library(openxlsx)
library(shiny)
library(plotly)
library(bsicons)
library(htmltools)
library(scales)
library(forcats)

#Chargement de la table  
setwd(dir=dirname(rstudioapi::getActiveDocumentContext()$path))
currentpath=getwd()
chemin <- getwd()

data <- read.xlsx(paste0(chemin,'/jobs_in_data_continent.xlsx'))

# Préparation des données de base
jobs_base <- data %>%
  select(-salary_currency, -salary)

# Ordre des niveaux d'expérience
experience_levels_order <- c("Entry-level", "Mid-level", "Senior", "Executive")

#########################################################################################################

# Création du thème avec la palette de couleurs (coolors.co)
theme <- bs_theme(
  bg = "#cae9ff",  # fond général
  fg = "#1b4965",  # texte principal
  primary = "#62b6cb",  # éléments principaux
  secondary = "#5fa8d3",  # éléments secondaires
  navbar_bg = "#1b4965"  # barre de navigation
)

# CSS pour personnaliser les éléments avec la palette de couleur

theme <- bs_add_rules(theme, 
                      "
  body {
    background: linear-gradient(135deg, #cae9ff 0%, #bee9e8 100%) !important;
    min-height: 100vh;
  }
  
  .navbar {
    background: linear-gradient(135deg, #1b4965 0%, #62b6cb 100%) !important;
    box-shadow: 0 2px 10px rgba(27, 73, 101, 0.3);
  }
  .navbar-nav > li > a {
    color: #cae9ff !important;
    font-weight: 500;
    transition: all 0.3s ease;
  }
  .navbar-nav > li > a:hover {
    background: linear-gradient(135deg, #62b6cb 0%, #5fa8d3 100%) !important;
    color: white !important;
    border-radius: 5px;
  }
  .navbar-brand {
    color: #bee9e8 !important;
    font-weight: bold;
    font-size: 1.4em;
  }
  
  .card {
    background: rgba(255, 255, 255, 0.95) !important;
    border: 1px solid #bee9e8 !important;
    border-radius: 12px !important;
    box-shadow: 0 4px 15px rgba(27, 73, 101, 0.1) !important;
    backdrop-filter: blur(10px);
  }
  
  .card-header {
    background: linear-gradient(135deg, #bee9e8 0%, #62b6cb 100%) !important;
    border-bottom: 2px solid #5fa8d3 !important;
    color: #1b4965 !important;
    font-weight: bold;
    border-radius: 12px 12px 0 0 !important;
  }
  
  .global-filters {
    background: linear-gradient(135deg, rgba(190, 233, 232, 0.8) 0%, rgba(98, 182, 203, 0.1) 100%);
    border: 2px solid #bee9e8;
    border-radius: 15px;
    padding: 20px;
    margin-bottom: 20px;
    box-shadow: 0 6px 20px rgba(27, 73, 101, 0.15);
    backdrop-filter: blur(5px);
    position: relative;
    z-index: 1000 !important;
  }
  
  .filter-row {
    display: flex;
    align-items: center;
    gap: 20px;
    flex-wrap: wrap;
  }
  
  .filter-item {
    min-width: 140px;
    flex: 1;
    position: relative;
    z-index: 1001 !important;
  }
  
  .filter-item label {
    font-size: 13px;
    font-weight: 700;
    margin-bottom: 4px;
    color: #1b4965;
    text-shadow: 0 1px 2px rgba(255,255,255,0.8);
  }
  
  .filter-item .form-select {
    height: 36px;
    font-size: 13px;
    padding: 6px 10px;
    border: 2px solid #bee9e8;
    border-radius: 8px;
    background: rgba(255, 255, 255, 0.9);
    color: #1b4965;
    transition: all 0.3s ease;
    position: relative;
    z-index: 1002 !important;
  }
  
  .filter-item .form-select:focus {
    border-color: #62b6cb;
    box-shadow: 0 0 0 0.2rem rgba(98, 182, 203, 0.25);
    z-index: 1003 !important;
  }
  
  /* Styles spécifiques pour les dropdowns de selectize */
  .selectize-dropdown {
    z-index: 1004 !important;
    position: absolute !important;
    background: white !important;
    border: 2px solid #bee9e8 !important;
    border-radius: 8px !important;
    box-shadow: 0 4px 15px rgba(27, 73, 101, 0.2) !important;
  }
  
  .selectize-dropdown-content {
    background: white !important;
    z-index: 1005 !important;
  }
  
  .selectize-dropdown .option {
    background: white !important;
    color: #1b4965 !important;
    padding: 8px 12px !important;
  }
  
  .selectize-dropdown .option:hover {
    background: #bee9e8 !important;
    color: #1b4965 !important;
  }
  
  .selectize-dropdown .option.active {
    background: #62b6cb !important;
    color: white !important;
  }
  
  /* Styles pour les menus déroulants Bootstrap standard */
  .dropdown-menu {
    z-index: 1004 !important;
    background: white !important;
    border: 2px solid #bee9e8 !important;
    border-radius: 8px !important;
    box-shadow: 0 4px 15px rgba(27, 73, 101, 0.2) !important;
  }
  
  .dropdown-item {
    color: #1b4965 !important;
    padding: 8px 12px !important;
  }
  
  .dropdown-item:hover {
    background: #bee9e8 !important;
    color: #1b4965 !important;
  }
  
  .btn-reset {
    height: 36px;
    font-size: 13px;
    font-weight: 600;
    padding: 6px 16px;
    margin-top: 20px;
    background: linear-gradient(135deg, #5fa8d3 0%, #62b6cb 100%);
    border: none;
    color: white;
    border-radius: 8px;
    transition: all 0.3s ease;
  }
  
  .btn-reset:hover {
    background: linear-gradient(135deg, #62b6cb 0%, #1b4965 100%);
    transform: translateY(-2px);
    box-shadow: 0 4px 15px rgba(27, 73, 101, 0.3);
  }
  
  .value-box {
    background: linear-gradient(135deg, rgba(255, 255, 255, 0.9) 0%, rgba(190, 233, 232, 0.3) 100%) !important;
    border: 2px solid #bee9e8 !important;
    border-radius: 12px !important;
    box-shadow: 0 4px 15px rgba(27, 73, 101, 0.1) !important;
  }
  
  .value-box .value-box-title {
    color: #1b4965 !important;
    font-weight: 600;
  }
  
  .value-box .value-box-value {
    color: #62b6cb !important;
    font-weight: bold;
  }
  
  /* Styles pour les graphiques - z-index plus bas */
  .plotly, .shiny-plot-output {
    border-radius: 8px;
    overflow: hidden;
    position: relative;
    z-index: 1 !important;
  }
  
  /* Les cartes contenant les graphiques */
  .card:not(.global-filters *) {
    z-index: 1 !important;
  }
  
  /* Animation d'entrée pour les cartes */
  .card {
    animation: slideInUp 0.6s ease-out;
  }
  
  @keyframes slideInUp {
    from {
      opacity: 0;
      transform: translateY(30px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }
  
  /* Amélioration de la lisibilité */
  h1, h2, h3, h4, h5, h6 {
    color: #1b4965 !important;
  }
  
  p, li {
    color: #1b4965 !important;
    line-height: 1.6;
  }
  
  strong {
    color: #62b6cb !important;
  }
  "
)

# Création de la navbar et des filtres
ui <- page_navbar(
  title = "WORKING IN DATA",
  theme = theme,
  nav_spacer(),
  
  # Filtres en haut
  div(class = "global-filters",
      div(class = "filter-row",
          div(class = "filter-item",
              tags$label("🌍 Continent"),
              selectInput("global_continent", NULL,
                          choices = NULL,
                          multiple = TRUE,
                          width = "100%")
          ),
          div(class = "filter-item",
              tags$label("💼 Titre du poste"),
              selectInput("global_job_title", NULL,
                          choices = NULL,
                          multiple = TRUE,
                          width = "100%")
          ),
          div(class = "filter-item",
              tags$label("🎓 Expérience"),
              selectInput("global_experience_level", NULL,
                          choices = NULL,
                          multiple = TRUE,
                          width = "100%")
          ),
          div(class = "filter-item",
              tags$label("🏠 Mode de travail"),
              selectInput("global_work_setting", NULL,
                          choices = NULL,
                          multiple = TRUE,
                          width = "100%")
          ),
          div(class = "filter-item",
              tags$label("🏢 Taille entreprise"),
              selectInput("global_company_size", NULL,
                          choices = NULL,
                          multiple = TRUE,
                          width = "100%")
          ),
          div(class = "filter-item",
              actionButton("reset_global_filters", "🔄 Reset", class = "btn-outline-secondary btn-reset")
          )
      )
  ),
  
  # Contenu des pages
  # Page de présentation du reporting
  nav_panel(
    title = "À propos de l'étude", 
    page_fillable(
      card(
        card_header("🔍 À propos de l'étude"),
        p("Dans le cadre de notre projet, nous avons décidé d'analyser l'évolution des métiers de la data dans le monde entre 2020 et 2023. Pour cela, nous avons utilisé une base de données disponible sur Kaggle, qui regroupe plus de 9300 lignes d'informations sur les salaires, les postes, les lieux de travail, le niveau d'expérience, etc.

L'idée derrière ce projet est de mieux comprendre les tendances autour des métiers de la data : quels sont les jobs les plus courants ? Où sont-ils les mieux payés ? Est-ce que le télétravail a un impact sur les salaires ? Ce sont toutes ces questions qu'on va explorer à travers ce dashboard.")
      ),
      card(
        card_header(" 🎯 Objectifs"),
        p("- Étudier l'évolution des métiers data sur les 4 dernières années (2020–2023)"
          ,br(), "- Identifier les postes les plus populaires dans le domaine (Data Analyst, Engineer, Scientist…)"
          ,br(), "- Comparer les salaires moyens selon les pays, les continents, l'expérience ou le type de contrat"
          ,br(), "- Voir l'impact du télétravail et des nouveaux modes de travail sur les rémunérations"
          ,br(), "- Aider les personnes qui veulent travailler dans la data à mieux s'orienter, que ce soit pour choisir une spécialité, un pays ou un type d'entreprise.")
      ),
      card(
        card_header("💡 Pourquoi on fait ça ?"),
        p("On est nous-mêmes des étudiants qui veulent bosser dans la data, donc on s'est dit que ce projet pouvait nous servir à nous… mais aussi à d'autres ! Grâce à ce dashboard, on peut avoir une vue d'ensemble des tendances du marché, se fixer des objectifs réalistes, savoir dans quels pays les salaires sont les plus élevés, ou quels types de postes sont les plus recherchés.")
      )
    )
  ),
  # Dashboard 1 
  nav_panel(
    title = "Dashboard 1",
    page_fillable(
      card(
        card_header("📊 Évolution des salaires et répartition par catégories"),
        layout_columns(
          col_width = c(6, 6),
          # Colonne de gauche avec les deux graphiques empilés
          div(
            card(
              card_header("Salaire moyen par continent"),
              plotOutput("plot_continent_evolution", height = "300px")
            ),
            card(
              card_header("Répartition du nombre de personnes par catégorie de travail"),
              plotOutput("plot_category_distribution", height = "300px")
            )
          ),
          # Colonne de droite avec le graphique des salaires par catégorie
          card(
            card_header("Salaire moyen par catégorie de métier"),
            plotOutput("plot_salary_by_category", height = "100px")
          )
        )
      )
    )
  ),
  # Dashboard 2
  nav_panel(
    title = "Dashboard 2",
    page_fillable(
      card(
        card_header("Analyse approfondie - Salaires dans la Data"),
        card(
        p("Cette carte thermique montre les salaires moyens pour les postes dans la data, 
            en fonction du niveau d'expérience, de la taille de l'entreprise et du mode de travail."),
          plotOutput("plot_heatmap", height = "700px")
        )
      )
    )
  ),
  # Dashboard 3
  nav_panel(
    title = "Dashboard 3",
    page_fillable(
      card(
        card_header("📈 Analyses complémentaires"),
        layout_columns(
          col_width = c(6, 6),
          # Colonne de gauche avec les deux camemberts
          div(
            card(
              card_header("Mode de travail"),
              plotOutput("plot_work_setting_pie", height = "300px")
            ),
            card(
              card_header("Taille des entreprises"),
              plotOutput("plot_company_size_pie", height = "300px")
            )
          ),
          # Colonne de droite avec le graphique en barres
          card(
            card_header("Répartition par niveau d'expérience"),
            plotOutput("plot_experience_levels", height = "750px")
          )
        )
      )
    )
  ),
  
  # La page "Nos données" avec un résumé des données utilisés
  nav_panel(
    title = "Nos données",
    page_fillable(
      layout_columns(
        col_width = 8,
        card(
          card_header("Liste des variables"),
          tags$ul(
            tags$li(strong("work_year"), " - Année"),
            tags$li(strong("job_title"), " - Titre du poste"),
            tags$li(strong("job_category"), " - Classification du métier"),
            tags$li(strong("salary_currency"), " - La devise du salaire perçu"),
            tags$li(strong("salary"), " - Montant salaire perçu"),
            tags$li(strong("salary_in_usd"), " - Salaire converti en dollar"),
            tags$li(strong("employee_residence"), " - Pays de résidence"),
            tags$li(strong("experience_level"), " - Niveau d'expérience"),
            tags$li(strong("employment_type"), " - Type de travail"),
            tags$li(strong("work_setting"), " - Mode de travail"),
            tags$li(strong("company_location"), " - Localisation de l'entreprise"),
            tags$li(strong("company_size"), " - Taille de l'entreprise"),
            tags$li(strong("Continent"), " - Continent de l'entreprise"),
          )
        ),
        
        col_width = 4,
        card(
          layout_columns(
            col_width = 6,
            value_box(
              title = "Lignes",
              value = textOutput("total_rows"),
              showcase = bsicons::bs_icon("table")
            ),
            
            value_box(
              title = "Variables",
              value = "13",
              showcase = bsicons::bs_icon("list-columns")
            )
          )
        )
      ),
      # Sources des données de Kaggle
      card(
        card_header("Sources de données"),
        p("kaggle : https://www.kaggle.com/datasets/hummaamqaasim/jobs-in-data/data ")
      )
    )
  )
)

# La partie du serveur
server <- function(input, output, session) {
  
  # Choix pour les filtres en haut
  observe({
    updateSelectInput(session, "global_continent",
                      choices = c("Tous" = "", sort(unique(jobs_base$continent))))
    updateSelectInput(session, "global_job_title",
                      choices = c("Tous" = "", sort(unique(jobs_base$job_title))))
    updateSelectInput(session, "global_experience_level",
                      choices = c("Tous" = "", experience_levels_order))
    updateSelectInput(session, "global_work_setting",
                      choices = c("Tous" = "", sort(unique(jobs_base$work_setting))))
    updateSelectInput(session, "global_company_size",
                      choices = c("Tous" = "", sort(unique(jobs_base$company_size))))
  })
  
  # Fonction pour filtrer les données sur toutes les pages en global
  filtered_data <- reactive({
    data_filtered <- jobs_base
    
    if (!is.null(input$global_continent) && length(input$global_continent) > 0 && !("" %in% input$global_continent)) {
      data_filtered <- data_filtered %>% filter(continent %in% input$global_continent)
    }
    if (!is.null(input$global_job_title) && length(input$global_job_title) > 0 && !("" %in% input$global_job_title)) {
      data_filtered <- data_filtered %>% filter(job_title %in% input$global_job_title)
    }
    if (!is.null(input$global_experience_level) && length(input$global_experience_level) > 0 && !("" %in% input$global_experience_level)) {
      data_filtered <- data_filtered %>% filter(experience_level %in% input$global_experience_level)
    }
    if (!is.null(input$global_work_setting) && length(input$global_work_setting) > 0 && !("" %in% input$global_work_setting)) {
      data_filtered <- data_filtered %>% filter(work_setting %in% input$global_work_setting)
    }
    if (!is.null(input$global_company_size) && length(input$global_company_size) > 0 && !("" %in% input$global_company_size)) {
      data_filtered <- data_filtered %>% filter(company_size %in% input$global_company_size)
    }
    
    return(data_filtered)
  })
  
  # Bouton de réinitialisation des filtres global
  observeEvent(input$reset_global_filters, {
    updateSelectInput(session, "global_continent", selected = "")
    updateSelectInput(session, "global_job_title", selected = "")
    updateSelectInput(session, "global_experience_level", selected = "")
    updateSelectInput(session, "global_work_setting", selected = "")
    updateSelectInput(session, "global_company_size", selected = "")
  })
  
  # Affichage du nombre total de lignes
  output$total_rows <- renderText({
    format(nrow(jobs_base), big.mark = " ")
  })
  
  # Graphique 1: Évolution du salaire moyen par continent
  output$plot_continent_evolution <- renderPlot({
    # On créer la table pour le graphique 
    data_plot <- filtered_data() %>%
      group_by(continent, work_year) %>%
      summarise(salaire_moyen_continent = mean(salary_in_usd, na.rm = TRUE), .groups = "drop")
    
    # Création du graphique
    ggplot(data = data_plot, aes(x = work_year, y = salaire_moyen_continent, group = continent, color = continent)) +
      geom_line(size = 1.2) +
      geom_point(size = 4) +
      theme_minimal() +
      theme(
        axis.text.x = element_text(angle = 45, hjust = 1, size = 14),
        axis.text.y = element_text(size = 14),
        legend.position = "none",
        plot.title = element_text(size = 16, face = "bold"),
        strip.text = element_text(size = 14, face = "bold"),
        axis.title = element_text(size = 14, face = "bold")
      ) +
      labs(
        x = "Année",
        y = "Salaire moyen en USD"
      ) +
      facet_wrap(~continent, scales = "free_y") +
      scale_y_continuous(labels = scales::number_format(scale = 1e-3, suffix = "k"))
  })
  
  # Graphique 2: Salaire moyen par catégorie de métier
  output$plot_salary_by_category <- renderPlot({
    # On créer la table pour le graphique 
    jobs_categ <- filtered_data() %>%
      group_by(job_category) %>%
      summarize(salaire_moyen_category = mean(salary_in_usd, na.rm = TRUE), .groups = "drop")
    
    # Création du graphique
    ggplot(data = jobs_categ, aes(x = fct_reorder(job_category, salaire_moyen_category), y = salaire_moyen_category)) +
      geom_bar(stat = 'identity', fill = "#62b6cb", width = 0.8, alpha = 0.8) +
      geom_text(aes(label = paste0(round(salaire_moyen_category / 1000), "k")), 
                vjust = -0.5, size = 5, color = "#1b4965", fontface = "bold") +
      theme_minimal() +
      theme(
        axis.text.x = element_text(angle = 45, hjust = 1, size = 14, color = "#1b4965"),
        axis.text.y = element_text(size = 14, color = "#1b4965"),
        plot.title = element_text(size = 16, face = "bold", color = "#1b4965"),
        axis.title = element_text(size = 14, face = "bold", color = "#1b4965"),
        panel.background = element_rect(fill = "white", color = NA),
        plot.background = element_rect(fill = "white", color = NA),
        panel.grid.major = element_line(color = "#bee9e8", size = 0.5),
        panel.grid.minor = element_line(color = "#cae9ff", size = 0.3)
      ) +
      labs(
        x = "Catégorie de métier",
        y = "Salaire moyen en USD"
      ) +
      scale_y_continuous(labels = scales::number_format(scale = 1e-3, suffix = "k"))
  })
  
  # Graphique 3: Répartition des personnes par catégorie
  output$plot_category_distribution <- renderPlot({
    # On créer la table pour le graphique 
    nb_categ <- filtered_data() %>%
      count(job_category)
    
    # Création du graphique
    ggplot(nb_categ, aes(x = fct_reorder(job_category, n), y = n)) +
      geom_col(fill = "#5fa8d3", alpha = 0.8) +
      geom_text(aes(label = n), hjust = -0.1, size = 5, color = "#1b4965", fontface = "bold") +
      labs(
        x = "Catégorie de travail",
        y = "Nombre de personnes"
        ) +
      theme_minimal() +
      theme(
        axis.text.x = element_text(size = 14, color = "#1b4965"),
        axis.text.y = element_text(size = 14, color = "#1b4965"),
        plot.title = element_text(size = 16, face = "bold", color = "#1b4965"),
        axis.title = element_text(size = 14, face = "bold", color = "#1b4965"),
        panel.background = element_rect(fill = "white", color = NA),
        plot.background = element_rect(fill = "white", color = NA),
        panel.grid.major = element_line(color = "#bee9e8", size = 0.5),
        panel.grid.minor = element_line(color = "#cae9ff", size = 0.3)
      ) +
      coord_flip()
  })
  
  # Graphique 4: Carte thermique
  output$plot_heatmap <- renderPlot({
    heatmap_data <- filtered_data() %>%
      filter(employment_type == 'Full-time')
    
    summary_table <- heatmap_data %>%
      group_by(work_setting, company_size, experience_level) %>%
      summarize(average_salary = round(mean(salary_in_usd)), .groups = "drop") %>%
      mutate(company_setting = paste(company_size, work_setting, sep = " - ")) %>%
      select(-company_size, -work_setting) %>% 
      select(company_setting, everything()) %>% 
      arrange(desc(average_salary))
    
    ggplot(summary_table, aes(x = experience_level, y = company_setting, fill = average_salary)) +
      geom_tile(color = "white", size = 1.2) +
      geom_text(aes(label = scales::number_format(accuracy = 1, scale = 1e-3, suffix = "k")(average_salary)), 
                vjust = 0.5, size = 5, fontface = "bold", color = "white") +
      scale_fill_gradient(low = "#bee9e8", high = "#1b4965", 
                          name = "Salaire moyen\nen USD", 
                          labels = scales::number_format(accuracy = 1, scale = 1e-3, suffix = "k")) +
      labs(
        x = "Niveau d'expérience",
        y = "Taille de l'entreprise / cadre de travail"
      ) +
      theme_minimal() +
      theme(
        axis.text.x = element_text(size = 14, face = "bold", color = "#1b4965"),
        axis.text.y = element_text(size = 14, face = "bold", color = "#1b4965"),
        plot.title = element_text(size = 16, face = "bold", color = "#1b4965"),
        plot.subtitle = element_text(size = 14, color = "#62b6cb"),
        legend.title = element_text(size = 14, color = "#1b4965"),
        legend.text = element_text(size = 12, color = "#1b4965"),
        axis.title = element_text(size = 14, face = "bold", color = "#1b4965"),
        panel.background = element_rect(fill = "white", color = NA),
        plot.background = element_rect(fill = "white", color = NA)
      )
  })
  
  # Graphique 5: Niveaux d'expérience
  output$plot_experience_levels <- renderPlot({
    data_analyst <- filtered_data() %>%
      filter(employment_type == 'Full-time')
    
    data_analyst$experience_level <- factor(data_analyst$experience_level, levels = experience_levels_order)
    
    experience_summary <- data_analyst %>%
      count(experience_level) %>%
      rename(frequency = n)
    
    # Couleurs dégradées pour chaque niveau d'expérience
    level_colors <- c("#cae9ff", "#bee9e8", "#5fa8d3", "#1b4965")
    
    ggplot(experience_summary, aes(x = experience_level, y = frequency, fill = experience_level)) +
      geom_bar(stat = "identity", position = "dodge", alpha = 0.8) +
      geom_text(aes(label = frequency), vjust = -0.3, size = 6, fontface = "bold", color = "#1b4965") +
      labs(
        x = "Niveau d'expérience",
        y = "Fréquence"
      ) +
      scale_fill_manual(values = level_colors) +
      theme_minimal() +
      theme(
        axis.text.x = element_text(size = 14, face = "bold", color = "#1b4965"),
        axis.text.y = element_text(size = 14, face = "bold", color = "#1b4965"),
        plot.title = element_text(size = 16, face = "bold", color = "#1b4965"),
        plot.subtitle = element_text(size = 14, color = "#62b6cb"),
        axis.title = element_text(size = 14, face = "bold", color = "#1b4965"),
        legend.position = "none",
        panel.background = element_rect(fill = "white", color = NA),
        plot.background = element_rect(fill = "white", color = NA),
        panel.grid.major = element_line(color = "#bee9e8", size = 0.5),
        panel.grid.minor = element_line(color = "#cae9ff", size = 0.3)
      )
  })
  
  # Graphique 6: Mode de travail graphique en Camembert
  output$plot_work_setting_pie <- renderPlot({
    full_time_data <- filtered_data() %>%
      filter(employment_type == 'Full-time')
    
    jd_ws <- full_time_data %>%
      count(work_setting) %>%
      mutate(percentage = n / sum(n) * 100)
    
    ggplot(data = jd_ws, aes(x = "", y = percentage, fill = work_setting)) +
      geom_col(width = 1, color = "white", size = 1) +
      coord_polar(theta = "y") +
      geom_text(aes(label = paste0(round(percentage, 1), "%"), x = 1.7),
                position = position_stack(vjust = 0.5), size = 5, fontface = "bold") +
      theme_void() +
      theme(
        axis.line = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        axis.title = element_blank(),
        plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
        legend.text = element_text(size = 12),
        legend.title = element_text(size = 14, face = "bold")
      ) +
      guides(fill = guide_legend(title = "Mode de travail"))
  })
  
  # Graphique 7: Taille des entreprises graphique en Camembert
  output$plot_company_size_pie <- renderPlot({
    full_time_data <- filtered_data() %>%
      filter(employment_type == 'Full-time')
    
    jd_cs <- full_time_data %>%
      count(company_size) %>%
      mutate(percentage = n / sum(n) * 100)
    
    ggplot(data = jd_cs, aes(x = "", y = percentage, fill = company_size)) +
      geom_col(width = 1, color = "white", size = 1) +
      coord_polar(theta = "y") +
      geom_text(aes(label = paste0(round(percentage, 1), "%"), x = 1.6),
                position = position_stack(vjust = 0.5), size = 5, fontface = "bold") +
      theme_void() +
      theme(
        axis.line = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        axis.title = element_blank(),
        plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
        legend.text = element_text(size = 12),
        legend.title = element_text(size = 14, face = "bold")
      ) +
      guides(fill = guide_legend(title = "Taille d'entreprise"))
  })
}

# Lancement du repporting Shiny
shinyApp(ui = ui, server = server)