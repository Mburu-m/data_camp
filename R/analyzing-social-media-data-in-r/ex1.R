"Power of twitter data
The volume and velocity of tweets posted on twitter every second 
is an indicator of the power of twitter data.
The enormous amount of information available,
from the tweet text and its metadata, gives great 
scope for analyzing extracted tweets and deriving insights.
Let's extract a 1% random sample of live tweets using 
stream_tweets() for a 120 seconds window and save it in a data frame.
The dimensions of the data frame will give you insights
about the number of live tweets extracted and the number
of columns that contain the actual tweeted text and metadata on the tweets."

library(rtweet)
library(tidyverse)
library(data.table)
# Extract live tweets for 120 seconds window
tweets120s <- stream_tweets("", timeout = 120)
token <- create_token(
    app = "Moses Mburu",
    consumer_key = api_key,
    consumer_secret = api_secret_key, set_renv = T)

# View dimensions of the data frame with live tweets
tweets <- recover_stream("stream-20200316102140.json", token = token)

dim(tweets120s)

search_tweets("")
"Search and extract tweets
Many functions are available in R to extract 
twitter data for analysis.
search_tweets() is a powerful function from 
rtweet which is used to extract tweets based on a search query.
The function returns a maximum of 18,000 tweets for each request posted.
In this exercise, you will use search_tweets() to extract tweets on
the Emmy Awards which are American awards that recognize excellence
in the television industry, by looking for tweets containing the Emmy Awards hashtag.
The library rtweet has been pre-loaded for this exercise."


# Extract tweets on "#Emmyawards" and include retweets
twts_emmy <- search_tweets("#Emmyawards", 
                           n = 2000, 
                           include_rts = T, 
                           lang = "en")



# View output for the first 5 columns and 10 rows
head(twts_emmy[,1:5], 10)



"Search and extract timelines
Similar to search_tweets(), get_timeline() 
is another function in the rtweet library that can be used to extract tweets.
The get_timeline() function is different
from search_tweets(). It extracts tweets posted by
a given user to their timeline instead of searching based on a query.
The get_timeline() function can extract upto 3200 tweets at a time.
In this exercise, you will extract tweets posted by Cristiano Ronaldo,
a very popular soccer player both on the field and on social media who has the @Cristiano twitter handle.
The library rtweet has been pre-loaded for this exercise."


# Extract tweets posted by the user @Cristiano
get_cris <- get_timeline("@Cristiano", n = 3200)

# View output for the first 5 columns and 10 rows
head(get_cris[,1:5], 10)


'User interest and tweet counts
The metadata components of extracted twitter data can be analyzed to derive insights.
To identify twitter users who are interested in a topic, you can look at users who
tweet often on that topic. The insights derived can be used to promote targeted products to interested users.
In this exercise, you will identify users who have tweeted often on the topic "Artificial Intelligence".
Tweet data on "Artificial Intelligence", extracted using search_tweets(), has been pre-loaded as tweets_ai.
The library rtweet has been pre-loaded for this exercise.'

tweets_ai<- search_tweets("Artificial Intelligence", 
                           n = 2000, 
                           include_rts = T, 
                           lang = "en")

# Create a table of users and tweet counts for the topic
sc_name <- table(tweets_ai$screen_name)

# Sort the table in descending order of tweet counts
sc_name_sort <- sort(sc_name, decreasing = T)

# View sorted table for top 10 users
head(sc_name_sort, 10)



"Compare follower count
The follower count for a twitter account indicates 
the popularity of the personality or a business entity 
and is a measure of influence in social media.
Knowing the follower counts helps digital marketers 
strategically position ads on popular twitter accounts for increased visibility.
In this exercise, you will extract user data and compare followers 
count for twitter accounts of four popular news sites: CNN, Fox News, NBC News, and New York Times."


# Extract user data for the twitter accounts of 4 news sites
users <- lookup_users(c("nytimes", "CNN", "FoxNews", "NBCNews"))

# Create a data frame of screen names and follower counts
user_df <- users[,c("screen_name","followers_count")]

# Display and compare the follower counts for the 4 news sites
user_df

'Retweet counts
A retweet helps utilize existing content to build a following for your brand.
The number of times a twitter text is retweeted indicates what is trending.
The inputs gathered can be leveraged by promoting your brand using the popular retweets.
In this exercise, you will identify tweets on "Artificial Intelligence" that have been retweeted the most.
Tweets on "Artificial Intelligence", extracted using search_tweets(), have been saved as tweets_ai.
The rtweet and data.table libraries and the dataset tweets_ai have been pre-loaded.'


# Create a data frame of tweet text and retweet count
rtwt <- tweets_ai[,c("text", "retweet_count")]
head(rtwt)

# Sort data frame based on descending order of retweet counts
rtwt_sort <- arrange(rtwt, desc(retweet_count))

# Exclude rows with duplicate text from sorted data frame
rtwt_unique <- unique(rtwt_sort, by = "text")

# Print top 6 unique posts retweeted most number of times
rownames(rtwt_unique) <- NULL
head(rtwt_unique)




