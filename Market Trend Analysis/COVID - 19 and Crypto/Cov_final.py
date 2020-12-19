#import io
import pandas as pd
import numpy as np
#import requests as r
import datetime as dt

path = '/Users/Yang/Desktop/final/'
file_covid = "covid.csv"
file_bit="BIT.csv"
file_ETH="ETH.csv"
file_exchange="FRB_H10.csv"
file_stock="StockData.csv"
################################################################
################################################################
###### The files for gold and silver
file_gold="gold_clean copy.csv"
file_sil="silver_final_merge copy.csv"
gold=pd.read_csv(path+file_gold)
sil=pd.read_csv(path+file_sil)
stock= pd.read_csv(path+file_stock)

#merge gold and silver as m
m = gold.merge(sil, how = "outer", on = ["Date","Country"])
################################################################
################################################################
#### Read and merge the cryptocurrency

bit=pd.read_csv(path+file_bit)
eth=pd.read_csv(path+file_ETH)

#Merge all tow files
crypto = bit.merge(eth, how = "inner", on ="Date" )


#to date time tye
crypto.Date = pd.to_datetime(crypto.Date)
#crypto.dtypes

# Choose the date from 2019.1.1
crypto_final = crypto[crypto.Date.dt.year >= 2019]

# Set the date as index and fill the missing date
crypto_final.set_index('Date', inplace=True)
crypto_final = crypto_final.resample('D').ffill().reset_index()
crypto_final = crypto_final.reset_index()

crypto_final.Date = pd.to_datetime(crypto_final.Date)
crypto_final.Date=crypto_final.Date.dt.strftime('%Y-%m-%d')


################################################################
################################################################
#### Covid
cov=pd.read_csv(path+file_covid)


# To date time type
cov.date = pd.to_datetime(cov.date)
cov_val = cov[["location","date","total_cases","total_deaths","total_cases_per_million"]]

# Rename the columns
cov_loc_1= cov_val[(cov_val.location=="China")|(cov_val.location=="Brazil")|(cov_val.location=="France")|(cov_val.location=="Germany")|(cov_val.location=="India")|(cov_val.location=="Japan")|(cov_val.location=="United Kingdom")|(cov_val.location=="Italy") |(cov_val.location=="United States") |(cov_val.location=="Canada") ]
cov_loc_1 = cov_loc_1.rename(columns={"date":"Date","location":"Country"})

#Double check  the date
cov_loc_1.Date = pd.to_datetime(cov_loc_1.Date)
cov_loc_1.Date=cov_loc_1.Date.dt.strftime('%Y-%m-%d')

################################################################
################################################################
#### Exchange
#read csv
exc=pd.read_csv(path+file_exchange)
# Add three countries
exc["Germany"]=exc["EURO"]
exc["France"]=exc["EURO"]
exc["Italy"]=exc["EURO"]


#Change the columns' name to match other files
exc_name=exc.rename(columns={"CHINA":"China","BRAZIL ":"Brazil","INDIA":"India","JAPAN":"Japan","UNITED KINGDOM":"United Kingdom","CANADA":"Canada"})
# Select columns
exc_final = exc_name[["Series Description","Brazil","China","France","Germany","India","Japan","United Kingdom","Italy","Canada"]]

# Since all the exchange is compare with USD, add USD column with all 1
exc_final["United States"]="1"

# Drop the useless rows
exc_final=exc_final.drop(exc_final.index[[0,1,2,3,4]],axis=0)

# change the column name to date.
exc_final=exc_final.rename(columns={"Series Description":"Date"})

#to change date time type
exc_final.Date = pd.to_datetime(exc_final.Date)

# Set the date as index and fill the missing date
exc_final.set_index('Date', inplace=True)
exc_final = exc_final.resample('D').ffill().reset_index()
exc_final = exc_final.reset_index()
    
exc_final.Date=exc_final.Date.dt.strftime('%Y-%m-%d')

#Add missing value of price 
# We used the prior day's price of the missing value to replace the missing one.
# Except for 2019.1.1. Because, there is no date before that, so, we used the date after that.
# For the date except 2019.1.1

exc_final.loc[0] = exc_final.loc[1]
exc_final["Date"].loc[0]="2019-01-01"

#to change date time type
exc_final.Date = pd.to_datetime(exc_final.Date)

exc_final=exc_final.replace("ND", np.NaN)

# Change the column name as a variable.
# Create subsets with data and country name and then merge them together
# Change null value into the value before.

exc_final_Brazil=pd.DataFrame()
exc_final_Brazil["Date"]=exc_final["Date"]
exc_final_Brazil["Price"]=exc_final["Brazil"]
exc_final_Brazil["Country"]="Brazil"
exc_final_Brazil['Price']=exc_final_Brazil['Price'].fillna(exc_final_Brazil['Price'].ffill())

exc_final_China=pd.DataFrame()
exc_final_China["Date"]=exc_final["Date"]
exc_final_China["Price"]=exc_final["China"]
exc_final_China["Country"]="China"
exc_final_China['Price']=exc_final_China['Price'].fillna(exc_final_China['Price'].ffill())

exc_final_Japan=pd.DataFrame()
exc_final_Japan["Date"]=exc_final["Date"]
exc_final_Japan["Price"]=exc_final["Japan"]
exc_final_Japan["Country"]="Japan"
exc_final_Japan['Price']=exc_final_Japan['Price'].fillna(exc_final_Japan['Price'].ffill())

exc_final_UK=pd.DataFrame()
exc_final_UK["Date"]=exc_final["Date"]
exc_final_UK["Price"]=exc_final["United Kingdom"]
exc_final_UK["Country"]="United Kingdom"
exc_final_UK['Price']=exc_final_UK['Price'].fillna(exc_final_UK['Price'].ffill())

exc_final_Italy=pd.DataFrame()
exc_final_Italy["Date"]=exc_final["Date"]
exc_final_Italy["Price"]=exc_final["Italy"]
exc_final_Italy["Country"]="Italy"
exc_final_Italy['Price']=exc_final_Italy['Price'].fillna(exc_final_Italy['Price'].ffill())

exc_final_Canada=pd.DataFrame()
exc_final_Canada["Date"]=exc_final["Date"]
exc_final_Canada["Price"]=exc_final["Canada"]
exc_final_Canada["Country"]="Canada"
exc_final_Canada['Price']=exc_final_Canada['Price'].fillna(exc_final_Canada['Price'].ffill())

exc_final_France=pd.DataFrame()
exc_final_France["Date"]=exc_final["Date"]
exc_final_France["Price"]=exc_final["France"]
exc_final_France["Country"]="France"
exc_final_France['Price']=exc_final_France['Price'].fillna(exc_final_France['Price'].ffill())

exc_final_Germany=pd.DataFrame()
exc_final_Germany["Date"]=exc_final["Date"]
exc_final_Germany["Price"]=exc_final["Germany"]
exc_final_Germany["Country"]="Germany"
exc_final_Germany['Price']=exc_final_Germany['Price'].fillna(exc_final_Germany['Price'].ffill())

exc_final_US=pd.DataFrame()
exc_final_US["Date"]=exc_final["Date"]
exc_final_US["Price"]=exc_final["United States"]
exc_final_US["Country"]="United States"
exc_final_US['Price']=exc_final_US['Price'].fillna(exc_final_US['Price'].ffill())

exc_final_India=pd.DataFrame()
exc_final_India["Date"]=exc_final["Date"]
exc_final_India["Price"]=exc_final["India"]
exc_final_India["Country"]="India"
exc_final_India['Price']=exc_final_India['Price'].fillna(exc_final_India['Price'].ffill())

# Merge all together
exc_final_1=pd.DataFrame()
exc_final_1=exc_final_1.append(exc_final_Brazil)
exc_final_1=exc_final_1.append(exc_final_US)
exc_final_1=exc_final_1.append(exc_final_Germany)
exc_final_1=exc_final_1.append(exc_final_France)
exc_final_1=exc_final_1.append(exc_final_Canada)
exc_final_1=exc_final_1.append(exc_final_Italy)
exc_final_1=exc_final_1.append(exc_final_Japan)
exc_final_1=exc_final_1.append(exc_final_China)
exc_final_1=exc_final_1.append(exc_final_India)
exc_final_1=exc_final_1.append(exc_final_UK)

# Rename the name
exc_final_1=exc_final_1.rename(columns={"Price":"Exchange to USD"})

#Double check  the date
exc_final_1.Date = pd.to_datetime(exc_final_1.Date)
exc_final_1.Date=exc_final_1.Date.dt.strftime('%Y-%m-%d')


################################################################
################################################################
################################################################
# Merge ALL
covid_final=pd.DataFrame()
covid_final = exc_final_1.merge(cov_loc_1, how = "outer", on = ["Date","Country"])

# Fill nan in total_cases, total_cases, total_cases_per_million with "0"
covid_final["total_cases"]=covid_final["total_cases"].fillna(0)
covid_final["total_deaths"]=covid_final["total_deaths"].fillna(0)
covid_final["total_cases_per_million"]=covid_final["total_cases_per_million"].fillna(0)

# Merge all together.
cov_exc_cryp = covid_final.merge(crypto_final,how = "outer", on =["Date"] )
cov_exc_cryp_final = cov_exc_cryp[["Country","Date","Exchange to USD","Currency_x","Closing Price (USD)_x","Currency_y","Closing Price (USD)_y","total_cases","total_deaths","total_cases_per_million"]]
cov_exc_cryp_final = cov_exc_cryp_final.rename(columns={"Currency_x":"BTC", "Currency_y":"ETH","Closing Price (USD)_x":"BIT_price","Closing Price (USD)_y":"ETH_price"})

# Choose the date before sep.11
cov_exc_cryp_final = cov_exc_cryp_final[cov_exc_cryp_final.Date <= "2020-09-11"]

################################################################
################################################################
################################################################
# OUt put data
##Exchange data
##exc_final_1.to_csv("exc_final.csv",index = False) 
## covid
#cov_loc_1[["Date","Country","total_cases","total_deaths"]].to_csv("cov_loc.csv",index = False) 
## crypto
#c=cov_exc_cryp_final.groupby(["Country","Date"]).mean()
#c = c.reset_index()
#c[["Date","BIT_price","ETH_price"]].to_csv("cyp.csv",index = False) 
#cov_exc_cryp_final.to_csv("covid_exc_cryp.csv",index=False)

#cor of the time, no covid
cov_exc_cryp_final_nocovid=cov_exc_cryp_final[cov_exc_cryp_final.total_cases==0]
cor_nocovid= cov_exc_cryp_final_nocovid.corr(method="pearson")

#cor of the time, have covid
cov_exc_cryp_final_covid=cov_exc_cryp_final[cov_exc_cryp_final.total_cases!=0]
cor_covid= cov_exc_cryp_final_covid.corr(method="pearson")

################################################################
################################################################
################################################################
# Merge all together
toge_all=cov_exc_cryp_final.merge(m,how = "outer",on=["Date","Country"])
toge_all=toge_all[["Country","Date","total_cases","total_deaths","Gold Price per tr oz"," Silver Price per tr oz","Exchange to USD","BIT_price","ETH_price",]]
toge_all = toge_all.merge(stock, how = "outer", on = ["Date","Country"])
toge_all=toge_all.rename(columns={" Silver Price per tr oz":"Silver Price per tr oz"})

#toge_all["Exchange to USD"]=pd.to_numeric(toge_all["Exchange to USD"])
#toge_all["ad_Gold_Price"]=toge_all["Gold Price per tr oz"]/toge_all["Exchange to USD"]
#toge_all["ad_Silver_Price"]=toge_all["Silver Price per tr oz"]/toge_all["Exchange to USD"]

# To csv
#toge_all.to_csv("Final_Project.csv",index=False)

#cor of the time, no covid
toge_all_nocovid=toge_all[toge_all.total_cases==0]
all_cor_nocovid= toge_all_nocovid.corr(method="pearson")

#cor of the time, have covid
toge_all_covid=toge_all[toge_all.total_cases!=0]
all_cor_covid= toge_all_covid.corr(method="pearson")



########### Matrix of the change rate.
toge_all_us=toge_all[toge_all["Country"]=="United States"]
toge_all_us=toge_all_us[toge_all_us.Date >= "2020-01-01"]

silver_1_1=toge_all_us["Silver Price per tr oz"].iloc[0]
silver_min = toge_all_us["Silver Price per tr oz"].min()
silver_max = toge_all_us["Silver Price per tr oz"].max()
silver_std = toge_all_us["Silver Price per tr oz"].std()
silver_mean = toge_all_us["Silver Price per tr oz"].mean()
silver_rate=(silver_max-silver_1_1)/silver_1_1
silver_std/silver_mean
############Gold
silver_1_1=toge_all_us["Gold Price per tr oz"].iloc[0]
silver_min = toge_all_us["Gold Price per tr oz"].min()
silver_max = toge_all_us["Gold Price per tr oz"].max()
silver_std = toge_all_us["Gold Price per tr oz"].std()
silver_std = toge_all_us["Gold Price per tr oz"].std()
silver_mean = toge_all_us["Gold Price per tr oz"].mean()
silver_rate=(silver_max-silver_1_1)/silver_1_1
silver_std/silver_mean
####stock
silver_1_1=toge_all_us["Stock_Price"].iloc[0]
silver_min = toge_all_us["Stock_Price"].min()
silver_max = toge_all_us["Stock_Price"].max()
silver_std = toge_all_us["Stock_Price"].std()
silver_mean = toge_all_us["Stock_Price"].mean()
(silver_max-silver_1_1)/silver_1_1
silver_std/silver_mean


a = {"Name"  : ["Silver","Gold","NASDAQ","BIT","ETH"],
     "Jan_1" : [toge_all_us["Silver Price per tr oz"].iloc[0] , toge_all_us["Gold Price per tr oz"].iloc[0] , toge_all_us["Stock_Price"].iloc[0] , toge_all_us["BIT_price"].iloc[0] , toge_all_us["ETH_price"].iloc[0]],
     "Min" : [toge_all_us["Silver Price per tr oz"].min() , toge_all_us["Gold Price per tr oz"].min() , toge_all_us["Stock_Price"].min() , toge_all_us["BIT_price"].min() , toge_all_us["ETH_price"].min()],
     "Max" : [toge_all_us["Silver Price per tr oz"].max() , toge_all_us["Gold Price per tr oz"].max() , toge_all_us["Stock_Price"].max() , toge_all_us["BIT_price"].max() , toge_all_us["ETH_price"].max()],
     "Std" : [toge_all_us["Silver Price per tr oz"].std() , toge_all_us["Gold Price per tr oz"].std() , toge_all_us["Stock_Price"].std() , toge_all_us["BIT_price"].std() , toge_all_us["ETH_price"].std()],
     "Mean" : [toge_all_us["Silver Price per tr oz"].mean() , toge_all_us["Gold Price per tr oz"].mean() , toge_all_us["Stock_Price"].mean() , toge_all_us["BIT_price"].mean() , toge_all_us["ETH_price"].mean()],
     "Change_rate" : [(toge_all_us["Silver Price per tr oz"].max()-toge_all_us["Silver Price per tr oz"].iloc[0])/toge_all_us["Silver Price per tr oz"].iloc[0]   , (toge_all_us["Gold Price per tr oz"].max()-toge_all_us["Gold Price per tr oz"].iloc[0])/toge_all_us["Gold Price per tr oz"].iloc[0]  , (toge_all_us["Stock_Price"].max()-toge_all_us["Stock_Price"].iloc[0])/toge_all_us["Stock_Price"].iloc[0]  , (toge_all_us["BIT_price"].max()-toge_all_us["BIT_price"].iloc[0])/toge_all_us["BIT_price"].iloc[0], (toge_all_us["ETH_price"].max()-toge_all_us["ETH_price"].iloc[0])/toge_all_us["ETH_price"].iloc[0]],
     "std/mean" : [toge_all_us["Silver Price per tr oz"].std()/toge_all_us["Silver Price per tr oz"].mean() , toge_all_us["Gold Price per tr oz"].std()/toge_all_us["Gold Price per tr oz"].mean()  , toge_all_us["Stock_Price"].std()/toge_all_us["Stock_Price"].mean() , toge_all_us["BIT_price"].std()/toge_all_us["BIT_price"].mean()  , toge_all_us["ETH_price"].std()/toge_all_us["ETH_price"].mean() ],
        }

rate=pd.DataFrame(a)




