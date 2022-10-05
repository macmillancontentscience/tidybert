test_that("Parsnip registration works.", {
  skip_if_not_installed("parsnip")
  # Note: If something runs this before this test, technically we aren't seeing
  # the test do this, but it's close enough.
  expect_error(
    .make_bert(),
    NA
  )
  parsnip_env <- parsnip::get_model_env()
  expect_true(
    "bert" %in% parsnip_env$models
  )
  expect_snapshot(
    parsnip_env$bert
  )
  expect_snapshot(
    parsnip_env$bert_args
  )
  expect_snapshot(
    parsnip_env$bert_encoding
  )
  expect_snapshot(
    parsnip_env$bert_fit
  )
  expect_snapshot(
    parsnip_env$bert_modes
  )
  expect_snapshot(
    parsnip_env$bert_pkgs
  )
  expect_snapshot(
    parsnip_env$bert_predict
  )
})

test_that("Dials parameters work.", {
  skip_if_not_installed("dials")
  expect_snapshot(
    bert_type()
  )
  expect_snapshot(
    bert_type(values = c("a", "b"))
  )
  expect_snapshot(
    n_tokens()
  )
  expect_snapshot(
    n_tokens(c(3, 5))
  )
  expect_snapshot(
    n_tokens(c(10, 27), trans = NULL)
  )
})

test_that("bert model specification works.", {
  # TODO: Really test tuning and fitting.

  skip_if_not_installed("parsnip")
  expect_snapshot(
    bert()
  )
  expect_snapshot(
    bert(mode = "classification")
  )
  expect_snapshot(
    bert(mode = "regression")
  )
})