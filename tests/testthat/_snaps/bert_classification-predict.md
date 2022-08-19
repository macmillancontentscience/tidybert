# predicting for a bert_classification works

    Code
      predict(test_model, dplyr::tibble(x1 = letters[1:5], x2 = rev(letters)[1:5]))
    Output
      # A tibble: 5 x 1
        .pred_class
        <fct>      
      1 a          
      2 a          
      3 a          
      4 a          
      5 a          

---

    Code
      predict(test_model, dplyr::tibble(x1 = letters[1:5], x2 = rev(letters)[1:5]),
      type = "prob")
    Output
      # A tibble: 5 x 2
        .pred_a .pred_b
          <dbl>   <dbl>
      1   0.987  0.0135
      2   0.981  0.0187
      3   0.982  0.0177
      4   0.976  0.0244
      5   0.984  0.0164

