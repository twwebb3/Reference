# Finds best predicting features out of a list of 9 using a grid search.
# Logistic regression is the predictive model in use.
# bestMetric allows one to optimize for metrics other than accuracy.

# Issues:
# Needs to be more dynamic (i.e. allow for a list of potential features with varying length)
# Eventually needs to allow for more models than just logit, based on user input.
# Needs to be wrapped in a function that returns a data frame?

library(arrangements)

# Predictor list
x<-c("Var1","Var2","Var3","Var4","Var5","Var6","Var7",
     "Var8","Var9")
y=rep(1,length(x))

# Sets a minimum accuracy threshold, useful when optimizing for other metrics
desiredAcc=0

offerAccuracy=0
bestVars=""
index=0

# Metric to optimize for, currently is accuracy.
bestMetric<-function(conf2){
  # Catches errors (i.e. when a model predicts only one outcome for all observations the below won't work)
  tryCatch({
    y=(conf2[2,2]+conf2[1,1])/sum(conf2)
    return(y)
  }, error=function(e){
    return(0)
  })
}

accuracy<-function(conf){
  tryCatch({
    z=(conf[2,2]+conf[1,1])/sum(conf)
    return(z)
  }, error=function(e){
    return(0)
  })
}


#All combos of 9 variables
K=as.data.frame(combinations(x=x,freq=y,k=9),stringsAsFactors = FALSE)
#Grid search
for(i in 1:length(K$V1))
{
  model<-glm(target~eval(as.symbol(K$V1[i]))+eval(as.symbol(K$V2[i]))+eval(as.symbol(K$V3[i]))+eval(as.symbol(K$V4[i]))+eval(as.symbol(K$V5[i]))+eval(as.symbol(K$V6[i]))+eval(as.symbol(K$V7[i]))+eval(as.symbol(K$V8[i]))+eval(as.symbol(K$V9[i])),family=binomial(link="logit"),data=train)
  preds<-predict(model,newdata = test,type='response')
  preds<-ifelse(preds>=0.5,1,0)
  conf2<-table(test_labels,preds)
  
  if(bestMetric(conf2)>sum(offerAccuracy[index]) & accuracy(conf2)>=desiredAcc)
  {
    index=index+1
    offerAccuracy[index]=bestMetric(conf2)
    bestVars[index]=paste(K[i,],collapse="+")
    print(offerAccuracy[index])
  }
}
i

K=as.data.frame(combinations(x=x,freq=y,k=8),stringsAsFactors = FALSE)
for(i in 1:length(K$V1))
{
  model<-glm(target~eval(as.symbol(K$V1[i]))+eval(as.symbol(K$V2[i]))+eval(as.symbol(K$V3[i]))+eval(as.symbol(K$V4[i]))+eval(as.symbol(K$V5[i]))+eval(as.symbol(K$V6[i]))+eval(as.symbol(K$V7[i]))+eval(as.symbol(K$V8[i])),family=binomial(link="logit"),data=train)
  preds<-predict(model,newdata = test,type='response')
  preds<-ifelse(preds>=0.5,1,0)
  conf2<-table(test_labels,preds)
  
  if(bestMetric(conf2)>sum(offerAccuracy[index]) & accuracy(conf2)>=desiredAcc)
  {
    index=index+1
    offerAccuracy[index]=bestMetric(conf2)
    bestVars[index]=paste(K[i,],collapse="+")
    print(offerAccuracy[index])
  }
}
i

K=as.data.frame(combinations(x=x,freq=y,k=7),stringsAsFactors = FALSE)
for(i in 1:length(K$V1))
{
  model<-glm(target~eval(as.symbol(K$V1[i]))+eval(as.symbol(K$V2[i]))+eval(as.symbol(K$V3[i]))+eval(as.symbol(K$V4[i]))+eval(as.symbol(K$V5[i]))+eval(as.symbol(K$V6[i]))+eval(as.symbol(K$V7[i])),family=binomial(link="logit"),data=train)
  preds<-predict(model,newdata = test,type='response')
  preds<-ifelse(preds>=0.5,1,0)
  conf2<-table(test_labels,preds)
  
  if(bestMetric(conf2)>sum(offerAccuracy[index]) & accuracy(conf2)>=desiredAcc)
  {
    index=index+1
    offerAccuracy[index]=bestMetric(conf2)
    bestVars[index]=paste(K[i,],collapse="+")
    print(offerAccuracy[index])
  }
}
i

K=as.data.frame(combinations(x=x,freq=y,k=6),stringsAsFactors = FALSE)
for(i in 1:length(K$V1))
{
  model<-glm(target~eval(as.symbol(K$V1[i]))+eval(as.symbol(K$V2[i]))+eval(as.symbol(K$V3[i]))+
               eval(as.symbol(K$V4[i]))+eval(as.symbol(K$V5[i]))+eval(as.symbol(K$V6[i])),family=binomial(link="logit"),data=train)
  preds<-predict(model,newdata = test,type='response')
  preds<-ifelse(preds>=0.5,1,0)
  conf2<-table(test_labels,preds)
  
  if(bestMetric(conf2)>sum(offerAccuracy[index]) & accuracy(conf2)>=desiredAcc)
  {
    index=index+1
    offerAccuracy[index]=bestMetric(conf2)
    bestVars[index]=paste(K[i,],collapse="+")
    print(offerAccuracy[index])
  }
}
i

K=as.data.frame(combinations(x=x,freq=y,k=5),stringsAsFactors = FALSE)
for(i in 1:length(K$V1))
{
  model<-glm(target~eval(as.symbol(K$V1[i]))+eval(as.symbol(K$V2[i]))+eval(as.symbol(K$V3[i]))+
               eval(as.symbol(K$V4[i]))+eval(as.symbol(K$V5[i])),family=binomial(link="logit"),data=train)
  preds<-predict(model,newdata = test,type='response')
  preds<-ifelse(preds>=0.5,1,0)
  conf2<-table(test_labels,preds)
  
  if(bestMetric(conf2)>sum(offerAccuracy[index]) & accuracy(conf2)>=desiredAcc)
  {
    index=index+1
    offerAccuracy[index]=bestMetric(conf2)
    bestVars[index]=paste(K[i,],collapse="+")
    print(offerAccuracy[index])
  }
}
i

K=as.data.frame(combinations(x=x,freq=y,k=4),stringsAsFactors = FALSE)
for(i in 1:length(K$V1))
{
  model<-glm(target~eval(as.symbol(K$V1[i]))+eval(as.symbol(K$V2[i]))+eval(as.symbol(K$V3[i]))+eval(as.symbol(K$V4[i])),family=binomial(link="logit"),data=train)
  preds<-predict(model,newdata = test,type='response')
  preds<-ifelse(preds>=0.5,1,0)
  conf2<-table(test_labels,preds)
  
  if(bestMetric(conf2)>sum(offerAccuracy[index]) & accuracy(conf2)>=desiredAcc)
  {
    index=index+1
    offerAccuracy[index]=bestMetric(conf2)
    bestVars[index]=paste(K[i,],collapse="+")
    print(offerAccuracy[index])
  }
}
i

K=as.data.frame(combinations(x=x,freq=y,k=3),stringsAsFactors = FALSE)
for(i in 1:length(K$V1))
{
  model<-glm(target~eval(as.symbol(K$V1[i]))+eval(as.symbol(K$V2[i]))+eval(as.symbol(K$V3[i])),family=binomial(link="logit"),data=train)
  preds<-predict(model,newdata = test,type='response')
  preds<-ifelse(preds>=0.5,1,0)
  conf2<-table(test_labels,preds)
  
  if(bestMetric(conf2)>sum(offerAccuracy[index]) & accuracy(conf2)>=desiredAcc)
  {
    index=index+1
    offerAccuracy[index]=bestMetric(conf2)
    bestVars[index]=paste(K[i,],collapse="+")
    print(offerAccuracy[index])
  }
}
i

K=as.data.frame(combinations(x=x,freq=y,k=2),stringsAsFactors = FALSE)
for(i in 1:length(K$V1))
{
  model<-glm(target~eval(as.symbol(K$V1[i]))+eval(as.symbol(K$V2[i])),family=binomial(link="logit"),data=train)
  preds<-predict(model,newdata = test,type='response')
  preds<-ifelse(preds>=0.5,1,0)
  conf2<-table(test_labels,preds)
  
  if(bestMetric(conf2)>sum(offerAccuracy[index]) & accuracy(conf2)>=desiredAcc)
  {
    index=index+1
    offerAccuracy[index]=bestMetric(conf2)
    bestVars[index]=paste(K[i,],collapse="+")
    print(offerAccuracy[index])
  }
}
i


View(data.frame(offerAccuracy,bestVars))

x<-data.frame(offerAccuracy,bestVars)
write.csv(x,"Best predictors v1.csv",row.names=FALSE)