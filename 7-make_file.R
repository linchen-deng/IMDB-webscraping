# Usage: if wish to starting from scratch, please delete following folder:

setwd(dirname(rstudioapi::callFun("getActiveDocumentContext")$path)) 

unlink("plot_data", recursive = TRUE) # Nearly 8 mins
# unlink("web_complete_data", recursive = TRUE) # Nearly 5 mins
# unlink("web_data", recursive = TRUE) # recommend keep this folder otherwise it will take 2 hours
unlink("wordcloud_data", recursive = TRUE) # Nearly 3 mins



source("1-helper_functions.R")  # load packages and helper functions
source("2-web_scraping_functions.R")  # web scraping functions 
source("3-get_data.R")     ## get data from web / load data from folders if saved 
source("4-word_cloud.R")  ## create wordcloud visualization
source("5-gg_visualization.R") ## ggplot visualization
source("6-gganimations.R") ## gganimation for movie counts growth over years
rmarkdown::render("lud-9-report.Rmd", output_format = "html_document")
