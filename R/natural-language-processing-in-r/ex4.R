"tidytext lexicons
Before you begin applying sentiment analysis to text, 
it is essential that you understand the lexicons being
used to aid in your analysis. Each lexicon has advantages 
when used in the right context. Before running any analysis,
you must decide which type of sentiment you are hoping to extract from the text available.
In this exercise, you will explore the three different lexicons offered by tidytext's sentiments' datasets."

# Print the lexicon
get_sentiments("bing")

# Count the different sentiment types
get_sentiments("bing") %>%
    count(sentiment) %>%
    arrange(desc(n))


# Print the lexicon
get_sentiments("nrc")

# Count the different sentiment types
get_sentiments("nrc") %>%
    count(sentiment) %>%
    arrange(desc(n))



get_sentiments("afinn")

# Count how many times each score was used
get_sentiments("afinn") %>%
    count(score) %>%
    arrange(desc(n))


'Sentiment scores
In the book Animal Farm, three main pigs are responsible for the
events of the book: Napoleon, Snowball, and Squealer. Throughout the
book they are spreading thoughts of rebellion and encouraging the other
animals to take over the farm from Mr. Jones - the owner of the farm.

Using the sentences that mention each pig, determine which character 
has the most negative sentiment associated with them. The sentences 
tibble contains a tibble of the sentences from the book Animal Farm.'

# Print the overall sentiment associated with each pig's sentences
for(name in c("napoleon", "snowball", "squealer")) {
    # Filter to the sentences mentioning the pig
    pig_sentences <- sentences[grepl(name, sentences$sentence), ]
    # Tokenize the text
    napoleon_tokens <- pig_sentences %>%
        unnest_tokens(output = "word", token = "words", input = sentence) %>%
        anti_join(stop_words)
    # Use afinn to find the overall sentiment score
    result <- napoleon_tokens %>% 
        inner_join(get_sentiments("afinn")) %>%
        summarise(sentiment = sum(score))
    # Print the result
    print(paste0(name, ": ", result$sentiment))
}


"Sentiment and emotion
Within the sentiments dataset, the lexicon nrc contains a
dictionary of words and an emotion associated with that word. 
Emotions such as joy, trust, anticipation, and others are found within this dataset.
In the Russian tweet bot dataset you have been exploring, you have looked at 
tweets sent out by both a left- and a right-leaning tweet bot. Explore the contents 
of the tweets sent by the left-leaning (democratic) tweet bot by using the nrc lexicon.
The left tweets, left, have been tokenized into words, with stop-words removed."


left_tokens <- left %>%
    unnest_tokens(output = "word", token = "words", input = content) %>%
    anti_join(stop_words)
# Dictionaries 
anticipation <- get_sentiments("nrc") %>% 
    filter(sentiment == "anticipation")
joy <- get_sentiments("nrc") %>% 
    filter(sentiment == "joy")
# Print top words for Anticipation and Joy
left_tokens %>%
    inner_join(anticipation, by = "word") %>%
    count(word, sort = TRUE)
left_tokens %>%
    inner_join(joy, by = "word") %>%
    count(word, sort = TRUE)


"h2o practice
There are several machine learning libraries
available in R. However, the h2o library is easy 
to use and offers a word2vec implementation. h2o can
also be used for several other machine learning tasks. 
In order to use the h2o library however, you need to take additional 
pre-processing steps with your data. You have a dataset called left_right
which contains tweets that were auto-tweeted during the 2016 US election campaign.
Instead of preparing your data for other text analysis techniques, prepare this dataset for use with the h2o library."

# Initialize an h2o session
library(h2o)
h2o.init()

# Create an h2o object for left_right
h2o_object = as.h2o(left_right)

# Tokenize the words from the column of text in left_right
tweet_words <-  h2o.tokenize(h2o_object$content, "\\\\W+")

# Lowercase
tweet_words <- h2o.tolower(tweet_words)
# Remove stopwords from tweet_words
tweet_words <- tweet_words[is.na(tweet_words) || (!tweet_words %in% stop_words$word),]


"word2vec
You have been web-scrapping a lot of job titles 
from the internet and are unsure if you need to scrap additional 
job titles for your analysis. So far, you have collected over 13,000 
job titles in a dataset called job_titles. You have read that word2vec 
generally performs best if the model has enough data to properly train,
and if words are not mentioned enough in your data, the model might not be useful.

In this exercise you will test how helpful additional data is by 
running your model 3 times; each run will use additional data."



library(h2o)
h2o.init()

set.seed(1111)
# Use 33% of the available data
sample_size <- floor(.33 * nrow(job_titles))
sample_data <- sample(nrow(job_titles), size = sample_size)

h2o_object = as.h2o(job_titles[sample_data, ])
words <- h2o.tokenize(h2o_object$jobtitle, "\\\\W+")
words <- h2o.tolower(words)
words = words[is.na(words) || (!words %in% stop_words$word),]

word2vec_model <- h2o.word2vec(words, min_word_freq=5, epochs = 10)
# Find synonyms for the word "teacher"
h2o.findSynonyms(word2vec_model, "teacher", count=10)


library(h2o)
h2o.init()

set.seed(1111)
# Use 66% of the available data
sample_size <- floor(.66 * nrow(job_titles))
sample_data <- sample(nrow(job_titles), size = sample_size)

h2o_object = as.h2o(job_titles[sample_data, ])
words <- h2o.tokenize(h2o_object$jobtitle, "\\\\W+")
words <- h2o.tolower(words)
words = words[is.na(words) || (!words %in% stop_words$word),]

word2vec_model <- h2o.word2vec(words, min_word_freq=5, epochs = 10)
# Find synonyms for the word "teacher"
h2o.findSynonyms(word2vec_model, "teacher", count=10)


library(h2o)
h2o.init()

set.seed(1111)
# Use all of the available data
sample_size <- floor(1 * nrow(job_titles))
sample_data <- sample(nrow(job_titles), size = sample_size)

h2o_object = as.h2o(job_titles[sample_data, ])
words <- h2o.tokenize(h2o_object$jobtitle, "\\\\W+")
words <- h2o.tolower(words)
words = words[is.na(words) || (!words %in% stop_words$word),]

word2vec_model <- h2o.word2vec(words, min_word_freq=5, epochs = 10)
# Find synonyms for the word "teacher"
h2o.findSynonyms(word2vec_model, "teacher", count=10)


"Reviewing methods #1
Text analysis is full of methods, models, and techniques that can be used to better understand text. In this exercise, you will review some of these methods.

a: Labels each word within text as either a noun, verb, adjective, or other category.
b: A model pre-trained on a vast amount of text data to create a language representation used for supervised learning.
c: A type of analysis that looks to describe text as either positive or negative and can be used to find active vs passive terms.
d: A modeling technique used to label entire text into a single category such as relevant or not-relevant.

"
# Sentiment Analysis
SA <- c

# Classifcation Modeling
CM <- d

# BERT
BERT <- b

# Part-of-speech Tagging
POS <- a

"
Review methods #2
In this exercise, you will review four additional methods.

e: Modeling techniques, including LDA, used to cluster text into groups or types based on similar words being used.
f: A method for searching through text and tagging words that distinguish people, locations, or organizations.
g: Method used to search text for specific patterns.
h: Representing words using a large vector space where similar words are close together within t"l
