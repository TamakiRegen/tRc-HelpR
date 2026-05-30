#' Load timestamped file
#' 
#' Load the most recent of a timestamped file (created by trc::save_timestamped())
#' @param target_name the name of the file you want to load (after the timestamp e.g. YYYYMMDD_HHMMSS_target_name
#' @param file_type the extension of the target file (e.g. xlsx, csv)
#' @param sub_dir the sub-directory of here::here() the file is located in. Defaults to here::here()
#' @importFrom rio import
#' @importFrom here here
#' @importFrom stringr str_extract
#' @export
#' 
load_timestamped <- function(target_name, file_type, sub_dir = NULL){
  file_pattern <- paste0("^[0-9]{8}_[0-9]{6}_", target_name, "\\.", file_type, "$")

  # Handle NULL safely so here() and error messages evaluate clearly
  target_dir <- if (is.null(sub_dir)) here::here() else here::here(sub_dir)
  
  if (!dir.exists(target_dir)) {
    stop(paste("Directory does not exist:", target_dir), call. = FALSE)
  }

  files <- list.files(
    target_dir, 
    pattern = file_pattern,
    full.names = TRUE
  )

  files <- files[!grepl("~\\$", basename(files))]
  files <- files[grepl("^[0-9]", basename(files))]

  if (length(files) == 0) {
    stop(
      paste0("No files found matching '", target_name, ".", file_type, "' in: ", target_dir), 
      call. = FALSE
    )
  }

  timestamp_strings <- stringr::str_extract(basename(files), "[0-9]{8}_[0-9]{6}")
  datetimes <- as.POSIXct(strptime(timestamp_strings, format = "%Y%m%d_%H%M%S"))

  if (all(is.na(datetimes))) {
    stop("Failed to parse timestamps from the matched filenames.", call. = FALSE)
  }

  latest_file <- files[which.max(datetimes)]

  return(rio::import(latest_file))
}
