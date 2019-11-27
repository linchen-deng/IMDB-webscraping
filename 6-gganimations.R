setwd(dirname(rstudioapi::callFun("getActiveDocumentContext")$path)) 

source("3-get_data.R")

# This file generates animations that descibe the change of number of movies by genres throughout years from 1950 - 2020 


# =============== First Animation ============================
if (!dir.exists("./plot_data")){  
  dir.create(file.path(".","plot_data"))
} 

# if it is not saved in the folder, we will run the code again.
if (!"animation.RData" %in% dir("plot_data")){ 
  # stack all data frames into one data frame 
  final_table <- data.frame() 
  for (i in 1:length(genre_list)){
    final_table <- final_table %>% 
      rbind(year_data_list[[i]] %>%
              num_movie_per_year_by_genre(genre=genre_list[i]))
  }
  
  theme_set(theme_classic())
  
  Final_table1 <- final_table %>%
    group_by(years) %>%
    mutate(rank = min_rank(-movie_peryear)) %>%
    ungroup()
  
  moving_bar <- ggplot(Final_table1,aes(rank, group= genre,fill = as.factor(genre))) + 
    geom_tile(aes(y = movie_peryear/2,height = movie_peryear)) +
    geom_text(aes(y = 0, label = paste(genre, " ")), vjust = 0.2, hjust = 1) +
    
    coord_flip(clip = "off", expand = FALSE) +
    scale_y_continuous(labels = scales::comma) +
    scale_x_reverse() +
    guides(color = FALSE, fill = FALSE) +
    
    
    labs(title='{closest_state}', x = "", y = "Movies per year") +
    theme(plot.title = element_text(hjust = 0, size = 22),
          axis.ticks.y = element_blank(), 
          axis.text.y  = element_blank(),  
          plot.margin = margin(1,1,1,4, "cm"))+
    
    transition_states(years, transition_length = 4, state_length = 1) +
    ease_aes('cubic-in-out')
  
  moving_animation <- animate(moving_bar, fps = 20, duration = 25, width = 800, height = 600)
  
  
  
  # ================= second animation ==========================
  movie_per_year <- Final_table1 %>%
    plot_ly(
      x = ~years, 
      y = ~movie_peryear, 
      size = ~ movie_peryear, 
      color = ~genre, 
      frame = ~years, 
      text = ~genre,
      hoverinfo = "text",
      type = 'scatter',
      mode = 'markers'
    )%>%
    layout(
      xaxis = list(
        type = "log"
      ) 
    )
  
  
  # ================== thrid animation ==================================
  popular <- Final_table1 %>% 
    filter(genre %in% c("Action","History","Romance","War"))%>%
    arrange(years)
  
  trend_of_movies <- ggplot(popular,aes(x = years, y = movie_peryear, color= genre))+
    geom_line() +
    geom_point() +
    scale_color_viridis(discrete = TRUE) +
    ggtitle("Trend of movies") +
    theme_ipsum() +
    ylab("Movies per year") +
    transition_reveal(years)
  
  
  
  # saving animation results for future use
  
  save(moving_animation, movie_per_year, trend_of_movies,file="plot_data/animation.RData")
} else {
  cat("Animations are saved already, reading from folder: plot_data/animation.RData \n")
}


