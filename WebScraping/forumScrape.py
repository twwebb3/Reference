# -*- coding: utf-8 -*-
"""
Created on Tue May  1 14:57:56 2018
Scrapes comments from forums on the web. Returns a pandas dataframe containing
username, comment, post title, and the date each comment was made.
Known issues: When a comment that is a reply to another comment is pulled that
particular row contains the comment that is being replied to as well. There
doesn't appear an obvious way around grabbing the additional comment via bs4
and html tokens. Not a major issue as it can be dealt with when doing the NLP.
@author: twebb
"""

def forumScrape(url,urlBase):
    import pandas as pd
    from bs4 import BeautifulSoup
    import requests

    r=requests.get(url)
    html_doc=r.text

    soup=BeautifulSoup(html_doc,"lxml")
    r.close()

    username=[]
    date=[]
    postTitle=[]
    userNameCount=0
    dateCount=0
    for link in soup.find_all('a'):
        if link.get('class')!=None:
            if ['username']==link.get('class'):
                if link.get('itemprop')=='name':
                    #print(link.get_text())
                    #print(link.prettify())
                    userNameCount += 1
                    username.append(link.get_text())
                    postTitle.append(soup.find_all('title')[0].get_text())
            if link.get('class')==['datePermalink']:
                date.append(link.get_text())
                dateCount += 1

    #print('Usernames: '+str(userNameCount))
    #print('Dates: '+str(dateCount))

    count2=0
    comments=[]
    for link in soup.find_all('blockquote'):
        if link.get('class')!=['quoteContainer']:
            comments.append(link.get_text())
            count2 +=1
    #print(count2)

    for i in range(500):
        x=""
        for link in soup.find_all('a'):
            if link.get_text()=="Next >":
                #print(link.get('href'))
                x=link.get('href')
        if x=="":
            break
        url=str(urlBase)+x

        r=requests.get(url)
        html_doc=r.text

        soup=BeautifulSoup(html_doc,"lxml")
        r.close()
        for link in soup.find_all('a'):
            if link.get('class')!=None:
                if ['username']==link.get('class'):
                    if link.get('itemprop')=='name':
                        #print(link.get_text())
                        #print(link.prettify())
                        userNameCount += 1
                        username.append(link.get_text())
                        postTitle.append(soup.find_all('title')[0].get_text())
                if link.get('class')==['datePermalink']:
                    date.append(link.get_text())
                    dateCount += 1

        #print('Usernames: '+str(userNameCount))
        #print('Dates: '+str(dateCount))
        for link in soup.find_all('blockquote'):
            if link.get('class')!=['quoteContainer']:
                comments.append(link.get_text())
                count2 +=1

    comments=[c.replace('\t','') for c in comments]
    comments=[c.replace('\n','') for c in comments]
    comments=[c.replace('\r','') for c in comments]
    #print(comments)

    output=pd.DataFrame({'postTitle':postTitle,
                         'comments':comments,
                         'date':date,
                         'username':username})

    return(output)
