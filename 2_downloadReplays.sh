#!/bin/bash
echo "Downloaded files per second:"
cat prepared.csv | cut -d";" -f4- | parallel -j 8 wget -nv --show-progress -O {/} {} 2>&1 | fgrep "download-replay.php?reported_on=" | pv -l -r > /dev/null
