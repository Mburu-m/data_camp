Natural Language Processing
================
Mburu
4/7/2020

## Practicing syntax with grep

You have just completed an ice-breaker exercise at work and you recorded
10 facts about your boss. You saved these 10 facts into a vector named
text. Using regular expressions, you want to summarize your bosses’
responses. A few notes on regular expressions in R: When using grep(),
setting value = TRUE will print the text instead of the indices. You can
combine patterns such as a digit, ‘\\d’, followed by a period ‘\\.,
with’\\d\\.’ Spaces can be found using ‘\\s’. You can search for a
word by simply using the word as your pattern. pattern = ‘word’

``` r
library(tidyverse)
library(tidytext)
library(SnowballC)
library(tm)
library(widyr)
library(knitr)

# Print off each item that contained a numeric number
text <- c("John's favorite color two colors are blue and red.",
          "John's favorite number is 1111.",
          "John lives at P Sherman, 42 Wallaby Way, Sydney", 
          "He is 7 feet tall", "John has visited 30 countries",
          "John only has nine fingers.", "John has worked at eleven different jobs",
          "He can speak 3 languages", "john's favorite food is pizza", 
          "John can name 10 facts about himself.")



grep(pattern ="\\d", x = text, value = TRUE)
```

    ## [1] "John's favorite number is 1111."                
    ## [2] "John lives at P Sherman, 42 Wallaby Way, Sydney"
    ## [3] "He is 7 feet tall"                              
    ## [4] "John has visited 30 countries"                  
    ## [5] "He can speak 3 languages"                       
    ## [6] "John can name 10 facts about himself."

``` r
# Find all items with a number followed by a space
grep(pattern = "\\d\\s", x = text)
```

    ## [1]  3  4  5  8 10

``` r
# How many times did you write down 'favorite'?
length(grep(pattern ='favorite', x = text))
```

    ## [1] 3

## Exploring regular expression functions.

You have a vector of ten facts about your boss saved as a vector called
text. In order to create a new ice-breaker for your team at work, you
need to remove the name of your boss, John, from each fact that you have
written down. This can easily be done using regular expressions (as well
as other search/replace functions). Use regular expressions to correctly
replace “John” from the facts you have written about him.’

``` r
# Print off the text for every time you used your boss's name, John
grep('John', x = text, value = TRUE)
```

    ## [1] "John's favorite color two colors are blue and red."
    ## [2] "John's favorite number is 1111."                   
    ## [3] "John lives at P Sherman, 42 Wallaby Way, Sydney"   
    ## [4] "John has visited 30 countries"                     
    ## [5] "John only has nine fingers."                       
    ## [6] "John has worked at eleven different jobs"          
    ## [7] "John can name 10 facts about himself."

``` r
# Try replacing all occurences of "John" with "He"
gsub(pattern = 'John', replacement = 'He', x = text)
```

    ##  [1] "He's favorite color two colors are blue and red."
    ##  [2] "He's favorite number is 1111."                   
    ##  [3] "He lives at P Sherman, 42 Wallaby Way, Sydney"   
    ##  [4] "He is 7 feet tall"                               
    ##  [5] "He has visited 30 countries"                     
    ##  [6] "He only has nine fingers."                       
    ##  [7] "He has worked at eleven different jobs"          
    ##  [8] "He can speak 3 languages"                        
    ##  [9] "john's favorite food is pizza"                   
    ## [10] "He can name 10 facts about himself."

``` r
# Replace all occurences of "John " with 'He '.
clean_text <- gsub(pattern = 'John\\s', replacement = 'He ', x = text)
clean_text
```

    ##  [1] "John's favorite color two colors are blue and red."
    ##  [2] "John's favorite number is 1111."                   
    ##  [3] "He lives at P Sherman, 42 Wallaby Way, Sydney"     
    ##  [4] "He is 7 feet tall"                                 
    ##  [5] "He has visited 30 countries"                       
    ##  [6] "He only has nine fingers."                         
    ##  [7] "He has worked at eleven different jobs"            
    ##  [8] "He can speak 3 languages"                          
    ##  [9] "john's favorite food is pizza"                     
    ## [10] "He can name 10 facts about himself."

``` r
# Replace all occurences of "John's" with 'His'
gsub(pattern = "John\\'s", replacement = 'His', x = clean_text)
```

    ##  [1] "His favorite color two colors are blue and red."
    ##  [2] "His favorite number is 1111."                   
    ##  [3] "He lives at P Sherman, 42 Wallaby Way, Sydney"  
    ##  [4] "He is 7 feet tall"                              
    ##  [5] "He has visited 30 countries"                    
    ##  [6] "He only has nine fingers."                      
    ##  [7] "He has worked at eleven different jobs"         
    ##  [8] "He can speak 3 languages"                       
    ##  [9] "john's favorite food is pizza"                  
    ## [10] "He can name 10 facts about himself."

## Text preprocessing: remove stop words

Stop words are unavoidable in writing. However, to determine how similar
two pieces of text are to each other are or when trying to find themes
within text, stop words can make things difficult. In the book Animal
Farm, the first chapter contains only 2,636 words, while almost 200 of
them are the word ‘the’

Usually, ‘the’ will not help us in text analysis projects. In this
exercise you will remove the stop words from the first chapter of Animal
Farm. Tokenization: sentences Animal Farm is a popular book for middle
school English teachers to assign to their students. You have decided to
do some exploration on the text and provide summary statistics for
teachers to use when assigning this book to their students. You already
know that there are 10 chapters, but you also know that you can use
tokenization to help count the number of sentences, words, and even
paragraphs. In this exercise, you will use the tokenization techniques
learned in the video to help split Animal Farm into sentences and count
them by chapter. "

``` r
animal_farm <- read_csv("animal_farm.csv")

# Split the text_column into sentences
animal_farm %>%
    unnest_tokens(output = "sentences",
                  input = text_column,
                  token = "sentences") %>%
    # Count sentences, per chapter
    count(chapter) %>%
    kable()
```

| chapter    |   n |
| :--------- | --: |
| Chapter 1  | 136 |
| Chapter 10 | 167 |
| Chapter 2  | 140 |
| Chapter 3  | 114 |
| Chapter 4  |  84 |
| Chapter 5  | 158 |
| Chapter 6  | 136 |
| Chapter 7  | 190 |
| Chapter 8  | 203 |
| Chapter 9  | 195 |

``` r
# Split the text_column using regular expressions

animal_farm %>%
    unnest_tokens(output = "sentences", input = text_column,
                  token = "regex", pattern = "\\.") %>%
    count(chapter) %>%
    kable()
```

| chapter    |   n |
| :--------- | --: |
| Chapter 1  | 131 |
| Chapter 10 | 179 |
| Chapter 2  | 150 |
| Chapter 3  | 113 |
| Chapter 4  |  92 |
| Chapter 5  | 158 |
| Chapter 6  | 127 |
| Chapter 7  | 188 |
| Chapter 8  | 200 |
| Chapter 9  | 174 |

## Text preprocessing: remove stop words

Stop words are unavoidable in writing. However, to determine how similar
two pieces of text are to each other are or when trying to find themes
within text, stop words can make things difficult. In the book Animal
Farm, the first chapter contains only 2,636 words, while almost 200 of
them are the word ‘the’.

Usually, ‘the’ will not help us in text analysis projects. In this
exercise you will remove the stop words from the first chapter of Animal
Farm."

``` r
# Tokenize animal farm's text_column column
tidy_animal_farm <- animal_farm %>%
  unnest_tokens(word, text_column) 

# Print the word frequencies
tidy_animal_farm %>%
  count(word, sort = TRUE) %>%
    head() %>%
    kable()
```

| word |    n |
| :--- | ---: |
| the  | 2187 |
| and  |  966 |
| of   |  899 |
| to   |  814 |
| was  |  633 |
| a    |  620 |

``` r
# Remove stop words, using stop_words from tidytext
tidy_animal_farm %>%
  anti_join(stop_words) %>%
    head() %>%
    kable()
```

| chapter   | word   |
| :-------- | :----- |
| Chapter 1 | jones  |
| Chapter 1 | manor  |
| Chapter 1 | farm   |
| Chapter 1 | locked |
| Chapter 1 | hen    |
| Chapter 1 | houses |

## Text preprocessing: Stemming

The root of words are often more important than their endings,
especially when it comes to text analysis. The book Animal Farm is
obviously about animals. However, knowing that the book mentions animals
248 times, and animal 107 times might not be helpful for your analysis.
tidy\_animal\_farm contains a tibble of the words from Animal Farm,
tokenized and without stop words. The next step is to stem the words and
explore the results.

``` r
library(SnowballC)
# Perform stemming on tidy_animal_farm
stemmed_animal_farm <- tidy_animal_farm %>%
    mutate(word = wordStem(word))

# Print the old word frequencies 
tidy_animal_farm %>%
    count(word, sort = T)
```

    ## # A tibble: 4,076 x 2
    ##    word      n
    ##    <chr> <int>
    ##  1 the    2187
    ##  2 and     966
    ##  3 of      899
    ##  4 to      814
    ##  5 was     633
    ##  6 a       620
    ##  7 in      537
    ##  8 had     529
    ##  9 that    451
    ## 10 it      384
    ## # ... with 4,066 more rows

``` r
# Print the new word frequencies
stemmed_animal_farm %>%
    count(word, sort = T)
```

    ## # A tibble: 3,095 x 2
    ##    word      n
    ##    <chr> <int>
    ##  1 the    2187
    ##  2 and     966
    ##  3 of      899
    ##  4 to      814
    ##  5 a       804
    ##  6 wa      633
    ##  7 in      537
    ##  8 had     529
    ##  9 that    451
    ## 10 it      405
    ## # ... with 3,085 more rows

## Explore an R corpus

One of your coworkers has prepared a corpus of 20 documents discussing
crude oil, named crude. This is only a sample of several thousand
articles you will receive next week. In order to get ready for running
text analysis on these documents, you have decided to explore their
content and metadata. Remember that in R, a VCorpus contains both meta
and content regarding each text. In this lesson, you will explore these
two objects.’

``` r
# Print out the corpus
data(crude)


# Print the content of the 10th article
crude[[10]]$content
```

    ## [1] "Saudi Arabian Oil Minister Hisham Nazer\nreiterated the kingdom's commitment to last December's OPEC\naccord to boost world oil prices and stabilise the market, the\nofficial Saudi Press Agency SPA said.\n    Asked by the agency about the recent fall in free market\noil prices, Nazer said Saudi Arabia \"is fully adhering by the\n... Accord and it will never sell its oil at prices below the\npronounced prices under any circumstance.\"\n    Nazer, quoted by SPA, said recent pressure on free market\nprices \"may be because of the end of the (northern hemisphere)\nwinter season and the glut in the market.\"\n    Saudi Arabia was a main architect of the December accord,\nunder which OPEC agreed to lower its total output ceiling by\n7.25 pct to 15.8 mln barrels per day (bpd) and return to fixed\nprices of around 18 dlrs a barrel.\n    The agreement followed a year of turmoil on oil markets,\nwhich saw prices slump briefly to under 10 dlrs a barrel in\nmid-1986 from about 30 dlrs in late 1985. Free market prices\nare currently just over 16 dlrs.\n    Nazer was quoted by the SPA as saying Saudi Arabia's\nadherence to the accord was shown clearly in the oil market.\n    He said contacts among members of OPEC showed they all\nwanted to stick to the accord.\n    In Jamaica, OPEC President Rilwanu Lukman, who is also\nNigerian Oil Minister, said the group planned to stick with the\npricing agreement.\n    \"We are aware of the negative forces trying to manipulate\nthe operations of the market, but we are satisfied that the\nfundamentals exist for stable market conditions,\" he said.\n    Kuwait's Oil Minister, Sheikh Ali al-Khalifa al-Sabah, said\nin remarks published in the emirate's daily Al-Qabas there were\nno plans for an emergency OPEC meeting to review prices.\n    Traders and analysts in international oil markets estimate\nOPEC is producing up to one mln bpd above the 15.8 mln ceiling.\n    They named Kuwait and the United Arab Emirates, along with\nthe much smaller producer Ecuador, among those producing above\nquota. Sheikh Ali denied that Kuwait was over-producing.\n REUTER"

``` r
# Find the first ID
crude[[1]]$meta$id
```

    ## [1] "127"

``` r
# Make a vector of IDs
ids <- c()
for(i in c(1:20)){
    ids <- append(ids, crude[[i]]$meta$id)
}
```

## Creating a tibble from a corpus

To further explore the corpus on crude oil data that you received from a
coworker, you have decided to create a pipeline to clean the text
contained in the documents. Instead of exploring how to do this with the
tm package, you have decided to transform the corpus into a tibble so
you can use the functions unnest\_tokens(), count(), and anti\_join()
that you are already familiar with. The corpus crude contains both the
metadata and the text of each document.

``` r
# Create a tibble & Review
crude_tibble <- tidy(crude)
names(crude_tibble)
```

    ##  [1] "author"        "datetimestamp" "description"   "heading"      
    ##  [5] "id"            "language"      "origin"        "topics"       
    ##  [9] "lewissplit"    "cgisplit"      "oldid"         "places"       
    ## [13] "people"        "orgs"          "exchanges"     "text"

``` r
crude_counts <- crude_tibble %>%
    # Tokenize by word 
    unnest_tokens(word, text) %>%
    # Count by word
    count(word, sort = TRUE) %>%
    # Remove stop words
    anti_join(stop_words)
```

## Creating a corpus

You have created a tibble called russian\_tweets that contains around
20,000 tweets auto generated by bots during the 2016 U.S. election cycle
so that you can preform text analysis. However, when searching through
the available options for performing the analysis you have chosen to do,
you believe that the tm package offers the easiest path forward. In
order to conduct the analysis, you first must create a corpus and attach
potentially useful metadata.

Be aware that this is real data from Twitter and as such there is always
a risk that it may contain profanity or other offensive content (in this
exercise, and any following exercises that also use real Twitter data).

``` r
# Create a corpus
russian_tweets <- read_csv("russian_1.csv")
tweet_corpus <- VCorpus(VectorSource(russian_tweets$content))

# Attach following and followers
meta(tweet_corpus, 'following') <- russian_tweets$following
meta(tweet_corpus, 'followers') <- russian_tweets$followers

# Review the meta data
head(meta(tweet_corpus))
```

    ##   following followers
    ## 1      1052      9636
    ## 2      1054      9637
    ## 3      1054      9637
    ## 4      1062      9642
    ## 5      1050      9645
    ## 6      1050      9644

## BoW Example

In literature reviews, researchers read and summarize as many available
texts about a subject as possible. Sometimes they end up reading
duplicate articles, or summaries of articles they have already read. You
have been given 20 articles about crude oil as an R object named
crude\_tibble. Instead of jumping straight to reading each article, you
have decided to see what words are shared across these articles. To do
so, you will start by building a bag-of-words representation of the
text.

``` r
# Count occurrence by article_id and word
data.table::setnames(crude_tibble, "id", "article_id")
words <- crude_tibble %>%
    unnest_tokens(output = "word", token = "words", input = text) %>%
    anti_join(stop_words) %>%
    count(article_id, word, sort=TRUE)

# How many different word/article combinations are there?
unique_combinations <- nrow(words)

# Filter to responses with the word "prices"
words_with_prices <- words %>%
    filter(word == "prices")

# How many articles had the word "prices"?
number_of_price_articles <- nrow(words_with_prices)
```

## Sparse matrices

During the video lesson you learned about sparse matrices. Sparse
matrices can become computational nightmares as the number of text
documents and the number of unique words grow. Creating word
representations with tweets can easily create sparse matrices because
emojis, slang, acronyms, and other forms of language are used. In this
exercise you will walk through the steps to calculate how sparse the
Russian tweet dataset is. Note that this is a small example of how
quickly text analysis can become a major computational problem.

``` r
# Tokenize and remove stop words
tidy_tweets <- russian_tweets %>%
  unnest_tokens(word, content) %>%
  anti_join(stop_words)


# Count by word
unique_words <- tidy_tweets %>%
  count(word)

# Count by tweet (tweet_id) and word
unique_words_by_tweet <- tidy_tweets %>%
  count(tweet_id, word)

# Find the size of matrix
size <- nrow(russian_tweets) * nrow(unique_words)
# Find percent of entries that would have a value
percent <- nrow(unique_words_by_tweet ) / size
percent
```

    ## [1] 0.0002028352

## TFIDF Practice

Earlier you looked at a bag-of-words representation of articles on crude
oil. Calculating TFIDF values relies on this bag-of-words
representation, but takes into account how often a word appears in an
article, and how often that word appears in the collection of articles.
To determine how meaningful words would be when comparing different
articles, calculate the TFIDF weights for the words in crude, a
collection of 20 articles about crude oil.

``` r
# Create a tibble with TFIDF values
crude_weights <- crude_tibble %>%
  unnest_tokens(output = "word", token = "words", input = text) %>%
  anti_join(stop_words) %>%
  count(article_id, word) %>%
  bind_tf_idf(word, article_id, n)

# Find the highest TFIDF values
crude_weights %>%
  arrange(desc(tf_idf))
```

    ## # A tibble: 1,498 x 6
    ##    article_id word         n     tf   idf tf_idf
    ##    <chr>      <chr>    <int>  <dbl> <dbl>  <dbl>
    ##  1 708        january      4 0.0930  2.30  0.214
    ##  2 368        power        4 0.0690  3.00  0.207
    ##  3 704        futures      9 0.0643  3.00  0.193
    ##  4 242        8            6 0.0619  3.00  0.185
    ##  5 191        canada       2 0.0526  3.00  0.158
    ##  6 191        canadian     2 0.0526  3.00  0.158
    ##  7 368        ship         3 0.0517  3.00  0.155
    ##  8 704        nymex        7 0.05    3.00  0.150
    ##  9 708        cubic        2 0.0465  3.00  0.139
    ## 10 708        fiscales     2 0.0465  3.00  0.139
    ## # ... with 1,488 more rows

``` r
# Find the lowest non-zero TFIDF values
crude_weights %>%
  filter(tf_idf != 0) %>%
  arrange(tf_idf)
```

    ## # A tibble: 1,458 x 6
    ##    article_id word          n      tf   idf  tf_idf
    ##    <chr>      <chr>     <int>   <dbl> <dbl>   <dbl>
    ##  1 237        prices        1 0.00452 0.288 0.00130
    ##  2 246        prices        1 0.00513 0.288 0.00148
    ##  3 237        dlrs          1 0.00452 0.598 0.00271
    ##  4 237        opec          1 0.00452 0.693 0.00314
    ##  5 246        opec          1 0.00513 0.693 0.00355
    ##  6 237        mln           1 0.00452 0.799 0.00361
    ##  7 237        petroleum     1 0.00452 0.799 0.00361
    ##  8 273        petroleum     1 0.00455 0.799 0.00363
    ##  9 236        barrels       1 0.00429 0.916 0.00393
    ## 10 236        industry      1 0.00429 0.916 0.00393
    ## # ... with 1,448 more rows

## An example of failing at text analysis

Early on, you discussed the power of removing stop words before
conducting text analysis. In this most recent chapter, you reviewed
using cosine similarity to identify texts that are similar to each
other.

In this exercise, you will explore the very real possibility of failing
to use text analysis properly. You will compute cosine similarities for
the chapters in the book Animal Farm, without removing stop-words.

``` r
# Create word counts
animal_farm_counts <- animal_farm %>%
  unnest_tokens(word, text_column) %>%
  count(chapter, word)

# Calculate the cosine similarity by chapter, using words
comparisons <- animal_farm_counts %>%
  pairwise_similarity(chapter, word, n) %>%
  arrange(desc(similarity))

# Print the mean of the similarity values
comparisons %>%
  summarize(mean = mean(similarity))
```

    ## # A tibble: 1 x 1
    ##    mean
    ##   <dbl>
    ## 1 0.949

## Cosine similarity example

The plot of Animal Farm is pretty simple. In the beginning the animals
are unhappy with following their human leaders. In the middle they
overthrow those leaders, and in the end they become unhappy with the
animals that eventually became their new leaders.

If done correctly, cosine similarity can help identify documents
(chapters) that are similar to each other. In this exercise, you will
identify similar chapters in Animal Farm. Odds are, chapter 1 (the
beginning) and chapter 10 (the end) will be similar.

``` r
# Create word counts 
animal_farm_counts <- animal_farm %>%
  unnest_tokens(word, text_column) %>%
  anti_join(stop_words) %>%
  count(chapter, word) %>%
  bind_tf_idf(chapter, word, n)

# Calculate cosine similarity on word counts
animal_farm_counts %>%
  pairwise_similarity(chapter, word, n) %>%
  arrange(desc(similarity))
```

    ## # A tibble: 90 x 3
    ##    item1      item2      similarity
    ##    <chr>      <chr>           <dbl>
    ##  1 Chapter 8  Chapter 7       0.696
    ##  2 Chapter 7  Chapter 8       0.696
    ##  3 Chapter 7  Chapter 5       0.693
    ##  4 Chapter 5  Chapter 7       0.693
    ##  5 Chapter 8  Chapter 5       0.642
    ##  6 Chapter 5  Chapter 8       0.642
    ##  7 Chapter 7  Chapter 6       0.641
    ##  8 Chapter 6  Chapter 7       0.641
    ##  9 Chapter 6  Chapter 10      0.638
    ## 10 Chapter 10 Chapter 6       0.638
    ## # ... with 80 more rows

``` r
# Calculate cosine similarity using tf_idf values
animal_farm_counts %>%
  pairwise_similarity(chapter, word, tf_idf) %>%
  arrange(desc(similarity))
```

    ## # A tibble: 90 x 3
    ##    item1      item2      similarity
    ##    <chr>      <chr>           <dbl>
    ##  1 Chapter 8  Chapter 7      0.0580
    ##  2 Chapter 7  Chapter 8      0.0580
    ##  3 Chapter 9  Chapter 8      0.0525
    ##  4 Chapter 8  Chapter 9      0.0525
    ##  5 Chapter 7  Chapter 5      0.0467
    ##  6 Chapter 5  Chapter 7      0.0467
    ##  7 Chapter 9  Chapter 10     0.0446
    ##  8 Chapter 10 Chapter 9      0.0446
    ##  9 Chapter 9  Chapter 7      0.0432
    ## 10 Chapter 7  Chapter 9      0.0432
    ## # ... with 80 more rows

## Data preparation

During the 2016 US election, Russian tweet bots were used to constantly
distribute political rhetoric to both democrats and republicans. You
have been given a dataset of such tweets called russian\_tweets. You
have decided to classify these tweets as either left- (democrat) or
right-leaning(republican). Before you can build a classification model,
you need to clean and prepare the text for modeling.

``` r
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
```

    ## <<DocumentTermMatrix (documents: 19986, terms: 38909)>>
    ## Non-/sparse entries: 176707/777458567
    ## Sparsity           : 100%
    ## Maximal term length: 37
    ## Weighting          : term frequency - inverse document frequency (normalized) (tf-idf)

``` r
#removing sparse terms

less_sparse_matrix <-
    removeSparseTerms(tweet_matrix , sparse =.9999)

# Print results
tweet_matrix
```

    ## <<DocumentTermMatrix (documents: 19986, terms: 38909)>>
    ## Non-/sparse entries: 176707/777458567
    ## Sparsity           : 100%
    ## Maximal term length: 37
    ## Weighting          : term frequency - inverse document frequency (normalized) (tf-idf)

``` r
less_sparse_matrix
```

    ## <<DocumentTermMatrix (documents: 19986, terms: 9566)>>
    ## Non-/sparse entries: 147364/191038712
    ## Sparsity           : 100%
    ## Maximal term length: 27
    ## Weighting          : term frequency - inverse document frequency (normalized) (tf-idf)

’Classification modeling example You have previously prepared a set of
Russian tweets for classification. Of the 20,000 tweets, you have
filtered to tweets with an account\_type of Left or Right, and selected
the first 2000 tweets of each. You have already tokenized the tweets
into words, removed stop words, and performed stemming. Furthermore, you
converted word counts into a document-term matrix with TFIDF values for
weights and saved this matrix as: left\_right\_matrix\_small.

You will use this matrix to predict whether a tweet was generated from a
left-leaning tweet bot, or a right-leaning tweet bot. The labels can be
found in the vector, left\_right\_labels.’

nrow(less\_sparse\_matrix) library(randomForest)

# Create train/test split

set.seed(1111) sample\_size \<- floor(.75 \* nrow(less\_sparse\_matrix))
train\_ind \<- sample(nrow(less\_sparse\_matrix), size = sample\_size)
train \<- less\_sparse\_matrix\[train\_ind, \] test \<-
less\_sparse\_matrix\[-train\_ind, \]

# Create a random forest classifier

x\_train \<- as.data.frame(as.matrix(train)) left\_right\_labels
\<-russian\_tweets$account\_type left\_right\_labels \<- facto y\_train
\<- left\_right\_labels\[train\_ind\]

rfc \<- randomForest(x =x\_train, y = y\_train, nTree = 50, ) \# Print
the results rfc

’Confusion matrices You have just finished creating a classification
model. This model predicts whether tweets were created by a left-leaning
(democrat) or right-leaning (republican) tweet bot. You have made
predictions on the test data and have the following result:

Predictions Left Right Left 350 157 Right 57 436 Use the confusion
matrix above to answer questions about the models accuracy.’

# Percentage correctly labeled “Left”

left \<- (350) / (350 + 157) left

# Percentage correctly labeled “Right”

right \<- (436) / (57 + 436) right

# Overall Accuracy:

accuracy \<- (350 + 436) / (350 + 157 + 57 + 436) accuracy

’LDA practice You are interested in the common themes surrounding the
character Napoleon in your favorite new book, Animal Farm. Napoleon is a
Pig who convinces his fellow comrades to overthrow their human leaders.
He also eventually becomes the new leader of Animal Farm.

You have extracted all of the sentences that mention Napoleons name,
pig\_sentences, and created tokenized version of these sentences with
stop words removed and stemming completed, pig\_tokens. Complete LDA on
t hese sentences and review the top words associated with some of the
topics.’

library(topicmodels) \# Perform Topic Modeling sentence\_lda \<-
LDA(pig\_matrix, k = 10, method = ‘Gibbs’, control = list(seed = 1111))
\# Extract the beta matrix sentence\_betas \<- tidy(sentence\_lda,
matrix = “beta”)

# Topic \#2

sentence\_betas %\>% filter(topic == 2) %\>% arrange(-beta) \# Topic \#3
sentence\_betas %\>% filter(topic == 3) %\>% arrange(-beta)

"Assigning topics to documents Creating LDA models are useless unless
you can interpret and use the results. You have been given the results
of running an LDA model, sentence\_lda on a set of sentences,
pig\_sentences. You need to explore both the beta, top words by topic,
and the gamma, top topics per document, matrices to fully understand the
results of any LDA analysis.

Given what you know about these two matrices, extract the results for a
specific topic and see if the output matches expectations."

# Extract the beta and gamma matrices

sentence\_betas \<- tidy(sentence\_lda, matrix = “beta”)
sentence\_gammas \<- tidy(sentence\_lda, matrix = “gamma”)

# Explore Topic 5 Betas

sentence\_betas %\>% filter(topic == 5) %\>% arrange(-beta)

# Explore Topic 5 Gammas

sentence\_gammas %\>% filter(topic == 5) %\>% arrange(-gamma)

“Testing perplexity You have been given a dataset full of tweets that
were sent by tweet bots during the 2016 US election. Your boss has
identified two different account types of interest, Left and Right. Your
boss has asked you to perform topic modeling on the tweets from Right
tweet bots. Furthermore, your boss is hoping to summarize the content of
these tweets with topic modeling. Perform topic modeling on 5, 15, and
50 topics to determine a general idea of how many topics are contained
in the data.”

library(topicmodels) \# Setup train and test data sample\_size \<-
floor(0.90 \* nrow(right\_matrix)) set.seed(1111) train\_ind \<-
sample(nrow(right\_matrix), size = sample\_size) train \<-
right\_matrix\[train\_ind, \] test \<- right\_matrix\[-train\_ind, \]

# Peform topic modeling

lda\_model \<- LDA(train, k = 50, method = “Gibbs”, control = list(seed
= 1111)) \# Train perplexity(lda\_model, newdata = train) \# Test
perplexity(lda\_model, newdata = test)

“Reviewing LDA results You have developed a topic model,
napoleon\_model, with 5 topics for the sentences from the book Animal
Farm that reference the main character Napoleon. You have had 5 local
authors review the top words and top sentences for each topic and they
have provided you with themes for each topic. To finalize your results,
prepare some summary statistics about the topics. You will present these
summary values along with the themes to your boss for review.”

# Extract the gamma matrix

gamma\_values \<- tidy(napoleon\_model, matrix = “gamma”) \# Create
grouped gamma tibble grouped\_gammas \<- gamma\_values %\>%
group\_by(document) %\>% arrange(desc(gamma)) %\>% slice(1) %\>%
group\_by(topic) \# Count (tally) by topic grouped\_gammas %\>%
tally(topic, sort=TRUE) \# Average topic weight for top topic for each
sentence grouped\_gammas %\>% summarise(avg=mean(gamma)) %\>%
arrange(desc(avg))
