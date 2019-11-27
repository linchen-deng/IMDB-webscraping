source("1-helper_functions.R")

# This R file contains two function that scrape data on various genre for different later tasks

# get_movie_data_by_gross gets all data of movies that do not have missing gross information, so counts are limited

get_movie_data_by_gross <- function(movie_genre, movie_num=1000){  
  # Generating web urls for scraping
  cat("scraping genre ",movie_genre, " data..... \n",sep="")
  base_url_1 <- 'https://www.imdb.com/search/title/?title_type=movie&genres='
  base_url_2<- '&sort=boxoffice_gross_us,desc'
  base_url_3 <- '&start='
  base_url_4 <- "&explore=title_type,genres&ref_=adv_nxt"
  movie_per_page <- 50
  movie_num <- seq(1,movie_num,by=movie_per_page)
  page_urls <- paste(base_url_1, movie_genre, base_url_2, base_url_3,movie_num, base_url_4, sep="")
  
  all_movie_rates <- c()
  all_movie_gross <- c()
  all_movie_votes <- c()
  all_movie_years <- c()
  all_movie_runtime <- c()
  all_movie_certificates <- c()
  all_movie_categories <- c()
  counter <- 0
  for (page_url in page_urls) {
    # Print out the progress for scraping
    counter <- counter + 1
    if (counter %% 10 == 0){cat("scraping ",counter,"-th webpage \n", sep="")}
    
    # read html and locate movie content chunks
    webpage <- read_html(page_url)
    movies <- webpage %>%
      html_nodes(css = "div.lister-item-content")
    
    # get gross box office data
    movie_gross_votes <- get_node_text(movies, "p.sort-num_votes-visible")
    movie_gross <- str_extract(movie_gross_votes, pattern="\\$(\\d+).(\\d+)M") %>% str_replace(pattern="\\$(\\d+.\\d+)M",replacement="\\1") %>% as.numeric()
    
    
    # Only scrape if every movie on that page has a non-zero gross
    # since pages are sorted by gross, can stop scraping when gross starts missing or encountering zero gross
    if(length(movie_gross)<50 | movie_gross[1]==0){break}

    
    # get movie rates
    movie_rates <- get_node_text(movies, "div.inline-block.ratings-imdb-rating strong") %>%
      as.numeric()
    # if cannot scrape 50 data from the webpage, that means there is missing values
    if(length(movie_rates)<50){break}
    
    # get movie votes 
    movie_votes <- str_extract(movie_gross_votes, pattern="\\d+,\\d+") %>%
      str_replace(pattern="(\\d+),(\\d+)",replacement = "\\1\\2") %>% 
      as.numeric()
    if(length(movie_votes)<50){break}
    
    
    # get movie years
    movie_years <- get_node_text(movies,"span.lister-item-year.text-muted.unbold")   %>% str_extract(pattern="\\d{4}") %>% as.numeric()
    # extract four digits number from the string
    if(length(movie_years)<50){break}
    
    
    # get movie run time
    movie_runtime <- get_node_text(movies, ".runtime") %>%
      str_replace(pattern="(\\d+).*",replacement = "\\1") %>% as.numeric()
    if(length(movie_runtime)<50){break}
    
    
    # get movie certificate
    movie_certificate <- get_node_text(movies, "span.certificate")
    if(length(movie_certificate)<50){break}
    
    
    # # concatenating data
    all_movie_years <- c(all_movie_years, movie_years)
    all_movie_runtime <- c(all_movie_runtime, movie_runtime)
    all_movie_rates <- c(all_movie_rates, movie_rates)
    all_movie_gross <- c(all_movie_gross, movie_gross)
    all_movie_votes <- c(all_movie_votes, movie_votes)
    all_movie_certificates <- c(all_movie_certificates, movie_certificate)
  }
  
  movie_data <- data.frame(years=all_movie_years,
                     runtime_minute=all_movie_runtime, 
                     rate_score=all_movie_rates,
                     gross_million=all_movie_gross,
                     votes=all_movie_votes,
                     certificates=all_movie_certificates,
                     stringsAsFactors=FALSE)
  return(movie_data)
}


# get_movie_title_year gets only years and titles, but with more data than the first function above with less restrictions on missing values

get_movie_title_year <- function(movie_genre, movie_num=9500){  
  cat("scraping genre years and titles",movie_genre, "..... \n",sep="")
  base_url_1 <- 'https://www.imdb.com/search/title/?title_type=movie&genres='
  base_url_2<- '&sort=boxoffice_gross_us,desc'
  base_url_3 <- '&start='
  base_url_4 <- "&explore=title_type,genres&ref_=adv_nxt"
  movie_per_page <- 50
  movie_num <- seq(1,movie_num,by=movie_per_page)
  page_urls <- paste(base_url_1, movie_genre, base_url_2, base_url_3,movie_num, base_url_4, sep="")
  
  
  all_movie_names <- c()
  all_movie_years <- c()

  
  counter <- 0
  for (page_url in page_urls) {
    counter <- counter + 1
    if (counter %% 10 == 0){cat("scraping ",counter,"-th webpage \n", sep="")}
  
    # read html and locate movie content chunks
    webpage <- read_html(page_url)
    
    movies <- webpage %>%
      html_nodes(css = "div.lister-item-content")
    
    # get movie names
    movie_names <- html_nodes(movies, "h3 a") %>%
      html_text()
    
    # get movie years
    movie_years <- get_node_text(movies,"span.lister-item-year.text-muted.unbold")   %>% str_extract(pattern="\\d{4}") %>%  # extract first four digits number
      as.numeric()
    
    # Only grab information from the webpage if every movie on that page has a year/title
    
    if(length(movie_years)<50 | length(movie_names)<50){
      print(movie_years)
      print(movie_names)
      cat(page_url, "\n")
      break
    }
   
    # # concatenating data
    all_movie_names <- c(all_movie_names, movie_names)
    all_movie_years <- c(all_movie_years, movie_years)
  }
  
  movie_data <- data.frame(titles=all_movie_names, 
                     years=all_movie_years,
                     stringsAsFactors=FALSE)
  return(movie_data)
}
