# Load necessary libraries
library(sf)
library(leaflet)
library(leaflet.extras)
library(readxl)
library(htmlwidgets)
library(dplyr)

# Set the path to the shapefile
shapefile_path <- "GDA94"

# Read the shapefile
map_data <- st_read(dsn = shapefile_path)

# Transform to desired CRS if needed
map_data <- st_transform(map_data, crs = 4326)

map_data <- map_data %>%
  mutate(LOC_NAME = ifelse(LOC_PID == "loc2c42697adc03", "The Rockss", LOC_NAME))

# Read the temperature data
temperature_data <- read_excel("loc_name_temperature.xlsx")

# Merge the datasets based on location name
merged_data <- merge(map_data, temperature_data, by.x = "LOC_NAME", by.y = "LOC_NAME", all.x = TRUE)

# Filter out NA values from Temperature column
merged_data <- merged_data[!is.na(merged_data$Temperature), ]

# Create a color palette
pal <- colorNumeric("YlOrRd", merged_data$Temperature)

# Load the tree shapefile
trees_shapefile <- st_read(dsn = "Trees")

# Check the geometry type of the tree shapefile
st_geometry_type(trees_shapefile)

# Transform the tree shapefile if needed
trees_shapefile <- st_transform(trees_shapefile, crs = st_crs(map_data))

# Add the tree layer as markers to the leaflet map
leaflet(data = merged_data) %>%
  addTiles() %>%
  addPolygons(fillColor = ~pal(Temperature),
              fillOpacity = 0.8,
              color = "white",
              weight = 1,
              label = ~paste(LOC_NAME, Temperature, "°C")) %>%
  addLegend(pal = pal, values = ~Temperature,
            title = "Temperature",
            position = "bottomright") %>%
  addCircleMarkers(data = trees_shapefile,
                   color = "green",
                   radius = 2,
                   fillOpacity = 0.8,
                   group = ~TreeType,  # Group markers by TreeType
                   popup = ~paste("Tree Type:", CommonName, "<br>",
                                  "Tree Height:", TreeHeight, "m<br>",
                                  "Tree Canopy:", TreeCanopy, "m")) %>%
  addLayersControl(
    overlayGroups = unique(trees_shapefile$TreeType),
    options = layersControlOptions(collapsed = FALSE, title = "Tree Type")
  ) %>%
  saveWidget(file = "FloraTempTreeCircle.html", selfcontained = TRUE)

