# Load the spatstat package
library(spatstat)

# Get some summary information on the dataset
summary(preston_crime)

# Get a table of marks
table(marks(preston_crime))

# Define a function to create a map
preston_map <- function(cols = c("green","red"), cex = c(1, 1), pch = c(1, 1)) {
    plotRGB(preston_osm) # from the raster package
    plot(preston_crime, cols = cols, pch = pch, cex = cex, add = TRUE, show.window = TRUE)
}

# Draw the map with colors, sizes and plot character
preston_map(
    cols = c("black", "red"), 
    cex = c(0.5, 1), 
    pch = c(19, 19)
)


"One method of computing a smooth intensity surface from a set 
of points is to use kernel smoothing. Imagine replacing each 
point with a dot of ink on absorbent paper. Each individual 
ink drop spreads out into a patch with a dark center, and multiple 
drops add together and make the paper even darker. With the right 
amount of ink in each drop,
and with paper of the right absorbency, you can create a fair 
impression of the density of the original points. In kernel smoothing jargon, 
this means computing a bandwidth and using a particular kernel function.

To get a smooth map of violent crimes proportion, we can estimate the intensity 
surface for violent and non-violent crimes, and take the ratio. To do this with 
density() function in spatstat, we have to split the points according to the two
values of the marks and then compute the ratio of the violent crime surface to the total. 
The function has sensible defaults for the kernel function and bandwidth to guarantee something that looks at least plausible."


# preston_crime has been pre-defined
preston_crime

# Use the split function to show the two point patterns
crime_splits <- split(preston_crime)

# Plot the split crime
plot(crime_splits)

# Compute the densities of both sets of points
crime_densities <- density(crime_splits)

# Calc the violent density divided by the sum of both
frac_violent_crime_density <- crime_densities[[2]] / 
    (crime_densities[[1]] + crime_densities[[2]])

# Plot the density of the fraction of violent crime
plot(frac_violent_crime_density)


'Bandwidth selection
We can get a more principled measure of the violent crime ratio using a spatial segregation model.
The spatialkernel package implements the theory of spatial segregation.
The first step is to compute the optimal bandwidth for kernel smoothing under the segregation model. 
A small bandwidth would result in a density that is mostly zero, with spikes at the event locations. 
A large bandwidth would flatten out any structure in the events, resulting in a large "blob" across the whole window.
Somewhere between these extremes is a bandwidth that best represents an underlying density for the process.
spseg() will scan over a range of bandwidths and compute a test statistic using a cross-validation method. 
The bandwidth that maximizes this test statistic is the one to use. The returned value from spseg() in this case is a list,
with h and cv elements giving the values of the statistic over the input h values. The spatialkernel package supplies a plotcv 
function to show how the test value varies. The hcv element has the value of the best bandwidth.'


# Scan from 500m to 1000m in steps of 50m
bw_choice <- spseg(
    preston_crime, 
    h = seq(500, 1000, by = 50),
    opt = 1)

# Plot the results and highlight the best bandwidth
plotcv(bw_choice); abline(v = bw_choice$hcv, lty = 2, col = "red")

# Print the best bandwidth
print(bw_choice$hcv)


'Segregation probabilities
The second step is to compute the probabilities for violent and
non-violent crimes as a smooth surface, as well as the p-values for
a point-wise test of segregation. This is done by calling spseg() 
with opt = 3 and a fixed bandwidth parameter h.

Normally you would run this process for at least 100 simulations,
but that will take too long to run here. Instead, run for only 10 
simulations. Then you can use a pre-loaded object seg which is the
output from a 1000 simulation run that took about 20 minutes to complete.'


# Set the correct bandwidth and run for 10 simulations only
seg10 <- spseg(
    pts = preston_crime, 
    h = bw_choice$hcv,
    opt = 3,
    ntest = 10, 
    proc = FALSE)
# Plot the segregation map for violent crime
plotmc(seg10, "Violent crime")

# Plot seg, the result of running 1000 simulations
plotmc(seg, "Violent crime")


"Mapping segregation
With a base map and some image and contour functions we can display both 
the probabilities and the significance tests over the area with more control than the plotmc() function.

The seg object is a list with several components. The X and Y coordinates 
of the grid are stored in the $gridx and $gridy elements. The probabilities of
each class of data (violent or non-violent crime) are in a matrix element $p with 
a column for each class. The p-value of the significance test is in a similar matrix 
element called $stpvalue. Rearranging columns of these matrices into a grid of values
can be done with R's matrix() function. From there you can construct list objects with 
a vector $x of X-coordinates, $y of Y-coordinates, and $z as the matrix. You can then 
feed this to image() or contour() for visualization.

This process may seem complex, but remember that with R you can always write functions
to perform complex tasks and those you may repeat often. For example, to help with the 
mapping in this exercise you will create a function that builds a map from four different items.

The seg object from 1000 simulations is loaded, as well as the preston_crime points and the preston_osm map image."


"Mapping segregation
With a base map and some image and contour functions 
we can display both the probabilities and the significance 
tests over the area with more control than the plotmc() function.

The seg object is a list with several components. 
The X and Y coordinates of the grid are stored in the $gridx and $gridy elements.
The probabilities of each class of data (violent or non-violent crime) are in a matrix 
element $p with a column for each class. The p-value of the significance test is in a 
similar matrix element called $stpvalue. Rearranging columns of these matrices into a 
grid of values can be done with R's matrix() function. From there you can construct list 
objects with a vector $x of X-coordinates, $y of Y-coordinates, and $z as the matrix. 
You can then feed this to image() or contour() for visualization.

This process may seem complex, but remember that with R you can always write functions
to perform complex tasks and those you may repeat often. For example, to help with the
mapping in this exercise you will create a function that builds a map from four different items.
The seg object from 1000 simulations is loaded, as well as the preston_crime points and the preston_osm map image."

# Inspect the structure of the spatial segregation object
str(seg)

# Get the number of columns in the data so we can rearrange to a grid
ncol <- length(seg$gridx)

# Rearrange the probability column into a grid
prob_violent <- list(x = seg$gridx,
                     y = seg$gridy,
                     z = matrix(seg$p[, "Violent crime"],
                                ncol = ncol))
image(prob_violent)

# Rearrange the p-values, but choose a p-value threshold
p_value <- list(x = seg$gridx,
                y = seg$gridy,
                z = matrix(seg$stpvalue[, "Violent crime"] < 0.05,
                           ncol = ncol))
image(p_value)

# Create a mapping function
segmap <- function(prob_list, pv_list, low, high){
    
    # background map
    plotRGB(preston_osm)
    
    # p-value areas
    image(pv_list, 
          col = c("#00000000", "#FF808080"), add = TRUE) 
    
    # probability contours
    contour(prob_list,
            levels = c(low, high),
            col = c("#206020", "red"),
            labels = c("Low", "High"),
            add = TRUE)
    
    # boundary window
    plot(Window(preston_crime), add = TRUE)
}

# Map the probability and p-value
segmap(prob_violent, p_value, 0.05, .15)


'Sasquatch data
The sasquatch, or "bigfoot", is a large ape-like creature reported to live in North American forests. 
The Bigfoot Field Researchers Organization maintains a database of sightings and allows its use for
teaching and research. A cleaned subset of data in north-west USA has been created as the ppp object 
sasq and is loaded for you to explore the space-time pattern of sightings in the area.'


# Get a quick summary of the dataset
summary(sasq)

# Plot unmarked points
plot(unmark(sasq))

# Plot the points using a circle sized by date
plot(sasq, which.marks = "date")


'Temporal pattern of bigfoot sightings
Having established that there is some spatial clustering going on, 
you need to explore the temporal behavior. Are the number of sightings
increasing? Decreasing? Does the rate vary over the course of a year ("seasonality")?
Does the spatial pattern change much over the course of a year?
The base R hist() function has a method for dates that lets you specify a time unit for the breaks. 
You pass a string to the breaks argument, such as "days", "weeks", "months", "quarters" or "years".'

# Show the available marks
names(marks(sasq))

# Histogram the dates of the sightings, grouped by year
hist(marks(sasq)$date, breaks = "years", freq = TRUE)

# Plot and tabulate the calendar month of all the sightings
plot(table(marks(sasq)$month))

# Split on the month mark
sasq_by_month <- split(sasq, "month", un = TRUE)

# Plot monthly maps
plot(sasq_by_month)

# Plot smoothed versions of the above split maps
plot(density(sasq_by_month))


'Preparing data for space-time clustering
To do a space-time clustering test with stmctest() 
from the splancs package, you first need to convert parts of your ppp object.
Functions in splancs tend to use matrix data instead of data frames.

To run stmctest() you need to set up

event locations
event times
region polygon
time limits
the time and space ranges for analysis.'

'The sasq object is loaded and the spatstat and splancs packages are ready for use.

Get a matrix of event coordinates, assigning to sasq_xy.
Extract the coordinates as a data frame using coords().
Convert this to a matrix with two columns.
Check the dimensions of sasq_xy.
Get a vector of event dates, assigning to sasq_t.
Extract the marks() of the sasq object.
Get the date element from this object.
Get a matrix describing the region polygon, assigning to sasq_poly.
Extract the Window() of the sasq object.
Convert this to a data frame with as.data.frame().
Convert this to a matrix.
Calculate the limits for the time axis.
Use range() on sasq_t to get the time range.
Add c(-1, 1) to extend the range by a day at each end.
Create a vector s of distances for the spatial scales of the analysis.
The numbers passed to seq() should be in metres.
Create a vector tm of time periods for the temporal scales of the analysis.
The numbers passed to seq() should be in days.'

# Get a matrix of event coordinates
sasq_xy <- as.matrix(coords(sasq))

# Check the matrix has two columns
dim(sasq_xy)

# Get a vector of event times
sasq_t <- marks(sasq)$date

# Extract a two-column matrix from the ppp object
sasq_poly <- as.matrix(as.data.frame(Window(sasq)))
dim(sasq_poly)

# Set the time limit to 1 day before and 1 day after the range of times
tlimits <- range(sasq_t) + c(-1, 1)

# Scan over 400m intervals from 100m to 20km
s <- seq(100, 20*1000, by = 400)

# Scan over 14 day intervals from one week to 31 weeks
tm <- seq(7, 31*7, by = 14)


"Monte-carlo test of space-time clustering
Everything is now ready for you to run the space-time clustering test function.
You can then plot the results and compute a p-value for rejecting the null hypothesis of no space-time clustering.

Any space-time clustering in a data set will be removed if you randomly rearrange the dates of 
the data points. The stmctest() function computes a clustering test statistic for your data based 
on the space-time K-function - how many points are within a spatial and temporal window of a point 
of the data. It then does a number of random rearrangements of the dates among the points and computes
the clustering statistic. After doing this a large number of times, you can compare the test statistic
for your data with the values from the random data. If the test statistic for your data is sufficiently 
large or small, you can reject the null hypothesis of no space-time clustering.

The output from stmctest() is a list with a single t0 which is the test statistic for your data, and a
vector of t from the simulations. By converting to data frame you can feed this to ggplot functions.

Because the window area is a large number of square meters, and we have about 400 events, the numerical 
value of the intensity is a very small number. This makes values of the various K-functions very large numbers,
since they are proportional to the inverse of the intensity. Don't worry if you see 10^10 or higher!

The p-value of a Monte-Carlo test like this is just the proportion of test statistics that are larger than
the value from the data. You can compute this from the t and t0 elements of the output."

'All the objects from the previous exercise are loaded.

Run stmctest() for 999 simulations.
Draw a histogram of times.
The x-aesthetic is t.
Add a vertical line at the t0 value.
Sum up how many t values are larger than the t0 value, and compute as a proportion.'

# Run 999 simulations 
sasq_mc <- stmctest(sasq_xy, sasq_t, sasq_poly, tlimits, s, tm, nsim = 999, quiet = TRUE)
names(sasq_mc)

# Histogram the simulated statistics and add a line at the data value
ggplot(data.frame(sasq_mc), aes(x = t)) +
    geom_histogram(binwidth = 1e13) +
    geom_vline(aes(xintercept = t0))

# Compute the p-value as the proportion of tests greater than the data
sum(sasq_mc$t > sasq_mc$t0) / 1000



