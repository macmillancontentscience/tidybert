## TODO: Also do this stuff: https://www.tidymodels.org/learn/develop/models/
## The rough ideas is that we'll have a single function along the lines of bert
## (equivalent to, for example, parsnip::boost_tree), with a "mode" that
## switches between classification, linear regression, and any other model types
## we implement that fall into the general BERT arena. That way this single
## parsnip function is the "hub" for people to think about how their problem
## might work. I think. tabnet does something like this.
