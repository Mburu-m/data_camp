'London EU referendum data
In 2016 the UK held a public vote on whether
to remain in the European Union. The results of the referendum,
where people voted either "Remain" or "Leave", are available online. 
The data set london_ref contains the results for the 32 boroughs of London, 
and includes the number and percentage of votes in each category as well as 
the count of spoilt votes, the population size and the electorate size.
The london_ref object is a SpatialPolygonsDataFrame, a special kind of data frame 
where each row also has the shape of the borough. It behaves like a data frame in many respects,
but can also be used to plot a choropleth, or shaded polygon, map.
You should start with some simple data exploration and mapping.
The following variables will be useful:
NAME : the name of the borough.
Electorate : the total number of people who can vote.
Remain, Leave : the number of votes for "Remain" or "Leave".
Pct_Remain, Pct_Leave : the percentage of votes for each side.
spplot() from the raster package provides a convenient way to draw a shaded map of regions'


'The london_ref object has been loaded.

Get a summary of the london_ref object.
For a borough to vote for "Leave", the number of "Leave" votes should be more than the number of "Remain" votes.
Use spplot() to make a shaded map, using the "Pct_Remain" variable to control the color.'


# See what information we have for each borough
summary(london_ref)

# Which boroughs voted to "Leave"?
london_ref$NAME[london_ref$Leave > london_ref$Remain]

# Plot a map of the percentage that voted "Remain"
spplot(london_ref, zcol = "Pct_Remain")


"Cartogram
Large areas, such as cities or countries, 
are often divided into smaller administrative units, 
often into zones of approximately equal population. 
But the area of those units may vary considerably.
When mapping them, the large areas carry more visual 
'weight' than small areas, although just as many people live in the small areas.

One technique for correcting for this is the cartogram. 
This is a controlled distortion of the regions, expanding some and
contracting others, so that the area of each region is proportional to
a desired quantity, such as the population. The cartogram also tries to
maintain the correct geography as much as possible, by keeping regions in
roughly the same place relative to each other.

The cartogram package contains functions for creating cartograms. 
You give it a spatial data frame and the name of a column, and you get back a
similar data frame but with regions distorted so that the region area is proportional to the column value of the regions.

You'll also use the rgeos package for computing the areas of individual regions with the gArea() function."


'The london_ref spatial data frame is already loaded.

Load the cartogram and rgeos packages.

Plot electorate against area for each region. Deviation from a straight line shows the degree of misrepresentation.

Create a cartogram scaling to the "Electorate" column.

Check that the electorate is proportional to the area.

Plot the "Remain" percentage on the cartogram. Notice how some areas have relatively shrunk or grown.'


# Use the cartogram and rgeos packages
library(cartogram)
library(rgeos)

# Make a scatterplot of electorate vs borough area
names(london_ref)
plot(london_ref$Electorate, gArea(london_ref, byid = TRUE))

# Make a cartogram, scaling the area to the electorate
carto_ref <- cartogram(london_ref, "Electorate")
plot(carto_ref)

# Check the linearity of the electorate-area plot
plot(carto_ref$Electorate, gArea(carto_ref, byid = TRUE))

# Make a fairer map of the Remain percentage
spplot(carto_ref, "Pct_Remain")


'Spatial autocorrelation test
The map of "Remain" votes seems to have spatial correlation. Pick any two boroughs that are
neighbors - with a shared border - and the chances are they
ll be more similar than any two random boroughs. This can be a problem when using statistical models that assume, 
conditional on the model, that the data points are independent.
The spdep package has functions for measures of spatial correlation, also known as spatial dependency.
Computing these measures first requires you to work out which regions are neighbors via the poly2nb() function,
short for "polygons to neighbors". The result is an object of class nb. Then you can compute the test statistic and run a significance test on the null hypothesis of no spatial correlation. The significance test can either be done by Monte-Carlo or theoretical models.
In this example youll use the Moran "I" statistic to test the spatial correlation of the population and the percentage "Remain" vote.'

"Update the basic map of the London boroughs by adding the connections.

In the second plot call pass borough_nb and borough_centers.
Also pass add = TRUE to add to the existing plot rather than starting a new one.
Inspect an [spplot()]() map of TOTAL_POP.

Feed the TOTAL_POP vector into moran.test().

moran.test() needs a weighted version of the nb object which you get by calling nb2listw(). 
This runs the test against the theoretical distribution of Moran's I statistic. Find the p-value. Can you reject the null hypothesis of no spatial correlation?
Inspect an [spplot()]() map of Pct_Remain.
Run another Moran I statistic test, this time on the percent of Remain voters.

Use 999 Monte-carlo iterations via moran.mc().
The first two arguments are the same as for moran.test().
You also need to pass the argument nsim = 999.
Note the p-value. Can you reject the null hypothesis this time?"


# Use the spdep package
library(spdep)

# Make neighbor list
borough_nb <- poly2nb(london_ref)

# Get center points of each borough
borough_centers <- coordinates(london_ref)

# Show the connections
plot(london_ref); plot(borough_nb , borough_centers, add = T)

# Map the total pop'n
spplot(london_ref, zcol = "TOTAL_POP")

# Run a Moran I test on total pop'n
moran.test(
    london_ref$TOTAL_POP, 
    nb2listw(borough_nb)
)

# Map % Remain
spplot(london_ref, zcol = "Pct_Remain")

# Run a Moran I MC test on % Remain
moran.mc(
    london_ref$Pct_Remain, 
    nb2listw(borough_nb), 
    nsim = 999
)


'London health data
The UKs National Health Service publishes weekly data for consultations at 
a number of "sentinel" clinics and makes this data available. A dataset 
for one week in February 2017 has been loaded for you to analyze. It is 
called london, and contains data for the 32 boroughs.

You will focus on reports of "Influenza-like illness", or more simply "Flu".
Your first task is to map the "Standardized Morbidity Ratio", or SMR. This is 
the number of cases per person, but scaled by the overall incidence so that the expected number is 1.'

'The london object, a spatial data frame, and the sp package are ready for you.

Get a summary of the london data.

Use spplot() to draw a map of the number of reported flu case counts.

Recall that spplot() takes a spatial data frame and a string naming the column, in this case Flu_OBS.
Calculate the overall incidence rate of flu in London.

This is the total number of observed flu reports divided by the total population.
Assign the result to r.
Calculate the expected number of cases per borough.

This is the population multiplied by the overall rate.
Assign the result to the Flu_EXP column of london.
Calculate the standardized morbidity ratio.

This is the observed number divided by the expected number.
Assign the result to the Flu_SMR column of london.
Use spplot() to draw a map of the SMR.'


# Get a summary of the data set
summary(london)

# Map the OBServed number of flu reports
spplot(london, "Flu_OBS")

# Compute and print the overall incidence of flu
r <- sum(london$Flu_OBS) / sum(london$TOTAL_POP)
r

# Calculate the expected number for each borough
london$Flu_EXP <- london$TOTAL_POP * r

# Calculate the ratio of OBServed to EXPected
london$Flu_SMR <- london$Flu_OBS / london$Flu_EXP

# Map the SMR
spplot(london, "Flu_SMR")


'Binomial confidence intervals
SMRs above 1 represent high rates of disease - but how high does an SMR need
to be before it can be considered statistically significant?

Given a number of cases and a population, its possible to work out confidence
intervals at some level of the estimate of the ratio of cases per population using
the properties of the binomial distribution. The epitools package has a function binom.exact() 
which you can use to compute confidence intervals for the flu data. These can be 
scaled to be confidence intervals on the SMR by dividing by the overall rate.'


'The london data set and the sp package are loaded.

Compute the data frame of confidence intervals from the observed flu case and total population columns.

flu_ci is in the same order as london, so we can add the borough names.

The SMR can be obtained from a proportion (OBS/TOTAL) by dividing the proportion by the overall rate.

Select only the boroughs with SMR over 1.

Draw a point range ggplot of the SMR estimates and confidence intervals by borough.

The x aesthetic is NAME.
The y aesthetic is proportion divided by the incidence rate, r.
The ymin and ymax aesthetics are lower and upper divided by r respectively.
Add a point range geom using geom_pointrange().'
# For the binomial statistics function
library(epitools)

# Get CI from binomial distribution
flu_ci <- binom.exact(london$Flu_OBS, london$TOTAL_POP)

# Add borough names
flu_ci$NAME <- london$NAME

# Calculate London rate, then compute SMR
r <- sum(london$Flu_OBS) / sum(london$TOTAL_POP)
flu_ci$SMR <- flu_ci$proportion / r

# Subset the high SMR data
flu_high <- flu_ci[flu_ci$SMR > 1, ]

# Plot estimates with CIs
library(ggplot2)
ggplot(flu_high, aes(x = NAME, y = proportion / r,
                     ymin = lower / r, ymax = upper / r)) +
    geom_pointrange() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))



'Exceedence probabilities
Distributions and confidence intervals can be difficult things to present to non-statisticians.
An alternative is to present a probability that a value is over a threshold.
For example, public health teams might be interested in when an SMR has more than doubled,
and as a statistician you can give a probability that this has happened. Then the public health
team might decide to go to some alert level when the probability of a doubling of SMR is over 0.95.

Again, the properties of the binomial distribution let you compute this for proportional data.
You can then map these exceedence probabilities for some threshold, and use a sensible color scheme to highlight probabilities close to 1.'

'The london data set has been loaded, and the expected flu case count, Flu_EXP has been computed.

The binom.exceed() function is defined in the sample code. Use it to compute the exceedence probability.

Pass it three columns from the london spatial data frame: the observed incidence rate per borough, the total population per borough, and the expected incidence rate per borough.
Assign the result to the Flu_gt_2 column of london.
Call spplot() to map the exceedence probability.

The first argument is the dataset.
The second argument is a string naming the column to determine the color.
Pass the custom color palette, pal, to col.regions'
# Probability of a binomial exceeding a multiple
binom.exceed <- function(observed, population, expected, e){
    1 - pbinom(e * expected, population, prob = observed / population)
}

# Compute P(rate > 2)
london$Flu_gt_2 <- binom.exceed(
    observed = london$Flu_OBS,
    population = london$TOTAL_POP,
    expected = london$Flu_EXP,
    e = 2)

# Use a 50-color palette that only starts changing at around 0.9
pal <- c(
    rep("#B0D0B0", 40),
    colorRampPalette(c("#B0D0B0", "orange"))(5), 
    colorRampPalette(c("orange", "red"))(5)
)

# Plot the P(rate > 2) map
spplot(london, "Flu_gt_2", col.regions = pal, at = seq(0, 1, len = 50))


'A Poisson GLM
A Poisson generalized linear model is a way of fitting count data to explanatory variables. 
You get out parameter estimates and standard errors for your explanatory variables, and can get fitted values and residuals.

The glm() function fits Poisson GLMs. It works just like the lm() function, but you also specify 
a family argument. The formula has the usual meaning - response on the left of the ~, and explanatory variables on the right.

To cope with count data coming from populations of different sizes, you specify an offset argument.
This adds a constant term for each row of the data in the model. The log of the population is used in the offset term.'


'The london health data set has been loaded with the sp package also ready.

Run a Poisson generalized linear model of how the count of flu cases, Flu_OBS, 
depends on the Health Deprivation index value, HealthDeprivation.

The first argument is the formula (response vairable on the left).
The family argument is a function, poisson.
Look at the summary table of coefficients and decide if HealthDeprivation is significant.
You should see stars.

Calculate the residuals of the GLM model by passing the model object to residuals().

Assign this to the Flu_Resid column of london.
Use spplot() to draw a map of the residuals.'
# Fit a poisson GLM.
model_flu <- glm(
    Flu_OBS ~ HealthDeprivation, 
    offset = log(TOTAL_POP), 
    data = london, 
    family = poisson)

# Is HealthDeprivation significant?
summary(model_flu)

# Put residuals into the spatial data.
london$Flu_Resid <- residuals(model_flu)

# Map the residuals using spplot
spplot(london, "Flu_Resid")


'Residuals
A linear model should fit the data and leave uncorrelated residuals. 
This applies to non-spatial models, where, for example, fitting a straight
line through points on a curve would lead to serially-correlated residuals. 
A model on spatial data should aim to have residuals that show no significant spatial correlation.

You can test the model fitted to the flu data using moran.mc() from the spdep package.
Monte Carlo Moran tests were previously discussed in the Spatial autocorrelation test exercise earlier in the chapter.'


'The london data is loaded, and has a column Flu_Resid which has the residuals from the model.

Compute the neighborhood structure from the London map data.

Call poly2nb() on the london dataset.
Assign the result to borough_nb.
Run a Monte-Carlo Moran test on the correlation of the model residuals.

Call moran.mc().
The first argument is the residuals column of the london data, named Flu_Resid.
The second argument is the neighborhood structure, converted to a weighted neighbor list object using nb2listw().
Pass nsim = 999 to run 999 iterations of the simulation.
Are the residuals spatially correlated?'

# Compute the neighborhood structure.
library(spdep)
borough_nb <- poly2nb(london)

# Test spatial correlation of the residuals.
moran.mc(london$Flu_Resid, listw = nb2listw(borough_nb), nsim = 999)


"Fit a Bayesian GLM
Bayesian statistical models return samples of the parameters of interest (the posterior
distribution) based on some prior distribution which is then updated by the data. 
The Bayesian modeling process returns a number of samples from which you can compute the mean, 
or an exceedence probability, or any other quantity you might compute from a distribution.

Before you fit a model with spatial correlation, you'll first fit the same model as before, but using Bayesian inference."

"The london data set has been loaded.

The R2BayesX package provides an interface to the BayesX code.

Fit the GLM for flu as before.

Show its summary...

and the confidence intervals of its coefficients, using confint() 
Check the model coefficients and standard errors for significance.

The syntax for bayesx() is similar, but the offset has to be specified 
explicitly from the data frame, the family name is in quotes, and the spatial
data frame needs to be turned into a plain data frame.
Run the model fitting and inspect with summary().

Plot the samples from the Bayesian model. On the left is the 'trace'
of samples in sequential order, and on the right is the parameter density.
For this model there is an intercept and a slope for the Health Deprivation score.
The parameter density should correspond with the parameter summary."


# Use R2BayesX
library(R2BayesX)

# Fit a GLM
model_flu <- glm(Flu_OBS ~ HealthDeprivation, offset = log(TOTAL_POP),
                 data = london, family = poisson)

# Summarize it                    
summary(model_flu)

# Calculate coeff confidence intervals
confint(model_flu)

# Fit a Bayesian GLM
bayes_flu <- bayesx(Flu_OBS ~ HealthDeprivation, offset = log(london$TOTAL_POP), 
                    family = "poisson", data = as.data.frame(london), 
                    control = bayesx.control(seed = 17610407))

# Summarize it                    
summary(bayes_flu)

# Look at the samples from the Bayesian model
plot(samples(bayes_flu))



"Adding a spatially autocorrelated effect
You've fitted a non-spatial GLM with BayesX. You can include a spatially 
correlated term based on the adjacency structure by adding a term to the formula specifying a spatially correlated model."


"The spatial data object, london is already loaded.

Use poly2nb() to compute the neighborhood structure of london to an nb object.
R2BayesX uses its own objects for the adjacency. Convert the nb object to a gra object.
The sx function specifies additional terms to bayesx. Create a term using the 'spatial'
basis and the gra object for the boroughs to define the map.
Print a summary of the model object. You should see a table of coefficients for the 
parametric part of the model as in the previous exercise, and then a table of 'Smooth terms variance'
with one row for the spatial term. Note that since BayesX can fit many different forms in its sx terms, 
most of which, like the spatial model here, cannot be simply expressed with a parameter or two. This table 
shows the variance of the random effects - for further explanation consult a text on random effects modeling."


# Compute adjacency objects
borough_nb <- poly2nb(london)
borough_gra <- nb2gra(borough_nb)

# Fit spatial model
flu_spatial <- bayesx(
    Flu_OBS ~ HealthDeprivation + sx(i, bs = "spatial", map = borough_gra),
    offset = log(london$TOTAL_POP),
    family = "poisson", data = data.frame(london), 
    control = bayesx.control(seed = 17610407)
)

# Summarize the model
summary(flu_spatial)


'Mapping the spatial effects
As with glm, you can get the fitted values and residuals
from your model using the fitted and residuals functions.
bayesx models are a bit more complex, since you have the
linear predictor and terms from sx elements, such as the spatially correlated term.

The summary function will show you information for the linear model terms
and the smoothing terms in two separate tables. The spatial term is called 
"sx(i):mrf" - standing for "Markov Random Field".

Bayesian analysis returns samples from a distribution for our S(x) term 
at each of the London boroughs. The fitted function from bayesx models returns summary statistics for each borough. You
ll just look at the mean of that distribution for now.'


'The model from the BayesX output is available as flu_spatial.

Get a summary of the model and see where the parameter information is. Does the Health Deprivation parameter look significant?
Add a column named spatial to london with the mean of the distribution of the fitted spatial term, and map this.
Add another column, named spatial_resid, with the residuals.
Use the "mu" column from residuals, as this is based on the rate rather than the number of cases, so can be compared across areas with different populations.
Plot a map of spatial_resid using spplot().
Run a Moran statistic Monte-Carlo test on the residuals - do they show spatial correlation?
Call moran.mc(), passing the residual vector as the first argument.'

# Summarize the model
summary(flu_spatial)

# Map the fitted spatial term only
london$spatial <- fitted(flu_spatial, term = "sx(i):mrf")[, "Mean"]
spplot(london, zcol = "spatial")

# Map the residuals
london$spatial_resid <- residuals(flu_spatial)[, "mu"]
spplot(london, zcol = "spatial_resid")

# Test residuals for spatial correlation
moran.mc(london$spatial_resid, nb2listw(borough_nb), 999)



