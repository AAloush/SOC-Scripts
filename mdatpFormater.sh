#/bin/bash

pbpaste | 
sed 's/>/>\
/g' | 
sed 's|</|\
</|g' | 
grep -v '<.*' | 
iconv -c -f UTF-8 -t ASCII | 
grep -v '^[[:space:]]*$' |
grep -v "Side panel" | 
grep -v "Hunt for related events" | 
sed 's|&gt;|>|g' |
pbcopy
echo "\n##### MDATP Event is already foramted and copied you can paste it into a Note #####"