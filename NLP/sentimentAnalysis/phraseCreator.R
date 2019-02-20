#Updates: Allows user to exclude stop words (i.e. 'I', 'we', 'is', etc.)
#This function extracts phrases from comments.
#One simply passes a data frame and the name of the column with comments to be parsed into phrases.
#Words, or "tokens", are returned from the comments as well.
#Allows up phrase length of up to 3 words.

phraseCreator<-function(df,commentCol,removeStopWords=FALSE,phraseLength=2){
  library(dplyr)
  library(tidytext)
  
  df$temporaryKey<-1:length(df[[commentCol]])
  
  tidy_df<-unnest_tokens_(df,"word",commentCol)
  
  if(removeStopWords)
  {
    x=1
    data("stop_words")
    tidy_df<-tidy_df %>% anti_join(stop_words,by=c("word"="word"))
  }
  
  tidy_df$temporaryKey2<-1:length(tidy_df$word)
  temp<-select(tidy_df,temporaryKey,temporaryKey2,word)
  temp$temporaryKey2<-temp$temporaryKey2-1
  
  out<-left_join(tidy_df,temp,by=c("temporaryKey"="temporaryKey","temporaryKey2"="temporaryKey2"))
  
  if(phraseLength==3)
  {
    temp$temporaryKey2=temp$temporaryKey2-1
    out<-left_join(out,temp,by=c("temporaryKey"="temporaryKey","temporaryKey2"="temporaryKey2"))
    out$phrase<-paste(out$word.x,out$word.y,out$word,sep=" ")
  }else
  {
    out$phrase<-paste(out$word.x,out$word.y,sep=" ")
  }
  
  
  out$temporaryKey<-NULL
  out$temporaryKey2<-NULL
  
  return(out)
}