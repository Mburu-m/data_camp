leaflet() %>%
    addTiles() %>% 
    addSearchOSM() %>% 
    addReverseSearchOSM()

m2 <- 
    ipeds %>% 
    leaflet() %>% 
    # use the CartoDB provider tile
    addProviderTiles(provider = "CartoDB" ) %>% 
    # center on the middle of the US with zoom of 3
    setView(lat = 39.8282, lng = -98.5795, zoom = 3)

# Map all American colleges 
m2 %>% 
    addCircleMarkers() 

# Load the htmltools package
library(htmltools)

# Create data frame called public with only public colleges
public <- filter(ipeds, sector_label == "Public")  

# Create a leaflet map of public colleges called m3 
m3 <- leaflet() %>% 
    addProviderTiles("CartoDB") %>% 
    addCircleMarkers(data = public, radius = 2, label = ~htmlEscape(name),
                     color = ~pal(sector_label), group = "Public")

m3


# Create data frame called private with only private colleges
private <- filter(ipeds, sector_label == "Private")  

# Add private colleges to `m3` as a new layer
m3 <- m3 %>% 
    addCircleMarkers(data = private, radius = 2, label = ~htmlEscape(name),
                     color = ~pal(sector_label), group = "Private") %>% 
    addLayersControl(overlayGroups = c("Public", "Private"))

m3



# Create data frame called profit with only For-Profit colleges
profit <- filter(ipeds, sector_label == "For-Profit")  

# Add For-Profit colleges to `m3` as a new layer
m3 <- m3 %>% 
    addCircleMarkers(data = profit, radius = 2, label = ~htmlEscape(name),
                     color = ~pal(sector_label),   group = "For-Profit")  %>% 
    addLayersControl(overlayGroups = c("Public", "Private", "For-Profit"))  

# Center the map on the middle of the US with a zoom of 4
m4 <- m3 %>%
    setView(lat = 39.8282, lng = -98.5795, zoom = 4) 

m4

leaflet() %>% 
    # Add the OSM, CartoDB and Esri tiles
    addTiles(group = "OSM") %>% 
    addProviderTiles("CartoDB", group = "CartoDB") %>% 
    addProviderTiles("Esri", group = "Esri") %>% 
    # Use addLayersControl to allow users to toggle between basemaps
    addLayersControl(baseGroups = c("OSM", "CartoDB", "Esri"))



m4 <- leaflet() %>% 
    addTiles(group = "OSM") %>% 
    addProviderTiles("CartoDB", group = "Carto") %>% 
    addProviderTiles("Esri", group = "Esri") %>% 
    addCircleMarkers(data = public, radius = 2, label = ~htmlEscape(name),
                     color = ~pal(sector_label),  group = "Public") %>% 
    addCircleMarkers(data = private, radius = 2, label = ~htmlEscape(name),
                     color = ~pal(sector_label), group = "Private")  %>% 
    addCircleMarkers(data = profit, radius = 2, label = ~htmlEscape(name),
                     color = ~pal(sector_label), group = "For-Profit")  %>% 
    addLayersControl(baseGroups = c("OSM", "Carto", "Esri"), 
                     overlayGroups = c("Public", "Private", "For-Profit")) %>% 
    setView(lat = 39.8282, lng = -98.5795, zoom = 4) 

m4



# Make each sector of colleges searchable 
m4_search <- m4  %>% 
    addSearchFeatures(
        targetGroups =  c("Public", "Private", "For-Profit"), 
        # Set the search zoom level to 18
        options = searchFeaturesOptions(zoom = 18 )) 

# Try searching the map for a college
m4_search


ipeds %>% 
    leaflet() %>% 
    addTiles() %>% 
    # Sanitize any html in our labels
    addCircleMarkers(radius = 2, label = ~htmlEscape(name),
                     # Color code colleges by sector using the `pal` color palette
                     color = ~pal(sector_label),
                     # Cluster all colleges using `clusterOptions`
                     clusterOptions = markerClusterOptions()) 