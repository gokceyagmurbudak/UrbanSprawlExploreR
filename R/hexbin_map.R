#' Hexbin Map
#'
#' This function creates a hexbin density map based on a dataframe containing new builtup data.
#'
#' @param city_df A dataframe containing city data, including x and y coordinates.
#' @param bins An integer specifying the number of hexagonal bins for the density map.
#' @param title A character string specifying the title of the map.
#'
#' @return A ggplot2 object representing the hexbin density map.
#'
#' @details This function creates a hexbin density map based on the provided city data dataframe.
#' It filters the dataframe to include only areas with a value of 1 (indicating new buildings), and then plots
#' the density of these new buildings using hexagonal bins. The map is customized with the specified title and styling parameters.
#' @import ggplot2 viridis
#' @export
#'
#' @examples
#' hex_map_polygon <- hexbin_map(city_df_boundaries,15,"Building Desinty, Pixel-Based Analysis")
#' hex_map_buffer <- hexbin_map(city_df_buffer,15,"Building Desinty, Pixel-Based Analysis")


hexbin_map <- function(city_df, bins, title) {
  new_city_df_polygon <- city_df[city_df$value == 1, ]

  my_palette <- c("#FFFFCC", "#FFEDA0", "#FED976", "#FEB24C", "#FD8D3C", "#FC4E2A", "#E31A1C")
  # Plot the density map with hexagonal bins
  p <- ggplot(new_city_df_polygon, aes(x = x, y = y)) +
    geom_hex(bins = bins, aes(fill = after_stat(count)), color = "#ffffff") +  # Use fill aesthetic for count
    theme_void() +
    scale_fill_viridis(
      option="B",
      trans = "log",
      #breaks = c(1,250,500,750,1000),
      name="New Building Density",
      #guide = guide_legend( keyheight = unit(2.5, units = "mm"), keywidth=unit(10, units = "mm"), label.position = "bottom", title.position = 'top', nrow=1)
      labels = scales::label_number(accuracy = 1)
    ) +
    labs(title = title) +  # Customize labels
    theme(
      legend.position = "bottom",  # Position legend at the bottom
      legend.title = element_text(color = "#4e4d47", size = 10),  # Customize legend title
      legend.text = element_text(color = "#4e4d47", size = 8),  # Customize legend text
      plot.title = element_text(size = 14, hjust = 0.5, color = "#4e4d47", margin = margin(b = 10)),  # Adjust plot title
      plot.background = element_rect(fill = "#E5E5E5", color = NA),  # Background color
      panel.background = element_rect(fill = "#E5E5E5", color = NA),  # Panel background color
      legend.background = element_rect(fill = "#E5E5E5", color = NA)  # Legend background color
    )
  print(p)
  return(p)
}
