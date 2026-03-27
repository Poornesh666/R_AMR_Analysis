library(readxl)
library(dplyr)
library(stringr)

data_dir <- "c:/Users/poorn/Desktop/R for DS/R_AMR_Project/Dataset/European"
output_file <- "c:/Users/poorn/Desktop/R for DS/R_AMR_Project/data/merged_MDR_data.csv"

files <- list.files(path = data_dir, pattern = "combined-resistance.*\\.xlsx$", recursive = TRUE, full.names = TRUE)
files <- files[grepl("^percentage-", basename(files))]
cat("Found", length(files), "MDR files.\n")

combined_data <- data.frame()

for (file in files) {
  year_match <- str_extract(file, "(2013|2014|2015)")
  pathogen <- basename(dirname(file))
  
  tryCatch({
    df <- read_excel(file, col_names = FALSE)
    df_char <- as.data.frame(lapply(df, as.character), stringsAsFactors = FALSE)
    
    col_countries <- 0
    row_austria <- 0
    for(j in 1:ncol(df_char)){
      idx <- grep("austria", df_char[[j]], ignore.case=TRUE)
      if(length(idx) > 0){
        col_countries <- j
        row_austria <- idx[1]
        break
      }
    }
    
    if(col_countries > 0){
      countries <- df_char[[col_countries]]
      
      col_res <- 0
      for(j in (col_countries+1):ncol(df_char)){
        val <- suppressWarnings(as.numeric(df_char[row_austria, j]))
        if(!is.na(val)){
          col_res <- j
          break
        }
      }
      
      if(col_res > 0){
        res_values <- suppressWarnings(as.numeric(df_char[[col_res]]))
        
        tmp <- data.frame(
          Country = countries,
          Resistance = res_values,
          Year = as.numeric(year_match),
          Pathogen = pathogen,
          SourceFile = basename(file),
          stringsAsFactors = FALSE
        )
        
        tmp <- tmp[!is.na(tmp$Resistance), ]
        tmp <- tmp[!is.na(tmp$Country) & nchar(tmp$Country) >= 3, ]
        
        combined_data <- bind_rows(combined_data, tmp)
      } else {
        cat("Could not find numeric resistance column for file:", basename(file), "\n")
      }
    } else {
      cat("Could not find 'Austria' in file:", basename(file), "\n")
    }

  }, error = function(e){
    message("Error reading file: ", basename(file), "\n", e)
  })
}

combined_data$Country <- gsub("\\s*\\*+.*", "", combined_data$Country)
combined_data$Country <- trimws(combined_data$Country)

write.csv(combined_data, output_file, row.names = FALSE)
cat("Successfully wrote", nrow(combined_data), "rows to", output_file, "\n")
print(table(combined_data$Pathogen, combined_data$Year))
