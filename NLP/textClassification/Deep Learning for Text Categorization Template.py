# -*- coding: utf-8 -*-
"""
Created on Thu Sep 20 10:20:20 2018

Mostly from Francois Chollet:
https://github.com/fchollet/deep-learning-with-python-notebooks


@author: TWEBB
"""

import pandas as pd
import numpy as np
import os

from keras.preprocessing.text import Tokenizer
from keras.preprocessing.sequence import pad_sequences
from keras.models import Sequential
from keras.layers import Dense, Embedding, Flatten
from keras.utils.np_utils import to_categorical

os.chdir('') # insert path to file folder here

data=pd.read_csv('Properly Sorted.csv')

np.shape(data)
data.head()

categories=data.Category.unique()
index=[i for i in range(0,10)]

numericCats=pd.DataFrame({'Category':categories,'numeric_categories':index})

data=pd.merge(data,numericCats,how='left',on='Category')

comments=np.array(data.Comment)

np.random.seed(123)
maxlen = 500
training_samples = 200
validation_samples = len(comments) - training_samples
max_words=5000

tokenizer = Tokenizer(num_words=max_words)
tokenizer.fit_on_texts(comments)
sequences = tokenizer.texts_to_sequences(comments)

word_index = tokenizer.word_index
print('Found %s unique tokens.' % len(word_index))

data2 = pad_sequences(sequences, maxlen=maxlen)

labels = np.asarray(data.numeric_categories)
print('Shape of data tensor:', data2.shape)
print('Shape of label tensor:', labels.shape)

indices = np.arange(data2.shape[0])
np.random.shuffle(indices)
data2 = data2[indices]
labels = labels[indices]

x_train = data2[:training_samples]
y_train = to_categorical(labels[:training_samples])
x_val = data2[training_samples: training_samples + validation_samples]
y_val = to_categorical(labels[training_samples: training_samples + validation_samples])


glove_dir=r""      #insert path to glove file folder here

embeddings_index = {}
f = open(os.path.join(glove_dir, 'glove.6B.100d.txt'), encoding="utf8")
for line in f:
    values = line.split()
    word = values[0]
    coefs = np.asarray(values[1:], dtype='float32')
    embeddings_index[word] = coefs
f.close()

print('Found %s word vectors.' % len(embeddings_index))

embedding_dim = 100

embedding_matrix = np.zeros((max_words, embedding_dim))
for word, i in word_index.items():
    if i < max_words:
        embedding_vector = embeddings_index.get(word)
        if embedding_vector is not None:
            embedding_matrix[i] = embedding_vector

from keras.layers import LSTM

model = Sequential()
model.add(Embedding(max_words, 32))#, embedding_dim, input_length = maxlen))
#model.add(Flatten())
model.add(LSTM(32))
model.add(Dense(32, activation = 'relu'))
#model.add(Dense(24, activation='relu'))
model.add(Dense(11, activation='softmax'))

model.compile(optimizer='rmsprop',
              loss='categorical_crossentropy',
              metrics=['accuracy'])

model.fit(x_train,y_train,epochs=20,batch_size=128,validation_data=(x_val,y_val))
