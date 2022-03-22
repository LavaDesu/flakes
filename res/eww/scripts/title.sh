#!/usr/bin/env sh

xtitle -s | while read -r line ; do
    trunc=$(echo $line | cut -c-85)
    if [ -z "$line" ]; then
        echo ""
    else
        echo "(box :class \"widget title\" :halign \"center\" :valign \"center\" :vexpand true :hexpand true (label :text \"${trunc}\"))"
    fi
done
