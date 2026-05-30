#' Apply the Rehousing Matrix
#' 
#' @description 
#' This applies the TRC rehousing matrix to a current bedroom value. This provides
#' an *indicative demand only* and should be validated with THA before acting
#' on code output. For more information on caveats visit github.com/TamakiRegen/rh_matrix.
#' 
#' Note that current values of NA, 0, or >=6 will return the current value.
#'
#' @param current A numeric vector of current bed counts.
#' @return A numeric vector of sampled required beds, or the original count if failsafes trigger.
#' @export
#' 
rh_matrix<- function(current) {
  # Handle empty inputs gracefully
  if (length(current) == 0) return(current)
  
  # Core sampling logic for a single valid value
  sample_single <- function(curr) {
    # 'dist' is automatically available from sysdata.rda
    d <- dist[dist$beds_current == curr, ]
    
    if (nrow(d) == 0) {
      return(NA_real_) 
    }
    
    sample(d$beds_req, size = 1, prob = d$pct_shift)
  }
  
  # Run the sampling logic across the vector
  sampled_values <- vapply(current, sample_single, FUN.VALUE = numeric(1))
  
  # Failsafe mask: identify where current is 0, >= 6, or missing
  failsafe_mask <- (current == 0 | current >= 6) & !is.na(current)
  
  # Replace sampled values with the original 'current' values where mask is TRUE
  sampled_values[failsafe_mask] <- current[failsafe_mask]
  
  return(sampled_values)
}
