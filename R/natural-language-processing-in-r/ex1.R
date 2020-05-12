
library(tidyverse)
library(tidytext)
library(SnowballC)

"Practicing syntax with grep
You have just completed an ice-breaker exercise
at work and you recorded 10 facts about your boss.
You saved these 10 facts into a vector named text. 
Using regular expressions, you want to summarize your bosses' responses.
A few notes on regular expressions in R:
When using grep(), setting value = TRUE will print the text instead of the indices.
You can combine patterns such as a digit, '\\d', followed by a period '\\., with '\\d\\.'
Spaces can be found using '\\s'.
You can search for a word by simply using the word as your pattern. pattern = 'word'"

# Print off each item that contained a numeric number
text <- c("John's favorite color two colors are blue and red.",
          "John's favorite number is 1111.",
          "John lives at P Sherman, 42 Wallaby Way, Sydney", 
          "He is 7 feet tall", "John has visited 30 countries",
          "John only has nine fingers.", "John has worked at eleven different jobs",
          "He can speak 3 languages", "john's favorite food is pizza", 
          "John can name 10 facts about himself.")



grep(pattern ="\\d", x = text, value = TRUE)

# Find all items with a number followed by a space
grep(pattern = "\\d\\s", x = text)

# How many times did you write down 'favorite'?
length(grep(pattern ='favorite', x = text))


'Exploring regular expression functions.
You have a vector of ten facts about your boss
saved as a vector called text. In order to create a
new ice-breaker for your team at work, you need to 
remove the name of your boss, John, from each fact 
that you have written down. This can easily be done
using regular expressions
(as well as other search/replace functions). Use regular
expressions to correctly replace "John" from the facts you have written about him.'

# Print off the text for every time you used your boss's name, John
grep('John', x = text, value = TRUE)

# Try replacing all occurences of "John" with "He"
gsub(pattern = 'John', replacement = 'He', x = text)

# Replace all occurences of "John " with 'He '.
clean_text <- gsub(pattern = 'John\\s', replacement = 'He ', x = text)
clean_text

# Replace all occurences of "John's" with 'His'
gsub(pattern = "John\\'s", replacement = 'His', x = clean_text)


"Text preprocessing: remove stop words
Stop words are unavoidable in writing.
However, to determine how similar two pieces of
text are to each other are or when trying to find themes 
within text, stop words can make things difficult.
In the book Animal Farm, the first chapter contains 
only 2,636 words, while almost 200 of them are the word 'the'"




"Usually, 'the' will not help us in text analysis projects.
In this exercise you will remove the stop words from the first chapter of Animal Farm.
Tokenization: sentences
Animal Farm is a popular book for middle school English teachers to
assign to their students. You have decided to do some exploration on the 
text and provide summary statistics for teachers to use when assigning this 
book to their students. You already know that there are 10 chapters, but you
also know that you can use tokenization to help count the number of sentences,
words, and even paragraphs. In this exercise, you will use the tokenization 
techniques learned in the video to help split Animal Farm into sentences and count them by chapter.
"

animal_farm <- read_csv("animal_farm.csv")

# Split the text_column into sentences
animal_farm %>%
    unnest_tokens(output = "sentences",
                  input = text_column,
                  token = "sentences") %>%
    # Count sentences, per chapter
    count(chapter)

# Split the text_column using regular expressions

animal_farm %>%
    unnest_tokens(output = "sentences", input = text_column,
                  token = "regex", pattern = "\\.") %>%
    count(chapter)


"Text preprocessing: remove stop words
Stop words are unavoidable in writing. However,
to determine how similar two pieces of text are
to each other are or when trying to find themes 
within text, stop words can make things difficult.
In the book Animal Farm, the first chapter contains
only 2,636 words, while almost 200 of them are the word 'the'.

Usually, 'the' will not help us in text analysis projects.
In this exercise you will remove the stop words from the first chapter of Animal Farm."

# Tokenize animal farm's text_column column
tidy_animal_farm <- animal_farm %>%
  unnest_tokens(word, text_column) 

# Print the word frequencies
tidy_animal_farm %>%
  count(word, sort = TRUE)

# Remove stop words, using stop_words from tidytext
tidy_animal_farm %>%
  anti_join(stop_words)


'Text preprocessing: Stemming
The root of words are often more 
important than their endings, especially when it
comes to text analysis. The book Animal Farm is
obviously about animals. However, knowing that 
the book mentions animals 248 times,
and animal 107 times might not be helpful for your analysis.
tidy_animal_farm contains a tibble of the words from Animal Farm, 
tokenized and without stop words. The next step is to stem the words and explore the results.'


# Perform stemming on tidy_animal_farm
stemmed_animal_farm <- tidy_animal_farm %>%
    mutate(word = wordStem(word))

# Print the old word frequencies 
tidy_animal_farm %>%
    count(word, sort = T)

# Print the new word frequencies
stemmed_animal_farm %>%
    count(word, sort = T)




