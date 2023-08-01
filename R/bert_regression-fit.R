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
#' `bert_regression()` fits a regression neural network in the style of
#' [BERT from Google Research](https://github.com/google-research/bert).
#'
#' The generated model is a pretrained BERT model with a final dense linear
#' layer to map the output to a numerical value, constructed using
#' [model_bert_linear()]. That pretrained model is fine-tuned on the provided
#' training data. Input data (during both fitting and prediction) is
#' automatically tokenized to match the tokenization expected by the BERT model.
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
#'   * A __data frame__ with 1 numerical column.
#'   * A __matrix__ with 1 numerical column.
#'   * A numerical __vector__.
#'
#' @param valid_x Depending on the context:
#'
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
#'   predictors should be character vectors. The outcome should be numerical.
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
#' @inheritParams .bert_regression_bridge
#'
#' @param ... Additional parameters to pass to methods or to luz for fitting.
#'
#' @return A `bert_regression` object.
#'
#' @export
bert_regression <- function(x, ...) {
  UseMethod("bert_regression")
}

#' @export
#' @rdname bert_regression
bert_regression.default <- function(x, ...) {
  stop(
    "`bert_regression()` is not defined for a '", class(x)[1], "'.",
    call. = FALSE
  )
}

# XY method - data frame

#' @export
#' @rdname bert_regression
bert_regression.data.frame <- function(x,
                                       y,
                                       valid_x = 0.1,
                                       valid_y = NULL,
                                       bert_type = "bert_tiny_uncased",
                                       n_tokens = torchtransformers::config_bert(
                                         bert_type, "max_tokens"
                                       ),
                                       loss = torch::nn_mse_loss(),
                                       optimizer = torch::optim_adam,
                                       metrics = list(
                                         luz::luz_metric_rmse()
                                       ),
                                       epochs = 10,
                                       batch_size = 128,
                                       luz_opt_hparams = list(),
                                       ...) {
  processed <- hardhat::mold(x, y)
  valid_data <- .mold_valid_xy(valid_x, valid_y, processed$blueprint)
  return(
    .bert_regression_bridge(
      processed,
      valid_data = valid_data,
      bert_type = bert_type,
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
#' @rdname bert_regression
bert_regression.matrix <- function(x,
                                   y,
                                   valid_x = 0.1,
                                   valid_y = NULL,
                                   bert_type = "bert_tiny_uncased",
                                   n_tokens = torchtransformers::config_bert(
                                     bert_type, "max_tokens"
                                   ),
                                   loss = torch::nn_mse_loss(),
                                   optimizer = torch::optim_adam,
                                   metrics = list(
                                     luz::luz_metric_rmse()
                                   ),
                                   epochs = 10,
                                   batch_size = 128,
                                   luz_opt_hparams = list(),
                                   ...) {
  processed <- hardhat::mold(x, y)
  valid_data <- .mold_valid_xy(valid_x, valid_y, processed$blueprint)
  return(
    .bert_regression_bridge(
      processed,
      valid_data = valid_data,
      bert_type = bert_type,
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
#' @rdname bert_regression
bert_regression.formula <- function(formula,
                                    data,
                                    valid_data = 0.1,
                                    bert_type = "bert_tiny_uncased",
                                    n_tokens = torchtransformers::config_bert(
                                      bert_type, "max_tokens"
                                    ),
                                    loss = torch::nn_mse_loss(),
                                    optimizer = torch::optim_adam,
                                    metrics = list(
                                      luz::luz_metric_rmse()
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
    .bert_regression_bridge(
      processed,
      valid_data = valid_data,
      bert_type = bert_type,
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


# ------------------------------------------------------------------------------
# Bridge

#' Bridge between hardhat and Implementation
#'
#' @inheritParams .bert_regression_impl
#' @param processed Processed inputs molded by hardhat.
#'
#' @return A bert_regression model object.
#' @keywords internal
.bert_regression_bridge <- function(processed,
                                    valid_data = 0.1,
                                    bert_type = "bert_tiny_uncased",
                                    n_tokens = torchtransformers::config_bert(
                                      bert_type, "max_tokens"
                                    ),
                                    loss = torch::nn_mse_loss(),
                                    optimizer = torch::optim_adam,
                                    metrics = list(
                                      luz::luz_metric_rmse()
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
  hardhat::validate_outcomes_are_numeric(processed$outcomes)

  predictors <- processed$predictors # tibble
  outcome <- processed$outcomes[[1]] # numeric

  fit <- .bert_regression_impl(
    predictors,
    outcome,
    valid_data = valid_data,
    bert_type = bert_type,
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
    .new_bert_regression(
      luz_model = fit,
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
#' @param outcome A numeric vector associated with the predictors.
#' @param ... Currently unused but included to expand into more luz options.
#' @param valid_data Either a number between 0 and 1, or a blueprint-processed
#'   dataset.
#' @param luz_opt_hparams List; parameters to pass on to
#'   \code{\link[luz]{set_opt_hparams}} to initialize the optimizer.
#' @inheritParams model_bert_linear
#' @inheritParams torchtransformers::dataset_bert_pretrained
#' @inheritParams luz::setup
#' @inheritParams luz::fit.luz_module_generator
#' @inheritParams torch::dataloader
#'
#' @return The fitted model with class `luz_module_fitted`.
#' @keywords internal
.bert_regression_impl <- function(predictors,
                                  outcome,
                                  valid_data = 0.1,
                                  bert_type = "bert_tiny_uncased",
                                  n_tokens = torchtransformers::config_bert(
                                    bert_type, "max_tokens"
                                  ),
                                  loss = torch::nn_mse_loss(),
                                  optimizer = torch::optim_adam,
                                  metrics = list(
                                    luz::luz_metric_rmse()
                                  ),
                                  epochs = 10,
                                  batch_size = 128,
                                  drop_last = TRUE,
                                  luz_opt_hparams = list(),
                                  ...) {
  # Use the processed data to create a torch dataset. We could tokenize here,
  # but instead we let luz_callback_bert_tokenize sort that out below.
  torch_ready <- torchtransformers::dataset_bert_pretrained(
    x = predictors,
    y = outcome
  )

  # Do the same for the validation data if it's a list.
  if (is.list(valid_data)) {
    valid_data <- torchtransformers::dataset_bert_pretrained(
      x = valid_data$predictors,
      y = valid_data$outcomes
    )
  }

  # For regression, the output is a single numeric value.
  n_levels <- 1L

  # Fit using {luz}.
  fitted <- luz::setup(
    model_bert_linear,
    loss = loss,
    optimizer = optimizer,
    metrics = metrics
  )
  fitted <- luz::set_hparams(
    fitted,
    bert_type = bert_type,
    output_dim = n_levels
  )
  fitted <- luz::set_opt_hparams(fitted, !!!luz_opt_hparams)
  fitted <- luz::fit(
    fitted,
    torch_ready,
    epochs = epochs,
    valid_data = valid_data,
    dataloader_options = list(batch_size = batch_size, drop_last = drop_last),
    # TODO: Allow the user to send in more callbacks.
    callbacks = list(
      torchtransformers::luz_callback_bert_tokenize(
        submodel_name = "bert",
        n_tokens = n_tokens,
        verbose = interactive()
      )
    )
  )

  return(fitted)
}
