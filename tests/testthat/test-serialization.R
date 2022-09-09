test_that("Serialization works.", {
  # torch_manual_seed appears to need an initialization for consistency between
  # my normal R session and R CMD check.
  torch::torch_manual_seed(1234)

  train_df <- dplyr::tibble(
    x1 = letters,
    x2 = rev(letters),
    y = factor(rep(c("a", "b"), 13))
  )

  set.seed(1234)
  torch::torch_manual_seed(1234)
  pre_model <- bert_classification(
    y ~ x1 + x2,
    train_df,
    n_tokens = 5L,
    epochs = 1L
  )

  temp_location <- tempfile()
  on.exit(unlink(temp_location), add = TRUE)
  saveRDS(pre_model, temp_location)
  test_model <- readRDS(temp_location)

  # I manually checked that these snapshots match the ones produced in the
  # predict tests.
  expect_snapshot(
    predict(
      test_model,
      dplyr::tibble(
        x1 = letters[1:5],
        x2 = rev(letters)[1:5]
      )
    )
  )
  expect_snapshot(
    predict(
      test_model,
      dplyr::tibble(
        x1 = letters[1:5],
        x2 = rev(letters)[1:5]
      ),
      type = "prob"
    )
  )
})
