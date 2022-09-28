test_that("predicting for a bert_regression works", {
  # torch_manual_seed appears to need an initialization for consistency between
  # my normal R session and R CMD check.
  torch::torch_manual_seed(1234)

  train_df <- dplyr::tibble(
    x1 = letters,
    x2 = rev(letters),
    y = (1:26)/10
  )

  set.seed(1234)
  torch::torch_manual_seed(1234)
  test_model <- bert_regression(
    y ~ x1 + x2,
    train_df,
    n_tokens = 5L,
    epochs = 1L
  )

  # This model is super bad, but I did other tests that convinced me the
  # functions actually work. I just want to check that it keeps doing the same
  # thing, allowing some tolerance for system differences.
  preds_reg <- predict(
    test_model,
    dplyr::tibble(
      x1 = letters[1:5],
      x2 = rev(letters)[1:5]
    )
  )
  expect_equal(
    preds_reg$.pred,
    c(3.22, 3.27, 3.28, 3.19, 3.30),
    # Unfortunately we need a wide tolerance until we sort out a standard test
    # box.
    tolerance = 0.1
  )

  # At some point we should check a snapshot, but probably all the snapshots
  # should be created by a standard system, which isn't mine.
  # expect_snapshot(preds_reg)
})
