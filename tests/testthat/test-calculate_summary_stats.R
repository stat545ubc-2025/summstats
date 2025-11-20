test_that("calculate_summary_stats works with valid inputs", {
  # Create test data
  test_data <- data.frame(
    value = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10),
    group = c("A", "A", "A", "B", "B", "B", "C", "C", "C", "C")
  )
  
  # Test without grouping
  result <- calculate_summary_stats(test_data, "value")
  
  expect_s3_class(result, "data.frame")
  expect_equal(ncol(result), 6)
  expect_equal(nrow(result), 1)
  expect_equal(result$mean, 5.5)
  expect_equal(result$median, 5.5)
  expect_equal(result$min, 1)
  expect_equal(result$max, 10)
  expect_equal(result$n, 10)
})

test_that("calculate_summary_stats works with grouping", {
  # Create test data
  test_data <- data.frame(
    value = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10),
    group = c("A", "A", "A", "B", "B", "B", "C", "C", "C", "C")
  )
  
  # Test with grouping
  result <- calculate_summary_stats(test_data, "value", group_by = "group")
  
  expect_s3_class(result, "data.frame")
  expect_equal(ncol(result), 7)  # 6 stats + 1 grouping variable
  expect_equal(nrow(result), 3)  # 3 groups
  expect_true("group" %in% names(result))
})

test_that("calculate_summary_stats handles missing values", {
  # Create test data with NAs
  test_data <- data.frame(
    value = c(1, 2, NA, 4, 5, NA, 7, 8, 9, 10),
    group = c("A", "A", "A", "B", "B", "B", "C", "C", "C", "C")
  )
  
  # Should not error and should exclude NAs
  result <- calculate_summary_stats(test_data, "value")
  
  expect_s3_class(result, "data.frame")
  expect_false(is.na(result$mean))
  expect_false(is.na(result$median))
})

test_that("calculate_summary_stats gives appropriate error messages", {
  # Test with non-data.frame input
  expect_error(
    calculate_summary_stats("not a data frame", "value"),
    "'data' must be a data frame"
  )
  
  # Test with invalid variable name
  test_data <- data.frame(value = 1:10)
  expect_error(
    calculate_summary_stats(test_data, "nonexistent"),
    "is not a column in 'data'"
  )
  
  # Test with non-numeric variable
  test_data <- data.frame(value = letters[1:10])
  expect_error(
    calculate_summary_stats(test_data, "value"),
    "'var' must be a numeric column"
  )
  
  # Test with invalid group_by
  test_data <- data.frame(value = 1:10, group = letters[1:10])
  expect_error(
    calculate_summary_stats(test_data, "value", group_by = "nonexistent"),
    "is not a column in 'data'"
  )
})

test_that("calculate_summary_stats works with real data", {
  # Test with datateachr::cancer_sample if available
  if (requireNamespace("datateachr", quietly = TRUE)) {
    data(cancer_sample, package = "datateachr", envir = environment())
    
    result <- calculate_summary_stats(cancer_sample, "radius_mean")
    
    expect_s3_class(result, "data.frame")
    expect_true(result$n > 0)
    expect_true(result$mean > 0)
    
    # Test with grouping
    result_grouped <- calculate_summary_stats(
      cancer_sample, 
      "radius_mean", 
      group_by = "diagnosis"
    )
    
    expect_s3_class(result_grouped, "data.frame")
    expect_true(nrow(result_grouped) >= 2)  # At least 2 groups
  }
})

