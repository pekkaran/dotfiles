if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# Set the list of directories that Zsh searches for programs.
path=(
  /usr/local/{bin,sbin}
  $HOME/dotfiles/bin
  $HOME/secrets/bin
  $HOME/bin
  $path
)

# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
if (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

# Automatically run wayland/xorg on the first virtual terminal. Test a named
# file exists, because in my experience all kinds of autologins are dangerous
# on new, partially broken installs.
if [[ -f "$HOME/.auto-startx" && -z $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  echo "Sleeping for 3 seconds before starting desktop. Hit Ctrl-C to abort.\n"
  sleep 3

  # exec startx

  export XDG_CURRENT_DESKTOP=sway
  export XDG_SESSION_DESKTOP=sway
  export XDG_SESSION_TYPE=wayland
  exec sway --unsupported-gpu
fi

# Japanese input
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export SDL_IM_MODULE=fcitx
export GLFW_IM_MODULE=ibus
