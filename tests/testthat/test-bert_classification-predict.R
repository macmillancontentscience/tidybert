test_that("predicting for a bert_classification works", {
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
  test_model <- bert_classification(
    y ~ x1 + x2,
    train_df,
    n_tokens = 5L,
    epochs = 1L
  )

  # This model is super bad and just always picks a, but I did other tests that
  # convinced me the functions actually work. I just want to check that it keeps
  # doing the same thing.
  preds_class <- predict(
    test_model,
    dplyr::tibble(
      x1 = letters[1:5],
      x2 = rev(letters)[1:5]
    )
  )
  expect_identical(
    preds_class$.pred_class,
    factor(rep("a", 5), levels = c("a", "b"))
  )

  preds_prob <- predict(
    test_model,
    dplyr::tibble(
      x1 = letters[1:5],
      x2 = rev(letters)[1:5]
    ),
    type = "prob"
  )
  expect_equal(
    preds_prob$.pred_a[[1]],
    0.98445999622345
  )

  # Check snapshots to catch anything I didn't realize we weren't testing.
  expect_snapshot(preds_class)
  expect_snapshot(preds_prob)
})
