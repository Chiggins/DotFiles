#!/usr/bin/env sh

killall -q polyball

while pgrep -x polybar >/dev/null; do sleep 1; done

if polybar -m | grep -i "Virtual"; then
    polybar topsinglevm
fi

if polybar -m | grep -i "eDP"; then
    polybar toplaptop
fi

if polybar -m | grep -i "HDMI"; then
    polybar tophdmi
fi
