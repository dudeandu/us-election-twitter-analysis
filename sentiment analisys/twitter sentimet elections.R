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
tweets_joebiden <- searchTwitter("@JoeBiden", n=1500, lang="en")
tweets <- searchTwitter("#MAGA", n=1500, lang="en")
tweets_df <- twListToDF(tweets_joebiden)

head(tweets_df)
write.csv(tweets_df, "MAGA.csv")

biden_Timeline <- userTimeline("@JoeBiden", n=3200)
biden_df <- twListToDF(biden_Timeline)
write.csv(biden_df, "biden.csv")

# CLEANING TWEETS

biden_df$text=gsub("&amp", "", biden_df$text)
biden_df$text = gsub("&amp", "", biden_df$text)
biden_df$text = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", biden_df$text)
biden_df$text = gsub("@\\w+", "", biden_df$text)
biden_df$text = gsub("[[:punct:]]", "", biden_df$text)
biden_df$text = gsub("[[:digit:]]", "", biden_df$text)
biden_df$text = gsub("http\\w+", "", biden_df$text)
biden_df$text = gsub("[ \t]{2,}", "", biden_df$text)
biden_df$text = gsub("^\\s+|\\s+$", "", biden_df$text)

biden_df$text <- iconv(biden_df$text, "UTF-8", "ASCII", sub="")


# Emotions for each tweet using NRC dictionary
emotions <- get_nrc_sentiment(biden_df$text)
emo_bar = colSums(emotions)
emo_sum = data.frame(count=emo_bar, emotion=names(emo_bar))
emo_sum$emotion = factor(emo_sum$emotion, levels=emo_sum$emotion[order(emo_sum$count, decreasing = TRUE)])


# Visualize the emotions from NRC sentiments
library(plotly)
plot_ly(emo_sum, x=~emotion, y=~count, type="bar", color=~emotion) %>%
  layout(xaxis=list(title=""), showlegend=FALSE, title="Emotion Type for timeline: @JoeBiden")
