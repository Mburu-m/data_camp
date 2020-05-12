
'Filtering for original tweets
An original tweet is an original posting by a twitter user and is not a retweet, quote, or reply.
The "-filter" can be combined with a search query to exclude retweets, quotes, and replies during tweet extraction.
In this exercise, you will extract tweets on "Superbowl" that are original posts and not retweets, quotes, or replies.
The libraries rtweet and plyr have been pre-loaded for this exercise.'


# Extract 100 original tweets on "Superbowl"
tweets_org <- search_tweets("Superbowl -filter:retweets -filter:quote -filter:replies", n = 100)

# Check for presence of replies
count(tweets_org$reply_to_screen_name)

# Check for presence of quotes
count(tweets_org$is_quote)

# Check for presence of retweets
count(tweets_org$is_retweet)



'Filtering on tweet language
You can use the language filter with a search query to filter tweets based on the language of the tweet.

The filter extracts tweets that have been classified by Twitter as being of a particular language.

Can you extract tweets posted in French on the topic "Apple iphone"?

The library rtweet has been pre-loaded for this exercise.'



# Extract tweets on "Apple iphone" in French
tweets_french <- search_tweets("Apple iphone", lang = "fr")

# View the tweets
head(tweets_french$text)

# View the tweet metadata showing the language
head(tweets_french$lang)


'Filter based on tweet popularity
Popular tweets are tweets that are retweeted and favorited several times.

They are useful in identifying current trends.
A brand can promote its merchandise and build brand loyalty by identifying popular tweets and retweeting them.
In this exercise, you will extract tweets on "Chelsea" that have been retweeted 
a minimum of 100 times and also favorited at least by 100 users.

The library rtweet has been pre-loaded for this exercise.'


# Extract tweets with a minimum of 100 retweets and 100 favorites
tweets_pop <- search_tweets("Chelsea min_faves:100 AND min_retweets:100")

# Create a data frame to check retweet and favorite counts
counts <- tweets_pop[c("retweet_count", "favorite_count")]
head(counts)

# View the tweets
head(tweets_pop$text)


'Extract user information
Analyzing twitter user data provides vital information which can 
be used to plan relevant promotional strategies.

User information contains data on the number of followers 
and friends of the twitter user.

The user information may have multiple instances of the same 
user as the user might have tweeted multiple times on a given subject. 
You need to take the mean values of the follower and friend counts in order to consider only one instance.
In this exercise, you will extract the number of friends and followers of users who tweet on #skincare or #cosmetics.
Tweets on #skincare or #cosmetics, extracted using search_tweets(), have been pre-loaded as tweet_cos.
The libraries rtweet and dplyr have also been pre-loaded.'

# Extract user information of people who have tweeted on the topic
user_cos <- users_data(tweet_cos)

# View few rows of user data
head(user_cos)

# Aggregate screen name, follower and friend counts
counts_df <- user_cos %>%
    group_by(screen_name) %>%
    summarise(follower = mean(followers_count),
              friend = mean(friends_count))

# View the output
head(counts_df)


'Explore users based on the golden ratio
The ratio of the number of followers to the number of 
friends a user has is called the golden ratio.
This ratio is a useful metric for marketers to strategize promotions.
In this exercise, you will calculate the golden ratio for the aggregated 
data frame counts_df that was created in the last step of the previous exercise.
The data frame counts_df and library dplyr have been pre-loaded for this exercise'


# Calculate and store the golden ratio
counts_df$ratio <- counts_df$follower/counts_df$friend

# Sort the data frame in decreasing order of follower count
counts_sort <- arrange(counts_df, desc(follower))

# View the first few rows
head(counts_sort)

# Select rows where the follower count is greater than 50000
counts_sort[counts_sort$follower >50000,]

# Select rows where the follower count is less than 1000
counts_sort[counts_sort$follower <1000,]


'Subscribers to twitter lists
A twitter list is a curated group of twitter accounts.

Twitter users subscribe to lists that interest them.
Collecting user information from twitter lists could help brands promote products to interested customers.

In this exercise, you will extract lists of the twitter account of "NBA", the popular basketball league National Basketball Association.

For one of the lists, you will extract the subscribed users and the user information for some of these users.

The rtweet library has been pre-loaded for this exercise.'

# Extract all the lists "NBA" subscribes to and view the first 4 columns
lst_NBA <- lists_users("NBA")
lst_NBA[,1:4]


'Trends by country name
Location-specific trends identify popular topics trending in a specific location. You can extract trends at the country level or city level.

It is more meaningful to extract trends around a specific region, in order to focus on twitter audience in that region for targeted marketing of a brand.

Can you extract topics trending in Canada and view the trends?

The library rtweet has been pre-loaded for this exercise.'

# Get topics trending in Canada
gt_country <- get_trends("Canada")


# View the first 6 columns
head(gt_country[,1:6])

'Trends by city and most tweeted trends
It is meaningful to extract trends around a specific region to focus on twitter audience in that region.

Trending topics in a city provide a chance to promote region-specific events or products.

In this exercise, you will extract topics that are trending in London and also look at the most tweeted trends.

The libraries rtweet and dplyr have been pre-loaded for this exercise.'
# Get topics trending in London
gt_city <- get_trends("London")

# View the first 6 columns
head(gt_city[,1:6])

# Aggregate the trends and tweet volumes
trend_df <- gt_city %>%
    group_by(trend) %>%
    summarise(tweet_vol = mean(tweet_volume))

# Sort data frame on descending order of tweet volumes and print header
trend_df_sort <- arrange(trend_df, desc(tweet_vol))
head(trend_df_sort,10)


'Create time series objects
A time series object contains the aggregated frequency of tweets over a specified time interval.

Creating time series objects is the first step before visualizing tweet frequencies for comparison.

In this exercise, you will be creating time series objects for the competing sportswear brands Puma and Nike.

Tweets extracted using search_tweets() for "#puma" and "#nike" have been pre-loaded for you as puma_st and nike_st.'


# Create a time series object for Puma at hourly intervals
puma_ts <- ts_data(puma_st, by ='hours')

# Rename the two columns in the time series object
names(puma_ts) <- c("time", "puma_n")

# View the output
head(puma_ts)

# Create a time series object for Nike at hourly intervals
nike_ts <- ts_data(nike_st, by ='hours')

# Rename the two columns in the time series object
names(nike_ts) <- c("time", "nike_n")

# View the output
head(nike_ts)


"Compare tweet frequencies for two brands
The volume of tweets posted for a product is a strong indicator of its brand salience.
Let's compare brand salience for two competing brands, Puma and Nike.
In the previous exercise, you had created time series objects for tweets on Puma and Nike.
You will merge the time series objects and create time series plots to compare the frequency of tweets.
The time series objects for Puma and Nike have been pre-loaded as puma_ts and nike_ts respectively.
The libraries rtweet, reshape, and ggplot2 have also been pre-"


# Merge the two time series objects and retain "time" column
merged_df <- merge(puma_ts, nike_ts, by = "time", all = TRUE)
head(merged_df)

# Stack the tweet frequency columns
melt_df <- melt(merged_df, na.rm = TRUE, id.vars = "time")

# View the output
head(melt_df)

# Plot frequency of tweets on Puma and Nike
ggplot(data = melt_df, aes(x = time, y = value, col = variable))+
    geom_line(lwd = 0.8)




