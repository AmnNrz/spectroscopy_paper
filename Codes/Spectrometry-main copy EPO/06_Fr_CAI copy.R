## ---------------------------
##
## Script name:
##
## Purpose of script:
##
## Author: Siddharth Chaudhary
##
## Date Created: 2022-09-20
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

# Load the reshape2 package
library(reshape2)
library(dplyr)
library(ggplot2)

##################################################################
##################################################################
##################################################################

########################### AFTER EPO ###########################

##################################################################
##################################################################
##################################################################
setwd("/Users/aminnorouzi/Library/CloudStorage/GoogleDrive-msaminnorouzi@gmail.com/My Drive/PhD/Projects/Spectroscopy paper/Spectrometry-main copy EPO")
path_to_save = "/Users/aminnorouzi/Library/CloudStorage/GoogleDrive-msaminnorouzi@gmail.com/My Drive/PhD/Projects/Spectroscopy paper/Spectrometry-main copy EPO/index_org_trsfed_crp_sl"
## creating some empty dataframes
Soil_Median <- read.csv("/Users/aminnorouzi/Library/CloudStorage/GoogleDrive-msaminnorouzi@gmail.com/My Drive/PhD/Projects/Spectroscopy paper/Spectrometry-main copy EPO/Soil_Transformed.csv")
Residue_Median <- read.csv("/Users/aminnorouzi/Library/CloudStorage/GoogleDrive-msaminnorouzi@gmail.com/My Drive/PhD/Projects/Spectroscopy paper/Spectrometry-main copy EPO/Residue_Transformed.csv")

## Run 03 to create CAI it might have got altered or saved as soil_residue_combined.csv
CAI <- read.csv("/Users/aminnorouzi/Library/CloudStorage/GoogleDrive-msaminnorouzi@gmail.com/My Drive/PhD/Projects/Spectroscopy paper/Spectrometry-main copy EPO/CAI_transformed_Combined.csv")

desired_colOrder <- c("Sample", "Scan", "Crop", "RWC", "X1600", "X1660", "X2000", "X2100", "X2200", "X2205",
"X2260", "X2330", "CAI", "SINDRI", "NDTI", "R2220", "R1620", "RSWIR", "ROLI")
# Reorder the columns
CAI <- CAI[, desired_colOrder]

crops = unique(CAI[CAI$Sample == "Residue", ]$Crop)
soils = unique(CAI[CAI$Sample == "Soil", ]$Crop)

for (crp in crops) {
  for (sl in soils) {
    a <- data.frame()
    b <- data.frame()
    c <- data.frame()
    d <- data.frame()
    e <- data.frame()
    f <- data.frame()
    
    
    for (i in length(unique(CAI$Scan))) {
      a <- dplyr::filter(CAI, Sample == "Soil")
      b <- dplyr::filter(CAI, Sample == "Residue")
      for (j in unique(a$Crop)) {
        c <- dplyr::filter(a, Crop == j)
        d <- merge(c, b, by.x = "Scan", by.y = "Scan")
        e <- rbind(e, d)
      }
      f <- rbind(f, e)
      }
    
    
    conven_lower <- 0.05 ## 0-15% residue cover
    conven_upper <- 0.10
    med_lower <- 0.17 ## 15-30 % residue cover 22% mean
    med_upper <- 0.25 ## 15-30 % residue cover 22% mean
    conser_lower <- 0.40 ## 30-100 % residue cover 65% mean
    conser_upper <- 0.65 ## 30-100 % residue cover 65% mean
    
    test1_NDTI <- f
    
    test1_NDTI$CAI_conven_lower <- test1_NDTI$NDTI.x * (1 - conven_lower) + test1_NDTI$NDTI.y * (conven_lower)
    test1_NDTI$CAI_conven_upper <- test1_NDTI$NDTI.x * (1 - conven_upper) + test1_NDTI$NDTI.y * (conven_upper)
    test1_NDTI$CAI_med_lower <- test1_NDTI$NDTI.x * (1 - med_lower) + test1_NDTI$NDTI.y * (med_lower)
    test1_NDTI$CAI_med_upper <- test1_NDTI$NDTI.x * (1 - med_upper) + test1_NDTI$NDTI.y * (med_upper)
    test1_NDTI$CAI_conser_lower <- test1_NDTI$NDTI.x * (1 - conser_lower) + test1_NDTI$NDTI.y * (conser_lower)
    test1_NDTI$CAI_conser_upper <- test1_NDTI$NDTI.x * (1 - conser_upper) + test1_NDTI$NDTI.y * (conser_upper)
    
    test2_NDTI <- dplyr::filter(test1_NDTI, Crop.x == sl & Crop.y == crp)
    
    test3_NDTI <- test2_NDTI[c(4,38:43)] ## select the conven,med,conser colums
    
    test3_NDTI <- reshape2::melt(test3_NDTI, id = "RWC.x")
    
    test3_NDTI$variable <- gsub("CAI_conven_lower", conven_lower, test3_NDTI$variable)
    test3_NDTI$variable <- gsub("CAI_conven_upper", conven_upper, test3_NDTI$variable)
    test3_NDTI$variable <- gsub("CAI_med_lower", med_lower, test3_NDTI$variable)
    test3_NDTI$variable <- gsub("CAI_med_upper", med_upper, test3_NDTI$variable)
    test3_NDTI$variable <- gsub("CAI_conser_lower", conser_lower, test3_NDTI$variable)
    test3_NDTI$variable <- gsub("CAI_conser_upper", conser_upper, test3_NDTI$variable)
    test3_NDTI$variable <- as.numeric(test3_NDTI$variable)
    
    names(test3_NDTI)[2] <- "Fraction_Residue_Cover"
    names(test3_NDTI)[3] <- "CAI"
    
    write.csv(test3_NDTI, paste0(path_to_save,"/","NDTI_transformed_", crp, "_", gsub("_", " ", sl), ".csv"), row.names = FALSE)
    
    ##Fig5
    ggplot(test3_NDTI, aes(CAI, Fraction_Residue_Cover, group = factor(RWC.x))) +
      geom_line(aes(color = factor(RWC.x))) +
      geom_point(aes(shape = factor(RWC.x)))+
      labs(y = "Fraction Residue Cover", x = "NDTI") +
      scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, by = 0.2)) +
      theme(text = element_text(size = 20),legend.position = c(0.8, 0.2),
            legend.title=element_blank(),
            legend.margin=margin(c(1,5,5,5)))
    
    ##################################################################
    ##################################################################
    ##################################################################
    
    a <- data.frame()
    b <- data.frame()
    c <- data.frame()
    d <- data.frame()
    e <- data.frame()
    f <- data.frame()
    
    
    for (i in length(unique(CAI$Scan))) {
      a <- dplyr::filter(CAI, Sample == "Soil")
      b <- dplyr::filter(CAI, Sample == "Residue")
      for (j in unique(a$Crop)) {
        c <- dplyr::filter(a, Crop == j)
        d <- merge(c, b, by.x = "Scan", by.y = "Scan")
        e <- rbind(e, d)
      }
      f <- rbind(f, e)
    }
    
    
    conven_lower <- 0.05 ## 0-15% residue cover
    conven_upper <- 0.10
    med_lower <- 0.17 ## 15-30 % residue cover 22% mean
    med_upper <- 0.25 ## 15-30 % residue cover 22% mean
    conser_lower <- 0.40 ## 30-100 % residue cover 65% mean
    conser_upper <- 0.65 ## 30-100 % residue cover 65% mean
    
    test1_CAI <- f
    
    test1_CAI$CAI_conven_lower <- test1_CAI$CAI.x * (1 - conven_lower) + test1_CAI$CAI.y * (conven_lower)
    test1_CAI$CAI_conven_upper <- test1_CAI$CAI.x * (1 - conven_upper) + test1_CAI$CAI.y * (conven_upper)
    test1_CAI$CAI_med_lower <- test1_CAI$CAI.x * (1 - med_lower) + test1_CAI$CAI.y * (med_lower)
    test1_CAI$CAI_med_upper <- test1_CAI$CAI.x * (1 - med_upper) + test1_CAI$CAI.y * (med_upper)
    test1_CAI$CAI_conser_lower <- test1_CAI$CAI.x * (1 - conser_lower) + test1_CAI$CAI.y * (conser_lower)
    test1_CAI$CAI_conser_upper <- test1_CAI$CAI.x * (1 - conser_upper) + test1_CAI$CAI.y * (conser_upper)
    
    test2_CAI <- dplyr::filter(test1_CAI, Crop.x == sl & Crop.y == crp)
    
    test3_CAI <- test2_CAI[c(4,38:43)] ## select the conven,med,conser colums
    
    test3_CAI <- reshape2::melt(test3_CAI, id = "RWC.x")
    
    test3_CAI$variable <- gsub("CAI_conven_lower", conven_lower, test3_CAI$variable)
    test3_CAI$variable <- gsub("CAI_conven_upper", conven_upper, test3_CAI$variable)
    test3_CAI$variable <- gsub("CAI_med_lower", med_lower, test3_CAI$variable)
    test3_CAI$variable <- gsub("CAI_med_upper", med_upper, test3_CAI$variable)
    test3_CAI$variable <- gsub("CAI_conser_lower", conser_lower, test3_CAI$variable)
    test3_CAI$variable <- gsub("CAI_conser_upper", conser_upper, test3_CAI$variable)
    test3_CAI$variable <- as.numeric(test3_CAI$variable)
    
    names(test3_CAI)[2] <- "Fraction_Residue_Cover"
    names(test3_CAI)[3] <- "CAI"
    
    write.csv(test3_CAI, paste0(path_to_save, "/", "CAI_transformed_", crp, "_", gsub("_", " ", sl), ".csv"), row.names = FALSE)
    
    ##Fig5
    ggplot(test3_CAI, aes(CAI, Fraction_Residue_Cover, group = factor(RWC.x))) +
      geom_line(aes(color = factor(RWC.x))) +
      geom_point(aes(shape = factor(RWC.x)))+
      labs(y = "Fraction Residue Cover", x = "CAI") +
      scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, by = 0.2)) +
      theme(text = element_text(size = 20),legend.position = c(0.8, 0.2),
            legend.title=element_blank(),
            legend.margin=margin(c(1,5,5,5)))
    
    ##################################################################
    ##################################################################
    ##################################################################
    
    a <- data.frame()
    b <- data.frame()
    c <- data.frame()
    d <- data.frame()
    e <- data.frame()
    f <- data.frame()
    
    
    for (i in length(unique(CAI$Scan))) {
      a <- dplyr::filter(CAI, Sample == "Soil")
      b <- dplyr::filter(CAI, Sample == "Residue")
      for (j in unique(a$Crop)) {
        c <- dplyr::filter(a, Crop == j)
        d <- merge(c, b, by.x = "Scan", by.y = "Scan")
        e <- rbind(e, d)
      }
      f <- rbind(f, e)
    }
    
    
    conven_lower <- 0.05 ## 0-15% residue cover
    conven_upper <- 0.10
    med_lower <- 0.17 ## 15-30 % residue cover 22% mean
    med_upper <- 0.25 ## 15-30 % residue cover 22% mean
    conser_lower <- 0.40 ## 30-100 % residue cover 65% mean
    conser_upper <- 0.65 ## 30-100 % residue cover 65% mean
    
    test1_SINDRI <- f
    
    test1_SINDRI$CAI_conven_lower <- test1_SINDRI$SINDRI.x * (1 - conven_lower) + test1_SINDRI$SINDRI.y * (conven_lower)
    test1_SINDRI$CAI_conven_upper <- test1_SINDRI$SINDRI.x * (1 - conven_upper) + test1_SINDRI$SINDRI.y * (conven_upper)
    test1_SINDRI$CAI_med_lower <- test1_SINDRI$SINDRI.x * (1 - med_lower) + test1_SINDRI$SINDRI.y * (med_lower)
    test1_SINDRI$CAI_med_upper <- test1_SINDRI$SINDRI.x * (1 - med_upper) + test1_SINDRI$SINDRI.y * (med_upper)
    test1_SINDRI$CAI_conser_lower <- test1_SINDRI$SINDRI.x * (1 - conser_lower) + test1_SINDRI$SINDRI.y * (conser_lower)
    test1_SINDRI$CAI_conser_upper <- test1_SINDRI$SINDRI.x * (1 - conser_upper) + test1_SINDRI$SINDRI.y * (conser_upper)
    
    test2_SINDRI <- dplyr::filter(test1_SINDRI, Crop.x == sl & Crop.y == crp)
    
    test3_SINDRI <- test2_SINDRI[c(4,38:43)] ## select the conven,med,conser colums
    
    test3_SINDRI <- reshape2::melt(test3_SINDRI, id = "RWC.x")
    
    test3_SINDRI$variable <- gsub("CAI_conven_lower", conven_lower, test3_SINDRI$variable)
    test3_SINDRI$variable <- gsub("CAI_conven_upper", conven_upper, test3_SINDRI$variable)
    test3_SINDRI$variable <- gsub("CAI_med_lower", med_lower, test3_SINDRI$variable)
    test3_SINDRI$variable <- gsub("CAI_med_upper", med_upper, test3_SINDRI$variable)
    test3_SINDRI$variable <- gsub("CAI_conser_lower", conser_lower, test3_SINDRI$variable)
    test3_SINDRI$variable <- gsub("CAI_conser_upper", conser_upper, test3_SINDRI$variable)
    test3_SINDRI$variable <- as.numeric(test3_SINDRI$variable)
    
    names(test3_SINDRI)[2] <- "Fraction_Residue_Cover"
    names(test3_SINDRI)[3] <- "CAI"
    
    write.csv(test3_SINDRI, paste0(path_to_save, "/", "SINDRI_transformed_", crp, "_", gsub("_", " ", sl), ".csv"), row.names = FALSE)
    
    ##Fig5
    ggplot(test3_SINDRI, aes(CAI, Fraction_Residue_Cover, group = factor(RWC.x))) +
      geom_line(aes(color = factor(RWC.x))) +
      geom_point(aes(shape = factor(RWC.x)))+
      labs(y = "Fraction Residue Cover", x = "SINDRI") +
      scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, by = 0.2)) +
      theme(text = element_text(size = 20),legend.position = c(0.8, 0.2),
            legend.title=element_blank(),
            legend.margin=margin(c(1,5,5,5)))
    
  }
}
  ##################################################################
  ##################################################################
  ##################################################################

  ########################### BEFORE EPO ###########################

  ##################################################################
  ##################################################################
  ##################################################################

  setwd('/Users/aminnorouzi/Library/CloudStorage/GoogleDrive-msaminnorouzi@gmail.com/My Drive/PhD/Projects/Spectroscopy paper/Spectrometry-main')
  ## creating some empty dataframes
  Soil_Median <- read.csv("/Users/aminnorouzi/Library/CloudStorage/GoogleDrive-msaminnorouzi@gmail.com/My Drive/PhD/Projects/Spectroscopy paper/Spectrometry-main/Soil_08_18.csv")
  Residue_Median <- read.csv("/Users/aminnorouzi/Library/CloudStorage/GoogleDrive-msaminnorouzi@gmail.com/My Drive/PhD/Projects/Spectroscopy paper/Spectrometry-main/Residue_08_18.csv")

  ## Run 03 to create CAI it might have got altered or saved as soil_residue_combined.csv
  CAI <- read.csv("/Users/aminnorouzi/Library/CloudStorage/GoogleDrive-msaminnorouzi@gmail.com/My Drive/PhD/Projects/Spectroscopy paper/Spectrometry-main/CAI_Combined.csv")


  desired_colOrder <- c("Sample", "Scan", "Crop", "RWC", "X1600", "X1660", "X2000", "X2100", "X2200", "X2205",
                        "X2260", "X2330", "CAI", "SINDRI", "NDTI", "R2220", "R1620", "RSWIR", "ROLI")
  # Reorder the columns
  CAI <- CAI[, desired_colOrder]
  
for (crp in crops) {
  for (sl in soils) {
    a <- data.frame()
    b <- data.frame()
    c <- data.frame()
    d <- data.frame()
    e <- data.frame()
    f <- data.frame()
  
  
    for (i in length(unique(CAI$Scan))) {
      a <- dplyr::filter(CAI, Sample == "Soil")
      b <- dplyr::filter(CAI, Sample == "Residue")
      for (j in unique(a$Crop)) {
        c <- dplyr::filter(a, Crop == j)
        d <- merge(c, b, by.x = "Scan", by.y = "Scan")
        e <- rbind(e, d)
      }
      f <- rbind(f, e)
    }
  
    conven_lower <- 0.05 ## 0-15% residue cover
    conven_upper <- 0.10
    med_lower <- 0.17 ## 15-30 % residue cover 22% mean
    med_upper <- 0.25 ## 15-30 % residue cover 22% mean
    conser_lower <- 0.40 ## 30-100 % residue cover 65% mean
    conser_upper <- 0.65 ## 30-100 % residue cover 65% mean
  
    test1_NDTI <- f
  
    test1_NDTI$CAI_conven_lower <- test1_NDTI$NDTI.x * (1 - conven_lower) + test1_NDTI$NDTI.y * (conven_lower)
    test1_NDTI$CAI_conven_upper <- test1_NDTI$NDTI.x * (1 - conven_upper) + test1_NDTI$NDTI.y * (conven_upper)
    test1_NDTI$CAI_med_lower <- test1_NDTI$NDTI.x * (1 - med_lower) + test1_NDTI$NDTI.y * (med_lower)
    test1_NDTI$CAI_med_upper <- test1_NDTI$NDTI.x * (1 - med_upper) + test1_NDTI$NDTI.y * (med_upper)
    test1_NDTI$CAI_conser_lower <- test1_NDTI$NDTI.x * (1 - conser_lower) + test1_NDTI$NDTI.y * (conser_lower)
    test1_NDTI$CAI_conser_upper <- test1_NDTI$NDTI.x * (1 - conser_upper) + test1_NDTI$NDTI.y * (conser_upper)
  
    test2_NDTI <- dplyr::filter(test1_NDTI, Crop.x == sl & Crop.y == crp)
  
    test3_NDTI <- test2_NDTI[c(4,38:43)] ## select the conven,med,conser colums
  
    test3_NDTI <- reshape2::melt(test3_NDTI, id = "RWC.x")
  
    test3_NDTI$variable <- gsub("CAI_conven_lower", conven_lower, test3_NDTI$variable)
    test3_NDTI$variable <- gsub("CAI_conven_upper", conven_upper, test3_NDTI$variable)
    test3_NDTI$variable <- gsub("CAI_med_lower", med_lower, test3_NDTI$variable)
    test3_NDTI$variable <- gsub("CAI_med_upper", med_upper, test3_NDTI$variable)
    test3_NDTI$variable <- gsub("CAI_conser_lower", conser_lower, test3_NDTI$variable)
    test3_NDTI$variable <- gsub("CAI_conser_upper", conser_upper, test3_NDTI$variable)
    test3_NDTI$variable <- as.numeric(test3_NDTI$variable)
  
    names(test3_NDTI)[2] <- "Fraction_Residue_Cover"
    names(test3_NDTI)[3] <- "CAI"
  
    write.csv(test3_NDTI, paste0(path_to_save, "/", "NDTI_Original_", crp, "_", gsub("_", " ", sl), ".csv"), row.names = FALSE)
  
    ##Fig5
    ggplot(test3_NDTI, aes(CAI, Fraction_Residue_Cover, group = factor(RWC.x))) +
      geom_line(aes(color = factor(RWC.x))) +
      geom_point(aes(shape = factor(RWC.x)))+
      labs(y = "Fraction Residue Cover", x = "NDTI") +
      scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, by = 0.2)) +
      theme(text = element_text(size = 20),legend.position = c(0.8, 0.2),
            legend.title=element_blank(),
            legend.margin=margin(c(1,5,5,5)))
  
    ##################################################################
    ##################################################################
    ##################################################################
  
    a <- data.frame()
    b <- data.frame()
    c <- data.frame()
    d <- data.frame()
    e <- data.frame()
    f <- data.frame()
  
  
    for (i in length(unique(CAI$Scan))) {
      a <- dplyr::filter(CAI, Sample == "Soil")
      b <- dplyr::filter(CAI, Sample == "Residue")
      for (j in unique(a$Crop)) {
        c <- dplyr::filter(a, Crop == j)
        d <- merge(c, b, by.x = "Scan", by.y = "Scan")
        e <- rbind(e, d)
      }
      f <- rbind(f, e)
    }
  
  
    conven_lower <- 0.05 ## 0-15% residue cover
    conven_upper <- 0.10
    med_lower <- 0.17 ## 15-30 % residue cover 22% mean
    med_upper <- 0.25 ## 15-30 % residue cover 22% mean
    conser_lower <- 0.40 ## 30-100 % residue cover 65% mean
    conser_upper <- 0.65 ## 30-100 % residue cover 65% mean
  
    test1_CAI <- f
  
    test1_CAI$CAI_conven_lower <- test1_CAI$CAI.x * (1 - conven_lower) + test1_CAI$CAI.y * (conven_lower)
    test1_CAI$CAI_conven_upper <- test1_CAI$CAI.x * (1 - conven_upper) + test1_CAI$CAI.y * (conven_upper)
    test1_CAI$CAI_med_lower <- test1_CAI$CAI.x * (1 - med_lower) + test1_CAI$CAI.y * (med_lower)
    test1_CAI$CAI_med_upper <- test1_CAI$CAI.x * (1 - med_upper) + test1_CAI$CAI.y * (med_upper)
    test1_CAI$CAI_conser_lower <- test1_CAI$CAI.x * (1 - conser_lower) + test1_CAI$CAI.y * (conser_lower)
    test1_CAI$CAI_conser_upper <- test1_CAI$CAI.x * (1 - conser_upper) + test1_CAI$CAI.y * (conser_upper)
  
    test2_CAI <- dplyr::filter(test1_CAI, Crop.x == sl & Crop.y == crp)
  
    test3_CAI <- test2_CAI[c(4,38:43)] ## select the conven,med,conser colums
  
    test3_CAI <- reshape2::melt(test3_CAI, id = "RWC.x")
  
    test3_CAI$variable <- gsub("CAI_conven_lower", conven_lower, test3_CAI$variable)
    test3_CAI$variable <- gsub("CAI_conven_upper", conven_upper, test3_CAI$variable)
    test3_CAI$variable <- gsub("CAI_med_lower", med_lower, test3_CAI$variable)
    test3_CAI$variable <- gsub("CAI_med_upper", med_upper, test3_CAI$variable)
    test3_CAI$variable <- gsub("CAI_conser_lower", conser_lower, test3_CAI$variable)
    test3_CAI$variable <- gsub("CAI_conser_upper", conser_upper, test3_CAI$variable)
    test3_CAI$variable <- as.numeric(test3_CAI$variable)
  
    names(test3_CAI)[2] <- "Fraction_Residue_Cover"
    names(test3_CAI)[3] <- "CAI"
  
    write.csv(test3_CAI, paste0(path_to_save, "/", "CAI_Original_" , crp, "_", gsub("_", " ", sl), ".csv"), row.names = FALSE)
  
    ##Fig5
    ggplot(test3_CAI, aes(CAI, Fraction_Residue_Cover, group = factor(RWC.x))) +
      geom_line(aes(color = factor(RWC.x))) +
      geom_point(aes(shape = factor(RWC.x)))+
      labs(y = "Fraction Residue Cover", x = "CAI") +
      scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, by = 0.2)) +
      theme(text = element_text(size = 20),legend.position = c(0.8, 0.2),
            legend.title=element_blank(),
            legend.margin=margin(c(1,5,5,5)))
  
    ##################################################################
    ##################################################################
    ##################################################################
  
    a <- data.frame()
    b <- data.frame()
    c <- data.frame()
    d <- data.frame()
    e <- data.frame()
    f <- data.frame()
  
  
    for (i in length(unique(CAI$Scan))) {
      a <- dplyr::filter(CAI, Sample == "Soil")
      b <- dplyr::filter(CAI, Sample == "Residue")
      for (j in unique(a$Crop)) {
        c <- dplyr::filter(a, Crop == j)
        d <- merge(c, b, by.x = "Scan", by.y = "Scan")
        e <- rbind(e, d)
      }
      f <- rbind(f, e)
    }
  
  
    conven_lower <- 0.05 ## 0-15% residue cover
    conven_upper <- 0.10
    med_lower <- 0.17 ## 15-30 % residue cover 22% mean
    med_upper <- 0.25 ## 15-30 % residue cover 22% mean
    conser_lower <- 0.40 ## 30-100 % residue cover 65% mean
    conser_upper <- 0.65 ## 30-100 % residue cover 65% mean
  
    test1_SINDRI <- f
  
    test1_SINDRI$CAI_conven_lower <- test1_SINDRI$SINDRI.x * (1 - conven_lower) + test1_SINDRI$SINDRI.y * (conven_lower)
    test1_SINDRI$CAI_conven_upper <- test1_SINDRI$SINDRI.x * (1 - conven_upper) + test1_SINDRI$SINDRI.y * (conven_upper)
    test1_SINDRI$CAI_med_lower <- test1_SINDRI$SINDRI.x * (1 - med_lower) + test1_SINDRI$SINDRI.y * (med_lower)
    test1_SINDRI$CAI_med_upper <- test1_SINDRI$SINDRI.x * (1 - med_upper) + test1_SINDRI$SINDRI.y * (med_upper)
    test1_SINDRI$CAI_conser_lower <- test1_SINDRI$SINDRI.x * (1 - conser_lower) + test1_SINDRI$SINDRI.y * (conser_lower)
    test1_SINDRI$CAI_conser_upper <- test1_SINDRI$SINDRI.x * (1 - conser_upper) + test1_SINDRI$SINDRI.y * (conser_upper)
  
    test2_SINDRI <- dplyr::filter(test1_SINDRI, Crop.x == sl & Crop.y == crp)
  
    test3_SINDRI <- test2_SINDRI[c(4,38:43)] ## select the conven,med,conser colums
  
    test3_SINDRI <- reshape2::melt(test3_SINDRI, id = "RWC.x")
  
    test3_SINDRI$variable <- gsub("CAI_conven_lower", conven_lower, test3_SINDRI$variable)
    test3_SINDRI$variable <- gsub("CAI_conven_upper", conven_upper, test3_SINDRI$variable)
    test3_SINDRI$variable <- gsub("CAI_med_lower", med_lower, test3_SINDRI$variable)
    test3_SINDRI$variable <- gsub("CAI_med_upper", med_upper, test3_SINDRI$variable)
    test3_SINDRI$variable <- gsub("CAI_conser_lower", conser_lower, test3_SINDRI$variable)
    test3_SINDRI$variable <- gsub("CAI_conser_upper", conser_upper, test3_SINDRI$variable)
    test3_SINDRI$variable <- as.numeric(test3_SINDRI$variable)
  
    names(test3_SINDRI)[2] <- "Fraction_Residue_Cover"
    names(test3_SINDRI)[3] <- "CAI"
  
    write.csv(test3_SINDRI, paste0(path_to_save, "/", "SINDRI_Original_", crp, "_", gsub("_", " ", sl),  ".csv"), row.names = FALSE)
  
    ##Fig5
    ggplot(test3_SINDRI, aes(CAI, Fraction_Residue_Cover, group = factor(RWC.x))) +
      geom_line(aes(color = factor(RWC.x))) +
      geom_point(aes(shape = factor(RWC.x)))+
      labs(y = "Fraction Residue Cover", x = "SINDRI") +
      scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, by = 0.2)) +
      theme(text = element_text(size = 20),legend.position = c(0.8, 0.2),
            legend.title=element_blank(),
            legend.margin=margin(c(1,5,5,5)))
  }
}
  
  
  
  
