#' @importFrom grid gTree
symbolGrob <- function(x=0.5, y=0.5,
                        symbol=26,
                        angle=0,
                        phase = 0,
                        position.units = "npc",
                        size.units = "mm",
                        gp= gpar(fill="black",
                                 fontsize=2,
                                 alpha=1,
                                 col=NA, lwd=0.5),
                        ...){
    grobs <- mapply(.symbolGrob, 
                    x=x, y=y,
                    symbol=symbol,
                    angle=angle,
                    phase=phase,
                    position.units=position.units,
                    size.units=size.units,
	            col=gp$col,
                    fill=gp$fill,
                    fontsize=gp$fontsize,
                    lwd=gp$lwd, 
                    MoreArgs=list(...),
                    SIMPLIFY=FALSE)
    class(grobs) <- "gList"
    grobs <- gTree(children=grobs)
    return(grobs)                      
}

#' @importFrom grid grid.draw
grid.symbol <- function(x=0.5, y=0.5, 
                         symbol=26,
			 angle=0,
                         phase=0,
                         position.units = "npc",
                         size.units="mm",
                         draw = TRUE, 
                         gp=NULL, vp=NULL, ...){
    
    sg <- symbolGrob(x = x, y = y,
                      symbol = symbol,
                      angle = angle,
                      gp = gp,
                      position.units = position.units,
                      size.units = size.units,
                      vp = vp,...)
    if (draw){
        grid.draw(sg)
    }
    invisible(sg)
}

shape_starshape <- c(9, 1, 2, 5, 3, 4, 6)
names(shape_starshape) <- seq(26, 32)

match_shape <- function(shape){
    shape <- shape_starshape[match(shape,names(shape_starshape))]
    return(unname(shape))
}

#' @importFrom grid pointsGrob
.symbolGrob <- function(x, y, symbol, 
                        angle, phase, 
                        position.units, size.units,
                        fill, fontsize, alpha, col, lwd, ...){
    if (symbol %in% c(26, 27, 28, 29, 30, 31, 32)){
        symbol <- match_shape(symbol)
        g <- starGrob(x=x, y=y,
                      starshape=symbol,
                      position.units=position.units,
                      size.units=size.units,
                      gp=gpar(col=col,
                              fill=fill,
                              fontsize=fontsize/5,
                              lwd=lwd),
                      angle=angle,
                      phase=phase, ...)
    }else{
        g <- pointsGrob(x=x, y=y, 
                        pch=symbol, 
                        gp=gpar(col=col,
                                fill=fill,
                                fontsize=fontsize,
                                lwd=lwd),
                        default.units="native")
    }
    return(g)
}

