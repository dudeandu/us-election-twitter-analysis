---
title: "USA 2020 elections sentiment analisys"
author: "Andres Plana"
date: "21 August 2020"
output: html_document
---  

###
setwd("~/Desktop/US elections 2020/sentiment analisys")

install.packages("RCurl")
install.packages("twitteR")
install.packages("httr")
install.packages("ggplot2")

install.packages("tm")
install.packages("wordcloud")
install.packages("syuzhet")
install.packages("dplyr")
install.packages("plotly")


install.packages("tidyr")
install.packages("tidytext")

##base64enc ( <- you need this for oauth to work!) 
install.packages("base64enc")
install.packages("devtools")


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

# run this code in R 
# devtools::install_github("hadley/httr") 
# finally proceed with the authorization: 
consumer_key <- "3jZ4fkvWpPkvEJjkrxjdAuJfr" 
consumer_secret <- "SWzaUB9NU1olDnDbJXnT8FIcKiocEOJrJRp7GQJPZugPCRIx6Y" 
access_token <- "381807468-XUP7IROnbiEQSTQXCAVi89z4qRUXgnTjHL7kMcO4" 
access_token_secret <- "MQTsTLlJuY0H4yXm7YZVsLsQf9rdDS0UCrWhqOHFEYFol" 
setup_twitter_oauth(consumer_key,consumer_secret,access_token,access_token_secret)


## tweets <- searchTwitter("ElectionsCanada", since='2019-10-20', until = '2019-10-21', n=1500, lang="en")
# tweets <- searchTwitter("#beer", n=1500, lang="en")
joebiden_mentions <- searchTwitter("@JoeBiden", n=1500, lang="en")
trump_mentions <- searchTwitter("@realDonaldTrump", n=1500, lang="en")
tweets <- searchTwitter("#MAGA", n=1500, lang="en")
tweets_df <- twListToDF(tweets_joebiden)

head(tweets_df)
write.csv(tweets_df, "MAGA.csv")

biden_Timeline <- userTimeline("@JoeBiden", n=3200)
biden_df <- twListToDF(biden_Timeline)
write.csv(biden_df, "biden.csv")

trump_Timeline <- userTimeline("@realDonaldTrump", n=3200)
trump_df <- twListToDF(trump_Timeline)
write.csv(biden_df, "trump.csv")

# CLEANING TWEETS
# 
# biden_df$text=gsub("&amp", "", biden_df$text)
# biden_df$text = gsub("&amp", "", biden_df$text)
# biden_df$text = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", biden_df$text)
# biden_df$text = gsub("@\\w+", "", biden_df$text)
# biden_df$text = gsub("[[:punct:]]", "", biden_df$text)
# biden_df$text = gsub("[[:digit:]]", "", biden_df$text)
# biden_df$text = gsub("http\\w+", "", biden_df$text)
# biden_df$text = gsub("[ \t]{2,}", "", biden_df$text)
# biden_df$text = gsub("^\\s+|\\s+$", "", biden_df$text)
# CLEANING TWEETS

biden_df$text = gsub("&amp", "", biden_df$text)
# biden_df$text = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", biden_df$text)
biden_df$text = gsub("(RT|via)", "", biden_df$text)
biden_df$text = gsub("@\\w+", "", biden_df$text)
biden_df$text = gsub("[[:punct:]]", "", biden_df$text)
biden_df$text = gsub("[[:digit:]]", "", biden_df$text)
biden_df$text = gsub("http\\w+", "", biden_df$text)
biden_df$text = gsub("[ \t]{2,}", "", biden_df$text)
biden_df$text = gsub("^\\s+|\\s+$", "", biden_df$text)

biden_df$text <- iconv(biden_df$text, "UTF-8", "ASCII", sub="")

### just in case
biden_df$stripped <- gsub("http\\s+","",biden_df$full_tweet_text)


### Get the canon
biden_df_stem <- biden_df %>%
  select(stripped) %>%
  unnest_tokens(word, stripped)

head(biden_df_stem)

## remove stop words
cleaned_biden_df <- biden_df_stem %>%
  anti_join(stop_words)

head(cleaned_biden_df)

### Top 10 words in @JoeBiden
cleaned_biden_df %>%
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
       title = "Unique word cont in @JoeBiden tweets")


###########################
# This exports total count of each word

book_words <- biden_df %>%
  unnest_tokens(word, text) %>%
  count(word, sort = TRUE)

total_words <- book_words %>% 
  group_by(book) %>% 
  summarize(total = sum(n))

book_words <- left_join(book_words, total_words)

book_words

write.csv(book_words, "biden-allword-count.csv")



###########################
# This exports total count of each word without stop words

bidentop20 <- cleaned_biden_df %>%
  count(word, sort = TRUE) %>%
  # top_n(20) %>%
  mutate(word = reorder(word, n))

write.csv(bidentop20, "biden-word-count.csv")

