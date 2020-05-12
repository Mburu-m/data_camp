"""
Regularized logistic regression
In Chapter 1, you used logistic regression on the handwritten
digits data set. Here, we'll explore the effect of L2 regularization.

The handwritten digits dataset is already loaded, split,
and stored in the variables X_train, y_train, X_valid, and y_valid.
The variables train_errs and valid_errs are already initialized as empty lists.
"""

# Train and validaton errors initialized as empty list
train_errs = list()
valid_errs = list()

# Loop over values of C_value
for C_value in [0.001, 0.01, 0.1, 1, 10, 100, 1000]:
    # Create LogisticRegression object and fit
    lr = LogisticRegression(C = C_value)
    lr.fit(X_train, y_train)
    
    # Evaluate error rates and append to lists
    train_errs.append( 1.0 - lr.score(X_train, y_train) )
    valid_errs.append( 1.0 - lr.score(X_valid, y_valid) )
    
# Plot results
plt.semilogx(C_values, train_errs, C_values, valid_errs)
plt.legend(("train", "validation"))
plt.show()


"""
Logistic regression and feature selection
In this exercise we'll perform feature selection on 
the movie review sentiment data set using L1 regularization. 
The features and targets are already loaded for you in X_train and y_train.

We'll search for the best value of C using scikit-learn's GridSearchCV(), which was covered in the prerequisite course.
"""

# Specify L1 regularization
lr = LogisticRegression(penalty='l1')

# Instantiate the GridSearchCV object and run the search
searcher = GridSearchCV(lr, {'C':[0.001, 0.01, 0.1, 1, 10]})
searcher.fit(X_train, y_train)

# Report the best parameters
print("Best CV params", searcher.best_params_)

# Find the number of nonzero coefficients (selected features)
best_lr = searcher.best_estimator_
coefs = best_lr.coef_
print("Total number of features:", coefs.size)
print("Number of selected features:", np.count_nonzero(coefs))


"""
Identifying the most positive and negative words
In this exercise we'll try to interpret the coefficients 
of a logistic regression fit on the movie review sentiment dataset.
The model object is already instantiated and fit for you in the variable lr.

In addition, the words corresponding to the different features are loaded into the 
variable vocab. For example, since vocab[100] is "think", that means feature 100 corresponds 
to the number of times the word "think" appeared in that movie review.
"""

# Get the indices of the sorted cofficients
inds_ascending = np.argsort(lr.coef_.flatten()) 
inds_descending = inds_ascending[::-1]

# Print the most positive words
print("Most positive words: ", end="")
for i in range(5):
    print(vocab[inds_descending[i]], end=", ")
print("\n")

# Print most negative words
print("Most negative words: ", end="")
for i in range(5):
    print(vocab[inds_ascending[i]], end=", ")
print("\n")


"""
Regularization and probabilities
In this exercise, you will observe the effects of
changing the regularization strength on the predicted probabilities.
A 2D binary classification dataset is already loaded into the environment as X and y.
"""
# Set the regularization strength
model = LogisticRegression(C=.1)

# Fit and plot
model.fit(X,y)
plot_classifier(X,y,model,proba=True)

# Predict probabilities on training points
prob = model.predict_proba(X)
print("Maximum predicted probability", np.max(prob))


"""
Identifying the most positive and negative words
In this exercise we'll try to interpret the coefficients of a logistic regression
fit on the movie review sentiment dataset.
The model object is already instantiated and fit for you in the variable lr.

In addition, the words corresponding to the different features are loaded into the variable vocab. 
For example, since vocab[100] is "think", that means feature 100 corresponds to the number of times 
the word "think" appeared in that movie review.
"""

# Get the indices of the sorted cofficients
inds_ascending = np.argsort(lr.coef_.flatten()) 
inds_descending = inds_ascending[::-1]

# Print the most positive words
print("Most positive words: ", end="")
for i in range(5):
    print(vocab[inds_descending[i]], end=", ")
print("\n")

# Print most negative words
print("Most negative words: ", end="")
for i in range(5):
    print(vocab[inds_ascending[i]], end=", ")
print("\n")

"""
Visualizing easy and difficult examples
In this exercise, you'll visualize the examples that the logistic regression
model is most and least confident about by looking at the largest and smallest predicted probabilities.

The handwritten digits dataset is already loaded into the variables X and y. 
The show_digit function takes in an integer index and plots the corresponding image, with some extra information displayed above the image
"""

lr = LogisticRegression()
lr.fit(X,y)

# Get predicted probabilities
proba = lr.predict_proba(X)

# Sort the example indices by their maximum probability
proba_inds = np.argsort(np.max(proba,axis=1))

# Show the most confident (least ambiguous) digit
show_digit(proba_inds[-1], lr)

# Show the least confident (most ambiguous) digit
show_digit(proba_inds[0], lr)


"""
Fitting multi-class logistic regression
In this exercise, you'll fit the two types of multi-class 
logistic regression, one-vs-rest and softmax/multinomial, 
on the handwritten digits data set and compare the results. 
The handwritten digits dataset is already loaded and split into X_train, y_train, X_test, and y_test.
"""


# Fit one-vs-rest logistic regression classifier
lr_ovr = LogisticRegression()
lr_ovr.fit(X_train, y_train)

print("OVR training accuracy:", lr_ovr.score(X_train, y_train))
print("OVR test accuracy    :", lr_ovr.score(X_test, y_test))

# Fit softmax classifier
lr_mn =LogisticRegression(multi_class= "multinomial", solver = "lbfgs")

lr_mn.fit(X_train, y_train)

print("Softmax training accuracy:", lr_mn.score(X_train, y_train))
print("Softmax test accuracy    :", lr_mn.score(X_test, y_test))

"""
Visualizing multi-class logistic regression
In this exercise we'll continue with the two types of multi-class 
logistic regression, but on a toy 2D data set specifically designed to break the one-vs-rest scheme.
The data set is loaded into X_train and y_train. The two logistic regression
objects,lr_mn and lr_ovr, are already instantiated (with C=100), fit, and plotted.
Notice that lr_ovr never predicts the dark blue class... yikes! Let's explore why
this happens by plotting one of the binary classifiers that it's using behind the scenes.

"""


# Print training accuracies
print("Softmax     training accuracy:", lr_mn.score(X_train, y_train))
print("One-vs-rest training accuracy:", lr_ovr.score(X_train, y_train))

# Create the binary classifier (class 1 vs. rest)
lr_class_1 = LogisticRegression(C = 100)
lr_class_1.fit(X_train, y_train==1)

# Plot the binary classifier (class 1 vs. rest)
plot_classifier(X_train, y_train==1, clf=lr_class_1)

"""
One-vs-rest SVM
As motivation for the next and final chapter
on support vector machines, we'll repeat the previous exercise with a
non-linear SVM. Once again, the data is loaded into X_train, y_train, X_test, and y_test .

Instead of using LinearSVC, we'll now use scikit-learn's SVC object, which is a non-linear 
"kernel" SVM (much more on what this means in Chapter 4!). Again, your task is to create a plot of the binary classifier for class 1 vs. rest.
"""

# We'll use SVC instead of LinearSVC from now on
from sklearn.svm import SVC

# Create/plot the binary classifier (class 1 vs. rest)
svm_class_1 = SVC()
svm_class_1.fit(X_train, y_train==1)
plot_classifier(X_train, y_train==1, clf=svm_class_1)




