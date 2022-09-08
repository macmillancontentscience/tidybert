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

#' Pretrained BERT Model with Linear Output
#'
#' Construct a BERT model with pretrained weights, and add a final dense linear
#' layer to transform to a desired number of dimensions. Note that we only use
#' the CLS token output from the final layer of the BERT model. It is possible
#' to attach a classification head to BERT using other techniques, but here we
#' use this simple technique.
#'
#' @inheritParams torchtransformers::make_and_load_bert
#' @param output_dim Integer; the target number of output dimensions.
#'
#' @return A torch neural net model with pretrained BERT weights and a final
#'   dense layer.
#' @export
model_bert_linear <- torch::nn_module(
  "bert_linear",
  initialize = function(model_name = "bert_tiny_uncased", output_dim = 1L) {
    embedding_size <- torchtransformers::config_bert(
      model_name, "embedding_size"
    )
    self$bert <- torchtransformers::make_and_load_bert(model_name)
    # After pooled bert output, do a final dense layer.
    self$linear <- torch::nn_linear(
      in_features = embedding_size,
      out_features = output_dim
    )
    # A check parameter, used to easily determine whether we need to reload the
    # model. Based on https://github.com/mlverse/tabnet/blob/e08f76dbdb0e9bc1bc395ee081b874ee1fa80367/R/tab-network.R#L398
    # TODO: Should this go in torchtransformers, or maybe even torch?
    self$.check <- torch::nn_parameter(
      torch::torch_tensor(1, requires_grad = TRUE)
    )
  },
  forward = function(x) {
    output <- self$bert(x$token_ids, x$token_type_ids)

    # Take the output embeddings from the last layer.
    output <- output$output_embeddings
    output <- output[[length(output)]]
    # Take the [CLS] token embedding for classification.
    output <- output[ , 1, ]
    # Apply the last dense layer to the pooled output.
    output <- self$linear(output)
    return(output)
  }
)
