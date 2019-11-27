# This file we create wordcloud visualizations on the frequency of words that appear in each genre 
# The graph created should be saved
setwd(dirname(rstudioapi::callFun("getActiveDocumentContext")$path)) 
source("1-helper_functions.R")
source("2-web_scraping_functions.R")
source("3-get_data.R")

create_word_cloud <- function(year_data_list, genre_list){
  
  if (!dir.exists("./wordcloud_data") | length(dir(path = "./wordcloud_data"))==0) {
    dir.create(file.path(".", "wordcloud_data"))
    cat("Building Word cloud images......")
    for (i in 1:length(genre_list)){
      data_with_year_title <- year_data_list[[i]]
      genre <- genre_list[i]
      
      all_words <- remove_unknown_characters_digits_stopword(data_with_year_title) 
      all_words_cleaned <- all_words[!all_words%in%c("black","the","movie",
                                                     "story","love","man","woman",
                                                     "musical","war","project","men",
                                                     "women","it","of","and","untitled",
                                                     "life","dark","back","broken")]
      
      freq <- all_words_cleaned %>% get_word_freq()
      wc2 <- wordcloud2(freq,minSize=0,size=0.5,
                                         color = "random-light", 
                                         backgroundColor = "grey", 
                                         shape="triangle")
      
      path <- paste(getwd(),"wordcloud_data/",sep="/")
      h_name <- paste(path,genre_list[i],".html",sep="")
      png_name <- paste(path,genre_list[i],".png",sep="")
      print(png_name)
      saveWidget(wc2,h_name,selfcontained = F)
      webshot(h_name, png_name, vwidth = 700, vheight = 500, delay =5)
    }
  }
}

create_word_cloud(year_data_list, genre_list)
