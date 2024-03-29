% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bert_regression-fit.R
\name{bert_regression}
\alias{bert_regression}
\alias{bert_regression.default}
\alias{bert_regression.data.frame}
\alias{bert_regression.matrix}
\alias{bert_regression.formula}
\title{Fit a BERT-style neural network}
\usage{
bert_regression(x, ...)

\method{bert_regression}{default}(x, ...)

\method{bert_regression}{data.frame}(
  x,
  y,
  valid_x = 0.1,
  valid_y = NULL,
  bert_type = "bert_tiny_uncased",
  n_tokens = torchtransformers::config_bert(bert_type, "max_tokens"),
  loss = torch::nn_mse_loss(),
  optimizer = torch::optim_adam,
  metrics = list(luz::luz_metric_rmse()),
  epochs = 10,
  batch_size = 128,
  luz_opt_hparams = list(),
  ...
)

\method{bert_regression}{matrix}(
  x,
  y,
  valid_x = 0.1,
  valid_y = NULL,
  bert_type = "bert_tiny_uncased",
  n_tokens = torchtransformers::config_bert(bert_type, "max_tokens"),
  loss = torch::nn_mse_loss(),
  optimizer = torch::optim_adam,
  metrics = list(luz::luz_metric_rmse()),
  epochs = 10,
  batch_size = 128,
  luz_opt_hparams = list(),
  ...
)

\method{bert_regression}{formula}(
  formula,
  data,
  valid_data = 0.1,
  bert_type = "bert_tiny_uncased",
  n_tokens = torchtransformers::config_bert(bert_type, "max_tokens"),
  loss = torch::nn_mse_loss(),
  optimizer = torch::optim_adam,
  metrics = list(luz::luz_metric_rmse()),
  epochs = 10,
  batch_size = 128,
  luz_opt_hparams = list(),
  ...
)
}
\arguments{
\item{x}{Depending on the context:
\itemize{
\item A \strong{data frame} of character predictors.
\item A \strong{matrix} of character predictors.
\item Note that a \strong{recipe} created from \code{\link[recipes:recipe]{recipes::recipe()}} will NOT
currently work.
}}

\item{...}{Additional parameters to pass to methods or to luz for fitting.}

\item{y}{When \code{x} is a \strong{data frame} or \strong{matrix}, \code{y} is the outcome
specified as:
\itemize{
\item A \strong{data frame} with 1 numerical column.
\item A \strong{matrix} with 1 numerical column.
\item A numerical \strong{vector}.
}}

\item{valid_x}{Depending on the context:
\itemize{
\item A number between 0 and 1, representing the fraction of data to use for
model validation.
\item Predictors in the same format as \code{x}. These predictors will be used for
model validation.
\item \code{NULL}, in which case no data will be used for model validation.
}}

\item{valid_y}{When \code{valid_x} is a set of predictors, \code{valid_y} should be
outcomes in the same format as \code{y}.}

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

\item{luz_opt_hparams}{List; parameters to pass on to
\code{\link[luz]{set_opt_hparams}} to initialize the optimizer.}

\item{formula}{A formula specifying the outcome term on the left-hand side,
and the predictor terms on the right-hand side.}

\item{data}{When a \strong{formula} is used, \code{data} is specified as:
\itemize{
\item A \strong{data frame} containing both the predictors and the outcome. The
predictors should be character vectors. The outcome should be numerical.
}}

\item{valid_data}{When a \strong{formula} is used, \code{valid_data} can be:
\itemize{
\item A \strong{data frame} containing both the predictors and the outcome to be
used for model validation, in the same format as \code{data}.
\item A number between 0 and 1, representing the fraction of data to use for
model validation.
\item \code{NULL}, in which case no data will be used for model validation.
}}
}
\value{
A \code{bert_regression} object.
}
\description{
\code{bert_regression()} fits a regression neural network in the style of
\href{https://github.com/google-research/bert}{BERT from Google Research}.
}
\details{
The generated model is a pretrained BERT model with a final dense linear
layer to map the output to a numerical value, constructed using
\code{\link[=model_bert_linear]{model_bert_linear()}}. That pretrained model is fine-tuned on the provided
training data. Input data (during both fitting and prediction) is
automatically tokenized to match the tokenization expected by the BERT model.
}
