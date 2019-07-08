#!/bin/bash
WINNER="$1"
ORIG_XML="$2"
WELO="$3"
LELO="$4"
LIMIT="$5"

cp "$2" /tmp/current.xml
XML="/tmp/current.xml"

function error() {
	echo "$ORIG_XML Error: $1" 1>&2
	exit 1
}

if [ $WELO -lt $LIMIT -o $LELO -lt $LIMIT ]; then
	error "Elo scores to low";
fi

function parseFactionByName() {
        faction="`xml sel -t -v "///side[@current_player='$2']/@faction_name" "$1" | head -n1`"
 	if [ -z "$faction" ]; then
		error "Empty faction string"
        elif [ "$faction" == "Custom" ]; then
		error "Unknown Faction: Custom"
        else
                echo "$faction"
        fi
}

function parseSideCount() {
	xml sel -t -v "count(///side/@current_player)" "$1"
}
function parseSide1Name() {
	xml sel -t -v "///side[@side=1]/@current_player" "$1" | head -n1
}

function parseSide2Name() {
        xml sel -t -v "///side[@side=2]/@current_player" "$1" | head -n1
}

function parseLoser() {
	xml sel -t -v "///speak[@id = 'server']/@message" "$1" | fgrep surrendered | sed -r 's/^(.*) has surrendered./\1/g' | head -n1
}

function parseTitle() {
	title="`xml sel -t -v "/root/@mp_game_title" "$1"`"
	if [ -z "$title" ]; then
		xml sel -t -v "/root/multiplayer/@scenario" "$1"
	fi
}

function parseFactionByName() {
	recruit="`xml sel -t -v "///side[@current_player='$2']/@recruit" "$1" | head -n1`"
	if [ -z "$recruit" ]; then
		recruit="`xml sel -t -v "///side[@current_player='$2']/@previous_recruits" "$1" | head -n1`"
	fi
	if [[ "$recruit" =~ "Drake" ]]; then
		echo Drakes;
	elif [[ "$recruit" =~ "Skeleton" ]]; then
		echo Undead;
        elif [[ "$recruit" =~ "Dwarvish Fighter" ]]; then
                echo Knalgan Alliance;
        elif [[ "$recruit" =~ "Elvish Fighter" ]]; then
                echo Rebels;
        elif [[ "$recruit" =~ "Fencer" ]]; then
                echo Loyalists;
        elif [[ "$recruit" =~ "Orcish Grunt" ]]; then
                echo Northerners;
	else
		faction="`xml sel -t -v "///side[@current_player='$2']/@faction_name" "$1" | head -n1`"
		if [ -z "$faction" ]; then
        	        error "Empty faction string"
	        elif [ "$faction" == "Custom" ]; then
        	        error "Unknown Faction: Custom"
	        else
        	        echo "$faction"
	        fi
	fi
}

title="`parseTitle "$XML"`"
name1="`parseSide1Name "$XML"`"
name2="`parseSide2Name "$XML"`"

if [ "$WINNER" == "$name2" ]; then
faction1="`parseFactionByName "$XML" "$name1"`"
faction2="`parseFactionByName "$XML" "$WINNER"`"

	echo "$faction2;$faction1;$name2;$name1;$title;$2"
elif [ "$WINNER" == "$name1" ]; then
faction1="`parseFactionByName "$XML" "$WINNER"`"
faction2="`parseFactionByName "$XML" "$name2"`"

        echo "$faction1;$faction2;$name1;$name2;$title;$2"
else
	error "winner ($WINNER) doesn't match either names: $name1, $name2";
fi


