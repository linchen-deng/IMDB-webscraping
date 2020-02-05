# IMDB-webscraping
This project was done in collaboration with David Crbonello and Uttam Bhetuwal, thanks David's plot visualization and Uttam's cool animations. I was responsible for writing up the web-scraping functions, wordcloud visualization, organizing everyone's code into functions and reproducible codes and eventually writing up the make file.

We are interested in the diffrence in word that appeared in titles by each movie genre, so we webscraped all the titles by each genre
to see if there is any interesting pattern.

Then we move on to web scraped other movie information including ratings, scores, runtime, certificate type. We ran a comparative 
analysis across all the genres we investigated.


# Usage
To check reproducibility, please clone this repository, delete everything except all R files, and source "7-make_file.R" in R Studio. The web scraping might take a long time (~2hrs) since we are scraping tens of thousands of movies from the website. Once it is done, a html report will be generated in the same folder. 
