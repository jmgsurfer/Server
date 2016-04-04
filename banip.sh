#!/bin/bash
#
machaine = `Bad-Guys`
liste = $1
#
# "Bad-Guys" présent dans iptables?
#
if [ chain_exists($machaine) ]; then
echo "Chaîne Bad-Guys présente [OUI]
else
echo "Chaîne Bad-Guys présente [NON]
echo "Création chaîne Bad-Guys [OUI]"
chain_create($machaine)
fi
#
#########
Parse liste IPs
#########
# IP Présente dans chaîne oui/non
# oui: ne rien faire; afficher "déjà bannies"
# non: bannir
#########
#bannir ips
for i in `cat ips.txt`;do iptables -A bad-ips -s $i -j DROP; done

#verif ip présente ou non
$ cat `which spamblock.sh`

if [ $# = 1 ]; then
LOOKUP=`sudo iptables -nL | grep $1`
if [ -z "$LOOKUP" ]; then
echo Blocking $1
sudo iptables -v -A INPUT -s $1 -j DROP
else
echo ALREADY BLOCKED
echo $LOOKUP
fi
else
echo Must get exactly 1 IP address to spam block
fi

#Vérifier si userchain existe
chain_exists()
{
[ $# -lt 1 -o $# -gt 2 ] && {
echo "Usage: chain_exists <chain_name> [table]" >&2
return 1
}
local chain_name="$1" ; shift
[ $# -eq 1 ] && local table="--table $1"
iptables $table -n --list "$chain_name" >/dev/null 2>&1
}

