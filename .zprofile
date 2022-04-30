if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# Set the list of directories that Zsh searches for programs.
path=(
  /usr/local/{bin,sbin}
  $HOME/dotfiles/bin
  $HOME/bin
  $path
)

# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
if (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

# Automatically startx on the first virtual terminal. Test a named file exists
# in my experience all kinds of autologins are dangerous on new, partially
# broken installs. Also sleep to give time to hit Ctrl-C.
if [[ -f "$HOME/.auto-startx" ]]; then
  echo "sleeping\n"
  sleep 3
  [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
fi

# TODO Move?
export PATH="$HOME/.cargo/bin:$PATH"
