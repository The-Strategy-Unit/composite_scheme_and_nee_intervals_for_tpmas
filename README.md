# Composite scheme and NEE intervals for TPMAs

Rendering the Quarto file
`create_custom_intervals.qmd`
will generate a list of tables of data, each with the following columns:

* `type`
* `change_factor`
* `strategy`
* `interval` (a list-col of numeric vectors)

The list of tables will be written to an rds file in the current working
directory.

Before rendering the qmd file, set the params at the top of the file as follows:

* `inflation_years` as an integer: the number of years of activity mitigation
  between the baseline and horizon. Multiple values can be handled using a YAML
  array, for example in the format `[10, 15]`
* `rds_filename` as a string: the name of the rds file to be created.

### Preparation

You will need to have the following environment variables set, ideally via your
local `.Renviron` file:

```
CONNECT_SERVER
CONNECT_API_KEY
PINS_FOLDER
AZ_STORAGE_EP
AZ_SUPPORT_CONTAINER
```

Contact Fran Barton for details of these values.

Rendering `create_custom_intervals.qmd` requires the following R packages:

* [azkit](https://github.com/The-Strategy-Unit/azkit)
* dplyr
* forcats
* glue
* purrr
* readr
* tibble
* tidyr
* distr
* pins
* rlang


## Creating a table for a "zero mitigation" scenario

Separately from the above, you may need to create a table where all the
intervals are set to 1.
This is equivalent to a "no mitigation", or "steady state", scenario.

For this, render the
`create_zero_mitigation_table.qmd`
file.
You may wish to edit the filename parameter at the top of the file first.

This will create an `rds` file in your current directory.

The data in the file will be in the form of an R list with a single element,
named "zero_mitigation", which contains a data frame.

### Preparation

You will need to have the following environment variables set, ideally via your
local `.Renviron` file:

```
AZ_STORAGE_EP
AZ_SUPPORT_CONTAINER
```

Rendering `create_zero_mitigation_table.qmd` requires the following R packages:

* [azkit](https://github.com/The-Strategy-Unit/azkit)
* dplyr
* forcats
* glue
* purrr
* readr
* tibble
