function INIT {
rm -rf data
mkdir data
INDOMAIN-SELECT
}

function INDOMAIN-SELECT {
set +x
cat data-raw/EssayData/www.zuowen.com/* > data/essay-raw.txt
set -x
cat data/essay-raw.txt |
./filter-raw.sh INIT essay > data/essay-filtered.txt
cat data/essay-filtered.txt |
awk '{if (NF >= 5) print $0}' > data/essay-selected.txt
OUTDOMAIN-SELECT
}

function OUTDOMAIN-SELECT {
shopt -s nullglob
for RESOURCE in data-outdomain-raw/*-sent.zh; do
./process-outdomain.sh INIT `basename ${RESOURCE%-sent.zh}`
done
DOMAIN-SPLIT
}

function DOMAIN-SPLIT {
cat data/{essay,sms-100k,pc-short15}-selected.txt \
	> data/data-indomain-raw.txt
cat data/{i2r-chat-2M,i2r-news-8M,openmt-300k,openmt-7M}-selected.txt \
	> data/data-outdomain-raw.txt
cat data-outdomain-raw/*-lex.zh | sort | uniq > data/data-lex.txt
select-parallel-by-Lucene.sh data/data-indomain-raw.txt NULL \
	data/data-outdomain-raw.txt data/data-outdomain-raw.txt \
	data/data-outdomain-sorted.txt /dev/null
DOMAIN-SELECT
}

function DOMAIN-SELECT {
LINE=`expr 1000000 - \`wc -l data/data-indomain-raw.txt \
	| cut -d" " -f1\``
cat data/data-indomain-raw.txt > data/data-indomain.txt
head -$LINE data/data-outdomain-sorted.txt >> data/data-indomain.txt
tail -n +$LINE data/data-outdomain-sorted.txt > data/data-outdomain.txt
WORD-LM
}

function WORD-LM {
for LMNAME in indomain outdomain; do
train_languagemodel_kenlm_unk.sh data/data-$LMNAME.txt data/$LMNAME-word.LM
done
CHAR-LM
}

function CHAR-LM {
for LMNAME in indomain outdomain lex; do
cat data/data-$LMNAME.txt | splitUTF8Characters.pl > data/data-$LMNAME-char.txt
train_languagemodel_kenlm_unk.sh data/data-$LMNAME-char.txt data/$LMNAME-char.LM
done
POS-LM
}

function POS-LM {
cat data/data-indomain.txt | ./postag.sh > data/data-indomain-pos.txt
train_languagemodel_kenlm_unk.sh data/data-indomain-pos.txt data/indomain-pos.LM
BIGRAM-COUNT
}

function BACKWARD-LM {
for LMNAME in indomain outdomain; do
train_languagemodel_kenlm_backward_unk.sh data/data-indomain.txt data/$LMNAME-word-backward.LM
done
BIGRAM-COUNT
}

function BIGRAM-COUNT {
./bigram-gen.py data/data-indomain-pos.txt data/data-indomain.txt > data/bigram-indomain-pos-word.txt
./bigram-gen.py data/data-indomain.txt data/data-indomain-pos.txt > data/bigram-indomain-word-pos.txt
./bigram-gen.py data/data-indomain.txt data/data-indomain.txt > data/bigram-indomain-word-word.txt
}

if [ $1 ]; then
set -e -x -o pipefail
$1
else
echo "Available anchors:
INIT INDOMAIN-SELECT OUTDOMAIN-SELECT
DOMAIN-SPLIT DOMAIN-SELECT
WORD-LM CHAR-LM POS-LM
BACKWARD-LM BIGRAM-COUNT"
fi
