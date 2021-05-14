# PLL Groundball Analysis
# Sejin Kim
# STAT 306 Sports Analytics

# This script is for EDA

library(mosaic)
library(dplyr)
library(ggplot2)
library(ggpubr)
library(rstatix)

# Load data
pll <- readRDS(url('https://github.com/kim3-sudo/pll_analysis/blob/main/data/pll.RDS?raw=true'))

# Simple stats
favstats(pll$P)
onlygbs <- filter(pll, GB != 0)
favstats(onlygbs$P)
gb2 <- filter(pll, GB >= 2)
favstats(gb2$P)
gb3 <- filter(pll, GB >= 3)
favstats(gb3$P)

# Determine possible interaction effects
pllmod <- lm(GB ~ Pos * GP * P * G1 * G2 * A * Sh * SOG * TO * CT * Team, data = pll)
interaction.plot(pll$GP, pll$Pos, pll$GB) # YES
interaction.plot(pll$P, pll$Pos, pll$GB) # YES
interaction.plot(pll$G1, pll$Pos, pll$GB) # NO
interaction.plot(pll$G2, pll$Pos, pll$GB) # NO
interaction.plot(pll$A, pll$Pos, pll$GB) # YES
interaction.plot(pll$Sh, pll$Pos, pll$GB) # WTH
interaction.plot(pll$SOG, pll$Pos, pll$GB) # Also WTH

# Use Friedman test to determine interaction (a nonpar alternative to two-way ANOVA)
# Visualize using a boxplot for sanity
ggboxplot(pll, x = "Pos", y = "GB", add = "jitter")
ggboxplot(pll, x = "Pos", y = "GP", add = "jitter")
ggboxplot(pll, x = "Pos", y = "P", add = "jitter")
ggboxplot(pll, x = "Pos", y = "G1", add = "jitter")
ggboxplot(pll, x = "Pos", y = "G2", add = "jitter")
ggboxplot(pll, x = "Pos", y = "A", add = "jitter")
ggboxplot(pll, x = "Pos", y = "Sh", add = "jitter")
ggboxplot(pll, x = "Pos", y = "SOG", add = "jitter")
ggboxplot(pll, x = "GP", "P", add = "jitter")
ggboxplot(pll, x = "GP", "G1", add = "jitter")
ggboxplot(pll, x = "GP", "G2", add = "jitter")
ggboxplot(pll, x = "GP", "A", add = "jitter")
ggboxplot(pll, x = "GP", "Sh", add = "jitter")
ggboxplot(pll, x = "GP", "SOG", add = "jitter")
ggboxplot(pll, x = "G1", "G2", add = "jitter")
ggboxplot(pll, x = "G1", "A", add = "jitter")
ggboxplot(pll, x = "G1", "Sh", add = "jitter")
ggboxplot(pll, x = "G1", "SOG", add = "jitter")
ggboxplot(pll, x = "G2", "A", add = "jitter")
ggboxplot(pll, x = "G2", "Sh", add = "jitter")
ggboxplot(pll, x = "G2", "SOG", add = "jitter")
ggboxplot(pll, x = "A", "Sh", add = "jitter")
ggboxplot(pll, x = "A", "SOG", add = "jitter")
ggboxplot(pll, x = "Sh", "SOG", add = "jitter")

## Determine interactions
interactmod <- lm(GB ~ (GP + P + G1 + G2 + A + Sh + SOG)^2, data = pll)
summary(interactmod)

# USE P:G1, GP:G1 and G1:SOG
