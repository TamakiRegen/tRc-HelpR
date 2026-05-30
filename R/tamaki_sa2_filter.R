#' Tamaki SA2 filter
#' 
#' Filters a list of StatsNZ Census 2023 SA2 codes to those that encompass
#' the Tamaki Regeneration area.
#' 
#' @param data The dataframe that contains SA2 codes that you want filtered.
#' @param col The column in df containing  SA2 codes.
#' @return A filtered dataframe that only contains SA2 codes for Tamaki.
#' @importFrom dplyr filter
#' @export
sa2 <- function(data, col) {
  # Define Tamaki SA2 codes
  tamaki_codes <- c(
    144700, 145400, 145800, 146301, 146302,
    146700, 147001, 147002, 147100
  )
  # Extract the target column values from the data frame
  col_values <- data[[col]]
  
  # Check if column exists
  if (is.null(col_values)) {
    stop("Column '", col, "' does not exist in the data.")
  }
  # Check for 6-digit format (coercing to character to safely count digits)
  all_six_digits <- all(nchar(as.character(na.omit(col_values))) == 6)
  if (!all_six_digits) {
    stop("wrong column format. col should be six digit SA2 code")
  }
  
  # Check if any Tsmaki codes exist in the column
  has_tamaki <- any(col_values %in% tamaki_codes)
  if (!has_tamaki) {
    stop("no Tāmaki SA2s found in data")
  }
  
  # Filter and return data frame if all checks pass
  dplyr::filter(data, .data[[col]] %in% tamaki_codes)
}
