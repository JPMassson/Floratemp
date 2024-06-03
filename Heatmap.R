# Load necessary libraries
library(sf)
library(leaflet)
library(leaflet.extras)
library(readxl)

# Set the path to the shapefile
shapefile_path <- "GDA94"

# Read the shapefile
map_data <- st_read(dsn = shapefile_path)

# Transform to desired CRS if needed
map_data <- st_transform(map_data, crs = 4326)

# Read the temperature data from Excel
temperature_data <- read_excel("loc_name_temperature.xlsx")

# Merge the datasets based on LOC_NAME
merged_data <- merge(map_data, temperature_data, by = "LOC_NAME", all.x = TRUE)

# Create Leaflet map
leaflet(data = merged_data) %>%
  addTiles() %>%
  addPolygons(fillColor = ~colorNumeric("YlOrRd", merged_data$Temperature)(Temperature),
              fillOpacity = 0.8,
              color = "white",
              weight = 1)
