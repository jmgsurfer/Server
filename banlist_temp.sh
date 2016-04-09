#!/bin/bash
#
# ban2block script
#
ip='[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'
file='fail2ban.log*'
log='banned.txt'
#
usage() {
  cat<<EOF

This script will check fail2ban.log and block all IPs, already banned more than X times, with iptables
All IP blocked will be logged into $log for further usage.

REQUIREMENTS:
  - root priviledge
  - file /var/log/fail2ban.log

Usage: no arguments needed on this version.

EOF
}
# A few test before to start
# Need to be roor to use this script
if [ `id -u` -ne 0 ]; then usage; exit 1; fi
if [ ! -f $file ]; then usage; exit 1; fi
if [ ! -f $log ]; then touch $log; fi
#
grep -o -E "Ban $ip" $file | grep -o -E "$ip" > banned.tmp
cat banned.tmp | sort | uniq > sort-banned.tmp
#
for i in `cat sort-banned.tmp`;do res=`grep -c -E "$i" banned.tmp`; echo "$res:$i" >> results.tmp;done
sort -r results.tmp > fin-results.txt
# echo "Nombre de fois IP bannies par fail2ban"
# cat fin-results.txt
rm *.tmp
#
while read line
  do
    # get occurence Nb of IP
    j=$(echo "$line" | cut --delimiter=":" --fields=1)
    # get IP
    k=$(echo "$line" | cut --delimiter=":" --fields=2)
    # Adapt with correct nb: here 1 for testing, recommanded 5
    if [ $j -lt 1 ]
    then
      continue
    fi
    # Test if IP is present in banned.txt, meaning already banned
    grep -o -E $k banned.txt > /dev/null
    success=$?
    if [ $success -eq 0 ]
    then
      echo "[KO] - $k is already blocked."
      continue
    fi
    # Process iptables blocking
    # iptables -I INPUT 1 -s $k -j DROP
    echo $k >> iptables_ip.txt
    echo $k >> banned.txt
    echo "[OK] - $k has just been blocked."
  done < fin-results.txt
