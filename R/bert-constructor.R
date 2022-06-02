new_bert <- function(coefs, blueprint) {
  hardhat::new_model(coefs = coefs, blueprint = blueprint, class = "bert")
}
