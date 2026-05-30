#' Hex codes for TRC brand colours
#' 
#' @param type A character string specifying the palette type: "standard" or "light". (Defaults to Standard)
#' @return A character vector of hex codes.
#' @importFrom dplyr tibble
#' @export
hex <- function(type = c("standard", "light")){
  type <- match.arg(type)
  
  colours <- tibble(
    ~hex_code, ~colour,
    "#2A7DE2", "Blue",
    "#15D3C5", "Bright Turquoise",
    "#F1636E", "Red",
    "#60269E", "Purple",
    "#FF7F30",  "Orange")

  light_colours <- tibble(
      ~hex_code, ~colour,
      "#7fb1ee", "Light Blue",
      "#73e5dc", "Light Turquoise",
      "#f7a1a8", "Pink",
      "#a07dc5", "Light Purple",
      "#ffb283", "Light Orange")

  if (type == "light"){
    return(light_colours)
  } else {
    return(colours)
  }
}
