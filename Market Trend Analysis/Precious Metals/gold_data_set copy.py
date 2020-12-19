#!/usr/bin/env python3
# -*- coding: utf-8 -*-
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
path = '/users/toyosibamidele/Desktop/'

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

gold_price = gold_price.drop(["d"], axis = 1)

gold_price.rename(columns = {'v' : "Gold Price per tr oz"}, inplace = True)

#create date range for  Brazilian gold values
date_check = pd.date_range (start = '01-01-2019', end ='28-09-2020')
date_value = pd.DataFrame(date_check)

gold_price["Date"] = date_value
gold_price["Country"] = "Brazil"

#check for null values 
gold_price.info()

#extract needed dates for brazilain dates 
start_day = '01-01-2019'
end_day = '09-11-2020'

after_start_day = gold_price["Date"] >= start_day
before_end_day = gold_price["Date"] <= end_day
between_two_days = after_start_day & before_end_day
brazil_gold = gold_price.loc[between_two_days]

brazil_gold.info()

#################read in part1 gold data with other countries##########################
part1_gold = pd.read_csv("part1_gold.csv")
#change date column to datetime type 
part1_gold['Name'] = part1_gold['Name'].astype('datetime64[ns]') 

#rename date column 
part1_gold.rename(columns = {'Name' : "Date"}, inplace = True)
part1_gold

#drop rows with ALL NA values 
gold_prices = part1_gold.dropna(how = "all")
#extract date values needed for merging 
start_date = '01-01-2019'
end_date = '09-11-2020'

after_start_date = gold_prices["Date"] >= start_date
before_end_date = gold_prices["Date"] <= end_date
between_two_dates = after_start_date & before_end_date
filtered_date = gold_prices.loc[between_two_dates]

filtered_date.columns
filtered_date.rename(columns = {'Indian' : "India"}, inplace = True)
filtered_date.rename(columns = {'United states' : "United States"}, inplace = True)


filtered_date = filtered_date.reset_index()
filtered_date['Date'] =pd.to_datetime(filtered_date['Date'], format='%m/%d/%Y')
filtered_dates= filtered_date.sort_values(by=['Date'], ascending=[True])
filtered_dates.set_index('Date', inplace=True)
filtered_date.info()

filtered_dates = filtered_dates.resample('D').ffill().reset_index()


final_goldp1 = pd.melt(filtered_dates, id_vars='Date', value_vars=['Canada','China','France','Germany','India','Italy','Japan','United Kingdom','United States'])



final_goldp1.rename(columns = {'variable' : "Country"}, inplace = True)
final_goldp1.rename(columns = {'value' : "Gold Price per tr oz"}, inplace = True)
final_goldp1.info() # not ok , Price is of object type, instead of float 

#remove comma from price string  and change to type float
final_goldp1['Gold Price per tr oz'] = final_goldp1['Gold Price per tr oz'].str.replace(',', "").astype(float)

final_gold = pd.concat([final_goldp1,brazil_gold], sort = True, ignore_index = True)


final_gold.info()


final_gold.to_csv(path + cleaned_gold)













