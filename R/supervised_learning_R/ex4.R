
"Building a simple decision tree
The loans dataset contains 11,312 randomly-selected people who 
applied for and later received loans from Lending Club, a US-based peer-to-peer lending company.

You will use a decision tree to try to learn patterns in the outcome of these 
loans (either repaid or default) based on the requested loan amount and credit score at the time of application.

Then, see how the tree's predictions differ for an applicant with good credit 
versus one with bad credit.

The dataset loans is already in your workspace."


# Load the rpart package

library(rpart)
# Build a lending model predicting loan outcome versus loan amount and credit score
loan_model <- rpart(outcome~loan_amount+credit_score,
                    data = loans, method = "class", control = rpart.control(cp = 0))

# Make a prediction for someone with good credit
predict(loan_model, good_credit, type = "class")

# Make a prediction for someone with bad credit
predict(loan_model, bad_credit, type = "class")


# Examine the loan_model object
loan_model




# Grow a tree using all of the available applicant data
loan_model <- rpart(outcome~., data = loans_train, method = "class", control = rpart.control(cp = 0))

# Make predictions on the test dataset
loans_test$pred <- predict(loan_model, loans_test, type = "class")

# Examine the confusion matrix
table(loans_test$outcome, loans_test$pred )

# Compute the accuracy on the test dataset
mean(loans_test$outcome == loans_test$pred)

# Load the rpart.plot package

library(rpart.plot)
# Plot the loan_model with default settings

rpart.plot(loan_model)
# Plot the loan_model with customized settings
rpart.plot(loan_model, type = 3, box.palette = c("red", "green"), fallen.leaves = TRUE)



"Creating random test datasets
Before building a more sophisticated lending model, 
it is important to hold out a portion of the loan data to 
simulate how well it will predict the outcomes of future loan applicants.

As depicted in the following image, you can use 75% of the observations for training and 25% for testing the model.



The sample() function can be used to generate a random sample of rows to include in 
the training set. Simply supply it the total number of observations and the number needed for training.

Use the resulting vector of row IDs to subset the loans into training and testing datasets.
The dataset loans is loaded in your workspace."


# Determine the number of rows for training

nrow(loans)
# Create a random sample of row IDs
sample_rows <- sample(11312, .75*11312)

# Create the training dataset
loans_train <- loans[sample_rows,]

# Create the test dataset
loans_test <- loans[-sample_rows,]



"Preventing overgrown trees
The tree grown on the full set of applicant data grew to
be extremely large and extremely complex, with hundreds of splits 
and leaf nodes containing only a handful of applicants. This tree would be
almost impossible for a loan officer to interpret.

Using the pre-pruning methods for early stopping, you can prevent a tree from growing
too large and complex. See how the rpart control options for maximum tree depth and minimum
split count impact the resulting tree.

rpart is loaded."

# Swap maxdepth for a minimum split of 500 
loan_model <- rpart(outcome ~ ., data = loans_train, method = "class", control = rpart.control(cp = 0, maxdepth = 6))

# Run this. How does the accuracy change?
loans_test$pred <- predict(loan_model, loans_test, type = "class")
mean(loans_test$pred == loans_test$outcome)

# Swap maxdepth for a minimum split of 500 
loan_model <- rpart(outcome ~ ., data = loans_train, method = "class", control = rpart.control(cp = 0, minsplit= 500))

# Run this. How does the accuracy change?
loans_test$pred <- predict(loan_model, loans_test, type = "class")
mean(loans_test$pred == loans_test$outcome)


# Grow an overly complex tree
loan_model <- rpart(outcome ~ ., data = loans_train, method = "class", control = rpart.control(cp = 0))


# Examine the complexity plot
plotcp(loan_model )

# Prune the tree
loan_model_pruned <- prune(loan_model, cp = 0.0014 )

# Compute the accuracy of the pruned tree
loans_test$pred <- predict(loan_model_pruned, loans_test, type = "class")
mean(loans_test$pred == loans_test$outcome)


# Load the randomForest package
library(randomForest)

# Build a random forest model
loan_model <- randomForest(outcome~., data = loans)

# Compute the accuracy of the random forest
loans_test$pred <- predict(loan_model, loans_test)
mean(loans_test$pred == loans_test$outcome)


# Load the randomForest package
library(randomForest)

# Build a random forest model
loan_model <- randomForest(outcome~., data = loans_train)

# Compute the accuracy of the random forest
loans_test$pred <- predict(loan_model, loans_test)
mean(loans_test$pred == loans_test$outcome)
