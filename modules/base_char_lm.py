import kenlm

def generate(lmname):
	model = kenlm.LanguageModel("data/%s-char.LM.5gram.srilm.trie" % lmname)
	return lambda ilist: model.score(ilist.chars, bos = ilist.begin, eos = ilist.end)
