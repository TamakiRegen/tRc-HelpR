#' Convert Dates to FY
#' 
#' This function takes a date value and returns the NZ Financial Year (FY) and quarter
#' and displays it as a four digit year value, a year-quarter, or quarter depending on 
#' the type selected.
#' 
#' @param dates a date object
#' @param type selection of how you want the FY value returned.
#' @return str showing the FY and/or quarter of the selected date object.
#' @export
d2fyq <- function(dates, type = c("year", "year_quarter", "quarter")) {
  type <- match.arg(type)
  dates <- as.Date(dates)
  year  <- as.integer(format(dates, "%Y"))
  month <- as.integer(format(dates, "%m"))
  fy_year <- ifelse(month >= 7, year + 1, year)
  q <- paste0("Q", ((month - 7) %% 12) %/% 3 + 1)

  switch(type,
    year         = as.character(fy_year),
    year_quarter = paste(fy_year, q),
    quarter      = q
  )
}
