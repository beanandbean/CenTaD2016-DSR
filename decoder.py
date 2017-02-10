#!/usr/bin/python

import argparse, imp
import os, sys
import subprocess

parser = argparse.ArgumentParser(description = "Disarranged Sentence Reconstruction")

parser.add_argument("mode", metavar = "mode", choices = ("run", "tune", "gen-weights"),
                    help = "running mode for the program (run/tune/gen-weights)")
parser.add_argument("-w", "--weights", metavar = "weights", type = file,
                    help = "weights for different features")
parser.add_argument("-f", "--feature", metavar = "feature", dest = "features", action = "append", required = "true",
                    help = "feature as pythons module for calculating scores")
parser.add_argument("-d", "--direction", metavar = "direction", choices = ("l2r", "r2l", "bidir"), default = "l2r",
										help = "direction of constructing the hypothesis")
                    
args = parser.parse_args()

class Processer(object):
	def __init__(self, args):
		self.p = subprocess.Popen(["stdbuf -o L " + args + " 2> /dev/null"], shell = True, stdin = subprocess.PIPE, stdout = subprocess.PIPE)

	def process(self, data):
		self.p.stdin.write(data + "\n")
		self.p.stdin.flush()
		return self.p.stdout.readline()[:-1]
        
segmenter = Processer("segmenter.zh-elus.sh")
spliter = Processer("splitUTF8Characters.pl")
postagger = Processer("./postag.sh")

class Item(object):
	def __init__(self, string):
		self.string = string
		self.words = segmenter.process(string)
		self.wordlist = self.words.split()
		self.chars = spliter.process(string)

BEGIN_ITEM = "<s>"
END_ITEM = "</s>"

class ItemList(object):
	def __init__(self, string = "", words = "", wordlist = [], chars = "", begin = False, end = False):
		self.string = string
		self.words = words
		self.wordlist = wordlist
		self.chars = chars
		self.begin = begin
		self.end = end
		self.pos = None
		self.poslist = None
		
	def __add__(self, item):
		if item == END_ITEM:
			return ItemList(self.string, self.words, self.wordlist, self.chars, self.begin, True);
		elif self.string:
			return ItemList(self.string + item.string, self.words + " " + item.words, self.wordlist + item.wordlist, self.chars + " " + item.chars, self.begin, self.end)
		else:
			return ItemList(item.string, item.words, item.wordlist, item.chars, self.begin, self.end)
		
	def __radd__(self, item):
		if item == BEGIN_ITEM:
			return ItemList(self.string, self.words, self.wordlist, self.chars, True, self.end)
		elif self.string:
			return ItemList(item.string + self.string, item.words + " " + self.words, item.wordlist + self.wordlist, item.chars + " " + self.chars, self.begin, self.end)
		else:
			return ItemList(item.string, item.words, item.wordlist, item.chars, self.begin, self.end)
			
	def getfullstring(self):
		string = self.string
		if self.begin:
			string = BEGIN_ITEM + string
		if self.end:
			string = string + END_ITEM
		return string
		
	def getpos(self):
		if self.pos == None:
			self.pos = postagger.process(self.words)
		return self.pos

	def getposlist(self):
		if self.poslist == None:
			self.poslist = self.getpos().split()
		return self.poslist

features = []
for f in args.features:
    features.append(imp.load_source(os.path.splitext(os.path.basename(f))[0], f))
if args.weights:
    data = args.weights.read().split()
    args.weights.close()
    for i in xrange(len(features)):
        features[i].weight = float(data[i])

def calc_score(ilist):
    score = 0
    for f in features:
        score += f.weight * f.score(ilist)
    return score

if args.mode == "gen-weights":
	def print_row(get):
		arr = []
		for f in features:
			arr.append(get(f))
		print " ".join([str(i) for i in arr])
	print_row(lambda f: f.weight)
	print_row(lambda f: f.weight_min) 
	print_row(lambda f: f.weight_max)
	exit()
else:
	nbest = (args.mode == "tune")
	while True:
		inp = sys.stdin.readline()
		if inp == "":
			break
		items = [Item(s) for s in inp.split()]
		initial = ItemList()
		if args.direction == "l2r":
			initial.begin = True
		elif args.direction == "r2l":
			initial.end = True
		elif args.direction == "bidir":
			items.extend([BEGIN_ITEM, END_ITEM])
		seqs = [(initial, items, 0)]
		for i in xrange(len(items)):
			newstrs = []
			if args.direction == "bidir":
				newstrset = set()
			end = (i == len(items) - 1)
			for origin, left, score in seqs:
				for index in xrange(len(left)):
					item = left[index]
					newleft = left[:index] + left[index + 1:]
					if args.direction == "l2r":
						newseq = origin + item
						newseq.end = end
						newstrs.append((newseq, newleft))
					elif args.direction == "r2l":
						newseq = item + origin
						newseq.begin = end
						newstrs.append((newseq, newleft))
					elif args.direction == "bidir":
						if item != END_ITEM and not origin.begin:
							newseq = item + origin
							if end or not (origin.begin and origin.end):
								fullstring = newseq.getfullstring()
								if not fullstring in newstrset:
									newstrset.add(fullstring)
									newstrs.append((newseq, newleft))
						if item != BEGIN_ITEM and not origin.end:
							newseq = origin + item
							if end or not (origin.begin and origin.end):
								fullstring = newseq.getfullstring()
								if not fullstring in newstrset:
									newstrset.add(fullstring)
									newstrs.append((newseq, newleft))
			newlist = zip(*newstrs)[0]
			scores = [sum(s) for s in zip(*[[f.weight * i for i in f.score(newlist)] for f in features])]
			newseqs = [(newstrs[i][0], newstrs[i][1], scores[i]) for i in xrange(len(newstrs))]
			seqs = sorted(newseqs, key = lambda t: t[2], reverse = True)[:100]
		if nbest:
			ilists = zip(*seqs)[0]
			scores = zip(*[f.score(ilists) for f in features])
			for i in xrange(len(seqs)):
				items, left, score = seqs[i]
				print items.words, "|||",
				for fs in scores[i]:
					print fs,
				print "|||", score
			print 
		else:
			items = seqs[0][0]
			print items.string
		sys.stdout.flush()
