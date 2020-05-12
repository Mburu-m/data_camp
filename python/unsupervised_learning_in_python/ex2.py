
"""
Hierarchical clustering of the grain data
In the video, you learned that the SciPy linkage() 
function performs hierarchical clustering on an array of samples. 
Use the linkage() function to obtain a hierarchical clustering of the grain samples,
and use dendrogram() to visualize the result. A sample of the grain measurements is provided in
the array samples, while the variety of each grain sample is given by the list varieties.

"""

# Perform the necessary imports
from scipy.cluster.hierarchy import linkage, dendrogram
import matplotlib.pyplot as plt

# Calculate the linkage: mergings
mergings = linkage(samples, method = "complete")

# Plot the dendrogram, using varieties as labels
dendrogram(mergings,
           labels=varieties,
           leaf_rotation= 90,
           leaf_font_size= 6,
)
plt.show()




"""
Hierarchies of stocks
In chapter 1, you used k-means clustering 
to cluster companies according to their stock price movements. 
Now, you'll perform hierarchical clustering of the companies. 
You are given a NumPy array of price movements movements, where the rows
correspond to companies, and a list of the company names companies. SciPy 
hierarchical clustering doesn't fit into a sklearn pipeline, so you'll need 
to use the normalize() function from sklearn.preprocessing instead of Normalizer.
linkage and dendrogram have already been imported from scipy.cluster.hierarchy

"""



# Import normalize
from sklearn.preprocessing import normalize

# Normalize the movements: normalized_movements
normalized_movements = normalize(movements)

# Calculate the linkage: mergings
mergings = linkage(normalized_movements, method = "complete")

# Plot the dendrogram
dendrogram(mergings,
           labels=companies,
           leaf_rotation= 90,
           leaf_font_size= 6,
)

plt.show()


"""
Different linkage, different hierarchical clustering!
In the video, you saw a hierarchical clustering of the voting 
countries at the Eurovision song contest using 'complete' linkage. Now,
perform a hierarchical clustering of the voting countries with 'single' linkage,
and compare the resulting dendrogram with the one in the video. Different linkage, different hierarchical clustering!

You are given an array samples. Each row corresponds to a voting country, and each column corresponds to 
a performance that was voted for. The list country_names gives the name of each voting country. This dataset was obtained from Eurovision.

"""



# Perform the necessary imports
import matplotlib.pyplot as plt
from scipy.cluster.hierarchy import linkage, dendrogram

# Calculate the linkage: mergings
mergings = linkage(samples, method = "single")

# Plot the dendrogram
dendrogram(mergings,
           labels=country_names,
           leaf_rotation= 90,
           leaf_font_size= 6,
)
plt.show()



"""
Extracting the cluster labels
In the previous exercise, you saw that
the intermediate clustering of the grain samples 
at height 6 has 3 clusters. Now, use the fcluster() 
function to extract the cluster labels for this intermediate clustering,
and compare the labels with the grain varieties using a cross-tabulation.

The hierarchical clustering has already been performed and mergings is the 
result of the linkage() function. The list varieties gives the variety of each grain sample.

"""

# Perform the necessary imports
import pandas as pd
from scipy.cluster.hierarchy import fcluster

# Use fcluster to extract labels: labels
labels = fcluster(mergings,6, criterion = "distance")

# Create a DataFrame with labels and varieties as columns: df
df = pd.DataFrame({'labels': labels, 'varieties': varieties})

# Create crosstab: ct
ct =pd.crosstab(df.labels, df.varieties)

# Display ct
print(ct)


"""t-SNE visualization of grain dataset
In the video, you saw t-SNE applied to the iris dataset. 
In this exercise, you'll apply t-SNE to the grain samples
data and inspect the resulting t-SNE features using a scatter plot.
You are given an array samples of grain samples and a list variety_numbers
giving the variety number of each grain sample.

"""

# Import TSNE
from sklearn.manifold import TSNE

# Create a TSNE instance: model
model = TSNE(learning_rate=200)

# Apply fit_transform to samples: tsne_features
tsne_features = model.fit_transform(samples)

# Select the 0th feature: xs
xs = tsne_features[:,0]

# Select the 1st feature: ys
ys = tsne_features[:,1]

# Scatter plot, coloring by variety_numbers
plt.scatter(xs, ys, c = variety_numbers)
plt.show()

"""

Correlated data in nature
You are given an array grains giving the width 
and length of samples of grain. You suspect that width and length
will be correlated. To confirm this, make a scatter plot of width vs length and measure their Pearson correlation.
"""


# Perform the necessary imports
import matplotlib.pyplot as plt
from scipy.stats import pearsonr

# Assign the 0th column of grains: width
width = grains[:,0]

# Assign the 1st column of grains: length
length = grains[:, 1]

# Scatter plot width vs length
plt.scatter(width, length)
plt.axis('equal')
plt.show()

# Calculate the Pearson correlation
correlation, pvalue = pearsonr(width, length)

# Display the correlation
print(correlation)


"""
Decorrelating the grain measurements with PCA
You observed in the previous exercise that the width 
and length measurements of the grain are correlated. Now, 
you'll use PCA to decorrelate these measurements, then plot the decorrelated points and measure their Pearson correlation.
"""

# Import PCA
from sklearn.decomposition import PCA

# Create PCA instance: model
model = PCA()

# Apply the fit_transform method of model to grains: pca_features
pca_features = model.fit_transform(grains)

# Assign 0th column of pca_features: xs
xs = pca_features[:,0]

# Assign 1st column of pca_features: ys
ys = pca_features[:,1]

# Scatter plot xs vs ys
plt.scatter(xs, ys)
plt.axis('equal')
plt.show()

# Calculate the Pearson correlation of xs and ys
correlation, pvalue = pearsonr(xs, ys)

# Display the correlation
print(correlation)

"""
The first principal component
The first principal component of the 
data is the direction in which the data varies 
the most. In this exercise, your job is to use PCA to 
find the first principal component of the length and width 
measurements of the grain samples, and represent it as an arrow on the scatter plot.

The array grains gives the length and width of the grain samples. PyPlot (plt) and PCA have already been imported for you.
"""

# Make a scatter plot of the untransformed points
plt.scatter(grains[:,0], grains[:,1])

# Create a PCA instance: model
model = PCA()

# Fit model to points
model = model.fit(grains)

# Get the mean of the grain samples: mean
mean = model.mean_

# Get the first principal component: first_pc
first_pc = model.components_[0,:]

# Plot first_pc as an arrow, starting at mean
plt.arrow(mean[0], mean[1], first_pc[0], first_pc[1], color='red', width=0.01)

# Keep axes on same scale
plt.axis('equal')
plt.show()


"""
Variance of the PCA features
The fish dataset is 6-dimensional. But what is its intrinsic
dimension? Make a plot of the variances of the PCA features to find out. 
As before, samples is a 2D array, where each row represents a fish. You'll need to standardize the features first.
"""

# Perform the necessary imports
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import make_pipeline
import matplotlib.pyplot as plt

# Create scaler: scaler
scaler = StandardScaler()

# Create a PCA instance: pca
pca = PCA()

# Create pipeline: pipeline
pipeline = make_pipeline(scaler, pca)

# Fit the pipeline to 'samples'
pipeline = pipeline.fit(samples)

# Plot the explained variances
features = range(pca.n_components_)
plt.bar(features, pca.explained_variance_)
plt.xlabel('PCA feature')
plt.ylabel('variance')
plt.xticks(features)
plt.show()

"""
A tf-idf word-frequency array
In this exercise, you'll create a tf-idf word frequency 
array for a toy collection of documents. For this, use the TfidfVectorizer
from sklearn. It transforms a list of documents into a word frequency array,
which it outputs as a csr_matrix. It has fit() and transform() methods like other sklearn objects.
You are given a list documents of toy documents about pets. Its contents have been printed in the IPython Shell.

"""
# Import PCA
from sklearn.decomposition import PCA

# Create a PCA model with 2 components: pca
pca = PCA(n_components=2)

# Fit the PCA instance to the scaled samples
pca = pca.fit(scaled_samples)

# Transform the scaled samples: pca_features
pca_features = pca.transform(scaled_samples)

# Print the shape of pca_features
print(pca_features.shape)

"""
A tf-idf word-frequency array
In this exercise, you'll create a tf-idf word
frequency array for a toy collection of documents. 
For this, use the TfidfVectorizer from sklearn. It transforms
a list of documents into a word frequency array, which it outputs as a csr_matrix. 
It has fit() and transform() methods like other sklearn objects.

You are given a list documents of toy documents about pets. Its contents have been printed in the IPython Shell.
"""

# Import TfidfVectorizer
from sklearn.feature_extraction.text import TfidfVectorizer

# Create a TfidfVectorizer: tfidf
tfidf = TfidfVectorizer()

# Apply fit_transform to document: csr_mat
csr_mat = tfidf.fit_transform(documents)

# Print result of toarray() method
print(csr_mat.toarray())

# Get the words: words
words = tfidf.get_feature_names()

# Print words
print(words)


"""
Clustering Wikipedia part I
You saw in the video that TruncatedSVD is able to perform 
PCA on sparse arrays in csr_matrix format, such as word-frequency arrays.
Combine your knowledge of TruncatedSVD and k-means to cluster some popular 
pages from Wikipedia. In this exercise, build the pipeline. In the next exercise,
you'll apply it to the word-frequency array of some Wikipedia articles.

Create a Pipeline object consisting of a TruncatedSVD followed by KMeans. (This time, 
we've precomputed the word-frequency matrix for you, so there's no need for a TfidfVectorizer).

The Wikipedia dataset you will be working with was obtained from here.
"""


# Perform the necessary imports
from sklearn.decomposition import TruncatedSVD
from sklearn.cluster import KMeans
from sklearn.pipeline import make_pipeline

# Create a TruncatedSVD instance: svd
svd = TruncatedSVD(n_components = 50)

# Create a KMeans instance: kmeans
kmeans = KMeans(n_clusters=6)

# Create a pipeline: pipeline
pipeline = make_pipeline(svd, kmeans)


"""
Clustering Wikipedia part II
It is now time to put your pipeline from the previous 
exercise to work! You are given an array articles of tf-idf
word-frequencies of some popular Wikipedia articles, and a list 
titles of their titles. Use your pipeline to cluster the Wikipedia articles.

A solution to the previous exercise has been pre-loaded for you, so a 
Pipeline pipeline chaining TruncatedSVD with KMeans is available.
"""

# Import pandas
import pandas as pd

# Fit the pipeline to articles
pipeline = pipeline.fit(articles)

# Calculate the cluster labels: labels
labels = pipeline.predict(articles)

# Create a DataFrame aligning labels and titles: df
df = pd.DataFrame({'label': labels, 'article': titles})

# Display df sorted by cluster label
print(df.sort_values("label"))
