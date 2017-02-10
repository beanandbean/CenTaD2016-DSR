if [ $4 ]; then
	fw2hw-all.sh | multi-thread.py $4 "./decoder.py run `./fargs.sh $1` -w tuning/result-$1-all-$3.opt -d $2"
else
	fw2hw-all.sh | ./decoder.py run `./fargs.sh $1` -w tuning/result-$1-all-$3.opt -d $2
fi
