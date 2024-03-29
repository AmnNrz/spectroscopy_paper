## ---------------------------
##
## Script name: Read files generated from spectrometer
##
## Purpose of script:Reading spectral reflectance of crop residues and soil for different water content
##
## Author: Siddharth Chaudhary
##
## Date Created: 2022-08-26
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

## Required packages

library(tidyverse)
library(magrittr)
library(plyr)

## Reading spectral refleactance of crop resideus

Data.in <- (list.files(
  path = "/Users/aminnorouzi/Library/CloudStorage/GoogleDrive-msaminnorouzi@gmail.com/My Drive/PhD/Projects/Spectroscopy paper/Updated_data/Data/Spectral Reflectance/Crop Residue",
  pattern = "*.sed", recursive = TRUE, full.names = TRUE
))

read_csv_filename <- function(filename) {
  ret <- read_delim(filename, delim = "\t", skip = 26)
  ret$Source <- filename
  ret
}

Residue <- ldply(Data.in, read_csv_filename)
Residue <- separate(data = Residue, col = Source, into = c(NA, NA, NA, NA,
                                                           NA, NA, NA, NA,
                                                           NA, NA, NA, NA, NA,
                                                          "Sample", "Scan", "Crop", NA, NA), sep = "/")
Residue$`Reflect. %` <- as.double(Residue$`Reflect. %`)
Residue$Wvl <- as.double(Residue$Wvl)
# 
## Details about RWC for each scan
CropMoisture <- read.csv("/Users/aminnorouzi/Library/CloudStorage/GoogleDrive-msaminnorouzi@gmail.com/My Drive/PhD/Projects/Spectroscopy paper/Updated_data/Data/CropMoisture.csv")
CropMoisture$RWC <- ifelse(CropMoisture$RWC > 1, 1, CropMoisture$RWC)
# 
Residue <- merge(Residue, CropMoisture, by = c("Scan", "Crop"))
# 
Residue_Median <- Residue %>%
  group_by(Wvl, Sample, Scan, Crop) %>%
  # mutate(SmoothRef = savgol((Residue$`Reflect. %`), 51, 2,0)) %>%
  summarise_all(.funs = c("median"))
# 
setwd("/Users/aminnorouzi/Library/CloudStorage/GoogleDrive-msaminnorouzi@gmail.com/My Drive/PhD/Projects/Spectroscopy paper/Spectrometry-main")
write.csv(Residue_Median, "Residue_08_18.csv", row.names = FALSE)
# 
## Reading spectral reflectance of soil samples
Data.in <- (list.files(
  path = "/Users/aminnorouzi/Library/CloudStorage/GoogleDrive-msaminnorouzi@gmail.com/My Drive/PhD/Projects/Spectroscopy paper/Updated_data/Data/Spectral Reflectance/Soil",
  pattern = "*.sed", recursive = TRUE, full.names = TRUE
))
# 
read_csv_filename <- function(filename) {
  ret <- read_delim(filename, delim = "\t", skip = 26)
  ret$Source <- filename
  ret
}
# 
Soil <- ldply(Data.in, read_csv_filename)
Soil <- separate(data = Soil, col = Source, into = c(NA, NA, NA, NA,
                                                     NA, NA, NA, NA,
                                                     NA, NA, NA, NA, NA, 
                                                     "Sample", "Scan", "Crop", NA, NA), sep = "/")
Soil$`Reflect. %` <- as.double(Soil$`Reflect. %`)
Soil$Wvl <- as.double(Soil$Wvl)
# 
## Details about RWC for each scan
SoilMoisture <- read.csv("/Users/aminnorouzi/Library/CloudStorage/GoogleDrive-msaminnorouzi@gmail.com/My Drive/PhD/Projects/Spectroscopy paper/Updated_data/Data/SoilMoisture.csv")
Soil <- merge(Soil, SoilMoisture, by = c("Scan", "Crop"))

Soil_Median <- Soil %>%
  group_by(Wvl, Sample, Scan, Crop) %>%
  # mutate(SmoothRef = savgol((Soil$`Reflect. %`), 51, 2,0)) %>%
  summarise_all(.funs = c("median"))
setwd("/Users/aminnorouzi/Library/CloudStorage/GoogleDrive-msaminnorouzi@gmail.com/My Drive/PhD/Projects/Spectroscopy paper/Spectrometry-main copy EPO")

write.csv(Soil_Median, "Soil_08_18.csv", row.names = FALSE)
