#Description: A "fancy" way to get a projection you "like".
############# Trend forecast using the trend between months you select and forecasting forward using that trend.
#Comments: Requires monthly time series data. Start and end are formatted as such YYYYMM so Aug. 2015 is 201508.

customTrend<-function(data,h=24,start=0,end=0,fcastOnly=FALSE){
  if(start==0 & end==0)
  {
    sYear=as.numeric(substr(data$months,1,4))
    sMonth=as.numeric(substr(data$months,5,6))
    xTs=ts(data$x,start=c(sYear,sMonth),frequency=12)
  }else
  {
    sYear=as.numeric(substr(start,1,4))
    sMonth=as.numeric(substr(start,5,6))
    xTs=ts(data$x[data$months>=start & data$months<=end],start=c(sYear,sMonth),frequency=12)
  }
  tempVar=data$x
  
  xTrendTotal=tslm(xTs~trend)
  xTotalCoefs=xTrendTotal$coefficients
  rateTotal=round(xTotalCoefs[2],0)
  
  fcastValues=fcastDates=rep(0,h)
  index=1
  for(k in 1:h)
  {
    if(k==1)
    {
      if(as.numeric(substr(data$months[length(data$months)],5,6))==12)
      {
        year=as.numeric(substr(data$months[length(data$months)],1,4))+1
        fcastDates[index]=as.numeric(paste(year,"01",sep=""))
      }else
      {
        year=substr(data$months[length(data$months)],1,4)
        month=as.numeric(substr(data$months[length(data$months)],5,6))+1
        if(as.numeric(substr(data$months[length(data$months)],5,6))<9)
        {
          fcastDates[index]=as.numeric(paste(year,"0",month,sep=""))
        }else
        {
          fcastDates[index]=as.numeric(paste(year,month,sep=""))
        }
      }
    }else
    {
      temp=as.numeric(fcastDates[index-1])
      if(as.numeric(substr(temp,5,6))==12)
      {
        year=as.numeric(substr(temp,1,4))+1
        fcastDates[index]=as.numeric(paste(year,"01",sep=""))
      }else
      {
        year=substr(temp,1,4)
        month=as.numeric(substr(temp,5,6))+1
        if(as.numeric(substr(temp,5,6))<9)
        {
          fcastDates[index]=as.numeric(paste(year,"0",month,sep=""))
        }else
        {
          fcastDates[index]=as.numeric(paste(year,month,sep=""))
        }
      }
    }
    
    if(k==1)
    {
      fcastValues[index]=as.numeric(tempVar[length(tempVar)])+rateTotal
    }
    else
    {
      temp=index-1
      fcastValues[index]=fcastValues[temp]+rateTotal
    }
    
    index=index+1
    
  }
  
  fcast=data.frame(months=fcastDates,x=fcastValues,stringsAsFactors = FALSE)
  if(fcastOnly)
  {
    out=data.frame(rbind(data[length(data$months),],fcast),stringsAsFactors = FALSE)
    return(out)
  }
  else
  {
    out=data.frame(rbind(data,fcast),stringsAsFactors = FALSE)
    return(out)
  }
}