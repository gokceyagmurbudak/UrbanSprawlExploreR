#' Convert Raster to Dataframe
#'
#' This function converts a raster (cropped raster by boundaries or buffer) data to a dataframe.
#'
#' @param raster_data
#'
#' @return A dataframe containing the values of the raster (x,y,values and cat columns).
#' @export
#'
#' @examples
#'
#'city_df_boundaries <- raster_to_df(crop_raster_boundaries)
#'city_df_buffer <- raster_to_df(crop_raster_buffer$raster_masked)


raster_to_df <- function(raster_data) {
  # Convert raster to dataframe
  raster_df <- terra::as.data.frame(raster_data, xy = TRUE)

  # Rename columns
  names(raster_df)[3] <- "value"

  # Create categorical variable based on the values
  raster_df$cat <- round(raster_df$value, 0)
  raster_df$cat <- factor(raster_df$cat, labels = c("no built-up", "new", "existing"))

  return(raster_df)
}
