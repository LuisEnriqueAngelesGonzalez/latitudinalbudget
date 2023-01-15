# -------------------------------------------------------------------------
# Code for projections ----------------------------------------------------
# -------------------------------------------------------------------------

Temp_fit <- function(lower_pejus = NULL, 
                     optimum_min = NULL, mean = NULL, optimum_max = NULL, 
                     upper_pejus = NULL, stack,
                     continent = NULL, shape = NULL, folder_name = '', species = '', ...){
  
  # Check for null values
  
  lower_pejus   <- ifelse(!is.null(lower_pejus),lower_pejus, NA)
  optimum_min   <- ifelse(!is.null(optimum_min),optimum_min, NA)
  mean          <- ifelse(!is.null(mean),mean, NA)
  optimum_max   <- ifelse(!is.null(optimum_max),optimum_max, NA)
  upper_pejus   <- ifelse(!is.null(upper_pejus),upper_pejus, NA)
  
  # Create folder to save the results if it doesn't exist
  
  options(warn = -1)
  newdir <- paste0(folder_name)
  if (!dir.exists(newdir)) {dir.create(newdir)}  
  
  
  # Approx function to fit data and GAM to project
  
  dat <- data.frame(x = c(lower_pejus, optimum_min, 
                          mean, optimum_max, upper_pejus), y=c(0, 0.5, 1 ,0.5, 0))
  
  dat  <- na.omit(dat)
  apro <- approx(x = dat$x, dat$y, n = 1000)
  
  tem <- apro$x
  fit <- apro$y
  
  fit[fit < 0] <- 0
  fit[fit > 1] <- 1
  
  phy <- data.frame(cbind(tem, fit))
  phy <- phy[order(tem),] 
  
  gam_fit <- gam(fit ~ s(tem, k = 500),
                 data = phy, family = "gaussian", type = 'response')
  
  # Projection
  
  for(i in 1:length(names(stack))){
    
    # Suitability maps
    
    f   <- paste0(names(stack[[i]]), '.tif')
    ras <- stack[[i]] 
    names(ras)   <- 'tem'
    pre          <- predict(ras, gam_fit, family = "gaussian", type ="response")
    pre[pre < 0] <- 0
    pre[pre > 1] <- 1
    
    # pre <- pre/pre@data@max #relativize values
    
    # 'species' is used to save the raster file with the name of the species modeled
    
    writeRaster(pre, filename = paste0(newdir,'/', species, '_', f), overwrite=TRUE) 
    
    
  }
  
  # Last projection
  
  ras          <- raster(continent)
  
  # Read or ignore shapefile
  if(!is.null(shape))
  {
    shp <- st_read(shape)
  }  else  {
    print(cat('No shapefile specified'))
  }
  
  if(is.null(shape))
  {
    shp <- NULL
  }
  
  if(!is.null(shp))
  {
    ras <- mask(ras, shp)
  }  else  {
    print(cat('Ignoring masking process'))
  }
  
  # Predict and save results
  
  names(ras)   <- 'tem'
  pre          <- predict(ras, gam_fit, family = "gaussian", type = "response")
  
  f <- paste0(newdir,'/', species, '_Continent', '.tif')
  
  pre[pre < 0] <- 0
  pre[pre > 1] <- 1
  
  writeRaster(pre, f, overwrite = TRUE)
  
  options(warn=0)
}

# -------------------------------------------------------------------------
# Code for binary maps ----------------------------------------------------
# -------------------------------------------------------------------------

Bin  <- function(Suit_lis = '', folder_name = ''){
  
  for(i in seq_along(Suit_lis))
  {
    ras <- raster(Suit_lis[i])
    
    # Create a folder
    
    # Create folder if it doesn't exist
    
    options(warn = -1)
    newdir <- paste0('Binary')
    dir.create(file.path(newdir, folder_name), recursive = TRUE)
    options(warn=0)
    
    f <- gsub(".*/", "", Suit_lis[i])
    f <- gsub(".tif", "", f)
    
    # Binary maps (pejus) 
    
    # Pejus map 
    
    pejus   <- reclassify(ras, cbind(0.0000000000000000000000000000000000000000000000000000000001, 0.499999999999999999999999999999999999999999999999999999999999999, 1))
    pejus[pejus != 1] <- 0
    
    
    writeRaster(pejus, filename = paste0('Binary','/',folder_name, '/',  f, '_pej.tif'), overwrite=TRUE) 
    
    # Optimum maps
    
    o_cha   <- cbind(from = c(0, 0.5), 
                     to = c(0.5, 1),
                     becomes = c(0, 1))
    
    optim   <- reclassify(ras, o_cha)
    writeRaster(optim, filename = paste0('Binary','/',folder_name, '/',  f, '_opt.tif'), overwrite=TRUE)
    
  }  
}


# -------------------------------------------------------------------------
# Code to extract performance ---------------------------------------------
# -------------------------------------------------------------------------

Latitudinal_df <- function(dataframes = NULL, layers = NULL, folder = ''){
  options(warn = -1)
  for(i in seq_along(layers))
  {
    # Read data frame and excract performance values
    
    df  <- read.csv(dataframes[i])
    ras <- raster(layers[[i]])
    ext <- extract(ras, df[,c(2,3)])
    df  <- cbind(df[,c(1,3)], ext)
    colnames(df)[3] <- 'Performance'
    f   <- gsub(pattern = "Filtered_occurrences/",
                replacement="",
                x= dataframes[i])

    # Create folder and save results

    newdir <- paste0('Relationship')
    dir.create(file.path(newdir, folder), recursive = TRUE)
    f <- paste0(newdir,'/', f)
    write.csv(df, file = f, row.names = FALSE)
  }
  options(warn=0)
  
}

# -------------------------------------------------------------------------
# Code for statisical analyses (GAM) --------------------------------------
# -------------------------------------------------------------------------

GAM_K <- function(dataframe = '', names =  '',  ks = seq(1,10,1), folder = 'GAM'){
  for(i in seq_along(dataframe))
  {
    
    svTransform <- function(y)
    {
      n <- length(y)
      transformed <- (y * (n-1) + 0.5)/n
      return(transformed)
    }
    
    lis  <- list()
    knot <- list()
    dat  <- read.csv(dataframe[i])
    nam  <- names[i]
    
    Performance <- dat$Performance
    dat$Performance <- ifelse(dat$Performance == 0, svTransform(Performance), dat$Performance)
    
    for(j in seq_along(ks))
    {
      try({    
        kn        <- ks[j]
        mod       <- mgcv::gam(Performance ~ s(Latitude, k = kn), data = dat, family = betar)
        lis[[j]]  <- mod
        knot[[j]] <- ifelse(exists('mod') == TRUE, kn, next)
        rm(mod)
      })
    }
    
    # Create folder for results
    
    options(warn = -1)
    newdir <- paste0('GAM_results')
    dir.create(file.path(newdir, folder), recursive = TRUE)
    options(warn = 0)
    
    # Select best model
    
    AIK    <- lapply(lis,AIC)
    AIK    <- do.call(rbind.data.frame, AIK)
    nlis   <- apply(AIK, 2, which.min)
    s_mod  <- lis[[nlis]]
    f_mod  <- summary(s_mod)
    nam_m  <- paste0(newdir, '/',folder,'/', nam,'_GAM.txt')
    
    # Save knots and aic results
    
    capture.output(f_mod, file = nam_m) 
    kno                <- do.call(rbind.data.frame, knot)
    Aic_full           <- cbind(AIK, kno)
    colnames(Aic_full) <- c('AIC', 'K')
    Aic_full$Species   <- nam
    Aic_full           <- Aic_full[order(Aic_full$AIC, decreasing = FALSE), ]
    nam_m              <- paste0(newdir, '/',folder,'/',nam,'_AIC.csv')
    write.csv(Aic_full, nam_m, row.names = FALSE)
    
    # # Save residuals plot
    # 
    # nam_m  <- paste0(newdir, '/',folder,'/',nam,'_Residuals.pdf')
    # pdf(nam_m)
    # par(mfrow = c(2,2))
    # gam.check(s_mod)
    # rm(lis)
    # rm(knot)
    # dev.off()
  }
}



# -------------------------------------------------------------------------
# Code for extracting values ----------------------------------------------
# -------------------------------------------------------------------------


values_perf <- function(list = '', spe ='', sce = '', year = '',  file = ''){
  lis_1 <- list()
  lis_2 <- list()
  for(i in seq_along(spe))
  {
    selection_b <- list[grepl(spe[i],list)]
    spec        <- spe[i]
    for(j in seq_along(selection_b))
    {
      ras           <- raster(selection_b[[j]])
      val           <- na.omit(as.data.frame(ras, xy=FALSE)) 
      colnames(val) <- 'Performance'
      val$Species   <- spec
      val$Scenarios <- sce[j]
      val$Year      <- year[j]
      lis_1[[j]]    <- val
    }
    lis_2[[i]]      <- lis_1 
  }
  
  # Create folder and save
  
  options(warn = -1)
  dir.create(file.path('Performance_values'))
  nam_m  <- paste0('Performance_values', '/', file, '.csv')
  df     <- dplyr::bind_rows(lis_2)
  write.csv(df, nam_m, row.names = FALSE)
  options(warn = 0)
  
}


# -------------------------------------------------------------------------
# Code for subtractions ---------------------------------------------------
# -------------------------------------------------------------------------

substraction <- function(present = '', sc2050 = '', sc2100 = '', species = '', scenarios = '', folder = ''){
  for(i in seq_along(species)){
    
    spe <- species[i]
    a   <- present[i]
    b   <- sc2050[grepl(spe, sc2050)]
    c   <- sc2100[grepl(spe, sc2100)]
    
    
    for(j in seq_along(b)){
      
      prese <- raster::raster(a)
      r2050 <- raster::raster(b[j])
      r2100 <- raster::raster(c[j])
      
      
      RCP2050 <- r2050 - prese 
      RCP2100 <- r2100 - prese
      
      
      dir.create(file.path('Substraction', folder), recursive = TRUE)
      f1 <- paste0('Substraction', '/', folder, '/', spe, '_', scenarios[j], '_2050', '.tif')
      f2 <- paste0('Substraction', '/', folder, '/', spe, '_', scenarios[j], '_2100', '.tif')
      writeRaster(RCP2050, filename = f1, overwrite = TRUE)
      writeRaster(RCP2100, filename = f2, overwrite = TRUE)
    }
  }
}




