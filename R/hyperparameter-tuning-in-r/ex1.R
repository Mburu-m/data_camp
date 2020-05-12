"Model parameters vs. hyperparameters
In order to perform hyperparameter tuning,
it is important to really understand what hyperparameters 
are (and what they are not). So let's look at model parameters versus hyperparameters in detail.
Note: The Breast Cancer Wisconsin (Diagnostic) Data Set has been loaded as breast_cancer_data for you."

library(tidyverse)
library(data.table)
library(tictoc)

breast_cancer_data <- fread("breast_cancer_data.csv")

# Fit a linear model on the breast_cancer_data.
linear_model <- lm(concavity_mean ~ symmetry_mean,data = breast_cancer_data)

# Look at the summary of the linear_model.
summary(linear_model)

# Extract the coefficients.
coef(linear_model)

"What are the coefficients?
To get a good feel for the difference between
fitted model parameters and hyperparameters, we are 
going to take a closer look at those fitted parameters:
in our simple linear model, the coefficients. The dataset
breast_cancer_data has already been loaded for you and the
linear model call was run as in the previous lesson, 
so you can directly access the object linear_model.
In our linear model, we can extract the coefficients
in the following way: linear_model$coefficients. And we can visualize the relationship we modeled with a plot.
Remember, that a linear model has the basic formula: y = x * slope + intercept"



# Plot linear relationship.
ggplot(data = breast_cancer_data, 
       aes(x = symmetry_mean, y = concavity_mean)) +
    geom_point(color = "grey") +
    geom_abline(slope = linear_model$coefficients[2], 
                intercept = linear_model$coefficients[1])




"Machine learning with caret
Before we can train machine learning models and tune hyperparameters,
we need to prepare the data. The data has again been loaded into your 
workspace as breast_cancer_data. The library caret has already been loaded"


library(caret)
# Create partition index
index <- createDataPartition(breast_cancer_data$diagnosis, p = 0.7, list = FALSE)

# Subset `breast_cancer_data` with index
bc_train_data <- breast_cancer_data[index, ]
bc_test_data  <- breast_cancer_data[-index, ]

# Define 3x5 folds repeated cross-validation
fitControl <- trainControl(method = "repeatedcv", number = 5, repeats = 3)

# Run the train() function
gbm_model <- train(diagnosis ~ ., 
                   data = bc_train_data, 
                   method = "gbm", 
                   trControl = fitControl,
                   verbose = FALSE)

# Look at the model
gbm_model



"Changing the number of hyperparameters to tune
When we examine the model object closely, 
we can see that caret already did some automatic
hyperparameter tuning for us: train automatically creates 
a grid of tuning parameters. By default, if p is the number 
of tuning parameters, the grid size is 3^p. But we can also 
specify the number of different values to try for each hyperparameter.
The data has again been preloaded as bc_train_data. 
The libraries caret and tictoc have also been preloaded."


# Set seed.
set.seed(42)
# Start timer.
tic()
# Train model.
gbm_model <- train(diagnosis ~ ., 
                   data = bc_train_data, 
                   method = "gbm", 
                   trControl = trainControl(method = "repeatedcv", 
                                            number = 5, repeats = 3),
                   verbose = FALSE,
                   tuneLength = 4)
# Stop timer.
toc()


