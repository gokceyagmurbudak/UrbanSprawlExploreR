#' Get City Boundaries from OSM data
#'
#' This function retrieves the boundaries of a specified city and plots them on top of raster data.
#'
#' @param city_name A character string specifying the name of the city.
#' @param raster_data A raster object containing the data to be plotted.
#' @param crsLONGLAT A character string representing the coordinate reference system CRS for the city boundaries.
#'
#' @return A sf polygon object representing the boundaries of the specified city.
#'
#' @details This function uses the OpenStreetMap OSM API to retrieve the bounding box of the specified city,
#' converts it into a spatial polygon object, and plots it on top of the provided raster (buildup_raster_data) data.
#'
#' @export
#'
#' @examples
#'city <- "Istanbul"
#'
#'city_border_osm <- get_city_boundaries(city, builtup_raster_data, crsLONGLAT)


get_city_boundaries <- function(city_name,raster_data, crsLONGLAT) {
  # Get the bounding box of the city
  city_border <- osmdata::getbb(
    city_name,
    format_out = "sf_polygon"
  ) |>
    sf::st_transform(crsLONGLAT)

  # Merge the city borders into a single polygon
  #merged_border <- sf::st_union(city_border)

  # Plot the raster data
  terra::plot(raster_data)

  # Plot the city border on top of the raster data
  plot(city_border, add = TRUE)

  return(city_border)
}
