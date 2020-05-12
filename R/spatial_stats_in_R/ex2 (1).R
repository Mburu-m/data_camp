
# Get the CRS from the canopy object
the_crs <- crs(canopy, asText = TRUE)

# Project trees to match the CRS of canopy
trees_crs <- st_transform(trees, crs = the_crs)

# Project neighborhoods to match the CRS of canopy
neighborhoods_crs <- st_transform(neighborhoods, crs = the_crs)

# Project manhattan to match the CRS of canopy
manhattan_crs <- projectRaster(manhattan, crs = the_crs, method = "ngb")

# Look at the CRS to see if they match
st_crs(trees_crs)
st_crs(neighborhoods_crs)
crs(manhattan_crs)

# Plot canopy and neighborhoods (run both lines together)
# Do you see the neighborhoods?
plot(canopy)
plot(neighborhoods, add = TRUE)

# See if canopy and neighborhoods share a CRS
st_crs(neighborhoods)
crs(canopy)

# Save the CRS of the canopy layer
the_crs <-crs(canopy, asText = T)

# Transform the neighborhoods CRS to match canopy
neighborhoods_crs <- st_transform(neighborhoods, crs = the_crs)

# Re-run plotting code (run both lines together)
# Do the neighborhoods show up now?
plot(canopy)
plot(neighborhoods_crs, add = TRUE)

# Simply run the tmap code
tm_shape(canopy) + 
    tm_raster() + 
    tm_shape(neighborhoods_crs) + 
    tm_polygons(alpha = 0.5)



# Create a data frame of counts by species
species_counts <- count(trees, species, sort = T)

# Use head to see if the geometry column is in the data frame
head(species_counts)

# Drop the geometry column
species_no_geometry <- st_set_geometry(species_counts,  NULL)

# Confirm the geometry column has been dropped
head(species_no_geometry)


# Limit to the fields boro_name, county_fip and boro_code
boro <- select(neighborhoods, boro_name, county_fip, boro_code)

# Drop the geometry column
boro_no_geometry <- st_set_geometry(boro, NULL)

# Limit to distinct records
boro_distinct <- distinct(boro_no_geometry)

# Join the county detail into the trees object
trees_with_county <-inner_join(trees, boro_distinct, by = c("boroname" = "boro_name"))

# Confirm the new fields county_fip and boro_code exist
head(trees_with_county)

# Plot the neighborhoods geometry
plot(st_geometry(neighborhoods), col = "grey")

# Measure the size of the neighborhoods object
object_size(neighborhoods)

# Compute the number of vertices in the neighborhoods object
pts_neighborhoods <- st_cast(neighborhoods$geometry, "MULTIPOINT")
cnt_neighborhoods <- sapply(pts_neighborhoods, length)
sum(cnt_neighborhoods)

# Simplify the neighborhoods object
neighborhoods_simple <-st_simplify(neighborhoods, 
                                   preserveTopology = T, 
                                   dTolerance = 100)

# Measure the size of the neighborhoods_simple object
object_size(neighborhoods_simple)

# Compute the number of vertices in the neighborhoods_simple object
pts_neighborhoods_simple <- st_cast(neighborhoods_simple$geometry, "MULTIPOINT")
cnt_neighborhoods_simple <- sapply(pts_neighborhoods_simple, length)
sum(cnt_neighborhoods_simple)

# Plot the neighborhoods_simple object geometry
plot(st_geometry(neighborhoods_simple), col = "grey")


# Read in the trees data
trees <- st_read("trees.shp")

# Convert to Spatial class
trees_sp <- as(trees, Class = "Spatial")

# Confirm conversion, should be "SpatialPointsDataFrame"
class(trees_sp)

# Convert back to sf
trees_sf <- st_as_sf(trees_sp)

# Confirm conversion
class(trees_sf)


# Read in the canopy layer
canopy <- raster("canopy.tif")

# Plot the canopy raster
plot(canopy)

# Determine the raster resolution
res(canopy)

# Determine the number of cells
ncell(canopy)

# Aggregate the raster
canopy_small <- aggregate(canopy, fact = 10)

# Plot the new canopy layer
plot(canopy_small)

# Determine the new raster resolution
res(canopy_small)

# Determine the number of cells in the new raster
ncell(canopy_small)



# Set up the matrix
vals <- cbind(100, 300, NA)

# Reclassify 
canopy_reclass <- reclassify(canopy, rcl = vals)

# Plot again and confirm that the legend stops at 100
plot(canopy_reclass)
