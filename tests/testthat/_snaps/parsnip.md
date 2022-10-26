# Parsnip registration works.

    Code
      parsnip_env$bert
    Output
      # A tibble: 2 x 2
        engine   mode          
        <chr>    <chr>         
      1 tidybert classification
      2 tidybert regression    

---

    Code
      parsnip_env$bert_args
    Output
      # A tibble: 4 x 5
        engine   parsnip    original   func             has_submodel
        <chr>    <chr>      <chr>      <list>           <lgl>       
      1 tidybert epochs     epochs     <named list [2]> TRUE        
      2 tidybert batch_size batch_size <named list [2]> FALSE       
      3 tidybert bert_type  bert_type  <named list [2]> FALSE       
      4 tidybert n_tokens   n_tokens   <named list [2]> FALSE       

---

    Code
      parsnip_env$bert_encoding
    Output
      # A tibble: 2 x 7
        model engine   mode           predictor_indicators compute_i~1 remov~2 allow~3
        <chr> <chr>    <chr>          <chr>                <lgl>       <lgl>   <lgl>  
      1 bert  tidybert classification none                 FALSE       FALSE   TRUE   
      2 bert  tidybert regression     none                 FALSE       FALSE   TRUE   
      # ... with abbreviated variable names 1: compute_intercept,
      #   2: remove_intercept, 3: allow_sparse_x

---

    Code
      parsnip_env$bert_fit
    Output
      # A tibble: 2 x 3
        engine   mode           value           
        <chr>    <chr>          <list>          
      1 tidybert classification <named list [4]>
      2 tidybert regression     <named list [4]>

---

    Code
      parsnip_env$bert_modes
    Output
      [1] "unknown"        "classification" "regression"    

---

    Code
      parsnip_env$bert_pkgs
    Output
      # A tibble: 0 x 3
      # ... with 3 variables: engine <chr>, pkg <list>, mode <chr>

---

    Code
      parsnip_env$bert_predict
    Output
      # A tibble: 3 x 4
        engine   mode           type    value           
        <chr>    <chr>          <chr>   <list>          
      1 tidybert classification class   <named list [4]>
      2 tidybert classification prob    <named list [4]>
      3 tidybert regression     numeric <named list [4]>

# Dials parameters work.

    Code
      bert_type()
    Output
      Pre-trained BERT Model  (qualitative)
      7 possible value include:
      'bert_tiny_uncased', 'bert_mini_uncased', 'bert_small_uncased', 'bert_medium_... 

---

    `values` must be one of "bert_L2H128_uncased", "bert_L4H128_uncased", "bert_L6H128_uncased", "bert_L8H128_uncased", "bert_L10H128_uncased", "bert_L12H128_uncased", "bert_L2H256_uncased", "bert_L4H256_uncased", "bert_L6H256_uncased", "bert_L8H256_uncased", "bert_L10H256_uncased", "bert_L12H256_uncased", "bert_L2H512_uncased", "bert_L4H512_uncased", "bert_L6H512_uncased", "bert_L8H512_uncased", "bert_L10H512_uncased", "bert_L12H512_uncased", "bert_L2H768_uncased", "bert_L4H768_uncased", "bert_L6H768_uncased", "bert_L8H768_uncased", "bert_L10H768_uncased", "bert_L12H768_uncased", "bert_tiny_uncased", "bert_mini_uncased", "bert_small_uncased", "bert_medium_uncased", "bert_base_uncased", "bert_base_cased", or "bert_large_uncased", not "a".

---

    Code
      bert_type(values = torchtransformers::available_berts()[1:3])
    Output
      Pre-trained BERT Model  (qualitative)
      3 possible value include:
      'bert_L2H128_uncased', 'bert_L4H128_uncased' and 'bert_L6H128_uncased' 

---

    Code
      n_tokens()
    Output
      Number of Tokens (quantitative)
      Range: [1, 9]

---

    Code
      n_tokens(c(3, 5))
    Output
      Number of Tokens (quantitative)
      Range: [3, 5]

---

    Code
      n_tokens(c(10, 27), trans = NULL)
    Output
      Number of Tokens (quantitative)
      Range: [10, 27]

# bert model specification works.

    Code
      bert()
    Message <rlang_message>
      ! parsnip could not locate an implementation for `bert` unknown model specifications using the `tidybert` engine.
    Output
      bert Model Specification (unknown mode)
      
      Main Arguments:
        epochs = 10
        batch_size = 128
      
      Computational engine: tidybert 
      

---

    Code
      bert(mode = "classification")
    Output
      bert Model Specification (classification)
      
      Main Arguments:
        epochs = 10
        batch_size = 128
      
      Computational engine: tidybert 
      

---

    Code
      bert(mode = "regression")
    Output
      bert Model Specification (regression)
      
      Main Arguments:
        epochs = 10
        batch_size = 128
      
      Computational engine: tidybert 
      

