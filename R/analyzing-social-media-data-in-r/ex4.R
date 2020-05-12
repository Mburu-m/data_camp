'Preparing data for a retweet network
A retweet network is a network of twitter users who retweet tweets posted by other users.
People who retweet on travel can be potential players for broadcasting messages of a travel portal.
In this exercise, you will prepare the tweet data on #travel for creating a retweet network.
The tweet data frame has been pre-loaded as twts_travel.'

# Extract source vertex and target vertex from the tweet data frame
rtwt_df <- twts_trvl[, c("screen_name" , "retweet_screen_name" )]

# View the data frame
head(rtwt_df)

# Remove rows with missing values
rtwt_df_new <- rtwt_df[complete.cases(rtwt_df), ]

# Create a matrix
rtwt_matrx <- as.matrix(rtwt_df_new)
head(rtwt_matrx)

'Create a retweet network
The core step in network analysis is to create a network object like a 
retweet network as it helps analyze the inter-relationships between the nodes.
Understanding the position of potential customers on a retweet network
allows a brand to identify key players who are likely to retweet posts to spread brand messaging.
Can you create a retweet network on #travel using the matrix saved in the previous exercise?
The matrix rtwt_matrx and the library igraph have been pre-loaded for this exercise'






# Convert the matrix to a retweet network
nw_rtweet <- graph_from_edgelist(el = rtwt_matrx, directed = TRUE)

# View the retweet network
print.igraph(nw_rtweet)


'Calculate out-degree scores
In a retweet network, the out-degree of a user indicates the number of times the user retweets posts.
Users with high out-degree scores are key players who can be used as a medium to retweet promotional posts.
Can you identify users who can be used as a medium to retweet promotional posts for a travel portal?
The retweet network on #travel has been pre-loaded as nw_rtweet.
The library igraph has been pre-loaded for this exercise.'

#out degree users who retweeted most
# Calculate out-degree scores from the retweet network
out_degree <- degree(nw_rtweet, mode = c("out"))

# Sort the out-degree scores in decreasing order
out_degree_sort <- sort(out_degree, decreasing = T)

# View users with the top 10 out-degree scores
out_degree_sort[1:10]

#

"Compute the in-degree scores
In a retweet network, the in-degree of a user indicates the number of times the user's posts are retweeted.
Users with high in-degrees are influential as their tweets are retweeted many times.
In this exercise, you will identify users who can be used to initiate branding messages of a travel portal.
The retweet network on #travel has been pre-loaded as nw_rtweet.
The library igraph has been pre-loaded for this exercise."


# Compute the in-degree scores from the retweet network
in_degree <- degree(nw_rtweet, mode = c("in"))

# Sort the in-degree scores in decreasing order
in_degree_sort <- sort(in_degree, decreasing = T)

# View users with the top 10 in-degree scores
in_degree_sort[1:10]


'Calculate the betweenness scores
Betweenness centrality represents the degree to which nodes stand between each other.
In a retweet network, a user with a high betweenness centrality score would have more 
control over the network because more information will pass through the user.
Can you identify users who are central to people who retweet the most and those
whose tweets are retweeted frequently?
The retweet network on #travel has been pre-loaded as nw_rtweet.
The library igraph has been pre-loaded for this exercise.'

# Calculate the betweenness scores from the retweet network
betwn_nw <- betweenness(nw_rtweet, directed = T)

# Sort betweenness scores in decreasing order and round the values
betwn_nw_sort <- betwn_nw %>%
    sort(decreasing = T) %>%
    round()

# View users with the top 10 betweenness scores 
betwn_nw_sort[1:10]


"Create a network plot with attributes
Visualization of twitter networks helps understand complex networks in an easier and appealing way.
You can format a plot to enhance the readability and improve its visual appeal.
In this exercise, you will visualize a retweet network on #travel.
The retweet network has been pre-loaded as nw_rtweet.
The library igraph has been pre-loaded for this exercise."


# Create a basic network plot
plot.igraph(nw_rtweet)

# Create a network plot with formatting attributes
set.seed(1234)
plot(nw_rtweet, asp = 9/12, 
     vertex.size = 10,
     vertex.color = "green", 
     edge.arrow.size = 0.5,
     edge.color = "black",
     vertex.label.cex = 0.9,
     vertex.label.color = "black")


"Network plot based on centrality measure
It will be more meaningful if the vertex size in the plot is proportional to the number of times the user retweets.
In this exercise, you will add attributes such that the vertex size is indicative of the number of times the user retweets.
The retweet network has been pre-loaded as nw_rtweet.
The library igraph has been pre-loaded for this exercise."

deg_out

# Amplify the out-degree values
vert_size <- (deg_out * 3) + 5

# Set vertex size to amplified out-degree values
set.seed(1234)
plot(nw_rtweet, asp = 10/11, 
     vertex.size  = vert_size, vertex.color = "lightblue",
     edge.arrow.size = 0.5,
     edge.color = "grey",
     vertex.label.cex = 0.8,
     vertex.label.color = "black")


'Follower count to enhance the network plot
The users who retweet most will add more value if they have a high follower
count as their retweets will reach a wider audience.
In a network plot, the combination of vertex size indicating the number of 
retweets by a user and vertex color indicating a high follower count provides
clear insights on the most influential users who can promote a brand.
In this exercise, you will create a plot showing the most influential users.
The retweet network nw_rtweet, the dataset followers with the follower count, 
and vert_size created in the last exercise have all been pre-loaded.
The library igraph has been pre-loaded for this exercise.'


# Create a column and categorize follower counts above and below 500
followers$follow <- ifelse(followers$followers_count > 500, "1", "0")
head(followers)

# Assign the new column as vertex attribute to the retweet network
V(nw_rtweet)$followers <- followers$follow
vertex_attr(nw_rtweet)

# Set the vertex colors based on follower count and create a plot
sub_color <- c("lightgreen", "tomato")
plot(nw_rtweet, asp = 9/12,
     vertex.size = vert_size, edge.arrow.size = 0.5,
     vertex.label.cex = 0.8,
     vertex.color = sub_color[as.factor(vertex_attr(nw_rtweet, "followers"))],
     vertex.label.color = "black", vertex.frame.color = "grey")


'Extract geolocation coordinates
Analyzing the geolocation of tweets helps influence customers with targeted marketing.
The first step in analyzing geolocation data using maps is to extract the available geolocation coordinates.
Veganism is a widely promoted topic. It is the practice of abstaining from the use of animal products and its followers are known as "vegans".
In this exercise, you will extract the geolocation coordinates from tweets on "#vegan".
The library rtweet has been pre-loaded for this exercise.'


# Extract 18000 tweets on #vegan
vegan <- search_tweets("#vegan", n = 18000)

# Extract geo-coordinates data to append as new columns
vegan_coord <- lat_lng(vegan)

# View the columns with geo-coordinates for first 20 tweets
head(vegan_coord[c("lat","lng")], 20)



'Twitter data on the map
It will be interesting to visualize tweets on "#vegan" on the map to 
see regions from where they are tweeted the most. A brand promoting vegan 
products can target people in these regions for their marketing.
Remember not all tweets will have the geolocation data as this is an optional input for the users.
The geolocation coordinates that you had extracted in the last exercise has been pre-loaded as vegan_coord.

The library maps has also been pre-loaded for this exercise.'
# Omit rows with missing geo-coordinates in the data frame
vegan_geo <- na.omit(vegan_coord[,c("lat", "lng")])

# View the output
head(vegan_geo)

# Plot longitude and latitude values of tweets on the US state map
map(database = "state", fill = TRUE, col = "light yellow")
with(vegan_geo, points(lng, lat, pch = 20, cex = 1, col = 'blue'))

# Plot longitude and latitude values of tweets on the world map
map(database = "world", fill = TRUE, col = "light yellow")
with(vegan_geo, points(lng, lat, pch = 20, cex = 1, col = 'blue')) 



