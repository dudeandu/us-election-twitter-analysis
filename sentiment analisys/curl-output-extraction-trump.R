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

library(stringr)

require(tidyr)
require(tidytext)


setwd("~/Desktop/US elections 2020/sentiment analisys")

## tweets <- searchTwitter("ElectionsCanada", since='2019-10-20', until = '2019-10-21', n=1500, lang="en")
# tweets <- searchTwitter("#beer", n=1500, lang="en")

json_file <- "data/trump-tweets.json"
# json_data <- fromJSON(paste(readLines(json_file), collapse=""))

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

trump_df$full_tweet_text = gsub("&amp", "", trump_df$full_tweet_text)
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


####  assign new columns with key search patterns
# trump_df$TK_mentions <- str_detect(trump_df$full_tweet_text, regex("TK", ignore_case = TRUE))

trump_df$joe_mentions <- str_detect(trump_df$full_tweet_text, regex("joe", ignore_case = TRUE))
trump_df$biden_mentions <- str_detect(trump_df$full_tweet_text, regex("biden", ignore_case = TRUE))
trump_df$vote_mentions <- str_detect(trump_df$full_tweet_text, regex("vote", ignore_case = TRUE))
trump_df$america_mentions <- str_detect(trump_df$full_tweet_text, regex("america ", ignore_case = TRUE))
trump_df$country_mentions <- str_detect(trump_df$full_tweet_text, regex("country", ignore_case = TRUE))
trump_df$ballots_mentions <- str_detect(trump_df$full_tweet_text, regex("ballots", ignore_case = TRUE))
trump_df$trump_mentions <- str_detect(trump_df$full_tweet_text, regex("trump", ignore_case = TRUE))
trump_df$republican_mentions <- str_detect(trump_df$full_tweet_text, regex("republican", ignore_case = TRUE))
trump_df$democrat_mentions <- str_detect(trump_df$full_tweet_text, regex("democrat", ignore_case = TRUE))
trump_df$maga_mentions <- str_detect(trump_df$full_tweet_text, regex("maga", ignore_case = TRUE))
trump_df$canada_mentions <- str_detect(trump_df$full_tweet_text, regex("canada", ignore_case = TRUE))
trump_df$black_mentions <- str_detect(trump_df$full_tweet_text, regex("black", ignore_case = TRUE))
trump_df$industry_mentions <- str_detect(trump_df$full_tweet_text, regex("industry", ignore_case = TRUE))
trump_df$hispanic_mentions <- str_detect(trump_df$full_tweet_text, regex("hispanic", ignore_case = TRUE))
trump_df$elections_mentions <- str_detect(trump_df$full_tweet_text, regex("elections", ignore_case = TRUE))
trump_df$covid_mentions <- str_detect(trump_df$full_tweet_text, regex("covid", ignore_case = TRUE))
trump_df$virus_mentions <- str_detect(trump_df$full_tweet_text, regex("virus", ignore_case = TRUE))
trump_df$healthcare_mentions <- str_detect(trump_df$full_tweet_text, regex("healthcare", ignore_case = TRUE))
trump_df$health_mentions <- str_detect(trump_df$full_tweet_text, regex("health", ignore_case = TRUE))
trump_df$people_mentions <- str_detect(trump_df$full_tweet_text, regex("people", ignore_case = TRUE))
trump_df$women_mentions <- str_detect(trump_df$full_tweet_text, regex("women", ignore_case = TRUE))



# Emotions for each tweet using NRC dictionary
emotions <- get_nrc_sentiment(trump_df$full_tweet_text)
# emotions_syuzhet <- get_sentiment(trump_df$full_tweet_text, method="afinn")
emo_bar = colSums(emotions)
emo_sum = data.frame(count=emo_bar, emotion=names(emo_bar))
emo_sum$emotion = factor(emo_sum$emotion, levels=emo_sum$emotion[order(emo_sum$count, decreasing = TRUE)])


write.csv(emotions, "donald-motions.csv")

# Visualize the emotions from NRC sentiments
library(plotly)
plot_ly(emo_sum, x=~emotion, y=~count, type="bar", color=~emotion) %>%
  layout(xaxis=list(title=""), showlegend=FALSE, title="Emotion Type: @realDonaldTrump")


total <- cbind(trump_df, emotions)
colnames(total)
write.csv(total[c(1:4,6:24,75,356:ncol(total))], "trump.csv")


# write.csv(trump_df[c(1:24,75,352)], "trump.csv")

# trump_df <- twListToDF(tweets_realDonaldTrump[["results"]])

