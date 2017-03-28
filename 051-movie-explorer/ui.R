library(ggvis)

# For dropdown menu
actionLink <- function(inputId, ...) {
  tags$a(href='javascript:void',
         id=inputId,
         class='action-button',
         ...)
}

fluidPage(
  titlePanel("Movie explorer"),
  fluidRow(
    column(3,
      wellPanel(
        selectInput("xvar", "X-axis variable", axis_vars, selected = "Meter"),
        selectInput("yvar", "Y-axis variable", axis_vars, selected = "Reviews")
      )
    ),
    column(9,
      ggvisOutput("plot1")
    )
  )
)
