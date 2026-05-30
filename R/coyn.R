#' C'mon you Nix!
#' @export
coyn <- function(){
  lyrics <- c("Oh Wellington!",
  "Oh Wellington!",
  "Is wonderful!",
  "Is wonderful!",
  "Oh Wellington is wonderful!",
  "We have the wind, the rain and the Phoenix!",
  "Oh Wellington is wonderful!"
  )

  for (line in lyrics){
    cat(line, '\n')
    utils::flush.console()
    Sys.sleep(2)
  }

}
