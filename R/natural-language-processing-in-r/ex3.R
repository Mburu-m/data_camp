'Data preparation
During the 2016 US election, Russian tweet bots were
used to constantly distribute political rhetoric to both
democrats and republicans. You have been given a dataset of 
such tweets called russian_tweets. You have decided to classify these tweets
as either left- (democrat) or right-leaning(republican). 
Before you can build a classification model, you need to clean and prepare the text for modeling.'

library(tidyverse)
library(tidytext)
library(SnowballC)
library(tm)
library(widyr)
library(randomForest)
# Stem the tokens
russian_tweets <- read_csv("russian_1.csv")
russian_tokens <- russian_tweets %>%
    unnest_tokens(output = "word", token = "words", input = content) %>%
    anti_join(stop_words) %>%
    mutate(word = wordStem(word))

# Create a document term matrix using TFIDF weighting
tweet_matrix <- russian_tokens %>%
    count(tweet_id, word) %>%
    cast_dtm(document = tweet_id, term = word,
             value = n, weighting = tm::weightTfIdf)

# Print the matrix details 
print(tweet_matrix)

#removing sparse terms

less_sparse_matrix <-
    removeSparseTerms(tweet_matrix , sparse =.9999)

# Print results
tweet_matrix
less_sparse_matrix


'Classification modeling example
You have previously prepared a set of Russian 
tweets for classification. Of the 20,000 tweets,
you have filtered to tweets with an account_type of Left or Right, 
and selected the first 2000 tweets of each. You have already tokenized
the tweets into words, removed stop words, and performed stemming. 
Furthermore, you converted word counts into a document-term matrix with TFIDF 
values for weights and saved this matrix as: left_right_matrix_small.

You will use this matrix to predict whether a tweet was generated 
from a left-leaning tweet bot, or a right-leaning tweet bot. 
The labels can be found in the vector, left_right_labels.'

nrow(less_sparse_matrix)
library(randomForest)

# Create train/test split
set.seed(1111)
sample_size <- floor(.75 * nrow(less_sparse_matrix))
train_ind <- sample(nrow(less_sparse_matrix), size = sample_size)
train <- less_sparse_matrix[train_ind, ]
test <- less_sparse_matrix[-train_ind, ]

# Create a random forest classifier
x_train <-  as.data.frame(as.matrix(train))
left_right_labels <-russian_tweets$account_type
left_right_labels <- facto
y_train <- left_right_labels[train_ind]

rfc <- randomForest(x =x_train, 
                    y = y_train,
                    nTree = 50, )
# Print the results
rfc 

'Confusion matrices
You have just finished creating a classification model. 
This model predicts whether tweets were created by a 
left-leaning (democrat) or right-leaning (republican) tweet bot.
You have made predictions on the test data and have the following result:

Predictions	Left	Right
Left	350	157
Right	57	436
Use the confusion matrix above to answer questions about the models accuracy.'


# Percentage correctly labeled "Left"
left <- (350) / (350 + 157)
left

# Percentage correctly labeled "Right"
right <- (436) / (57 + 436)
right

# Overall Accuracy:
accuracy <- (350 +  436) / (350 + 157 + 57 + 436)
accuracy



'LDA practice
You are interested in the common themes surrounding the character
Napoleon in your favorite new book, Animal Farm. Napoleon is a Pig 
who convinces his fellow comrades to overthrow their human leaders. 
He also eventually becomes the new leader of Animal Farm.

You have extracted all of the sentences that mention Napoleons name,
pig_sentences, and created tokenized version of these sentences with 
stop words removed and stemming completed, pig_tokens. Complete LDA on t
hese sentences and review the top words associated with some of the topics.'



library(topicmodels)
# Perform Topic Modeling
sentence_lda <-
    LDA(pig_matrix, k = 10, method = 'Gibbs', control = list(seed = 1111))
# Extract the beta matrix 
sentence_betas <- tidy(sentence_lda, matrix = "beta")

# Topic #2
sentence_betas %>%
    filter(topic == 2) %>%
    arrange(-beta)
# Topic #3
sentence_betas %>%
    filter(topic ==  3) %>%
    arrange(-beta)


"Assigning topics to documents
Creating LDA models are useless unless you can
interpret and use the results. You have been given the
results of running an LDA model, sentence_lda on a set
of sentences, pig_sentences. You need to explore both the beta,
top words by topic, and the gamma, top topics per document, 
matrices to fully understand the results of any LDA analysis.

Given what you know about these two matrices, extract the 
results for a specific topic and see if the output matches expectations."

# Extract the beta and gamma matrices
sentence_betas <- tidy(sentence_lda, matrix = "beta")
sentence_gammas <- tidy(sentence_lda, matrix = "gamma")

# Explore Topic 5 Betas
sentence_betas %>%
    filter(topic == 5) %>%
    arrange(-beta)

# Explore Topic 5 Gammas
sentence_gammas %>%
    filter(topic == 5) %>%
    arrange(-gamma)




"Testing perplexity
You have been given a dataset full of tweets that were sent
by tweet bots during the 2016 US election. Your boss has identified two
different account types of interest, Left and Right. Your boss has asked you
to perform topic modeling on the tweets from Right tweet bots. Furthermore,
your boss is hoping to summarize the content of these tweets with topic modeling.
Perform topic modeling on 5, 15, and 50 topics to determine a general idea of how 
many topics are contained in the data."


library(topicmodels)
# Setup train and test data
sample_size <- floor(0.90 * nrow(right_matrix))
set.seed(1111)
train_ind <- sample(nrow(right_matrix), size = sample_size)
train <- right_matrix[train_ind, ]
test <- right_matrix[-train_ind, ]

# Peform topic modeling 
lda_model <- LDA(train, k = 50, method = "Gibbs",
                 control = list(seed = 1111))
# Train
perplexity(lda_model, newdata = train) 
# Test
perplexity(lda_model, newdata = test) 

"Reviewing LDA results
You have developed a topic model, napoleon_model,
with 5 topics for the sentences from the book Animal Farm
that reference the main character Napoleon. You have had 5 local 
authors review the top words and top sentences for each topic and
they have provided you with themes for each topic.
To finalize your results, prepare some summary statistics about the topics.
You will present these summary values along with the themes to your boss for review."


# Extract the gamma matrix 
gamma_values <- tidy(napoleon_model, matrix = "gamma")
# Create grouped gamma tibble
grouped_gammas <- gamma_values %>%
    group_by(document) %>%
    arrange(desc(gamma)) %>%
    slice(1) %>%
    group_by(topic)
# Count (tally) by topic
grouped_gammas %>% 
    tally(topic, sort=TRUE)
# Average topic weight for top topic for each sentence
grouped_gammas %>% 
    summarise(avg=mean(gamma)) %>%
    arrange(desc(avg))