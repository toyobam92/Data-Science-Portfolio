#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Sep 29 08:14:21 2020

@author: toyosibamidele
"""

import pandas as pd
import csv
import glob
import os
import matplotlib.pyplot as plt

#file path to import
silverpart1 = '/users/toyosibamidele/Desktop/silverpart1/'
silverpart2= '/users/toyosibamidele/Desktop/silverpart2/'

#file path to export 
path = '/users/toyosibamidele/Desktop/'
silver_cleaned = "silver_final_merge.csv"


#loop to import silver csv files and add filename as column
#SILVER PART 1
file_list = []
files_in_dir = [f for f in os.listdir(silverpart1) if f.endswith('csv')]
for filenames in files_in_dir:
    df = pd.read_csv(silverpart1 + filenames)
    df['filenames'] = filenames
    file_list.append(df)
silv1 = pd.concat(file_list, ignore_index=True)
silv1 = silv1[['Date','Price','filenames']]

#SILVER PART 2
file_list2 = []
files_in_dir2 = [f for f in os.listdir(silverpart2) if f.endswith('csv')]
for filenames in files_in_dir2:
    df2 = pd.read_csv(silverpart2+ filenames,header = 1,skipfooter = 1)
    df2['filenames'] = filenames
    file_list2.append(df2)
silv2 = pd.concat(file_list2, ignore_index=True)
silv2 = silv2 [['Date Time','Close','filenames']]

#change table structure from long to wide to be able use ffill function
#SILVER PART1
silv1_c  = silv1.pivot_table(index=["Date"], 
                    columns='filenames', 
                    values='Price')

#SILVER PART2
silv2_c  = silv2.pivot_table(index=["Date Time"], 
                    columns='filenames', 
                    values='Close')


#check for null values
silv1_c.info() # not ok
silv2_c.info() #ok
#rename columns from filename to country 
#SILVER PART 1
silv1_c.columns
silv1_c.rename(columns = {'XAG_CADcopy.csv' : "Canada"}, inplace = True)
silv1_c.rename(columns = {'XAG_EURcopy.csv' : "Europe"}, inplace = True)
silv1_c.rename(columns = {'XAG_GBPcopy.csv' : "United Kingdom"}, inplace = True)
silv1_c.rename(columns = {'XAG_USDcopy.csv' : "United States"}, inplace = True)
#SILVER PART 2
silv2_c.columns
silv2_c.rename(columns = {'XAG_BRL_B copy.csv' : "Brazil"}, inplace = True)
silv2_c.rename(columns = {'XAG_CNY_B copy.csv' : "China"}, inplace = True)
silv2_c.rename(columns = {'XAG_INR_B copy.csv' : "India"}, inplace = True)
silv2_c.rename(columns = {'XAG_JPY_B copy.csv' : "Japan"}, inplace = True)
silv2_c.columns

#add columns SILVER PART 1 to represent France Italy and Germany 
silv1_c['France'] = silv1_c['Europe']
silv1_c['Italy'] = silv1_c['Europe']
silv1_c['Germany'] = silv1_c['Europe']

#drop Europe column
silv1_c=silv1_c.drop("Europe", axis = 1)

#check for null values
silv1_c.info() #not ok
bool_series = pd.isnull(silv1_c["United States"]) 
silv1_c[bool_series]["United States"]

silv2_c.info() #ok

#missing USA Price for 2019-12-25(christmas day)
#fill with previous day value 
silv1_c = silv1_c.fillna(method='ffill')
silv1_c.info()

#add missing dates 
#change date values to date time 

#SILVER PART 1
silv1_c = silv1_c.reset_index()
silv1_c ['Date'] = silv1_c ['Date'].astype('datetime64[ns]')     
silv1_c = silv1_c.sort_values(by=['Date'], ascending=[True])


#SILVER PART 2
#silv2_c.rename(columns = {'Date Time' : "Date"}, inplace = True)
silv2_c = silv2_c.reset_index()
silv2_c ['Date Time'] = silv2_c ['Date Time'].astype('datetime64[ns]')     
silv2_c = silv2_c.sort_values(by=['Date Time'], ascending=[True])


#change to date time index
silv1_c.set_index('Date', inplace=True)
silv2_c.set_index('Date Time', inplace=True)

#add missing dates values and fill with previous date
silv1_c= silv1_c.resample('D').ffill().reset_index()
silv2_c= silv2_c.resample('D').ffill().reset_index()

#check for null values 
silv1_c.info()
silv2_c.info()
 
# PULL NEEDED DATES
start_dates = '01-01-2019'
end_dates = '09-11-2020'

#SILVER PART 2,
after_start_date = silv2_c["Date Time"]>= start_dates
before_end_date = silv2_c["Date Time"] <= end_dates
between_two_dates = after_start_date & before_end_date
silv2_c = silv2_c.loc[between_two_dates]
silv2_c
#SILVER PART 1
after_start_date = silv1_c["Date"]>= start_dates
before_end_date = silv1_c["Date"] <= end_dates
between_two_dates = after_start_date & before_end_date
silv1_c = silv1_c.loc[between_two_dates]
silv1_c

silv2_c.columns
silv1_c.columns

#change table structure from  wide to long data for merging
#SILVER PART 2
silv2_clean = pd.melt(silv2_c, id_vars='Date Time', value_vars=['Brazil', 'China', 'India', 'Japan'])
silv2_clean.rename(columns = {'filenames' : "Country"}, inplace = True)
silv2_clean.rename(columns = {'value' : " Silver Price per tr oz"}, inplace = True)
silv2_clean


#SILVER PART 1
silv1_clean = pd.melt(silv1_c, id_vars='Date', value_vars=['Canada', 'United Kingdom',
       'United States', 'France', 'Italy', 'Germany'])
silv1_clean.rename(columns = {'filenames' : "Country"}, inplace = True)
silv1_clean.rename(columns = {'value' : " Silver Price per tr oz"}, inplace = True)
silv1_clean

#Rename column name to 
silv2_clean.rename(columns = {'Date Time' : "Date"}, inplace = True)


#combine silver part1 and  silver part2 dataframe
silvercleaned = pd.concat([silv1_clean,silv2_clean],ignore_index = True)
silvercleaned.info()


#export clean silver to csv
silvercleaned.to_csv(path + silver_cleaned)



















