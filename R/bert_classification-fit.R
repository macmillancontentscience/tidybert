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
#' @param valid_x Depending on the context:
#'   * A number between 0 and 1, representing the fraction of data to use for
#'     model validation.
#'   * Predictors in the same format as `x`. These predictors will be used for
#'     model validation.
#'   * `NULL`, in which case no data will be used for model validation.
#'
#' @param valid_y When `valid_x` is a set of predictors, `valid_y` should be
#'   outcomes in the same format as `y`.
#'
#' @param data When a __formula__ is used, `data` is specified as:
#'
#'   * A __data frame__ containing both the predictors and the outcome. The
#'     predictors should be character vectors. The outcome should be a factor.
#'
#' @param formula A formula specifying the outcome term on the left-hand side,
#'   and the predictor terms on the right-hand side.
#'
#' @param valid_data When a __formula__ is used, `valid_data` can be:
#'
#'   * A __data frame__ containing both the predictors and the outcome to be
#'     used for model validation, in the same format as `data`.
#'   * A number between 0 and 1, representing the fraction of data to use for
#'     model validation.
#'   * `NULL`, in which case no data will be used for model validation.
#'
#' @inheritParams .bert_classification_bridge
#'
#' @param ... Additional parameters to pass to methods or to luz for fitting.
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
bert_classification.data.frame <- function(x,
                                           y,
                                           valid_x = 0.1,
                                           valid_y = NULL,
                                           model_name = "bert_tiny_uncased",
                                           n_tokens = torchtransformers::config_bert(
                                             model_name, "max_tokens"
                                           ),
                                           loss = torch::nn_cross_entropy_loss(),
                                           optimizer = torch::optim_adam,
                                           metrics = list(
                                             luz::luz_metric_accuracy()
                                           ),
                                           epochs = 10,
                                           batch_size = 128,
                                           luz_opt_hparams = list(),
                                           ...) {
  processed <- hardhat::mold(x, y)
  valid_data <- .mold_valid_xy(valid_x, valid_y, processed$blueprint)
  return(
    .bert_classification_bridge(
      processed,
      valid_data = valid_data,
      model_name = model_name,
      n_tokens = n_tokens,
      loss = loss,
      optimizer = optimizer,
      metrics = metrics,
      epochs = epochs,
      batch_size = batch_size,
      luz_opt_hparams = luz_opt_hparams,
      ...
    )
  )
}

# XY method - matrix

#' @export
#' @rdname bert_classification
bert_classification.matrix <- function(x,
                                       y,
                                       valid_x = 0.1,
                                       valid_y = NULL,
                                       model_name = "bert_tiny_uncased",
                                       n_tokens = torchtransformers::config_bert(
                                         model_name, "max_tokens"
                                       ),
                                       loss = torch::nn_cross_entropy_loss(),
                                       optimizer = torch::optim_adam,
                                       metrics = list(
                                         luz::luz_metric_accuracy()
                                       ),
                                       epochs = 10,
                                       batch_size = 128,
                                       luz_opt_hparams = list(),
                                       ...) {
  processed <- hardhat::mold(x, y)
  valid_data <- .mold_valid_xy(valid_x, valid_y, processed$blueprint)
  return(
    .bert_classification_bridge(
      processed,
      valid_data = valid_data,
      model_name = model_name,
      n_tokens = n_tokens,
      loss = loss,
      optimizer = optimizer,
      metrics = metrics,
      epochs = epochs,
      batch_size = batch_size,
      luz_opt_hparams = luz_opt_hparams,
      ...
    )
  )
}

# Formula method

#' @export
#' @rdname bert_classification
bert_classification.formula <- function(formula,
                                        data,
                                        valid_data = 0.1,
                                        model_name = "bert_tiny_uncased",
                                        n_tokens = torchtransformers::config_bert(
                                          model_name, "max_tokens"
                                        ),
                                        loss = torch::nn_cross_entropy_loss(),
                                        optimizer = torch::optim_adam,
                                        metrics = list(
                                          luz::luz_metric_accuracy()
                                        ),
                                        epochs = 10,
                                        batch_size = 128,
                                        luz_opt_hparams = list(),
                                        ...) {
  processed <- hardhat::mold(
    formula, data,
    # The predictors should be text, so don't blow them up into a zillion
    # columns!
    blueprint = hardhat::default_formula_blueprint(indicators = "none")
  )
  valid_data <- .mold_valid_formula(
    formula, valid_data, processed$blueprint
  )

  return(
    .bert_classification_bridge(
      processed,
      valid_data = valid_data,
      model_name = model_name,
      n_tokens = n_tokens,
      loss = loss,
      optimizer = optimizer,
      metrics = metrics,
      epochs = epochs,
      batch_size = batch_size,
      luz_opt_hparams = luz_opt_hparams,
      ...
    )
  )
}

#' Mold Validation Data
#'
#' @inheritParams bert_classification
#' @param blueprint The blueprint generated by \code{\link[hardhat]{mold}} for
#'   the training data.
#'
#' @return The processed validation data.
#' @keywords internal
.mold_valid_xy <- function(valid_x, valid_y, blueprint) {
  if (is.numeric(valid_x) && length(valid_x) == 1) {
    return(valid_x)
  } else {
    processed <- hardhat::mold(
      valid_x, valid_y, blueprint = blueprint
    )
    if (ncol(processed$predictors) == 0 || ncol(processed$outcomes) == 0) {
      rlang::abort(
        message = "Please provide both predictors and outcomes for validation.",
        class = "bad_valid_data",
        call = rlang::caller_env()
      )
    }
    return(processed)
  }
}

#' Mold Validation Data
#'
#' @inheritParams bert_classification
#' @param blueprint The blueprint generated by \code{\link[hardhat]{mold}} for
#'   the training data.
#'
#' @return The processed validation data.
#' @keywords internal
.mold_valid_formula <- function(formula, valid_data, blueprint) {
  if (is.numeric(valid_data) && length(valid_data) == 1) {
    return(valid_data)
  } else {
    # Molding with the formula makes sure that the outcomes are there.
    return(
      hardhat::mold(
        formula, valid_data, blueprint = blueprint
      )
    )
  }
}



# ------------------------------------------------------------------------------
# Bridge

#' Bridge between hardhat and Implementation
#'
#' @inheritParams .bert_classification_impl
#' @param processed Processed inputs molded by hardhat.
#'
#' @return A bert_classification model object.
#' @keywords internal
.bert_classification_bridge <- function(processed,
                                        valid_data = 0.1,
                                        model_name = "bert_tiny_uncased",
                                        n_tokens = torchtransformers::config_bert(
                                          model_name, "max_tokens"
                                        ),
                                        loss = torch::nn_cross_entropy_loss(),
                                        optimizer = torch::optim_adam,
                                        metrics = list(
                                          luz::luz_metric_accuracy()
                                        ),
                                        epochs = 10,
                                        batch_size = 128,
                                        luz_opt_hparams = list(),
                                        ...) {
  #### Validate processed data.

  # Validate predictors. Right now we only support up to two character columns.
  .validate_predictors_are_character(processed$predictors)
  .validate_predictor_count(processed$predictors, max_predictors = 2)

  # Validate outcome.
  hardhat::validate_outcomes_are_univariate(processed$outcomes)
  hardhat::validate_outcomes_are_factors(processed$outcomes)

  predictors <- processed$predictors # tibble
  outcome <- processed$outcomes[[1]] # factor

  fit <- .bert_classification_impl(
    predictors,
    outcome,
    valid_data = valid_data,
    model_name = model_name,
    n_tokens = n_tokens,
    loss = loss,
    optimizer = optimizer,
    metrics = metrics,
    epochs = epochs,
    batch_size = batch_size,
    luz_opt_hparams = luz_opt_hparams,
    ...
  )

  return(
    .new_bert_classification(
      luz_model = fit,
      outcome_levels = levels(outcome),
      n_tokens = n_tokens,
      blueprint = processed$blueprint
    )
  )
}


# ------------------------------------------------------------------------------
# Implementation

#' Create and Fit the Model
#'
#' @param predictors A tibble containing one or two character columns.
#' @param outcome A factor of output classes associated with the predictors.
#' @param ... Currently unused but included to expand into more luz options.
#' @param valid_data Either a number between 0 and 1, or a blueprint-processed
#'   dataset.
#' @param luz_opt_hparams List; parameters to pass on to
#'   \code{\link[luz]{set_opt_hparams}} to initialize the optimizer.
#' @inheritParams model_bert_linear
#' @inheritParams torchtransformers::dataset_bert
#' @inheritParams luz::setup
#' @inheritParams luz::fit.luz_module_generator
#' @inheritParams torch::dataloader
#'
#' @return The fitted model with class `luz_module_fitted`.
#' @keywords internal
.bert_classification_impl <- function(predictors,
                                      outcome,
                                      valid_data = 0.1,
                                      model_name = "bert_tiny_uncased",
                                      n_tokens = torchtransformers::config_bert(
                                        model_name, "max_tokens"
                                      ),
                                      loss = torch::nn_cross_entropy_loss(),
                                      optimizer = torch::optim_adam,
                                      metrics = list(
                                        luz::luz_metric_accuracy()
                                      ),
                                      epochs = 10,
                                      batch_size = 128,
                                      luz_opt_hparams = list(),
                                      ...) {
  # Make sure n_tokens is valid for this model.
  n_tokens <- min(
    n_tokens,
    torchtransformers::config_bert(
      model_name, "max_tokens"
    )
  )

  # Use the processed data to create a torch dataset.
  torch_ready <- torchtransformers::dataset_bert(
    x = predictors,
    y = outcome,
    n_tokens = n_tokens
  )

  # Do the same for the validation data if it's a list.
  if (is.list(valid_data)) {
    valid_data <- torchtransformers::dataset_bert(
      x = valid_data$predictors,
      y = valid_data$outcomes,
      n_tokens = n_tokens
    )
  }

  # The number of levels defines the number of output dimensions in the model.
  n_levels <- length(levels(outcome))

  # Fit using {luz}.
  fitted <- luz::setup(
    model_bert_linear,
    loss = loss,
    optimizer = optimizer,
    metrics = metrics
  )
  fitted <- luz::set_hparams(
    fitted,
    model_name = model_name,
    output_dim = n_levels
  )
  fitted <- luz::set_opt_hparams(fitted, !!!luz_opt_hparams)
  fitted <- luz::fit(
    fitted,
    torch_ready,
    epochs = epochs,
    valid_data = valid_data,
    dataloader_options = list(batch_size = batch_size)
  )

  return(fitted)
}
