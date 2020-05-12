
library(ggmap)

corvallis <- c(lon = -123.2620, lat = 44.5646)

# Add a maptype argument to get a satellite map
corvallis_map_sat <- get_map(corvallis, zoom = 13, maptype = "satellite")


register_google(api_google)

sales <- readRDS("01_corv_sales.rds")
# Edit to display satellite map
ggmap(corvallis_map_sat) +
    geom_point(aes(lon, lat, color = year_built), data = sales)


corvallis <- c(lon = -123.2620, lat = 44.5646)

# Add source and maptype to get toner map from Stamen Maps
corvallis_map_bw <- get_map(corvallis, zoom = 13, 
                            maptype = "toner", source ="stamen")

# Edit to display toner map
ggmap(corvallis_map_bw) +
    geom_point(aes(lon, lat, color = year_built), data = sales)


# Use base_layer argument to ggmap() to specify data and x, y mappings
ggmap(corvallis_map_bw,
      base_layer = ggplot(data = sales, aes(lon, lat )))+
    geom_point(aes(color = class))+ facet_wrap(~class)


qmplot(lon, lat, data = sales, 
       geom = "point", color = bedrooms) +
    facet_wrap(~ month)

# Add a point layer with color mapped to ward
head(ward_sales)
ggplot(ward_sales, aes(lon, lat)) +
    geom_point(aes(color = ward))


# Add a point layer with color mapped to group
ggplot(ward_sales, aes(lon, lat)) +
    geom_point(aes(color = group))


ggplot(ward_sales, aes(lon, lat)) +
    geom_path(aes(group = group))


# Add a polygon layer with fill mapped to ward, and group to group
ggplot(ward_sales, aes(lon, lat))+
    geom_polygon(aes(fill = ward, group = group))


# Fix the polygon cropping
ggmap(corvallis_map_bw, extent = "normal", maprange = FALSE,
      base_layer = ggplot(ward_sales, aes(lon, lat))) +
    geom_polygon(aes(group = group, fill = ward))


# Repeat, but map fill to num_sales
ggmap(corvallis_map_bw, 
      base_layer = ggplot(ward_sales, aes(lon, lat)),
      extent = "normal", maprange = FALSE) +
    geom_polygon(aes(group = group, fill = num_sales))

# Repeat again, but map fill to avg_price
ggmap(corvallis_map_bw, 
      base_layer = ggplot(ward_sales, aes(lon, lat)),
      extent = "normal", maprange = FALSE) +
    geom_polygon(aes(group = group, fill = avg_price), alpha = 0.8)



ggmap(corvallis_map_bw) +
  geom_tile(data = preds, aes(lon, lat, fill =predicted_price), alpha = 0.8)



# Call summary() on countries_spdf and countries_sp

summary(countries_spdf)

# Call str() with max.level = 2 on countries_spdf
str(countries_spdf, max.level = 2)

# Plot countries_spdf
plot(countries_spdf)


one <- countries_spdf@polygons[[169]]

# str() with max.level = 2, on the Polygons slot of one
str(one@Polygons, max.level = 2)

# str() with max.level = 2, on the 6th element of the one@Polygons

str(one@Polygons[[6]], max.level = 2)
# Call plot on the coords slot of 6th element of one@Polygons

plot(one@Polygons[[6]]@coords)


one <- countries_spdf@polygons[[169]]

# str() with max.level = 2, on the Polygons slot of one
str(one@Polygons, max.level = 2)

# str() with max.level = 2, on the 6th element of the one@Polygons

str(one@Polygons[[6]], max.level = 2)
# Call plot on the coords slot of 6th element of one@Polygons

plot(one@Polygons[[6]]@coords)

# Subset the 169th object of countries_spdf: usa
usa <- countries_spdf[169,]

# Look at summary() of usa

summary(usa)
# Look at str() of usa

str(usa)
# Call plot() on usa
plot(usa)


# Call head() and str() on the data slot of countries_spdf

head(countries_spdf@data)
str(countries_spdf@data)
# Pull out the name column using $

countries_spdf$name
# Pull out the subregion column using [[
countries_spdf[['subregion']]


# Create logical vector: is_nz

is_nz <- countries_spdf$name == "New Zealand"
# Subset countries_spdf using is_nz: nz
nz <- countries_spdf[is_nz, ]

# Plot nz
plot(nz)


library(sp)
library(tmap)

# Use qtm() to create a choropleth map of gdp

qtm(shp = countries_spdf, fill = "gdp")



library(sp)
library(tmap)

# Add style argument to the tm_fill() call
tm_shape(countries_spdf) +
  tm_fill(col = "population") +
  tm_borders(col = "burlywood4")
# Add a tm_borders() layer 


# New plot, with tm_bubbles() instead of tm_fill()

tm_shape(countries_spdf) +
  tm_bubbles(size = "population") +
  tm_borders(col = "burlywood4")



library(sp)
library(tmap)

# Add style argument to the tm_fill() call
tm_shape(countries_spdf) +
  tm_fill(col = "population", style = "quantile") +
  tm_borders(col = "burlywood4")
# Add a tm_borders() layer 


# New plot, with tm_bubbles() instead of tm_fill()

tm_shape(countries_spdf) +
  tm_bubbles(size = "population") +
  tm_borders(col = "burlywood4")


library(sp)
library(tmap)

# Switch to a Hobo–Dyer projection
tm_shape(countries_spdf, projection = "hd") +
  tm_grid(n.x = 11, n.y = 11) +
  tm_fill(col = "population", style = "quantile")  +
  tm_borders(col = "burlywood4") 

# Switch to a Robinson projection
tm_shape(countries_spdf, projection = "robin")+
  tm_grid(n.x = 11, n.y = 11) +
  tm_fill(col = "population", style = "quantile")  +
  tm_borders(col = "burlywood4") 

# Add tm_style_classic() to your plot
tm_shape(countries_spdf, projection = "robin")+
  tm_grid(n.x = 11, n.y = 11) +
  tm_fill(col = "population", style = "quantile")  +
  tm_borders(col = "burlywood4") +
  tm_style_classic()
  

library(sp)
library(tmap)

# Plot from last exercise
tm_shape(countries_spdf) +
  tm_grid(n.x = 11, n.y = 11, projection = "longlat") +
  tm_fill(col = "population", style = "quantile")  +
  tm_borders(col = "burlywood4")

# Save a static version "population.png"

save_tmap(filename = 'population.png')
# Save an interactive version "population.html"
save_tmap(filename = 'population.html')


library(raster)

# Print pop
print(pop)

# Call str() on pop, with max.level = 2
str(pop, max.level = 2)

# Call summary on pop
summary(pop)


# Call plot() on pop

plot(pop)
# Call str() on values(pop)

str(pop)
# Call head() on values(pop)
head(values(pop))
  
# Print pop_by_age

print(pop_by_age)
# Subset out the under_1 layer using [[
pop_by_age[["under_1"]]

# Plot the under_1 layer

plot(pop_by_age[["under_1"]])

library(tmap)

# Specify pop as the shp and add a tm_raster() layer
tm_shape(pop) +
  tm_raster()

# Plot the under_1 layer in pop_by_age

tm_shape(pop_by_age[['under_1']]) +
  tm_raster()

library(rasterVis)
# Call levelplot() on pop
levelplot(pop)



library(tmap)

# Specify pop as the shp and add a tm_raster() layer
tm_shape(pop) +
  tm_raster()

# Plot the under_1 layer in pop_by_age

tm_shape(pop_by_age) +
  tm_raster(col = "under_1")

library(rasterVis)
# Call levelplot() on pop
levelplot(pop)
#chroma and luminace are ordered use them in an ordered scale, hue is unordered

# Generate palettes from last time
library(RColorBrewer)
blups <- brewer.pal(9, "BuPu")

library(viridisLite)
vir <- viridis(9)
mag <- magma(9)

# Use the blups palette
tm_shape(prop_by_age) +
  tm_raster(col = "age_18_24", palette = blups) +
  tm_legend(position = c("right", "bottom"))

# Use the vir palette
tm_shape(prop_by_age) +
  tm_raster(col = "age_18_24", palette = vir) +
  tm_legend(position = c("right", "bottom"))

# Use the mag palette but reverse the order
tm_shape(prop_by_age) +
  tm_raster(col = "age_18_24", palette = rev(mag)) +
  tm_legend(position = c("right", "bottom"))

library(classInt)


mag <- viridisLite::magma(7)

library(classInt)

# Create 5 "pretty" breaks with classIntervals()

classIntervals(values(prop_by_age[["age_18_24"]]), style = "pretty", n =5)

# Create 5 "quantile" breaks with classIntervals()

classIntervals(values(prop_by_age[["age_18_24"]]), style = "quantile", n =5)


# Use 5 "quantile" breaks in tm_raster()
tm_shape(prop_by_age) +
  tm_raster(col ="age_18_24", palette = mag, style = "quantile") +
  tm_legend(position = c("right", "bottom"))

# Create histogram of proportions
hist(values(prop_by_age[["age_18_24"]]))

# Use fixed breaks in tm_raster()
tm_shape(prop_by_age) +
  tm_raster("age_18_24", palette = mag,
            style = "fixed", breaks = c(0.025, 0.05, 0.1, 0.2, 0.25, 0.3, 1))

# Save your plot to "prop_18-24.html"
save_tmap(filename = 'prop_18-24.html')



# Print migration
print(migration)

# Diverging "RdGy" palette
red_gray <- brewer.pal(7, "RdGy")

# Use red_gray as the palette 
tm_shape(migration) +
  tm_raster(palette = red_gray) +
  tm_legend(outside = TRUE, outside.position = c("bottom"))

# Add fixed breaks 
tm_shape(migration) +
  tm_raster(palette = red_gray,
            style = "fixed", breaks = c(-5e6, -5e3, -5e2, -5e1, 5e1, 5e2, 5e3, 5e6)) +
  tm_legend(outside = TRUE, outside.position = c("bottom"))




library(raster)

# Plot land_cover

tm_shape(land_cover) +
  tm_raster() 

# Palette like the ggplot2 default
hcl_cols <- hcl(h = seq(15, 375, length = 9), 
                c = 100, l = 65)[-9]

# Use hcl_cols as the palette

tm_shape(land_cover) +
  tm_raster(palette = hcl_cols)

# Examine levels of land_cover
levels(land_cover)

# A set of intuitive colors
intuitive_cols <- c(
  "darkgreen",
  "darkolivegreen4",
  "goldenrod2",
  "seagreen",
  "wheat",
  "slategrey",
  "white",
  "lightskyblue1"
)

# Use intuitive_cols as palette

tm_shape(land_cover) +
  tm_raster(palette = intuitive_cols)+
  tm_legend(position = c("left", "bottom"))


library(sp)
library(rgdal)

# Use dir() to find directory name

dir()
# Call dir() with directory name
dir("nynta_16c")

# Read in shapefile with readOGR(): neighborhoods

neighborhoods <- readOGR("nynta_16c","nynta")
# summary() of neighborhoods
summary(neighborhoods)

# Plot neighborhoods

plot(neighborhoods)


dir("nyc_grid_data")
# Use raster() with file path: income_grid

income_grid <- raster("nyc_grid_data/m5602ahhi00.tif")
# Call summary() on income_grid

summary(income_grid)
# Call plot() on income_grid


plot(income_grid)

library(sp)
library(tigris)

# Call tracts(): nyc_tracts
nyc_tracts <- tracts(state = "NY", county = "New York", cb = TRUE)

# Call summary() on nyc_tracts

summary(nyc_tracts)
# Plot nyc_tracts

plot(nyc_tracts)

library(sp)

# proj4string() on nyc_tracts and neighborhoods
proj4string(nyc_tracts)

proj4string(neighborhoods)
# coordinates() on nyc_tracts and neighborhoods

coordinates(nyc_tracts)
coordinates(neighborhoods)
# plot() neighborhoods and nyc_tracts
plot(neighborhoods)
plot(nyc_tracts,  add = T , col = "red")


library(sp)
library(raster)

# Use spTransform on neighborhoods: neighborhoods
neighborhoods <- spTransform(neighborhoods, proj4string(nyc_tracts))


# head() on coordinates() of neighborhoods
head(coordinates(neighborhoods))

# Plot neighborhoods, nyc_tracts and water
plot(neighborhoods)
plot(nyc_tracts, add = TRUE, col = "red")
plot(water, add = TRUE, col = "red")



library(sp)
library(raster)

# Use spTransform on neighborhoods: neighborhoods
neighborhoods <- spTransform(neighborhoods, proj4string(nyc_tracts))


# head() on coordinates() of neighborhoods
head(coordinates(neighborhoods))

# Plot neighborhoods, nyc_tracts and water
plot(neighborhoods)
plot(nyc_tracts, add = TRUE, col = "red")
plot(water, add = TRUE, col = "blue")


# Highlight tract 002201 in nyc_tracts
plot(nyc_tracts)
plot(nyc_tracts[nyc_tracts$TRACTCE == "002201", ], 
     col = "red", add = TRUE)

# Set nyc_tracts@data to nyc_income
nyc_tracts@data <- nyc_income

# Highlight tract 002201 again
plot(nyc_tracts)
plot(nyc_tracts[nyc_tracts$tract == "002201", ], 
     col = "red", add = TRUE)


# Check for duplicates in nyc_income

any(duplicated(nyc_income$tract))
# Check for duplicates in nyc_tracts
any(duplicated(nyc_tracts$TRACTCE))

# Check nyc_tracts in nyc_income

all(nyc_tracts$TRACTCE %in% nyc_income$tract)
# Check nyc_income in nyc_tracts
all(nyc_income$tract %in% nyc_tracts$TRACTCE)


# Merge nyc_tracts and nyc_income: nyc_tracts_merge
nyc_tracts_merge <- sp::merge(nyc_tracts, nyc_income, by.x = "TRACTCE", by.y = "tract")

# Call summary() on nyc_tracts_merge
summary(nyc_tracts_merge)

# Choropleth with col mapped to estimate

tm_shape(nyc_tracts_merge)+
  tm_fill(col = "estimate")



tm_shape(nyc_tracts_merge) +
  tm_fill(col = "estimate") +
  # Add a water layer, tm_fill() with col = "grey90"
  tm_shape(water)             +
  tm_fill(col = "grey90")              +
  # Add a neighborhood layer, tm_borders()
  tm_shape(neighborhoods)             +
  tm_borders()                         



library(tmap)

# Find unique() nyc_tracts_merge$COUNTYFP

unique(nyc_tracts_merge$COUNTYFP)
# Add logical expression to pull out New York County
manhat_hoods <- neighborhoods[neighborhoods$CountyFIPS == "061", ]

tm_shape(nyc_tracts_merge) +
  tm_fill(col = "estimate") +
  tm_shape(water) +
  tm_fill(col = "grey90") +
  # Edit to use manhat_hoods instead
  tm_shape(manhat_hoods) +
  tm_borders() +
  # Add a tm_text() layer
  tm_text(text ="NTAName")