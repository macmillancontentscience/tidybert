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


# .make_token_map ---------------------------------------------------------


#' Make Token Map
#'
#' Given a list of input token sequences, construct a data frame with explicit
#' index columns. Later this can be joined onto the indexed outputs to add the
#' actual token and segment columns to the tidy data frames.
#'
#' @inheritParams tidy_bert_output
#'
#' @return A data frame of the input tokens, with explicit index columns.
#' @keywords internal
.make_token_map <- function(tokenized) {
  tok_id_list <- tokenized$token_ids
  tok_list <- purrr::map(tok_id_list, names)
  tt_list <- tokenized$token_type_ids

  token_map <- tibble::tibble(
    sequence_index = integer(),
    token_index = integer(),
    segment_index = integer(),
    token = character()
  )
  for (i in seq_along(tok_list)) {
    tokens <- tok_list[[i]]
    token_ids <- tok_id_list[[i]]
    segments <- tt_list[[i]]
    token_seq <- seq_along(tokens)
    token_map <- dplyr::bind_rows(
      token_map,
      data.frame(
        sequence_index = as.integer(i),
        token_index = token_seq,
        segment_index = segments,
        token = tokens,
        token_id = token_ids,
        stringsAsFactors = FALSE
      )
    )
  }

  return(token_map)
}



# .make_index_column ------------------------------------------------------


#' Make Index Column
#'
#' Given an overall shape and a particular dimension, construct the index column
#' for that dimension.
#'
#' @param shape Integer vector; the shape of the tensor to index.
#' @param which Integer scalar; which dimension to index.
#'
#' @return The index column as an integer vector.
#' @keywords internal
.make_index_column <- function(shape, which) {
  temp <- torch::torch_ones(dim = shape)

  dim <- rep(1, length(shape))
  dim[[which]] <- shape[[which]]
  index_tensor <- torch::torch_tensor(array(
    seq_len(shape[[which]]),
    dim = dim
  ))

  return(as.integer(torch::torch_flatten(
    temp * index_tensor, # broadcast
    start_dim = 1,
    end_dim = length(shape)
  )))
}
# .process_attention_result -----------------------------------------------


#' Process Attention
#'
#' Takes the raw output from a BERT model and turns the attention weights matrix
#' into a data frame.
#'
#' @inheritParams tidy_bert_output
#'
#' @return The attention weights from a BERT model, as a data frame.
#' @keywords internal
.process_attention_result <- function(bert_model_output) {
  attention_output <- bert_model_output$attention_weights

  # figure out best column order
  shape <- attention_output[[1]]$shape
  index_columns <- tibble::tibble(
    sequence_index = .make_index_column(shape = shape, which = 1L),
    layer_index = -1L, # just a placeholder
    head_index = .make_index_column(shape = shape, which = 2L),
    token_index = .make_index_column(shape = shape, which = 3L),
    segment_index = -1L, # just a placeholder
    token = "", # just a placeholder
    token_id = -1L, # just a placeholder
    attention_token_index = .make_index_column(shape = shape, which = 4L),
    attention_segment_index = -1L, # just a placeholder
    attention_token = "", # just a placeholder
    attention_token_id = -1L # just a placeholder
  )

  layer_indexes <- seq_len(length(attention_output))

  sequence_attention <- purrr::map_dfr(
    layer_indexes,
    function(this_layer_index) {
      result_i <- torch::as_array(attention_output[[this_layer_index]])

      this_layer <- torch::torch_flatten(result_i,
                                         start_dim = 1L,
                                         end_dim = 4L)

      this_layer <- tibble::tibble(attention_weight = as.numeric(this_layer))

      this_layer <- dplyr::bind_cols(index_columns, this_layer)

      this_layer[["layer_index"]] <- this_layer_index # yay base R
      this_layer
    }
  )
  return(
    dplyr::arrange(
      sequence_attention,
      .data$sequence_index
    )
  )
}


# .finalize_attention -----------------------------------------------------


#' Finalize Attention Output
#'
#' Takes the data frame output from `.process_attention_result`, joins on the
#' `token_map` information and filters out the padding tokens.
#'
#' @param processed_attention The output from `.process_attention_result`.
#' @param token_map The output from `.make_token_map`.
#'
#' @return A tidy version of the attention weights matrix, with one weight value
#'   per row.
#' @keywords internal
.finalize_attention <- function(processed_attention,
                                token_map) {
  to_ret <- processed_attention %>%
    # first add columns for attending tokens
    dplyr::left_join(token_map,
                     by = c("sequence_index", "token_index"),
                     suffix = c("", "_fill")) %>%
    dplyr::mutate(segment_index = .data$segment_index_fill,
                  token = .data$token_fill,
                  token_id = .data$token_id_fill) %>%
    dplyr::select(-dplyr::ends_with("_fill")) %>%
    # now add columns for attendee tokens
    dplyr::left_join(token_map,
                     by = c("sequence_index",
                            "attention_token_index" = "token_index"),
                     suffix = c("", "_fill")) %>%
    dplyr::mutate(attention_segment_index = .data$segment_index_fill,
                  attention_token = .data$token_fill,
                  attention_token_id = .data$token_id_fill) %>%
    dplyr::select(-dplyr::ends_with("_fill")) %>%
    # I don't think we need to support other conventions for the pad token.
    dplyr::filter(.data$token_id != 1L,
                  .data$attention_token_id != 1L)

  return(to_ret)
}


# .process_embeddings_result ----------------------------------------------


#' Process Embeddings
#'
#' Takes the raw output from a BERT model and turns the embeddings into a data
#' frame.
#'
#' @inheritParams tidy_bert_output
#'
#' @return The embedding vectors from a BERT model, as a data frame.
#' @keywords internal
.process_embeddings_result <- function(bert_model_output) {
  # for embeddings, we keep the last dimension unflattened
  shape <- bert_model_output$output_embeddings[[1]]$shape[1:2]
  index_columns <- tibble::tibble(
    sequence_index = .make_index_column(shape = shape, which = 1L),
    layer_index = -1L, # just a placeholder
    token_index = .make_index_column(shape = shape, which = 2L),
    segment_index = -1L, # just a placeholder
    token = "", # just a placeholder
    token_id = -1L # just a placeholder
  )

  embedding_output <- bert_model_output$output_embeddings
  initial_embeddings <- bert_model_output$initial_embeddings

  layer_indexes_actual <- seq_len(length(embedding_output))
  layer_indexes_all <- c(0L, layer_indexes_actual)

  sequence_outputs <- purrr::map_dfr(
    layer_indexes_all,
    function(this_layer_index) {
      if (this_layer_index == 0) {
        # In {tt}, the initial embeddings are returned as a separate element
        # of the output. This is how we combine them with the layer output
        # embeddings.
        result_i <- initial_embeddings
      } else {
        result_i <- torch::as_array(embedding_output[[this_layer_index]])
      }

      this_layer <- torch::torch_flatten(result_i,
                                         start_dim = 1L,
                                         end_dim = 2L)

      this_layer <- tibble::as_tibble(as.matrix(this_layer),
                                      .name_repair = "minimal")
      # set names explicitly, rather than rely on default behavior.
      names(this_layer) <- paste0("V", seq_along(names(this_layer)))

      this_layer <- dplyr::bind_cols(index_columns, this_layer)

      this_layer[["layer_index"]] <- this_layer_index # yay base R
      this_layer
    }
  )
  return(
    dplyr::arrange(
      sequence_outputs,
      .data$sequence_index
    )
  )
}



# .finalize_embeddings ----------------------------------------------------


#' Finalize Embeddings Output
#'
#' Takes the data frame output from `.process_embeddings_result`, joins on the
#' `token_map` information and filters out the padding tokens.
#'
#' @param processed_embeddings The output from `.process_embeddings_result`.
#' @param token_map The output from `.make_token_map`.
#'
#' @return A tidy version of the output embeddings, with one embedding vector
#'   per row.
#' @keywords internal
.finalize_embeddings <- function(processed_embeddings,
                                 token_map) {
  to_ret <- dplyr::left_join(processed_embeddings,
                             token_map,
                             by = c("sequence_index", "token_index"),
                             suffix = c("", "_fill")) %>%
    dplyr::mutate(segment_index = .data$segment_index_fill,
                  token = .data$token_fill,
                  token_id = .data$token_id_fill) %>%
    dplyr::select(-dplyr::ends_with("_fill")) %>%
    # I don't think we need to support other conventions for the pad token.
    dplyr::filter(.data$token_id != 1L)

  return(to_ret)
}


# tidy_bert_output --------------------------------------------------


#' Tidy the BERT Output
#'
#' Given the output from a transformer model, construct tidy data frames for
#' the layer outputs and the attention weights.
#'
#' @param bert_model_output The output from a BERT model.
#' @param tokenized The raw output from `torchtransformers::tokenize_bert`.
#'
#' @return A list of data frames, one for the layer output embeddings and one
#' for the attention weights.
#' @export
tidy_bert_output <- function(bert_model_output,
                             tokenized) {
  token_map <- .make_token_map(tokenized)

  embeddings_df <- .process_embeddings_result(bert_model_output)
  embeddings_df <- .finalize_embeddings(embeddings_df, token_map)

  attention_df <- .process_attention_result(bert_model_output)
  attention_df <- .finalize_attention(attention_df, token_map)

  return(list("embeddings" = embeddings_df, "attention" = attention_df))
}


