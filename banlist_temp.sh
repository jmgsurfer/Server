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
for line in fin-results.txt
  do
    j = line | cut -d":" -f1
    k = line | cut -d":" -f2
    if [ $j < 5 ]; then next; fi
    if [ grep -o -E $k banned.txt ]; then next; fi
    iptables -I INPUT 1 -s $k -j DROP
  done

