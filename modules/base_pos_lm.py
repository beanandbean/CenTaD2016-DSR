import kenlm
from modules import postagger

def generate(lmname):
	model = kenlm.LanguageModel("data/%s-pos.LM.5gram.srilm.trie" % lmname)
	return lambda ilist: model.score(ilist.getpos(), bos = ilist.begin, eos = ilist.end)
