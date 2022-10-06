train_df <- dplyr::tibble(
  x1 = letters,
  x2 = rev(letters),
  y = (1:26)/10
)
y <- train_df$y
set.seed(1234)
validation_data <- dplyr::sample_n(train_df, 7)

test_that("fitting bert_regression works for dfs", {
  # torch_manual_seed appears to need an initialization for consistency between
  # my normal R session and R CMD check.
  torch::torch_manual_seed(1234)

  expect_error(
    bert_regression(
      x = dplyr::select(train_df, x1, x2),
      y = train_df$y,
      valid_x = dplyr::select(validation_data, x1, x2),
      valid_y = NULL,
      n_tokens = 5L,
      epochs = 1L
    ),
    regexp = "Please provide both",
    class = "bad_valid_data"
  )

  set.seed(1234)
  torch::torch_manual_seed(1234)
  test_result <- bert_regression(
    x = dplyr::select(train_df, x1, x2),
    y = dplyr::select(train_df, y),
    n_tokens = 5L,
    epochs = 1L
  )
  # Times can change.
  test_result$luz_model$records$profile <- NULL
  # Metrics are changing during R CMD Check. I'd rather not do this but for now
  # I can't find a way to make this consistent.
  test_result$luz_model$records <- NULL
  expect_snapshot(test_result)

  set.seed(1234)
  torch::torch_manual_seed(1234)
  test_result <- bert_regression(
    x = dplyr::select(train_df, x1, x2),
    y = y,
    valid_x = dplyr::select(validation_data, x1, x2),
    valid_y = validation_data$y,
    n_tokens = 5L,
    epochs = 1L
  )
  # Times can change.
  test_result$luz_model$records$profile <- NULL
  expect_snapshot(test_result)
})

test_that("fitting bert_regression works for matrices", {
  train_matrix <- as.matrix(
    dplyr::select(train_df, x1, x2)
  )
  set.seed(1234)
  torch::torch_manual_seed(1234)
  test_result <- bert_regression(
    x = train_matrix,
    y = y,
    n_tokens = 5L,
    epochs = 1L
  )
  # Times can change.
  test_result$luz_model$records$profile <- NULL
  expect_snapshot(test_result)
})

test_that("fitting bert_regression works for formulas", {
  expect_error(
    bert_regression(
      y ~ x1 + x2,
      train_df,
      valid_data = dplyr::select(validation_data, x1, x2),
      n_tokens = 5L,
      epochs = 1L
    ),
    regexp = "outcomes were not found"
  )

  set.seed(1234)
  torch::torch_manual_seed(1234)
  test_result <- bert_regression(
    y ~ x1 + x2,
    train_df,
    n_tokens = 5L,
    epochs = 1L
  )
  # Times can change.
  test_result$luz_model$records$profile <- NULL
  expect_snapshot(test_result)

  set.seed(1234)
  torch::torch_manual_seed(1234)
  test_result <- bert_regression(
    y ~ x1 + x2,
    train_df,
    valid_data = validation_data,
    n_tokens = 5L,
    epochs = 1L
  )
  # Times can change.
  test_result$luz_model$records$profile <- NULL
  expect_snapshot(test_result)
})

test_that("fitting bert_regression fails gracefully", {
  expect_error(
    bert_regression(1:10),
    regexp = "is not defined for a 'integer'"
  )
})
