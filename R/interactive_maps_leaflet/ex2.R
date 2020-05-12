# Remove markers, reset bounds, and store the updated map in the m object
map_clear <- map %>%
    clearMarkers() %>% 
    clearBounds()

# Print the cleared map
map_clear

# Create a list of US States in descending order by the number of colleges in each state
ipeds  %>% 
    group_by(state)  %>% 
    count()  %>% 
    arrange(desc(n))


# Create a dataframe called `ca` with data on only colleges in California
ca <- ipeds %>%
    filter(state == "CA")

# Use `addMarkers` to plot all of the colleges in `ca` on the `m` leaflet map
map %>%
    addMarkers(lng = ca$lng, lat = ca$lat)

# Center the map on LA 
map %>% 
    addMarkers(data = ca) %>% 
    setView(lat = la_coords$lat, lng = la_coords$lon, zoom = 12)

map_zoom <-
    map %>%
    addMarkers(data = ca) %>%
    setView(lat = la_coords$lat, lng = la_coords$lon, zoom = 8)

map_zoom# Set the zoom level to 8 and store in the m object


# Change the radius of each circle to be 2 pixels and the color to red
map2 %>% 
    addCircleMarkers(lng = ca$lng, lat = ca$lat,
                     radius = 2, col = "red")

# Add circle markers with popups for college names
map %>% 
    addCircleMarkers(data = ca, radius = 2, popup = ~name)


# Add circle markers with popups for college names
map %>%
    addCircleMarkers(data = ca, radius = 2, popup = ~name)

# Change circle color to #2cb42c and store map in map_color object
map_color <- map %>% 
    addCircleMarkers(data = ca, radius = 2, color = "#2cb42c", popup = ~name)

# Print map_color
map_color


# Make the institution name in each popup bold
map2 %>% 
    addCircleMarkers(data = ca, radius = 2, 
                     popup = ~paste0("<b>", name, "</b>", "<br/>",  sector_label))



# Use paste0 to add sector information to the label inside parentheses 
map %>% 
    addCircleMarkers(data = ca, radius = 2, label = ~paste0(name, " (", sector_label, ")"))



# Make a color palette called pal for the values of `sector_label` using `colorFactor()`  
# Colors should be: "red", "blue", and "#9b4a11" for "Public", "Private", and "For-Profit" colleges, respectively
pal <- colorFactor(palette = c("red", "blue", "#9b4a11"), 
                   levels = c("Public", "Private", "For-Profit"))

# Add circle markers that color colleges using pal() and the values of sector_label
map2 <- 
    map %>% 
    addCircleMarkers(data = ca, radius = 2, 
                     color = ~pal(sector_label), 
                     label = ~paste0(name, " (", sector_label, ")"))

# Print map2
map2

# Customize the legend
m %>% 
    addLegend(pal = pal, 
              values = c("Public", "Private", "For-Profit"),
              # opacity of .5, title of Sector, and position of topright
              opacity = 0.5, title = "Sector", position = "topright")