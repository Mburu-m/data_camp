
"Simple spatial principles
For these first few exercises you'll mostly use standard R functions to generate some point patterns.
Firstly, you'll generate 200 points uniformly in a rectangle. 
The rectangle will have its bottom left corner at coordinate (0, 0) and its top right corner 
at (1, 2), so it is taller than it is wide.
runif(n, a, b) will generate n random numbers anywhere between a and b."


"Set the minimum and maximum values of the rectangle in X and Y coordinates.
Complete the call to runif() to create the X coordinates, 
and write the similar line for the Y coordinates.
Note that n is already defined for you."


# The number of points to create
n <- 200

# Set the range
xmin <- 0
xmax <- 1
ymin <- 0
ymax <- 2

# Sample from a Uniform distribution
x <- runif(n, xmin,xmax)
y <- runif(n, ymin,ymax)



"Plotting areas
At school we were taught to make the most of a piece of 
graph paper by scaling our data to fit the page. 
R will usually follow this advice by making a plot fill the graphics window.

With spatial data, this can cause misleading distortion
that changes the distance and direction between pairs of points. 
The data in the previous exercise was created in a tall, skinny rectangle, 
and it should always be shown as a tall, skinny rectangle. If R stretches 
this to fill a wide graphics window then it is misrepresenting the relationship
between events in the up-down and left-right directions.

So spatial plots should have scales so that one unit in the X axis is the same 
size as one unit on the Y axis. Circles will appear as circles and not ellipses,
and squares will appear square.

The ratio of the Y axis scale to the X axis scale is called the aspect ratio of
the plot. Spatial data should always be presented with an aspect ratio of 1:1."


"The boundaries of the rectangle have been 
pre-defined as xmin, xmax, ymin, and ymax.
The x and y coordinates of the points have 
been pre-defined as x and y, respectively.

Edit the body of the mapxy() function to plot 
the points using the x and y vectors.
Call mapxy() with the correct aspect ratio a 
to get the map looking right. You should get points in a rectangle twice as high as it is wide.
"



# See pre-defined variables
ls.str()

# Plot points and a rectangle

mapxy <- function(a = NA){
    plot(x, y, asp = a)
    rect(xmin, ymin, xmax, ymax)
}

mapxy(a = 1)


"Uniform in a circle
How do we create a uniform density point pattern in a circle?
We might first try selecting radius and angle uniformly. But that produces a `cluster`
at small distances. Instead we sample the radius from a non-uniform distribution that 
scales linearly with distance, so we have fewer points at small radii and more at large radii.
This exercise uses spatstat's disc() function, that creates a circular window."

"The number of points to generate and the circle's radius are
shown in the script as n_points and radius respectively.
Call library() to load the spatstat package.
Create n_points random numbers uniformly from zero to the radius-squared. Assign the result to r_squared.
Calculate the x and y coordinates.
x-values are the square root of r_squared times the cosine of angle.
y-values are the square root of r_squared times the sine of angle.
Plot a disc of radius radius, then add the points to the plot."

# Load the spatstat package
library(spatstat)
# Create this many points, in a circle of this radius
n_points <- 300
radius <- 10

# Generate uniform random numbers up to radius-squared
r_squared <- runif(n_points, 0, 10^2)
angle <- runif(n_points, 0, 2*pi)

# Take the square root of the values to get a uniform spatial distribution
x <- sqrt(r_squared) * cos(angle)
y <- sqrt(r_squared) * sin(angle)

plot(disc(radius)); points(x, y)


"Quadrat count test for uniformity
Humans tend to see patterns in random arrangements, so we need statistical tests. 
The quadrat count test was one of the earliest developed
spatial statistics methods. It can be used to check if points are 
completely spatially random; that is, they are uniformly random throughout
the area of interest. By running a quadrat count test on the points generated 
in the previous exercise, you can confirm they were generated uniformly on the circle.
Quadrat count tests are implemented using quadrat.test(),
which takes a planar point pattern, ppp() object. `Planar point pattern' is jargon for a set of points in a region of a 2D plane"


# Some variables have been pre-defined
ls.str()

# Set coordinates and window
ppxy <- ppp(x = x, y = y, window = disc(radius))

# Test the point pattern
qt <- quadrat.test(ppxy)

# Inspect the results
plot(qt)
print(qt)


"Creating a uniform point pattern with spatstat
A Poisson point process creates events according to a Poisson 
distribution with an intensity parameter specifying the expected 
events per unit area. The total number of events generated is a 
single number from a Poisson distribution, so multiple realisations 
of the same process can easily have different numbers of events.

In the previous exercise you used a set of 300 events scattered 
uniformly within a circle. If you repeated the generation of the 
events again you will still have 300 of them, but in different locations. 
The dataset of exactly 300 points is from a Poisson point process conditioned 
on the total being 300.

The spatstat package can generate Poisson spatial processes with the rpoispp() 
function given an intensity and a window, that are not conditioned on the total.

Just as the random number generator functions in R start with an r, 
most of the random point-pattern functions in spatstat start with an 'r'.

The area() function of spatstat will compute the area of a window such as a disc."

"Create a disc of radius 10, assigning the result to disc10.
To generate approximately 500 points in a disc of radius 10, 
set lambda to 500 divided by the area() of the disc. Assign the result to lambda.
Generate a random Poisson point pattern with intensity lambda and window disc10, 
assigning the result to ppois. Do you get about 500 points?
Plot the Poisson point pattern by calling plot() on ppois."

# Create a disc of radius 10
disc10 <- disc(10)

# Compute the rate as count divided by area
lambda <- 500 / area(disc10)

# Create a point pattern object
ppois <- rpoispp(lambda = lambda, win = disc10)

# Plot the Poisson point pattern
plot(ppois)

"The spatstat package also has functions for generating point patterns from other process models. 
These generally fall into one of two classes: clustered processes, where points occur together more
than under a uniform Poisson process, and regular (aka inhibitory) processes where points are more 
spaced apart than under a uniform intensity Poisson process. Some process models can generate patterns 
on a continuum from clustered through uniform to regular depending on their parameters.

The quadrat.test() function can test against clustered or regular alternative hypotheses. By default it 
tests against either of those, but this can be changed with the alternative parameter to create a one-sided test.

A Thomas process is a clustered pattern where a number of 'parent' points, uniformly distributed, create 
a number of 'child' points in their neighborhood. The child points themselves form the pattern. 
This is an attractive point pattern, and makes sense for modeling things like trees, since new trees
will grow near the original tree. Random Thomas point patterns can be generated using rThomas(). 
This takes three numbers that determine the intensity and clustering of the points, and a window object.

Conversely the points of a Strauss process cause a lowering in the probability of finding another point nearby.
The parameters of a Strauss process can be such that it is a 'hard-core' process, where no two points can be closer
than a set threshold. Creating points from this process involves some clever simulation algorithms. This is a repulsive
point pattern, and makes sense for modeling things like territorial animals, since the other animals of that species will 
avoid the territory of a given animal. Random Strauss point patterns can be generated using rStrauss(). This takes three
numbers that determine the intensity and 'territory' of the points, and a window object. Points generated by a Strauss process 
are sometimes called regularly spaced."

'Create a disc of radius 10, assigning to disc10.
Generate points from a Thomas process in a disc of radius 10.
Keep the pre-defined values, and pass disc10 as the window.
Assign to p_cluster.
Plot the result.
Run a quadrat test against a "clustered" alternative hypothesis.
Do the same for a Strauss process, but test against a "regular" point pattern hypothesis. '


# Create a disc of radius 10
disc10 <- disc(10)
# Generate clustered points from a Thomas process
set.seed(123)
p_cluster <- rThomas(kappa = 0.35, scale = 1, mu = 3, win = disc10)
plot(p_cluster)

# Run a quadrat test
quadrat.test(p_cluster, alternative = "clustered")

# Regular points from a Strauss process
set.seed(123)
p_regular <- rStrauss(beta = 2.9, gamma = 0.025, R = .5, W = disc10)
plot(p_regular)

# Run a quadrat test
quadrat.test(p_regular, alternative = "regular")


'Nearest-neighbor distributions
Another way of assessing clustering and regularity is to consider each point,
and how it relates to the other points. One simple measure is the distribution 
of the distances from each point to its nearest neighbor.

The nndist() function in spatstat takes a point pattern and for each point 
returns the distance to its nearest neighbor. You can then plot the histogram.

Instead of working with the nearest-neighbor density, as seen in the histogram, 
it can be easier to work with the cumulative distribution function, G(r). This is 
the probability of a point having a nearest neighbour within a distance r.

For a uniform Poisson process, G can be computed theoretically, and is
G(r) = 1 - exp( - lambda * pi * r ^ 2). You can compute G empirically from your data
using Gest() and so compare with the theoretical value.

Events near the edge of the window might have had a nearest neighbor outside the window,
and so unobserved. This will make the distance to its observed nearest neighbor larger
than expected, biasing the estimate of G. There are several methods for correcting this bias.

Plotting the output from Gest shows the theoretical cumulative distribution and several 
estimates of the cumulative distribution using different edge corrections. Often these edge 
corrections are almost indistinguishable, and the lines overlap. The plot can be used as a
quick exploratory test of complete spatial randomness.'


'Two ppp objects, p_poisson, and p_regular are defined for you.

Pass the Poisson point pattern to nndist() to find the nearest neighbor of each point, assigning the result to nnd_poisson.
Plot the histogram of the nearest neighbor distances for the Poisson point data.
Estimate G(r) for the Poisson point pattern by passing p_poisson to Gest(). Assign the result to G_poisson.
Plot G(r) vs. r by passing the estimate (G_poisson) to plot().
Repeat the previous four steps using the regular point pattern.'

# Point patterns are pre-defined
p_poisson; p_regular

# Calc nearest-neighbor distances for Poisson point data
nnd_poisson <- nndist(p_poisson)

# Draw a histogram of nearest-neighbor distances
hist(nnd_poisson)

# Estimate G(r)
G_poisson <- Gest(p_poisson)


'A number of other functions of point patterns have been developed. 
They are conventionally denoted by various capital letters, including F, H, J, K and L.

The K-function is defined as the expected number of points within a distance 
of a point of the process, scaled by the intensity. Like G, this can be computed 
theoretically for a uniform Poisson process and is K(r) = pi * r ^ 2 - the area of a circle of that radius. Deviation from pi 
* r ^ 2 can indicate clustering or point inhibition.

Computational estimates of K(r) are done using the Kest() function.

As with G calculations, K-function calculations also need edge corrections. 
The default edge correction in spatstat is generally the best, but can be slow, 
so well use the "border" correction for speed here.

Uncertainties on K-function estimates can be assessed by randomly sampling
points from a uniform Poisson process in the area and computing the K-function
of the simulated data. Repeat this process 99 times, and take the minimum and 
maximum value of K over each of the distance values. This gives an envelope - 
if the K-function from the data goes above the top of the envelope then we have
evidence for clustering. If the K-function goes below the envelope then there is 
evidence for an inhibitory process causing points to be spaced out. Envelopes can 
be computed using the envelope() function.

The plot method for estimates of K uses a formula system where a dot on the left 
of a formula refers to K(r). So the default plot uses . ~ r. You can compare the 
estimate of K to a Poisson process by plotting . - pi * r ^ 2 ~ r. If the data was 
generated by a Poisson process, then the line should be close to zero for all values of r.'

'The ppp objects p_poisson, p_cluster, and p_regular are defined for you.

Use the Kest() function to estimate the K function for the Poisson points.
Pass the point pattern as the first argument.
Set the correction argument to "border".
Plot the K function with the default formula, . ~ r.
Plot the K function with a formula that subtracts the theoretical Poisson value, . - pi * r ^ 2 ~ r.
Use envelope() to simulate K for the cluster data.
The first argument is the point pattern object, p_cluster.
The second argument is the estimation function, Kest.
As before, use "border" for the correction argument.
Plot the simulation envelope with a formula that subtracts the theoretical Poisson value, . - pi * r ^ 2 ~ r.
Repeat the last two steps for the regular data.
    '

# Point patterns are pre-defined
p_poisson; p_cluster; p_regular

# Estimate the K-function for the Poisson points
K_poisson <- Kest(p_poisson, correction = "border")

# The default plot shows quadratic growth
plot(K_poisson, . ~ r)

# Subtract pi * r ^ 2 from the Y-axis and plot
plot(K_poisson ,. - pi * r ^ 2 ~ r)

# Compute envelopes of K under random locations
K_cluster_env <- envelope(p_cluster, Kest, correction = "border")

# Insert the full formula to plot K minus pi * r^2
plot(K_cluster_env ,. - pi * r ^ 2 ~ r)

# Repeat for regular data
K_regular_env <-  envelope(p_regular, Kest, correction = "border")
plot(K_regular_env , .- pi * r ^ 2 ~ r)