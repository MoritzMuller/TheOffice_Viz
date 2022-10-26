# The Office Episode Recommendation system

This is the underlying code for this webapp that I programmed in R/shiny: https://moritz-muller.shinyapps.io/TheOffice_EpisodeRecommender/
The app lets the user visualize and filter through all "The Office" episodes, so they can select the best episode to watch today (based on their own preferences)

I webscraped the underlying data from this amazing website that contains all transcripts of all The Office (US) episodes: https://transcripts.foreverdreaming.org/viewforum.php?f=574
Furthermore, I webscraped the IMDB website to get ratings for every episode of the office.

I then used the scraped data, merged it together and performed some data wrangling to extract valueable data such as the share of lines that each of the characters deliver in each episode. Furthermore, I used the fact that acting instructions are always written in squared parantheses [] to calculate a 'Theatricality score' per episode.

To see how I constructed the underlying dataset for this shiny webapp, please see the RMarkdown file here: https://htmlpreview.github.io/?https://github.com/MoritzMuller/TheOffice_Viz/blob/main/data_wrangling.html

If you wish to run this shiny app locally, clone this repo to your machine and click "Run App" when you open the app.R file (when using RStudio).

Happy watching!
