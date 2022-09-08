# model_bert_linear produced the expected model

    Code
      test_result
    Output
      An `nn_module` containing 4,369,538 parameters.
      
      -- Modules ---------------------------------------------------------------------
      * bert: <BERT> #4,369,408 parameters
      * linear: <nn_linear> #129 parameters
      
      -- Parameters ------------------------------------------------------------------
      * .check: Float [1:1]

---

    Code
      names(test_dict)
    Output
       [1] ".check"                                                 
       [2] "bert.embeddings.word_embeddings.weight"                 
       [3] "bert.embeddings.token_type_embeddings.weight"           
       [4] "bert.embeddings.position_embeddings.weight"             
       [5] "bert.embeddings.layer_norm.weight"                      
       [6] "bert.embeddings.layer_norm.bias"                        
       [7] "bert.encoder.layer.0.attention.self.in_proj_weight"     
       [8] "bert.encoder.layer.0.attention.self.in_proj_bias"       
       [9] "bert.encoder.layer.0.attention.self.out_proj.weight"    
      [10] "bert.encoder.layer.0.attention.self.out_proj.bias"      
      [11] "bert.encoder.layer.0.attention.output.layer_norm.weight"
      [12] "bert.encoder.layer.0.attention.output.layer_norm.bias"  
      [13] "bert.encoder.layer.0.intermediate.dense.weight"         
      [14] "bert.encoder.layer.0.intermediate.dense.bias"           
      [15] "bert.encoder.layer.0.output.dense.weight"               
      [16] "bert.encoder.layer.0.output.dense.bias"                 
      [17] "bert.encoder.layer.0.output.layer_norm.weight"          
      [18] "bert.encoder.layer.0.output.layer_norm.bias"            
      [19] "bert.encoder.layer.1.attention.self.in_proj_weight"     
      [20] "bert.encoder.layer.1.attention.self.in_proj_bias"       
      [21] "bert.encoder.layer.1.attention.self.out_proj.weight"    
      [22] "bert.encoder.layer.1.attention.self.out_proj.bias"      
      [23] "bert.encoder.layer.1.attention.output.layer_norm.weight"
      [24] "bert.encoder.layer.1.attention.output.layer_norm.bias"  
      [25] "bert.encoder.layer.1.intermediate.dense.weight"         
      [26] "bert.encoder.layer.1.intermediate.dense.bias"           
      [27] "bert.encoder.layer.1.output.dense.weight"               
      [28] "bert.encoder.layer.1.output.dense.bias"                 
      [29] "bert.encoder.layer.1.output.layer_norm.weight"          
      [30] "bert.encoder.layer.1.output.layer_norm.bias"            
      [31] "linear.weight"                                          
      [32] "linear.bias"                                            

---

    Code
      test_result
    Output
      An `nn_module` containing 4,369,925 parameters.
      
      -- Modules ---------------------------------------------------------------------
      * bert: <BERT> #4,369,408 parameters
      * linear: <nn_linear> #516 parameters
      
      -- Parameters ------------------------------------------------------------------
      * .check: Float [1:1]

---

    Code
      names(test_dict)
    Output
       [1] ".check"                                                 
       [2] "bert.embeddings.word_embeddings.weight"                 
       [3] "bert.embeddings.token_type_embeddings.weight"           
       [4] "bert.embeddings.position_embeddings.weight"             
       [5] "bert.embeddings.layer_norm.weight"                      
       [6] "bert.embeddings.layer_norm.bias"                        
       [7] "bert.encoder.layer.0.attention.self.in_proj_weight"     
       [8] "bert.encoder.layer.0.attention.self.in_proj_bias"       
       [9] "bert.encoder.layer.0.attention.self.out_proj.weight"    
      [10] "bert.encoder.layer.0.attention.self.out_proj.bias"      
      [11] "bert.encoder.layer.0.attention.output.layer_norm.weight"
      [12] "bert.encoder.layer.0.attention.output.layer_norm.bias"  
      [13] "bert.encoder.layer.0.intermediate.dense.weight"         
      [14] "bert.encoder.layer.0.intermediate.dense.bias"           
      [15] "bert.encoder.layer.0.output.dense.weight"               
      [16] "bert.encoder.layer.0.output.dense.bias"                 
      [17] "bert.encoder.layer.0.output.layer_norm.weight"          
      [18] "bert.encoder.layer.0.output.layer_norm.bias"            
      [19] "bert.encoder.layer.1.attention.self.in_proj_weight"     
      [20] "bert.encoder.layer.1.attention.self.in_proj_bias"       
      [21] "bert.encoder.layer.1.attention.self.out_proj.weight"    
      [22] "bert.encoder.layer.1.attention.self.out_proj.bias"      
      [23] "bert.encoder.layer.1.attention.output.layer_norm.weight"
      [24] "bert.encoder.layer.1.attention.output.layer_norm.bias"  
      [25] "bert.encoder.layer.1.intermediate.dense.weight"         
      [26] "bert.encoder.layer.1.intermediate.dense.bias"           
      [27] "bert.encoder.layer.1.output.dense.weight"               
      [28] "bert.encoder.layer.1.output.dense.bias"                 
      [29] "bert.encoder.layer.1.output.layer_norm.weight"          
      [30] "bert.encoder.layer.1.output.layer_norm.bias"            
      [31] "linear.weight"                                          
      [32] "linear.bias"                                            

---

    Code
      test_result
    Output
      An `nn_module` containing 28,502,532 parameters.
      
      -- Modules ---------------------------------------------------------------------
      * bert: <BERT> #28,500,992 parameters
      * linear: <nn_linear> #1,539 parameters
      
      -- Parameters ------------------------------------------------------------------
      * .check: Float [1:1]

---

    Code
      names(test_dict)
    Output
       [1] ".check"                                                 
       [2] "bert.embeddings.word_embeddings.weight"                 
       [3] "bert.embeddings.token_type_embeddings.weight"           
       [4] "bert.embeddings.position_embeddings.weight"             
       [5] "bert.embeddings.layer_norm.weight"                      
       [6] "bert.embeddings.layer_norm.bias"                        
       [7] "bert.encoder.layer.0.attention.self.in_proj_weight"     
       [8] "bert.encoder.layer.0.attention.self.in_proj_bias"       
       [9] "bert.encoder.layer.0.attention.self.out_proj.weight"    
      [10] "bert.encoder.layer.0.attention.self.out_proj.bias"      
      [11] "bert.encoder.layer.0.attention.output.layer_norm.weight"
      [12] "bert.encoder.layer.0.attention.output.layer_norm.bias"  
      [13] "bert.encoder.layer.0.intermediate.dense.weight"         
      [14] "bert.encoder.layer.0.intermediate.dense.bias"           
      [15] "bert.encoder.layer.0.output.dense.weight"               
      [16] "bert.encoder.layer.0.output.dense.bias"                 
      [17] "bert.encoder.layer.0.output.layer_norm.weight"          
      [18] "bert.encoder.layer.0.output.layer_norm.bias"            
      [19] "bert.encoder.layer.1.attention.self.in_proj_weight"     
      [20] "bert.encoder.layer.1.attention.self.in_proj_bias"       
      [21] "bert.encoder.layer.1.attention.self.out_proj.weight"    
      [22] "bert.encoder.layer.1.attention.self.out_proj.bias"      
      [23] "bert.encoder.layer.1.attention.output.layer_norm.weight"
      [24] "bert.encoder.layer.1.attention.output.layer_norm.bias"  
      [25] "bert.encoder.layer.1.intermediate.dense.weight"         
      [26] "bert.encoder.layer.1.intermediate.dense.bias"           
      [27] "bert.encoder.layer.1.output.dense.weight"               
      [28] "bert.encoder.layer.1.output.dense.bias"                 
      [29] "bert.encoder.layer.1.output.layer_norm.weight"          
      [30] "bert.encoder.layer.1.output.layer_norm.bias"            
      [31] "bert.encoder.layer.2.attention.self.in_proj_weight"     
      [32] "bert.encoder.layer.2.attention.self.in_proj_bias"       
      [33] "bert.encoder.layer.2.attention.self.out_proj.weight"    
      [34] "bert.encoder.layer.2.attention.self.out_proj.bias"      
      [35] "bert.encoder.layer.2.attention.output.layer_norm.weight"
      [36] "bert.encoder.layer.2.attention.output.layer_norm.bias"  
      [37] "bert.encoder.layer.2.intermediate.dense.weight"         
      [38] "bert.encoder.layer.2.intermediate.dense.bias"           
      [39] "bert.encoder.layer.2.output.dense.weight"               
      [40] "bert.encoder.layer.2.output.dense.bias"                 
      [41] "bert.encoder.layer.2.output.layer_norm.weight"          
      [42] "bert.encoder.layer.2.output.layer_norm.bias"            
      [43] "bert.encoder.layer.3.attention.self.in_proj_weight"     
      [44] "bert.encoder.layer.3.attention.self.in_proj_bias"       
      [45] "bert.encoder.layer.3.attention.self.out_proj.weight"    
      [46] "bert.encoder.layer.3.attention.self.out_proj.bias"      
      [47] "bert.encoder.layer.3.attention.output.layer_norm.weight"
      [48] "bert.encoder.layer.3.attention.output.layer_norm.bias"  
      [49] "bert.encoder.layer.3.intermediate.dense.weight"         
      [50] "bert.encoder.layer.3.intermediate.dense.bias"           
      [51] "bert.encoder.layer.3.output.dense.weight"               
      [52] "bert.encoder.layer.3.output.dense.bias"                 
      [53] "bert.encoder.layer.3.output.layer_norm.weight"          
      [54] "bert.encoder.layer.3.output.layer_norm.bias"            
      [55] "linear.weight"                                          
      [56] "linear.bias"                                            

