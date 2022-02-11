#/bin/bash

echo '### Copy all string from the ticket output then using (command+v) ###'
if pbpaste | grep -q dst; then
    pbpaste | 
    grep -Eo 'dst: [0-9]+.[0-9]+.[0-9]+.[0-9]+' | 
    grep -Eo '[0-9]+.[0-9]+.[0-9]+.[0-9]+'
else
    pbpaste | 
    grep -Eo 'SRC IP:.+|DST IP:.+' | 
    grep -Eo '[0-9]+.[0-9]+.[0-9]+.[0-9]+'
fi | 
uniq | \
while read CMD; do 
    echo "IP: $CMD"
    nslookup $CMD
done | 
grep -v "Authoritative answers can be found from:" | 
pbcopy
echo "### Use (command+v) in an Text Editor to see the Output ###"