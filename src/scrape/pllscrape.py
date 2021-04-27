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

url = "https://stats.premierlacrosseleague.com/player-table"

driver = webdriver.Chrome()
driver.implicitly_wait(5)
driver.get(url)

viewqty = driver.find_element_by_css_selector("select[aria-label='rows per page']")
viewqty.send_keys(" A")
viewqty.send_keys(Keys.ENTER)

source = driver.page_source
driver.close()

soup = BeautifulSoup(source, 'lxml')

print(soup)
