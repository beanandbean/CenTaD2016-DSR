import kenlm

def generate(lmname):
	model = kenlm.LanguageModel("data/%s-word-backward.LM.bw5gram.srilm.trie" % lmname)
	return lambda ilist: model.score(" ".join(reversed(ilist.wordlist)), bos = ilist.end, eos = ilist.begin)
