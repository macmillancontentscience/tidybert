% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bert_classification-fit.R
\name{.bert_classification_impl}
\alias{.bert_classification_impl}
\title{Create and Fit the Model}
\usage{
.bert_classification_impl(
  predictors,
  outcome,
  valid_data = 0.1,
  bert_type = "bert_tiny_uncased",
  n_tokens = torchtransformers::config_bert(bert_type, "max_tokens"),
  loss = torch::nn_cross_entropy_loss(),
  optimizer = torch::optim_adam,
  metrics = list(luz::luz_metric_accuracy()),
  epochs = 10,
  batch_size = 128,
  drop_last = TRUE,
  luz_opt_hparams = list(),
  ...
)
}
\arguments{
\item{predictors}{A tibble containing one or two character columns.}

\item{outcome}{A factor of output classes associated with the predictors.}

\item{valid_data}{Either a number between 0 and 1, or a blueprint-processed
dataset.}

\item{bert_type}{Character; which flavor of BERT to use. See
\code{\link[torchtransformers:available_berts]{available_berts()}} for known models.}

\item{n_tokens}{An integer scalar indicating the number of tokens in the
output.}

\item{loss}{(\code{function}, optional) An optional function with the signature
\verb{function(input, target)}. It's only requires if your \code{nn_module} doesn't
implement a method called \code{loss}.}

\item{optimizer}{(\code{torch_optimizer}, optional) A function with the signature
\verb{function(parameters, ...)} that is used to initialize an optimizer given
the model parameters.}

\item{metrics}{(\code{list}, optional) A list of metrics to be tracked during
the training procedure. Sometimes, you want some metrics to be evaluated
only during training or validation, in this case you can pass a \code{\link[luz:luz_metric_set]{luz_metric_set()}}
object to specify metrics used in each stage.}

\item{epochs}{(int) The maximum number of epochs for training the model. If a
single value is provided, this is taken to be the \code{max_epochs} and
\code{min_epochs} is set to 0. If a vector of two numbers is provided, the first
value is \code{min_epochs} and the second value is \code{max_epochs}. The minimum and
maximum number of epochs are included in the context object as
\code{ctx$min_epochs} and \code{ctx$max_epochs}, respectively.}

\item{batch_size}{(int, optional): how many samples per batch to load
(default: \code{1}).}

\item{drop_last}{(bool, optional): set to \code{TRUE} to drop the last incomplete batch,
if the dataset size is not divisible by the batch size. If \code{FALSE} and
the size of dataset is not divisible by the batch size, then the last batch
will be smaller. (default: \code{FALSE})}

\item{luz_opt_hparams}{List; parameters to pass on to
\code{\link[luz]{set_opt_hparams}} to initialize the optimizer.}

\item{...}{Currently unused but included to expand into more luz options.}
}
\value{
The fitted model with class \code{luz_module_fitted}.
}
\description{
Create and Fit the Model
}
\keyword{internal}
