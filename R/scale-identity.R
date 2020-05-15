#' Use values without scaling
#' 
#' @inheritDotParams ggplot2::continuous_scale
#' @param guide Guide to use for this scale. Defaults to `"none"`.
#' @seealso \code{\link[ggplot2]{scale_shape_identity}}
#' @importFrom ggplot2 continuous_scale ScaleContinuousIdentity
#' @export
scale_symbol_identity <- function(..., guide = "none") {
    sc <- continuous_scale("symbol", "identity", scales::identity_pal(), ..., guide = guide,
                           super = ScaleContinuousIdentity)
    sc
}
