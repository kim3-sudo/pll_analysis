# -*- coding: utf-8 -*-
"""
Created on Tue Apr 27 16:02:12 2021

@author: kim3
"""

import pandas as pd
from bs4 import BeautifulSoup
import selenium
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from datetime import datetime
import re

url = "https://stats.premierlacrosseleague.com/player-table"

now = datetime.now()
dt_string = now.strftime("_%d%m%Y_%H%M%S")
enddir = 'D:\\development\\scrapepll\\'
endfile = enddir + 'pll_scrape' + dt_string + '_'

driver = webdriver.Chrome()
driver.implicitly_wait(5)
driver.get(url)

viewqty = driver.find_element_by_css_selector("select[aria-label='rows per page']")
viewqty.send_keys(" A")
viewqty.send_keys(Keys.ENTER)

source = driver.page_source
driver.close()

soup = BeautifulSoup(source, 'lxml')

table = soup.find('table', attrs = {'class': 'MuiTable-root'})

data_rows = table.find_all('tr')

data = []
for tr in data_rows:
    td = tr.find_all('td')
    row = [tr.text for tr in td]
    data.append(row)

imgurls = []
images = table.find_all('img')
for image in images:
    imgurls.append(image['src'])
    
df = pd.DataFrame(data, columns = ['imgurl', 'Player', 'Pos', 'GP', 'P', 'G1', 'G2', 'A', 'Sh', 'ShP', 'SOG', 'TO', 'CT', 'GB', 'FO', 'FOP', 'Sv', 'SvP'])

df = df.iloc[1:]

df['imgurl'] = imgurls

# Clean names by removing rank and move jersey number to different column and get team from iage url lol xd lmao haha poopy stinky haha
jerseyList = []
rankList = []
teamList = []
for index, row in df.iterrows():
    # remove ranks
    row['Player'] = re.sub(r'\d\d?\d?\.\s', '', str(row['Player']))
    # process jersey numbers
    jersey = str(re.findall(r'\s\|\s\d\d?', str(row['Player'])))
    jersey = jersey.lstrip("[| '")
    jersey = jersey.rstrip("'']")
    jerseyList.append(jersey)
    # process ranks
    row['Player'] = re.sub(r'\s\|\s\d\d?', '', row['Player'])
    rankList.append(index)
    # process teams
    team = str(row['imgurl'])
    team = re.sub(r'\/static\/media\/', '', team)
    team = re.sub(r'\_ic\.\S\S\S\S\S\S\S\S\.png', '', team)
    teamList.append(str.upper(team))
    
df['Jersey'] = jerseyList
df['Rank'] = rankList
df['Team'] = teamList

print('Data preview')
print(df)

writeout = input('Write out CSV? [y/n]')
if writeout == 'Y' or writeout == 'y':
    df.to_csv(endfile + '.csv')
    print('Wrote CSV out')
else:
    print('Skipping CSV writeout')

print('All done!')
