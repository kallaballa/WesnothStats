#!/bin/bash

ELOLIMIT="$1"
echo "winner_faction;loser_faction;winner;loser;title;file" > result.csv
cat prepared.csv | while read line; do
	file="$( basename "`echo "$line" | cut -d";" -f4`")" 
	zcat "$file" | wml2xml > "$file.xml"
	./decideByName.sh "`echo "$line" | cut -d";" -f1`" "$file.xml"; 
done 2> errors.txt > result.csv