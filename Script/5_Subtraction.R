# -------------------------------------------------------------------------
# Substracion -------------------------------------------------------------
# -------------------------------------------------------------------------

if (!require(raster)) install.packages("raster") 
source('Script/0_functions.R')

# Atlantic ----------------------------------------------------------------

# Select performance maps

al <- list.files(pattern = '2003', path = 'Atlantic/', full.names = TRUE)
bl <- list.files(pattern = '2050', path = 'Atlantic/', full.names = TRUE)
cl <- list.files(pattern = '2100', path = 'Atlantic/', full.names = TRUE)

# Select scenarios

my_list        <- c('Present', 'RCP 8.5 2040-2050', 'RCP 8.5 2090-2100')

# Select species

species        <- c('Callinectes', 'Centropomus', 'Libinia',
                    'Melongena', 'Octopus', 'Ocyurus', 'Panulirus', 
                    'Strombus')

# Substract

substraction(present = al, sc2050 = bl, sc2100 = cl, 
             species = species, scenarios = c('RCP2.6', 'RCP4.5', 'RCP6.0', 'RCP8.5'), folder = 'Atlantic')



# Pacific -----------------------------------------------------------------

# Select performance maps

al <- list.files(pattern = '2003', path = 'Pacific/', full.names = TRUE)
bl <- list.files(pattern = '2050', path = 'Pacific/', full.names = TRUE)
cl <- list.files(pattern = '2100', path = 'Pacific/', full.names = TRUE)


my_comparisons <- list(al, bl, cl)

# Select scenarios
my_list        <- c('Present', 'RCP 8.5 2040-2050', 'RCP 8.5 2090-2100')

# Select species

species        <- c('Kelletia', 'Lutjanus', 'Seriola')

# Substract

substraction(present = al, sc2050 = bl, sc2100 = cl, 
             species = species, scenarios = c('RCP2.6', 'RCP4.5', 'RCP6.0', 'RCP8.5'), folder = 'Pacific')



