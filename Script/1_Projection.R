# -------------------------------------------------------------------------
# Function ----------------------------------------------------------------
# -------------------------------------------------------------------------

# Install and load libraries

if (!require(mgcv)) install.packages("mgcv") 
if (!require(raster)) install.packages("raster")

# Load function to obtain results

Temp_fit <- function(pejus_min, optimum_min, mean, optimum_max, 
                     pejus_max, stack, folder_name, species, ...){
  
  # Create folder if it doesn't exist
  
  options(warn = -1)
  newdir <- paste0(folder_name)
  if (!dir.exists(newdir)) {dir.create(newdir)}  
  
  # GAM analysis
  
  dat <- data.frame(x = c(pejus_min, optimum_min, mean, optimum_max, pejus_max), y=c(0, 0.75, 1 ,0.75, 0))
  plot.new() # Mandatory
  res <- xspline(dat$x, dat$y, -0.5, draw=FALSE)
  tem <- res$x
  fit <- res$y
  phy <- data.frame(cbind(tem, fit))
  gam_fit <- gam(fit ~ s(tem, k = 70),
                 data = phy, method = "REML", family = "gaussian")
  
  # Projection
  
  for(i in 1:length(names(stack))){
    
    # Suitability maps
    
    f   <- paste0(names(stack[[i]]), '.tif')
    ras <- stack[[i]] 
    names(ras)   <- 'tem'
    pre   <- predict(ras, gam_fit, family = gaussian, type ="response", scale=TRUE)
    pre[pre < 0] <- 0
    pre[pre > 1] <- 1
    
    # pre <- pre/pre@data@max #relativize values
    
    writeRaster(pre, filename = paste0(newdir,'/', species, '_', f), overwrite=TRUE) 
    
    # Binary maps (pejus) 
    
    pejus   <- reclassify(pre, cbind(0.0000000000000000000000000000000000000000000000000000000001, 0.7499999999999999999999999999999999999999999999999999999999999999, 1))
    pejus[pejus != 1] <- 0
    writeRaster(pejus, filename = paste0(newdir,'/',species, '_', 'bin_pej_',  f), overwrite=TRUE) 
    
    # Optimum maps (optimum) 
    
    o_cha   <- cbind(from = c(0, 0.75), 
                     to = c(0.75, 1),
                     becomes = c(0, 1))
    
    optim   <- reclassify(pre, o_cha)
    writeRaster(optim, filename = paste0(newdir,'/', species,'_', 'bin_opt_', f), overwrite=TRUE) 
    
  }
  options(warn=0)
}


# Function fit the model in a specifed stack raster
# the inputs are the pejus temperatures and the 
# optimumum tempeatures.
# The stack in the following example is "sta" is the stack.
# The function creates a folder where results are saved
# "Atlantic" and "Pacific". The species name
# is used to save the projections with the species
# name

# -------------------------------------------------------------------------
# Atlantic Projection -----------------------------------------------------
# ------------------------------------------------------------------------


sta      <- list.files('Environmental_layers/Atlantic/', pattern = '', full.names = TRUE)
sta      <- stack(sta)

# Callinectes similis

Temp_fit(16, 21, 22.5, 24, 32, sta, 'Atlantic', 'Callinectes')

# Libinia dubia

Temp_fit(15, 22, 24, 26, 34, sta, 'Atlantic', 'Libinia')

# Panulirus argus

Temp_fit(14, 22, 25, 28, 32, sta, 'Atlantic', 'Panulirus')

# Melongena Corona Bispinosa

Temp_fit(7, 19, 24, 29, 42, sta, 'Atlantic', 'Melongena')

# Octopus maya

Temp_fit(17, 19, 23, 27, 30, sta, 'Atlantic', 'Octopus')

# Strombus pugilis 

Temp_fit(14, 18, 24.5, 31, 34, sta, 'Atlantic', 'Strombus')

# Centropomus undecimalis

Temp_fit(18, 26, 29, 32, 38, sta, 'Atlantic', 'Centropomus')

# Ocyurus chrysurus

Temp_fit(16, 23, 27, 31, 35, sta, 'Atlantic', 'Ocyurus')

# -------------------------------------------------------------------------
# Pacific Projection ------------------------------------------------------
# -------------------------------------------------------------------------

sta      <- list.files('Environmental_layers/Pacific/', pattern = '.asc', full.names = TRUE)
sta      <- stack(sta)


# Kelletia Kellettii

Temp_fit(12, 13, 18.5, 24, 29, sta, 'Pacific', 'Kelletia')

# Lutjanus gutattus

Temp_fit(20, 24, 27, 30, 36, sta, 'Pacific', 'Lutjanus')

# Seriola	lalandi

Temp_fit(17, 24, 25.5, 27, 34, sta, 'Pacific', 'Seriola')




