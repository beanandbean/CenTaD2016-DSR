import math

BEGIN = "<-BEGIN->"
END = "<-END->"

def generate(name, seqs):
	f = open("data/bigram-%s.txt" % name)
	data = f.readlines()
	f.close()
	data = [l.strip().split("\t") for l in data]
	data = {d[0]: int(d[1]) for d in data}
	def score(ilist):
		ss = seqs(ilist)
		s1 = [BEGIN] * ilist.begin + ss[0] + [END] * ilist.end
		s2 = [BEGIN] * ilist.begin + ss[1] + [END] * ilist.end
		total = 0
		for i in xrange(len(s1) - 1):
			token = s1[i] + " " + s2[i + 1]
			if token in data:
				total += math.log(data[token], 10) * 2 + 1
		return total
	return score
