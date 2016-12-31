#!/usr/bin/python

import sys

BEGIN = "<-BEGIN->"
END = "<-END->"

f1 = open(sys.argv[1])
f2 = open(sys.argv[2])

bigrams = {}
for l1 in f1:
	w1 = [BEGIN] + l1.split() + [END]
	l2 = f2.readline()
	w2 = [BEGIN] + l2.split() + [END]
	for i in xrange(len(w1) - 1):
		pair = w1[i] + " " + w2[i + 1]
		if pair in bigrams:
			bigrams[pair] += 1
		else:
			bigrams[pair] = 1
for pair in sorted(bigrams):
	print pair + "\t" + str(bigrams[pair])
