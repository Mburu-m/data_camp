
library(sp)
load("nc_zips.rda")
library(tidyverse)
glimpse(shp@data)
# Print the class of the data slot of shp
class(shp@data)

# Print GEOID10
shp@data$GEOID10 

load("wealthiest_zips.rda")


# Glimpse the nc_income data
glimpse(nc_income)

# Summarize the nc_income data
summary(nc_income)

# Left join nc_income onto shp@data and store in shp_nc_income
shp_nc_income <- shp@data %>% 
    left_join(nc_income, by = c("GEOID10" = "zipcode"))

# Print the number of missing values of each variable in shp_nc_income
shp_nc_income  %>%
    summarize_all(funs(sum(is.na(.))))


shp %>% 
    leaflet() %>% 
    addTiles() %>% 
    addPolygons()


# map the polygons in shp
shp %>% 
    leaflet() %>% 
    addTiles() %>% 
    addPolygons()

# which zips were not in the income data?
shp_na <- shp[is.na(shp$mean_income),]

# map the polygons in shp_na
shp_na %>% 
    leaflet() %>% 
    addTiles() %>% 
    addPolygons()


# summarize the mean income variable
summary(shp$mean_income)

# subset shp to include only zip codes in the top quartile of mean income
high_inc <- shp[!is.na(shp$mean_income) & shp$mean_income > 55917,]

# map the boundaries of the zip codes in the top quartile of mean income
high_inc %>%
    leaflet() %>%
    addTiles() %>%
    addPolygons()





# create color palette with colorNumeric()
nc_pal <- colorNumeric("YlGn", domain = high_inc@data$mean_income)

high_inc %>%
    leaflet() %>%
    addTiles() %>%
    # set boundary thickness to 1 and color polygons
    addPolygons(weight = 1, col = ~nc_pal(mean_income),
                # add labels that display mean income
                label = ~paste0("Mean Income: ", dollar(mean_income)),
                # highlight polygons on hover
                highlight = highlightOptions(weight = 5, color = "white",
                                             bringToFront = TRUE))




# Use the log function to create a new version of nc_pal
nc_pal <- colorNumeric("YlGn", domain = log(high_inc@data$mean_income))

# comment out the map tile
high_inc %>%
    leaflet() %>%
    #addProviderTiles("CartoDB") %>%
    # apply the new nc_pal to the map
    addPolygons(weight = 1, color = ~nc_pal(log(mean_income)), fillOpacity = 1,
                label = ~paste0("Mean Income: ", dollar(mean_income)),
                highlightOptions = highlightOptions(weight = 5, color = "white", bringToFront = TRUE))



# plot zip codes with mean incomes >= $200k
wealthy_zips %>% 
    leaflet() %>% 
    addProviderTiles("CartoDB") %>% 
    # set color to green and create Wealth Zipcodes group
    addPolygons(weight = 1, fillOpacity = .7, color = "green",  group = "Wealthy Zipcodes", 
                label = ~paste0("Mean Income: ", dollar(mean_income)),
                highlightOptions = highlightOptions(weight = 5, color = "white", bringToFront = TRUE))



# Add polygons using wealthy_zips
final_map <- m4 %>% 
    addPolygons(data = wealthy_zips, weight = 1, fillOpacity = .5, color = "Grey",  group = "Wealthy Zip Codes", 
                label = ~paste0("Mean Income: ", dollar(mean_income)),
                highlightOptions = highlightOptions(weight = 5, color = "white", bringToFront = TRUE)) %>% 
    # Update layer controls including "Wealthy Zip Codes"
    addLayersControl(baseGroups = c("OSM", "Carto", "Esri"), 
                     overlayGroups = c("Public", "Private", "For-Profit", "Wealthy Zip Codes"))     

# Print and explore your very last map of the course!
final_map
                  
                  
                  