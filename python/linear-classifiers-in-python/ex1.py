"""
KNN classification
In this exercise you'll explore a subset of the Large Movie Review Dataset. 
The variables X_train, X_test, y_train, and y_test are already loaded into the environment. 
The X variables contain features based on the words in the movie reviews, and the y variables
contain labels for whether the review sentiment is positive (+1) or negative (-1).
This course touches on a lot of concepts you may have forgotten, so if you ever need a quick
refresher, download the Scikit-Learn Cheat Sheet and keep it handy!

"""
from sklearn.neighbors import KNeighborsClassifier

# Create and fit the model
knn = KNeighborsClassifier()
knn.fit(X_train, y_train)

# Predict on the test features, print the results
pred = knn.predict(X_test)[0]
print("Prediction for test example 0:", pred)

"""
Running LogisticRegression and SVC
In this exercise, you'll apply logistic regression 
and a support vector machine to classify images of handwritten digits.
"""


from sklearn import datasets
digits = datasets.load_digits()
X_train, X_test, y_train, y_test = train_test_split(digits.data, digits.target)

# Apply logistic regression and print scores
lr = LogisticRegression()
lr.fit(X_train, y_train)
print(lr.score(X_train, y_train))
print(lr.score( X_test, y_test))

# Apply SVM and print scores
svm = SVC()
svm.fit(X_train, y_train)
print(svm.score(X_train, y_train))
print(svm.score(X_test, y_test))

"""
Sentiment analysis for movie reviews
In this exercise you'll explore the probabilities 
outputted by logistic regression on a subset of the Large Movie Review Dataset.
The variables X and y are already loaded into the environment.
X contains features based on the number of times words appear in the movie
reviews, and y contains labels for whether the review sentiment is positive (+1) or negative (-1).
"""
# Instantiate logistic regression and train
lr = LogisticRegression()
lr.fit(X, y)

# Predict sentiment for a glowing review
review1 = "LOVED IT! This movie was amazing. Top 10 this year."
review1_features = get_features(review1)
print("Review:", review1)
print("Probability of positive review:", lr.predict_proba(review1_features)[0,1])

# Predict sentiment for a poor review
review2 = "Total junk! I'll never watch a film by that director again, no matter how good the reviews."
review2_features = get_features(review2)
print("Review:", review2)
print("Probability of positive review:", lr.predict_proba(review2_features)[0,1])


"""
Visualizing decision boundaries
In this exercise, you'll visualize the decision boundaries of various classifier types.
A subset of scikit-learn's built-in wine dataset is already loaded into X, along with binary labels in y.
"""


from sklearn.linear_model import LogisticRegression
from sklearn.svm import SVC, LinearSVC
from sklearn.neighbors import KNeighborsClassifier

# Define the classifiers
classifiers = [LogisticRegression(), LinearSVC(),
               SVC(), KNeighborsClassifier()]

# Fit the classifiers
for c in classifiers:
    c.fit(X, y)

# Plot the classifiers
plot_4_classifiers(X, y, classifiers)
plt.show()


