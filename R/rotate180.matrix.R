#' @export
#' 
rotate180.matrix <-
function(x) { 
  xx <- rev(x);
  dim(xx) <- dim(x);
  xx;
}
