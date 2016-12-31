import i2r_rnnlm as rnnlm

def generate(lmname):
	model = rnnlm.Model("rnnlm-%s/model-big-stageF" % lmname)
	return lambda ilist: model.test_epoch("<s> " + ilist.chars + " </s>" * ilist.end)
