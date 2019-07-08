#!/bin/bash
CSV="$1"
declare -A wins;
declare -A losses;

while read line; do
	winner="`echo "$line" | cut -d";" -f1`"
	loser="`echo "$line" | cut -d";" -f2`"
	if [ -z "$winner" -o -z "$loser" ]; then
		continue;
	fi

	key="$winner;$loser";
	if [ -n "${wins[$key]}" ]; then
		wins[$key]=$[ ${wins[$key]} + 1 ];
	else
		wins[$key]=1;
	fi

	key="$loser;$winner";

	if [ -n "${losses[$key]}" ]; then
                losses[$key]=$[ ${losses[$key]} + 1 ];
        else
                losses[$key]=1;
        fi
done < "$CSV"
for K in "${!wins[@]}"; do 
	echo "$K;${wins[$K]};${losses[$K]}"; 
done
