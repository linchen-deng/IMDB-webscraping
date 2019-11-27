# gg visualization based on get_movie_data_by_gross()
# install.packages("ggthemes")
 # Load
setwd(dirname(rstudioapi::callFun("getActiveDocumentContext")$path)) 
source("3-get_data.R")


ggplot_by_genre_top_n_rows <- function(n, genre_list_complete, complete_data_list){
  binded_data <- data.frame()
  
  ggplot_sublist<-list()

  for (i in 1:length(genre_list_complete)){
    if (nrow(complete_data_list[[i]]) >= n){
      binded_data <- rbind(binded_data,complete_data_list[[i]][1:n,] %>% 
                             mutate(genre=genre_list_complete[i])) # adding a genre column
    }
  }
  # boxplot of gross box office by genre
  average_gross <- mean(binded_data$gross_million)
  ggplot_sublist[[1]] <- ggplot(binded_data,aes(x=genre,y=gross_million)) + 
    theme_economist() + geom_boxplot(aes(fill = genre),outlier.colour="black", 
                                     outlier.shape=16, outlier.size=2, notch=FALSE) + 
    geom_hline(yintercept=average_gross, linetype="dashed", color = "navy",size=1.3)+ 
    ggtitle(paste("Boxplot of gross box office(Millions) by top ", n,
                  " rows from genres",sep="")) + 
    theme(plot.title = element_text(hjust = 0.5))
  
  # bar plot of certificates by genre
  ggplot_sublist[[2]] <- ggplot(binded_data,aes(x=genre,fill=genre)) + 
    theme_economist() + geom_bar() + facet_wrap(~certificates,scale="free_x") +
    theme(axis.text.x=element_blank(),
          strip.text.x = element_text(
            size = 12, color = "black", face = "bold.italic"
          ),
          strip.background = element_rect(
            color="black", size=1.5, linetype="solid"
          )) +
    ggtitle(paste("Barplot of movie certificates by top ", n," rows from genres",sep="")) + 
    theme(plot.title = element_text(hjust = 0.5))
  
  
  # histogram of runtime length by genre
  ggplot_sublist[[3]] <- ggplot(binded_data,aes(runtime_minute,fill=genre))+
    theme_economist() + geom_histogram() + 
    facet_wrap(~genre, scale="free_x") + xlim(60, 180) + 
    ggtitle(paste("Histogram of runtime length in minutes by top ",n,
                  " rows from genres",sep="")) + 
    theme(plot.title = element_text(hjust = 0.5))
  
  # boxplot of rate_score by genre
  average_rate_score <- mean(binded_data$rate_score)
  ggplot_sublist[[4]] <- ggplot(binded_data,aes(x=genre,y=rate_score)) + 
    theme_economist() + geom_boxplot(aes(fill = genre),outlier.colour="black", 
                                     outlier.shape=16, outlier.size=2, notch=FALSE) +
    geom_hline(yintercept=average_rate_score, linetype="dashed", color = "navy",size=1.3)+ 
    ggtitle(paste("Boxplot of score ratings by top ",n," rows from genres",sep="")) + 
    theme(plot.title = element_text(hjust = 0.5))
  return(ggplot_sublist)
}

if (!dir.exists("./plot_data")) {
  dir.create(file.path(".", "plot_data"))
}

# if (!"ggplot.RData" %in% dir("plot_data")){
if (T){
  ggplot_list <- lapply(c(50,100,200,500,1000),ggplot_by_genre_top_n_rows,
                      genre_list_complete, complete_data_list)
  save(ggplot_list, file="plot_data/ggplot.RData")
}