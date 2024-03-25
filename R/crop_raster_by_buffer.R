#' Crop Raster by Buffer
#'
#' This function crops a raster dataset using a buffer zone around a city boundary.
#'
#' @param city_border A spatial object representing the boundary of the city.
#' @param buffer_size_km The size of the buffer zone in kilometers.
#' @param buffer_shape The shape of the buffer zone, either "circle" or "square".
#' @param builtup_raster_data A raster object representing the built-up data.
#'
#' @return A list containing the buffer polygon and the cropped raster data.($buffer_polygon and $raster_masked)
#'
#' @details This function allows you to crop a raster dataset using a buffer zone around a city boundary.
#' The buffer can be either a circle or a square shape.
#' @import terra sf
#' @export
#'
#' @examples
#' buffer_size <- 30
#' buffer_shape <- "square"
#' crop_raster_by_buffer <- crop_raster_by_buffer(city_border_osm, buffer_size, buffer_shape, builtup_raster_data)


crop_raster_by_buffer <- function(city_border, buffer_size_km, buffer_shape, builtup_raster_data) {
  # Define function to get circle buffer
  get_buffer <- function(city_border, buffer_distance_km) {
    buffer_cents <- sf::st_centroid(city_border)
    buffer_circle <- sf::st_buffer(
      buffer_cents,
      dist = units::set_units(buffer_distance_km, km)
    ) %>%
      st_set_crs(st_crs(city_border)) %>%
      st_transform(crs = st_crs(city_border))
    return(buffer_circle)
  }

  # Define function to get square buffer
  get_buffer_square <- function(city_border, buffer_distance_km){
    buffer_cents <- st_centroid(city_border)
    buffer_round <- st_buffer(
      buffer_cents,
      dist = units::set_units(buffer_distance_km, km)
    )
    buffer_square <- sf::st_as_sfc(sf::st_bbox(buffer_round))

    return(buffer_square)
  }


  # Define function to crop builtup data
  crop_builtup_data <- function(raster_data, buffer_polygon) {
    polygon_vect <- terra::vect(buffer_polygon)
    raster_cropped <- crop(raster_data, polygon_vect)
    raster_masked <- mask(raster_cropped, polygon_vect)
    return(raster_masked)
  }

  if (buffer_shape == "circle") {
    buffer_shape_function <- get_buffer
  } else if (buffer_shape == "square") {
    buffer_shape_function <- get_buffer_square
  } else {
    stop("Invalid buffer shape. Please choose 'circle' or 'square'.")
  }

  # Generate buffer
  buffer_polygon <- buffer_shape_function(city_border, buffer_size_km)


  # Crop builtup data with buffer
  raster_masked <- crop_builtup_data(builtup_raster_data, buffer_polygon)

  terra::plot(raster_masked)
  # Return buffer polygon and cropped raster
  return(list(buffer_polygon = buffer_polygon, raster_masked = raster_masked))
}
