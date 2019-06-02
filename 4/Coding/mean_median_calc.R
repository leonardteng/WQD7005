library(sentimentr)
library(dplyr)
library(ggplot2)

stock <- read.csv("23_4.csv")
str(stock)
summary_per_stock <- stock %>% group_by(board)%>% summarize(mean(perc_change), median(perc_change))
analyzed <- stock %>% select(stock.code, board, perc_change, count, comments, volume)
analyzed[analyzed==""] <- NA
analyzed <- na.omit(analyzed)
analyzed <- get_sentences(analyzed)
sen_analyzed <- sentiment(analyzed)
str(sen_analyzed)
#sen_analyzed_2 <- sen_analyzed %>% filter(grepl("Technology", board )) %>% group_by(stock.code) %>% summarize(mean(perc_change), mean(sentiment), mean(count))
sen_analyzed_2 <- sen_analyzed %>% group_by(stock.code) %>% summarize(mean(perc_change), mean(sentiment), mean(count))

names(sen_analyzed_2)[1] <-"stock_code"
names(sen_analyzed_2)[2] <-"per_change"
names(sen_analyzed_2)[3] <-"sentiment"
names(sen_analyzed_2)[4] <-"count"

sen_analyzed_2 <-  sen_analyzed_2 %>% filter(sen_analyzed_2$per_change <100) 
str(sen_analyzed_2)
sen_omit <- na.omit(sen_analyzed_2)
summary(sen_omit)
sen_norm <- as.data.frame(apply(sen_omit[,2:3], 2, function(x) (x-min(x))/(max(x)-min(x))))
sen_norm$stock_code <- sen_omit$stock_code
sen_norm$count <- sen_omit$count
#str(sen_analyzed_2_norm)
#summary(sen_analyzed_2_norm)
#sen_analyzed_2$perc_change <- normalize(sen_analyzed_2$per_change, method = "standardize", range = c(0, 1), margin = 1L, on.constant = "quiet")
#sen_analyzed_2$per_change <- scale(sen_analyzed_2$per_change)

sen_norm_score_low <- sen_norm %>% filter(sentiment < 0.24)

ggplot() + 
  geom_point(data=sen_norm_score_low, aes(x=stock_code, y= per_change), color ="red") +
  geom_point(data=sen_norm_score_low,  aes(x=stock_code, y= sentiment), color ="blue")

sen_norm_count <- sen_omit %>% filter(count > 0)

ggplot() + 
  geom_point(data=sen_norm_count, aes(x=stock_code, y= per_change), color ="red")+
  geom_point(data=sen_norm_count,  aes(x=stock_code, y= count), color ="blue")

