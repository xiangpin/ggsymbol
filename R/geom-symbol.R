#' Symbols layer
#'
#' geom_symbol provides the symbols layer to easily discernible
#' shapes based on `ggplot2` and `ggstar`, you can use it to 
#' create scatterplots, etc.
#'
#' @eval rd_aesthetics("geom", "symbol")
#' @inheritParams ggplot2::layer
#' @param na.rm If `FALSE`, the default, missing values are removed with
#'     a warning. If `TRUE`, missing values are silently removed.
#' @param ... Other arguments passed on to \code{\link[ggplot2]{layer}}.
#' @importFrom ggplot2 layer
#' @author Shuangbin Xu
#' @export
#' @examples
#' library(ggplot2) 
#' library(ggsymbol)
#' p <- ggplot(data=iris, aes(x=Petal.Length,y=Petal.Width)) +
#'      geom_symbol(aes(color=Species, symbol=Species)) 
#' p
geom_symbol <- function(mapping = NULL,
                        data= NULL,
                        na.rm = FALSE,
                        stat = "identity",
                        position = "identity",
                        show.legend = NA,
                        inherit.aes = TRUE,
                        ...){
    layer(data = data,
          mapping = mapping,
          geom = GeomSymbol,
          stat = stat,
          position = position,
          params = list(na.rm=na.rm,...),
          show.legend = show.legend,
          inherit.aes = inherit.aes)
}

#' GeomSymbol
#' @author Shuangbin Xu
#' @rdname ggsymbol-ggproto
#' @format NULL
#' @usage NULL
#' @importFrom ggplot2 aes ggproto Geom
#' @importFrom grid gpar
#' @export
GeomSymbol <- ggproto("GeomSymbol",
                       Geom,
                       required_aes = c("x", "y"),
                       non_missing_aes = c("size", "symbol"),
                       default_aes = aes(size = 1.5, fill = NA, symbol=26,
                                         angle=0, colour = "black", alpha = 1,
                                         phase=0, stroke=0.5),
                       draw_key = draw_key_symbol,
                       draw_panel=function(data, panel_params, coord){
                           if (is.character(data$symbol)){
                               data$symbol <- translate_symbol_string(data$symbol)
                           }
                           coords <- coord$transform(data, panel_params)
                           grobs <- symbolGrob(x=coords$x,
                                               y=coords$y,
                                               gp=gpar(fill = alpha(coords$fill, coords$alpha),
                                                       col = alpha(coords$colour, coords$alpha),
                                                       fontsize = coords$size * .pt + coords$stroke * .stroke/2,
                                                       lwd = coords$stroke * .stroke / 2),
                                               symbol = coords$symbol,
                                               angle = coords$angle,
                                               phase = coords$phase)
                           ggname("geom_symbol", grobs)
                       }
                   )

# reference ggplot2
shape_table <- c(
    "square open"           = 0,
    "circle open"           = 1,
    "triangle open"         = 2,
    "plus"                  = 3,
    "cross"                 = 4,
    "diamond open"          = 5,
    "triangle down open"    = 6,
    "square cross"          = 7,
    "asterisk"              = 8,
    "diamond plus"          = 9,
    "circle plus"           = 10,
    "star"                  = 11,
    "square plus"           = 12,
    "circle cross"          = 13,
    "square triangle"       = 14,
    "triangle square"       = 14,
    "square"                = 15,
    "circle small"          = 16,
    "triangle"              = 17,
    "diamond"               = 18,
    "circle"                = 19,
    "bullet"                = 20,
    "circle filled"         = 21,
    "square filled"         = 22,
    "diamond filled"        = 23,
    "triangle filled"       = 24,
    "triangle down filled"  = 25,
    "anise star2"           = 26,
    "pentagram"             = 27,
    "magen david"           = 28,
    "regular pentagon"      = 29,
    "seven pointed star"    = 30,
    "anise star"            = 31,
    "hexagon"               = 32
  )

# reference ggplot2
translate_symbol_string <- function(shape_string) {
    # strings of length 0 or 1 are interpreted as symbols by grid
    if (nchar(shape_string[1]) <= 1) {
        return(shape_string)
    }
    shape_match <- charmatch(shape_string, names(shape_table))

    invalid_strings <- is.na(shape_match)
    nonunique_strings <- shape_match == 0

    if (any(invalid_strings)) {
        bad_string <- unique(shape_string[invalid_strings])
        n_bad <- length(bad_string)

        collapsed_names <- sprintf("\n* '%s'", bad_string[1:min(5, n_bad)])

        more_problems <- if (n_bad > 5) {
            sprintf("\n* ... and %d more problem%s", n_bad - 5, ifelse(n_bad > 6, "s", ""))
        }

        stop(
           "Can't find shape name:",
            collapsed_names,
            more_problems,
            call. = FALSE
        )
    }
    if (any(nonunique_strings)) {
        bad_string <- unique(shape_string[nonunique_strings])
        n_bad <- length(bad_string)

        n_matches <- vapply(
           bad_string[1:min(5, n_bad)],
           function(shape_string) sum(grepl(paste0("^", shape_string), names(shape_table))),
           integer(1)
        )

        collapsed_names <- sprintf(
            "\n* '%s' partially matches %d shape names",
            bad_string[1:min(5, n_bad)], n_matches
        )

        more_problems <- if (n_bad > 5) {
            sprintf("\n* ... and %d more problem%s", n_bad - 5, ifelse(n_bad > 6, "s", ""))
        }

        stop(
            "Shape names must be unambiguous:",
            collapsed_names,
            more_problems,
            call. = FALSE
        )
    }

  unname(shape_table[shape_match])
}

#' @importFrom ggstar GeomStar
ggstar::GeomStar
