# List of packages to check and install if needed
packages_to_install <- c("remotes")

# Function to check and install packages
install_if_missing <- function(packages) {
  for (package in packages) {
    if (!requireNamespace(package, quietly = TRUE)) {
      install.packages(package)
    }
  }
}

# Call the function with the list of packages
install_if_missing(packages_to_install)
# install sourmashconsumr via github
remotes::install_github("Arcadia-Science/sourmashconsumr")

# load libraries
library(sourmashconsumr)
library(dplyr)
library(ggplot2)
library(RColorBrewer)

# Get the file path from the command-line arguments
args <- commandArgs(trailingOnly = TRUE)

# Check if a file path is provided as an argument
if (length(args) == 0) {
  stop("No file path provided. Usage: Rscript plot-sourmash-sankey.R <file>")
}

# Read the file into a data frame (modify as needed based on your file format)
annotated_gather_csv <- args[1]
plot_output <- args[2]

tax_data = sourmashconsumr::read_taxonomy_annotate(annotated_gather_csv) %>%
                            dplyr::mutate(query_name = basename(query_filename))

g <- plot_taxonomy_annotate_sankey(taxonomy_annotate_df = tax_data, tax_glom_level = "order", label=FALSE) +
  ggforce::geom_parallel_sets_labels(colour = 'black', angle = 360, size = 3, hjust = -0.25)

ggsave(plot_output, g, width = 10, height = 6, dpi = 300)

