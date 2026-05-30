#' MOT
#' @export
#' 
mot <- function(){
  lyrics <- c(
    "Here we go with Leeds United",
    "We're gonna give the boys a hand",
    "Stand up and sing for Leeds United",
    "They are the greatest in the land",
    "",
    "Everyday, we're all gonna say",
    "We love you, Leeds, Leeds, Leeds!",
    "Everywhere, we're gonna be there",
    "We love you, Leeds, Leeds, Leeds!",
    "Marching on together",
    "We're gonna see you win",
    "We are so proud",
    "We shout it out loud",
    "We love you, Leeds, Leeds, Leeds!"
  )

  for (line in lyrics){
    cat(line, "\n")
    utils::flush.console()
    Sys.sleep(3)
  }

}


