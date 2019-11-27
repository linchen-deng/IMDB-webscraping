# Helper functions and required libraries loading...

# install.packages("devtools")
# install.packages("gifski")
# install.packages("tidyverse")
# install.packages("gganimate")
# install.packages("stringr")
# install.packages("rlang")
# install.packages("digest")
# install.packages("tokenizers")
# install.packages("wordcloud")
# install.packages("tm")
# install.packages("RColorBrewer")
# install.packages("wordcloud2")
# devtools::install_github("lchiffon/wordcloud2")
# install.packages("webshot")  # rendering wordcloud2 images in rmd

# used for web scraping and string manipulations
library(rvest)
library(httr)
library(stringr)
library(rebus)

# used for wordcloud generation
library(tokenizers)
library(wordcloud)
library(wordcloud2)
library(tm)
library(RColorBrewer)
library(htmlwidgets)
library(webshot)

# used for data wrangling 
library(tidyverse)
library(readr)
library(dplyr)
library(tidyr)

# used in 6-gganimations and 5-gg_visualization
library(devtools)
library(rlang)
library(gifski)
library(gganimate)
library(ggthemes)
library(plotly)
library(viridis)
library(ggplot2)
library(hrbrthemes)


# This function is called in 2-web_scraping_functions.R
get_node_text <- function(html_page, node_css){
  out <- html_page %>%
    html_nodes(node_css) %>%
    html_text()
  return(out)
}

# This function is called in 4-word_cloud.R which removes non-english characters and stopwords from the movie tiltles to yield cleaner images
remove_unknown_characters_digits_stopword <- function(title_data){
  stopwords_regex <- paste(stopwords('en'), collapse = '\\b|\\b')
  stopwords_regex <- paste("[^",paste0('\\b', stopwords_regex, '\\b'),"]",sep="")
  pattern_to_keep <- paste("[^\\p{script=Han}*][^\\d*]",stopwords_regex,sep="")
  # pattern_to_keep <- "[^\\p{script=Han}*][^\\d*]"
  out <- title_data$titles %>%
    paste(collapse=" ") %>%
    tokenize_words() %>%
    unlist() %>%
    str_subset(pattern=pattern_to_keep)
  return(out)
}

# This function is used in 6-gganimations.R, which processes the input data frame to the desirable structure for each movie genre
num_movie_per_year_by_genre <- function(title_year, genre){
  title_year%>%
    filter(!is.na(years) & years >= 1950 & years <= 2020 )%>%
    group_by(years)%>%
    summarize(movie_peryear =n())%>%
    mutate(genre = genre) %>%
    complete(genre, years = 1950:2020, fill = list(movie_peryear = 0)) %>%
    as.data.frame()
}

# This is used in 4-word_cloud.R to get the frequency of each word in a genre
get_word_freq <- function(all_words_cleaned){
  all_words_cleaned%>%
  data.frame(name=.) %>%
  group_by(name) %>%
  count() %>% 
  as.data.frame()
}
