#!/bin/bash

ELO=$1

if [ -z "$ELO" ]; then
	ELO=0;
fi
echo "Games per second: "
cut -d";" -f1,3,7,13,24 data/ladder.csv  | grep "\"[[:digit:]]*.gz\"" | sed 's/ /+/g;s/:/%3A/g;s/"//g' | while read line; do 
	we="`echo "$line" | cut -d";" -f3`"; 
	le="`echo "$line" | cut -d";" -f4`";
	if [ $we -lt $ELO -o $le -lt $ELO ]; then
		continue;
	fi
        winner="`echo "$line" | cut -d";" -f1`"; 
        d="`echo "$line" | cut -d";" -f2`";
	echo "$winner;$we;$le;http://wesnoth.gamingladder.info/download-replay.php?reported_on=$d"; 
done | pv -l -r > prepared.csv
