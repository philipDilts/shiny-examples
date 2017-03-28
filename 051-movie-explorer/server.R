library(ggvis)
library(dplyr)
if (FALSE) library(RSQLite)

# load data file
app_dir <- "O:/Analytics Unit/Projects/Open government/Open Data/HackAThon/Shiny_HackAThon"
average_year_df <- read_csv( paste(app_dir, "average_year_df.csv", sep = "/") )


# Join tables, filtering out those with <10 reviews, and select specified columns
all_movies <- average_year_df


function(input, output, session) {

  # Filter the movies, returning a data frame
  movies <- reactive({
    m <- all_movies

    m <- as.data.frame(m)

    m
  })

  # Function for generating tooltip text
  movie_tooltip <- function(x) {
    if (is.null(x)) return(NULL)
    # if (is.null(x$ID)) return(NULL)

    # Pick out the movie with this ID
    all_movies <- isolate(movies())
    movie <- all_movies[all_movies$appr_trade_code == x$appr_trade_code, ]

    paste0("<b>", movie$appr_trade_code, "</b><br>",
      movie$appr_trade_name, "<br>",
      "$", format(movie$pct_complete, big.mark = ",", scientific = FALSE)
    )
  }

  # A reactive expression with the ggvis plot
  vis <- reactive({
    # Lables for axes
    xvar_name <- names(axis_vars)[axis_vars == input$xvar]
    yvar_name <- names(axis_vars)[axis_vars == input$yvar]

    # Normally we could do something like props(x = ~BoxOffice, y = ~Reviews),
    # but since the inputs are strings, we need to do a little more work.
    xvar <- prop("x", as.symbol(input$xvar))
    yvar <- prop("y", as.symbol(input$yvar))

    movies %>%
      ggvis(x = xvar, y = yvar) %>%
      layer_points(size := 50, size.hover := 200,
        fillOpacity := 0.2, fillOpacity.hover := 0.5,
        key := ~appr_trade_code) %>%
      add_tooltip(movie_tooltip, "hover") %>%
      add_axis("x", title = xvar_name) %>%
      add_axis("y", title = yvar_name)
  })

  vis %>% bind_shiny("plot1")
}
