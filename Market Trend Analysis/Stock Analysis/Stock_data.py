# =============================================================================
# Program to read, clean and merge stock data for 
# top 10 GDP countries from Jan 1st 2019 - Sep 11 2020
#Countries=['Brazil','Canada','China','France','Germany','India','Japan','United States','Italy','United Kingdom']
#Index=['BOVESPA','S&P/TSX','SSE','CAC 40','DAX','NSE','Nikkei','NASDAQ','FTSE MIB','FTSE 100']
# =============================================================================

#import statements
import pandas as pd

#url, file path and file names
data_dir = 'C:/Users/skarn/Desktop/TTU/Fall/BI/FP/Data/'
fp = 'C:/Users/skarn/Desktop/TTU/Fall/BI/FP/'
fileOut1 = 'StockData.csv'
# top 10 GDP countries and Indices we used to collect the data
# handled UK and Italy Separately in the loop as the data was in a different format
Countries=['Brazil','Canada','China','France','Germany','India','Japan','United States','Italy','United Kingdom']
Index=['BOVESPA','S&P/TSX','SSE','CAC 40','DAX','NSE','Nikkei','NASDAQ','FTSE MIB','FTSE 100']

dfFinal=pd.DataFrame()

for i in range (0 , len(Countries)):
    country = Countries[i]  
    df=pd.DataFrame()
    columnName='Close'
    if country=='Italy' :
        #read the two files  
        df1=pd.read_csv(data_dir+country+'1.csv')
        df2=pd.read_csv(data_dir+country+'2.csv')
        #Concantenate both
        df=pd.concat([df2,df1])
        #drop unwanted columns
        df.drop(['Open', 'High', 'Low','Adj Close', 'Volume'],axis=1, inplace=True)
        #format date to the existing date column format
        df["Date"] = pd.to_datetime(df["Date"]).dt.strftime('%Y-%m-%d')
        #dummy dta frame to collect all the missing dates(weekends and holidays)
        s = pd.DataFrame({"Date": pd.date_range(df.Date.min(), df.Date.max(), freq="D")})   
        s.Date=s.Date.dt.strftime('%Y-%m-%d')
        df=df.merge(s, how='right',on='Date')
        df['Date'] = pd.to_datetime(df['Date'])
        #dropped the data before jan 1st 2019
        df = df[~(df['Date'] <= '2018-12-31')]
        df['Date'] = df['Date'].dt.date
        df.sort_values(by=['Date'], inplace=True, ascending=True)
    elif country=='United Kingdom':
        df=pd.read_csv(data_dir+country+'.csv')
        #drop unwanted columns
        df.drop(['Open Price', 'High Price', 'Low Price','Volume'],axis=1, inplace=True)
        #format date to the existing date column format
        df["Date"] = pd.to_datetime(df["Date"]).dt.strftime('%Y-%m-%d')
        #dummy dta frame to collect all the missing dates(weekends and holidays)
        s = pd.DataFrame({"Date": pd.date_range('2019-01-01', df.Date.max(), freq="D")})   
        s.Date=s.Date.dt.strftime('%Y-%m-%d')
        df=df.merge(s, how='right',on='Date')
        df.Date=pd.to_datetime(df.Date)
        df.sort_values(by=['Date'], inplace=True, ascending=True)
        df.Date=df.Date.dt.strftime('%Y-%m-%d')
        columnName='Close Price'
    else:
        #all other countries
        df=pd.read_csv(data_dir+country+'.csv')
        #drop unwanted columns
        df.drop(['Open', 'High', 'Low','Adj Close', 'Volume'],axis=1, inplace=True)
        #dummy dta frame to collect all the missing dates(weekends and holidays)
        s = pd.DataFrame({"Date": pd.date_range('2019-01-01', df.Date.max(), freq="D")})   
        s.Date=s.Date.dt.strftime('%Y-%m-%d')
        df=df.merge(s, how='right',on='Date')
        df.Date=pd.to_datetime(df.Date)
        df.sort_values(by=['Date'], inplace=True, ascending=True)
        df.Date=df.Date.dt.strftime('%Y-%m-%d')
        
   #common code for all countries        
   #Clean data.replaced all nan with the data from previous date
    df[columnName]=df[columnName].fillna(df[columnName].ffill())
    #for back filling Jan 1st with jan 2nd data
    df[columnName]=df[columnName].fillna(df[columnName].bfill())
    #rename column to Stock Price
    df.rename(columns = {columnName : "Stock_Price"}, inplace = True)
    #added country and stock index columns
    df['Country'] = country
    df['Stock Index'] =Index[i]
    # append to the final list
    dfFinal=dfFinal.append(df,ignore_index=True)     
    
#Write the final data to the file
dfFinal.to_csv(fp + fileOut1,index=False)
