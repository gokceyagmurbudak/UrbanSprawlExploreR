#' Extract OSM Roads for City
#'
#' This function calls OpenStreetMap (OSM) road data for a specified city boundary and plots the roads.
#'
#' @param city_border A spatial object representing the boundary of the city.
#' @param road_tags A character vector specifying the types of roads to retrieve from OSM.
#' @param crsLONGLAT A character string representing the coordinate reference system (CRS) for the city boundary.
#'
#' @return A spatial object containing the OSM roads data for the specified city.
#'
#' @details This function calls road data from OpenStreetMap (OSM) for a specified city boundary and plots
#' the roads using ggplot2. The road types to be taken can be specified using the road_tags parameter.
#'
#' @export
#' @examples
#' road_tags <- c("motorway", "trunk", "primary", "secondary",
#'"tertiary", "motorway_link", "trunk_link",
#'"primary_link", "secondary_link", "tertiary_link")
#'
#' city_roads <- city_osm_roads(city_border_osm, road_tags, crsLONGLAT)
#'
city_osm_roads <- function(city_border, road_tags, crsLONGLAT) {
  # Retrieve OSM roads data
  roads <- sf::st_bbox(city_border) |>
    osmdata::opq() |>
    osmdata::add_osm_feature(
      key = "highway",
      value = road_tags
    ) |>
    osmdata::osmdata_sf()

  city_roads <- roads$osm_lines |>
    sf::st_transform(crs = crsLONGLAT)

  # Plot OSM roads
  plot <- ggplot() +
    geom_sf(
      data = sf::st_centroid(city_border), fill = "transparent",
      color = "#3036ff", size = 1.2,
      inherit.aes = FALSE
    ) +
    geom_sf(
      data = city_roads,
      aes(color=highway)
    ) +
    theme_void() +
    theme(panel.grid.major = element_line("transparent"))

  # Print the plot
  print(plot)

  # Return city_roads
  return(city_roads)
}
