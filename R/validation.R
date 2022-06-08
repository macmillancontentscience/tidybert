.check_predictors_are_character <- function(predictors) {
  # This is based on hardhat::check_predictors_are_numeric. We want to make sure
  # the predictors are all character, which is a case hardhat didn't anticipate.

  # For now I assume the predictors are "data like" (as hardhat puts it);
  # hardhat explicitly checks that first.

  where_character <- purrr::map_lgl(predictors, is.character)
  ok <- all(where_character)
  if (!ok) {
    bad_classes <- hardhat::get_data_classes(predictors[, !where_character])
  }
  else {
    bad_classes <- list()
  }
  return(
    list(
      ok = ok,
      bad_classes = bad_classes
    )
  )
}

.validate_predictors_are_character <- function(predictors) {
  check <- .check_predictors_are_character(predictors)
  if (!check$ok) {
    bad_cols <- glue::single_quote(names(check$bad_classes))
    bad_printable_classes <- purrr::map(
      check$bad_classes,
      ~glue::glue_collapse(glue::single_quote(.x), sep = ", ")
    )
    bad_msg <- glue::glue("{bad_cols}: {bad_printable_classes}")
    bad_msg <- glue::glue_collapse(bad_msg, sep = "\n")
    rlang::abort(
      glue::glue(
        "All predictors must be character, but the following are not:",
        "\n",
        "{bad_msg}",
        .sep = ""
      )
    )
  }
  return(invisible(predictors))
}
