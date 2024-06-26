#' EPO Module
#' 
#' @docType module
#' @name epo_module
#' @aliases my_module
#' @title My Module
#' @description This module contains the External Parameter Orthogonalisation (EPO) function(s).
#' @details ...
#' @author Amin Norouzi
#' @seealso \code{\link{...}}
#' @importFrom ...
#' @export ...
#' 
#' # Load the module
#' source("epo_module.R")
#'
#' # Call the function
#' transformed_df <- epo(df)


#' @param df Original reflectances dataframe input.
#' @param num_pc Number of principle components
#' @return Transformed reflectances dataframe output.
#' @examples ...
#' df <- data.frame(ID=1:3, Sample=c('Residue', 'Residue', 'Residue'),
#'                           Type=c('Canola', 'Canola', 'Canola'),
#'                           RWC=c(1, 1, 1),
#'                           Wvl=c(1060, 1070, 1080),
#'                           Reflect=c(12.3, 13.4, 13.5))
#' 
#' @include epo_module.R

library(tibble)
library(reshape2)

library(tidyverse)
library(dplyr)
library(ggplot2)

# # 
# path_to_data <- paste0('/Users/aminnorouzi/Library/CloudStorage/',
#                        'OneDrive-WashingtonStateUniversity(email.wsu.edu)/Ph.D/',
#                        'Projects/Soil_Residue_Spectroscopy/Data/10nm_resolution/')
# path_to_data <- paste0('/home/amnnrz/OneDrive - a.norouzikandelati/Ph.D/',
#                        'Projects/Soil_Residue_Spectroscopy/Data/10nm_resolution/')

# Residue_Median <- read.csv(paste0(path_to_data,
#                                   "Residue.csv"),
#                            header = TRUE, row.names = NULL)
# Residue_Median <- Residue_Median[-c(1, 8)]
# 
# Soil_Median <- read.csv(paste0(path_to_data,
#                                "Soil.csv"),
#                         header = TRUE, row.names = NULL)
# Soil_Median <- Soil_Median[-c(1, 8)]
# 
# Residue_Median <- Residue_Median %>%
#   rename(Type = Soil)
# 
# Soil_Median <- Soil_Median %>%
#   rename(Type = Soil)
# 
# Residue_Median <- Residue_Median %>%
#   mutate(Sample = recode(Sample, "Crop Residue" = "Residue"))
# Dataframe <- Soil_Median
# # Dataframe <- Residue_Median
# type <- 'Athena'
# # type <- 'Canola'
# num_pc <- 1

epo <- function(Dataframe, num_pc = 1){
  transformed_DF <- data.frame()
  for (type in unique(Dataframe$Type)){
    df <- dplyr::filter(Dataframe, Type==type)
    df <- df %>% distinct(Wvl, RWC, .keep_all = TRUE)
    df <- df %>% select(-Scan)
    df <- df %>% 
      pivot_wider(names_from = RWC, values_from = Reflect) 
    
    df <- as.data.frame(df)
    rownames(df) <- df$Wvl
    
    X <- df[, 4:ncol(df)]
    X <- X[, ncol(X):1]
    
    # print(dim(X))
    
    min_col <- which.min(colnames(X))
    X_wet <- X[,-min_col]
    
    D <- X_wet - matrix(rep(X[,min_col], ncol(X_wet)),
                        ncol = ncol(X_wet), byrow = FALSE)
    
    D_mat <- as.matrix(D)
    D_mat <- -D_mat
    
    svd_result <- svd(t(D_mat) %*% D_mat)
    # svd_result <- svd(D_mat %*% t(D_mat))
    
    U <- svd_result$u
    S <- svd_result$d
    V <- svd_result$v
    
    Vs <- t(V)[, 1:num_pc]
    Q <- Vs %*% t(Vs)
    
    # P <- diag(nrow(Q)) - Q
    P <- matrix(1, nrow = nrow(Q), ncol = nrow(Q)) - Q
    
    X_wet <- as.matrix(X_wet)
    P <- as.matrix(P)
    
    X_transformed <- X_wet %*% P
    # X_transformed <- t(X_wet) %*% P
    # X_transformed <- t(X_transformed)
    X <- as.data.frame(X)
    X_transformed <- as.data.frame(X_transformed)
    row.names(X_transformed) <- row.names(X)
    colnames(X_transformed) <- colnames(X_wet)
    X_transformed <- rownames_to_column(X_transformed, var = 'Wvl')
    X_transformed <- melt(X_transformed, id.vars = "Wvl", variable.name = "RWC",
                          value.name = "Reflect")
    org_df_subset <- subset(Dataframe, Type == type)
    org_df_subset$Scan_RWC <- paste(
      as.character(org_df_subset$Scan), as.character(org_df_subset$RWC),
      sep = "_")
    scan_list <- unique(org_df_subset$Scan_RWC)
    
    
    
    mapping_list <- strsplit(scan_list, "_")
    mapping_df <- do.call(rbind, lapply(
      mapping_list, function(x) data.frame(Scan = x[1], RWC = as.numeric(x[2]))))
    
    mapping_dict <- setNames(mapping_df$Scan, mapping_df$RWC)
    
    
    X_transformed$Scan <- mapping_dict[as.character(X_transformed$RWC)]
    
    
    X_transformed <- X_transformed %>% select(Scan, everything())
    
    X_transformed$Type <- type
    
    X_transformed$Sample <- Dataframe$Sample[1]
    
    transformed_DF <- rbind(transformed_DF, X_transformed)
  }
  return(transformed_DF)
}


project <- function(df, num_pc = 1){
  df <- df %>% distinct(Wvl, RWC, .keep_all = TRUE)
  df <- df %>% select(-Scan)
  df <- df %>% 
    pivot_wider(names_from = RWC, values_from = Reflect) 
  
  df <- as.data.frame(df)
  rownames(df) <- df$Wvl
  
  X <- df[, 4:ncol(df)]
  X <- X[, ncol(X):1]
  
  min_col <- which.min(colnames(X))
  X_wet <- X[,-min_col]
  
  D <- X_wet - matrix(rep(X[,min_col], ncol(X_wet)),
                      ncol = ncol(X_wet), byrow = FALSE)
  
  D_mat <- as.matrix(D)
  D_mat <- -D_mat
  
  svd_result <- svd(t(D_mat) %*% D_mat)
  
  U <- svd_result$u
  S <- svd_result$d
  V <- svd_result$v
  
  Vs <- t(V)[, 1:num_pc]
  Q <- Vs %*% t(Vs)
  
  # P <- diag(nrow(Q)) - Q
  P <- matrix(1, nrow = nrow(Q), ncol = nrow(Q)) - Q
  
  X_wet <- as.matrix(X_wet)
  P <- as.matrix(P)

return(P)
}

# Min-Max Normalization
min_max_normalize <- function(matrix) {
  min_val <- min(matrix)
  max_val <- max(matrix)
  normalized_matrix <- (matrix - min_val) / (max_val - min_val)
  return(normalized_matrix)
}

# Robust Scaling
robust_scale <- function(matrix) {
  median_val <- apply(matrix, 2, median)
  Q1 <- apply(matrix, 2, quantile, probs = 0.25)
  Q3 <- apply(matrix, 2, quantile, probs = 0.75)
  IQR <- Q3 - Q1
  scaled_matrix <- sweep(sweep(matrix, 2, median_val, "-"), 2, IQR, "/")
  return(scaled_matrix)
}
Dm <- function(df, sample){
  
  df$Type <- sample
  df <- df %>% distinct(Wvl, RWC, .keep_all = TRUE)
  # df_filtered <- df_filtered %>% select(-Scan)
  df <- df %>%
    pivot_wider(names_from = RWC, values_from = Reflect)
  
  df <- as.data.frame(df)
  rownames(df) <- df$Wvl
  
  X <- df[, 4:ncol(df)]
  # Convert column names to numeric and get the order
  ordered_column_indices <- order(as.numeric(names(X)))
  
  # Sort the dataframe by the ordered indices
  X <- X[, ordered_column_indices]
  X <- X[, c(1, 9:ncol(X))]
  print(dim(X))
  print(X)
  
  min_col <- which.min(colnames(X))
  X_wet <- X[,-min_col]
  
  D_ <- X_wet - matrix(rep(X[,min_col], ncol(X_wet)),
                       ncol = ncol(X_wet), byrow = FALSE)
  
  D_mat <- as.matrix(D_)
  D_mat <- t(D_mat)
  
  D <- as.matrix(D_mat)
  
  # D <- min_max_normalize(D)
  return(D)
}

epo_scenario <- function(df, sample, num_pc = 2){
  
  D <- as.matrix(Dm(df, sample))
  D <- -D
  D <- D[order(as.numeric(rownames(D))), ]
  # D <- t(D)
  
  # Perform SVD on t(D) %*% D
  svd_result <- svd(t(D) %*% D)
  # svd_result <- svd(D)
  
  U <- svd_result$u
  S <- svd_result$d
  V <- svd_result$v
  # print(dim(V))
  
  Vs <- V[, 1:num_pc]
  # print(dim(Vs))
  Q <- Vs %*% t(Vs)
  

  P <- diag(nrow(Q)) - Q
  # P <- matrix(1, nrow = nrow(Q), ncol = nrow(Q)) - Q
  P <- as.matrix(P)
  return(list(P=P, Q=Q))
  
}



#########################
# different D
# type <-  unique(df$Type)[1]
Dm2 <- function(df, sample){
  D <- data.frame()
  for (type in unique(df$Type)){
    df_type <- dplyr::filter(df, Type == type)
    
    # df_type <- df_type %>% distinct(Wvl, RWC, .keep_all = TRUE)
    # df_filtered <- df_filtered %>% select(-Scan)
    df_type <- df_type %>%
      pivot_wider(names_from = RWC, values_from = Reflect)
    
    df_type <- as.data.frame(df_type)
    rownames(df_type) <- df_type$Wvl
    
    X <- df_type[, 4:ncol(df_type)]
    # Convert column names to numeric and get the order
    ordered_column_indices <- order(as.numeric(names(X)))
    
    # Sort the dataframe by the ordered indices
    X <- X[, ordered_column_indices]
    
    # print(dim(X))
    # print(X)
    
    min_col <- which.min(colnames(X))
    X_wet <- X[,-min_col]
    
    D_ <- X_wet - matrix(rep(X[,min_col], ncol(X_wet)),
                         ncol = ncol(X_wet), byrow = FALSE)
    
    D_mat <- as.matrix(D_)
    D_mat <- t(D_mat)
    
    D_type <- as.matrix(D_mat)
    
    D_type <- min_max_normalize(D_type)
    D <- rbind(D, D_type)
    D <- as.matrix(D)
    # D <- min_max_normalize(D)
  }
  return(D)
}

epo_scenario2 <- function(df, sample, num_pc = 1){
  
  D <- as.matrix(Dm2(df, sample))
  D <- -D
  D <- D[order(as.numeric(rownames(D))), ]
  # D <- t(D)
  
  # Perform SVD on t(D) %*% D
  svd_result <- svd(t(D) %*% D)
  # svd_result <- svd(D)
  
  U <- svd_result$u
  S <- svd_result$d
  V <- svd_result$v
  # print(dim(V))
  
  Vs <- V[, 1:num_pc]
  # print(dim(Vs))
  Q <- Vs %*% t(Vs)
  
  
  P <- diag(nrow(Q)) - Q
  P <- as.matrix(P)
  return(list(P=P, Q=Q))
  
}



##########################################
# Projection Matrix of Individual mixes

Dm_indivMix <- function(df, sample){
  
  df$Type <- sample
  df <- df %>% distinct(Wvl, RWC, .keep_all = TRUE)
  # df_filtered <- df_filtered %>% select(-Scan)
  df <- df %>%
    pivot_wider(names_from = RWC, values_from = Reflect)
  
  df <- as.data.frame(df)
  rownames(df) <- df$Wvl
  
  X <- df[, 4:ncol(df)]
  # Convert column names to numeric and get the order
  ordered_column_indices <- order(as.numeric(names(X)))
  
  # Sort the dataframe by the ordered indices
  X <- X[, ordered_column_indices]
  # print(dim(X))
  # print(X)
  
  min_col <- which.min(colnames(X))
  X_wet <- X[,-min_col]
  
  D_ <- X_wet - matrix(rep(X[,min_col], ncol(X_wet)),
                       ncol = ncol(X_wet), byrow = FALSE)
  
  D_mat <- as.matrix(D_)
  D_mat <- t(D_mat)
  
  D <- as.matrix(D_mat)
  
  # D <- min_max_normalize(D)
  return(D)
}

epo_scenario_indivMix_P <- function(df, sample, num_pc = 2){
  
  D <- as.matrix(Dm_indivMix(df, sample))
  D <- -D
  D <- D[order(as.numeric(rownames(D))), ]
  # D <- t(D)
  
  # Perform SVD on t(D) %*% D
  svd_result <- svd(t(D) %*% D)
  # svd_result <- svd(D)
  
  U <- svd_result$u
  S <- svd_result$d
  V <- svd_result$v
  # print(dim(V))
  
  Vs <- V[, 1:num_pc]
  # print(dim(Vs))
  Q <- Vs %*% t(Vs)
  
  
  P <- diag(nrow(Q)) - Q
  # P <- matrix(1, nrow = nrow(Q), ncol = nrow(Q)) - Q
  P <- as.matrix(P)
  return(list(P=P, Q=Q))
  
}




