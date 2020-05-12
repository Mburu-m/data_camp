
'Remove URLs and characters other than letters
Tweet text posted by twitter users is unstructured, noisy, and raw.

It contains emoticons, URLs, and numbers. This redundant information has to be cleaned before analysis in order to yield reliable results.

In this exercise, you will remove URLs and replace characters other than letters with spaces.

The tweet data frame twt_telmed, with 1000 extracted tweets on "telemedicine", has been pre-loaded for this exercise.

The library qdapRegex has been pre-loaded for this exercise.'

twt_txt <- twt_telmed$text
head(twt_txt)

# Remove URLs from the tweet text and view the output
twt_txt_url <- rm_twitter_url(twt_txt)
head(twt_txt_url)

# Replace special characters, punctuation, & numbers with spaces
twt_txt_chrs  <- gsub("[^A-Za-z]"," " ,twt_txt_url)

# View text after replacing special characters, punctuation, & numbers
head(twt_txt_chrs)




'Build a corpus and convert to lowercase
A corpus is a list of text documents. You have to convert the tweet
text into a corpus to facilitate subsequent steps in text processing.
When analyzing text, you want to ensure that a word is not counted as two 
different words because the case is different in the two instances. Hence, 
you need to convert text to lowercase.
In this exercise, you will create a text corpus and convert all characters to lower case.
The cleaned text output from the previous exercise has been pre-loaded as twts_gsub.
The library tm has been pre-loaded for this exercise.'



# Convert text in "twt_gsub" dataset to a text corpus and view output
twt_corpus <- twt_gsub %>% 
    VectorSource() %>% 
    Corpus() 
head(twt_corpus$content)

# Convert the corpus to lowercase
twt_corpus_lwr <- tm_map(twt_corpus, tolower) 

# View the corpus after converting to lowercase
head(twt_corpus_lwr$content)


'Remove stop words and additional spaces
The text corpus usually has many common words like a, an, the, of,
and but. These are called stop words.
Stop words are usually removed during text processing so one can
focus on the important words in the corpus to derive insights.
Also, the additional spaces created during the removal of special characters, 
punctuation, numbers, and stop words need to be removed from the corpus.
The corpus that you created in the last exercise has been pre-loaded as twt_corpus_lwr.
The library tm has been pre-loaded for this exercise.'

# Remove English stop words from the corpus and view the corpus
twt_corpus_stpwd <- tm_map(twt_corpus_lwr, removeWords, stopwords("english"))
head(twt_corpus_stpwd$content)

# Remove additional spaces from the corpus
twt_corpus_final <- tm_map(twt_corpus_stpwd, stripWhitespace)

# View the text corpus after removing spaces
head(twt_corpus_final$content)



'Removing custom stop words
Popular terms in a text corpus can be visualized 
using bar plots or word clouds.
However, it is important to remove custom stop words present in the corpus 
first before using the visualization tools.
In this exercise, you will check the term frequencies and 
remove custom stop words from the text corpus that you had created for "telemedicine".
The text corpus has been pre-loaded as twt_corpus.
The libraries qdap and tm have been pre-loaded for this exercise.'


termfreq  <-  freq_terms(twt_corpus, 60)
termfreq

# Create a vector of custom stop words
custom_stopwds <- c("telemedicine", " s", "amp", "can", "new", "medical", 
                    "will", "via", "way",  "today", "come", "t", "ways", 
                    "say", "ai", "get", "now")

# Remove custom stop words and create a refined corpus
corp_refined <- tm_map(twt_corpus,removeWords, custom_stopwds) 

# Extract term frequencies for the top 20 words
termfreq_clean <- freq_terms(corp_refined, 20)
termfreq_clean

'Visualize popular terms with bar plots
Bar plot is a simple yet popular tool used in data visualization.

It quickly helps summarize categories and their values in a visual form.

In this exercise, you will create bar plots for the popular terms appearing in a text corpus.

The refined text corpus that you created for "telemedicine" has been pre-loaded as corp_refined.

The libraries qdap and ggplot2 have been pre-loaded for this exercise.'

# Extract term frequencies for the top 10 words
termfreq_10w <- freq_terms(corp_refined, 10)
termfreq_10w

# Identify terms with more than 60 counts from the top 10 list
term60 <- subset(termfreq_10w, FREQ > 60)

# Create a bar plot using terms with more than 60 counts
ggplot(term60, aes(x = reorder(WORD, -FREQ), y = FREQ)) + 
    geom_bar(stat = "identity", fill = "red") + 
    theme(axis.text.x = element_text(angle = 15, hjust = 1))


# Extract term frequencies for the top 25 words
termfreq_25w <- freq_terms(corp_refined, 25)
termfreq_25w

# Identify terms with more than 50 counts from the top 25 list
term50 <- subset(termfreq_25w, FREQ > 50)
term50

# Create a bar plot using terms with more than 50 counts
ggplot(term50, aes(x = reorder(WORD, -FREQ), y = FREQ)) +
    geom_bar(stat = "identity", fill = "blue") + 
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

'Word clouds for visualization
A word cloud is an image made up of words in which the size of 
each word indicates its frequency.
It is an effective promotional image for marketing campaigns.
In this exercise, you will create word clouds using the words in a text corpus.
The refined text corpus that you created for "telemedicine" has been pre-loaded as corp_refined.
The libraries wordcloud and RColorBrewer have been pre-loaded for this exercise.'

# Create a word cloud in red with min frequency of 20
wordcloud(corp_refined, min.freq = 20, colors = "red", 
          scale = c(3,0.5),random.order = FALSE)


# Create word cloud with 6 colors and max 50 words
wordcloud(corp_refined, max.words = 50, 
          colors = brewer.pal(6, "Dark2"), 
          scale=c(4,1), random.order = FALSE)



'Create a document term matrix
The document term matrix or DTM is a matrix representation of a corpus.
Creating the DTM from the text corpus is the first step towards building a topic model.
Can you create a DTM from the pre-loaded corpus on "Climate change" called corpus_climate?
The library tm has been pre-loaded for this exercise.'

# Create a document term matrix (DTM) from the pre-loaded corpus
dtm_climate <- DocumentTermMatrix(corpus_climate)
dtm_climate

# Find the sum of word counts in each document
rowTotals <- apply(dtm_climate, 1, sum)
head(rowTotals)

# Select rows with a row total greater than zero
dtm_climate_new <- dtm_climate[rowTotals > 0, ]
dtm_climate_new


'Create a topic model
Topic modeling is the task of automatically discovering topics from a vast amount of text.
You can create topic models from the tweet text to quickly summarize the vast information
available into distinct topics and gain insights.
In this exercise, you will extract distinct topics from tweets on "Climate change".
The DTM of tweets on "Climate change" has been pre-loaded as dtm_climate_new.
The library topicmodels has been pre-loaded for this exercise.'

# Create a topic model with 5 topics
topicmodl_5 <- LDA(dtm_climate_new, k = 5)

# Select and view the top 10 terms in the topic model
top_10terms <- terms(topicmodl_5,10)
top_10terms 
# Create a topic model with 4 topics
topicmodl_4 <- LDA(dtm_climate_new, k = 4)

# Select and view the top 6 terms in the topic model
top_6terms <- terms(topicmodl_4, 6)
top_6terms 


"Extract sentiment scores
Sentiment analysis is useful in social media monitoring since it gives an overview of people's sentiments.
Climate change is a widely discussed topic for which the perceptions range from being a severe threat to nothing but a hoax.
In this exercise, you will perform sentiment analysis and extract the sentiment scores for tweets on Climate change.
You will use those sentiment scores in the next exercise to plot and analyze how the collective sentiment varies among people.
Tweets on Climate change, extracted using search_tweets(), have been pre-loaded as tweets_cc.
The library syuzhet has been pre-loaded for this exercise."


# Perform sentiment analysis for tweets on `Climate change` 
sa.value <- get_nrc_sentiment(tweets_cc$text)

# View the sentiment scores
head(sa.value, 10)


'Perform sentiment analysis
You have extracted the sentiment scores for tweets on "Climate change" in the previous exercise.
Can you plot and analyze the most prevalent sentiments among people and see how the collective sentiment varies?
The data frame with the extracted sentiment scores has been pre-loaded as sa.value.
The library ggplot2 has been pre-loaded for this exercise.'

# Calculate sum of sentiment scores
score <- colSums(sa.value[,])

# Convert the sum of scores to a data frame
score_df <- data.frame(score)

# Convert row names into 'sentiment' column and combine with sentiment scores
score_df2 <- cbind(sentiment = row.names(score_df),  
                   score_df, row.names = NULL)
print(score_df2)

# Plot the sentiment scores
ggplot(data = score_df2, aes(x = sentiment, y = score, fill = sentiment)) +
    geom_bar(stat = "identity") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))








