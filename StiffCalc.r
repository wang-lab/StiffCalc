library(glmnet)
library(optparse)

args <- commandArgs(trailingOnly = TRUE)

# Define command-line options using optparse
option_list <- list(
  make_option(c("-i", "--input"), type = "character", default = NULL, 
              help = "Input file path", metavar = "character"),
  make_option(c("-o", "--output"), type = "character", default = "predicted_classes.txt", 
              help = "Output file path [default = %default]", metavar = "character")
)

# Parse the command-line arguments
opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)

# Check if input file is provided
if (is.null(opt$input)) {
  stop("Please provide an input file using the -i or --input flag.")
}


# Read the input file
cat("Loading input file...\n")
input_data <- read.csv(opt$input, row.names = 1, sep = "\t")


# Define the gene signatures of interest
gene_signatures <- c('S1PR1', 'EDN2', 'DIO2', 'KRT14', 'DAW1', 'KRT17', 'TNNT2', 'IL6', 'DOCK4')

convert_to_cpm <- function(count_matrix) {
  # Calculate the total counts per sample (column)
  total_counts <- colSums(count_matrix)
  
  # Convert raw counts to CPM
  cpm_matrix <- t(t(count_matrix) / total_counts) * 1e6
  
  return(cpm_matrix)
}

# Convert raw counts to CPM (Counts Per Million)


# Function to normalize a row (z-score normalization)
normalize_row <- function(row) {
  mean_val <- mean(row)
  sd_val <- sd(row)
  (row - mean_val) / sd_val
}

# Apply normalization to each row
cat("Normalizing data...\n")
input_cpm_data <- convert_to_cpm(input_data)
normalize_data <- t(apply(input_cpm_data, 1, normalize_row))

# Load prediction model
cat("Loading prediction model...\n")
load("StiffCalc.RData")


normalize_sig_data <- normalize_data[rownames(normalize_data) %in% gene_signatures, ]
normalize_sig_data <- normalize_sig_data[order(rownames(normalize_sig_data)), ]
normalize_sig_data <- t(normalize_sig_data)

cat("Making predictions...\n")
predictions <- predict(fit, newx = as.matrix(normalize_sig_data), type = "response")
predicted_classes <- ifelse(predictions > 0.5, "stiff", "soft")

cat("Saving predicted classes...\n")
write.table(predicted_classes, file = opt$output, row.names = TRUE, col.names = c("\ttumor_rigidity_label"), sep = "\t", quote = FALSE)

cat("Prediction finished and results saved.\n")



