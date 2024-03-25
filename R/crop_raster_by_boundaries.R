#' Crop Raster by Boundaries
#'
#' This function crops a raster data using the boundaries defined by a polygon.
#'
#' @param raster_data A raster object representing the raster dataset to be cropped.
#' @param polygon_data A vector or object containing the polygon boundaries.
#'
#' @return  A cropped raster object with the specified boundaries.
#' @export
#'
#' @examples
#' crop_raster_by_boundaries<- crop_raster_by_boundaries(builtup_raster_data, city_border_osm)

crop_raster_by_boundaries <- function(raster_data, polygon_data) {
  terra::crs(raster_data) <- crsLONGLAT
  # Convert polygon data to vector format compatible with terra
  polygon_vect <- terra::vect(polygon_data)

  # # Set CRS of polygon data to match CRS of raster data
  terra::crs(polygon_vect) <- terra::crs(raster_data)

  # Crop the raster data with the polygon
  raster_cropped <- terra::crop(raster_data, polygon_vect)

  # Mask the cropped raster with the polygon
  raster_masked <- terra::mask(raster_cropped, polygon_vect)

  terra::plot(raster_masked)
  return(raster_masked)
}
