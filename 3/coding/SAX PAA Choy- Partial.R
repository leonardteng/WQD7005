#install all the packages required
install.packages("stringr")
install.packages("readr")
install.packages("dplyr")
install.packages("tidyverse")
install.packages("ggplot")
install.packages("reshape")
install.packages("devtools")
install_github('jMotif/jmotif-R')

#once all are installed, open the library
library(stringr)
library(readr)
library(dplyr)
library(tidyverse)
library(ggplot2)
library(reshape)
library(devtools)
library(jmotif)

##################DATA CLEANING########################

#insert all the stocks text file
stock1 <- read_delim("stock_20190303.txt","|", escape_double = FALSE, col_names = FALSE, trim_ws = TRUE)
stock2 <- read_delim("stock_20190304.txt","|", escape_double = FALSE, col_names = FALSE, trim_ws = TRUE)
stock3 <- read_delim("stock_20190305.txt","|", escape_double = FALSE, col_names = FALSE, trim_ws = TRUE)
stock4 <- read_delim("stock_20190306.txt","|", escape_double = FALSE, col_names = FALSE, trim_ws = TRUE)
stock5 <- read_delim("stock_20190307.txt","|", escape_double = FALSE, col_names = FALSE, trim_ws = TRUE)
stock6 <- read_delim("stock_20190308.txt","|", escape_double = FALSE, col_names = FALSE, trim_ws = TRUE)
stock7 <- read_delim("stock_20190311.txt","|", escape_double = FALSE, col_names = FALSE, trim_ws = TRUE)
stock8 <- read_delim("stock_20190312.txt","|", escape_double = FALSE, col_names = FALSE, trim_ws = TRUE)
stock9 <- read_delim("stock_20190313.txt","|", escape_double = FALSE, col_names = FALSE, trim_ws = TRUE)
stock10 <- read_delim("stock_20190314.txt","|", escape_double = FALSE, col_names = FALSE, trim_ws = TRUE)
stock11 <- read_delim("stock_20190315.txt","|", escape_double = FALSE, col_names = FALSE, trim_ws = TRUE)
stock12 <- read_delim("stock_20190318.txt","|", escape_double = FALSE, col_names = FALSE, trim_ws = TRUE)
stock13 <- read_delim("stock_20190319.txt","|", escape_double = FALSE, col_names = FALSE, trim_ws = TRUE)

#rename the column 5 header
names(stock1)[names(stock1) == 'X5'] <- 1
names(stock2)[names(stock2) == 'X5'] <- 2
names(stock3)[names(stock3) == 'X5'] <- 3
names(stock4)[names(stock4) == 'X5'] <- 4
names(stock5)[names(stock5) == 'X5'] <- 5
names(stock6)[names(stock6) == 'X5'] <- 6
names(stock7)[names(stock7) == 'X5'] <- 7
names(stock8)[names(stock8) == 'X5'] <- 8
names(stock9)[names(stock9) == 'X5'] <- 9
names(stock10)[names(stock10) == 'X5'] <- 10
names(stock11)[names(stock11) == 'X5'] <- 11
names(stock12)[names(stock12) == 'X5'] <- 12
names(stock13)[names(stock13) == 'X5'] <- 13

#remove the rest of the column 
#by replacing the subset that only have selected column
stock1 <- subset(stock1, select = c("X2",1))
stock2 <- subset(stock2, select = c("X2",2))
stock3 <- subset(stock3, select = c("X2",3))
stock4 <- subset(stock4, select = c("X2",4))
stock5 <- subset(stock5, select = c("X2",5))
stock6 <- subset(stock6, select = c("X2",6))
stock7 <- subset(stock7, select = c("X2",7))
stock8 <- subset(stock8, select = c("X2",8))
stock9 <- subset(stock9, select = c("X2",9))
stock10 <- subset(stock10, select = c("X2",10))
stock11 <- subset(stock11, select = c("X2",11))
stock12 <- subset(stock12, select = c("X2",12))
stock13 <- subset(stock13, select = c("X2",13))

#join the stock files by the stock name, X2
stocks<-list(stock1, stock2, stock3,stock4,stock5, stock6, stock7,stock8,stock9, stock10, stock11,stock12,stock13) %>% reduce(full_join, by = "X2")

#replace the column name X2 as Days
names(stocks)[names(stocks) == 'X2'] <- 'Days'

#make sure all the value shown inside are numeric
stocks$`1`<-as.numeric(stocks$`1`)
stocks$`2`<-as.numeric(stocks$`2`)
stocks$`3`<-as.numeric(stocks$`3`)
stocks$`4`<-as.numeric(stocks$`4`)
stocks$`5`<-as.numeric(stocks$`5`)
stocks$`6`<-as.numeric(stocks$`6`)
stocks$`7`<-as.numeric(stocks$`7`)
stocks$`8`<-as.numeric(stocks$`8`)
stocks$`9`<-as.numeric(stocks$`9`)
stocks$`10`<-as.numeric(stocks$`10`)
stocks$`11`<-as.numeric(stocks$`11`)
stocks$`12`<-as.numeric(stocks$`12`)
stocks$`13`<-as.numeric(stocks$`13`)

#make sure all the classes required are numeric
str(stocks)

#check is there any NA in the data frame
sum(is.na(stocks))

#replace all the NA with 0
stocks[is.na(stocks)] <- 0

#check again, make sure it is 0
sum(is.na(stocks))

#calculate the sum value of day 1 to day 13 by row
stocks$Total<-rowSums(stocks[, -1])

#remove the stocks if the total sum is 0
#by replacing the data framw where only more than 0 are kept
stocks <- stocks %>% filter(Total!=0)

#create a csv file of the combined stocks
write.csv(stocks,file="stocks.csv")

##################Euclidean Distance########################

#import the stock file (optional)
stocks <- read_csv("stocks.csv")

#duplicate the stock files
stock_test2 <- stocks

#remove the first column X1 and second column stock name
stocker2 <- stock_test2[-c(1:2)]

#replace the row name with the stock name (column title is Days)
row.names(stocker2) <- stock_test2$Days

#again, make sure all the column are numeric to perform euclidean distance
str(stocker2)

#start to calculate the euclidean
x<-dist(stocker2, method = "euclidean")

#convert the output as a matrix then save into csv files
y<-as.matrix(x)
write.csv(y,file="Euclidean.csv")


#stocks_transpose<-data.frame(t(stock_test))

#names(stocks_transpose) <- as.matrix(stocks_transpose[1, ])
#stocks_transpose <- stocks_transpose[-1, ]

#stocks_transpose<-stocks_transpose[-14,]
#stocks_transpose$Days<-seq(1,13)

##################Z-Norm, PAA & SAX########################

#duplicate the stock again but only the first 11 stocks
stock_test <- stocks[1:11,]

#remove the stock name column and rename the rows by stock name
stocker <- stock_test[-c(1:2)]
row.names(stocker) <- stock_test$Days

#transpose the file and save as data frame
#removed the sum row as well
stocker_transpose<-data.frame(t(stocker))
stocker_transpose <- stocker_transpose[-14,]

#Z-normalization function
znorm <- function(ts){
  ts.mean <- mean(ts)
  ts.dev <- sd(ts)
  (ts - ts.mean)/ts.dev
}

#PAA value function
paa <- function(ts, paa_size){
  len = length(ts)
  if (len == paa_size) {
    ts
  }
  else {
    if (len %% paa_size == 0) {
      colMeans(matrix(ts, nrow=len %/% paa_size, byrow=F))
    }
    else {
      res = rep.int(0, paa_size)
      for (i in c(0:(len * paa_size - 1))) {
        idx = i %/% len + 1# the spot
        pos = i %/% paa_size + 1 # the col spot
        res[idx] = res[idx] + ts[pos]
      }
      for (i in c(1:paa_size)) {
        res[i] = res[i] / len
      }
      res
    }
  }
}

#create four empty vector
result <- vector("list")
result2 <-vector("list")
result3 <- vector("list")
result4 <-vector("list")

#create a for loop for Z-normalization and paa that loop across the column name
#the result of Z-normalization is save in result
#the result of paa is save in result2
for(i in names(stocker_transpose)){
  ts1_znorm=znorm(stocker_transpose[[i]])
  result[[i]] <- ts1_znorm
  
  paa_size=3
  y_paa3 = paa(ts1_znorm,paa_size)
  result2[[i]]<-y_paa3

}

#save these both output as data frame
result<-as.data.frame(result)
result2<-as.data.frame(result2)

#transpose both of the result and save as data frame
result_transpose<-as.data.frame(t(result))
result2_transpose<-as.data.frame(t(result2))

#convert data frame into csv file
write.csv(result_transpose,file="result.csv")
write.csv(result2_transpose,file="result2.csv")

#check the maximum value and minimum value in result
# optional as it is to plot a nice range for visualization
max_value<-max(result)
min_value<-min(result)

##################Plot PAA & SAX########################

#Create an empty plot graph first
plot("Value","Days",xlim = c(1,13),ylim=c(-3.5,2.5),type = "n",main="PAA transform")

#create a for loop to plot each across the column name
for (i in names(result)){
  #plot the Z-norm line of each stock
  lines(result[[i]],col = "blue",type = 'o')
  
  #this is to plot the SAX segment, the grey vertical dotted line
  points(result[[i]], pch=16, lwd=5, col="blue")
  abline(v=c(1,5,9,13), lty=3, lwd=2, col="gray50")
  
  #plot the paa value of each stock
  for (j in names(result2)){
    #plot the paa value segment 1
    segments(1,result2[[j]][1],5,result2[[j]][1],lwd=1,col="red")
    points(x=(1+5)/2,y=result2[[j]][1],col="red",pch=23,lwd=5)
    
    #plot the paa value segment 2
    segments(5,result2[[j]][2],9,result2[[j]][2],lwd=1,col="red")
    points(x=(5+9)/2,y=result2[[j]][2],col="red",pch=23,lwd=5)
    
    #plot the paa value segment 3
    segments(9,result2[[j]][3],13,result2[[j]][3],lwd=1,col="red")
    points(x=(9+13)/2,y=result2[[j]][3],col="red",pch=23,lwd=5)
    
    #plot the alphabet letter
    y <- seq(-3.5,2.5, length=100)
    x <- dnorm(y, mean=0, sd=1)
    lines(x,y, type="l", lwd=5, col="magenta")
    abline(h = alphabet_to_cuts(5)[1:9], lty=2, lwd=2, col="magenta")
    text(0.7,-2,"e",cex=2,col="magenta")
    text(0.7,-0.5,"d",cex=2,col="magenta")
    text(0.7, 0,"c",cex=2,col="magenta")
    text(0.7, 0.5,"b",cex=2,col="magenta")
    text(0.7, 2,"a",cex=2,col="magenta")
    
    #save the result of PAA location
    result3[[j]]<-series_to_string(result2[[j]],3)
    result4[[j]]<-series_to_chars(result2[[j]],3)
    
  }

}

#convert the list to data frame
result3<-as.data.frame(result3)
result4<-as.data.frame(result4)

#transpose the data and save as data frame
result3_transpose<-as.data.frame(t(result3))
result4_transpose<-as.data.frame(t(result4))

#convert data frame into csv
write.csv(result3_transpose,file="result3.csv")
write.csv(result4_transpose,file="result4.csv")