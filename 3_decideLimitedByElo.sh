#!/bin/bash

ELOLIMIT="$1"
set -x
echo "winner_faction;loser_faction;winner;loser;title;file" > result.csv
cat prepared.csv | while read line; do
	file="$( basename "`echo "$line" | cut -d";" -f4`")" 
	zcat "$file" | wml2xml > "$file.xml"
	./decideByName.sh "`echo "$line" | cut -d";" -f1`" "$( basename "`echo "$line" | cut -d";" -f4`").xml" "`echo "$line" | cut -d";" -f3`" "`echo "$line" | cut -d";" -f2`" "$ELOLIMIT"; 
done 2> errors.txt > result.csv
