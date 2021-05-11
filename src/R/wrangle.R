# PLL Groundball Analysis
# Sejin Kim
# STAT 306 Sports Analytics

# This script is for data wrangling

pll <- read.csv('D:/development/scrapepll/pll_scrape_10052021_204247_all.csv')
View(pll)

saveRDS(pll, file = 'D:/development/scrapepll/pll.RDS')
