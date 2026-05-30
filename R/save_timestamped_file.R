#' Save timestamped file
#' 
#' Save an object as a timestamped file using YYYYMMDD_HHMMSS_filename.ext format.
#' Note: if you want to export multiple objects to different sheets of an excel workbook
#' consider using rio::export() directly.
#' 
#' @param object_to_save the object (df, list, etc) you wish to save
#' @param filename the name the file will have (after the timestamp)
#' @param sub_dir the sub-directory of here::here() you want to save the file to. Defaults to current working directory.
#' @param extension the extension you want to save the file as (e.g. xlsx)
#' @return a timestamped file of the filetype specified in extension.
#' @importFrom rio export
#' @importFrom here here
#' @export
#' 
save_timestamped <- function(object_to_save, filename, sub_dir = NULL, extension){
  current_time  <- format(Sys.time(), "%Y%m%d_%H%M%S")
  filename <- paste0(current_time, "_", filename, ".", extension)
  full_path <- here::here(sub_dir, filename)
  rio::export(object_to_save, full_path)
}