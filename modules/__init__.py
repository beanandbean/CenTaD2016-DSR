import subprocess

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
