#!/bin/bash
#
ip='[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'
file='fail2ban.log*'
#
grep -o -E "Ban $ip" $file | grep -o -E "$ip" > banned.tmp
cat banned.tmp | sort | uniq > sort-banned.tmp
#
for i in `cat sort-banned.tmp`;do res=`grep -c -E "$i" banned.tmp`; echo "$res:$i" >> results.tmp;done
sort -r results.tmp > fin-results.txt
echo "Nombre de fois IP bannies par fail2ban"
cat fin-results.txt
rm *.tmp
#
while read line
  do
    # get occurence Nb of IP
    j=$(echo "$line" | cut --delimiter=":" --fields=1)
    # get IP
    k=$(echo "$line" | cut --delimiter=":" --fields=2)
    if [ $j -lt 2 ]; then continue; fi
    # Test if IP is present in banned.txt, meaning already banned
    grep -o -E $k banned.txt
    success=$?
    if [ $success -ne 0 ]; then continue; fi
    echo $j
    echo $k
#    iptables -I INPUT 1 -s $k -j DROP
  done < fin-results.txt
