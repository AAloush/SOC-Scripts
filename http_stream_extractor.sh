echo "Targets:"
tshark -nr $1 -T fields -e http.request.full_uri | grep http | sort -u
echo "\nAttacker tried to execute following:"
tshark -nr $1 -V -Y "http.request || http.response" | grep "jndi" | sed  's|    ||g' |sort -u
tshark -nr $1 -V -Y "http.request || http.response" | grep -F "\${\${" | sed  's|^\s*||g' |sort -u
echo "\nAttacker Source:"
tshark -r $1 -Y http.request -V | grep "Source Address:" | grep -Eo ':.+' | sed 's|: ||g' | sort -u

echo "\nHTTP STREAMS:\n"
END=$(tshark -r $1 -T fields -e tcp.stream | sort -n | tail -1)
for ((i=0;i<=END;i++))
do
    echo "Stream:" $i
    tshark -r $1 -qz follow,http,ascii,$i
done