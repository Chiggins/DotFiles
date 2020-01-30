#
#/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# .profile, if it exists
[ -f ~/.xprofile ] && source ~/.xprofile
#
# Mute terminal bell
xset -b
xsetroot -cursor_name left_ptr

# Set up colors
xrdb ~/.Xresources

xset +fp /usr/share/fonts/local
xset fp rehash

# Aliases
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

# Config for extra Asus monitor
xrandr --setprovideroutputsource 1 0
if [ "$(xrandr | grep 'DVI-I-1 connected' | cut -d ' ' -f 2)" == "connected" ]; then
    xrandr --output DVI-I-1 --mode 1920x1080 --right-of eDP1
fi



# Fixes some Java program rendering
export _JAVA_AWT_WM_NONREPARENTING=1

# Start up bspwm
xrandr --output Virtual-1 --mode 2560x1600
exec bspwm
