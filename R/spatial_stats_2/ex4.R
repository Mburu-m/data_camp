"Canadian geochemical survey data
Your job is to study the acidity (pH) of some Canadian survey data. 
The survey measurements are loaded into a spatial data object called ca_geo"

"The acidity survey data, ca_geo has been pre-defined.

Look at the names of columns in the data and get a summary of 
the numerical pH values. You should notice there are some missing values (NA's).
Make a histogram of the acidity.
Construct a vector that is TRUE for the rows with missing pH values. You should have 33.
Plot a map of the survey data.
You need to subset the data to remove the missing values.
The spplot() function needs a column name in quotes to map that data."
# ca_geo has been pre-defined
str(ca_geo, 1)

# See what measurements are at each location
names(ca_geo)

# Get a summary of the acidity (pH) values
summary(ca_geo$pH)

# Look at the distribution
hist(ca_geo$pH)

# Make a vector that is TRUE for the missing data
miss <- is.na(ca_geo$pH)
table(miss)

# Plot a map of acidity
spplot(ca_geo[!miss, ], "pH")


"Fitting a trend surface
The acidity data shows pH broadly increasing from north-east to 
south-west. Fitting a linear model with the coordinates as covariates will interpolate a flat plane through the values."


"The acidity survey data, ca_geo has been pre-defined.

The response, on the left of the ~ sign, is the name of the column we are modeling.
The explanatory variables are on the right of the ~ sign, separated by a + sign, and are 
the names of the coordinate columns obtained by coordnames().
Fit the model and see if the model parameters are significant by seeing stars in the coefficients table."


# ca_geo has been pre-defined
str(ca_geo, 1)

# Are they called lat-long, up-down, or what?
coordnames(ca_geo)

# Complete the formula
m_trend <- lm(pH ~ x + y, as.data.frame(ca_geo))

# Check the coefficients
summary(m_trend)


"Predicting from a trend surface
Your next task is to compute the pH at the locations
that have missing data in the source. You can use the predict()
function on the fitted model from the previous exercise for this."


"The acidity survey data, ca_geo, and the linear model, m_trend have been pre-defined.

Construct a vector that is TRUE for the rows with missing pH values.
Take a subset of the data wherever the pH is missing, assigning the result to ca_geo_miss.
By default predict() will return predictions at all the original locations.
Pass the model as the first argument, as usual.
Pass ca_geo_miss to the newdata argument to predict missing values.
Assign the result to predictions.
Alkaline soils are those with a pH over 7. Our linear model gives us
estimates and standard deviation based on a normal (Gaussian) assumption. 
Compute the probability of the soil being over 7 using pnorm() with the mean and standard deviation values from the prediction data."

# ca_geo, miss, m_trend have been pre-defined
ls.str()

# Make a vector that is TRUE for the missing data
miss <- is.na(ca_geo$pH)

# Create a data frame of missing data
ca_geo_miss <- as.data.frame(ca_geo)[miss, ]

# Predict pH for the missing data
predictions <- predict(m_trend, newdata = ca_geo_miss, se.fit = TRUE)

# Compute the exceedence probability
pAlkaline <- 1 - pnorm(7, mean = predictions$fit, sd = predictions$se.fit)


"Variogram estimation
You can use the gstat package to plot variogram clouds and the variograms from data. Recall:

The variogram cloud shows the differences of the measurements against distance for all pairs of data points.
The binned variogram divides the cloud into distance bins and computes the average difference within each bin.
The y-range of the binned variogram is always much smaller than the variogram cloud because the cloud includes
the full range of values that go into computing the mean for the binned variogram."


"The acidity survey data, ca_geo and the missing value index, miss have been pre-defined.

The gstat variogram() function uses the cloud argument to plot a variogram cloud.
Use the miss vector from the previous exercise to select non-missing data.
The data is in meters, so use a 10km cutoff to prevent the cloud being too dense.
Plot a binned variogram of the non-missing data - the default cloud parameter is FALSE."


# ca_geo, miss have been pre-defined
ls.str()

# Make a cloud from the non-missing data up to 10km
plot(variogram(pH ~ 1, ca_geo[!miss, ], cloud = TRUE, cutoff = 10*1000))

# Make a variogram of the non-missing data
plot(variogram(pH ~ 1, ca_geo[!miss, ]))


"Variogram with spatial trend
You might imagine that if soil at a particular point is alkaline,
then soil one metre away is likely to be alkaline too. But can you say the 
same thing about soil one kilometre away, or ten kilometres, or one hundred kilometres?

The shape of the previous variogram tells you there is a large-scale trend in the data.
You can fit a variogram considering this trend with gstat. This variogram should flatten out,
indicating there is no more spatial correlation after a certain distance with the trend taken into account."

"The acidity survey data, ca_geo and the missing value index, miss have been pre-defined.

Set the formula for the variogram so that the pH value depends on the coordinates.
"

# ca_geo, miss have been pre-defined
ls.str()

# See what coordinates are called
coordnames(ca_geo)

# The pH depends on the coordinates
ph_vgm <- variogram(pH ~ x + y, ca_geo[!miss, ])
plot(ph_vgm)


"Variogram model fitting
Next you'll fit a model to your variogram.
The gstat function fit.variogram() does this. 
You need to give it some initial values as a starting point for the optimization algorithm to fit a better model.
The sill is the the upper limit of the model. That is, the long-range largest value, ignoring any outliers."


"A variogram has been plotted for you, and ph_vgm has been pre-defined.

Estimate some parameters by eyeballing the plot.
The nugget is the value of the semivariance at zero distance.
The partial sill, psill is the difference between the sill and the nugget.
Set the range to the distance where the model first begins to flattens out.
Fit a variogram model by calling fit.variogram().
The second argument should take the parameters you estimated, wrapped in a call to vgm().
Plot the binned variogram."


# ca_geo, miss, ph_vgm have been pre-defined
ls.str()

# Eyeball the variogram and estimate the initial parameters
nugget <- .16
psill <- .14
range <- 15000

# Fit the variogram
v_model <- fit.variogram(
    ph_vgm, 
    model = vgm(
        model = "Ste",
        nugget = nugget,
        psill = psill,
        range = range,
        kappa = 0.5
    )
)

# Show the fitted variogram on top of the binned variogram
plot(ph_vgm, model = v_model)
print(v_model)



"Filling in the gaps
The final part of geostatical estimation is kriging itself. 
This is the application of the variogram along with the sample data points
to produce estimates and uncertainties at new locations.

The computation of estimates and uncertainties, together with the assumption of a 
normal (Gaussian) response means you can compute any function of the estimates - 
for example the probability of a new location having alkaline soil."


"The acidity survey data, ca_geo, the missing value index, miss, and the variogram model,
v_model, have been pre-defined.

Complete the formula to indicate kriging with a spatial trend surface.
Select the missing values from the data as our newdata locations.
Plot the predicted acidity from the returned object."


# ca_geo, miss, v_model have been pre-defined
ls.str()

# Set the trend formula and the new data
km <- krige(pH ~ x + y, ca_geo[!miss, ], newdata = ca_geo[miss, ], model = v_model)
names(km)

# Plot the predicted values
spplot(km, "var1.pred")

# Compute the probability of alkaline samples, and map
km$pAlkaline <- 1 - pnorm(7, mean = km$var1.pred, sd = sqrt(km$var1.var))
spplot(km, "pAlkaline")

"Making a prediction grid
You have been asked to produce an alkaline probability map over the study area. 
To do this, you are going to do some kriging via the krige() function. 
This requires a SpatialPixels object which will take a bit of data manipulation to create. 
start by defining a grid, creating points on that grid, cropping to the study region, and then
finally converting to SpatialPixels. On the way, you'll meet some new functions.

GridTopology() defines a rectangular grid. It takes three vectors of length two as inputs. 
The first specifies the position of the bottom left corner of the grid. The second specifies
the width and height of each rectangle in the grid, and the third specifies the number of rectangles in each direction.

To ensure that the grid and the study area have the same coordinates, some housekeeping is involved.
SpatialPoints() converts the points to a coordinate reference system (CRS), or projection
(different packages use different terminology for the same concept). The CRS is created by wrapping 
the study area in projection(), then in CRS(). For the purpose of this exercise, you don't need to worry 
about exactly what these functions do, only that this data manipulation is necessary to align the grid and the study area.

Now that you have that alignment, crop(), as the name suggests, crops the grid to the study area.

Finally, SpatialPixels() converts the raster cropped gridpoints to the equivalent sp object."


# ca_geo, geo_bounds have been pre-defined
ls.str()

# Plot the polygon and points
plot(geo_bounds); points(ca_geo)

# Find the corners of the boundary
bbox(geo_bounds)

# Define a 2.5km square grid over the polygon extent. The first parameter is
# the bottom left corner.
grid <- GridTopology(c(537853, 5536290), c(2500, 2500), c(72, 48))

# Create points with the same coordinate system as the boundary
gridpoints <- SpatialPoints(grid, proj4string = CRS(projection(geo_bounds)))
plot(gridpoints)

# Crop out the points outside the boundary
cropped_gridpoints <- crop(gridpoints, geo_bounds)
plot(cropped_gridpoints)

# Convert to SpatialPixels
spgrid <- SpatialPixels(cropped_gridpoints)
coordnames(spgrid) <- c("x", "y")
plot(spgrid)



"Gridded predictions
Constructing the grid is the hard part done. You can now 
compute kriged estimates over the grid using the variogram model from
before (v_model) and the grid of SpatialPixels."


"The spatial pixel grid of the region, spgrid, and the variogram model of pH, v_model have been pre-defined.

Use kriging to predict pH in each grid rectangle throughout the study area.
Call krige().
The formula and input data are already specified.
Pass spgrid as the new data to predict.
Pass the variogram model to the model argument.
Calculate the probability of alkaline samples in each grid rectangle.
The mean of the predictions is the var1.pred element of ph_grid.
The variance of the predictions is the var1.var element of ph_grid. Take the square root to get the standard deviation.
Plot the alkalinity in each grid rectangle.
Call spplot().
Pass the alkalinity column to the zcol argument as a string."


# spgrid, v_model have been pre-defined
ls.str()

# Do kriging predictions over the grid
ph_grid <- krige(pH ~ x + y, ca_geo[!miss, ], newdata = spgrid, model = v_model)

# Calc the probability of pH exceeding 7
ph_grid$pAlkaline <- 1 - pnorm(7, mean = ph_grid$var1.pred, sd = sqrt(ph_grid$var1.var))

# Map the probability of alkaline samples
spplot(ph_grid, zcol = "pAlkaline")


"Auto-kriging at point locations
The autoKrige() function in the automap package computes binned variograms, fits models, does model selection, and
performs kriging by making multiple calls to the gstat functions you used previously.
It can be a great time-saver but you should always check the results carefully.

In this example you will get predictions at the missing data locations.

autoKrige() can try several variogram model types. In the example, you'll use a Matern
variogram model, which is commonly used in soil and forestry analyses. You can see a complete
list of available models by calling vgm() with no arguments."


"The acidity survey data, ca_geo, and the missing value index, miss, have been pre-defined.

Call autoKrige() to automatically run a kriging model.
Set the formula for modeling acidity versus the position, as before.
The input_data is the non-missing data from the survey.
The new_data is the missing data from the survey.
Set the model to 'Mat' (Note the capital M.)
Assign the result to ph_auto.
Call plot() on ph_auto to see the results."



# ca_geo, miss are pre-defined
ls.str()

# Kriging with linear trend, predicting over the missing points
ph_auto <- autoKrige(
    pH ~ x + y, 
    input_data = ca_geo[!miss, ], 
    new_data = ca_geo[miss, ], 
    model = "Mat"
)

# Plot the variogram, predictions, and standard error
plot(ph_auto)


"Auto-kriging over a grid
You can also use autoKrige() over the spgrid grid 
from the earlier exercise. This brings together all the concepts 
that you've learned in the chapter. That is, kriging is great for 
predicting missing data, plotting things on a grid is much clearer than plotting
individual points, and automatic kriging is less hassle than manual kriging."


"The acidity survey data, ca_geo, the missing value index, 
miss, the spatial pixel grid of the region, spgrid, the manual 
kriging grid model, ph_grid, and the variogram model of pH, v_model have been pre-defined.

Automatically fit a kriging model.
Call autoKrige().
The first argument is the same formula you've used throughout the chapter.
The input_data argument contains the non-missing points from the survey data.
The new_data argument is the grid of prediction locations.
Assign the result to ph_auto_grid.
To remind yourself of the manual kriging predictions, plot ph_grid.
Plot ph_auto_grid. Do the predictions look similar or different?
To compare the manual and automated variogram models, print v_model the var_model element of ph_auto_grid."



# ca_geo, miss, spgrid, ph_grid, v_model are pre-defined
ls.str()

# Auto-run the kriging
ph_auto_grid <- autoKrige(pH ~ x + y, input_data = ca_geo[!miss,], new_data = spgrid)

# Remember predictions from manual kriging
plot(ph_grid)

# Plot predictions and variogram fit
plot(ph_auto_grid)

# Compare the variogram model to the earlier one
v_model
ph_auto_grid$var_model
