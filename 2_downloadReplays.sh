#!/bin/bash

cat prepared.csv | cut -d";" -f4- | parallel -j 8 wget -c -O {/} {}
