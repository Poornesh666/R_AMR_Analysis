<div align="center">
  <img src="https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white" />
  <img src="https://img.shields.io/badge/Shiny-Web App-blue?style=for-the-badge&logo=r&logoColor=white" />
  <img src="https://img.shields.io/badge/Academic-Data Science-success?style=for-the-badge" />
  
  <h1>🧪 Antimicrobial Resistance (AMR) in Europe</h1>
  <p><b>A Mixed-Effects Regression Analysis of Multi-Drug Resistance (MDR) Trends</b></p>
</div>

<br/>

## 📖 Overview
This repository contains a comprehensive data science project developed for academic purposes. It investigates the temporal and geographic trends in **Multi-Drug Resistance (MDR)** across several critical bacterial species (*E. coli, K. pneumoniae, P. aeruginosa, Acinetobacter*) within Europe using historical data (2013-2014).

By utilizing a **Linear Mixed-Effects Model (LMM)**, this study separates inherent baseline geographic differences from the underlying evolutionary resistance trajectories of the pathogens.

---

## 📽️ Video Presentation
[👉 Watch the Full Project Walkthrough Here](https://drive.google.com/file/d/11froogE65hAk9EfWj2lK7q4bFbhAZYW4/view?usp=drive_link)

---

## 🎯 Objectives
1. **Data Ingestion pipelines**: Build robust algorithms to recursively parse, extract, and standardize disparate Excel sheets provided by health agencies into a unified dataset.
2. **Statistical Modeling**: Apply interaction-based Mixed-Effects Models (`lme4`) to quantify whether certain bacterial families are evolving resistance faster than others over time.
3. **Academic Interpretation**: Transform raw coefficients into epidemiological insights regarding geographic heterogeneity and pathogen disparities.
4. **Interactive Dashboard**: Construct an engaging, user-friendly `Shiny` application to visualize mean resistance trends and confidence intervals.

---

## 🗂️ Project Structure
```text
R_AMR_Project/
│
├── data/
│   └── merged_MDR_data.csv            # Final consolidated dataset containing 227 records
│
├── Dataset/
│   └── European/                      # Raw Excel datasets nested by Year/Pathogen
│
├── plots/
│   └── amr_trends_by_pathogen.png     # High-res plot of mean MDR trends with error bars
│
├── reports/
│   └── regression_summary.txt         # Full LMM summary, ANOVA tables, and text insights
│
└── scripts/
    ├── data_preparation.R             # Preprocessing pipeline isolating 'percentage' Excel sheets
    ├── amr_regression.R               # Core statistical model leveraging lme4 and ggplot2
    └── app.R                          # Interactive Shiny Dashboard (Bootswatch theme)
```

---

## 🚀 How to Run

### 1. Requirements
Ensure you have **R (version 4.4+)** installed. The required packages (`shiny`, `bslib`, `dplyr`, `ggplot2`, `lme4`) will be automatically installed when you run the scripts.

### 2. View the Dashboard
Run the interactive web application to explore the data dynamically:
```r
shiny::runApp('scripts/app.R', launch.browser = TRUE)
```

### 3. Reproduce the Analysis
To pull the raw datasets, clean them, and execute the regression model from scratch:
```R
# 1. Prepare and merge data
source("scripts/data_preparation.R")

# 2. Run the regression and generate plots
source("scripts/amr_regression.R")
```

---

## 🧠 Key Academic Insights
Derived from the `reports/regression_summary.txt`:

* **Pathogen Disparities**: Pathogen type is the definitive predictor of resistance capability ($p < 0.05$). *E. coli* and *K. pneumoniae* naturally exhibit substantially higher MDR baseline severity. 
* **Temporal Stagnation**: The linear interaction involving `Year` was not statistically significant. This highlights a sobering stability in MDR baselines across the 2013-2014 study period, indicating resilient bacterial persistence despite interventions.
* **Geographic Heterogeneity**: The random effect intercept (`1 | Country`) consumed massive variance in the model framework. This proves that differing national health policies, hygiene enforcement, and antibiotic stewardship protocols strongly dictate a country's absolute resistance hazard.

---
*Disclaimer: This project was primarily constructed as an academic submission demonstrating proficiency in R Data Science concepts, complex spreadsheet processing, and Advanced Regression/UI Modeling.*
