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

#' Predict from a `bert_classification`
#'
#' @param object A `bert_classification` object.
#'
#' @param new_data A data frame or matrix of new predictors.
#'
#' @param type A single character. The type of predictions to generate.
#' Valid options are:
#'
#' - `"class"` for "hard" class predictions.
#' - `"prob"` for class probabilities.
#'
#' @param ... Not used, but required for extensibility.
#'
#' @return
#'
#' A tibble of predictions. The number of rows in the tibble is guaranteed
#' to be the same as the number of rows in `new_data`.
#'
#' @export
predict.bert_classification <- function(object,
                                        new_data,
                                        type = c("class", "prob"),
                                        ...) {
  forged <- hardhat::forge(new_data, object$blueprint)
  type <- match.arg(type)
  return(.predict_bert_classification_bridge(type, object, forged$predictors))
}

# ------------------------------------------------------------------------------
# Bridge

#' Prepare BERT Classification Data for Prediction
#'
#' @inheritParams predict.bert_classification
#' @param predictors Forged predictor data.
#'
#' @return A tibble with output dependent on the type.
#' @keywords internal
.predict_bert_classification_bridge <- function(type, object, predictors) {
  # Prepare the input.
  predictors_ds <- torchtransformers::dataset_bert(
    x = predictors,
    y = NULL,
    n_tokens = object$n_tokens
  )

  # Make sure the model is properly loaded.
  .check_luz_model_serialization(object$luz_model)

  predict_function <- .get_bert_classification_predict_function(type)

  # Actually do the prediction.
  predictions <- predict_function(object, predictors_ds)

  hardhat::validate_prediction_size(predictions, predictors)

  return(predictions)
}

#' Choose the Proper Prediction Function for BERT Classification
#'
#' @inheritParams predict.bert_classification
#'
#' @return The predict function.
#' @keywords internal
.get_bert_classification_predict_function <- function(type) {
  return(
    switch(
      type,
      class = .predict_bert_classification_class,
      prob = .predict_bert_classification_prob
    )
  )
}

# ------------------------------------------------------------------------------
# Implementation

#' Shared Prediction for BERT Classification
#'
#' @inheritParams .predict_bert_classification_bridge
#'
#' @return A torch tensor of softmax probabilities.
#' @keywords internal
.predict_bert_classification_shared <- function(object, predictors) {
  # Get the prediction output and apply softmax.
  return(
    torch::nnf_softmax(
      input = predict(object$luz_model, predictors),
      dim = 2
    )
  )
}

#' Get Class for BERT Classification
#'
#' @inheritParams .predict_bert_classification_bridge
#'
#' @return A tibble with a factor column identifying the most probable outcome.
#' @keywords internal
.predict_bert_classification_class <- function(object, predictors) {
  predictions <- torch::torch_argmax(
    .predict_bert_classification_shared(object, predictors),
    2
  )

  predictions <- torch::as_array(predictions$to(device = "cpu"))

  predictions <- factor(
    predictions,
    levels = seq_along(object$outcome_levels),
    labels = object$outcome_levels
  )

  return(hardhat::spruce_class(predictions))
}

#' Get Probabilities for BERT Classification
#'
#' @inheritParams .predict_bert_classification_bridge
#'
#' @return A tibble of probabilities.
#' @keywords internal
.predict_bert_classification_prob <- function(object, predictors) {
  predictions <- .predict_bert_classification_shared(object, predictors)

  predictions <- torch::as_array(predictions$to(device = "cpu"))

  predictions <- hardhat::spruce_prob(
    pred_levels = object$outcome_levels,
    prob_matrix = predictions
  )

  return(predictions)
}
