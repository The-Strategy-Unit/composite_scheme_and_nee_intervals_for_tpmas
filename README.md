# Composite scheme and NEE intervals for TPMAs

## Summary

Rendering the Quarto file
`create_custom_intervals.qmd`
will generate a list of tables of data, each with the following columns:

* `type`
* `change_factor`
* `strategy`
* `interval` (a list-col of numeric vectors)

The list of tables will be written to an rds file in the current working
directory.

See the sections below for how to get started and what you will need to do in
preparation.


## Getting started

Clone this repository to a local folder (or use GitHub's "download to zip"
option and then unpack the zip file).


### How to clone the repository

Copy the URL from the "Code" button on the GitHub repo page to your clipboard.
This may look like
`https://github.com/The-Strategy-Unit/composite_scheme_and_nee_intervals_for_tpmas.git`.
You can then paste this in at the next step when your IDE asks for a URL, or you
can pass it to `git clone` at the terminal.


In RStudio you can use

```
File > New Project... Version Control...
```

In Positron or VSCode you can use

```
File > New Folder From Git...
```

Or <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>P</kbd> then `Git: Clone`.


## Generating the intervals data

This is achieved by rendering the Quarto file `create_custom_intervals.qmd`.

Before rendering, set the params at the top of the file as desired:

- `horizon_years`: an integer, the number of years of activity mitigation
  between the baseline and horizon. Multiple values can be handled using a YAML
  array, for example in the format `[10, 15]`
- `create_rds_file`: logical, `true` by default. Set to `false` to prevent
  writing the list of data frames to an `rds` file
- `rds_filename` as a string: the name of the rds file to create
- include_zero_mitigation: logical, `false` by default. Whether to append to the
  data list a table with all intervals set to `c(1, 1)` to the list. (That is,
  data for a scenario with no mitigation applied across all TPMAs).

The qmd file ends by internally generating an R list called `intervals_list`.
This is the list of tables that (by default) gets exported to the rds file.

As an alternative to exporting the rds and reading its data back in, you might
prefer to extend the qmd file and just work with `intervals_list` within the
Quarto process.


## Preparation

You will need to have the following environment variables set, ideally via an
`.Renviron` file:

```
CONNECT_SERVER
CONNECT_API_KEY
PINS_FOLDER
AZ_STORAGE_EP
AZ_SUPPORT_CONTAINER
```

Contact a member of the Data Science team for these values.

Rendering `create_custom_intervals.qmd` requires the following R packages:

* [azkit](https://github.com/The-Strategy-Unit/azkit)
* from the tidyverse:
  * dplyr
  * forcats
  * glue
  * purrr
  * readr
  * rlang
  * tibble
  * tidyr
* base64enc
* distr
* gt
* httr2
* pins
