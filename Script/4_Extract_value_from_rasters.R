# -------------------------------------------------------------------------
# Extract values ----------------------------------------------------------
# -------------------------------------------------------------------------

if (!require(raster)) install.packages("raster") 
source('Script/0_functions.R')

list <- list.files(path = 'Atlantic/',pattern = '.tif', full.names = TRUE)

# Unselect continental rasters

list <- list[-c(1,11,21, 31,41, 51,61,71)]

# Select species

spe  <- c('Callinectes', 'Centropomus', 'Libinia', 'Melongena', 'Octopus', 'Ocyurus', 'Panulirus', 'Strombus')

# Select scenarios

sce  <- c('Present', 'RCP 2.6', 'RCP 4.5', 'RCP 6.0', 'RCP 8.5', 'RCP 2.6', 'RCP 4.5', 'RCP 6.0', 'RCP 8.5')

# Select year

year <- c('2000', '2050', '2050', '2050', '2050', '2100', '2100', '2100', '2100')

# Atlantic species --------------------------------------------------------

values_perf(list = list, spe = spe, sce = sce, year = year, file = 'Atlantic')

# Pacific species ---------------------------------------------------------

list <- list.files(pattern = '.tif', path = 'Pacific/', full.names = TRUE)

# Unselect continental rasters

list <- list[-c(1,11,21)]

# Select species

spe  <- c('Kelletia', 'Lutjanus', 'Seriola')

# Select scenarios

sce  <- c('Present', 'RCP 2.6', 'RCP 4.5', 'RCP 6', 'RCP 8.5', 'RCP 2.6', 'RCP 4.5', 'RCP 6.0', 'RCP 8.5')

# Select year

year <- c('2000', '2050', '2050', '2050', '2050', '2100', '2100', '2100', '2100')

values_perf(list = list, spe = spe, sce = sce, year = year,  file = 'Pacific')





