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

#' Create the Bert Regression Object
#'
#' @param luz_model A model fit using `{luz}`.
#' @param n_tokens The number of tokens to which the predictors should be
#'   tokenized.
#' @param blueprint The `{hardhat}` blueprint to reproduce the data.
#'
#' @return A `{hardhat}` \code{\link[hardhat]{new_model}}.
#' @keywords internal
.new_bert_regression <- function(luz_model,
                                 n_tokens,
                                 blueprint) {
  luz_model <- .serialize_luz_model(luz_model)
  return(
    hardhat::new_model(
      luz_model = luz_model,
      n_tokens = n_tokens,
      blueprint = blueprint,
      class = "bert_regression"
    )
  )
}

#' @export
print.bert_regression <- function(x, ...) {
  .check_luz_model_serialization(x$luz_model)
  NextMethod()
}
