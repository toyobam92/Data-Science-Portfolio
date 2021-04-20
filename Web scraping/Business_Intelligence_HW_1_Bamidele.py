#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Aug 30 20:47:40 2020

@author: toyosibamidele
"""

import requests as r
from bs4 import BeautifulSoup
import csv

urltoget = 'http://drd.ba.ttu.edu/2020c/isqs6339/hw1/'
filepath_1 = '/users/toyosibamidele/Desktop/data_phoneinfo.csv'
filepath_2 = '/users/toyosibamidele/Desktop/data_front_camera.csv'
filepath_3 = '/users/toyosibamidele/Desktop/data_back_camera.csv'

res = r.get(urltoget)
res.content

#Check if we have a good request
if res.status_code == 200:
    print('request is good')
else:
    print('bad request, received code ' + str(res.status_code))
    
#Let's identify our products blocks in HTML
soup = BeautifulSoup(res.content,'lxml') 

#product_result = soup.find_all('div')

search_results = soup.find('div', attrs={'id' : 'mobindex'})

table_results = search_results.find("table")


             
with open(filepath_1, 'w') as data_phoneinfo:
            datawriter = csv.writer(data_phoneinfo, delimiter=',', quotechar='"', quoting=csv.QUOTE_NONNUMERIC)
            datawriter.writerow(['ID', 'Model', 'Product Size', 'Color', 'Battery','Storage',"Network","OS"])
            
            tr = table_results.find_all("tr")

    
            for i in tr:
                    td = i.find_all('td')
                    for j in td:
                         a = i.find('a')   
                         new_url = urltoget + a["href"]
                    id = new_url.split("=")[1]
                    print(id)
                    if len(id) > 0:
                        response = r.get(new_url)
                        soup_new =  BeautifulSoup(response.content,'lxml') 
                        results_new = soup_new.find_all('div', attrs={'id':'PhoneInfo'}) 
                    
                        for rn in results_new:
                            phone_info = rn.find_all("span", class_ = "val")
                            datawriter.writerow([(phone_info[0].text),
                                                                     ( phone_info[1].text),
                                                                     ( phone_info[2].text),
                                                                     ( phone_info[3].text),
                                                                     ( phone_info[6].text),
                                                                     ( phone_info[7].text),
                                                                     ( phone_info[8].text),
                                                                     ( phone_info[9].text)])
  
with open(filepath_2, 'w') as data_front_camera:
            datawriter = csv.writer(data_front_camera, delimiter=',', quotechar='"', quoting=csv.QUOTE_NONNUMERIC)
            datawriter.writerow(['ID', 'Model', 'Camera Front'])
            
            tr = table_results.find_all("tr")

    
            for i in tr:
                    td = i.find_all('td')
                    for j in td:
                         a = i.find('a')   
                         new_url = urltoget + a["href"]
                    id = new_url.split("=")[1]
                    print(id)
                    if len(id) > 0:
                        response = r.get(new_url)
                        soup_new =  BeautifulSoup(response.content,'lxml') 
                        results_new = soup_new.find_all('div', attrs={'id':'PhoneInfo'}) 
                    
                        for rn in results_new:
                            phone_info = rn.find_all("span", class_ = "val")
                            datawriter.writerow([(phone_info[0].text),
                                                                     ( phone_info[1].text),
                                                                     ( phone_info[4].text)])
                                                                     
    
    
    
with open(filepath_3, 'w') as data_back_camera:
            datawriter = csv.writer(data_back_camera, delimiter=',', quotechar='"', quoting=csv.QUOTE_NONNUMERIC)
            datawriter.writerow(['ID', 'Model', 'Camera Back'])
            
            tr = table_results.find_all("tr")

    
            for i in tr:
                    td = i.find_all('td')
                    for j in td:
                         a = i.find('a')   
                         new_url = urltoget + a["href"]
                    id = new_url.split("=")[1]
                    print(id)
                    if len(id) > 0:
                        response = r.get(new_url)
                        soup_new =  BeautifulSoup(response.content,'lxml') 
                        results_new = soup_new.find_all('div', attrs={'id':'PhoneInfo'}) 
                    
                        for rn in results_new:
                            phone_info = rn.find_all("span", class_ = "val")
                            datawriter.writerow([(phone_info[0].text),
                                                                     ( phone_info[1].text),
                                                                     ( phone_info[5].text)])
                                                                   
        
    
    
    
    
    
tr = table_results.find_all("tr")

    
for i in tr:
        td = i.find_all('td')
        for j in td:
             a = i.find('a')   
             new_url = urltoget + a["href"]
        id = new_url.split("=")[1]
        print(id)
        response = r.get(new_url)
        soup_new =  BeautifulSoup(response.content,'lxml') 
        results_new = soup_new.find_all('div', attrs={'id':'PhoneInfo'}) 
        
        for rn in results_new:
            phone_info = rn.find_all("span", class_ = "val")
            title = rn.find_all("span", class_ = "title")
            print('\n*************PHONE INFO***********\n')
            print(id)
            print(title[1].text + phone_info[1].text)
            print(title[4].text + phone_info[4].text)