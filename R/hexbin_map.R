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
#' hex_map_polygon <- hexbin_map(city_df_boundaries,100,"Building Desinty, Pixel-Based Analysis")
#' hex_map_buffer <- hexbin_map(city_df_buffer,100,"Building Desinty, Pixel-Based Analysis")
#'
#' #ggsave(
#' #filename = "hex_map_polygon.png",
#' #width = 6, height = 6, dpi = 600,
#' #device = "png", hex_map_polygon #hex_map_buffer
#' #)


hexbin_map <- function(city_df, bins, title) {
  # new_builtup_density_map
  new_city_df_polygon <- city_df[city_df$value == 1, ]

  # Plot the density map with hexagonal bins
  p <- ggplot(new_city_df_polygon, aes(x = x, y = y)) +
    geom_hex(bins = bins, aes(fill = after_stat(count)), color = "#ffffff") +  # Use fill aesthetic for percentage
    theme_void() +
    scale_fill_viridis(option = "B",
                       guide = guide_legend( keyheight = unit(2.5, units = "mm"),limits=c(0,100),
                                             keywidth=unit(10, units = "mm"), label.position = "bottom",
                                             title.position = 'top',title.hjust = 0.5, nrow=1), name = "Number of Pixels of New Built-up Class")+
    labs(title = title) +  # Customize labels
    theme(
      legend.position = "bottom",  # Position legend at the bottom
      legend.title = element_text(color = "#4e4d47", size = 10),  # Customize legend title
      legend.text = element_text(color = "#4e4d47", size = 8),  # Customize legend text
      plot.title = element_text(
        size = 20, color = "#14213d", hjust = 0.5, vjust = 2
      ),
      plot.caption = element_text(
        size = 9, color = "#14213d", hjust = 0.5, vjust = 5
      ),
      plot.margin = unit(c(t = 1, r = 0, b = 0, l = 0), "lines"),
      plot.background = element_rect(fill = "#fcfafa", color = NA),  # Background color
      panel.background = element_rect(fill = "#fcfafa", color = NA),  # Panel background color
      legend.background = element_rect(fill = "#fcfafa", color = NA),  # Legend background color
      panel.border = element_blank()
    )
  print(p)
  return(p)
}
