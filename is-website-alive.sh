#!/bin/bash

while read DOMAIN; do
    STATUS=$(curl -s --head --max-time 5 $DOMAIN | head -1)
    echo -e "$DOMAIN \t $STATUS" >> output.txt
    echo -e "$DOMAIN \t $STATUS"
done <input.txt
