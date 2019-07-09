#!/bin/bash

YEAR=$1

cut -d";" -f1,3,7,13,24 data/ladder.csv  | grep "\"$YEAR[[:digit:]]*.gz\"" | sed 's/ /+/g;s/:/%3A/g;s/"//g' | while read line; do 
	winner="`echo "$line" | cut -d";" -f1`"; 
	d="`echo "$line" | cut -d";" -f2`"; 
	we="`echo "$line" | cut -d";" -f3`"; 
	le="`echo "$line" | cut -d";" -f4`"; 
	echo "$winner;$we;$le;http://wesnoth.gamingladder.info/download-replay.php?reported_on=$d"; 
done > prepared.csv
