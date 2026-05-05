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
(This behaviour can be turned off by setting the `create_rds_file` parameter
YAML config option to `false`).

Before rendering the qmd file, set the params at the top of the file as desired:

* `horizon_years` as an integer: the number of years of activity mitigation
  between the baseline and horizon. Multiple values can be handled using a YAML
  array, for example in the format `[10, 15]`
* `create_rds_file`: logical. `true` by default. Set to `false` to avoid
  writing the list of data frames to an `rds` file
* `rds_filename` as a string: the name of the rds file to create
* include_zero_mitigation: logical, `false` by default. Whether to append to the
  data list a table with all intervals set to `c(1, 1)` to the list. (That is,
  data for a scenario with no mitigation applied across all TPMAs).

## Getting started

Clone this repository to a local folder (or use GitHub's "download to zip"
option and then unpack the file).

### How to clone the repository

Copy the URL from the "Code" button on the GitHub repo page to your clipboard.
This may look like
`https://github.com/The-Strategy-Unit/composite_scheme_and_nee_intervals_for_tpmas.git`.
You can then paste this in when your IDE asks for a URL, or you can pass it to
`git clone` at the terminal.


In RStudio you can use

```
File > New Project... Version Control...
```

In Positron or VSCode you can use

```
File > New Folder From Git...
```

Or <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>P</kbd> then `Git: Clone`.

Once cloned or downloaded, you can open the
`create_custom_intervals.qmd`
file, edit the params section as necessary, then render the file.

The file will generate an R list called `intervals_list`.
You may wish to add further chunks to the qmd file to work with the list
within the Quarto process (instead of exporting the rds and working with the
data from there.)


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
