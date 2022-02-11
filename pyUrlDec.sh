#/bin/bash

pbpaste | 
python3 -c "import sys; from urllib.parse import unquote; print(unquote(sys.stdin.read()));" | 
pbcopy 
pbpaste 
echo "\n##### Decoded query is already copied you can paste it into a Note #####"
