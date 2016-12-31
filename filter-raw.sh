function INIT {
cat > data/$DATATAG-raw.0.txt
NORMALIZE
}

function NORMALIZE {
cat data/$DATATAG-raw.0.txt | xml2txt.sh | fw2hw-all.sh | lowercase.perl |
sed "s:\xC2\xA0: :g" | desegmenter.zh.sh > data/$DATATAG-raw.1.txt
PUNCTUATE
}

function PUNCTUATE {
cat data/$DATATAG-raw.1.txt |
sed "s:[\.\?\!;]['\"]\?:\0\n:g" | trim.sh > data/$DATATAG-raw.2.txt
FILTER
}

function FILTER {
cat data/$DATATAG-raw.2.txt |
sed "/^[,:\.\?\!;]/d" | grep "[\.\?\!;]['\"]\?$" |
sed "s:([^)]*)::g; s:\[[^]]*\]::g; s:{[^}]*}::g" |
sed "s:[(){}]::g; s:\[::g; s:\]::g" |
sed "s:^[一二三四五六七八九十]\+,::g" |
sed "s:^[1234567890]\+,::g" |
sed "/指导老师/d; /老师点评/d; /未经许可/d; /转载/d; /佚名/d" > data/$DATATAG-raw.3.txt
SEGMENT
}

function SEGMENT {
cat data/$DATATAG-raw.3.txt | segmenter.zh-elus.sh
}

if [ $1 ]; then
set -e -x -o pipefail
DATATAG=$2
$1
else
echo "Available anchors:
INIT NORMALIZE PUNCTUATE FILTER SEGMENT"
fi
