# Load the leaflet library
library(leaflet)
library(tidyverse)
# Create a leaflet map with default map tile using addTiles()
leaflet() %>%
    addTiles()


names(providers)

# Print the providers list included in the leaflet library
providers

# Print only the names of the map tiles in the providers list 
names(providers)

# Use str_detect() to determine if the name of each provider tile contains the string "CartoDB"
str_detect(names(providers), "CartoDB")

# Use str_detect() to print only the provider tile names that include the string "CartoDB"
names(providers)[str_detect(names(providers), "CartoDB")]

# Change addTiles() to addProviderTiles() and set the provider argument to "CartoDB"
leaflet() %>% 
    addProviderTiles(provider =  "CartoDB")


# Map with CartoDB tile centered on DataCamp's NYC office with zoom of 6
leaflet()  %>% 
    addProviderTiles("CartoDB")  %>% 
    setView(lng = -73.98575, lat = 40.74856, zoom = 6)


# Map with CartoDB.PositronNoLabels tile centered on DataCamp's Belgium office with zoom of 4
leaflet() %>% 
    addProviderTiles("CartoDB.PositronNoLabels") %>% 
    setView(lng = dc_hq$lon[2], lat = dc_hq$lat[2], zoom = 4)


leaflet(options = leafletOptions(
    # Set minZoom and dragging 
    minZoom = 12, dragging = TRUE))  %>% 
    addProviderTiles("CartoDB")  %>% 
    
    # Set default zoom level 
    setView(lng = dc_hq$lon[2], lat = dc_hq$lat[2], zoom = 14) %>% 
    
    # Set max bounds of map 
    setMaxBounds(lng1 = dc_hq$lon[2] + .05, 
                 lat1 = dc_hq$lat[2] + .05, 
                 lng2 = dc_hq$lon[2] - .05, 
                 lat2 = dc_hq$lat[2] - .05) 


# Plot DataCamp's NYC HQ
leaflet() %>% 
    addProviderTiles("CartoDB") %>% 
    addMarkers(lng = dc_hq$lon[1], lat = dc_hq$lat[1])


# Plot DataCamp's NYC HQ with zoom of 12    
leaflet() %>% 
    addProviderTiles("CartoDB") %>% 
    addMarkers(lng = -73.98575, lat = 40.74856)  %>% 
    setView(lng = -73.98575, lat = 40.74856, zoom = 12)    


# Plot both DataCamp's NYC and Belgium locations
leaflet() %>% 
    addProviderTiles("CartoDB") %>% 
    addMarkers(lng = dc_hq$lon, lat = dc_hq$lat)


# Store leaflet hq map in an object called map
map <- leaflet() %>%
    addProviderTiles("CartoDB") %>%
    # Use dc_hq to add the hq column as popups
    addMarkers(lng = dc_hq$lon, lat = dc_hq$lat,
               popup = dc_hq$hq)

# Center the view of map on the Belgium HQ with a zoom of 5 
map_zoom <- map %>%
    setView(lat = 50.881363, lng = 4.717863,
            zoom = 5)

# Print map_zoom
map_zoom