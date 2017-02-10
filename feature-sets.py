#!/usr/bin/python

import os

domains = {
	"in": ["indomain"],
	"no-lex": ["indomain", "outdomain"],
	"all": ["indomain", "outdomain", "lex"]
}

models = {
	"word": ["word_lm"],
	"bidir-word": ["word_lm", "word_backward_lm"],
	"n-gram-no-pos": ["word_lm", "char_lm", "word_backward_lm"],
	"n-gram-no-backward": ["word_lm", "char_lm", "pos_lm"],
	"n-gram": ["word_lm", "char_lm", "pos_lm", "word_backward_lm"],
	"no-bigram-pos": ["word_lm", "char_lm", "pos_lm", "word_backward_lm", "word_word_bigram"],
	"no-pos": ["word_lm", "char_lm", "word_backward_lm", "word_word_bigram"],
	"no-backward": ["word_lm", "char_lm", "pos_lm", "word_word_bigram", "word_pos_bigram", "pos_word_bigram"],
	"all": ["word_lm", "char_lm", "pos_lm", "word_backward_lm", "word_word_bigram", "word_pos_bigram", "pos_word_bigram"]
}

available = {
	"in": ["word", "bidir-word", "n-gram-no-pos", "n-gram-no-backward", "n-gram", "bigram-no-pos", "no-pos", "no-backward",  "all"],
	"no-lex": ["word", "bidir-word", "n-gram-no-pos", "n-gram-no-backward", "n-gram", "no-backward", "all"],
	"all": ["n-gram-no-pos", "n-gram-no-backward", "n-gram", "no-backward", "all"]
}

def write(name, modules):
	f = open("tuning/result-%s.modules" % name, "w")
	f.write("\n".join(modules))
	f.close()

for (dom, mods) in available.iteritems():
	for mod in mods:
		sel = []
		for d in domains[dom]:
			for m in models[mod]:
				if os.path.exists("modules/%s_%s.py" % (d, m)):
					sel.append(d + "_" + m)
		name = dom + "-" + mod
		write(name, sel)
		if dom == "all" and mod == "all":
			write(name + "-rnn", sel + ["char_rnnlm", "char_nopunc_rnnlm"])
