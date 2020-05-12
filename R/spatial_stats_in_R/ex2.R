# Determine the CRS for the neighborhoods and trees vector objects
st_crs(neighborhoods)
st_crs(trees)

# Assign the CRS to trees
crs_1 <- "+proj=longlat +ellps=WGS84 +no_defs"
st_crs(trees) <- crs_1 

# Determine the CRS for the canopy and manhattan rasters
crs(canopy)
crs(manhattan)

# Assign the CRS to manhattan
crs_2 <- "+proj=utm +zone=18 +ellps=GRS80 +datum=NAD83 +units=m +no_defs"
crs(manhattan) <-crs_2

