#!/bin/bash
XML="$1"

cp "$1" /tmp/current.xml
XML="/tmp/current.xml"

function error() {
	echo "Error: $1" 1>&2
	exit 1
}
function parseSideCount() {
	xml sel -t -v "count(///side/@name)" "$1"
}
function parseSide1Name() {
	xml sel -t -v "///side[@side=1]/@name" "$1"
}

function parseSide2Name() {
        xml sel -t -v "///side[@side=2]/@name" "$1"
}

function parseLoser() {
	xml sel -t -v "///speak[@id = 'server']/@message" "$1" | fgrep surrendered | sed -r 's/^(.*) has surrendered./\1/g' | head -n1
}

function parseTitle() {
	xml sel -t -v "/root/@mp_game_title" "$1"
}

function parseSide1Faction() {
	faction="`xml sel -t -v "///side[@side=1]/@faction_name" "$1" | head -n1`"
	if [ "$faction" == "Custom" ]; then
		xml sel -t -v "///side1/@faction_name" "$1" | head -n1
	else
		echo "$faction"
	fi
}

function parseSide2Faction() {
        faction="`xml sel -t -v "///side[@side=2]/@faction_name" "$1" | head -n1`"
        if [ "$faction" == "Custom" ]; then
                xml sel -t -v "///side2/@faction_name" "$1" | head -n1
	else
		echo "$faction"
        fi
}

title="`parseTitle "$XML"`"
if [ -z "`echo "$title" | fgrep -i ladder`" ]; then
        error "Not a ladder game"
fi

sidecnt="`parseSideCount "$XML"`"
if [ $sidecnt -ne 2 ]; then
	error "side count is not 2";
fi

name1="`parseSide1Name "$XML"`"
name2="`parseSide2Name "$XML"`"
faction1="`parseSide1Faction "$XML"`"
faction2="`parseSide2Faction "$XML"`"
loser="`parseLoser "$XML"`"

if [ -z "$loser" ]; then
	error "No one surrendered"
fi

if [ "$loser" == "$name1" ]; then
	echo "$faction2;$faction1;$name2;$name1;$title;$1"
elif [ "$loser" == "$name2" ]; then
        echo "$faction1;$faction2;$name1;$name2;$title;$1"
else
	error "loser ($loser) doesn't match either names";
fi


