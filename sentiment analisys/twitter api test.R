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
tweets_df <- twListToDF(tweets)

head(tweets_df)
write.csv(tweets_df, "MAGA.csv")

tpsoperationsTimeline <- userTimeline("@tpsoperations", n=3200)
tpsoperations_df <- twListToDF(tpsoperationsTimeline)
