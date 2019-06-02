library(quantmod)
library(lubridate)
library(e1071)
library(rpart)
library(rpart.plot)
library(ROCR)

stock <- read.csv("sapura_all.csv")
#Calculate a 3-period relative strength index (RSI) off the open price
RSI <- RSI(stock$Open, n = 3)
EMA5 <- EMA(stock$Open, n = 5)
EMAcross <- stock$Open - EMA5
MACD <- MACD(stock$Open,
             fast = 12,
             slow = 26,
             signal = 9)
MACD <- MACD[, 2]
#SMI <- SMI(stock$Open, n = 10, slow = 25, fast = 2, signal = 9)
#Grab just the oscillator to use as our indicator
#SMI <- SMI[,1]
#Williams %R with standard parameters
WPR <- WPR(stock$Price, n = 14)
WPR <- WPR[,1]
#Average Directional Index with standard parameters
ADX <- ADX(stock[, c("High","Low","Price")], n=14)
ADX <- ADX[,1]
#Commodity Channel Index with standard parameters
CCI <- CCI(stock$Price, n=14)
CCI <- CCI[, 1]
#Collateral Mortgage Obligation with standard parameters
CMO <- CMO(stock$Price, n=14)
#CMO <- CMO[,1]
#Collateralized Mortgage Obligation with standard parameters
ROC <- ROC(stock$Price, n = 2)
#ROC <- ROC[,1]
new_dataset <- data.frame(stock, RSI, EMAcross, MACD, WPR, ADX, CCI, CMO, ROC)
write.csv(new_dataset,"sapura_2.csv")
