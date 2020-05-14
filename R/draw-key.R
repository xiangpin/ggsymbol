#' Key drawing functions
#'
#' Each Geom has an associated function that draws the key when the geom needs
#' to be displayed in a legend. These are the options built into ggplot2.
#'
#' @param data A single row data frame containing the scaled aesthetics to
#'      display in this key
#' @param params A list of additional parameters supplied to the geom.
#' @param size Width and height of key in mm.
#' @return A grid grob.
#' @rdname draw_key
#' @name draw_key
#' @export
#' @importFrom scales alpha
draw_key_symbol <- function(data, params, size){
    if (is.null(data$symbol)) {
        data$symbol <- 26 
    } else if (! is.numeric(data$symbol)) {
        data$symbol <- translate_symbol_string(data$symbol)
    }
    symbolGrob(x=0.5, y=0.5,
               symbol=data$symbol,
               gp=gpar(fill=alpha(data$fill, data$alpha),
                       col=alpha(data$colour, data$alpha),
                       fontsize = (data$size %||% 1.5) * .pt + (data$stroke %||% 0.5) * .stroke / 2,
                       lwd = (data$stroke %||% 0.5) * .stroke / 2))
}
