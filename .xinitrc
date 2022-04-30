#!/bin/sh

[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

# Disable pc speaker beeps. Better: Blacklist the kernel module pcspkr.
# xset -b

# Turn off Display Power Management Signaling (DPMS) and screen blanking.
xset s off -dpms

# Tune screen color temperature based on time.
if type redshift > /dev/null 2>&1; then
  redshift -l "$(<$HOME/secrets/redshift-coordinates)" -t 4500:2700
fi

# Adjust speed of specific mouses.
if type xinput > /dev/null 2>&1; then
  mouseid=$(xinput list | grep "SEMICCHIP Usb Mouse" | cut -f2 | cut -d= -f2)
  xinput --set-prop $mouseid 'libinput Accel Speed' -0.4
  mouseid=$(xinput list | grep "Logitech USB Optical Mouse" | cut -f2 | cut -d= -f2)
  xinput --set-prop $mouseid 'libinput Accel Speed' -0.3
fi

# Keyboard stuff (layout, capslock is escape, custom mappings etc.).
if type xkbcomp > /dev/null 2>&1; then
  # The command prints a bunch of warnings that I'm too lazy to research, so just silence the output.
  xkbcomp -I$HOME/.xkb ~/.xkb/keymap/xkbmap_us_custom $DISPLAY &> /dev/null
fi

# Start programs in background.
# Cannot use arguments here since the commands are just whitespace separated.
cmds=(
  dunst
  rwacom
  mpd
  unclutter
  devmon
  lxqt-policykit-agent
)
for cmd in ${cmds[@]}; do
  if type $cmd > /dev/null 2>&1; then
    $cmd &
  fi
done

# Once `ssh-agent` is running, run `ssh-add` once before you need your keys.
eval $(ssh-agent)

# Starting the window manager is required to be the last step.
# NOTE There are some more graphical program auto-starting at the bottom of `.i3/config`.
exec i3
