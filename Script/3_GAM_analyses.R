# -------------------------------------------------------------------------
# GAM analyses ------------------------------------------------------------
# -------------------------------------------------------------------------

if (!require(raster)) install.packages("raster") 
source('Script/0_functions.R')

# Atlantic species --------------------------------------------------------

dataframe <- list.files('Relationship/Atlantic/', full.names = TRUE)
names     <- list.files('Relationship/Atlantic/', full.names = FALSE)
names     <- sub('_thin1.csv', '', names)

# ks represent the different values of k tested, in this case 3 to 8.

GAM_K(dataframe = dataframe, names =  names,  ks = seq(3,8,1), folder = 'Atlantic')

# Pacific species ---------------------------------------------------------

dataframe <- list.files('Relationship/Pacific/', full.names = TRUE)
names     <- list.files('Relationship/Pacific/', full.names = FALSE)
names     <- sub('_thin1.csv', '', names)

GAM_K(dataframe = dataframe, names =  names,  ks = seq(3,8,1), folder = 'Pacific')

