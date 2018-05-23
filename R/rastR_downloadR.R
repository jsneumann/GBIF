#' rastR_downloadR
#'
#' This function:
#' - reads in a list of GBIF taxonIDs
#' - searches for the corresponding occurence maps using the map api
#' - checks if there is no occurrence data and skips those urls to prevent abortion
#' - writes .tif image files with the occurrence maps for each taxon into a new folder
#'
#' @param webpage A list of URLs to download map data from
#' @param rastR All output file names will start with this, followed by taxonID
#'
#' @export
#' @examples
#'

# load necessary packages

require(stringr)
require(dismo)

# read in data in form of a csv file containing the GBIF taxonIDs to search for

taxonID_big = read.csv('~/Dropbox/Spatial_Bioinformatics/GBIF_Project/TaxonID_tiny.csv')
taxonID_small = taxonID_big[,3]

# Create a list of URLs based on the taxonIDs, using the GBIF map api

webpage = paste0('https://api.gbif.org/v2/map/occurrence/density/0/0/0@1x.png?taxonKey=', taxonID_small, '&squareSize=64&style=classic.point','test.ras')


# The loop will produce an error if an output file of the same name exists (overwrite = FALSE)
# Therefore, create a new folder to make sure it works

dir.create('rastR')
setwd('rastR')

# try(...) tests if the webpage provides an occurence map
# class(...) assigns a new class "try-error", if there is an error for try()
# if(...) {next} skips the webpage[i] if there is no data
# print(paste(...)) prints out an error that indicates which taxonID did not have occurence map data
# the function then creates a raster and writes out each file with the taxonID in the name

stack1 = NULL

for(i in 1:length(webpage)) {
  if(class(try(raster(webpage[i]), silent = T)) == "try-error") {print(paste('could not find webpage with taxonID', taxonID_small[i], sep=' '));
    next}
  rastR = raster(webpage[i])
  # stack1 = stack(rastR, stack1)
  writeRaster(ra, paste('rastR_', taxonID_small[i], sep=''), format = 'GTiff')
}
