#' @export
#' 
flip.matrix <-
function(x) {
  mirror.matrix(rotate180.matrix(x))
}
