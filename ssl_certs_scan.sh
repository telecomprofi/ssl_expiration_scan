#!/bin/sh

red='\033[0;31m'
nc='\033[0m' # No Color
green='\033[0;32m' 

if [[ -f $1 ]]; then
# if the file exists proceed with ssl scan in a loop

i=1;while read p; do key=$(echo "$p"| awk '{print $1}');curl -s -o /dev/null $key && echo "$i. ${green}$key${nc}" || echo "$i. ${red}$key${nc}";curl --insecure -vvI https://$key 2>&1 | awk 'BEGIN { cert=0 } /^\* SSL connection/ { cert=1 } /^\*/ { if (cert) print }'| grep -e 'expire'| sed -E 's/^\*  expire date\: //';i=$((i+1)); done <$1;
else
#Inform the user that the file do not exist
echo "file $1 does not exist or inaccessible\n

Usage:  ssl_certs_scan.sh file_with_domains.txt

Scanner for ssl cert expiration\n
"
fi

