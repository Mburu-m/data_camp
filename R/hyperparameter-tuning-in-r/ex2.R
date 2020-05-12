'Cartesian grid search in caret
In chapter 1, you learned how to use the expand.grid() 
function to manually define hyperparameters. The same function
can also be used to define a grid of hyperparameters.
The voters_train_data dataset has already been preprocessed 
to make it a bit smaller so training will run faster; it has 
now 80 observations and balanced classes and has been loaded for you. 
The caret and tictoc packages have also been loaded and the trainControl 
object has been defined with repeated cross-validation:
fitControl <- trainControl(method = "repeatedcv",
                           number = 3,
                           repeats = 5)'

library(tidyverse)
library(data.table)
library(tictoc)
library(caret)

voters_data <- fread("voters_data.csv")
View(voters_data)

index <- createDataPartition(voters_data$turnout16_2016, p = 0.7, list = FALSE)

# Subset `breast_cancer_data` with index
voters_train_data <-voters_data[index, ]
voters_test_data  <- voters_data[-index, ]

# Define Cartesian grid
man_grid <- expand.grid(degree = c(1, 2, 3), 
                        scale = c(0.1, 0.01, 0.001), 
                        C = 0.5)

# Start timer, set seed & train model
tic()
set.seed(42)
svm_model_voters_grid <- train(turnout16_2016 ~ ., 
                               data = voters_train_data, 
                               method = "svmPoly", 
                               trControl = fitControl,
                               verbose= FALSE,
                               tuneGrid = man_grid)
toc()


# Plot default
plot(svm_model_voters_grid)

# Plot Kappa level-plot
plot(svm_model_voters_grid, metric = "Kappa", plottype = "level")




"Tune hyperparameters manually
If you already know which hyperparameter
values you want to set, you can also manually define
hyperparameters as a grid. Go to modelLookup('gbm')
or search for gbm in the list of available models in caret and check under Tuning Parameters.

Note: Just as before,bc_train_data and the libraries caret and tictoc have been preloaded."


# Define hyperparameter grid.
hyperparams <- expand.grid(n.trees = 200, 
                           interaction.depth = 1, 
                           shrinkage = 0.1, 
                           n.minobsinnode = 10)

# Apply hyperparameter grid to train().
set.seed(42)
gbm_model <- train(diagnosis ~ ., 
                   data = bc_train_data, 
                   method = "gbm", 
                   trControl = trainControl(method = "repeatedcv", 
                                            number = 5,repeats = 3),
                   verbose = FALSE,
                   tuneGrid = hyperparams)





"Grid search with range of hyperparameters
In chapter 1, you learned how to use the expand.grid()
function to manually define a set of hyperparameters.
The same function can also be used to define a grid with ranges of hyperparameters.
The voters_train_data dataset has been loaded for you, as have the caret and tictoc packages."

# Define the grid with hyperparameter ranges
big_grid <- expand.grid(size = seq(from = 1, to = 5, by = 1), decay = c(0, 1))

# Train control with grid search
fitControl <- trainControl(method = "repeatedcv", number = 3, repeats = 5, search = "grid")

# Train neural net
tic()
set.seed(42)
nn_model_voters_big_grid <- train(turnout16_2016 ~ ., 
                                  data = voters_train_data, 
                                  method = "nnet", 
                                  trControl = fitControl,
                                  verbose = FALSE)
toc()


# Define the grid with hyperparameter ranges
big_grid <- expand.grid(size = seq(from = 1, to = 5, by = 1), decay = c(0, 1))

# Train control with grid search
fitControl <- trainControl(method = "repeatedcv", number = 3, repeats = 5, search = "grid")

# Train neural net
tic()
set.seed(42)
nn_model_voters_big_grid <- train(turnout16_2016 ~ ., 
                                  data = voters_train_data, 
                                  method = "nnet", 
                                  trControl = fitControl,
                                  verbose = FALSE,
                                  tuneGrid = big_grid)
toc()



"Random search with caret
Now you are going to perform a random search instead of grid search!
As before, the small voters_train_data dataset has been loaded for you,
as have the caret and tictoc packages."


# Train control with random search
fitControl <- trainControl(method = "repeatedcv",
                           number = 3,
                           repeats = 5,
                           search = "random")

# Test 6 random hyperparameter combinations
tic()
nn_model_voters_big_grid <- train(turnout16_2016 ~ ., 
                                  data = voters_train_data, 
                                  method = "nnet", 
                                  trControl = fitControl,
                                  verbose = FALSE,
                                  tuneLength = 6)
toc()


"Adaptive Resampling with caret
Now you are going to train a model on the voter's 
dataset using Adaptive Resampling!
As before, the small voters_train_data dataset
has been loaded for you, as have the caret and tictoc packages."



# Define trainControl function
fitControl <- trainControl(method = "adaptive_cv",
                           number = 3, repeats = 3,
                           adaptive = list(min = 3, alpha = 0.05, method = "BT", complete = FALSE),
                           search = "random")

# Start timer & train model
tic()
svm_model_voters_ar <- train(turnout16_2016 ~ ., 
                             data = voters_train_data, 
                             method = "nnet", 
                             trControl = fitControl,
                             verbose = FALSE,
                             tuneLength = 6 )
toc()