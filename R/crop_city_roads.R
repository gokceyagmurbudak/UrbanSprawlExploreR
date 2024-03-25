#' Crop City Roads
#'
#' This function crops the specified city roads dataset based on the provided boundary, buffer or spatial object.
#'
#' @param city_roads A spatial object containing the city roads dataset.
#' @param cropped_method  A spatial object representing the boundary or area to crop the city roads dataset.
#'
#' @return A spatial object containing the cropped city roads dataset.
#'
#' @details This function intersects the city roads dataset with the specified boundary or area to crop the roads within that boundary.
#'
#' @export
#'
#' @import sf ggplot2
#'
#' @examples
#' city_roads_inside_buffer <- crop_city_roads(city_roads,crop_raster_by_buffer$buffer_polygon)
#' city_roads_inside_boundaries <- crop_city_roads(city_roads,city_border_osm)

crop_city_roads <- function(city_roads, cropped_method) {
  roads_cropped <- sf::st_intersection(city_roads, cropped_method)

  p <- ggplot() +
    geom_sf(
      data = cropped_method,
      color = "#3036ff", fill = NA,
      size = 1.2, inherit.aes = FALSE
    ) +
    geom_sf(
      data = roads_cropped, fill = "transparent",
      aes(color=highway), inherit.aes = FALSE
    ) +
    theme_void() +
    theme(panel.grid.major = element_line("transparent"))

  print(p)
  return(roads_cropped)
}
