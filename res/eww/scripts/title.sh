#!/usr/bin/env sh

out () {
    if [ -z "$1" ]; then
        echo ""
    else
        echo "(box :class \"widget title\" :halign \"center\" :valign \"center\" :vexpand true :hexpand true (label :text \"$1\"))"
    fi
}

init=$(hyprctl activewindow -j | jq --raw-output .title)
out "$init"

socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | stdbuf -o0 awk -F '>>|,' '/^activewindow>>/{print $3}' | while read -r line ; do
    trunc=$(echo $line | cut -c-85)
    out "$trunc"
done
