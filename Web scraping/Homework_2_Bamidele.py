#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Sep 16 16:41:00 2020

@author: toyosibamidele

"""
import io
import pandas as pd
import requests as r
import numpy as np

# path to save file
path = '/users/toyosibamidele/Desktop/'
#url to obatin csv files
urltoget  = "http://drd.ba.ttu.edu/isqs6339/hw/hw2/"
#csv files for ETL
players = "players.csv"
players_sessions = "player_sessions.csv"

groupby_clan = "groupby_clan.csv"
groupby_position ="groupby_position.csv"
sortedby_pdgr = "sortedby_pdgr.csv"
 
#get csv contents from url 
#players data
players_get= r.get(urltoget + players)
players_get.content
#players sessions
players_ses_get = r.get(urltoget + players_sessions)
players_ses_get.content

# read in csv files for players and player sessions data
players_data = pd.read_csv(io.StringIO(players_get.text), delimiter='|')


players_ses_data = pd.read_csv(io.StringIO(players_ses_get.text))



#display the first 5 rows in dataframe
players_data.head()
players_ses_data.head()

#display descriptive statistics 
players_data.describe()
players_ses_data.describe()

#display column count of each variable and data types 
# This step also helps to identify NA values
players_data.info()
players_ses_data.info()

#Data cleaning on players dataframe
#Identify NA rows/columns
players_data[players_data['clan'].isnull()]
#Replace NA values for missing Clan values as "LoD"
players_data["clan"].fillna("LoD", inplace = True)


#Data cleaning on players session dataframe
players_ses_data[players_ses_data['damage_done'].isnull()]

#Based on playid, in order to fill the damage_done NA values
#obtain an average of the damage done by player id
players_ses_data['damage_done'] = players_ses_data['damage_done'].fillna(players_ses_data.groupby('playerid')['damage_done'].transform("mean"))

#join tables 
player_session = players_ses_data.merge(players_data, how='inner', left_on = "playerid", right_on = "playerid")
player_session.info()


player_session['player_performance_metric'] = ((player_session["damage_done"] * 3.125) + (player_session['healing_done'] * 4.815))/ 4

#creating a new column dps_quality based on high,low and medium criteria
values = [0,40000,60000,np.inf]
num = ["Low", "Medium","High" ]
damage_category = pd.cut( player_session["damage_done"],values,labels  = num)  
player_session = player_session.assign(dps_quality = damage_category)            
player_session.info()  
player_session.columns          
               
#creating a new column called player_dkp_gen_rate based on criteria
x= player_session["dps_quality"]
y =player_session["clan"]
z =player_session["player_performance_metric"]

#set default value
player_session["player_dkp_gen_rate"] = 0
#set conditions for player_dkp_gen_rate
player_session["player_dkp_gen_rate"][x == "High"]= z * 1.25
player_session["player_dkp_gen_rate"][x == "Medium"]= z  * 1.15
player_session["player_dkp_gen_rate"][(x == "Low") & (y != "LoD")]= z * .85
player_session["player_dkp_gen_rate"][(x == "Low") & (y == "LoD")]= z * 2.35

#Average damage and healing per session by clan
by_clan = player_session.groupby(["clan","session"])[['damage_done',"healing_done"]].mean()
#Average damage and healing by position
by_position = player_session.groupby("position")[['damage_done',"healing_done"]].mean()
#Output of all merged data sorted by “player_dkp_gen_rate”
sorted_pdgr = player_session.sort_values(by = "player_dkp_gen_rate")


#write all outputs above to csv
by_clan.to_csv(path + groupby_clan)
by_position.to_csv(path + groupby_position)
sorted_pdgr.to_csv(path +sortedby_pdgr)



#############################QUESTIONS################################

#What is the quality of your data? i.e. how clean is your data?

#All NA rows were filled with information best fit to transform the data,
#so there aren't missing values, which puts the data closer to completeness 
#than when it was received and introduces a better level of accuracy 
#and altered steps are traceable, which puts the data at a cleaner point 
#than it was when received.

#What steps did you take to clean your data and why did you choose those options?

#The first step involved understanding the data by identifying the columnns 
# in the two datasets to be joined , the null values and descriptive statistics
# to get better sense of what the data consists of.

#The first file about the player sessions revealed missing values in the 
#damage_done column and the second file revealed missing values in the 
#clan column

#The clan column clean up involved inputing the  values with "LOD" while 
#for the damage done column, the clean up involved replacing values with the average 
#damage done by player id.


#Are there other potential ways you could have cleaned your data?
# the damage done column could have been been replaced with 0 after reviewing
# that some healing_done values were 0.

#players highest values
#damage_done
player_session.groupby("playerid")[['damage_done']].sum().max()
#healing_done
player_session.groupby("playerid")[['healing_done']].sum().max()
#player_performance_metric
player_session.groupby("playerid")[['player_performance_metric']].sum().max()
#player_dkp_gen_rate
player_session.groupby("playerid")[['player_dkp_gen_rate']].sum().max()















