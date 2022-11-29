---
title: "tpsoperations twitter"
author: "Andres Plana"
date: "26 November 2019"
output: html_document
---
  
setwd("~/Desktop/twitter api test")

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


## tweets <- searchTwitter("ElectionsCanada", since='2019-01-01', until = '2019-01-31', n=1500, lang="en")
tweets <- searchTwitter("tpsoperations + SHOOTING", n=1500, lang="en")
tweets_df <- twListToDF(tweets)
write.csv(tweets_df,'tpsoperations_SHOOTINGS.csv')

head(tweets_df)

tpsoperationsTimeline <- userTimeline("tpsoperations", n=3200, since= )
tpsoperations_df <- twListToDF(tpsoperationsTimeline)
write.csv(tpsoperations_df,'tpsoperations.csv')

###START TEST
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################

tpsoperationsTimeline_january2019 <- userTimeline("tpsoperations", maxID = '1127414276908625921', n=3200, includeRts=FALSE,excludeReplies=FALSE)
tpsoperations_df_2019 <- twListToDF(tpsoperationsTimeline_january2019)
write.csv(tpsoperations_df_2019,'tpsoperations_01_2019_6.csv')
