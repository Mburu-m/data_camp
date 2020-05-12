
"""
Evaluate the regression tree
In this exercise, you will evaluate the test set performance
of dt using the Root Mean Squared Error (RMSE) metric. The RMSE of a model measures,
on average, how much the model's predictions differ from the actual labels. The RMSE of a model 
can be obtained by computing the square root of the model's Mean Squared Error (MSE).

The features matrix X_test, the array y_test, as well as the decision tree regressor dt that you
trained in the previous exercise are available in your workspace.
"""



# Import mean_squared_error from sklearn.metrics as MSE
from sklearn.metrics import mean_squared_error as MSE

# Compute y_pred
y_pred = dt.predict(X_test)

# Compute mse_dt
mse_dt = MSE(y_test, y_pred)

# Compute rmse_dt
rmse_dt = mse_dt**0.5

# Print rmse_dt
print("Test set RMSE of dt: {:.2f}".format(rmse_dt))

"""
Linear regression vs regression tree
In this exercise, you'll compare the test set
RMSE of dt to that achieved by a linear regression model. 
We have already instantiated a linear regression model lr and trained it on the same dataset as dt.

The features matrix X_test, the array of labels y_test, the trained 
linear regression model lr, mean_squared_error function which was imported under 
the alias MSE and rmse_dt from the previous exercise are available in your workspace.
"""

# Predict test set labels 
y_pred_lr = lr.predict(X_test)

# Compute mse_lr
mse_lr = MSE(y_test, y_pred_lr)

# Compute rmse_lr
rmse_lr = mse_lr**0.5

# Print rmse_lr
print('Linear Regression test set RMSE: {:.2f}'.format(rmse_lr))

# Print rmse_dt
print('Regression Tree test set RMSE: {:.2f}'.format(rmse_dt))



"""
Instantiate the model
In the following set of exercises, 
you'll diagnose the bias and variance 
problems of a regression tree. The regression 
tree you'll define in this exercise will be used 
to predict the mpg consumption of cars from the auto 
dataset using all available features.

We have already processed the data and loaded the features
matrix X and the array y in your workspace. In addition, 
the DecisionTreeRegressor class was imported from sklearn.tree.
"""

# Import train_test_split from sklearn.model_selection
from sklearn.model_selection import train_test_split

# Set SEED for reproducibility
SEED = 1

# Split the data into 70% train and 30% test
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=.3, random_state=SEED)

# Instantiate a DecisionTreeRegressor dt
dt = DecisionTreeRegressor(min_samples_leaf = .26, max_depth = 4, random_state=SEED)


"""
Evaluate the 10-fold CV error
In this exercise, you'll evaluate the 10-fold 
CV Root Mean Squared Error (RMSE) achieved by the
regression tree dt that you instantiated in the previous exercise.

In addition to dt, the training data including X_train and y_train are
available in your workspace. We also imported cross_val_score from sklearn.model_selection.

Note that since cross_val_score has only the option of evaluating the negative MSEs, 
its output should be multiplied by negative one to obtain the MSEs.
"""


# Compute the array containing the 10-folds CV MSEs
MSE_CV_scores = - cross_val_score(dt, X_train, y_train, cv= 10, 
                       scoring='neg_mean_squared_error',
                       n_jobs=-1)

# Compute the 10-folds CV RMSE
RMSE_CV = (MSE_CV_scores.mean())**(.5)

# Print RMSE_CV
print('CV RMSE: {:.2f}'.format(RMSE_CV))



"""Evaluate the training error
You'll now evaluate the training set RMSE 
achieved by the regression tree dt that you instantiated in a previous exercise.
In addition to dt, X_train and y_train are available in your workspace"

"""


# Import mean_squared_error from sklearn.metrics as MSE
from sklearn.metrics import mean_squared_error as MSE 

# Fit dt to the training set
dt.fit(X_train, y_train)

# Predict the labels of the training set
y_pred_train  = dt.predict(X_train)

# Evaluate the training set RMSE of dt
RMSE_train = (MSE(y_train, y_pred_train))**(.5)

# Print RMSE_train
print('Train RMSE: {:.2f}'.format(RMSE_train))

"""
High bias or high variance?
In this exercise you'll diagnose whether the regression 
tree dt you trained in the previous exercise suffers from a bias or a variance problem.
The training set RMSE (RMSE_train) and the CV RMSE (RMSE_CV) achieved
by dt are available in your workspace. In addition, we have also loaded a
variable called baseline_RMSE which corresponds to the root mean-squared error
achieved by the regression-tree trained with the disp feature only (it is the 
RMSE achieved by the regression tree trained in chapter 1, lesson 3). Here 
baseline_RMSE serves as the baseline RMSE above which a model is considered 
to be underfitting and below which the model is considered 'good enough'.
Does dt suffer from a high bias or a high variance problem?
"""

# ex

#dt suffers from high bias because RMSE_CV ≈ RMSE_train and both scores are greater than baseline_RMSE.



"""
Define the ensemble
In the following set of exercises, 
you'll work with the Indian Liver Patient Dataset
from the UCI Machine learning repository.

In this exercise, you'll instantiate three 
classifiers to predict whether a patient suffers 
from a liver disease using all the features present in the dataset.

The classes LogisticRegression, DecisionTreeClassifier,
and KNeighborsClassifier under the alias KNN are available in your workspace.
"""


# Set seed for reproducibility
SEED=1

# Instantiate lr
lr = LogisticRegression(random_state=SEED)

# Instantiate knn
knn = KNN(n_neighbors=27)

# Instantiate dt
dt = DecisionTreeClassifier(min_samples_leaf= .13, random_state=SEED)

# Define the list classifiers
classifiers = [('Logistic Regression', lr), ('K Nearest Neighbours', knn), ('Classification Tree', dt)]


"""
Evaluate individual classifiers
In this exercise you'll evaluate the performance
of the models in the list classifiers that we defined 
in the previous exercise. You'll do so by fitting each
classifier on the training set and evaluating its test set accuracy.

The dataset is already loaded and preprocessed for you 
(numerical features are standardized) and it is split into 70% train and 30% test. 
The features matrices X_train and X_test, as well as the arrays of labels y_train
and y_test are available in your workspace. In addition, we have loaded the list 
classifiers from the previous exercise, as well as the function accuracy_score() from sklearn.metrics.
"""

# Iterate over the pre-defined list of classifiers
for clf_name, clf in classifiers:    
 
    # Fit clf to the training set
    clf.fit(X_train, y_train)    
   
    # Predict y_pred
    y_pred = clf.predict(X_test)
    
    # Calculate accuracy
    accuracy = accuracy_score(y_test, y_pred) 
   
    # Evaluate clf's accuracy on the test set
    print('{:s} : {:.3f}'.format(clf_name, accuracy))


"""
Better performance with a Voting Classifier
Finally, you'll evaluate the performance of 
a voting classifier that takes the outputs of 
the models defined in the list classifiers and assigns 
labels by majority voting.
X_train, X_test,y_train, y_test, the list classifiers defined 
in a previous exercise, as well as the function accuracy_score 
from sklearn.metrics are available in your workspace.
"""

# Import VotingClassifier from sklearn.ensemble
from sklearn.ensemble import VotingClassifier

# Instantiate a VotingClassifier vc
vc = VotingClassifier(estimators= classifiers)     

# Fit vc to the training set
vc.fit(X_train, y_train)   

# Evaluate the test set predictions
y_pred = vc.predict(X_test)

# Calculate accuracy score
accuracy = accuracy_score(y_test, y_pred)
print('Voting Classifier: {:.3f}'.format(accuracy))

"""Define the bagging classifier
In the following exercises you'll work with the 
Indian Liver Patient dataset from the UCI machine learning 
repository. Your task is to predict whether a patient suffers 
from a liver disease using 10 features including Albumin, age and gender. 
You'll do so using a Bagging Classifier.
"""

# Import DecisionTreeClassifier
from sklearn.tree import DecisionTreeClassifier 

# Import BaggingClassifier
from sklearn.ensemble import BaggingClassifier
# Instantiate dt
dt = DecisionTreeClassifier(random_state=1)

# Instantiate bc
bc = BaggingClassifier(base_estimator=dt, n_estimators= 50, random_state=1)


"""
Evaluate Bagging performance
Now that you instantiated the bagging classifier, 
it's time to train it and evaluate its test set accuracy.
The Indian Liver Patient dataset is processed for you and split
into 80% train and 20% test. The feature matrices X_train and X_test,
as well as the arrays of labels y_train and y_test are available in your workspace.
In addition, we have also loaded the bagging classifier bc that you instantiated in 
the previous exercise and the function accuracy_score() from sklearn.metrics.
"""

# Fit bc to the training set
bc.fit(X_train, y_train)

# Predict test set labels
y_pred = bc.predict(X_test)

# Evaluate acc_test
acc_test = accuracy_score(y_test, y_pred)
print('Test set accuracy of bc: {:.2f}'.format(acc_test)) 

"""
Prepare the ground
In the following exercises, you'll compare the OOB accuracy to the test set 
accuracy of a bagging classifier trained on the Indian Liver Patient dataset.
In sklearn, you can evaluate the OOB accuracy of an ensemble classifier by 
setting the parameter oob_score to True during instantiation. After training the classifier, 
the OOB accuracy can be obtained by accessing the .oob_score_ attribute from the corresponding instance.
In your environment, we have made available the class DecisionTreeClassifier from sklearn.tree
"""


# Import DecisionTreeClassifier
from sklearn.tree import DecisionTreeClassifier

# Import BaggingClassifier
from sklearn.ensemble import BaggingClassifier

# Instantiate dt
dt = DecisionTreeClassifier(min_samples_leaf= 8, random_state=1)

# Instantiate bc
bc = BaggingClassifier(base_estimator= dt, 
            n_estimators= 50,
            oob_score=True,
            random_state=1)
            
            
            
"""
OOB Score vs Test Set Score
Now that you instantiated bc, you will fit it to the training set 
and evaluate its test set and OOB accuracies.
The dataset is processed for you and split into 80% train and 20% test.
The feature matrices X_train and X_test, as well as the arrays of labels y_train 
and y_test are available in your workspace. In addition, we have also loaded the 
classifier bc instantiated in the previous exercise and the function accuracy_score() from sklearn.metrics.
"""

# Fit bc to the training set 
bc.fit(X_train, y_train)

# Predict test set labels
y_pred = bc.predict(X_test)

# Evaluate test set accuracy
acc_test = accuracy_score(y_test, y_pred)

# Evaluate OOB accuracy
acc_oob = bc.oob_score_

# Print acc_test and acc_oob
print('Test set accuracy: {:.3f}, OOB accuracy: {:.3f}'.format(acc_test, acc_oob))


"""
Train an RF regressor
In the following exercises you'll predict
bike rental demand in the Capital Bikeshare program in Washington, 
D.C using historical weather data from the Bike Sharing Demand dataset 
available through Kaggle. For this purpose, you will be using the random forests 
algorithm. As a first step, you'll define a random forests regressor and fit it to the training set.

The dataset is processed for you and split into 80% train and 20% test. The features matrix X_train and the array y_train are available in your workspace.
"""


# Import RandomForestRegressor
from sklearn.ensemble import RandomForestRegressor

# Instantiate rf
rf = RandomForestRegressor(n_estimators= 25,
            random_state=2)
            
# Fit rf to the training set    
rf.fit(X_train, y_train) 


"""
Evaluate the RF regressor
You'll now evaluate the test set RMSE of the random forests regressor
rf that you trained in the previous exercise.

The dataset is processed for you and split into 80% train and 20% test. 
The features matrix X_test, as well as the array y_test are available in your workspace. 
In addition, we have also loaded the model rf that you trained in the previous exercise.
"""

# Import mean_squared_error as MSE
from sklearn.metrics import mean_squared_error as MSE

# Predict the test set labels
y_pred = rf.predict(X_test)

# Evaluate the test set RMSE
rmse_test = MSE(y_test, y_pred)**.5

# Print rmse_test
print('Test set RMSE of rf: {:.2f}'.format(rmse_test))


"""
Visualizing features importances
In this exercise, you'll determine which features were the most predictive 
according to the random forests regressor rf that you trained in a previous exercise.
For this purpose, you'll draw a horizontal barplot of the feature importance as assessed by rf. 
Fortunately, this can be done easily thanks to plotting capabilities of pandas.
We have created a pandas.Series object called importances containing the 
feature names as index and their importances as values. In addition, matplotlib.pyplot is available as plt and pandas as pd.
"""

# Create a pd.Series of features importances
importances = pd.Series(data=rf.feature_importances_,
                        index= X_train.columns)

# Sort importances
importances_sorted = importances.sort_values()

# Draw a horizontal barplot of importances_sorted
importances_sorted.plot(kind='barh', color ='lightgreen')
plt.title('Features Importances')
plt.show()





"""
Random forests hyperparameters
In the following exercises, you'll be revisiting the Bike Sharing
Demand dataset that was introduced in a previous chapter.
Recall that your task is to predict the bike rental demand using
historical weather data from the Capital Bikeshare program 
in Washington, D.C.. For this purpose, you'll be tuning 
the hyperparameters of a Random Forests regressor.
We have instantiated a RandomForestRegressor called rf using
sklearn's default hyperparameters. You can inspect the hyperparameters of rf in your console.
Which of the following is not a hyperparameter of rf?
"""


"""
et the hyperparameter grid of RF
In this exercise, you'll manually set the grid of 
hyperparameters that will be used to tune rf's hyperparameters
and find the optimal regressor. For this purpose, you will be constructing
a grid of hyperparameters and tune the number of estimators,
the maximum number of features used when splitting each node and the minimum number of samples (or fraction) per leaf.
"""

# Define the dictionary 'params_rf'
params_rf = {'n_estimators' : [100, 350, 500],
    'max_features' : ['log2', 'auto', 'sqrt'],
    'min_samples_leaf' : [2, 10, 30]
}



"""
Search for the optimal forest
In this exercise, you'll perform grid search using 3-fold
cross validation to find rf's optimal hyperparameters.
To evaluate each model in the grid, you'll be using the negative mean squared error metric.
Note that because grid search is an exhaustive search process, 
it may take a lot time to train the model. Here you'll only be 
instantiating the GridSearchCV object without fitting it to the training set.
As discussed in the video, you can train such an object similar to any scikit-learn estimator by using the .fit() method:
grid_object.fit(X_train, y_train)
The untuned random forests regressor model rf as well as the 
dictionary params_rf that you defined in the previous exercise are available in your workspace.
"""


# Import GridSearchCV
from sklearn.model_selection import GridSearchCV

# Instantiate grid_rf
grid_rf = GridSearchCV(estimator=rf,
                       param_grid= params_rf,
                       scoring='neg_mean_squared_error',
                       cv= 3,
                       verbose=1,
                       n_jobs=-1)
                       


"""
Evaluate the optimal forest
In this last exercise of the course, 
you'll evaluate the test set RMSE of grid_rf's optimal model.
The dataset is already loaded and processed for you and is split
into 80% train and 20% test. In your environment are available X_test,
y_test and the function mean_squared_error from sklearn.metrics under the alias MSE. 
In addition, we have also loaded the trained GridSearchCV object grid_rf that you instantiated 
in the previous exercise. Note that grid_rf was trained as follows:
grid_rf.fit(X_train, y_train)

"""


# Import mean_squared_error from sklearn.metrics as MSE 
from sklearn.metrics import mean_squared_error as MSE

# Extract the best estimator
best_model = grid_rf.best_estimator_

# Predict test set labels
y_pred = best_model.predict(X_test)

# Compute rmse_test
rmse_test = MSE(y_test, y_pred)**.5

# Print rmse_test
print('Test RMSE of best model: {:.3f}'.format(rmse_test)) 

