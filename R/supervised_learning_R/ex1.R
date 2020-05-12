"Can you apply a kNN classifier to help the car recognize this sign?

The dataset signs is loaded in your workspace along with the dataframe next_sign, which holds the observation you want to classify."

library(data.table)
library(tidyverse)

signs <- fread("knn_traffic_signs.csv")

# Load the 'class' package
library(class)

# Create a vector of labels
sign_types <- signs$sign_type

# Classify the next sign observed
next_sign <- signs[4, -(1:3)]
train <- signs[-4, -(1:3)] %>% as.matrix()
cl = sign_types[-4]
knn(train = train, test = next_sign, cl =cl )

# Examine the structure of the signs dataset

str(signs)
# Count the number of signs of each type
table(signs$sign_type)

# Check r10's average red level by sign type
aggregate(r10 ~ sign_type, data = signs, mean)

# Use kNN to identify the test road signs
sign_types <- signs$sign_type
train <- signs[sample == "train"]

signs_pred <- knn(train = signs[-1], test =test_signs[-1], cl =sign_types )

# Create a confusion matrix of the predicted versus actual values
signs_actual <- test_signs$sign_type
table(signs_actual,signs_pred)

# Compute the accuracy
mean(signs_actual == signs_pred)


# Compute the accuracy of the baseline model (default k = 1)
k_1 <- knn(train = signs[, -1], test = signs_test[, -1], cl = sign_types)
mean(signs_actual == k_1)

# Modify the above to set k = 7
k_7 <- knn(train = signs[, -1], test = signs_test[, -1], cl = sign_types, k = 7)
mean(signs_actual == k_7)

# Set k = 15 and compare to the above
k_15 <- knn(train = signs[, -1], test = signs_test[, -1], cl = sign_types, k = 15)
mean(signs_actual == k_15)

# Use the prob parameter to get the proportion of votes for the winning class
sign_pred <- knn(train = signs[, -1], test = signs_test[, -1], cl = sign_types, k = 7,
                 prob = TRUE)

# Get the "prob" attribute from the predicted classes
sign_prob <- attr(sign_pred, "prob")

# Examine the first several predictions
head(sign_pred )

# Examine the proportion of votes for the winning class
head(sign_prob)

# Compute P(A) 
p_A <- nrow(subset(where9am, location == "office"))/nrow(where9am)

# Compute P(B)
p_B <- nrow(subset(where9am, daytype == "weekday"))/nrow(where9am)

# Compute the observed P(A and B)
p_AB <- nrow(subset(where9am, location == "office" & daytype == "weekday" ))/nrow(where9am)

# Compute P(A | B) and print its value
p_A_given_B <- p_AB /p_B
p_A_given_B


# The 'naivebayes' package is loaded into the workspace
# and the Naive Bayes 'locmodel' has been built

# Examine the location prediction model

locmodel
# Obtain the predicted probabilities for Thursday at 9am
predict(locmodel,newdata = thursday9am , type = "prob")

# Obtain the predicted probabilities for Saturday at 9am
predict(locmodel,newdata = saturday9am , type = "prob")



# The 'naivebayes' package is loaded into the workspace already

# Build a NB model of location
locmodel <- naive_bayes(location~ daytype + hourtype,data = locations)

# Predict Brett's location on a weekday afternoon
predict(locmodel, weekday_afternoon)

# Predict Brett's location on a weekday evening
predict(locmodel, weekday_evening)


# The 'naivebayes' package is loaded into the workspace already
# The Naive Bayes location model (locmodel) has already been built

# Observe the predicted probabilities for a weekend afternoon
predict(locmodel,newdat = weekend_afternoon ,type = "prob")

# Build a new model using the Laplace correction
locmodel2 <- naive_bayes(location~ daytype + hourtype,data = locations, laplace = 1)

# Observe the new predicted probabilities for a weekend afternoon
predict(locmodel2,newdat = weekend_afternoon ,type = "prob")


# Examine the dataset to identify potential independent variables

str(donors)
# Explore the dependent variable
table(donors$donated)

# Build the donation model
donation_model <- glm(donated~bad_address+interest_religion+interest_veterans, 
                      data = donors, family = "binomial")

# Summarize the model results

summary(donation_model)

