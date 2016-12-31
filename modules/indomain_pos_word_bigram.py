import modules.base_bigram as bigram

weight = 1
weight_min = -10
weight_max = 100

score = bigram.generate("indomain-pos-word", lambda ilist: (ilist.getposlist(), ilist.wordlist))
