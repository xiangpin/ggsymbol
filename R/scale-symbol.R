#' Scales for starshapes, aka glyphs 
#'
#' `scale_symbol` maps discrete variables to six easily discernible symbols.
#' If you have more than 6 levels, you will get a warning message, and the
#' seventh and subsequence levels will not appear on the plot. Use
#' [scale_symbol_manual()] to supply your own values. You can not map
#' a continuous variable to shape.
#'
#' @param default should the symbol be default?
#' @inheritDotParams ggplot2::discrete_scale -expand -position
#' @rdname scale_symbol
#' @importFrom ggplot2 discrete_scale
#' @export
scale_symbol <- function(default=TRUE,...){
    discrete_scale("symbol", "symbol_d", symbol_pal(default), ...)
}

#' @rdname scale_symbol
#' @export
#' @usage NULL
scale_symbol_discrete <- scale_symbol

#' @rdname scale_symbol
#' @export
#' @usage NULL
scale_symbol_ordinal <- function(...) {
  warning("Using symbol for an ordinal variable is not advised", call. = FALSE)
  scale_symbol(...)
}
 
#' @rdname scale_symbol
#' @export
#' @usage NULL
scale_symbol_continuous <- function(...) {
  stop("A continuous variable can not be mapped to symbol", call. = FALSE)
}               

symbol_pal <- function(default=TRUE){
    force(default)
    function(n){
    if (n > 11) {
        msg <- paste("The symbol palette can deal with a maximum of 11 discrete ",
                     "values because more than 11 becomes difficult to discriminate; ",
                     "you have ", n, ". Consider specifying starshapes manually if you ",
                     "must have them.", sep = "")
        warning(paste(strwrap(msg), collapse = "\n"), call. = FALSE)
    }
    if (default){
        c(26, 27, 21, 22, 23, 24, 28, 32, 31, 30, 29)[seq_len(n)]
    }else{
        c(26, 27, 28, 32, 31, 30, 29, 21, 22, 23, 24)[seq_len(n)]
    }
}
}
