# UrbanSprawlExploreR

#### Install the library 

Please use the commands below;
```
library(devtools)
install_github("gokceyagmurbudak/UrbanSprawlExploreR")
```
#### Operations

**Please run all functions in this order;**

Calling library and dataset;
```
library(UrbanSprawlExploreR)
```
```
example("fetch_builtup_data")
```
```
example("get_city_boundaries")
```

Cropping the built--up raster images according to the boundaries or buffer (circle or square) of relevant city;
```
example("crop_raster_by_boundaries")
```
```
example("crop_raster_by_buffer")
```

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
