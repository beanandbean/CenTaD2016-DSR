import modules.base_rnnlm as lm

weight = 1.0
weight_min = -10
weight_max = 100
score = lm.generate("char-nopunc")
