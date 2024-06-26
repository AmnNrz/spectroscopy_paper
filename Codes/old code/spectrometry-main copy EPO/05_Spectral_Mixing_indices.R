## ---------------------------
##
## Script name:
##
## Purpose of script:
##
## Author: Siddharth Chaudhary
##
## Date Created: 2022-09-12
##
## Copyright (c) Siddharth Chaudhary, 2022
## Email: siddharth.chaudhary@wsu.edu
##
## ---------------------------
##
## Notes:
##
##
## ---------------------------

library(tidyverse)
library(dplyr)
library(ggplot2)

LinearMix <- read.csv("/Users/aminnorouzi/Library/CloudStorage/GoogleDrive-msaminnorouzi@gmail.com/My Drive/PhD/Projects/Spectroscopy paper/LinearMix/LinearMix_onetomany.csv")
Soil_Median <- read.csv("/Users/aminnorouzi/Library/CloudStorage/GoogleDrive-msaminnorouzi@gmail.com/My Drive/PhD/Projects/Spectroscopy paper/Spectrometry-main/Soil_08_18.csv")
Residue_Median <- read.csv("/Users/aminnorouzi/Library/CloudStorage/GoogleDrive-msaminnorouzi@gmail.com/My Drive/PhD/Projects/Spectroscopy paper/Spectrometry-main/Residue_08_18.csv")

CAI_residue <- read.csv("/Users/aminnorouzi/Library/CloudStorage/GoogleDrive-msaminnorouzi@gmail.com/My Drive/PhD/Projects/Spectroscopy paper/Spectrometry-main/CAI_Residue.csv")
CAI_soil <- read.csv("/Users/aminnorouzi/Library/CloudStorage/GoogleDrive-msaminnorouzi@gmail.com/My Drive/PhD/Projects/Spectroscopy paper/Spectrometry-main/CAI_Soil.csv")

## Renaming the column to Reflectance
LinearMix_sub <- dplyr::filter(LinearMix,Crop.x=="Canola"&Crop.y=="Almira_bottom")

CAI <- LinearMix_sub %>%
  dplyr::filter(Wvl == 2200 | Wvl == 2000 | Wvl == 2100 | Wvl == 2260 | Wvl == 2205 | Wvl == 1660 | Wvl == 2330)


CAI <- CAI[c(1,4,8,11,17)]

CAI <- CAI %>%
  spread(Wvl,Ref_conven_lower) %>%
  mutate(CAI = 2200 / 2000) %>%
  mutate(SINDRI = 2200 / 2000) %>%
  mutate(NDTI = 2200 / 2000)

CAI$CAI <- (0.5 * (CAI$`2000` + CAI$`2200`) - CAI$`2100`)
CAI$SINDRI <- 100 * (CAI$`2205` - CAI$`2260`) / (CAI$`2205` + CAI$`2260`)
CAI$NDTI <- (CAI$`1660` - CAI$`2330`) / (CAI$`1660` + CAI$`2330`)


ggplot(CAI, aes(x = RWC_conven_lower, y = CAI, group = Crop.x, color = Crop.x)) +
  geom_point() +
  geom_line()
facet_wrap(~Crop, ncol = 2)

ggplot(CAI, aes(x = RWC_conven_lower, y = SINDRI, group = Crop.x, color = Crop.x)) +
  geom_point() +
  geom_line()
facet_wrap(~Crop, ncol = 2)

ggplot(CAI, aes(x = RWC_conven_lower, y = NDTI, group = Crop.x, color = Crop.x)) +
  geom_point() +
  geom_line()
facet_wrap(~Crop, ncol = 2)

colnames(Soil_Median)[5] <- "Reflectance"
CAI1 <- Soil_Median %>%
  dplyr::filter(Wvl == 2200 | Wvl == 2000 | Wvl == 2100 | Wvl == 2260 | Wvl == 2205 | Wvl == 1660 | Wvl == 2330)

CAI1 <- CAI1 %>%
  spread(Wvl, Reflectance) %>%
  mutate(CAI = 2200 / 2000) %>%
  mutate(SINDRI = 2200 / 2000) %>%
  mutate(NDTI = 2200 / 2000)

CAI1$CAI <- (0.5 * (CAI1$`2000` + CAI1$`2200`) - CAI1$`2100`)
CAI1$SINDRI <- 100 * (CAI1$`2205` - CAI1$`2260`) / (CAI1$`2205` + CAI1$`2260`)
CAI1$NDTI <- (CAI1$`1660` - CAI1$`2330`) / (CAI1$`1660` + CAI1$`2330`)

CAI <- rbind(CAI1, CAI)
CAI$Scan <- gsub(" ", "", CAI$Scan)

ggplot(CAI, aes(x = RWC, y = CAI, group = Crop, color = Sample)) +
  geom_point() +
  geom_line(size = 1) +
  scale_x_continuous(limits = c(0, 1), breaks = seq(0, 1, by = 0.1)) +
  labs(x = "RWC", y = "CAI") +
  theme(text = element_text(size = 20))

scale_x_discrete(limits = rev(levels(as.factor(CAI$Scan))), guide = guide_axis(angle = 90))

ggplot(dplyr::filter(CAI, Crop == "Wheat Duet" | Crop == "Pomeroy_top"), aes(x = RWC, y = SINDRI, group = Crop, color = Sample)) +
  geom_point() +
  geom_line(size = 1) +
  scale_x_continuous(limits = c(0, 1), breaks = seq(0, 1, by = 0.1)) +
  labs(x = "RWC", y = "SINDRI") +
  theme(axis.text.y = element_blank(), text = element_text(size = 20))

ggplot(dplyr::filter(CAI, Crop == "Wheat Duet" | Crop == "Pomeroy_top"), aes(x = RWC, y = CAI, group = Crop, color = Sample)) +
  geom_point() +
  geom_line(size = 1) +
  scale_x_continuous(limits = c(0, 1), breaks = seq(0, 1, by = 0.1)) +
  labs(x = "RWC", y = "CAI") +
  theme(axis.text.y = element_blank(), text = element_text(size = 20))

ggplot(dplyr::filter(CAI, Crop == "Wheat Duet" | Crop == "Pomeroy_top"), aes(x = RWC, y = NDTI, group = Crop, color = Sample)) +
  geom_point() +
  geom_line(size = 1) +
  scale_x_continuous(limits = c(0, 1), breaks = seq(0, 1, by = 0.1)) +
  labs(x = "RWC", y = "NDTI") +
  theme(axis.text.y = element_blank(), text = element_text(size = 20))

