# Post exploitation helper

This script will help you to download all common post exploitation tools on your target machine using 2 simple commands.

Works even on target machines without internet access.

## How to start using it ?

```
git clone https://github.com/melnicek/peh
cd peh
sh peh.sh
```

## Usage

```
Example: ./peh.sh --file windows-privesc.peh --interface eth0
Example: ./peh.sh -f linux-privesc.peh -i tun0 -p 53

    -h, --help
        Prints this message.
    -f, --file    <FILE>
        Set peh file from where to load tool links to download.
    -i, --interface    <INTERFACE>
        Set on which interface to listen (default: tun0).
    -p, --port    <PORT>
        Set on which port to listen (default: 8990).
```
