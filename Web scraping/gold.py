"""
Created on Mon Sep 28 10:19:51 2020
@author: toyosibamidele
"""

import requests as r
import time
import json
import pandas as pd
import datetime as dt
from pandas.io.json import json_normalize
import matplotlib.pyplot as plt
from matplotlib import style
style.use('ggplot')

#file path
path = '/users/xxxxxxxxxxxx/Desktop/'

#url to post
action_postURL = 'https://www.bullionstar.com/widget/generator/line/generate/chartsData'
# use get to pull cookies information
res = r.get(action_postURL)

cleaned_gold = "gold_clean.csv"

res.status_code
res.headers['content-type']
res.encoding
res.text
res.content
time.sleep(5)
res.cookies

#Get the Cookies
search_cookies = res.cookies

#post method data
post_data = {'method':'POST',"product":"false","productId":"0","productTo":"false","productIdTo":"0",
             "fromIndex":"XAU" ,"toIndex":"BRL","period":"CUSTOM","weightUnit":"tr_oz",
             "width":"600", "height":"300","timeZoneId": "America/Chicago","fromDateString":"01-01-2019 00:00","toDateString":"28-09-2020 00:00"}

#headers information
headers = {'user-agent': "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36"}

#request post data
res_post = r.post(action_postURL, data=post_data, cookies=search_cookies, headers = headers)

#pull data into  json format
values = res_post.json()

#normalize data with Brazilian gold values 
gold_values = res_post.json()["dataSeries"]
df = json_normalize(gold_values)


gold_price = pd.DataFrame(df)
