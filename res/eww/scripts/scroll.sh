#!/usr/bin/env sh
translated=$([ "$1" == "up" ] && echo "prev" || echo "next")
bspc desktop -f $translated
