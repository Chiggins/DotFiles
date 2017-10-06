#!/usr/bin/env sh

killall -q polyball

while pgrep -x polybar >/dev/null; do sleep 1; done

polybar tophdmi &
polybar toplaptop &
