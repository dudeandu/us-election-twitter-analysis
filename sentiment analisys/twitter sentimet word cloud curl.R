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
install.packages("stringr")


require(rjson)
require(jsonlite)
require(data.table)

require(twitteR)
require(RCurl)
require(httr)
require(ggplot2)
require(base64enc)

library(stringr)

require(tm)
require(wordcloud)
require(syuzhet)
require(dplyr)

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
  if (!is.na(trump_df[i,69])){
    # print(trump_df[i,69])
    tweet_text <- c(tweet_text, trump_df[i,69])
  } else {
    # print(trump_df[i,4])
    tweet_text <- c(tweet_text, trump_df[i,4])
  }
}

trump_df$full_tweet_text <- tweet_text 

# CLEANING TWEETS

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

# finding a word 
joe <- "joe"
sum(str_detect(trump_df$full_tweet_text, "joe"))
# ignore capitals
sum(str_detect(trump_df$full_tweet_text, regex("joe", ignore_case = TRUE)))

trump_df$joe_mentions <- str_detect(trump_df$full_tweet_text, regex("joe", ignore_case = TRUE))




# Emotions for each tweet using NRC dictionary
emotions <- get_nrc_sentiment(trump_df$full_tweet_text)
emo_bar = colSums(emotions)
emo_sum = data.frame(count=emo_bar, emotion=names(emo_bar))
emo_sum$emotion = factor(emo_sum$emotion, levels=emo_sum$emotion[order(emo_sum$count, decreasing = TRUE)])

write.csv(emotions, "donald-motions.csv")

# Visualize the emotions from NRC sentiments
library(plotly)
plot_ly(emo_sum, x=~emotion, y=~count, type="bar", color=~emotion) %>%
  layout(xaxis=list(title=""), showlegend=FALSE, title="Emotion Type for timeline: @JoeBiden")


# Create comparison word cloud data

wordcloud_tweet = c(
  paste(trump_df$full_tweet_text[emotions$anger > 0], collapse=" "),
  paste(trump_df$full_tweet_text[emotions$anticipation > 0], collapse=" "),
  paste(trump_df$full_tweet_text[emotions$disgust > 0], collapse=" "),
  paste(trump_df$full_tweet_text[emotions$fear > 0], collapse=" "),
  paste(trump_df$full_tweet_text[emotions$joy > 0], collapse=" "),
  paste(trump_df$full_tweet_text[emotions$sadness > 0], collapse=" "),
  paste(trump_df$full_tweet_text[emotions$surprise > 0], collapse=" "),
  paste(trump_df$full_tweet_text[emotions$trust > 0], collapse=" "),
  paste(trump_df$full_tweet_text[emotions$negative > 0], collapse=" "),
  paste(trump_df$full_tweet_text[emotions$positive > 0], collapse=" ")
)

all_words <- paste(trump_df$full_tweet_text, collapse=" ")

# create corpus
corpus = Corpus(VectorSource(wordcloud_tweet))

# remove punctuation, convert every word in lower case and remove stop words

corpus = tm_map(corpus, tolower)
corpus = tm_map(corpus, removePunctuation)
corpus = tm_map(corpus, removeWords, c(stopwords("english")))
## stemming removes a lot of words. (maybe some are not important?)
corpus = tm_map(corpus, stemDocument)

# create document term matrix

tdm = TermDocumentMatrix(corpus)

# convert as matrix
tdm = as.matrix(tdm)
tdmnew <- tdm[nchar(rownames(tdm)) < 11,]

# column name binding
colnames(tdm) = c('anger', 'anticipation', 'disgust', 'fear', 'joy', 'sadness', 'surprise', 'trust', 'negative', 'positive')
colnames(tdmnew) <- colnames(tdm)
comparison.cloud(tdmnew, random.order=FALSE,
                 colors = c("#00B2FF", "red", "#FF0099", "#6600CC", "green", "orange", "blue", "brown"),
                 title.size=1, max.words=250, scale=c(2.5, 0.4),rot.per=0.4)

### 


write.csv(tdm, "trump-word-emotion.csv")
