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
#' - `"prob"` for class probabilities. (NOT IMPLEMENTED AT ALL YET)
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
                                        type = "class",
                                        ...) {
  forged <- hardhat::forge(new_data, object$blueprint)
  rlang::arg_match(type, valid_bert_classification_predict_types())
  predict_bert_classification_bridge(type, object, forged$predictors)
}

valid_bert_classification_predict_types <- function() {
  c("class")
}

# ------------------------------------------------------------------------------
# Bridge

predict_bert_classification_bridge <- function(type, model, predictors) {
  predictors <- as.matrix(predictors)

  predict_function <- get_bert_classification_predict_function(type)
  predictions <- predict_function(model, predictors)

  hardhat::validate_prediction_size(predictions, predictors)

  predictions
}

get_bert_classification_predict_function <- function(type) {
  switch(
    type,
    class = predict_bert_classification_class
  )
}

# ------------------------------------------------------------------------------
# Implementation

predict_bert_classification_class <- function(model, predictors) {
  predictions <- rep(1L, times = nrow(predictors))
  hardhat::spruce_class(predictions)
}
