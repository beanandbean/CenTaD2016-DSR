set -e -x -o pipefail

echo " BLEU    NIST       TER        METEROR   |  BLEU    NIST       TER        METEROR   | NAME" > results/.collected.txt
#     0.0000 00.0000 0.0000000000 0.0000000000 | 0.0000 00.0000 0.0000000000 0.0000000000 | name

files=`ls results/result-*.score | sed "/-test.score/d"`
for file in $files; do
	name=`echo $file | sed "s:^results/result-::g; s:.score$::g"`
	full=`tail -n 4 $file | awk '{print $2}' | tr "\n" " " | awk '{printf("%.4f %.4f %.10f %.10f"), $1, $2, $3, $4}'`
	test=`tail -n 4 results/result-$name-test.score | awk '{print $2}' | tr "\n" " " | awk '{printf("%.4f %.4f %.10f %.10f"), $1, $2, $3, $4}'`
	echo $test "|" $full "|" $name >> results/.collected.txt
done

sort -r results/.collected.txt > results/collected.txt
rm results/.collected.txt
