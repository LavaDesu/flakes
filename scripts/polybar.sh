#!/bin/sh

polybar top      >> ${XDG_RUNTIME_DIR}/bar-top.log 2>&1 &
polybar scroller >> ${XDG_RUNTIME_DIR}/bar-scroller.log 2>&1 &
