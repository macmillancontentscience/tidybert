# I normally wouldn't test these internal functions, but I suspect I'll want to
# move them somewhere and export them, so let's make sure they work on their
# own.
test_that("character checks work", {
  expect_snapshot(
    .check_predictors_are_character(
      data.frame(a = 1:26, b = letters)
    )
  )
  expect_snapshot(
    .check_predictors_are_character(
      data.frame(a = 1:26 + 0.1, b = 1:26)
    )
  )
  expect_snapshot(
    .check_predictors_are_character(
      data.frame(a = rev(letters), b = letters)
    )
  )

  expect_error(
    .validate_predictors_are_character(
      data.frame(a = 1:26, b = letters)
    ),
    regexp = "'a': 'integer'",
    class = "bad_predictor_classes"
  )
  expect_error(
    .validate_predictors_are_character(
      data.frame(a = 1:26 + 0.1, b = 1:26)
    ),
    regexp = "'a': 'numeric'",
    class = "bad_predictor_classes"
  )

  properly_character <- data.frame(a = rev(letters), b = letters)
  expect_identical(
    .validate_predictors_are_character(properly_character),
    properly_character
  )

  # Check one with a tibble to make sure nothing is weird.
  properly_character <- dplyr::as_tibble(properly_character)
  expect_identical(
    .validate_predictors_are_character(properly_character),
    properly_character
  )
})

test_that("number of predictor check works.", {
  test_df <- data.frame(a = 1, b = 2, c = 3)
  expect_identical(
    .validate_predictor_count(test_df, 3),
    test_df
  )
  expect_error(
    .validate_predictor_count(test_df, 2),
    regexp = "2 predictor columns",
    class = "too_many_predictors"
  )
})
