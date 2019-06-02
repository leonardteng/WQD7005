Sys.setenv(JAVA_HOME='C:/Program Files/Java/jre1.8.0_211')
library(sentimentr)
library(dplyr)
library('lubridate')
library('stringr')
library(ggplot2)
library(xlsx)

oritext <- read.csv("22_4_news.csv")
title <- oritext %>% select(stock.code, date, title)
title[title==""] <- NA
title <- na.omit(title)
title <- get_sentences(title)
sen_title <- sentiment(title)
ar_sen_title <- sen_title %>% select(stock.code, date, title, sentiment) %>% filter(stock.code == 5238)
ar_sen_title$date <- dmy_hm(ar_sen_title$date)
ar_sen_title$date <- as_date(ar_sen_title$date)
ar_sen_title <- ar_sen_title %>% select(stock.code, date, title, sentiment) %>% filter(stock.code == 5238) %>% arrange((date))
ggplot(data=ar_sen_title, aes(x=date, y=sentiment)) +
  geom_point()

arx <- read.xlsx("airasia.xlsx", sheetName = "Airasia")
arx$Date <- ymd(arx$Date)
arx$Close.Price <- as.numeric(levels(arx$Close.Price))


ggplot() + 
  geom_line(data=ar_sen_title, aes(x=date, y=sentiment), color ="red") + 
  geom_line(data=arx, aes(x=Date, y=Close.Price), color = "blue")

