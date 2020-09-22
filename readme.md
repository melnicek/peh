# Linux privilege escalation

This script will download common linux privilege escalation tools, then serve them with python's http.server on port 8990 so you can download them on target machine.

# How to start using it ?

```
git clone https://github.com/melnicek/lpe
cd lpe
chmod +x run.sh
./run.sh
```

# Usage

```           
Usage: ./run.sh <LHOST/INTERFACE> <LPORT>

Example: ./run.sh 10.10.14.12 80
Example: ./run.sh tun0 8080
Example: ./run.sh tun0 random
```
