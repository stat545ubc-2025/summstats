#' Calculate Summary Statistics for Numeric Variables
#'
#' This function calculates summary statistics (mean, median, standard deviation,
#' min, max) for numeric variables in a data frame, optionally grouped by a
#' categorical variable.
#'
#' @param data A data frame containing the variables to summarize.
#' @param var A character string or unquoted variable name specifying the
#'   numeric variable to summarize.
#' @param group_by Optional. A character string or unquoted variable name
#'   specifying a categorical variable to group by. If NULL (default), summary
#'   statistics are calculated for the entire dataset.
#'
#' @return A data frame with summary statistics including:
#'   \item{mean}{Mean value}
#'   \item{median}{Median value}
#'   \item{sd}{Standard deviation}
#'   \item{min}{Minimum value}
#'   \item{max}{Maximum value}
#'   \item{n}{Number of observations}
#'   If group_by is specified, the grouping variable is also included.
#'
#' @examples
#' # Load example data
#' library(datateachr)
#' data(cancer_sample)
#'
#' # Calculate summary statistics for radius_mean
#' calculate_summary_stats(cancer_sample, "radius_mean")
#'
#' # Calculate summary statistics grouped by diagnosis
#' calculate_summary_stats(cancer_sample, "radius_mean", group_by = "diagnosis")
#'
#' @importFrom dplyr group_by summarise n
#' @importFrom rlang sym
#' @importFrom stats median sd
#' @importFrom magrittr "%>%"
#' @export
calculate_summary_stats <- function(data, var, group_by = NULL) {
  # Input validation
  if (!is.data.frame(data)) {
    stop("'data' must be a data frame")
  }
  
  if (!is.character(var) || length(var) != 1) {
    stop("'var' must be a single character string")
  }
  
  if (!var %in% names(data)) {
    stop("'var' is not a column in 'data'")
  }
  
  if (!is.numeric(data[[var]])) {
    stop("'var' must be a numeric column")
  }
  
  # Handle grouping
  if (!is.null(group_by)) {
    if (!is.character(group_by) || length(group_by) != 1) {
      stop("'group_by' must be a single character string or NULL")
    }
    
    if (!group_by %in% names(data)) {
      stop("'group_by' is not a column in 'data'")
    }
    
    # Calculate summary statistics by group
    result <- data %>%
      dplyr::group_by(!!rlang::sym(group_by)) %>%
      dplyr::summarise(
        mean = base::mean(!!rlang::sym(var), na.rm = TRUE),
        median = stats::median(!!rlang::sym(var), na.rm = TRUE),
        sd = stats::sd(!!rlang::sym(var), na.rm = TRUE),
        min = base::min(!!rlang::sym(var), na.rm = TRUE),
        max = base::max(!!rlang::sym(var), na.rm = TRUE),
        n = dplyr::n(),
        .groups = "drop"
      )
  } else {
    # Calculate summary statistics for entire dataset
    result <- data %>%
      dplyr::summarise(
        mean = base::mean(!!rlang::sym(var), na.rm = TRUE),
        median = stats::median(!!rlang::sym(var), na.rm = TRUE),
        sd = stats::sd(!!rlang::sym(var), na.rm = TRUE),
        min = base::min(!!rlang::sym(var), na.rm = TRUE),
        max = base::max(!!rlang::sym(var), na.rm = TRUE),
        n = dplyr::n()
      )
  }
  
  return(result)
}

