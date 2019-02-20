# -*- coding: utf-8 -*-
"""
Created on Wed May 30 14:32:31 2018

@author: TWEBB
"""


import pandas as pd
import numpy as np
import os
import matplotlib.pyplot as plt

from sklearn.model_selection import train_test_split
from sklearn.metrics import confusion_matrix
from sklearn.metrics import accuracy_score
from sklearn.metrics import roc_curve
from sklearn.linear_model import LogisticRegression

os.chdir('F:/Predictive Analytics/Webb/Python/Training')
credit=pd.read_csv('credit.csv',sep=',',header=None)
credit.head()
credit.info()
credit.dtypes
credit=credit.replace('?',np.NaN)
credit=credit.dropna()
credit.info()
credit[1]=pd.to_numeric(credit[1])
credit[13]=pd.to_numeric(credit[13])
credit.info()

credit[[15]]=credit[[15]].replace('+',1)
credit[[15]]=credit[[15]].replace('-',0)

credit.info()

df=credit[[1,2,7,10,13,14,15]]

df.columns=['v1','v2','v3','v4','v5','v6','target']

predictors=df[['v1','v2','v3','v4','v5','v6']]

X_train, X_test, y_train, y_test = train_test_split(predictors,df[['target']],test_size=0.2,random_state=42)

logit=LogisticRegression(fit_intercept=True)
logit.fit(X_train,y_train)
preds=logit.predict(X_test)
accuracy_score(y_test,preds)

conf=confusion_matrix(y_test,preds)
conf

y_pred_prob = logit.predict_proba(X_test)[:,1]

fpr, tpr, thresholds = roc_curve(y_test, y_pred_prob)

plt.plot([0, 1], [0, 1], 'k--')
plt.plot(fpr, tpr)
plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate')
plt.title('ROC Curve')
plt.show()