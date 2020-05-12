
"Prepare data for modelling with h2o
In order to train models with h2o, you need to prepare
the data according to h2o's specific needs. Here,
you will go over a common data preparation workflow in h2o.
The h2o library has already been loaded for you, as has the
seeds_train_data object.
This chapter uses functions that can take some time to run, 
so don't be surprised if it takes a little longer than usual to
submit your answer. On rare occurrences, you may get a server error.
If this is the case, just reload the page"

library(tidyverse)
library(data.table)
library(tictoc)
library(h2o)
library(readr)
seeds_train_data <- fread("seeds_train_data.csv")
# Initialise h2o cluster
h2o.init()

# Convert data to h2o frame
seeds_train_data_hf <- as.h2o(seeds_train_data)

# Identify target and features
y <- "seed_type"
x <- setdiff(colnames(seeds_train_data_hf), y)

# Split data into train & validation sets
sframe <- h2o.splitFrame(seeds_train_data_hf, seed = 42)
train <- sframe[[1]]
valid <- sframe[[2]]

# Calculate ratio of the target variable in the training set
summary(train$seed_type, exact_quantiles = TRUE)

'Modeling with h2o
In the last exercise, you successfully prepared data 
for modeling with h2o. Now, you can use this data to train a model. 
The h2o library has already been loaded for you, as has the 
seeds_train_data object and the following code has been run:'


h2o.init()
seeds_train_data_hf <- as.h2o(seeds_train_data)

y <- "seed_type"
x <- setdiff(colnames(seeds_train_data_hf), y)

seeds_train_data_hf[, y] <- as.factor(seeds_train_data_hf[, y])

sframe <- h2o.splitFrame(seeds_train_data_hf, seed = 42)
train <- sframe[[1]]
valid <- sframe[[2]]

# Train random forest model
rf_model <- h2o.randomForest(x = x,
                             y = y,
                             training_frame = train,
                             validation_frame = valid)

# Calculate model performance
perf <- h2o.performance(rf_model, valid = TRUE)

# Extract confusion matrix
h2o.confusionMatrix(perf)

# Extract logloss
h2o.logloss(perf)

'Grid search with h2o
Now that you successfully trained a Random Forest model with h2o, 
you can apply the same concepts to training all other algorithms, 
like Deep Learning. In this exercise, you are going to apply a grid search to tune a model.
The h2o library has already been loaded and initialized for you.'


# Define hyperparameters
dl_params <- list(hidden = list(c(50, 50), c(100, 100)),
                  epochs = c(5, 10, 15),
                  rate = c(0.001, 0.005, 0.01))


'Random search with h2o
Next, you will use random search. 
The h2o library and seeds_train_data have 
already been loaded for you and the following code has been run:'

h2o.init()
seeds_train_data_hf <- as.h2o(seeds_train_data)

y <- "seed_type"
x <- setdiff(colnames(seeds_train_data_hf), y)

seeds_train_data_hf[, y] <- as.factor(seeds_train_data_hf[, y])

sframe <- h2o.splitFrame(seeds_train_data_hf, seed = 42)
train <- sframe[[1]]
valid <- sframe[[2]]

dl_params <- list(hidden = list(c(50, 50), c(100, 100)),
                  epochs = c(5, 10, 15),
                  rate = c(0.001, 0.005, 0.01))



'Random search with h2o
Next, you will use random search. 
The h2o library and seeds_train_data have already 
been loaded for you and the following code has been run:'

h2o.init()
seeds_train_data_hf <- as.h2o(seeds_train_data)

y <- "seed_type"
x <- setdiff(colnames(seeds_train_data_hf), y)

seeds_train_data_hf[, y] <- as.factor(seeds_train_data_hf[, y])

sframe <- h2o.splitFrame(seeds_train_data_hf, seed = 42)
train <- sframe[[1]]
valid <- sframe[[2]]

dl_params <- list(hidden = list(c(50, 50), c(100, 100)),
                  epochs = c(5, 10, 15),
                  rate = c(0.001, 0.005, 0.01))


# Define search criteria
search_criteria <- list(strategy = "RandomDiscrete", 
                        max_runtime_secs = 10, # this is way too short & only used to keep runtime short!
                        seed = 42)

# Train with random search
dl_grid <- h2o.grid("deeplearning", 
                    grid_id = "dl_grid",
                    x = x, 
                    y = y,
                    training_frame = train,
                    validation_frame = valid,
                    seed = 42,
                    hyper_params = dl_params,
                    search_criteria = search_criteria)




'Stopping criteria
In random search, you can also define stopping criteria
instead of a maximum runtime. The h2o library and seeds_train_data 
has already been loaded and initialized for you.'


# Define early stopping
stopping_params <- list(strategy = "RandomDiscrete", 
                        stopping_metric = "misclassification",
                        stopping_rounds = 2, 
                        stopping_tolerance = 0.1,
                        seed = 42)


'AutoML in h2o
A very convenient functionality of h2o is automatic
machine learning (AutoML). The h2o library and seeds_train_data
have already been loaded for you and the following code has been run:'

h2o.init()
seeds_train_data_hf <- as.h2o(seeds_train_data)

y <- "seed_type"
x <- setdiff(colnames(seeds_train_data_hf), y)

seeds_train_data_hf[, y] <- as.factor(seeds_train_data_hf[, y])

sframe <- h2o.splitFrame(seeds_train_data_hf, seed = 42)
train <- sframe[[1]]
valid <- sframe[[2]]


# Run automatic machine learning
automl_model <- h2o.automl(x = x, 
                           y = y,
                           training_frame = train,
                           max_runtime_secs = 10,
                           sort_metric = "mean_per_class_error",
                           nfolds = 3,
                           seed = 42)


# Run automatic machine learning
automl_model <- h2o.automl(x = x, 
                           y = y,
                           training_frame = train,
                           max_runtime_secs = 10,
                           sort_metric = "mean_per_class_error",
                           validation_frame= valid,
                           seed = 42)



'Correct! With training_frame + validation_frame,
training data is used as is, validation set is
split 50/50 into validation and leaderboard data.'


"'Extract h2o models and evaluate performance
In this final exercise, you will extract the best model 
from the AutoML leaderboard. The h2o library and test data 
has been loaded and the following code has been run:'
"

automl_model <- h2o.automl(x = x, 
                           y = y,
                           training_frame = seeds_data_hf,
                           nfolds = 3,
                           max_runtime_secs = 60,
                           sort_metric = "mean_per_class_error",
                           seed = 42)


# Extract the leaderboard
lb <- automl_model@leaderboard
head(lb)

# Assign best model new object name
aml_leader <- automl_model@leader

# Look at best model
summary(aml_leader)


