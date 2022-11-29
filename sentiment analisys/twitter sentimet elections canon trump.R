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
tweets_joetrump <- searchTwitter("@JoeBiden", n=1500, lang="en")
tweets <- searchTwitter("#MAGA", n=1500, lang="en")
tweets_df <- twListToDF(tweets_joetrump)

head(tweets_df)
write.csv(tweets_df, "MAGA.csv")

# tweets_realDonaldTrump <- searchTwitter("@realDonaldTrump", n=1500, lang="en")
trump_Timeline <- userTimeline("@realDonaldTrump", n=3200)
trump_df <- twListToDF(trump_Timeline)
write.csv(trump_df, "trump.csv")

# CLEANING TWEETS

trump_df$text=gsub("&amp", "", trump_df$text)
trump_df$text = gsub("&amp", "", trump_df$text)
trump_df$text = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", trump_df$text)
trump_df$text = gsub("@\\w+", "", trump_df$text)
trump_df$text = gsub("[[:punct:]]", "", trump_df$text)
trump_df$text = gsub("[[:digit:]]", "", trump_df$text)
trump_df$text = gsub("http\\w+", "", trump_df$text)
trump_df$text = gsub("[ \t]{2,}", "", trump_df$text)
trump_df$text = gsub("^\\s+|\\s+$", "", trump_df$text)

trump_df$text <- iconv(trump_df$text, "UTF-8", "ASCII", sub="")

### just in case
trump_df$stripped <- gsub("http\\s+","",trump_df$text)


### Get the canon
trump_df_stem <- trump_df %>%
  select(stripped) %>%
  unnest_tokens(word, stripped)

head(trump_df_stem)

## remove stop words
cleaned_trump_df <- trump_df_stem %>%
  anti_join(stop_words)

head(cleaned_trump_df)

### Top 10 words in @Joetrump
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
