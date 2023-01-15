# -------------------------------------------------------------------------
# Create dataframe for relationships --------------------------------------
# -------------------------------------------------------------------------

# Load libraries ----------------------------------------------------------

if (!require(raster)) install.packages("raster") 
source('Script/0_functions.R')

# Atlantic species --------------------------------------------------------

dataframes <- list.files(path = 'Filtered_occurrences/Atlantic/', pattern = '.csv', full.names = TRUE)
layers     <- list.files(path = 'Atlantic/', pattern = 'Continent', full.names = TRUE)

Latitudinal_df(dataframes = dataframes, layers = layers, folder = 'Atlantic')

# Pacific species ---------------------------------------------------------

dataframes <- list.files(path = 'Filtered_occurrences/Pacific/', pattern = '.csv', full.names = TRUE)
layers     <- list.files(path = 'Pacific/', pattern = 'Continent', full.names = TRUE)

Latitudinal_df(dataframes = dataframes, layers = layers, folder = 'Pacific')


