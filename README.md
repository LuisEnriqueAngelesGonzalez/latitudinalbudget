In this repository, the codes to replicate the results and figures of the work titled " Thermal optimality and physiological parameters inferred from experimental studies scale latitudinally with marine species occurrences" are stored in the folder “Script”. The ".Rproj" file allows users to quickly run the codes (R file) numbered from 0 to 5.
In the file 0 there are functions that allow rapid results replication. The user opens the file number 1 and continues progressively (2, 3...) as the results are obtained. 
The start of each script consists of loading the R packages necessary to run the codes as well as loading the functions from the file 0.
Regarding the other folders, "Filtered_occurrences" correspond to GBIF, VERTNET, and OBIS data after the spatial thinning. "Environmental_layers" are the rasters where models projections will be done. Finally, “Shapefiles” folder has the .shp files used to crop environmental layers if necessary. 

Next, we briefly explain what each file does:
1) Code 1 (projections) consist in functions that allow the user to project the performance estimated to different environmental layers ("tif files in the Environmental_layers folder"). Code 1 also has a function that allows users to transform the performance map to optimum and pejus region. In the current configuration of the code, a folder called "Atlantic" and "Pacific" will be created with the performance maps  will optimum and pejus map will be created in the folder called Binary with the subfolder "Atlantic" and "Pacific". 
2) Code 2 allows users to extract the performance values according to the coordinates of the reported occurrence of the species ("Filtered_occurrences"). 
3) Code 3 creates and test different models according to predefined values of 'k'. A folder "GAM_results" is created with two subfolders, "Atlantic" and "Pacific". GAM results are saved on those folders. 
4) The code four extract all pixel values from performance maps of the Economic Exclusive Zone of Mexico to be plotted on a boxplot later. Results are saved in a folder called "Performance_values" with two subfolders: ' Atlantic' and 'Pacific'.
5) The code five corresponds to a subtraction between the present and future scenarios to identify vulnerable regions and potential thermal refuge zones. Results are saved in the subtraction folder. 



