import kenlm

def generate(lmname):
	model = kenlm.LanguageModel("data/%s-word.LM.5gram.srilm.trie" % lmname)
	return lambda ilist: model.score(ilist.words, bos = ilist.begin, eos = ilist.end)
