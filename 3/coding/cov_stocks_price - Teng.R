library(stringr)
library(readr)
library(dplyr)
library(tidyverse)

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

names(stock1)[names(stock1) == 'X5'] <- 'Day1'
names(stock2)[names(stock2) == 'X5'] <- 'Day2'
names(stock3)[names(stock3) == 'X5'] <- 'Day3'
names(stock4)[names(stock4) == 'X5'] <- 'Day4'
names(stock5)[names(stock5) == 'X5'] <- 'Day5'
names(stock6)[names(stock6) == 'X5'] <- 'Day6'
names(stock7)[names(stock7) == 'X5'] <- 'Day7'
names(stock8)[names(stock8) == 'X5'] <- 'Day8'
names(stock9)[names(stock9) == 'X5'] <- 'Day9'
names(stock10)[names(stock10) == 'X5'] <- 'Day10'
names(stock11)[names(stock11) == 'X5'] <- 'Day11'
names(stock12)[names(stock12) == 'X5'] <- 'Day12'
names(stock13)[names(stock13) == 'X5'] <- 'Day13'


stock1 <- subset(stock1, select = c("X2","Day1"))
stock2 <- subset(stock2, select = c("X2","Day2"))
stock3 <- subset(stock3, select = c("X2","Day3"))
stock4 <- subset(stock4, select = c("X2","Day4"))
stock5 <- subset(stock5, select = c("X2","Day5"))
stock6 <- subset(stock6, select = c("X2","Day6"))
stock7 <- subset(stock7, select = c("X2","Day7"))
stock8 <- subset(stock8, select = c("X2","Day8"))
stock9 <- subset(stock9, select = c("X2","Day9"))
stock10 <- subset(stock10, select = c("X2","Day10"))
stock11 <- subset(stock11, select = c("X2","Day11"))
stock12 <- subset(stock12, select = c("X2","Day12"))
stock13 <- subset(stock13, select = c("X2","Day13"))


stocks<-list(stock1, stock2, stock3,stock4,stock5, stock6, stock7,stock8,stock9, stock10, stock11,stock12,stock13) %>% reduce(full_join, by = "X2")

names(stocks)[names(stocks) == 'X2'] <- 'Stock_Name'
stocks[is.na(stocks)] <- 0
stocks_transpose<-data.frame(t(stocks))
names(stocks_transpose) <- as.matrix(stocks_transpose[1, ])
stocks_transpose <- as.data.frame(stocks_transpose[-1, ])

range.names = names(stocks_transpose)
stocks_transpose <- data.frame(lapply(stocks_transpose, function(x) as.numeric(as.character(x))))
covmatrix = matrix(c(cov(stocks_transpose)), nrow=1933, ncol=1933)
dimnames(covmatrix) <-  list(range.names, range.names)

#Covariance matrix
covmatrix
write.csv(covmatrix, file = "covmatrix_Leo.csv")
#write.csv(stocks,file="stocks.csv")
