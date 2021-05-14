# PLL Groundball Analysis
# Sejin Kim
# STAT 306 Sports Analytics

# This script is for the gradient boosted regressor

library(mosaic)
library(dplyr)
library(gbm)
library(parallel)
library(leaps)
library(caret)
library(MASS)

# Read in data
pll <- readRDS(url('https://github.com/kim3-sudo/pll_analysis/blob/main/data/pll.RDS?raw=true'))

# Prepare multicore processing
numCores <- detectCores()
print(paste('Will use ', numCores, ' cores in GBM'))

# Generate models to use with GBM
## Start with full model using reasonable data
fullmod <- lm(GB ~ Pos + GP + P + G1 + G2 + A + Sh + SOG + TO + CT + Team, data = pll)
## Generate stepwise model
stepmod <- stepAIC(fullmod, direction = "both", trace = FALSE)
summary(stepmod)
## Generate max subsetted model using leaps on sequential replacement
seqrepmod <- regsubsets(GB ~ Pos + GP + P + G1 + G2 + A + Sh + SOG + TO + CT + Team, data = pll, nvmax = 10, method = "seqrep")
summary(seqrepmod)
## Generate model via k-fold x-validation
trainCtrl <- trainControl(method = "cv", number = 10)
newstepmod <- train(GB ~ Pos + GP + P + G1 + G2 + A + Sh + SOG + TO + CT + Team, data = pll,
                 method = "leapSeq",
                 tuneGrid = data.frame(nvmax = 1:10),
                 trControl = trainCtrl)
backmod <- train(GB ~ Pos + GP + P + G1 + G2 + A + Sh + SOG + TO + CT + Team, data = pll,
                 method = "leapBackward",
                 tuneGrid = data.frame(nvmax = 1:10),
                 trControl = trainCtrl)
forwmod <- train(GB ~ Pos + GP + P + G1 + G2 + A + Sh + SOG + TO + CT + Team, data = pll,
                 method = "leapForward",
                 tuneGrid = data.frame(nvmax = 1:10),
                 trControl = trainCtrl)
summary(newstepmod)
summary(backmod)
summary(forwmod)

## View optimal nvmax value - finds the model with the lowest RMSE
newstepmod$bestTune
backmod$bestTune
forwmod$bestTune

## View best models
summary(newstepmod$finalModel)
summary(backmod$finalModel)
summary(forwmod$finalModel)

# Generate gradient boosted modifier model
# For interactions, use P:G1, GP:G1 and G1:SOG
gbmmod <- gbm(formula = (GB ~ A + Sh + SOG + P + G1 + G2 + (P * G1) + (GP * G1) + (G1 * SOG)),
              distribution = "poisson", 
              data = pll,
              n.trees = 100000,
              interaction.depth = 5,
              cv.folds = 10,
              verbose = TRUE,
              n.cores = numCores)
summary(gbmmod)
gbmmod

interpmod <- glm(formula = (GB ~ A + Sh + SOG + P + G1 + G2 + (P * G1) + (GP * G1) + (G1 * SOG)),
                 family = poisson(), 
                 data = pll)
summary(interpmod)