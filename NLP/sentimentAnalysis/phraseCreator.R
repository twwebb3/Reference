#This function extracts phrases from comments.
#One simply passes a data frame and the name of the column with comments to be parsed into phrases.
#Words, or "tokens", are returned from the comments as well.

phraseCreator<-function(df,commentCol){
  library(dplyr)
  library(tidytext)
  
  df$key<-1:length(df[[commentCol]])
  
  tidy_df<-unnest_tokens_(df,"word",commentCol)
  
  tidy_df$key2<-1:length(tidy_df$word)
  temp<-select(tidy_df,key,key2,word)
  temp$key2<-temp$key2-1
  
  out<-left_join(tidy_df,temp,by=c("key"="key","key2"="key2"))
  
  out$phrase<-paste(out$word.x,out$word.y,sep=" ")
  out$key<-NULL
  out$key2<-NULL
  
  return(out)
}