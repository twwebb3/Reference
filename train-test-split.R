# Divides data into train and test sets

# Issues:
# Functions can't return multiple objects.
# Create a class?

set.seed(123)
smp_size=round(nrow(df)*.8,0)

trainIndex<-sample(seq_len(nrow(df)),size=smp_size)

train<-df[trainIndex,]
test<-df[-trainIndex,]