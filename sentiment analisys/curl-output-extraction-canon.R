---
title: "USA 2020 elections sentiment analisys"
author: "Andres Plana"
date: "21 August 2020"
output: html_document
---  
  
###testing curl command JSON file otput to data frame


setwd("~/Desktop/US elections 2020/sentiment analisys")

install.packages("rjson")
install.packages("jsonlite")
install.packages("data.table")

require(rjson)
require(jsonlite)
require(data.table)

require(twitteR)
require(RCurl)
require(httr)
require(ggplot2)
require(base64enc)

require(tm)
require(wordcloud)
require(syuzhet)
require(dplyr)

require(tidyr)
require(tidytext)

## tweets <- searchTwitter("ElectionsCanada", since='2019-10-20', until = '2019-10-21', n=1500, lang="en")
# tweets <- searchTwitter("#beer", n=1500, lang="en")

json_file <- "data/trump-tweets.json"
json_data <- fromJSON(paste(readLines(json_file), collapse=""))

# tweets_realDonaldTrump <- fromJSON(paste(readLines(json_file), collapse=""))
tweets_realDonaldTrump <- fromJSON(paste(readLines(json_file), collapse=""),flatten=TRUE)


trump_df <- as.data.frame(tweets_realDonaldTrump[["results"]])
colnames(trump_df)
nrow(trump_df)

tweet_text <- character()

for (i in 1:nrow(trump_df)) {
  if (!is.na(trump_df[i,75])){
    # print(trump_df[i,69])
    tweet_text <- c(tweet_text, trump_df[i,75])
  } else {
    # print(trump_df[i,4])
    tweet_text <- c(tweet_text, trump_df[i,4])
  }
}

trump_df$full_tweet_text <- tweet_text 

# CLEANING TWEETS

trump_df$full_tweet_text =gsub("&amp", "", trump_df$full_tweet_text)
trump_df$full_tweet_text = gsub("&amp", "", trump_df$full_tweet_text)
# trump_df$full_tweet_text = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", trump_df$full_tweet_text)
trump_df$full_tweet_text = gsub("(RT|via)", "", trump_df$full_tweet_text)
trump_df$full_tweet_text = gsub("@\\w+", "", trump_df$full_tweet_text)
trump_df$full_tweet_text = gsub("[[:punct:]]", "", trump_df$full_tweet_text)
trump_df$full_tweet_text = gsub("[[:digit:]]", "", trump_df$full_tweet_text)
trump_df$full_tweet_text = gsub("http\\w+", "", trump_df$full_tweet_text)
trump_df$full_tweet_text = gsub("[ \t]{2,}", "", trump_df$full_tweet_text)
trump_df$full_tweet_text = gsub("^\\s+|\\s+$", "", trump_df$full_tweet_text)

trump_df$full_tweet_text <- iconv(trump_df$full_tweet_text, "UTF-8", "ASCII", sub="")

### just in case
trump_df$stripped <- gsub("http\\s+","",trump_df$full_tweet_text)


### Get the canon
trump_df_stem <- trump_df %>%
  select(stripped) %>%
  unnest_tokens(word, stripped)

head(trump_df_stem)

## remove stop words
cleaned_trump_df <- trump_df_stem %>%
  anti_join(stop_words)

write.csv(cleaned_trump_df, "donald-canon.csv")

head(cleaned_trump_df)

### Top 20 words in @realDonaldTrump
cleaned_trump_df %>%
  count(word, sort = TRUE) %>%
  top_n(20) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(x = word, y = n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip() +
  theme_classic() + 
  labs(x = "Count",
       y = "Unique words",
       title = "Unique word count in @realDonaldTrump tweets")


###########################
# This exports total count of each word all words

book_words <- trump_df %>%
  unnest_tokens(word, full_tweet_text) %>%
  count(word, sort = TRUE)

total_words <- book_words %>% 
  group_by(book) %>% 
  summarize(total = sum(n))

book_words <- left_join(book_words, total_words)

book_words

write.csv(book_words, "donald-allword-count.csv")

###########################
# This exports total count of each word without stop words

trumptop20 <- cleaned_trump_df %>%
  count(word, sort = TRUE) %>%
  # top_n(20) %>%
  mutate(word = reorder(word, n))

write.csv(trumptop20, "donald-word-count.csv")
