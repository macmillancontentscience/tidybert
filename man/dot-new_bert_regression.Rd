% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bert_regression-constructor.R
\name{.new_bert_regression}
\alias{.new_bert_regression}
\title{Create the Bert Regression Object}
\usage{
.new_bert_regression(luz_model, n_tokens, blueprint)
}
\arguments{
\item{luz_model}{A model fit using \code{{luz}}.}

\item{n_tokens}{The number of tokens to which the predictors should be
tokenized.}

\item{blueprint}{The \code{{hardhat}} blueprint to reproduce the data.}
}
\value{
A \code{{hardhat}} \code{\link[hardhat]{new_model}}.
}
\description{
Create the Bert Regression Object
}
\keyword{internal}
