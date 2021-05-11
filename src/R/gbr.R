# PLL Groundball Analysis
# Sejin Kim
# STAT 306 Sports Analytics

# This script is for the gradient boosted regressor

library(mosaic)
library(dplyr)
library(gbm)
library(parallel)

numCores <- detectCores()

gbm(formula = (GB~Rank*GP*P*Sh), distribution = "poisson", data = pll, n.trees = 100, interaction.depth = 1, cv.folds = 1, verbose = TRUE, n.cores = numCores)