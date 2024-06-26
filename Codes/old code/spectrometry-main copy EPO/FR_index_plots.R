
# Load the reshape2 package
library(reshape2)
library(dplyr)
library(ggplot2)
library(viridis)
library(scales)

# Set the path to directory
path_to_directory <- "/Users/aminnorouzi/Library/CloudStorage/GoogleDrive-msaminnorouzi@gmail.com/My Drive/PhD/Projects/Spectroscopy paper/Spectrometry-main copy EPO/index_org_trsfed_crp_sl"

# Get a list of all .csv files in the directory
csv_files <- list.files(path = path_to_directory, pattern = "\\.csv$", full.names = FALSE)

# Remove the ".csv" extension from the file names
csv_files <- sub("\\.csv$", "", csv_files)

# Extract characters after the second underscore
csv_files <- sapply(strsplit(csv_files, "_"), function(x) paste(tail(x, -2), collapse = "_"))

print(unique(csv_files))



##################################################################
##################################################################
##################################################################

########################### AFTER EPO ###########################

##################################################################
##################################################################
##################################################################
setwd("/Users/aminnorouzi/Library/CloudStorage/GoogleDrive-msaminnorouzi@gmail.com/My Drive/PhD/Projects/Spectroscopy paper/Spectrometry-main copy EPO")
# NDTI_transformed <- read.csv(paste0('/Users/aminnorouzi/Library/CloudStorage/GoogleDrive-msaminnorouzi@gmail.com/My Drive/PhD/Projects/Spectroscopy paper/Spectrometry-main copy EPO/index_org_trsfed_crp_sl/NDTI_transformed_',name, '.csv'))
# NDTI_original <- read.csv(paste0('/Users/aminnorouzi/Library/CloudStorage/GoogleDrive-msaminnorouzi@gmail.com/My Drive/PhD/Projects/Spectroscopy paper/Spectrometry-main copy EPO/index_org_trsfed_crp_sl/NDTI_Original_', name, '.csv'))
# 
# CAI_transformed <- read.csv(paste0('/Users/aminnorouzi/Library/CloudStorage/GoogleDrive-msaminnorouzi@gmail.com/My Drive/PhD/Projects/Spectroscopy paper/Spectrometry-main copy EPO/index_org_trsfed_crp_sl/CAI_transformed_', name, '.csv'))
# CAI_original <- read.csv(paste0('/Users/aminnorouzi/Library/CloudStorage/GoogleDrive-msaminnorouzi@gmail.com/My Drive/PhD/Projects/Spectroscopy paper/Spectrometry-main copy EPO/index_org_trsfed_crp_sl/CAI_Original_', name, '.csv'))
# 
# SINDRI_transformed <- read.csv(paste0('/Users/aminnorouzi/Library/CloudStorage/GoogleDrive-msaminnorouzi@gmail.com/My Drive/PhD/Projects/Spectroscopy paper/Spectrometry-main copy EPO/index_org_trsfed_crp_sl/SINDRI_transformed_', name, '.csv'))
# SINDRI_original <- read.csv(paste0('/Users/aminnorouzi/Library/CloudStorage/GoogleDrive-msaminnorouzi@gmail.com/My Drive/PhD/Projects/Spectroscopy paper/Spectrometry-main copy EPO/index_org_trsfed_crp_sl/SINDRI_Original_', name, '.csv'))

  for (name in unique(csv_files)) {

  NDTI_transformed <- read.csv(paste0('/Users/aminnorouzi/Library/CloudStorage/GoogleDrive-msaminnorouzi@gmail.com/My Drive/PhD/Projects/Spectroscopy paper/Spectrometry-main copy EPO/index_org_trsfed_crp_sl/NDTI_transformed_',name, '.csv'))
  NDTI_original <- read.csv(paste0('/Users/aminnorouzi/Library/CloudStorage/GoogleDrive-msaminnorouzi@gmail.com/My Drive/PhD/Projects/Spectroscopy paper/Spectrometry-main copy EPO/index_org_trsfed_crp_sl/NDTI_Original_', name, '.csv'))
  
  CAI_transformed <- read.csv(paste0('/Users/aminnorouzi/Library/CloudStorage/GoogleDrive-msaminnorouzi@gmail.com/My Drive/PhD/Projects/Spectroscopy paper/Spectrometry-main copy EPO/index_org_trsfed_crp_sl/CAI_transformed_', name, '.csv'))
  CAI_original <- read.csv(paste0('/Users/aminnorouzi/Library/CloudStorage/GoogleDrive-msaminnorouzi@gmail.com/My Drive/PhD/Projects/Spectroscopy paper/Spectrometry-main copy EPO/index_org_trsfed_crp_sl/CAI_Original_', name, '.csv'))
  
  SINDRI_transformed <- read.csv(paste0('/Users/aminnorouzi/Library/CloudStorage/GoogleDrive-msaminnorouzi@gmail.com/My Drive/PhD/Projects/Spectroscopy paper/Spectrometry-main copy EPO/index_org_trsfed_crp_sl/SINDRI_transformed_', name, '.csv'))
  SINDRI_original <- read.csv(paste0('/Users/aminnorouzi/Library/CloudStorage/GoogleDrive-msaminnorouzi@gmail.com/My Drive/PhD/Projects/Spectroscopy paper/Spectrometry-main copy EPO/index_org_trsfed_crp_sl/SINDRI_Original_', name, '.csv'))
  
  ##Fig5
  ggplot(NDTI_transformed, aes(CAI, Fraction_Residue_Cover, group = factor(RWC.x))) +
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
  
  
  ##Fig5
  ggplot(CAI_transformed, aes(CAI, Fraction_Residue_Cover, group = factor(RWC.x))) +
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
  
  
  ##Fig5
  ggplot(SINDRI_transformed, aes(CAI, Fraction_Residue_Cover, group = factor(RWC.x))) +
    geom_line(aes(color = factor(RWC.x))) +
    geom_point(aes(shape = factor(RWC.x)))+
    labs(y = "Fraction Residue Cover", x = "SINDRI") +
    scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, by = 0.2)) +
    theme(text = element_text(size = 20),legend.position = c(0.8, 0.2),
          legend.title=element_blank(),
          legend.margin=margin(c(1,5,5,5)))
  
  
  
  ##################################################################
  ##################################################################
  ##################################################################
  
  ########################### BEFORE EPO ###########################
  
  ##################################################################
  ##################################################################
  ##################################################################
  
  ##Fig5
  ggplot(NDTI_original, aes(CAI, Fraction_Residue_Cover, group = factor(RWC.x))) +
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
  
  
  ##Fig5
  ggplot(CAI_original, aes(CAI, Fraction_Residue_Cover, group = factor(RWC.x))) +
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
  
  
  ##Fig5
  ggplot(SINDRI_original, aes(CAI, Fraction_Residue_Cover, group = factor(RWC.x))) +
    geom_line(aes(color = factor(RWC.x))) +
    geom_point(aes(shape = factor(RWC.x)))+
    labs(y = "Fraction Residue Cover", x = "SINDRI") +
    scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, by = 0.2)) +
    theme(text = element_text(size = 20),legend.position = c(0.8, 0.2),
          legend.title=element_blank(),
          legend.margin=margin(c(1,5,5,5)))
  
  # Combine the datasets
  
  # For NDTI
  NDTI_transformed$index <- 'After EPO'
  NDTI_transformed$type <- 'NDTI'
  NDTI_original$index <- 'Before EPO'
  NDTI_original$type <- 'NDTI'
  
  # For CAI
  CAI_transformed$index <- 'After EPO'
  CAI_transformed$type <- 'CAI'
  CAI_original$index <- 'Before EPO'
  CAI_original$type <- 'CAI'
  
  # For SINDRI
  SINDRI_transformed$index <- 'After EPO'
  SINDRI_transformed$type <- 'SINDRI'
  SINDRI_original$index <- 'Before EPO'
  SINDRI_original$type <- 'SINDRI'
  
  SINDRI_transformed$CAI <- SINDRI_transformed$CAI/100
  
  # Combine all datasets into one
  combined_data <- rbind(NDTI_original, NDTI_transformed, CAI_original, CAI_transformed, SINDRI_original, SINDRI_transformed)
  # Change the order of levels of 'index'
  combined_data$index <- factor(combined_data$index, levels = c('Before EPO', 'After EPO'))
  
  # Get all unique RWC levels from both dataframes
  all_rwc_levels <- unique(c(combined_data$RWC.x))
  
  # Create a color palette with enough colors for all RWC levels
  custom_colors <- viridis(length(all_rwc_levels))
  custom_colors <- rev(custom_colors)
  
  # Plotting
    ggplot(combined_data, aes(CAI, Fraction_Residue_Cover, group = factor(RWC.x))) +
    geom_line(aes(color = factor(RWC.x))) +
    geom_point(aes(shape = factor(RWC.x), color = factor(RWC.x))) +
    scale_color_manual(values = custom_colors, name = "RWC Levels") +  # Set legend title here
    labs(title = paste0("'", strsplit(name, "_")[[1]][1], "'"," ", "on", " ", "'", strsplit(name, "_")[[1]][2], "'"),
         y = "Fraction Residue Cover") +  # Removed the 'shape' title here
    xlab("") +  # Set X axis label to an empty string to remove it
    theme_minimal() +
    theme(
      plot.title = element_text(hjust = 0.5),  # This line centers the title
      panel.background = element_rect(fill = "white"),
      plot.background = element_rect(fill = "white"),
      panel.grid.major = element_blank(),           # Remove major grid lines
      panel.grid.minor = element_blank(),           # Remove minor grid lines
      strip.background = element_rect(fill = "white"), # Remove facet strip background
      axis.text = element_text(size = 10),
      axis.title = element_text(size = 14),
      legend.text = element_text(size = 12),
      legend.position = "right",
      legend.margin = margin(c(1, 5, 5, 5)),
      legend.key.size = unit(0.4, "cm")
    ) +
    facet_grid(index ~ type, scales = "free") +
    guides(
      shape = FALSE,  # Remove the shape legend
      color = guide_legend(
        override.aes = list(shape = 1:length(custom_colors))  # Set the shapes in the legend
      )
    )
  
    # Save the figure as a PDF with A5 size (width = 14.8 cm, height = 21 cm)
    ggsave(paste0("/Users/aminnorouzi/Library/CloudStorage/GoogleDrive-msaminnorouzi@gmail.com/My Drive/PhD/Projects/Spectroscopy paper/EPO/plots/FR~Index/", name, ".png"), width = 21, height = 14.8, units = "cm")
}



