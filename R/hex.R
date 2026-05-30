#' Hex codes for TRC brand colours
#' 
#' @param type A character string specifying the palette type: "standard" or "light". (Defaults to Standard)
#' @return A character vector of hex codes.
#' @export
hex <- function(type = c("standard", "light")){
  type <- match.arg(type)
  
  colours <- c(
    "#2A7DE2", # blue
    "#15D3C5", # teal
    "#F1636E", # red
    "#60269E", # purple
    "#FF7F30")  # orange

  light_colours <- c(
      "#7fb1ee",
      "#73e5dc",
      "#f7a1a8",
      "#a07dc5",
      "#ffb283"
  )

  if (type == "light"){
    return(light_colours)
  } else {
    return(colours)
  }
}
