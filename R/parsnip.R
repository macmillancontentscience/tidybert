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

#' Set Up tidybert for Parsnip
#'
#' @keywords internal
.make_bert <- function() {
  current <- parsnip::get_model_env()

  # Register the model if it isn't already.
  if (!("bert" %in% current$models)) {
    parsnip::set_new_model("bert")

    parsnip::set_model_arg(
      model = "bert",
      eng = "tidybert",
      parsnip = "epochs",
      original = "epochs",
      func = list(pkg = "dials", fun = "epochs"),
      has_submodel = TRUE
    )

    parsnip::set_model_arg(
      model = "bert",
      eng = "tidybert",
      parsnip = "batch_size",
      original = "batch_size",
      func = list(pkg = "dials", fun = "batch_size"),
      has_submodel = FALSE
    )

    parsnip::set_model_arg(
      model = "bert",
      eng = "tidybert",
      parsnip = "bert_type",
      original = "bert_type",
      func = list(pkg = "tidybert", fun = "bert_type"),
      has_submodel = FALSE
    )

    parsnip::set_model_arg(
      model = "bert",
      eng = "tidybert",
      parsnip = "n_tokens",
      original = "n_tokens",
      func = list(pkg = "tidybert", fun = "n_tokens"),
      has_submodel = FALSE
    )
  }

  # Register classification mode if it isn't already.
  if (!("classification" %in% current$bert_modes)) {
    parsnip::set_model_mode(model = "bert", mode = "classification")

    parsnip::set_model_engine(
      model = "bert",
      mode = "classification",
      eng = "tidybert"
    )

    parsnip::set_fit(
      model = "bert",
      mode = "classification",
      eng = "tidybert",
      value = list(
        interface = "formula",
        protect = c("formula", "data"),
        func = c(fun = "bert_classification"),
        defaults = list()
      )
    )

    parsnip::set_encoding(
      model = "bert",
      mode = "classification",
      eng = "tidybert",
      options = list(
        predictor_indicators = "none",
        compute_intercept = FALSE,
        remove_intercept = FALSE,
        allow_sparse_x = TRUE
      )
    )

    parsnip::set_pred(
      model = "bert",
      mode = "classification",
      eng = "tidybert",
      type = "class",
      value = list(
        pre = NULL,
        post = NULL,
        func = c(fun = "predict"),
        args = list(
          object = quote(object$fit),
          new_data = quote(new_data),
          type = "class"
        )
      )
    )

    parsnip::set_pred(
      model = "bert",
      mode = "classification",
      eng = "tidybert",
      type = "prob",
      value = list(
        pre = NULL,
        post = NULL,
        func = c(fun = "predict"),
        args = list(
          object = quote(object$fit),
          new_data = quote(new_data),
          type = "prob"
        )
      )
    )
  }

  # Register regression mode if it isn't already.
  if (!("regression" %in% current$bert_modes)) {
    parsnip::set_model_mode(model = "bert", mode = "regression")

    parsnip::set_model_engine(
      model = "bert",
      mode = "regression",
      eng = "tidybert"
    )

    parsnip::set_fit(
      model = "bert",
      mode = "regression",
      eng = "tidybert",
      value = list(
        interface = "formula",
        protect = c("formula", "data"),
        func = c(fun = "bert_regression"),
        defaults = list()
      )
    )

    parsnip::set_encoding(
      model = "bert",
      mode = "regression",
      eng = "tidybert",
      options = list(
        predictor_indicators = "none",
        compute_intercept = FALSE,
        remove_intercept = FALSE,
        allow_sparse_x = TRUE
      )
    )

    parsnip::set_pred(
      model = "bert",
      mode = "regression",
      eng = "tidybert",
      type = "numeric",
      value = list(
        pre = NULL,
        post = NULL,
        func = c(fun = "predict"),
        args = list(
          object = quote(object$fit),
          new_data = quote(new_data),
          type = "numeric"
        )
      )
    )
  }
}

#' Fine-Tune a BERT Model
#'
#' `bert()` defines a model that fine-tunes a pre-trained BERT-like model to a
#' classification or regression task.
#'
#' This package (`tidybert`) is currently the only engine for this model. See
#' [tidybert_engine] for parameters available in this engine.
#'
#' The defined model is appropriate for use with `parsnip` and the rest of the
#' `tidymodels` framework.
#'
#' @param mode A single character string for the prediction outcome mode.
#'   Possible values for this model are "unknown", "regression", or
#'   "classification".
#' @param engine A single character string specifying what computational engine
#'   to use for fitting. The only implemented option is "tidybert".
#' @param epochs A single integer indicating the maximum number of epochs for
#'   training, or a vector of two integers, indicating the minimum and maximum
#'   number of epochs for training.
#' @param batch_size The number of samples to load in each batch during
#'   training.
#' @inheritParams bert_classification
#'
#' @return A specification for a model.
#' @export
bert <- function(mode = "unknown",
                 engine = "tidybert",
                 epochs = 10,
                 batch_size = 128,
                 bert_type = "bert_small_uncased",
                 n_tokens = 1) {
  # This only makes sense if they have parsnip installed.
  rlang::check_installed("parsnip")

  # Register the model. The register-er checks if it's already registered.
  .make_bert()

  # Capture the arguments in quosures
  args <- list(
    epochs = rlang::enquo(epochs),
    batch_size = rlang::enquo(batch_size),
    bert_type = rlang::enquo(bert_type),
    n_tokens = rlang::enquo(n_tokens)
  )

  # Save some empty slots for future parts of the specification
  return(
    parsnip::new_model_spec(
      "bert",
      args = args,
      eng_args = NULL,
      mode = mode,
      method = NULL,
      engine = engine
    )
  )
}

#' BERT models via tidybert
#'
#' The `tidybert` engine defines a [bert_classification()] or
#' [bert_regression()] model. The models are fit using
#' [luz::fit.luz_module_generator()].
#'
#' The available parameters are `bert_type`, `n_tokens`, `valid_data`, `loss`,
#' `optimizer`, `metrics`, `luz_opt_hparams`, and `...`. See
#' [bert_classification()] and [bert_regression()] for details.
#'
#' @name tidybert_engine
#' @keywords internal
NULL

#' Pre-Trained BERT Model
#'
#' The pre-trained BERT model that will be fine-tuned for a model.
#'
#' @param values A character vector indicating the names of available models.
#'   The default uses the 7 named pre-trained BERT models. We recommend that you
#'   select specific models that are likely to work on your hardware. See
#'   [torchtransformers::available_berts()] for possible values.
#'
#' @return A parameter that can be tuned with the `tune` package.
#' @export
#' @examples
#' if (rlang::is_installed("dials")) {
#'   bert_type()
#' }
bert_type <- function(values = c("bert_tiny_uncased",
                                 "bert_mini_uncased",
                                 "bert_small_uncased",
                                 "bert_medium_uncased",
                                 "bert_base_uncased",
                                 "bert_base_cased",
                                 "bert_large_uncased")) {
  # This only works if they have dials installed.
  rlang::check_installed("dials")

  rlang::arg_match(
    arg = values,
    values = torchtransformers::available_berts(),
    multiple = TRUE
  )

  dials::new_qual_param(
    type = "character",
    values = values,
    label = c(bert_type = "Pre-trained BERT Model")
  )
}

#' Number of Tokens
#'
#' The number of tokens to use for tokenization of predictors.
#'
#' @param range A two-element integer vector with the smallest and largest
#'   possible values. By default these values should be the powers of two to
#'   try.
#' @param trans An optional transformation to apply. By default,
#'   [scales::log2_trans()] (meaning take the log2 of the original values,
#'   resulting in small-number range values).
#'
#' @return A parameter that can be tuned with the `tune` package.
#' @export
#' @examples
#' if (rlang::is_installed("dials")) {
#'   n_tokens()
#' }
n_tokens <- function(range = c(1, 9), trans = scales::log2_trans()) {
  dials::new_quant_param(
    type = "integer",
    range = range,
    inclusive = c(TRUE, TRUE),
    label = c(n_tokens = "Number of Tokens"),
    # Technically we should have a finalizer that makes sure bert_type and
    # n_tokens are compatible, but I'm pretty sure the model will error out and
    # do that for us.
    finalize = NULL
  )
}
