set -e -x -o pipefail

cat data-raw/qns.txt | sed "s:\:.\+$::g" | ./decoder.sh $1 $2 $3 > results/result-$1-$2-$3.txt
tail -n 533 results/result-$1-$2-$3.txt > results/result-$1-$2-$3-test.txt

eval.char.sh results/ref.txt results/ref.txt results/result-$1-$2-$3.txt 2>&1 > results/result-$1-$2-$3.score
eval.char.sh results/ref-test.txt results/ref-test.txt results/result-$1-$2-$3-test.txt 2>&1 > results/result-$1-$2-$3-test.score
rm results/result-$1-$2-$3.txt.*
rm results/result-$1-$2-$3-test.txt.*
rm meteor-*
