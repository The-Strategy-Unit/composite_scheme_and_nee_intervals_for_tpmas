# Composite scheme and NEE intervals for TPMAs

The Quarto file
`create_custom_intervals.qmd`
will generate a list of tables of data, each with the following columns:

* `type`
* `change_factor`
* `strategy`
* `interval` (list-col of numeric vectors)

The list of tables will be written to an rds file in the current working directory.

Before rendering the qmd file, set the params at the top of the file as follows:

* `inflation_years` as an integer: the number of years of activity mitigation
  between the baseline and horizon. Multiple values can be handled using a YAML
  array, for example in the format `[10, 15]`
* `rds_filename` as a string: the name of the rds file to be created.

## Preparation

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

`create_custom_intervals.qmd` depends on the following R packages:

* [azkit](https://github.com/The-Strategy-Unit/azkit)
* dplyr
* forcats
* glue
* purrr
* readr
* tidyr
* distr
* pins
* rlang
