library("lubridate")
library(dplyr)

stock <- read.csv("dufu.csv")
names(stock)[1] <- 'date'
stock$date <- mdy(stock$date)
stock_senti <- read.csv("dufu_senti.csv")
stock_senti$date <- ymd(stock_senti$date)
stock$date <- as.Date(stock$date, format = "%d-%m-%Y")
stock_senti$date <- as.Date(stock_senti$date, format = "%d-%m-%Y")

stock_senti <- stock %>% left_join(stock_senti, by = "date")
stock_senti <- stock_senti[-c(8:12)]
stock_senti$convertvalue[is.na(stock_senti$convertvalue)]<-'neutral'

write.csv(stock_senti, "dufu_all.csv")
