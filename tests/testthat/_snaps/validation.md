# character checks work

    Code
      .check_predictors_are_character(data.frame(a = 1:26, b = letters))
    Output
      $ok
      [1] FALSE
      
      $bad_classes
      $bad_classes$a
      [1] "integer"
      
      

---

    Code
      .check_predictors_are_character(data.frame(a = 1:26 + 0.1, b = 1:26))
    Output
      $ok
      [1] FALSE
      
      $bad_classes
      $bad_classes$a
      [1] "numeric"
      
      $bad_classes$b
      [1] "integer"
      
      

---

    Code
      .check_predictors_are_character(data.frame(a = rev(letters), b = letters))
    Output
      $ok
      [1] TRUE
      
      $bad_classes
      list()
      

