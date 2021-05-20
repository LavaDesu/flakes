#!/bin/sh

polybar top    >>/tmp/bar-top.log 2>&1 &
polybar bottom >>/tmp/bar-bottom.log 2>&1 &
