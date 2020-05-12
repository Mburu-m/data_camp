# Load igraph
library(igraph)

friends <- data.frame(name1 = c("Jessie", "Jessie", "Sidney", "Sidney", "Karl", "Sidney"),
           name2 = c("Sidney", "Britt", "Britt", "Donie", "Berry", "Rene"))

# Inspect the first few rows of the dataframe 'friends'
head(friends)

# Convert friends dataframe to a matrix
friends.mat <- as.matrix(friends)

# Convert friends matrix to an igraph object
g <- graph.edgelist(friends.mat, directed = FALSE)


# Make a very basic plot of the network
plot(g)

# Load igraph
library(igraph)

# Subset vertices and edges
V(g)
E(g)

# Count number of edges
gsize(g)

# Count number of vertices
gorder(g)

