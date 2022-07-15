# bert output tidiers work

    Code
      names(tidy_out$embeddings)
    Output
        [1] "sequence_index" "layer_index"    "token_index"    "segment_index" 
        [5] "token"          "token_id"       "V1"             "V2"            
        [9] "V3"             "V4"             "V5"             "V6"            
       [13] "V7"             "V8"             "V9"             "V10"           
       [17] "V11"            "V12"            "V13"            "V14"           
       [21] "V15"            "V16"            "V17"            "V18"           
       [25] "V19"            "V20"            "V21"            "V22"           
       [29] "V23"            "V24"            "V25"            "V26"           
       [33] "V27"            "V28"            "V29"            "V30"           
       [37] "V31"            "V32"            "V33"            "V34"           
       [41] "V35"            "V36"            "V37"            "V38"           
       [45] "V39"            "V40"            "V41"            "V42"           
       [49] "V43"            "V44"            "V45"            "V46"           
       [53] "V47"            "V48"            "V49"            "V50"           
       [57] "V51"            "V52"            "V53"            "V54"           
       [61] "V55"            "V56"            "V57"            "V58"           
       [65] "V59"            "V60"            "V61"            "V62"           
       [69] "V63"            "V64"            "V65"            "V66"           
       [73] "V67"            "V68"            "V69"            "V70"           
       [77] "V71"            "V72"            "V73"            "V74"           
       [81] "V75"            "V76"            "V77"            "V78"           
       [85] "V79"            "V80"            "V81"            "V82"           
       [89] "V83"            "V84"            "V85"            "V86"           
       [93] "V87"            "V88"            "V89"            "V90"           
       [97] "V91"            "V92"            "V93"            "V94"           
      [101] "V95"            "V96"            "V97"            "V98"           
      [105] "V99"            "V100"           "V101"           "V102"          
      [109] "V103"           "V104"           "V105"           "V106"          
      [113] "V107"           "V108"           "V109"           "V110"          
      [117] "V111"           "V112"           "V113"           "V114"          
      [121] "V115"           "V116"           "V117"           "V118"          
      [125] "V119"           "V120"           "V121"           "V122"          
      [129] "V123"           "V124"           "V125"           "V126"          
      [133] "V127"           "V128"          

---

    Code
      head(tidy_out$embeddings$V1)
    Output
      [1]  0.7973319 -0.8413255 -1.8721251 -1.1527218  0.7180122 -1.4168051

---

    Code
      names(tidy_out$attention)
    Output
       [1] "sequence_index"          "layer_index"            
       [3] "head_index"              "token_index"            
       [5] "segment_index"           "token"                  
       [7] "token_id"                "attention_token_index"  
       [9] "attention_segment_index" "attention_token"        
      [11] "attention_token_id"      "attention_weight"       

---

    Code
      head(tidy_out$attention$attention_weight)
    Output
      [1] 0.129293516 0.040168900 0.091523618 0.017589871 0.018716220 0.009866948

