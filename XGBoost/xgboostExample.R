

setwd("C:/Users/twebb/Desktop/occupancy")

train<-read.csv("datatraining.txt",stringsAsFactors = F)
head(train)
count(train,Occupancy)

library(lubridate)
library(dplyr)

train$time<-strftime(as.Date(train$date),format = "%H:%M:%S")
train %>% head()

train %>% group_by(date) %>% summarise(occupancy=sum(Occupancy)) %>% nrow()

train2=na.omit(train)
model1<-glm(Occupancy~Temperature+Humidity+Light+CO2+HumidityRatio,family=binomial(link="logit"),data=train2)
summary(model1)
summary(train)
sum(is.na(train$CO2))


test1<-read.csv("datatest.txt",stringsAsFactors = F)

test1$predOccupancy=predict(model1,test1)
test1$predCat<-0
test1$predCat[test1$predOccupancy>=0.5]<-1

conf<-table(test1$Occupancy,test1$predCat)
(conf[1,1]+conf[2,2])/sum(conf)

library(xgboost)

train_data=as.matrix(train[,c(2:6)])
train_labels=as.matrix(train$Occupancy)

dtrain <-xgb.DMatrix(data=train_data, label=train_labels)

model2 <- xgboost(data=dtrain,
                  max.depth = 2,
                  nround=10,
                  early_stopping_rounds = 3,
                  objective = "binary:logistic")

test_data=as.matrix(test1[,c(2:6)])
test_labels=as.matrix(test1$Occupancy)

dtest <-xgb.DMatrix(data=test_data, label=test_labels)

pred <- predict(model2, dtest)
predCat<-ifelse(pred>=0.5,1,0)
conf<-table(predCat,test_labels)
conf
(conf[1,1]+conf[2,2])/sum(conf)