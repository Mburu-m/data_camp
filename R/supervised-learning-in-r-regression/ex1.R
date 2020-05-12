

"Code a simple one-variable regression
For the first coding exercise, you'll create a
formula to define a one-variable modeling task, 
and then fit a linear model to the data. You are given 
the rates of male and female unemployment in the United 
States over several years (Source).

The task is to predict the rate of female unemployment
from the observed rate of male unemployment. 
The outcome is female_unemployment, and the input
is male_unemployment.

The sign of the variable coefficient tells you whether
the outcome increases (+) or decreases (-) as the variable increases.

Recall the calling interface for lm() is:

lm(formula, data = ___)"
library(tidyverse)
library(sigr)
# unemployment is loaded in the workspace
unemployment <- readRDS("unemployment.rds")
summary(unemployment)

# Define a formula to express female_unemployment as a function of male_unemployment
fmla <- formula(female_unemployment ~ male_unemployment, data =unemployment )

# Print it
fmla

# Use the formula to fit a model: unemployment_model
unemployment_model <- lm(fmla, data = unemployment)

# Print it
unemployment_model

"Examining a model
Let's look at the model unemployment_model 
that you have just created. There are a variety of
different ways to examine a model; each way provides 
different information. We will use summary(), broom::glance(),
and sigr::wrapFTest()."


# broom and sigr are already loaded in your workspace
# Print unemployment_model

unemployment_model
# Call summary() on unemployment_model to get more details
summary(unemployment_model)

# Call glance() on unemployment_model to see the details in a tidier form
library(broom)
glance(unemployment_model)

# Call wrapFTest() on unemployment_model to see the most relevant details
wrapFTest(unemployment_model)

# unemployment is in your workspace
summary(unemployment)

# newrates is in your workspace
#newrates

# Predict female unemployment in the unemployment data set
unemployment$prediction <-  predict(unemployment_model, newdata = unemployment)

# load the ggplot2 package
#library(ggplot2)

# Make a plot to compare predictions to actual (prediction on x axis). 
ggplot(unemployment, aes(x =prediction, y = female_unemployment)) + 
    geom_point() +
    geom_abline(color = "blue")

# Predict female unemployment rate when male unemployment is 5%
newrates <- data.frame(male_unemployment = 5)
pred <- predict(unemployment_model, newdata = newrates)
# Print it
pred
bloodpressure <- readRDS("bloodpressure.rds")
# bloodpressure is in the workspace
summary(bloodpressure)

# Create the formula and print it
fmla <- formula(blood_pressure ~ weight + age)
fmla

# Fit the model: bloodpressure_model

bloodpressure_model <- lm(fmla, data = bloodpressure)

# Print bloodpressure_model and call summary() 
bloodpressure_model
summary(bloodpressure_model)


# bloodpressure is in your workspace
summary(bloodpressure)

# bloodpressure_model is in your workspace
bloodpressure_model

# predict blood pressure using bloodpressure_model :prediction
bloodpressure$prediction <- predict(bloodpressure_model, newdata = bloodpressure)

# plot the results
ggplot(bloodpressure, aes(prediction, blood_pressure)) + 
    geom_point() +
    geom_abline(color = "blue")

# From previous step
unemployment$predictions <- predict(unemployment_model)

# Calculate residuals
unemployment$residuals <- residuals(unemployment_model)

# Fill in the blanks to plot predictions (on x-axis) versus the residuals
ggplot(unemployment, aes(x = predictions, y = residuals)) + 
    geom_pointrange(aes(ymin = 0, ymax = residuals)) + 
    geom_hline(yintercept = 0, linetype = 3) + 
    ggtitle("residuals vs. linear model prediction")

"The gain curve to evaluate the unemployment model
In the previous exercise you made predictions about female_unemployment and visualized 
the predictions and the residuals. Now, you will also plot the gain curve of the unemployment_model's
predictions against actual female_unemployment using the WVPlots::GainCurvePlot() function.

For situations where order is more important than exact values, the gain curve helps you check if 
the model's predictions sort in the same order as the true outcome.

Calls to the function GainCurvePlot() look like:

GainCurvePlot(frame, xvar, truthvar, title)
where

frame is a data frame
xvar and truthvar are strings naming the prediction and actual outcome columns of frame
title is the title of the plot
When the predictions sort in exactly the same order, the relative Gini coefficient is 1. 
When the model sorts poorly, the relative Gini coefficient is close to zero, or even negative."


# unemployment is in the workspace (with predictions)
summary(unemployment)

# unemployment_model is in the workspace
summary(unemployment_model)

# Load the package WVPlots
library(WVPlots)

# Plot the Gain Curve

GainCurvePlot(unemployment, "predictions",
              "female_unemployment", "Unemployment model")


# unemployment is in the workspace
summary(unemployment)

# For convenience put the residuals in the variable res
res <- unemployment$predictions - unemployment$female_unemployment

# Calculate RMSE, assign it to the variable rmse and print it
(rmse <- sqrt(mean(res^2)))

# Calculate the standard deviation of female_unemployment and print it
(sd_unemployment <- sd(unemployment$female_unemployment))



# Calculate mean female_unemployment: fe_mean. Print it
(fe_mean <- mean(unemployment$female_unemployment))

# Calculate total sum of squares: tss. Print it
(tss <- sum((unemployment$female_unemployment - fe_mean)^2))

# Calculate residual sum of squares: rss. Print it
(rss <- sum((unemployment$predictions - unemployment$female_unemployment)^2))

# Calculate R-squared: rsq. Print it. Is it a good fit?
(rsq <-1 - rss/tss )

# Get R-squared from glance. Print it
(rsq_glance <- glance(unemployment_model)$r.squared)


# unemployment is in your workspace
summary(unemployment)

# unemployment_model is in the workspace
summary(unemployment_model)

# Get the correlation between the prediction and true outcome: rho and print it
(rho <- cor(unemployment$female_unemployment, unemployment$predictions))

# Square rho: rho2 and print it
(rho2 <- rho^2)

# Get R-squared from glance and print it
(rsq_glance <- glance(unemployment_model)$r.squared)


"Generating a random test/train split
For the next several exercises you will use the mpg data from the
package ggplot2. The data describes the characteristics of several 
makes and models of cars from different years. The goal is to predict 
city fuel efficiency from highway fuel efficiency.

In this exercise, you will split mpg into a training set mpg_train (75% of the data)
and a test set mpg_test (25% of the data). One way to do this is to generate a column of
uniform random numbers between 0 and 1, using the function runif().

If you have a data set dframe of size N, and you want a random subset of approximately size 
100∗X% of N (where X is between 0 and 1), then:

Generate a vector of uniform random numbers: gp = runif(N).
dframe[gp < X,] will be about the right size.
dframe[gp >= X,] will be the complement."


# mpg is in the workspace
summary(mpg)
dim(mpg)

# Use nrow to get the number of rows in mpg (N) and print it
(N <- nrow(mpg))

# Calculate how many rows 75% of N should be and print it
# Hint: use round() to get an integer
(target <- round(.75*N))

# Create the vector of N uniform random variables: gp
gp <- runif(N)

# Use gp to create the training set: mpg_train (75% of data) and mpg_test (25% of data)
mpg_train <- mpg[gp < 0.75,]
mpg_test <- mpg[gp >= 0.75,]

# Use nrow() to examine mpg_train and mpg_test
nrow(mpg_train)
nrow(mpg_test)


# mpg_train is in the workspace
summary(mpg_train)

# Create a formula to express cty as a function of hwy: fmla and print it.
(fmla <- formula(cty~hwy))

# Now use lm() to build a model mpg_model from mpg_train that predicts cty from hwy 
mpg_model <- lm(fmla, data = mpg_train)

# Use summary() to examine the model
summary(mpg_model)


"Evaluate a model using test/train split
Now you will test the model mpg_model on the test data, 
mpg_test. Functions rmse() and r_squared() to calculate RMSE
and R-squared have been provided for convenience:

rmse(predcol, ycol)
r_squared(predcol, ycol)




where:

predcol: The predicted values
ycol: The actual outcome
You will also plot the predictions vs. the outcome.

Generally, model performance is better on the training data than the test data (though sometimes the test set gets lucky).
A slight difference in performance is okay; if the performance on training is significantly better, there is a problem."




# Examine the objects in the workspace
ls.str()

# predict cty from hwy for the training set
mpg_train$pred <- predict(mpg_model, newdata = mpg_train)

# predict cty from hwy for the test set
mpg_test$pred <- predict(mpg_model, newdata = mpg_test)

# Evaluate the rmse on both training and test data and print them
(rmse_train <- rmse(mpg_train$pred, mpg_train$cty))
(rmse_test <- rmse(mpg_test$pred, mpg_test$cty))


# Evaluate the r-squared on both training and test data.and print them


(rsq_train <- r_squared(mpg_train$pred, mpg_train$cty))
(rsq_test <- r_squared(mpg_test$pred, mpg_test$cty))

# Plot the predictions (on the x-axis) against the outcome (cty) on the test data
ggplot(mpg_test, aes(x = pred, y = cty)) + 
    geom_point() + 
    geom_abline()


"Create a cross validation plan
There are several ways to implement an n-fold cross validation plan. In this exercise you will 
create such a plan using vtreat::kWayCrossValidation(), and examine it.

kWayCrossValidation() creates a cross validation plan with the following call:

splitPlan <- kWayCrossValidation(nRows, nSplits, dframe, y)
where nRows is the number of rows of data to be split, and nSplits is the desired number of cross-validation folds.

Strictly speaking, dframe and y aren't used by kWayCrossValidation; they are there for compatibility 
with other vtreat data partitioning functions. You can set them both to NULL.

The resulting splitPlan is a list of nSplits elements; each element contains two vectors:

train: the indices of dframe that will form the training set
app: the indices of dframe that will form the test (or application) set
In this exercise you will create a 3-fold cross-validation plan for the data set mpg."

# Load the package vtreat
library(vtreat)

# mpg is in the workspace
summary(mpg)

# Get the number of rows in mpg
nRows <- nrow(mpg)

# Implement the 3-fold cross-fold plan with vtreat
splitPlan <-  kWayCrossValidation(nRows, nSplits = 3, dframe = NULL , NULL)

# Examine the split plan
str(splitPlan)

"Evaluate a modeling procedure using n-fold cross-validation
In this exercise you will use splitPlan, the 3-fold cross validation plan from the 
previous exercise, to make predictions from a model that predicts mpg$cty from mpg$hwy.

If dframe is the training data, then one way to add a column of cross-validation predictions to the frame is as follows:
    
    # Initialize a column of the appropriate length
    dframe$pred.cv <- 0 
"
# k is the number of folds
# splitPlan is the cross validation plan


# alcohol is in the workspace
summary(alcohol)

# Both the formulae are in the workspace
fmla_add
fmla_interaction

# Create the splitting plan for 3-fold cross validation
set.seed(34245)  # set the seed for reproducibility
splitPlan <- kWayCrossValidation(nrow(alcohol), nSplits = 3, dframe = NULL , NULL)

# Sample code: Get cross-val predictions for main-effects only model
alcohol$pred_add <- 0  # initialize the prediction vector
for(i in 1:3) {
    split <- splitPlan[[i]]
    model_add <- lm(fmla_add, data = alcohol[split$train, ])
    alcohol$pred_add[split$app] <- predict(model_add, newdata = alcohol[split$app, ])
}

# Get the cross-val predictions for the model with interactions
alcohol$pred_interaction <- 0 # initialize the prediction vector
for(i in 1:3) {
    split <- splitPlan[[i]]
    model_interaction <- lm(fmla_interaction, data = alcohol[split$train, ])
    alcohol$pred_interaction[split$app] <- predict(model_interaction, newdata = alcohol[split$app, ])
}

# Get RMSE
alcohol %>% 
    gather(key = modeltype, value = pred, pred_add, pred_interaction) %>%
    mutate(residuals = Metabol - pred) %>%      
    group_by(modeltype) %>%
    summarize(rmse = sqrt(mean(residuals^2)))

for(i in 1:k) {
    # Get the ith split
    split <- splitPlan[[i]]
    
    # Build a model on the training data 
    # from this split 
    # (lm, in this case)
    model <- lm(fmla, data = dframe[split$train,])
    
    # make predictions on the 
    # application data from this split
    dframe$pred.cv[split$app] <- predict(model, newdata = dframe[split$app,])
}
"Cross-validation predicts how well a model built from all the data will 
perform on new data. As with the test/train split, for a good modeling procedure,
cross-validation performance and training performance should be close.
"

# mpg is in the workspace
summary(mpg)

# splitPlan is in the workspace
str(splitPlan)

# Run the 3-fold cross validation plan from splitPlan
k <- 3 # Number of folds
mpg$pred.cv <- 0 
for(i in 1:k) {
    split <- splitPlan[[i]]
    model <- lm(cty ~ hwy, data = mpg[split$train,])
    mpg$pred.cv[split$app] <- predict(model, newdata = mpg[split$app,])
}

# Predict from a full model
mpg$pred <- predict(lm(cty ~ hwy, data = mpg))

# Get the rmse of the full model's predictions
rmse(mpg$pred, mpg$cty)

# Get the rmse of the cross-validation predictions
rmse(mpg$pred.cv, mpg$cty)


# Call str on flowers to see the types of each column
str(flowers)

# Use unique() to see how many possible values Time takes
unique(flowers$Time)

# Build a formula to express Flowers as a function of Intensity and Time: fmla. Print it
(fmla <- as.formula("Flowers ~ Intensity + Time"))

# Use fmla and model.matrix to see how the data is represented for modeling
mmat <- model.matrix(fmla, data = flowers)

# Examine the first 20 lines of flowers
head(flowers, 20)

# Examine the first 20 lines of mmat
head(mmat, 20)


# flowers in is the workspace
str(flowers)

# fmla is in the workspace
fmla

# Fit a model to predict Flowers from Intensity and Time : flower_model
flower_model <- lm(fmla, data = flowers)

# Use summary on mmat to remind yourself of its structure
summary(mmat)

# Use summary to examine flower_model 
summary(flower_model)

# Predict the number of flowers on each plant
flowers$predictions <- predict(flower_model, flowers)

# Plot predictions vs actual flowers (predictions on x-axis)
ggplot(flowers, aes(x = predictions , y = Flowers)) + 
    geom_point() +
    geom_abline(color = "blue") 



"Modeling an interaction
In this exercise you will use interactions to model the effect of gender and gastric activity on alcohol metabolism.

The data frame alcohol has columns:

Metabol: the alcohol metabolism rate
Gastric: the rate of gastric alcohol dehydrogenase activity
Sex: the sex of the drinker (Male or Female)
In the video, we fit three models to the alcohol data:

one with only additive (main effect) terms : Metabol ~ Gastric + Sex
two models, each with interactions between gastric activity and sex
We saw that one of the models with interaction terms had a better R-squared than 
the additive model, suggesting that using interaction terms gives a better fit.
In this exercise we will compare the R-squared of one of the interaction models to the main-effects-only model.

Recall that the operator : designates the interaction between two variables.
The operator * designates the interaction between the two variables, plus the main effects."


# alcohol is in the workspace
summary(alcohol)

# Create the formula with main effects only
(fmla_add <- formula(Metabol ~Gastric + Sex))

# Create the formula with interactions
(fmla_interaction <-  formula(Metabol ~Gastric:Sex + Gastric) )

# Fit the main effects only model
model_add <- lm(fmla_add, data = alcohol)

# Fit the interaction model
model_interaction <- lm(fmla_interaction, data = alcohol)

# Call summary on both models and compare
summary(model_add)
summary(model_interaction)


"Relative error
In this exercise, you will compare relative error to absolute error. For the purposes of modeling, we will define relative error as

rel=(y−pred)y
that is, the error is relative to the true outcome. You will measure the overall relative error of a model using root mean squared relative error:

rmserel=(√rel2¯¯¯¯¯¯¯¯)
where rel2¯¯¯¯¯¯¯¯ is the mean of rel2.

The example (toy) dataset fdata is loaded in your workspace. It includes the columns:

y: the true output to be predicted by some model; imagine it is the amount of money a customer will spend on a visit to your store.
pred: the predictions of a model that predicts y.
label: categorical: whether y comes from a population that makes small purchases, or large ones.
You want to know which model does better: the one predicting the small purchases, or the one predicting large ones."