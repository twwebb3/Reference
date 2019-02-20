#This function allows one to present the time for which it takes R to complete a given task.
#One simply creates a "start" variable using proc.time() before the code used to complete the task,
#then passes the "start" variable to the function below the code used to complete the task.


timeLength<-function(start){
  x=proc.time()-start
  y=as.integer(x[3]/60)
  z=((x[3]/60)-y)*60
  g=paste(y,"minutes",z,"seconds",sep=" ")
  return(g)
}



start=proc.time()
j=0
for(i in 1:100000000)
{
  j=j+1
}
print(format(j,big.mark = ',',scientific = FALSE))
timeLength(start = start)