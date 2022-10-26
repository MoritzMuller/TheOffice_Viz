#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
library(shiny)
library(ggvis)
library(dplyr)
if (FALSE) {
  library(RSQLite)
  library(dbplyr)
}

actionLink <- function(inputId, ...) {
  tags$a(href='javascript:void',
         id=inputId,
         class='action-button',
         ...)
}

axis_vars <- c(
  "Ratings" = "Ratings",
  "Michael share" = "michael",
  "Jim share" = "jim",
  "Pam share" = "pam",
  "Dwight share" = "dwight",
  "Kevin share" = "kevin",
  "Angela share" = "angela",
  "Creed share" = "creed",
  "Meridith share" = "meredith",
  "Toby share" = "toby",
  "Ryan share" = "ryan",
  "Phyllis share" = "phyllis",
  "Stanley share" = "stanley",
  "Kelly share" = "kelly",
  "Oscar share" = "oscar",
  "Andy share" = "andy",
  "Nelly share" = "nellie",
  "Erin share" = "erin",
  "Jan share" = "jan"
)

# Define UI for application that draws a histogram
ui <- fluidPage(
  titlePanel("Which 'The Office' episode should I watch today?"),
  sidebarPanel(
             h4("Filter"),
             sliderInput("Ratings", "Minimum rating of episode on IMDB",
                         0, 10, 5, step = 0.1),
             sliderInput("Viewership", "How many viewers watched the episode at first airing?",
                         0, 25, c(0,25), step = 1),
             sliderInput("Theatricality", "How often do characters use gestures?",
                         0, 1, c(0,1), step = 0.1),
             sliderInput("Twss", "How many 'That's what she said' jokes does the episode contain?",
                         0, 3, c(0,3), step = 1),
             h4("Y axis selector"),
             selectInput("yvar", "Y-axis variable", axis_vars, selected = "Ratings"),
             tags$small(paste0(
               "If you rather feel like watching an episode with a certain character,",
               " you can select a character here.",
               " For instance, a Michael share of .3 means that 30% of the lines in a given",
               " episode are delivered by Michael."
             ))
             ),
    mainPanel(
      column(5,
           ggvisOutput("plot1"),
           wellPanel(
             span("Number of episodes selected:",
                  textOutput("n_movies")
             )
           )
    )
  )
)

#office <- read.csv(file="TheOffice_data.csv")


# Define server logic required to draw a histogram
server <- function(input, output) {
  office <- read.csv(file="TheOffice_data.csv")
  
  # Filter the movies, returning a data frame
  episodes <- reactive({
    # Due to dplyr issue #318, we need temp variables for input values
    reviews <- input$Ratings
    viewersmax <- input$Viewership[2]
    viewersmin <- input$Viewership[1]
    theatermax <- input$Theatricality[2]
    theatermin <- input$Theatricality[1]
    thatswhatshesaidmax <- input$Twss[2]
    thatswhatshesaidmin <- input$Twss[1]

    
    # Apply filters
    m <- office %>%
      filter(
        Ratings >= reviews,
        Viewership <= viewersmax,
        Viewership >= viewersmin,
        total_theater <= theatermax,
        total_theater >= theatermin,
        twss <= thatswhatshesaidmax,
        twss >= thatswhatshesaidmin
      ) 
    
    
    m <- as.data.frame(m)
    m
  })
  
  # Function for generating tooltip text
  episode_tooltip <- function(x) {
    if (is.null(x)) return(NULL)
    
    # Pick out the movie with this ID
    all_episodes <- isolate(episodes())
    episode <- all_episodes[all_episodes$X.1 == x$X.1, ]
    
    paste0("<b>", episode$EpisodeTitle, "</b><br>",
           episode$uniqueid, "<br>",
           "IMDB Rating: ", format(episode$Ratings, big.mark = ",", scientific = FALSE), "<br>",
           "Viewership ", format(episode$Viewership), " million viewers", "<br>",
           "Synopsis:", format(episode$About)
    )
  }
  
  # A reactive expression with the ggvis plot
  vis <- reactive({
    # Lables for axes
    yvar_name <- names(axis_vars)[axis_vars == input$yvar]
    yvar <- prop("y", as.symbol(input$yvar))
    
    episodes %>%
      ggvis(~X.1, y=yvar) %>%
      layer_points(size := 50, size.hover := 200,
                   fillOpacity := 0.2, fillOpacity.hover := 0.5) %>%
      add_tooltip(episode_tooltip, "hover") %>% 
      add_axis("y", title = yvar_name) %>%
      add_axis("x", title = "Episode No.") %>%
      set_options(width = 500, height = 500)
  })
  
  vis %>% bind_shiny("plot1")
  
  output$n_movies <- renderText({ nrow(episodes()) })
}

# Run the application 
shinyApp(ui = ui, server = server)
