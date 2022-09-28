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

#' Predict from a `bert_regression` model.
#'
#' @param object A `bert_regression` object.
#'
#' @param new_data A data frame or matrix of new character predictors. This data
#'   is automatically tokenized to match the tokenization expected by the BERT
#'   model.
#'
#' @param ... Not used, but required for extensibility.
#'
#' @return
#'
#' A tibble of predictions. The number of rows in the tibble is guaranteed to be
#' the same as the number of rows in `new_data`.
#'
#' @export
predict.bert_regression <- function(object,
                                    new_data,
                                    ...) {
  forged <- hardhat::forge(new_data, object$blueprint)
  return(.predict_bert_regression_bridge(object, forged$predictors))
}

# ------------------------------------------------------------------------------
# Bridge

#' Prepare BERT Regression Data for Prediction
#'
#' @inheritParams predict.bert_regression
#' @param predictors Forged predictor data.
#'
#' @return A tibble with output dependent on the type.
#' @keywords internal
.predict_bert_regression_bridge <- function(object, predictors) {
  # Prepare the input.
  predictors_ds <- torchtransformers::dataset_bert_pretrained(
    x = predictors,
    y = NULL,
    n_tokens = object$n_tokens
  )

  # Make sure the model is properly loaded.
  .check_luz_model_serialization(object$luz_model)

  # Actually do the prediction.
  predictions <- .predict_bert_regression(object, predictors_ds)

  hardhat::validate_prediction_size(predictions, predictors)

  return(predictions)
}


# ------------------------------------------------------------------------------
# Implementation

#' Get Predictions for BERT Regression
#'
#' @inheritParams .predict_bert_regression_bridge
#'
#' @return A tibble of numeric predictions
#' @keywords internal
.predict_bert_regression <- function(object, predictors) {
  predictions <- predict(
    object$luz_model,
    predictors,
    # TODO: Allow additional luz:::predict.luz_module_fitted arguments.
    callbacks = list(
      torchtransformers::luz_callback_bert_tokenize(
        submodel_name = "bert",
        verbose = interactive()
      )
    )
  )

  predictions <- torch::as_array(predictions$to(device = "cpu"))

  predictions <- hardhat::spruce_numeric(predictions)

  return(predictions)
}
