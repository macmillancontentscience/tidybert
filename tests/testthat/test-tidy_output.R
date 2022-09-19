test_that("bert output tidiers work", {
  bert_model <- torchtransformers::model_bert_pretrained("bert_tiny_uncased")

  test_input_1 <- c("Why didn't the chicken cross the road?",
                    "Why didn't the chicken cross the road?")

  test_input_2 <- c("Because it was too wide.",
                    "Because it was too tired.")

  # tokenize the input
  n_tokens <- 20L
  n_inputs <- length(test_input_1)
  tokenized <- torchtransformers::tokenize_bert(test_input_1,
                                                test_input_2,
                                                n_tokens = n_tokens)
  # format the input
  x <- list(
    token_ids = torch::torch_tensor(tokenized$token_ids),
    token_type_ids = torch::torch_tensor(tokenized$token_type_ids)
  )


  bert_model$eval()
  bert_output <- bert_model(x)
  tidy_out <- tidy_bert_output(bert_output, tokenized)

  # check the column names and the first few values
  expect_snapshot(names(tidy_out$embeddings))
  expect_snapshot(head(tidy_out$embeddings$V1))
  expect_snapshot(names(tidy_out$attention))
  expect_snapshot(head(tidy_out$attention$attention_weight))
})
