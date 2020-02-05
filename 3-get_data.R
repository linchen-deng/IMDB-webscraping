# This scripts will return any data we need to do further analysis using functions in 2-web_scraping_functions
setwd(dirname(rstudioapi::callFun("getActiveDocumentContext")$path)) 
source("1-helper_functions.R")
source("2-web_scraping_functions.R")


# ========== scraping years and titles of movies among genres specified ==================

genre_list <- c("Comedy", "Horror", "Drama", 
                "Sci-Fi", "History","Documentary",
                "War", "Crime", "Animation", 
                "Action","Romance", "Thriller",
                "Biography", "Musical", "Fantacy")

# Use the saved data without spending 2 hours scraping again
if (dir.exists("./web_data") & length(dir(path = "./web_data"))>=0) {
  cat("Data files saved, reading year data... \n")
  genre_list <- gsub( pattern=".*_(.*).csv$", replacement="\\1",dir(path = "./web_data", full.names = T))
  year_data_list <- lapply(dir(path = "./web_data", full.names = T), read.csv, stringsAsFactors=FALSE)
  names(year_data_list) <- genre_list
} else {
  print("No data saved, scraping from the website...")
  # This will likely take 2 hours if movie_num=8000
  year_data_list <- lapply(genre_list, get_movie_title_year, movie_num=8000)
  year_data_list <- lapply(year_data_list, drop_na)
  if (!dir.exists("./web_data")){
    dir.create(file.path(".", "web_data"))
  }
  for (i in 1:15) {
    write.csv(year_data_list[i], 
              paste("web_data/","title_year_",genre_list[[i]],".csv",sep=""))
  }
}




# ==Scrape data with non-missing years, runtime, rate_score, certificates, gross =========

genre_list_complete <- c("Comedy", "Horror", "Drama", 
                         "Sci-Fi", "History","War", "Crime", "Animation", 
                         "Action","Romance", "Thriller",
                         "Biography", "Musical", "Fantacy")

if (dir.exists("./web_complete_data") & length(dir(path = "./web_complete_data"))>0) {
  cat("Data files saved, reading gross data... \n")
  genre_list_complete <- gsub( pattern=".*_(.*).csv$", replacement="\\1",dir(path = "./web_complete_data", full.names = T))
  complete_data_list <- lapply(dir(path = "./web_complete_data", full.names = T), read.csv, stringsAsFactors=FALSE)
  names(year_data_list) <- genre_list_complete
} else {
  # The scraping speed on my computer is 2000 years&titles per minute
  print("No data saved, scraping from the website...")
  complete_data_list <- lapply(genre_list_complete, get_movie_data_by_gross, movie_num=2000)
  complete_data_list <- lapply(complete_data_list, drop_na)
  dir.create(file.path(".", "web_complete_data"))
  for (i in 1:length(genre_list_complete)) {
    write.csv(complete_data_list[i], 
              paste("web_complete_data/","complete_",nrow(complete_data_list[[i]]),"_",genre_list_complete[i],".csv",sep=""))
  }
}
