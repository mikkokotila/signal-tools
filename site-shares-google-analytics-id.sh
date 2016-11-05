GAID = $1
curl -s http://w3bin.com/analytics/$GAID | head -90 | sed $'s/\/domain\//\\\n/g' | cut -d '"' -f1 | grep -e ^[a-z0-9] | wc -l
curl -s http://w3bin.com/analytics/$GAID | head -90 | sed $'s/\/domain\//\\\n/g' | cut -d '"' -f1 | grep -e ^[a-z0-9] > output.txt
