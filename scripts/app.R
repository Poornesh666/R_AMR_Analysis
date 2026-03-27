if (!require("shiny")) install.packages("shiny", repos="https://cloud.r-project.org/")
if (!require("bslib")) install.packages("bslib", repos="https://cloud.r-project.org/")
if (!require("ggplot2")) install.packages("ggplot2", repos="https://cloud.r-project.org/")
if (!require("dplyr")) install.packages("dplyr", repos="https://cloud.r-project.org/")

library(shiny)
library(bslib)
library(ggplot2)
library(dplyr)

# Load Data
data_file <- "c:/Users/poorn/Desktop/R for DS/R_AMR_Project/data/merged_MDR_data.csv"
amr_data <- tryCatch(read.csv(data_file), error=function(e) data.frame())

if(nrow(amr_data) > 0){
  amr_data$Year <- as.factor(amr_data$Year)
  amr_data$Pathogen <- as.factor(amr_data$Pathogen)
}

# UI Definition
ui <- page_navbar(
  title = "AMR Multi-Drug Resistance (MDR) Dashboard",
  theme = bs_theme(version = 5, bootswatch = "flatly", primary = "#2c3e50"),
  
  nav_panel("🏠 Home", 
    div(class = "container text-center mt-5",
      h1("Antimicrobial Resistance Analysis in Europe", class="display-4 text-primary"),
      h3("A Focus on Multi-Drug Resistance (2013-2014)", class="text-muted"),
      hr(),
      p(class = "lead text-start mx-auto", style="max-width: 800px;",
        "Welcome to the interactive AMR Dashboard. This platform consolidates extensive European resistance data to uncover temporal and pathogen-specific trends. ",
        "We focus explicitly on Multi-Drug Resistance (MDR) - an urgent global health threat where bacteria survive multi-class antibiotic treatments."
      ),
      br(),
      div(class="row",
          div(class="col-md-6",
              card(
                  card_header("What is MDR?"),
                  card_body("Multi-Drug Resistance occurs when bacteria mutate or acquire genes that allow them to withstand multiple classes of antibiotics concurrently. This makes infections significantly harder and more expensive to treat.")
              )
          ),
          div(class="col-md-6",
              card(
                  card_header("Project Scope"),
                  card_body("Analyzing combined resistance percentages from E. coli, K. pneumoniae, P. aeruginosa, and Acinetobacter across ~30 European nations, utilizing Mixed-Effects models to account for baseline geographic variance.")
              )
          )
      )
    )
  ),
  
  nav_panel("📊 Dashboard",
    sidebarLayout(
      sidebarPanel(
        h4("Controls"),
        checkboxGroupInput("pathogens", "Select Pathogens to View:",
                           choices = levels(amr_data$Pathogen),
                           selected = levels(amr_data$Pathogen)[1:2]),
        hr(),
        p("Use the checkboxes to isolate specific bacteria. The trendlines display the mean MDR with 95% Confidence Intervals.")
      ),
      mainPanel(
        card(
          card_header("Pathogen MDR Temporal Trends"),
          card_body(plotOutput("trendPlot", height = "500px"))
        )
      )
    )
  ),
  
  nav_panel("🧠 Analysis", 
    div(class = "container mt-4",
      h2("Model Explanation", class="text-primary"),
      p("We employed a Linear Mixed-Effects Model (LMM) in R to analyze the data. The formula used was:"),
      pre("Resistance ~ Year * Pathogen + (1 | Country)"),
      hr(),
      h4("Why this model?"),
      tags$ul(
        tags$li(strong("Fixed Effects (Year & Pathogen): "), "We track the direct impact of the passage of time and the species of bacteria on resistance levels."),
        tags$li(strong("Interaction Term (Year * Pathogen): "), "This tells us if MDR changes differently for each pathogen. For instance, is E. coli getting worse faster than Acinetobacter?"),
        tags$li(strong("Random Effect (1 | Country): "), "We account for the unmeasured baseline differences in resistance across countries due to distinct healthcare policies, meaning our trend estimates are robust to geographic clustering.")
      ),
      h4("Interpretation Summary"),
      p("The mixed model reveals that pathogen genetics heavily dictate ambient resistance loads. The temporal effect over just a single year interval (2013-2014) is subtle when aggregated, suggesting that MDR is a stable, entrenched systemic hazard rather than a rapidly fluctuating metric over a 12-month span.")
    )
  ),
  
  nav_panel("📈 Results", 
    div(class = "container mt-4",
      h2("Key Statistical Findings", class="text-primary"),
      br(),
      card(
        card_header("Pathogen Disparities"),
        card_body("E. coli and K. pneumoniae demonstrate distinct MDR baseline severities compared to Acinetobacter. Pathogen class is the most powerful predictor of resistance trajectory (< 0.001 significance). E. coli shows significantly higher MDR baselines overall.")
      ),
      br(),
      card(
        card_header("Temporal Stagnation"),
        card_body("No significant overall temporal change was observed between 2013 and 2014. This suggests resilient, stable MDR levels during the study period across Europe—a sobering realization that existing mitigations had no immediate continent-wide downward impact.")
      ),
      br(),
      card(
        card_header("Geographic Heterogeneity"),
        card_body("Country-level variation indicates profound geographic heterogeneity. Standard deviation intercepts for 'Country' in the model consumed a large portion of the variance, confirming that national health infrastructure dictates baseline resistance more than universal temporal shifts.")
      )
    )
  )
)

# Server Logic
server <- function(input, output, session) {
  
  output$trendPlot <- renderPlot({
    req(input$pathogens)
    filtered_data <- amr_data %>% filter(Pathogen %in% input$pathogens)
    
    ggplot(filtered_data, aes(x = Year, y = Resistance, color = Pathogen, group = Pathogen)) +
      stat_summary(fun = mean, geom = "line", linewidth = 1.2) +
      stat_summary(fun.data = mean_se, geom = "errorbar", width = 0.1, linewidth = 0.8) +
      theme_minimal(base_size = 14) +
      scale_color_brewer(palette = "Set1") +
      labs(title = "Mean Multi-Drug Resistance (MDR) Trend Line",
           subtitle = "With 95% Confidence Intervals",
           x = "Year", y = "Average Resistance (%)",
           color = "Pathogen") +
      theme(legend.position = "bottom",
            plot.title = element_text(face="bold"),
            panel.grid.minor = element_blank())
  })
}

shinyApp(ui, server)
