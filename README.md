
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tRc HelpR

<!-- badges: start -->

<!-- badges: end -->

The goal of tRc HelpR is to provide commonly used helper functions for
data cleaning and analysis.

## Contents

- [Installation](#installation)
- [Date to FY Quarter](#date-to-fy-quarter)
- [Tamaki SA2 Filter](#tamaki-sa2-filter)
- [Save and Load Timestamped Files](#save-and-load-timestamped-files)
  - [Saving Files](#saving-files)
  - [Loading Files](#loading-files)
- [Rehousing Matrix](#rehousing-matrix)
  - [Other Things to Note](#other-things-to-note)
- [Hex Codes](#hex-codes)

## Installation

You can install the development version of tRc from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("TamakiRegen/trc")
```

## Date to FY Quarter

Takes a date object and returns either the financial year, year and
quarter, or quarter that the date falls in.

``` r
library(trc)

date <- "2026-05-30"

trc::d2fyq(date, type = "year")
#> [1] "2026"
trc::d2fyq(date, type = "year_quarter")
#> [1] "2026 Q4"
trc::d2fyq(date, type = "quarter")
#> [1] "Q4"
```

## Tamaki SA2 Filter

Filter a vector of StatsNZ Census 2023 SA2 codes to only include those
that cover the Tamaki Regeneration area.

Note that the `col` parameter must be parsed into the function as a
string.

``` r
library(trc)

# Create the Tāmaki and New Zealand SA2 dataset
codes <- data.frame(
  SA22026_code = c(
    147001, 144700, 191201, 146700, 338200, 221500, 243200, 145800, 
    400013, 146301, 214500, 362100, 115100, 145400, 147100, 147002, 
    132501, 243800, 146302
  ),
  SA22026_name = c(
    "Tamaki West", "Glen Innes West", "Te Puna", "Panmure West", 
    "Tinwald South", "Ohangai", "Maungaraki", "Glen Innes East-Wai O Taiki Bay", 
    "Snares Islands", "Point England North", "Nelson Park", "Georgetown", 
    "Stanmore Bay East", "Panmure Glen Innes Industrial", "Panmure East", 
    "Tamaki East", "Konini Road", "Tirohanga", "Point England South"
  )
)

print(codes)
#>    SA22026_code                    SA22026_name
#> 1        147001                     Tamaki West
#> 2        144700                 Glen Innes West
#> 3        191201                         Te Puna
#> 4        146700                    Panmure West
#> 5        338200                   Tinwald South
#> 6        221500                         Ohangai
#> 7        243200                      Maungaraki
#> 8        145800 Glen Innes East-Wai O Taiki Bay
#> 9        400013                  Snares Islands
#> 10       146301             Point England North
#> 11       214500                     Nelson Park
#> 12       362100                      Georgetown
#> 13       115100               Stanmore Bay East
#> 14       145400   Panmure Glen Innes Industrial
#> 15       147100                    Panmure East
#> 16       147002                     Tamaki East
#> 17       132501                     Konini Road
#> 18       243800                       Tirohanga
#> 19       146302             Point England South

filtered_sa2 <- trc::sa2(codes, "SA22026_code")

print(filtered_sa2)
#>   SA22026_code                    SA22026_name
#> 1       147001                     Tamaki West
#> 2       144700                 Glen Innes West
#> 3       146700                    Panmure West
#> 4       145800 Glen Innes East-Wai O Taiki Bay
#> 5       146301             Point England North
#> 6       145400   Panmure Glen Innes Industrial
#> 7       147100                    Panmure East
#> 8       147002                     Tamaki East
#> 9       146302             Point England South
```

## Save and Load Timestamped Files

Create version controlled, timestamped files when exporting data from R
(then load them again without writing out timestamps each time).

These function relies on the `rio()` package, which supports multiple
formats [listed
here](https://cran.r-project.org/web/packages/rio/vignettes/rio.html).
However, the package won’t support the `rio()` functionality of
exporting two R objects as separate sheets in the same workbook (for
that you’ll need a more manual workaround).

### Saving files

Example of `save_timestamped_file()`:

    trc::save_timestamped_file(df, "clean_data", sub_dir = "outputs", "xlsx")

    outputs/20260530_172534_clean_data.xlsx

Note that the `sub_dir` parameter defaults to `NULL`, and will therefore
save the file into the working directory if not defined.

### Loading files

While great for version control, timestamped files like the example
above are a bitch to load. Most of the time you just want to have the
most recent file loaded into a script. The
`load_timestamped_file()`function will take the target filename and
extension and search the target directory for the latest timestamp (of
the format `YYYYMMDD_HHMMSS`) before loading it.

## Rehousing Matrix

This function takes the [Rehousing
Matrix](https://github.com/TamakiRegen/rh_matrix) and applies it to a
value.

- Rows with \>=6 bedrooms are not treated by the matrix and will return
  the same number of bedrooms as the input number. This is due to a
  limit of both rehousing data to calculate distributions, and the low
  number of these large properties in our portfolio.
- Rows with zero bedrooms return zero as there is no rehousing demand.
  This is likely to be either an untenantable house (e.g. fire damage)
  or a SPM land entry has crept into the data you’re trying to mutate.
  In either case, zero bedroom values should be investigated.
- Be sure to filter !is.na(current) in your dataframe before applying
  the matrix.

``` r
library(trc)

rehousing_data <- data.frame(
 address = c('1 Big John Street', '2 Big John Street', '3 Big John Street', '4 Big John Street',
 '5 Big John Street', '6 Big John Street', '1 Extra Medium John Place', '3 Extra Medium John Place'),
 current_bedrooms = c(2,3,3,4,1,7,0,5)
)

rehousing_data <- rehousing_data %>% 
 mutate(required_bedrooms = trc::rh_matrix(current_bedrooms))

print(rehousing_data)
#>                     address current_bedrooms required_bedrooms
#> 1         1 Big John Street                2                 2
#> 2         2 Big John Street                3                 3
#> 3         3 Big John Street                3                 3
#> 4         4 Big John Street                4                 4
#> 5         5 Big John Street                1                 1
#> 6         6 Big John Street                7                 7
#> 7 1 Extra Medium John Place                0                 0
#> 8 3 Extra Medium John Place                5                 3
```

### Other things to note

- The results will be different each time you run it as the function
  takes a sample based on the observed distribution of bedroom typology
  shifts.
- The code doesn’t know the exact circumstances of the whanau in each
  home, and therefore provides an **indicative best guess** at what
  bedroom typologies will be required.
- Because of this, the **outputs are for planning purposes only, and
  need to be validated with THA before being operationalised.**

\## Hex Codes This offers a quick way of printing TRC brand colour hex
codes in the console. These can then be copied into `ase()`arguments for
visualisations.

The library defaults to TRC’s standard colours, but the parameter
“light” can be entered to get a lighter shade of each of the five brand
colours.

``` r
library(trc)

trc::hex()
#> [1] "#2A7DE2" "#15D3C5" "#F1636E" "#60269E" "#FF7F30"

trc::hex("light")
#> [1] "#7fb1ee" "#73e5dc" "#f7a1a8" "#a07dc5" "#ffb283"
```
