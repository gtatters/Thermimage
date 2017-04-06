#' @export
#' 
rotate270.matrix <-
function(x) {
  mirror.matrix(t(x))
}
