# List of packages to check and install if needed
packages_to_install <- c("ggplot2", "dplyr")

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
# Load the necessary libraries
library(ggplot2)
library(dplyr)
# Get the file path from the command-line arguments
args <- commandArgs(trailingOnly = TRUE)

# Check if a file path is provided as an argument
if (length(args) == 0) {
  stop("No file path provided. Usage: Rscript myscript.R <file>")
}

# Read the file into a data frame (modify as needed based on your file format)
data <- read.csv(args[1], stringsAsFactors = FALSE)

killed_kenny_data <- data %>%
  filter(grepl("killed kenny", Line, ignore.case = TRUE))

# Calculate the frequency of each character's name
name_frequency <- killed_kenny_data %>%
  group_by(Character) %>%
  summarise(frequency = n())

# Create the bar plot using ggplot2
k <- ggplot(name_frequency, aes(x = reorder(Character, -frequency), y = frequency)) +
  geom_bar(stat = "identity", fill = "orange", color = "black") +
  labs(title = 'Who said the words "killed Kenny"?',
       x = "Character",
       y = "Number of Times Said") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 12),  # Set x-axis text size
        axis.text.y = element_text(size = 12),  # Set y-axis text size
        axis.title = element_text(size = 14),   # Set axis title text size
        plot.title = element_text(hjust = 0.5, size = 16))  # Set plot title text size and center it
print(k)
ggsave("killed_kenny.png", k, width = 10, height = 6, dpi = 300)