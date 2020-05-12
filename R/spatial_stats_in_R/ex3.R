# Review df
df

# Convert the data frame to an sf object             
df_sf <- st_as_sf(df, coords = c("longitude", "latitude"), crs = 4326)

# Transform the points to match the manhattan CRS
df_crs <- st_transform(df_sf, crs = crs(manhattan, asText = TRUE))

# Buffer the points
df_buf <- st_buffer(df_crs, dist = 1000)

# Plot the manhattan image (it is multi-band)
plotRGB(manhattan)
plot(st_geometry(df_buf), col = "firebrick", add = TRUE)
plot(st_geometry(df_crs), pch = 16, add = TRUE)

# Read in the neighborhods shapefile
neighborhoods <- st_read("neighborhoods.shp")

# Project neighborhoods to match manhattan
neighborhoods_tf <- st_transform(neighborhoods, crs = 32618)

# Compute the neighborhood centroids
centroids <- st_centroid(neighborhoods_tf)

# Plot the neighborhood geometry
plot(st_geometry(neighborhoods_tf), col = "grey", border = "white")
plot(centroids, pch = 16, col = "firebrick", add = T)


"Create a bounding box around vector data
You can compute bounding boxes around vector data using sf. These can help you, for example, create polygons to clip layers to a common area for an analysis or identify regions of influence.

In the sf package, there is a function for extracting the bounding box coordinates, if that's all you need, this is st_bbox(). More likely you'll want to create a new sf object (a polygon) from those coordinates and to do this sf provides the st_make_grid() function.

st_make_grid() can be used to make a multi-row and multi-column grid covering your input data but it can also be used to make a grid of just one cell (a bounding box). To do this, you need to specify the number of grid cells as n = 1."


"Plot the beech trees object on top of the neighborhoods object -- wrap neighborhoods in st_geometry() so you're not plotting any attributes. Both have been preloaded. This requires two calls to plot() and one will need add = TRUE.
Compute the bounding box coordinates with st_bbox().
Create a single polygon bounding box around the beech trees with st_make_grid() with an argument of n = 1.
Create a plot of the neighborhoods (just the geometry), the beech trees and the new box around the beech trees."



# Plot the neighborhoods and beech trees
plot(st_geometry(neighborhoods), col = "grey", border = "white")
plot(beech, add = T, pch = 16, col = "forestgreen")

# Compute the coordinates of the bounding box
st_bbox(beech)

# Create a bounding box polygon
beech_box <- st_make_grid(beech, n = 1)

# Plot the neighborhoods, add the beech trees and add the new box
plot(st_geometry(neighborhoods), col = "grey", border = "white")
plot(beech, add = T, pch = 16, col = "forestgreen")
plot(beech_box, add = T)



"Dissolve multiple features into one
In order to compute a tighter bounding box, a convex hull, around a set of 
points like the beech trees from the previous exercise you'll need to learn one more function first.

For points you don't want a convex hull around each point! This doesn't even make sense. 
More likely you want to compute a convex hull around all your points.
If you have a set of points and you want to draw a convex hull around 
them you first need to bundle the points into a single MULTIPOINT feature
and in order to do this you will use the dissolve function in sf called st_union().

With polygons, st_union() will dissolve all the polygons into a single
polygon representing the area where all the polygons overlap. Your set of
individual points will be dissolved/unioned into a single, 
MULTIPOINT feature that you can use for tasks like computing the convex hull."


'Buffer the beech object by 3000 with st_buffer() -- sf will automatically use meters, the units of the CRS.
Create a new object called beech_buffers which is just the geometry of the buffered beech trees with st_geometry().
Compute the number of features in the beech_buffers object with length() and plot() to see what they look like.
Dissolve the buffers in beech_buffers, call this beech_buf_union.
Compute the number of features in the beech_buf_union object with length() and plot() to see what the dissolved object looks like.'



# Buffer the beech trees by 3000
beech_buffer <- st_buffer(beech, 3000)

# Limit the object to just geometry
beech_buffers <- st_geometry(beech_buffer)

# Compute the number of features in beech_buffer
length(beech_buffers)

# Plot the tree buffers
plot(beech_buffers)

# Dissolve the buffers
beech_buf_union <- st_union(beech_buffers)

# Compute the number of features in beech_buf_union
length(beech_buf_union)

# Plot the dissolved buffers
plot(beech_buf_union)

"Compute a convex hull around vectors
A more precise bounding polygon is sometimes needed, 
one that fits your data more neatly. For this, 
you can use the st_convex_hull() function. 
Note that st_convex_hull() will compute a
tight box around each one of your features 
individually so if you want to create a convex hull around a group of
features you'll need to use st_union()
to combine individual features into a single multi-feature."


"Use head() on beech to look at the data frame and see the type of geometry.
Use st_union() to combine the individual points in the beech object into a single MULTIPOINT geometry and call this beech1.
Use head() on beech1 to see the type of geometry of the dissolved object.
Use the length() function from base R on beech and beech1 to confirm that the number of features went from 17 to 1.
Use the st_convex_hull() function on beech1 to compute the tight bounding box around the beech trees and call this beech_hull.
Plot beech_hull and then plot the points on top. Use plot() twice and run the lines together."


# Look at the data frame to see the type of geometry
head(beech)

# Convert the points to a single multi-point
beech1 <- st_union(beech)

# Look at the data frame to see the type of geometry
head(beech1)

# Confirm that we went from 17 features to 1 feature
length(beech)
length(beech1)

# Compute the tight bounding box
beech_hull <- st_convex_hull(beech1)

# Plot the points together with the hull
plot(beech_hull, col = "red")
plot(beech1, add = T)


"Spatial joins
For many analysis types you need to link geographies spatially.
For example, you want to know how many trees are in each neighborhood 
but you don't have a neighborhood attribute in the tree data.
The best way to do this is with a spatial join using st_join().

Importantly, the st_join() function requires sf data frames as 
input and will not accept an object that is just sf geometry.
You can use the st_sf() function to convert sf geometry objects to an sf data frame (st_sf() 
is essentially the opposite of st_geometry())."

"Plot the beech trees (beech) on top of the neighborhoods (neighborhoods).
You will want to plot only the geometry of the neighborhoods.
Use class() to see if the beech object has class data.frame or if it's just geometry.
Convert the sf geometry object beech to an sf data frame with st_sf().
Use class() to confirm that beech now has a class of data.frame (as well as sf).
Use st_join() to conduct a spatial join in order to add neighborhood information to the beech object.
Use head() to confirm that the new object has neighborhood information -- for example, 
it should now have neighborhood name (ntaname"


# Plot the beech on top of the neighborhoods
plot(st_geometry(neighborhoods))
plot(beech, add = T, pch = 16, col = "red")

# Determine whether beech has class data.frame
class(beech)

# Convert the beech geometry to a sf data frame
beech_df <- st_sf(beech)

# Confirm that beech now has the data.frame class
class(beech_df)

# Join the beech trees with the neighborhoods
beech_neigh <- st_join(beech_df, neighborhoods)

# Confirm that beech_neigh has the neighborhood information
head(beech_neigh)


"Spatial relationships
In this exercise you will determine which neighborhoods are at least partly 
within 2000 meters of the Empire State Building with st_intersects() 
and those that are completely within 2000 meters of the Empire State 
Building using st_contains(). You will then use the st_intersection()
function (notice the slight difference in function name!) to clip the neighborhoods to the buffer.

A note about the output of functions that test relationships between two sets of features.
The output of these and related functions is a special kind of list (with the class sgbp). 
For example, when using st_intersects(), the first element in the output can be accessed using [[1]], 
which shows polygons from the second polygon that intersect with the first polygon. Likewise, [[2]] 
would show the polygons from from the first polygon that intersect with the second polygon."

"Use st_intersects() to identify neighborhoods that intersect with the buffer object (buf) and call the result neighborhoods_int.
Use st_contains() to identify neighborhoods that are completely within the buffer object (buf) and call the result neighborhoods_cont.
Extract neighborhoods that are contained by and intersect with buf and save as int and cont.
Use the int object you just created to identify the names of the neighborhoods that intersect with buffer (the first will be Clinton).
Use st_intersection() to 'clip' the neighborhoods by buf and call this neighborhoods_clip

"



# Identify neighborhoods that intersect with the buffer
neighborhoods_int <- st_intersects(buf, neighborhoods)

# Identify neighborhoods contained by the buffer
neighborhoods_cont <- st_contains(buf, neighborhoods)

# Get the indexes of which neighborhoods intersect
# and are contained by the buffer
int <- neighborhoods_int[[1]]
cont <- neighborhoods_cont[[1]]
``
# Get the names of the names of neighborhoods in buffer
neighborhoods$ntaname[int]

# Clip the neighborhood layer by the buffer (ignore the warning)
neighborhoods_clip <- st_intersection(buf, neighborhoods)

# Plot the geometry of the clipped neighborhoods
plot(st_geometry(neighborhoods_clip), col = "red")
plot(neighborhoods[cont,], add = TRUE, col = "yellow")






"Measuring distance between features
Of course, measuring distance between feature sets is a
component of spatial analysis 101 -- a core skill for any analyst. 
There are several functions in base R as well as in the packages 
rgeos and geosphere to compute distances, but the st_distance() 
function from sf provides a useful feature-to-feature distance 
matrix as output and can be used for most distance calculation needs.
In this exercise you'll measure the distance from the Empire 
State Building to all the parks and identify the closest one"



"Read in the parks shapefile (`parks.shp``).
Test whether the CRS of parks matches the CRS of the preloaded object empire_state with st_crs().
Project/transform the parks object to match the empire_state object. You'll need st_transform() and st_crs().
Use st_distance() to compute the distance between the Empire State Building (empire_state) and the parks.
Use head() to take a quick look at the result.
Identify the index of the smallest distance using which.min() and assign it to nearest.
Use nearest to pull out the row from parks of the nearest park (see the signname variable, it should be Greeley Square Park)."




# Read in the parks object
parks <- st_read("parks.shp")

# Test whether the CRS match
st_crs(empire_state) == st_crs(parks)

# Project parks to match empire state
parks_es <- st_transform(parks, crs = st_crs(empire_state))

# Compute the distance between empire_state and parks_es
d <- st_distance(empire_state, parks_es)

# Take a quick look at the result
head(d)

# Find the index of the nearest park
nearest <- which.min(d)

# Identify the park that is nearest
parks_es[nearest, ]


"Limit rasters to focus areas
Mask and crop are similar operations that allow you to limit your 
raster to a specific area of interest. With mask() you essentially 
place your area of interest on top of the raster and any raster cells
outside of the boundary are assigned NA values. A reminder that currently
the raster package does not support sf objects so they will need to be converted
to Spatial objects with, for example, as(input, 'Spatial')."


'Project the preloaded parks object to match the canopy raster with st_transform() and crs(). Assign this to parks_cp.
Compute the area of the parks with st_area() and save this object as areas.
Filter the parks to only those above 30000 square meters with the filter() function. You will need to wrap areas in unclass(). Save as parks_big.
Review the plot of canopy raster.
Plot the geometry of the parks_big.
Convert the parks_big object to the Spatial class (the class from the package sp) with as(input, "Spatial") and save this as parks_sp.
Mask the canopy layer with parks_sp and save as canopy_mask. This may take a couple of seconds.
Review the plot of canopy_mask.'


# Project parks to match canopy
parks_cp <- st_transform(parks, crs = crs(canopy, asText = TRUE))

# Compute the area of the parks
areas <- st_area(parks_cp)

# Filter to parks with areas > 30000
parks_big <- filter(parks_cp, unclass(areas) > 30000)

# Plot the canopy raster
plot(canopy)

# Plot the geometry of parks_big
plot(st_geometry(parks_big))

# Convert parks to a Spatial object
parks_sp <- as(parks_big, "Spatial")

# Mask the canopy layer with parks_sp and save as canopy_mask
canopy_mask <- mask(canopy, mask = parks_sp)

# Plot canopy_mask -- this is a raster!
plot(canopy_mask)





"Crop a raster based on another spatial object
As you saw in the previous exercise with mask(), the raster extent is not changed. 
If the extents of the input raster and the mask 
itself are different then they will still be different 
after running mask(). In many cases, however, you will 
want your raster to share an extent with another layer
and this is where crop() comes in handy. With crop() you
are cropping the raster so that the extent (the bounding box) 
of the raster matches the extent of the input crop layer. 
But within the bounding box no masking is done (no raster cells are set to NA).

In this exercise you will both mask and crop the NYC canopy
layer based on the large parks and you'll compare. You should 
notice that the masked raster includes a lot of NA values (there are the whitespace) 
and that the extent is the same as the original canopy layer. With the cropped layer 
you should notice that the extent of the cropped canopy layer matches the extent of the large parks (essentially it's zoomed in)."


# Convert the parks_big to a Spatial object
parks_sp <- as(parks_big, "Spatial")

# Mask the canopy with the large parks 
canopy_mask <- mask(canopy, mask = parks_sp)

# Plot the mask
plot(canopy_mask)

# Crop canopy with parks_sp
canopy_crop <- crop(canopy, parks_sp)

# Plot the cropped version and compare
plot(canopy_crop)


"Extract raster values by location
Beyond simply masking and cropping you may want to
know the actual cell values at locations of interest.
You might, for example, want to know the percentage canopy
at your landmarks or within the large parks. This is where the extract() 
function comes in handy.

Usefully, and you'll see this in a later analysis, you can feed extract() 
a function that will get applied to extracted cells. For example, you can use extract()
to extract raster values by neighborhood and with the fun = mean argument it will return an average cell value by neighborhood.

Similar to other raster functions, it is not yet set up to accept sf objects so you'll need to convert to a Spatial object."



# Project the landmarks to match canopy
landmarks_cp <- st_transform(landmarks, crs = crs(canopy, asText=FALSE))

# Convert the landmarks to a Spatial object
landmarks_sp <- as(landmarks_cp, "Spatial")

# Extract the canopy values at the landmarks
landmarks_ex <- extract(canopy, landmarks_sp)

# Look at the landmarks and extraction results
landmarks_cp
landmarks_ex


"Raster math with overlay
You will now use the canopy layer and an 'imperviousness'
layer from the same source, the United States Geological Survey.
Imperviousness measures whether water can pass through a surface. 
So a high percentage impervious surface might be a road that does 
not let water pass through while a low percentage impervious might be something like a lawn.

What you will do in this exercise is essentially identify the most urban locations by finding areas
that have both a low percentage of tree canopy ([removed] 80%). To do this, we defined the function f to do the raster math for you."


# Read in the canopy and impervious layer
canopy <- raster("canopy.tif")
impervious <- raster("impervious.tif")

# Function f with 2 arguments and the raster math code
f <- function(rast1, rast2) {
    rast1 < 20 & rast2 > 80
}

# Do the overlay using f as fun
canopy_imperv_overlay <- overlay(canopy, impervious, fun = f)

# Plot the result (low tree canopy and high impervious areas)
plot(canopy_imperv_overlay)


# Compute the counts of all trees by hood
tree_counts <- count(trees, hood)

# Take a quick look
head(tree_counts)

# Remove the geometry
tree_counts_no_geom <-  st_set_geometry(tree_counts, NULL)

# Rename the n variable to tree_cnt
tree_counts_renamed <- rename(tree_counts_no_geom, tree_cnt = "n")

# Create histograms of the total counts
hist(tree_counts_renamed$tree_cnt)


# Compute areas and unclass
areas <- unclass(st_area(neighborhoods))

# Add the areas to the neighborhoods object
neighborhoods_area <- mutate(neighborhoods, area = areas)

# Join neighborhoods and counts
neighborhoods_counts <- left_join(neighborhoods_area, 
                                  tree_counts_renamed, by = "hood")

# Replace NA values with 0
neighborhoods_counts <- mutate(neighborhoods_counts, 
                               tree_cnt = ifelse(is.na(tree_cnt), 
                                                 0, tree_cnt))

# Compute the density
neighborhoods_counts <- mutate(neighborhoods_counts, 
                               tree_density = tree_cnt/area)



# Confirm that you have the neighborhood density results
head(neighborhoods)

# Transform the neighborhoods CRS to match the canopy layer
neighborhoods_crs <- st_transform(neighborhoods, crs = crs(canopy, asText=TRUE))

# Convert neighborhoods object to a Spatial object
neighborhoods_sp <- as(neighborhoods_crs, "Spatial")

# Compute the mean of canopy values by neighborhood
canopy_neighborhoods <- extract(canopy, neighborhoods_sp, fun = mean)

# Add the mean canopy values to neighborhoods
neighborhoods_avg_canopy <- mutate(neighborhoods, avg_canopy = canopy_neighborhoods)


# Load the ggplot2 package
library(ggplot2)

# Create a histogram of tree density (tree_density)
ggplot(neighborhoods, aes(x = tree_density)) + 
    geom_histogram(color = "white")

# Create a histogram of average canopy (avg_canopy)
ggplot(neighborhoods, aes(x = avg_canopy)) + 
    geom_histogram(color = "white")

# Create a scatter plot of tree_density vs avg_canopy
ggplot(neighborhoods, aes(x = tree_density, y = avg_canopy)) + 
    geom_point() + 
    stat_smooth()

# Compute the correlation between density and canopy
cor(neighborhoods$tree_density, neighborhoods$avg_canopy)


# Plot the tree density with default colors
ggplot(neighborhoods) + 
    geom_sf(aes(fill = tree_density))

# Plot the tree canopy with default colors
ggplot(neighborhoods) + 
    geom_sf(aes(fill = avg_canopy))

# Plot the tree density using scale_fill_gradient()
ggplot(neighborhoods) + 
    geom_sf(aes(fill = tree_density)) + 
    scale_fill_gradient(low = "#edf8e9", high = "#005a32")

# Plot the tree canopy using the scale_fill_gradient()
ggplot(neighborhoods) + 
    geom_sf(aes(fill = avg_canopy)) +
    scale_fill_gradient(low = "#edf8e9", high = "#005a32")


# Create a simple map of neighborhoods
tm_shape(neighborhoods) + 
    tm_polygons()

# Create a color-coded map of neighborhood tree density
tm_shape(neighborhoods) + 
    tm_polygons(col = "tree_density")

# Style the tree density map
tm_shape(neighborhoods) + 
    tm_polygons("tree_density", palette = "Greens", 
                style = "quantile", n = 7, 
                title = "Trees per sq. KM")

# Create a similar map of average tree canopy
tm_shape(neighborhoods) + 
    tm_polygons("avg_canopy", palette = "Greens", 
                style = "quantile", n = 7, 
                title = "Average tree canopy (%)")


# Combine the aerial photo and neighborhoods into one map
map1 <- tm_shape(manhattan) + 
    tm_raster() + 
    tm_shape(neighborhoods) + 
    tm_borders(col = "black", lwd = 0.5, alpha = 0.5)

# Create the second map of tree measures
map2 <- tm_shape(neighborhoods, bbox = bbox(manhattan)) +
    tm_polygons(
        c("tree_density", "avg_canopy"), 
        style = "quantile",
        palette = "Greens",
        title = c("Tree Density", "Average Tree Canopy"))


# Combine the aerial photo and neighborhoods into one map
map1 <- tm_shape(manhattan) + 
    tm_raster() + 
    tm_shape(neighborhoods) + 
    tm_borders(col = "black", lwd = 0.5, alpha = 0.5)

# Create the second map of tree measures
map2 <- tm_shape(neighborhoods, bbox = bbox(manhattan)) +
    tm_polygons(c("tree_density", "avg_canopy"), 
                style = "quantile",
                palette = "Greens",
                title = c("Tree Density", "Average Tree Canopy")) 

# Combine the two maps into one
tmap_arrange(map1, map2, asp = NA)