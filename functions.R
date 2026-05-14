get_tpma_data <- function() {
  resp <- httr2::request("https://api.github.com") |>
    httr2::req_url_path_append("repos") |>
    httr2::req_url_path_append("The-Strategy-Unit") |>
    httr2::req_url_path_append("TPMAs") |>
    httr2::req_url_path_append("contents") |>
    httr2::req_url_path_append("reference") |>
    httr2::req_url_path_append("mitigator-lookup.csv") |>
    httr2::req_perform() |>
    httr2::resp_check_status()

  httr2::resp_body_json(resp) |>
    purrr::pluck("content") |>
    base64enc::base64decode() |>
    readr::read_csv(col_types = "ccc-----c") |>
    # only keep currently active TPMAs
    dplyr::filter(dplyr::if_any("active_to", is.na)) |>
    dplyr::select(
      type = "activity_type",
      change_factor = "mitigator_type",
      strategy = "mitigator_variable"
    )
}


get_nee_intervals <- function(support_cont_name) {
  az_token <- azkit::get_auth_token()
  support_container <- azkit::get_container(support_cont_name, token = az_token)

  support_container |>
    azkit::read_azure_rds("nee_table.rds", type = "none") |>
    dplyr::rename_with(stringr::str_to_snake) |>
    dplyr::select(
      type = "strategy_type",
      change_factor = "type",
      strategy = "param_name",
      p10 = "lower_ci",
      p90 = "upper_ci"
    ) |>
    dplyr::mutate(
      dplyr::across("type", \(x) {
        dplyr::case_when(
          grepl("^inpatient", x) ~ "ip",
          grepl("^length of stay", x) ~ "ip",
          grepl("^outpatient", x) ~ "op",
          grepl("^A&E", x) ~ "aae",
          .default = x
        )
      }),
      dplyr::across(c("p10", "p90"), \(x) x / 100)
    )
}


reinflate_intervals <- function(exp, tbl) {
  dplyr::mutate(tbl, dplyr::across(c("p10", "p90"), \(x) x^exp))
}


annualise <- \(x, p) `^`(x, (1 / p))


create_intervals_tbl <- function(lst) {
  lst |>
    purrr::map_depth(2, \(x) list(x[["interval"]])) |>
    purrr::imap(\(x, y) dplyr::bind_cols(type = y, tibble::as_tibble_row(x))) |>
    purrr::list_rbind() |>
    tidyr::pivot_longer(
      !"type",
      names_to = "strategy",
      values_drop_na = TRUE
    ) |>
    tidyr::unnest_wider("value", names_sep = "_") |>
    dplyr::rename(p10 = "value_1", p90 = "value_2")
}


create_mixtures <- function(intervals_tbl, colnames_vec) {
  intervals_tbl |>
    dplyr::mutate(
      mu = (.data[["p10"]] + .data[["p90"]]) / 2,
      sigma = (.data[["p90"]] - .data[["mu"]]) /
        qnorm(p = 0.90, mean = 0, sd = 1),
      dplyr::across("sigma", \(x) dplyr::if_else(x == 0, 0.0001, x)),
      dist = purrr::map2(.data[["mu"]], .data[["sigma"]], \(m, s) {
        distr::Truncate(distr::Norm(mean = m, sd = s), lower = 0, upper = 1)
      })
    ) |>
    dplyr::summarise(
      mixture = purrr::map(list(.data[["dist"]]), \(l) {
        distr::UnivarMixingDistribution(Dlist = l)
      }),
      .by = tidyselect::all_of(colnames_vec)
    )
}
