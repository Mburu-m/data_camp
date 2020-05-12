
"""
Changing the model coefficients
When you call fit with scikit-learn, the logistic
regression coefficients are automatically learned from your dataset. 
In this exercise you will explore how the decision boundary is represented
by the coefficients. To do so, you will change the coefficients manually (instead of with fit), 
and visualize the resulting classifiers.
A 2D dataset is already loaded into the environment as X and y, along with a linear classifier object model.
"""
# Set the coefficients
model.coef_ = np.array([[0,1]])
model.intercept_ = np.array([0])

# Plot the data and decision boundary
plot_classifier(X,y,model)

# Print the number of errors
num_err = np.sum(y != model.predict(X))
print("Number of errors:", num_err)



"""Minimizing a loss function
In this exercise you'll implement linear regression "from scratch" using scipy.optimize.minimize.

We'll train a model on the Boston housing price data set, which is already 
loaded into the variables X and y. For simplicity, we won't include an intercept in our regression model.

"""

# The squared error, summed over training examples
def my_loss(w):
    s = 0
    for i in range(y.size):
        # Get the true and predicted target values for example 'i'
        y_i_true = y[i]
        y_i_pred = w@X[i]
        s = s + (y_i_pred - y_i_true)**2
    return s

# Returns the w that makes my_loss(w) smallest
w_fit = minimize(my_loss, X[0]).x
print(w_fit)

# Compare with scikit-learn's LinearRegression coefficients
lr = LinearRegression(fit_intercept=False).fit(X,y)
print(lr.coef_)


"""
Comparing the logistic and hinge losses
In this exercise you'll create a plot of the logistic 
and hinge losses using their mathematical expressions,
which are provided to you.
The loss function diagram from the video is shown on the right.
"""

# Mathematical functions for logistic and hinge losses
def log_loss(raw_model_output):
   return np.log(1+np.exp(-raw_model_output))
def hinge_loss(raw_model_output):
   return np.maximum(0,1-raw_model_output)

# Create a grid of values and plot
grid = np.linspace(-2,2,1000)
plt.plot(grid, log_loss(grid), label='logistic')
plt.plot(grid, hinge_loss(grid), label='hinge')
plt.legend()
plt.show()


"""
Implementing logistic regression
This is very similar to the earlier exercise where you
implemented linear regression "from scratch" using scipy.optimize.minimize.
However, this time we'll minimize the logistic loss and compare with scikit-learn's 
LogisticRegression (we've set C to a large value to disable regularization; more on this in Chapter 3!).

The log_loss() function from the previous exercise is already defined in your environment, and the sklearn 
breast cancer prediction dataset (first 10 features, standardized) is loaded into the variables X and 
"""

# The logistic loss, summed over training examples
def my_loss(w):
    s = 0
    for i in range(y.size):
        raw_model_output = w@X[i]
        s = s + log_loss(raw_model_output * y[i])
    return s

# Returns the w that makes my_loss(w) smallest
w_fit = minimize(my_loss, X[0]).x
print(w_fit)

# Compare with scikit-learn's LogisticRegression
lr = LogisticRegression(fit_intercept=False, C=1000000).fit(X,y)
print(lr.coef_)

