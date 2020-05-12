# Examine the dataset to identify potential independent variables

str(donors)
# Explore the dependent variable
table(donors$donated)

# Build the donation model
donation_model <- glm(donated~bad_address+interest_religion+interest_veterans, 
                      data = donors, family = "binomial")

# Summarize the model results

summary(donation_model)

# Estimate the donation probability
donors$donation_prob <- predict(donation_model, type = "response")

# Find the donation probability of the average prospect
mean(donors$donated)

# Predict a donation if probability of donation is greater than average (0.0504)
donors$donation_pred <- ifelse(donors$donation_prob > 0.0504, 1, 0)

# Calculate the model's accuracy
mean(donors$donated == donors$donation_pred)


"Calculating ROC Curves and AUC
The previous exercises have demonstrated that accuracy is a very misleading 
measure of model performance on imbalanced datasets. Graphing the model's performance better 
illustrates the tradeoff between a model that is overly agressive and one that is overly passive.

In this exercise you will create a ROC curve and compute the area under the curve (AUC) to evaluate 
the logistic regression model of donations you built earlier.

The dataset donors with the column of predicted probabilities, donation_prob ,is already loaded in your workspace."

# Load the pROC package

library(pROC)
# Create a ROC curve
ROC <- roc(donors$donated,donors$donation_prob)

# Plot the ROC curve
plot(ROC, col = "blue")

# Calculate the area under the curve (AUC)
auc(ROC)


# Convert the wealth rating to a factor
donors$wealth_levels <- factor(donors$wealth_rating, 
                               levels = c(0, 1, 2, 3), labels = c("Unknown", "Low", "Medium", "High"))

# Use relevel() to change reference category
donors$wealth_levels <- relevel(donors$wealth_levels, ref = "Medium" )

# See how our factor coding impacts the model
fit <- glm(donated~wealth_levels, data = donors, family = binomial)
summary(fit)


# Find the average age among non-missing values
summary(donors$age)

# Impute missing age values with the mean age
donors$imputed_age <- ifelse(is.na(donors$age), 61.65, donors$age)

# Create missing value indicator for age
donors$missing_age <-  ifelse(is.na(donors$age), 1, 0)


# Specify a null model with no predictors
null_model <- glm(donated~1, data = donors, family = "binomial")

# Specify the full model using all of the potential predictors
full_model <- glm(donated~., data = donors, family = "binomial")

# Use a forward stepwise algorithm to build a parsimonious model
step_model <- step(null_model, scope = list(lower = null_model, upper = full_model), direction = "forward")

# Estimate the stepwise donation probability
step_prob <- predict(step_model, type = "response")

# Plot the ROC of the stepwise model
library(pROC)
ROC <- roc(donors$donated, step_prob)
plot(ROC, col = "red")
auc(ROC)