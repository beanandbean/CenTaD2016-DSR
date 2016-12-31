set -e -x -o pipefail

directory=tuning/run-$1-$2-$3
if [ -d $directory ]; then
	rm -rf $directory
fi
mkdir $directory

fargs="`./fargs.sh $1`"
thread_c=12

head -1500 data-raw/qns.txt > $directory/init.data.txt
cat $directory/init.data.txt | sed "s:\:.\+$::g" |
	fw2hw-all.sh > $directory/init.input.txt
cat $directory/init.data.txt | sed "s:^.\+\:::g" |
	segmenter.zh-elus.sh > $directory/init.ref.txt
./decoder.py gen-weights $fargs > $directory/init.opt

cp $directory/init.opt $directory/run1.init.opt

dim=`sed -n 1p $directory/init.opt | awk '{print NF}'`
iter=50

function MERT {
		norm=`head -1 $PREFIX.init.opt | LP-norm.py`
		mert -d $dim --ifile $PREFIX.init.opt --ffile $FEATURES --scfile $SCORES 2>&1 |
			tee $PREFIX.mert.out
		cat $PREFIX.mert.out | grep "Best point:" | cut.py 3--2 |
			normalize-weights.py $norm > $directory/run$[N+1].init.opt
}

function MIRA {
		kbmira -J 60 --dense-init $PREFIX.init.opt --ffile $FEATURES --scfile $SCORES \
			-o $PREFIX.mira.out
		cat $PREFIX.mira.out | awk '{printf $2" "}END{print ""}' > $directory/run$[N+1].init.opt
}

for N in `seq -s' ' 1 $iter`; do
	PREFIX=$directory/run$N
	cat $directory/init.input.txt | multi-thread.1-line-to-1-linegroup.py "$thread_c" "./decoder.py tune $fargs -w $PREFIX.init.opt -d $2" |
		awk 'BEGIN{i = 0}{if($0=="")i+=1; else print i" ||| "$0}' | gzip > $PREFIX.nbest.gz
	extractor --scconfig "case:true" --scfile $PREFIX.scores.dat --ffile $PREFIX.features.dat \
		-r $directory/init.ref.txt -n $PREFIX.nbest.gz
	FEATURES=`echo $directory/run*.features.dat | sed "s: : --ffile :g"`
	SCORES=`echo $directory/run*.scores.dat | sed "s: : --scfile : g"`
	ACTION=$3
	if [ $3 = 'HALF' ]; then
	if [ $[N%2] != 1 ] || [ $N -ge 30 ]; then
		ACTION='MERT'
	else
		ACTION='MIRA'
	fi
	fi
	$ACTION
	tail -2 $directory/init.opt >> $directory/run$[N+1].init.opt
	if [ -s $directory/run$[N-1].init.opt ] && [ ! "`diff $directory/run$[N-1].init.opt $directory/run$[N+1].init.opt`" ]
	then
		echo "Weights converged after Iteration $N"
		cp $PREFIX.init.opt tuning/result-$1-$2-$3.opt
		break
	fi
	if [ $N -eq $iter ]; then
		echo "Weights failed to converge. Use weights after Iteration $N"
		cp $directory/run$[N+1].init.opt tuning/result-$1-$2-$3.opt
	fi
done
