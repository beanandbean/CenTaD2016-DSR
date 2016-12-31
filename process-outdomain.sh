function INIT {
cat data-outdomain-raw/$NAME-sent.zh > data/$NAME-raw.txt
FILTER
}

function FILTER {
cat data/$NAME-raw.txt |
./filter-raw.sh INIT $NAME > data/$NAME-filtered.txt
SELECT
}

function SELECT {
cat data/$NAME-filtered.txt |
awk '{if (NF >= 3 && NF <= 30) print $0}' > data/$NAME-selected.txt
}

if [ $1 ]; then
set -e -x -o pipefail
NAME=$2
$1
else
echo "Available anchors:
INIT FILTER SELECT"
fi
