# model_bert_linear produced the expected model

    Code
      test_result
    Output
      An `nn_module` containing 4,369,537 parameters.
      
      -- Modules ---------------------------------------------------------------------
      * bert: <BERT> #4,369,408 parameters
      * linear: <nn_linear> #129 parameters

---

    Code
      names(test_dict)
    Output
       [1] "bert.embeddings.word_embeddings.weight"                 
       [2] "bert.embeddings.token_type_embeddings.weight"           
       [3] "bert.embeddings.position_embeddings.weight"             
       [4] "bert.embeddings.layer_norm.weight"                      
       [5] "bert.embeddings.layer_norm.bias"                        
       [6] "bert.encoder.layer.0.attention.self.in_proj_weight"     
       [7] "bert.encoder.layer.0.attention.self.in_proj_bias"       
       [8] "bert.encoder.layer.0.attention.self.out_proj.weight"    
       [9] "bert.encoder.layer.0.attention.self.out_proj.bias"      
      [10] "bert.encoder.layer.0.attention.output.layer_norm.weight"
      [11] "bert.encoder.layer.0.attention.output.layer_norm.bias"  
      [12] "bert.encoder.layer.0.intermediate.dense.weight"         
      [13] "bert.encoder.layer.0.intermediate.dense.bias"           
      [14] "bert.encoder.layer.0.output.dense.weight"               
      [15] "bert.encoder.layer.0.output.dense.bias"                 
      [16] "bert.encoder.layer.0.output.layer_norm.weight"          
      [17] "bert.encoder.layer.0.output.layer_norm.bias"            
      [18] "bert.encoder.layer.1.attention.self.in_proj_weight"     
      [19] "bert.encoder.layer.1.attention.self.in_proj_bias"       
      [20] "bert.encoder.layer.1.attention.self.out_proj.weight"    
      [21] "bert.encoder.layer.1.attention.self.out_proj.bias"      
      [22] "bert.encoder.layer.1.attention.output.layer_norm.weight"
      [23] "bert.encoder.layer.1.attention.output.layer_norm.bias"  
      [24] "bert.encoder.layer.1.intermediate.dense.weight"         
      [25] "bert.encoder.layer.1.intermediate.dense.bias"           
      [26] "bert.encoder.layer.1.output.dense.weight"               
      [27] "bert.encoder.layer.1.output.dense.bias"                 
      [28] "bert.encoder.layer.1.output.layer_norm.weight"          
      [29] "bert.encoder.layer.1.output.layer_norm.bias"            
      [30] "linear.weight"                                          
      [31] "linear.bias"                                            

---

    Code
      test_result
    Output
      An `nn_module` containing 4,369,924 parameters.
      
      -- Modules ---------------------------------------------------------------------
      * bert: <BERT> #4,369,408 parameters
      * linear: <nn_linear> #516 parameters

---

    Code
      names(test_dict)
    Output
       [1] "bert.embeddings.word_embeddings.weight"                 
       [2] "bert.embeddings.token_type_embeddings.weight"           
       [3] "bert.embeddings.position_embeddings.weight"             
       [4] "bert.embeddings.layer_norm.weight"                      
       [5] "bert.embeddings.layer_norm.bias"                        
       [6] "bert.encoder.layer.0.attention.self.in_proj_weight"     
       [7] "bert.encoder.layer.0.attention.self.in_proj_bias"       
       [8] "bert.encoder.layer.0.attention.self.out_proj.weight"    
       [9] "bert.encoder.layer.0.attention.self.out_proj.bias"      
      [10] "bert.encoder.layer.0.attention.output.layer_norm.weight"
      [11] "bert.encoder.layer.0.attention.output.layer_norm.bias"  
      [12] "bert.encoder.layer.0.intermediate.dense.weight"         
      [13] "bert.encoder.layer.0.intermediate.dense.bias"           
      [14] "bert.encoder.layer.0.output.dense.weight"               
      [15] "bert.encoder.layer.0.output.dense.bias"                 
      [16] "bert.encoder.layer.0.output.layer_norm.weight"          
      [17] "bert.encoder.layer.0.output.layer_norm.bias"            
      [18] "bert.encoder.layer.1.attention.self.in_proj_weight"     
      [19] "bert.encoder.layer.1.attention.self.in_proj_bias"       
      [20] "bert.encoder.layer.1.attention.self.out_proj.weight"    
      [21] "bert.encoder.layer.1.attention.self.out_proj.bias"      
      [22] "bert.encoder.layer.1.attention.output.layer_norm.weight"
      [23] "bert.encoder.layer.1.attention.output.layer_norm.bias"  
      [24] "bert.encoder.layer.1.intermediate.dense.weight"         
      [25] "bert.encoder.layer.1.intermediate.dense.bias"           
      [26] "bert.encoder.layer.1.output.dense.weight"               
      [27] "bert.encoder.layer.1.output.dense.bias"                 
      [28] "bert.encoder.layer.1.output.layer_norm.weight"          
      [29] "bert.encoder.layer.1.output.layer_norm.bias"            
      [30] "linear.weight"                                          
      [31] "linear.bias"                                            

---

    Code
      test_result
    Output
      An `nn_module` containing 28,502,531 parameters.
      
      -- Modules ---------------------------------------------------------------------
      * bert: <BERT> #28,500,992 parameters
      * linear: <nn_linear> #1,539 parameters

---

    Code
      names(test_dict)
    Output
       [1] "bert.embeddings.word_embeddings.weight"                 
       [2] "bert.embeddings.token_type_embeddings.weight"           
       [3] "bert.embeddings.position_embeddings.weight"             
       [4] "bert.embeddings.layer_norm.weight"                      
       [5] "bert.embeddings.layer_norm.bias"                        
       [6] "bert.encoder.layer.0.attention.self.in_proj_weight"     
       [7] "bert.encoder.layer.0.attention.self.in_proj_bias"       
       [8] "bert.encoder.layer.0.attention.self.out_proj.weight"    
       [9] "bert.encoder.layer.0.attention.self.out_proj.bias"      
      [10] "bert.encoder.layer.0.attention.output.layer_norm.weight"
      [11] "bert.encoder.layer.0.attention.output.layer_norm.bias"  
      [12] "bert.encoder.layer.0.intermediate.dense.weight"         
      [13] "bert.encoder.layer.0.intermediate.dense.bias"           
      [14] "bert.encoder.layer.0.output.dense.weight"               
      [15] "bert.encoder.layer.0.output.dense.bias"                 
      [16] "bert.encoder.layer.0.output.layer_norm.weight"          
      [17] "bert.encoder.layer.0.output.layer_norm.bias"            
      [18] "bert.encoder.layer.1.attention.self.in_proj_weight"     
      [19] "bert.encoder.layer.1.attention.self.in_proj_bias"       
      [20] "bert.encoder.layer.1.attention.self.out_proj.weight"    
      [21] "bert.encoder.layer.1.attention.self.out_proj.bias"      
      [22] "bert.encoder.layer.1.attention.output.layer_norm.weight"
      [23] "bert.encoder.layer.1.attention.output.layer_norm.bias"  
      [24] "bert.encoder.layer.1.intermediate.dense.weight"         
      [25] "bert.encoder.layer.1.intermediate.dense.bias"           
      [26] "bert.encoder.layer.1.output.dense.weight"               
      [27] "bert.encoder.layer.1.output.dense.bias"                 
      [28] "bert.encoder.layer.1.output.layer_norm.weight"          
      [29] "bert.encoder.layer.1.output.layer_norm.bias"            
      [30] "bert.encoder.layer.2.attention.self.in_proj_weight"     
      [31] "bert.encoder.layer.2.attention.self.in_proj_bias"       
      [32] "bert.encoder.layer.2.attention.self.out_proj.weight"    
      [33] "bert.encoder.layer.2.attention.self.out_proj.bias"      
      [34] "bert.encoder.layer.2.attention.output.layer_norm.weight"
      [35] "bert.encoder.layer.2.attention.output.layer_norm.bias"  
      [36] "bert.encoder.layer.2.intermediate.dense.weight"         
      [37] "bert.encoder.layer.2.intermediate.dense.bias"           
      [38] "bert.encoder.layer.2.output.dense.weight"               
      [39] "bert.encoder.layer.2.output.dense.bias"                 
      [40] "bert.encoder.layer.2.output.layer_norm.weight"          
      [41] "bert.encoder.layer.2.output.layer_norm.bias"            
      [42] "bert.encoder.layer.3.attention.self.in_proj_weight"     
      [43] "bert.encoder.layer.3.attention.self.in_proj_bias"       
      [44] "bert.encoder.layer.3.attention.self.out_proj.weight"    
      [45] "bert.encoder.layer.3.attention.self.out_proj.bias"      
      [46] "bert.encoder.layer.3.attention.output.layer_norm.weight"
      [47] "bert.encoder.layer.3.attention.output.layer_norm.bias"  
      [48] "bert.encoder.layer.3.intermediate.dense.weight"         
      [49] "bert.encoder.layer.3.intermediate.dense.bias"           
      [50] "bert.encoder.layer.3.output.dense.weight"               
      [51] "bert.encoder.layer.3.output.dense.bias"                 
      [52] "bert.encoder.layer.3.output.layer_norm.weight"          
      [53] "bert.encoder.layer.3.output.layer_norm.bias"            
      [54] "linear.weight"                                          
      [55] "linear.bias"                                            

