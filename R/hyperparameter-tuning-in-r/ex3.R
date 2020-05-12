library(tidyverse)
library(data.table)
library(tictoc)
library(caret)
library(mlr)

'Modeling with mlr
As you have seen in the video just now,
mlr is yet another popular machine learning package in 
R that comes with many functions to do hyperparameter tuning.
Here, you are going to go over the basic workflow for training models with mlr.
The knowledge_train_data dataset has already been loaded for you, 
as have the packages mlr, tidyverse and tictoc. Remember that starting 
to type in the console will suggest autocompleting options for functions and packages.'

knowledge_test_data <- read_csv("knowledge_test_data.csv")
knowledge_train_data <- read_csv("knowledge_train_data.csv")
# Create classification taks
task <- makeClassifTask(data = knowledge_train_data, 
                        target = "UNS")

# Call the list of learners
listLearners() %>%
    as.data.frame() %>%
    select(class, short.name, package) %>%
    filter(grepl("classif.", class))

# Create learner
lrn <- makeLearner("classif.randomForest", 
                   fix.factors.prediction = TRUE,
                   predict.type = "prob")


'Random search with mlr
Now, you are going to perform hyperparameter tuning with random search.
You will prepare 
the different functions and objects you need to tune your model in the next exercise.
The knowledge_train_data dataset has already been loaded for you,
as have the packages mlr, tidyverse and tictoc. Remember to look 
into the function that lists all learners if you are unsure about the name of a learner.'

# Get the parameter set for neural networks of the nnet package
getParamSet("classif.nnet")
# Define task
task <- makeClassifTask(data = knowledge_train_data, 
                        target = "UNS")

# Define learner
lrn <- makeLearner("classif.nnet", predict.type = "prob", fix.factors.prediction = TRUE)

# Define set of parameters


# lrn <- makeLearner("classif.h2o.deeplearning",
#                    predict.type = "prob",
#                    fix.factors.prediction = TRUE)
# Define set of parameters
param_set <- makeParamSet(
    makeDiscreteParam("size", values = c(2,3,5)),
    makeNumericParam("decay", lower = 0.0001, upper = 0.1)
)

# Print parameter set
print(param_set)

# Define a random search tuning method.
ctrl_random <- makeTuneControlRandom()


'Perform hyperparameter tuning with mlr
Now, you can combine the prepared functions 
and objects from the previous exercise to actually 
perform hyperparameter tuning with random search.
The knowledge_train_data dataset has already been loaded for you, 
as have the packages mlr, tidyverse and tictoc. And the following code has also been run already:
# Define task
task <- makeClassifTask(data = knowledge_train_data, 
                        target = "UNS")
# Define learner
lrn <- makeLearner("classif.nnet", predict.type = "prob", fix.factors.prediction = TRUE)

# Define set of parameters
param_set <- makeParamSet(
  makeDiscreteParam("size", values = c(2,3,5)),
  makeNumericParam("decay", lower = 0.0001, upper = 0.1)
)'


# Define a random search tuning method.
ctrl_random <- makeTuneControlRandom(maxit = 6)

# Define a 3 x 3 repeated cross-validation scheme
cross_val <- makeResampleDesc("RepCV", folds = 3 * 3)

# Tune hyperparameters
tic()
lrn_tune <- tuneParams(lrn,
                       task,
                       resampling = cross_val,
                       control = ctrl_random,
                       par.set = param_set)
toc()


'valuating hyperparameter tuning results
Here, you will evaluate the results of a hyperparameter
tuning run for a decision tree trained with the rpart package. 
The knowledge_train_data dataset has already been loaded for you,
as have the packages mlr and tidyverse. And the following code has also been run:'


task <- makeClassifTask(data = knowledge_train_data, 
                        target = "UNS")

lrn <- makeLearner(cl = "classif.rpart", fix.factors.prediction = TRUE)

param_set <- makeParamSet(
    makeIntegerParam("minsplit", lower = 1, upper = 30),
    makeIntegerParam("minbucket", lower = 1, upper = 30),
    makeIntegerParam("maxdepth", lower = 3, upper = 10)
)

ctrl_random <- makeTuneControlRandom(maxit = 10)


'Evaluating hyperparameter tuning results
Here, you will evaluate the results of a hyperparameter tuning
run for a decision tree trained with the rpart package.
The knowledge_train_data dataset has already been loaded for you, 
as have the packages mlr and tidyverse. And the following code has also been run:'

task <- makeClassifTask(data = knowledge_train_data, 
                        target = "UNS")

lrn <- makeLearner(cl = "classif.rpart", fix.factors.prediction = TRUE)

param_set <- makeParamSet(
    makeIntegerParam("minsplit", lower = 1, upper = 30),
    makeIntegerParam("minbucket", lower = 1, upper = 30),
    makeIntegerParam("maxdepth", lower = 3, upper = 10)
)

ctrl_random <- makeTuneControlRandom(maxit = 10)
# Create holdout sampling
holdout <- makeResampleDesc("Holdout")

# Perform tuning
lrn_tune <- tuneParams(learner = lrn, task = task, resampling = holdout,
                       control = ctrl_random, par.set = param_set)

# Generate hyperparameter effect data
hyperpar_effects <- generateHyperParsEffectData(lrn_tune, partial.dep = TRUE)

# Plot hyperparameter effects
plotHyperParsEffect(hyperpar_effects, 
                    partial.dep.learn = "regr.glm",
                    x = "minsplit", y = "mmce.test.mean", z = "maxdepth",
                    plot.type = "line")



"Define aggregated measures
Now, you are going to define performance measures. 
The knowledge_train_data dataset has already been loaded for you,
as have the packages mlr and tidyverse. And the following code has also been run:"

task <- makeClassifTask(data = knowledge_train_data, 
                        target = "UNS")

lrn <- makeLearner(cl = "classif.nnet", fix.factors.prediction = TRUE)

param_set <- makeParamSet(
    makeIntegerParam("size", lower = 1, upper = 5),
    makeIntegerParam("maxit", lower = 1, upper = 300),
    makeNumericParam("decay", lower = 0.0001, upper = 1)
)

ctrl_random <- makeTuneControlRandom(maxit = 10)


# Create holdout sampling
holdout <- makeResampleDesc("Holdout", predict = "both")

# Perform tuning
lrn_tune <- tuneParams(learner = lrn, 
                       task = task, 
                       resampling = holdout, 
                       control = ctrl_random, 
                       par.set = param_set,
                       measures = list(acc,
                                       setAggregation(acc, train.mean), mmce,
                                       setAggregation(mmce, train.mean)))


"Setting hyperparameters
And finally, you are going to set specific hyperparameters,
which you might have found by examining your tuning results from before, 
The knowledge_train_data dataset has already been loaded for you, as 
have the packages mlr and tidyverse. And the following code has also been run:"




task <- makeClassifTask(data = knowledge_train_data, 
                        target = "UNS")

lrn <- makeLearner(cl = "classif.nnet", fix.factors.prediction = TRUE)


# Set hyperparameters
lrn_best <- setHyperPars(lrn, par.vals = list(size = 1, 
                                              maxit = 150, 
                                              decay = 0))

# Train model
model_best <- train(lrn_best, task)
