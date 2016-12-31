set -e -x -o pipefail

for direction in bidir l2r r2l; do
	for tune in MIRA MERT HALF; do
	for file in tuning/result-*.modules; do
		modules=`echo $file | sed "s:^tuning/result-::g; s:.modules$::g"`
		./tuning.sh $modules $direction $tune
		./check-result.sh $modules $direction $tune
	done
	done
done
