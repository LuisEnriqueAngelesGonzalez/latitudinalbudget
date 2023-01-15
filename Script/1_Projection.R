# -------------------------------------------------------------------------
# Model projections -------------------------------------------------------
# -------------------------------------------------------------------------

# Load libraries ----------------------------------------------------------

if (!require(mgcv)) install.packages("mgcv") 
if (!require(raster)) install.packages("raster")
if (!require(sf)) install.packages("sf")
source('Script/0_functions.R')


# Read environmental layers -----------------------------------------------

sta_atl      <- stack(list.files('Environmental_layers/Atlantic/', pattern = '', full.names = TRUE))
sta_pac      <- stack(list.files('Environmental_layers/Pacific/', pattern = '', full.names = TRUE))


# Read rasters and shapefiles for continental projections -----------------

con      <- list.files('Environmental_layers/Americas/', full.names = TRUE)[1]
Atl      <- list.files('Shapefiles/', pattern = 'Atlantic_ocean.shp', full.names = TRUE)[1]
Pac      <- list.files('Shapefiles/', pattern = 'Pacific_ocean.shp', full.names = TRUE)[1]

# -------------------------------------------------------------------------
# Run function to obtain fitness maps -------------------------------------
# -------------------------------------------------------------------------

# Atlantic species --------------------------------------------------------

# Callinectes similis -----------------------------------------------------

Temp_fit(lower_pejus = 14,  
         optimum_min = 19, mean = 23.5, optimum_max = 28, 
         upper_pejus = 39, stack = sta_atl, continent = con, 
         shape = Atl, 'Atlantic', 'Callinectes')

# Libinia dubia -----------------------------------------------------------

Temp_fit(lower_pejus = 17,  
         optimum_min = 19, mean = 26, optimum_max = 28, 
         upper_pejus = 34,  stack = sta_atl, continent = con, 
         shape = Atl, 'Atlantic', 'Libinia')

# Panulirus argus ---------------------------------------------------------

Temp_fit(lower_pejus = 15,  
         optimum_min = 22, mean = 25, optimum_max = 28, 
         upper_pejus = 30, stack = sta_atl, continent = con, 
         shape = Atl, 'Atlantic', 'Panulirus')

# Melongena corona --------------------------------------------------------

Temp_fit(lower_pejus = 14,  
         optimum_min = 18, mean = 23.5, optimum_max = 31, 
         upper_pejus = 37, stack = sta_atl, continent = con, 
         shape = Atl, 'Atlantic', 'Melongena')


# Strombus pugilis --------------------------------------------------------

Temp_fit(lower_pejus = 16,  
         optimum_min = 19, mean = 23, optimum_max = 27, 
         upper_pejus = 33, stack = sta_atl, continent = con, 
         shape = Atl, 'Atlantic', 'Strombus')

# Centropomus -------------------------------------------------------------

# 28 

Temp_fit(lower_pejus = 14,  
         optimum_min = 27, mean = 28.5, optimum_max = 30, 
         upper_pejus = 35, stack = sta_atl, continent = con, 
         shape = Atl, 'Atlantic', 'Centropomus')

# Ocyurus -----------------------------------------------------------------

# 26

Temp_fit(lower_pejus = 16,  
         optimum_min = 24, mean = 26.4, optimum_max = 29, 
         upper_pejus = 34, stack = sta_atl, continent = con, 
         shape = Atl, 'Atlantic', 'Ocyurus')

# Octopus -----------------------------------------------------------------

Temp_fit(lower_pejus = NULL, 
         optimum_min = 23, mean = 23.4, optimum_max = 26, 
         upper_pejus = 30, stack = sta_atl, continent = con, 
         folder_name = 'Atlantic', species =  'Octopus')


# Pacific species ---------------------------------------------------------

# Kelletia ----------------------------------------------------------------

Temp_fit(lower_pejus = 12, 
         optimum_min = 13, mean = 13.4, optimum_max = 19, 
         upper_pejus = 29, stack = sta_pac, continent = con, 
         shape = Pac, folder_name = 'Pacific', species =  'Kelletia')

# Lutjanus ----------------------------------------------------------------

Temp_fit(lower_pejus = 20, 
         optimum_min = 24, mean = 26, optimum_max = 28, 
         upper_pejus = 34, stack = sta_pac, continent = con, 
         shape = Pac, folder_name = 'Pacific', species =  'Lutjanus')

# Seriola ----------------------------------------------------------------

Temp_fit(lower_pejus = 18, 
         optimum_min = 22, mean = 26, optimum_max = 28, 
         upper_pejus = 33, stack = sta_pac, continent = con, 
         shape = NULL, folder_name = 'Pacific', species =  'Seriola')


# -------------------------------------------------------------------------
# Binary plot -------------------------------------------------------------
# -------------------------------------------------------------------------

# Load libraries ----------------------------------------------------------

if (!require(raster)) install.packages("raster")
source('Script/0_functions.R')

# Load list of rasters (performance maps) ---------------------------------

Atl <- list.files('Atlantic', full.names = TRUE)
Atl <- Atl[lapply(Atl,function(x) length(grep("Continent",x,value=FALSE))) == 0]

Pac <- list.files('Pacific', full.names = TRUE)
Pac <- Pac[lapply(Pac,function(x) length(grep("Continent",x,value=FALSE))) == 0]


# Atlantic ----------------------------------------------------------------

Bin(Suit_lis = Atl, folder_name = 'Atlantic')


# Pacific -----------------------------------------------------------------

Bin(Suit_lis = Pac, folder_name = 'Pacific')



