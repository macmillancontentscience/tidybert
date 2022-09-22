test_that("model_bert_linear produced the expected model", {
  test_result <- model_bert_linear()
  expect_snapshot(test_result)
  test_dict <- test_result$state_dict()
  expect_snapshot(names(test_dict))
  expect_identical(test_dict$linear.weight$shape[[1]], 1L)

  output_dim <- 4L
  test_result <- model_bert_linear(output_dim = output_dim)
  expect_snapshot(test_result)
  test_dict <- test_result$state_dict()
  expect_snapshot(names(test_dict))
  expect_identical(test_dict$linear.weight$shape[[1]], output_dim)

  output_dim <- 3L
  test_result <- model_bert_linear(
    bert_type = "bert_small_uncased",
    output_dim = output_dim
  )
  expect_snapshot(test_result)
  test_dict <- test_result$state_dict()
  expect_snapshot(names(test_dict))
  expect_identical(test_dict$linear.weight$shape[[1]], output_dim)
})
