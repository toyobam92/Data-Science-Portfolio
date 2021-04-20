#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Sep  1 16:30:26 2020

@author: toyosibamidele
"""

import requests as r
from bs4 import BeautifulSoup
import csv


#URL to scrap
urltoget = 'http://drd.ba.ttu.edu/2020c/isqs6339/hw1/'

#file to save expected 3 outputs
filepath_1 = '/users/toyosibamidele/Desktop/data_p.csv'
filepath_2 = '/users/toyosibamidele/Desktop/data_f.csv'
filepath_3 = '/users/toyosibamidele/Desktop/data_b.csv'


#get the url's mainpage 
res = r.get(urltoget)
res.content


#Checking for a  good request
if res.status_code == 200:
    print('request is good')
else:
    print('bad request, received code ' + str(res.status_code))
    
#identifying products blocks in HTML
soup = BeautifulSoup(res.content,'lxml') 

#identify the main section/division to obtain the necessary data 
search_results = soup.find('div', attrs={'id' : 'mobindex'})


#identify the table that houses the row,header and the cell 
table_results = search_results.find("table")


#create/open a 3 csv file to be written into  per the assignment         
with open(filepath_1, 'w') as data_p:
    with open(filepath_2, 'w') as data_f:
        with open(filepath_3, 'w') as data_b:
            datawriter = csv.writer(data_p, delimiter=',', quotechar='"', quoting=csv.QUOTE_NONNUMERIC)
            datawriter2 = csv.writer(data_f, delimiter=',', quotechar='"', quoting=csv.QUOTE_NONNUMERIC)
            datawriter3 = csv.writer(data_b, delimiter=',', quotechar='"', quoting=csv.QUOTE_NONNUMERIC)
            #header for each column in the csv file
            datawriter.writerow(['ID', 'Model', 'Product Size', 'Color', 'Battery','Storage',"Network","OS"])
            datawriter2.writerow(['ID', 'Model', 'Camera Front'])
            datawriter3.writerow(['ID', 'Model', 'Camera Back'])
            
            
            #tr is a repeated tag within the table to obtain information from the cells
            tr = table_results.find_all("tr")
            #iterate through row tag to obtain all cells from all subpages 
            for i in tr:
                    #obtain all the td tags to obtain all the cell values 
                    td = i.find_all('td')
                    #removing header row to obtain td tags 
                    if len(td) > 0:
                        for j in td:
                        #obtain all the anchor tags to access the subpage through the hyperlink    
                             a = i.find('a') 
                         #create a new url to scrap     
                             new_url = urltoget + a["href"]
                         #removing the outputs with no values by identifying the ones that have no id     
                        id = new_url.split("=")[1]
                        print(id)
                        if len(id) > 0:
                        #request the url's subpages    
                            response = r.get(new_url)
                            #identifying the blocks in the HTML subpages
                            soup_new =  BeautifulSoup(response.content,'lxml') 
                            #identifying the sections/divisions in the subpages
                            results_new = soup_new.find_all('div', attrs={'id':'PhoneInfo'}) 
                            #iterate trough the divisons in the subpages to obtain all groups per assignment
                            for rn in results_new:
                                phone_info = rn.find_all("span", class_ = "val")
                                #write all the necessary outputs to the csv files created
                                datawriter.writerow([(phone_info[0].text),
                                                                         ( phone_info[1].text),
                                                                         ( phone_info[2].text),
                                                                         ( phone_info[3].text),
                                                                         ( phone_info[6].text),
                                                                         ( phone_info[7].text),
                                                                         ( phone_info[8].text),
                                                                         ( phone_info[9].text)])
                                datawriter2.writerow([(phone_info[0].text),
                                                                         ( phone_info[1].text),
                                                                         ( phone_info[4].text)])
        
        
                                datawriter3.writerow([(phone_info[0].text),
                                                                         ( phone_info[1].text),
                                                                         ( phone_info[5].text)])
