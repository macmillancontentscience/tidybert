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

#' Fit a BERT-style neural network
#'
#' `bert_classification()` fits a classifier neural network in the style of
#' [BERT from Google Research](https://github.com/google-research/bert).
#'
#' @param x Depending on the context:
#'
#'   * A __data frame__ of character predictors.
#'   * A __matrix__ of character predictors.
#'   * Note that a __recipe__ created from [recipes::recipe()] will NOT
#'     currently work.
#'
#' @param y When `x` is a __data frame__ or __matrix__, `y` is the outcome
#'   specified as:
#'
#'   * A __data frame__ with 1 factor column.
#'   * A __matrix__ with 1 factor column.
#'   * A factor __vector__.
#'
#' @param data When a __formula__ is used, `data` is specified as:
#'
#'   * A __data frame__ containing both the predictors and the outcome. The
#'     predictors should be character vectors. The outcome should be a factor,
#'     or a character vector.
#'
#' @param formula A formula specifying the outcome term on the left-hand side,
#'   and the predictor terms on the right-hand side.
#'
#' @param ... Not currently used, but required for extensibility.
#'
#' @return A `bert_classification` object.
#'
#' @export
bert_classification <- function(x, ...) {
  UseMethod("bert_classification")
}

#' @export
#' @rdname bert_classification
bert_classification.default <- function(x, ...) {
  stop(
    "`bert_classification()` is not defined for a '", class(x)[1], "'.",
    call. = FALSE
  )
}

# XY method - data frame

#' @export
#' @rdname bert_classification
bert_classification.data.frame <- function(x, y, ...) {
  processed <- hardhat::mold(x, y)
  return(.bert_classification_bridge(processed, ...))
}

# XY method - matrix

#' @export
#' @rdname bert_classification
bert_classification.matrix <- function(x, y, ...) {
  processed <- hardhat::mold(x, y)
  return(.bert_classification_bridge(processed, ...))
}

# Formula method

#' @export
#' @rdname bert_classification
bert_classification.formula <- function(formula, data, ...) {
  processed <- hardhat::mold(
    formula, data,
    # The predictors should be text, so don't blow them up into a zillion
    # columns!
    blueprint = hardhat::default_formula_blueprint(indicators = "none")
  )
  return(.bert_classification_bridge(processed, ...))
}

# Recipe method

#' @export
#' @rdname bert_classification
bert_classification.recipe <- function(x, data, ...) {
  # Recipe predictors are always converted to factors during prep/bake. We need
  # them to still be character so we can make sure they're tokenized properly
  # for the specified model, so this can't work yet.

  stop(
    "`bert_classification()` is not defined for a 'recipe'.",
    call. = FALSE
  )
}

# ------------------------------------------------------------------------------
# Bridge

.bert_classification_bridge <- function(processed, ...) {
  #### Validate processed data.

  # Validate predictors. It should be one or more character vectors (really up
  # to two but for now we won't enforce that).
  .validate_predictors_are_character(processed$predictors)

  # Validate outcome.
  hardhat::validate_outcomes_are_univariate(processed$outcomes)
  hardhat::validate_outcomes_are_factors(processed$outcomes)

  predictors <- processed$predictors # tibble
  outcome <- processed$outcomes[[1]] # factor-vector

  fit <- .bert_classification_impl(predictors, outcome)

  return(
    .new_bert_classification(
      luz_model = fit,
      outcome_levels = levels(outcome),
      blueprint = processed$blueprint
    )
  )
}


# ------------------------------------------------------------------------------
# Implementation

.bert_classification_impl <- function(predictors, outcome) {
  ### Use the processed data to create a torch dataset.
  torch_ready <- torchtransformers::dataset_bert(
    x = predictors,
    y = outcome
  )

  # The number of levels defines the number of heads in the model.
  n_levels <- length(levels(outcome))
  bert_classifier <- model_bert_linear(
    model_name = "bert_tiny_uncased",
    output_dim = n_levels
  )

  # Fit using {luz}.
  fitted <- bert_classifier %>%
    luz::setup(
      loss = torch::nn_cross_entropy_loss(),
      optimizer = torch::optim_adam,
      metrics = list(
        luz::luz_metric_accuracy()
      )
    ) %>%
    luz::fit(
      torch_ready,
      epochs = 1,
      valid_data = 0.1,
      dataloader_options = list(batch_size = 128L)
    )

  return(fitted)
}


# ------------------------------------------------------------------------------
# Constructor

.new_bert_classification <- function(luz_model, outcome_levels, blueprint) {
  return(
    hardhat::new_model(
      luz_model = luz_model,
      outcome_levels = outcome_levels,
      blueprint = blueprint,
      class = "bert_classification"
    )
  )
}
