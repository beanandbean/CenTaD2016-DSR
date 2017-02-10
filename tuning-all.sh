set -e -x -o pipefail

for tune in MIRA MERT Alt; do
	for file in tuning/result-*.modules; do
		if [[ ! $file =~ rnn ]]; then
		modules=`echo $file | sed "s:^tuning/result-::g; s:.modules$::g"`
		./tuning.sh $modules all $tune
		for direction in bidir l2r r2l; do
		./check-result.sh $modules $direction $tune
		done
		fi
	done
done
