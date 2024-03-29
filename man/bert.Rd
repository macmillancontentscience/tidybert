% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/parsnip.R
\name{bert}
\alias{bert}
\title{Fine-Tune a BERT Model}
\usage{
bert(
  mode = "unknown",
  engine = "tidybert",
  epochs = 10,
  batch_size = 128,
  bert_type = "bert_small_uncased",
  n_tokens = 1
)
}
\arguments{
\item{mode}{A single character string for the prediction outcome mode.
Possible values for this model are "unknown", "regression", or
"classification".}

\item{engine}{A single character string specifying what computational engine
to use for fitting. The only implemented option is "tidybert".}

\item{epochs}{A single integer indicating the maximum number of epochs for
training, or a vector of two integers, indicating the minimum and maximum
number of epochs for training.}

\item{batch_size}{The number of samples to load in each batch during
training.}

\item{bert_type}{Character; which flavor of BERT to use. See
\code{\link[torchtransformers:available_berts]{available_berts()}} for known models.}

\item{n_tokens}{An integer scalar indicating the number of tokens in the
output.}
}
\value{
A specification for a model.
}
\description{
\code{bert()} defines a model that fine-tunes a pre-trained BERT-like model to a
classification or regression task.
}
\details{
This package (\code{tidybert}) is currently the only engine for this model. See
\link{tidybert_engine} for parameters available in this engine.

The defined model is appropriate for use with \code{parsnip} and the rest of the
\code{tidymodels} framework.
}
