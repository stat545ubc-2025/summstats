
<!-- README.md is generated from README.Rmd. Please edit that file -->

# summstats

<!-- badges: start -->

<!-- badges: end -->

The goal of summstats is to provide useful functions for calculating
summary statistics and performing data analysis tasks.

## Installation

You can install the development version of summstats from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("zaralipour/summstats", ref = "0.1.0")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(summstats)
library(datateachr)

# Load example data
data(cancer_sample)

# Calculate summary statistics for radius_mean
calculate_summary_stats(cancer_sample, "radius_mean")
#> # A tibble: 1 × 6
#>    mean median    sd   min   max     n
#>   <dbl>  <dbl> <dbl> <dbl> <dbl> <int>
#> 1  14.1   13.4  3.52  6.98  28.1   569
```

``` r
# Calculate summary statistics grouped by diagnosis
calculate_summary_stats(cancer_sample, "radius_mean", group_by = "diagnosis")
#> # A tibble: 2 × 7
#>   diagnosis  mean median    sd   min   max     n
#>   <chr>     <dbl>  <dbl> <dbl> <dbl> <dbl> <int>
#> 1 B          12.1   12.2  1.78  6.98  17.8   357
#> 2 M          17.5   17.3  3.20 11.0   28.1   212
```

## Functions

- `calculate_summary_stats()`: Calculate summary statistics (mean,
  median, sd, min, max, n) for numeric variables, optionally grouped by
  a categorical variable.
