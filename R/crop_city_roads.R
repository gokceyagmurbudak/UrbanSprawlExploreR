#' Crop City Roads
#'
#' This function crops city roads based on specified road tags and a cropping method.
#'
#' @param road_tags A character vector specifying the types of roads to include.
#' @param cropped_method An object representing the method used for cropping the roads.
#' @param crsLONGLAT The coordinate reference system (CRS) for the output roads.
#'
#' @return An sf object representing the cropped city roads.
#' @export
#'
#' @examples
#' road_tags <- c("motorway", "trunk", "primary", "secondary",
#' "tertiary", "motorway_link", "trunk_link",
#' "primary_link", "secondary_link", "tertiary_link")
#'
#' city_roads_inside_buffer <- crop_city_roads(road_tags,crop_raster_buffer$buffer_polygon, crsLONGLAT)
#' city_roads_inside_boundaries <- crop_city_roads(road_tags,city_border_osm,crsLONGLAT)

crop_city_roads <- function(road_tags,cropped_method,crsLONGLAT) {
  roads <- sf::st_bbox(cropped_method) |>
    osmdata::opq() |>
    osmdata::add_osm_feature(
      key = "highway",
      value = road_tags
    ) |>
    osmdata::osmdata_sf()

  city_roads <- roads$osm_lines |>
    sf::st_transform(crs = crsLONGLAT)

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
