#' FETCH BUILD-UP DATA
#'
#' This function fetches built-up data from a given URL for specific locations
#' defined by Tile-s. (check here for your tile-s using QGIS https://glad.umd.edu/users/Potapov/GLCLUC2020/10d_tiles.zip).
#'
#' @param url A character string specifying the URL where the raster data is located.
#' @param lat_lon_list  A character vector specifying tile-s for the locations of interest.
#' @param crsLONGLAT A character string representing the coordinate reference system (CRS)
#'
#' @return A single or merged raster tile layer containing the built-up data for the specified locations.
#' @export
#'
#' @examples
#' url <- "https://glad.umd.edu/users/Potapov/GLCLUC2020/Built-up_change_2000_2020/"
#' lat_lon_list <- c("50N_020E")
#' crsLONGLAT <- "+proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +no_defs"
#'
#' builtup_raster_data <- fetch_builtup_data(url, lat_lon_list, crsLONGLAT)

fetch_builtup_data <- function(url, lat_lon_list, crsLONGLAT) {
  # Fetch raster links
  get_raster_links <- function(url) {
    res <- httr::GET(url, timeout=1000)#try timeout=100
    parse <- XML::htmlParse(res)
    links <- XML::xpathSApply(parse, path = "//a", XML::xmlGetAttr, "href")
    lnks <- links[-c(1:5)]
    rlinks <- paste0(url, lnks)
    return(rlinks)
  }

  rlinks <- get_raster_links(url)

  # Get built-up data for specific location
  load_builtup_data <- function(rlinks, lat_lon) {
    l <- rlinks[grepl(lat_lon, rlinks)]
    if (length(l) == 0) {
      stop("No raster found for lat_lon: ", lat_lon)
    }
    builtup_data <- terra::rast(l)
    #terra::crs(builtup_data) <- crsLONGLAT
    return(builtup_data)
  }

  # Load each raster layer and store them in a list
  raster_list <- lapply(lat_lon_list, function(lat_lon) load_builtup_data(rlinks, lat_lon))

  # Merge the raster layers if there are more than one
  if (length(raster_list) > 1) {
    merged_data <- do.call(terra::merge, raster_list)
    terra::crs(merged_data) <- crsLONGLAT
  } else if (length(raster_list) == 1) {
    merged_data <- raster_list[[1]]
    terra::crs(merged_data) <- crsLONGLAT
  } else {
    stop("No raster layers found to merge")
  }

  terra::plot(merged_data)
  return(merged_data)
}
