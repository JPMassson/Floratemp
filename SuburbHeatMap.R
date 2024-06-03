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

# Read the temperature data
temperature_data <- read_excel("loc_name_temperature.xlsx")

# Merge the datasets based on location name
merged_data <- merge(map_data, temperature_data, by.x = "LOC_NAME", by.y = "LOC_NAME", all.x = TRUE)

# Filter out NA values from Temperature column
merged_data <- merged_data[!is.na(merged_data$Temperature), ]

# Create a color palette
pal <- colorNumeric("YlOrRd", merged_data$Temperature)

# Create Leaflet map with clickable labels
leaflet(data = merged_data) %>%
  addTiles() %>%
  addPolygons(fillColor = ~pal(Temperature),
              fillOpacity = 0.8,
              color = "white",
              weight = 1,
              label = ~paste(LOC_NAME, Temperature, "°C")) %>%
  addLegend(pal = pal, values = ~Temperature,
            title = "Temperature",
            position = "bottomright")
