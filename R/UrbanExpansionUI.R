#' Urban Expansion Analysis Dashboard
#'
#' This function generates a Shiny dashboard for visualizing urban expansion analysis.
#'
#' @param city_map_buffer  A map object representing the city map with buffer.
#' @param city_map_boundaries A map object representing the city map with boundaries.
#' @param city_df_buffer A data frame containing data related to the city map with buffer.
#' @param city_df_boundaries A data frame containing data related to the city map with boundaries.
#'
#' @return A Shiny dashboard for urban expansion analysis.
#' @export
#'
#' @examples
#' UrbanExpansionUI(city_map_buffer,city_map_boundaries,city_df_buffer,city_df_boundaries)
#' @import shiny
#' @import shinydashboard

UrbanExpansionUI <- function(city_map_buffer, city_map_boundaries, city_df_buffer, city_df_boundaries) {

  # Define UI
  ui <- dashboardPage(
    dashboardHeader(title = "Urban Expansion Analysis Dashboard"),
    dashboardSidebar(
      sidebarMenu(
        menuItem("City Maps", tabName = "city_maps", icon = icon("map")),
        menuItem("Building Density", tabName = "building_density", icon = icon("building"))
      ),
      # Add radioButtons widget for map selection
      radioButtons("map_type", label = "Select Map:",
                   choices = c("Buffer Map", "Boundary Map"),
                   selected = "Buffer Map"), # Set default selected map
      sliderInput("bins", label = "Number of Bins:", min = 1, max = 100, value = 10) # Slider for selecting number of bins
    ),
    dashboardBody(
      tabItems(
        tabItem(tabName = "city_maps",
                fluidRow(
                  column(width = 12,
                         plotOutput("map_selected",height = "500px", width = "500px"))
                )
        ),
        tabItem(tabName = "building_density",
                fluidRow(
                  column(width = 12,
                         plotOutput("map_selected2", height = "500px", width = "500px"))  # Fixed height and width for the plot
                )
        )
      )
    )
  )

  # Define server logic
  server <- function(input, output) {
    # Output variable names for selected map
    output$map_selected <- renderPlot({
      # Check which map type is selected and render the corresponding map
      if (input$map_type == "Buffer Map") {
        city_map_buffer
      } else if (input$map_type == "Boundary Map") {
        city_map_boundaries
      }
    })

    output$map_selected2 <- renderPlot({
      # Render hex map dynamically based on selected map type and number of bins
      bins <- input$bins # Get the selected number of bins
      if (input$map_type == "Buffer Map") {
        hexbin_map(city_df_buffer, bins, "Building Density, Pixel-Based Analysis")
      } else if (input$map_type == "Boundary Map") {
        hexbin_map(city_df_boundaries, bins, "Building Density, Pixel-Based Analysis")
      }
    })
  }

  # Run the application
  shinyApp(ui, server)
}
