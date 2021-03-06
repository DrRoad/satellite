if ( !isGeneric('brick') ) {
  setGeneric('brick', function(x, ...)
    standardGeneric('brick'))
}

#' Convert selected layers of a Satellite object to a RasterBrick
#' 
#' @description
#' Convert selected layers of a Satellite object to a RasterBrick
#' 
#' @param x an object of class 'Satellite'
#' @param layer character vector (bcde codes) or integer vector (index) of 
#' the layers to be stacked
#' @param ... additional arguments passed on to \code{\link{brick}}
#' 
#' @examples 
#' path <- system.file("extdata", package = "satellite")
#' files <- list.files(path, pattern = glob2rx("LC08*.TIF"), full.names = TRUE)
#' sat <- satellite(files)
#' 
#' brck <- brick(sat, c("B001n", "B002n", "B003n"))
#' brck
#' 
#' @export
#' @name brick
#' @docType methods
#' @rdname brick
#' @aliases brick,Satellite-method


setMethod('brick', signature(x = 'Satellite'), 
          function(x,
                   layer = names(x),
                   ...) {
            
            if (is.numeric(layer)) layer <- names(x)[layer]
            
            lyrs <- getSatDataLayers(x, bcde = layer)
            xres <- getSatXRes(x, bcde = layer)
            if (length(unique(xres)) > 1) {
              skip <- which(xres == unique(xres)[2])
              warning("\nlayer ", names(skip), " has different resolution",
                      "\nnot stacking this layer")
            }
            ind <- duplicated(xres)
            ind[1] <- TRUE
            brck <- raster::brick(lyrs[ind], ...)
            
            return(brck)
          }
)
