# UrbanSprawlExploreR

This package use [Global Land Cover and Land Use Change, 2000-2020 dataset](https://glad.umd.edu/dataset/GLCLUC2020) to generate built-up change and new building density map.
Before you start using the package, check which tile your study area falls on with QGIS software [here](https://glad.umd.edu/users/Potapov/GLCLUC2020/10d_tiles.zip).

### Install the library 

Please use the commands below;
```
library(devtools)
install_github("gokceyagmurbudak/UrbanSprawlExploreR")
```
### Operations

**Please run all functions in this order;**

Calling library and dataset;
```
library(UrbanSprawlExploreR)
```
```
example("fetch_builtup_data")
```
<a href="https://drive.google.com/uc?export=view&id=1C1mROUeTyEOI5p2fIYJDJpHFvYzSIoXc"><img src="https://drive.google.com/uc?export=view&id=1C1mROUeTyEOI5p2fIYJDJpHFvYzSIoXc" style="width: 500px; max-width: 100%; height: auto" title="Click to enlarge picture" />

```
example("get_city_boundaries")
```
<a href="https://drive.google.com/uc?export=view&id=1fz8Erp_4iHJpFdAeJk51S5bT5r0eEUkq"><img src="https://drive.google.com/uc?export=view&id=1fz8Erp_4iHJpFdAeJk51S5bT5r0eEUkq" style="width: 500px; max-width: 100%; height: auto" title="Click to enlarge picture" />

Cropping the built--up raster images according to the boundaries or buffer (circle or square) of relevant city;
```
example("crop_raster_by_boundaries")
```
<a href="https://drive.google.com/uc?export=view&id=1XKfGrANjIBErdsSJZ-gX65HcI5aLajIX"><img src="https://drive.google.com/uc?export=view&id=1XKfGrANjIBErdsSJZ-gX65HcI5aLajIX" style="width: 500px; max-width: 100%; height: auto" title="Click to enlarge picture" />

```
example("crop_raster_by_buffer")
```
<a href="https://drive.google.com/uc?export=view&id=1Kz9atlKjQJwsmj5HeHo4873ymgrNxH4K"><img src="https://drive.google.com/uc?export=view&id=1Kz9atlKjQJwsmj5HeHo4873ymgrNxH4K" style="width: 500px; max-width: 100%; height: auto" title="Click to enlarge picture" />

Convert built-up raster image to dataframe to generate labels as characters;
```
example("raster_to_df")
```

Calling the road dataset from OSM to crop roads within the city;
```
example("city_osm_roads")
```
```
example("crop_city_roads")
```

Create a visual map and hexagon bining denstiy map for relevant city;
```
example("create_map")
```
```
example("hexbin_map")
```

### For Free Users:

Please change the variables for your usage;

```
url <- "https://glad.umd.edu/users/Potapov/GLCLUC2020/Built-up_change_2000_2020/"
#If your city is in the intersection, you can type more than one tile name, the function will merge it for you.
#eg. c("50N_020E","50N_030E")
lat_lon_list <- c("50N_020E")
crsLONGLAT <- "+proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +no_defs"
builtup_raster_data <- fetch_builtup_data(url, lat_lon_list, crsLONGLAT)

city <- "Istanbul"
city_border_osm <- get_city_boundaries(city, builtup_raster_data, crsLONGLAT)

crop_raster_boundaries<- crop_raster_by_boundaries(builtup_raster_data, city_border_osm)

buffer_size <- 15
buffer_shape <- "square" # or circle
crop_raster_buffer <- crop_raster_by_buffer(city_border_osm, buffer_size, buffer_shape, builtup_raster_data)

city_df_boundaries <- raster_to_df(crop_raster_boundaries)
city_df_buffer <- raster_to_df(crop_raster_buffer$raster_masked)

road_tags <- c("motorway", "trunk", "primary", "secondary",
               "tertiary", "motorway_link", "trunk_link",
               "primary_link", "secondary_link", "tertiary_link")

#city_roads <- city_osm_roads(city_border_osm, road_tags, crsLONGLAT)

city_roads_inside_buffer <- crop_city_roads(road_tags,crop_raster_buffer$buffer_polygon, crsLONGLAT)
city_roads_inside_boundaries <- crop_city_roads(road_tags,city_border_osm,crsLONGLAT)

city_map_buffer <- create_map(city_df_buffer, city_roads_inside_buffer, "Istanbul Urban Expansion 2000-2020","Created by <name>")
city_map_boundaries <- create_map(city_df_boundaries, city_roads_inside_boundaries, "Istanbul Urban Expansion 2000-2020","Created by <name>")

# ggsave(
# filename = "built_up.png",
# width = 6, height = 6, dpi = 600,
# device = "png", city_map_boundaries #city_map_buffer
# )

hex_map_polygon <- hexbin_map(city_df_boundaries,100,"Building Desinty, Pixel-Based Analysis")
hex_map_buffer <- hexbin_map(city_df_buffer,100,"Building Desinty, Pixel-Based Analysis")

UrbanExpansionUI(city_map_buffer,city_map_boundaries,city_df_buffer,city_df_boundaries)

```

