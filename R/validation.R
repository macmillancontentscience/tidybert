# Copyright 2022 Bedford Freeman & Worth Pub Grp LLC DBA Macmillan Learning.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#' Identify Non-Character Predictors
#'
#' @param predictors "Data-like" predictors, in this case always a tibble of
#'   predictors (but also works for dfs).
#'
#' @return A list with elements `ok` (whether the check passes) and
#'   `bad_classes` (a named list of any bad classes, where the name is the name
#'   of the column, and the value is the class).
#' @keywords internal
.check_predictors_are_character <- function(predictors) {
  # This is based on hardhat::check_predictors_are_numeric. We want to make sure
  # the predictors are all character, which is a case hardhat didn't anticipate.

  # For now I assume the predictors are "data like" (as hardhat puts it);
  # hardhat explicitly checks that first.

  where_character <- purrr::map_lgl(predictors, is.character)
  ok <- all(where_character)
  if (!ok) {
    bad_classes <- hardhat::get_data_classes(
      # Specify not to drop the extra dimension so it works for plain dfs.
      predictors[, !where_character, drop = FALSE]
    )
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

#' Confirm that Predictors are Character
#'
#' @inheritParams .check_predictors_are_character
#'
#' @return `predictors` (invisibly), or an error identifying bad columns.
#' @keywords internal
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
      ),
      class = "bad_predictor_classes",
      call = rlang::caller_env()
    )
  }
  return(invisible(predictors))
}

#' Confirm the Number of Predictors
#'
#' @inheritParams .check_predictors_are_character
#' @param max_predictors The maximum expected number of predictors.
#'
#' @return `predictors` (invisibly), or an error if there are too many columns.
#' @keywords internal
.validate_predictor_count <- function(predictors, max_predictors = 2) {
  if (ncol(predictors) > max_predictors) {
    all_cols <- glue::glue_collapse(
      glue::single_quote(names(predictors)),
      sep = ", "
    )
    rlang::abort(
      glue::glue(
        "We currently support 1 or 2 predictor columns.",
        "These columns were identified as predictors:",
        all_cols,
        .sep = "\n"
      ),
      class = "too_many_predictors",
      call = rlang::caller_env()
    )
  }
  return(invisible(predictors))
}
