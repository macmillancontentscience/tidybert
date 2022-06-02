#' Fit a `bert`
#'
#' `bert()` fits a model.
#'
#' @param x Depending on the context:
#'
#'   * A __data frame__ of predictors.
#'   * A __matrix__ of predictors.
#'   * A __recipe__ specifying a set of preprocessing steps
#'     created from [recipes::recipe()].
#'
#' @param y When `x` is a __data frame__ or __matrix__, `y` is the outcome
#' specified as:
#'
#'   * A __data frame__ with 1 numeric column.
#'   * A __matrix__ with 1 numeric column.
#'   * A numeric __vector__.
#'
#' @param data When a __recipe__ or __formula__ is used, `data` is specified as:
#'
#'   * A __data frame__ containing both the predictors and the outcome.
#'
#' @param formula A formula specifying the outcome terms on the left-hand side,
#' and the predictor terms on the right-hand side.
#'
#' @param ... Not currently used, but required for extensibility.
#'
#' @return
#'
#' A `bert` object.
#'
#' @examples
#' predictors <- mtcars[, -1]
#' outcome <- mtcars[, 1]
#'
#' # XY interface
#' mod <- bert(predictors, outcome)
#'
#' # Formula interface
#' mod2 <- bert(mpg ~ ., mtcars)
#'
#' # Recipes interface
#' library(recipes)
#' rec <- recipe(mpg ~ ., mtcars)
#' rec <- step_log(rec, disp)
#' mod3 <- bert(rec, mtcars)
#'
#' @export
bert <- function(x, ...) {
  UseMethod("bert")
}

#' @export
#' @rdname bert
bert.default <- function(x, ...) {
  stop("`bert()` is not defined for a '", class(x)[1], "'.", call. = FALSE)
}

# XY method - data frame

#' @export
#' @rdname bert
bert.data.frame <- function(x, y, ...) {
  processed <- hardhat::mold(x, y)
  bert_bridge(processed, ...)
}

# XY method - matrix

#' @export
#' @rdname bert
bert.matrix <- function(x, y, ...) {
  processed <- hardhat::mold(x, y)
  bert_bridge(processed, ...)
}

# Formula method

#' @export
#' @rdname bert
bert.formula <- function(formula, data, ...) {
  processed <- hardhat::mold(formula, data)
  bert_bridge(processed, ...)
}

# Recipe method

#' @export
#' @rdname bert
bert.recipe <- function(x, data, ...) {
  processed <- hardhat::mold(x, data)
  bert_bridge(processed, ...)
}

# ------------------------------------------------------------------------------
# Bridge

bert_bridge <- function(processed, ...) {
  predictors <- processed$predictors
  outcome <- processed$outcomes[[1]]

  fit <- bert_impl(predictors, outcome)

  new_bert(
    coefs = fit$coefs,
    blueprint = processed$blueprint
  )
}


# ------------------------------------------------------------------------------
# Implementation

bert_impl <- function(predictors, outcome) {
  list(coefs = 1)
}
