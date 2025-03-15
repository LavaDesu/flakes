#!/usr/bin/env bash

init=$(nmcli -t -f name,device connection show --active | grep wlp1s0 | cut -d\: -f1)

if [[ -z $init ]]; then
    echo Disconnected
else
    echo $init
fi

nmcli monitor | while read -r line ; do
    if [[ $line == *"is now the primary connection" ]]; then
        conn=$(echo $line | cut -d\' -f2)
        echo $conn
    fi
    if [[ $line == "There's no primary connection" ]]; then
        echo Disconnected
    fi
done
