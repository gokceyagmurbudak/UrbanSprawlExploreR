#' Create Map
#'
#' This function creates a map by overlaying a raster dataset and cropped roads on a ggplot2 plot.
#'
#' @param raster_df A dataframe containing the values of the raster dataset.
#' @param roads_cropped  A spatial object containing the cropped roads dataset
#' @param title A character string specifying the title of the map.
#' @param caption A character string providing additional information or caption for the map.
#'
#' @return A ggplot2 object representing the created map.
#' @details This function creates a map by overlaying a raster dataset, which represents built-up areas, and cropped roads
#' dataset on a ggplot2 plot. The map is customized with specified title, caption, and styling parameters. Please use zoom on Plots window
#' to observe full size of the map.
#'
#' @export
#'
#' @examples
#' city_map_buffer <- create_map(city_df_buffer, city_roads_inside_buffer, "Istanbul Urban Expansion 2000-2020","Created by <name>")
#' city_map_boundaries <- create_map(city_df_boundaries, city_roads_inside_boundaries, "Istanbul Urban Expansion 2000-2020","Created by <name>")
#'
#' #ggsave(
#'  # filename = "built_up.png",
#'  # width = 6, height = 6, dpi = 600,
#'  # device = "png", city_map_boundaries #city_map_buffer
#' # )

create_map <- function(raster_df, roads_cropped, title, caption) {
  colrs <- c(
    "#edebe4", "#e71d36","#2ca25f"
  )

  p <- ggplot() +
    geom_raster(
      data = raster_df,
      aes(x = x, y = y, fill = cat),
      alpha = 0.8
    ) +
    geom_sf(
      data = roads_cropped,
      color = "#edebe4",
      size = 0.1,
      alpha = 0.5,
      fill = "transparent"
    ) +
    scale_fill_manual(
      name = "",
      values = colrs,
      drop = FALSE
    ) +
    guides(
      fill = guide_legend(
        direction = "horizontal",
        keyheight = unit(1.5, units = "mm"),
        keywidth = unit(35, units = "mm"),
        title.position = "top",
        title.hjust = 0.5,
        label.hjust = 0.5,
        nrow = 1,
        byrow = TRUE,
        reverse = FALSE,
        label.position = "top"
      )
    ) +
    theme_minimal() +
    theme(
      axis.line = element_blank(),
      axis.text.x = element_blank(),
      axis.text.y = element_blank(),
      axis.ticks = element_blank(),
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      legend.position = c(0.5, 1.05),
      legend.text = element_text(size = 12, color = "black"),
      legend.title = element_text(size = 14, color = "black"),
      legend.spacing.y = unit(0.25, "cm"),
      panel.grid.major = element_line(color = "#f5f0f0", size = 0.2),
      panel.grid.minor = element_blank(),
      plot.title = element_text(
        size = 20, color = "#14213d", hjust = 0.5, vjust = 2
      ),
      plot.caption = element_text(
        size = 9, color = "#14213d", hjust = 0.5, vjust = 5
      ),
      plot.margin = unit(c(t = 1, r = 0, b = 0, l = 0), "lines"),
      plot.background = element_rect(fill = "#f5f0f0", color = NA),
      panel.background = element_rect(fill = "#f5f0f0", color = NA),
      legend.background = element_rect(fill = "#f5f0f0", color = NA),
      legend.key = element_rect(colour = "black"),
      panel.border = element_blank()
    ) +
    labs(
      x = "",
      y = NULL,
      title = title,
      subtitle = "",
      caption = caption
    )
  print(p)
  return(p)
}
