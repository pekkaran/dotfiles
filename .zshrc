# # WHAT EACH ZSH DOTFILE DOES IN MY CONFIG:
#
# (I put this text in .zshrc because of the easy to remember filename)
#
# Consult the chart below, remembering that "login shell" is the one that gets
# run once while starting the system, "non-login shell" everytime you open a
# new shell window etc, and presumably "script" for zsh scripts.
#
# * <https://wiki.archlinux.org/index.php/Zsh>
# * <http://zsh.sourceforge.net/Guide/zshguide02.html>
#
# The startup files:
#
# * .zshenv:
#   Sources .zprofile when using interactive login.
#   Should be used to define env variables, not for commands that print.
#   Since all scripts run it, you probably want to place your stuff in the other files.
#
# * .zprofile:
#   Stuff for preparing login shell goes here.
#
# * .zprezto/init.zsh:
#   FILE NOT MEANT TO BE EDITED
#   Sourced at the beginning of `.zshrc`, so this happens for both types of interactive shells.
#   Loads prezto modules.
#   Sources `.zpreztorc`.
#
# * .zpreztorc:
#   Configuration file for zprezto.
#
# * .zshrc:
#   Stuff for both interactive shells goes here.
#
# * .zlogin:
#   Run custom commands (non-graphical) at end of login session.
#   The difference between .zprofile and .zlogin is that .zshrc is run in between them.
#
# * .zlogout:
#   Cleanup when closing login shell.
#
# * There are also system files like `/etc/{zprofile, zshrc}`.
#
# RUN ORDER:
#
# +----------------+-----------+-----------+------+
# |                |Interactive|Interactive|Script|
# |                |login      |non-login  |      |
# +----------------+-----------+-----------+------+
# |~/.zshenv       |    A      |    A      |  A   |
# +----------------+-----------+-----------+------+
# |~/.zprofile     |    B      |           |      |
# +----------------+-----------+-----------+------+
# |~/.zshrc        |    C      |    B      |      |
# +----------------+-----------+-----------+------+
# |~/.zlogin       |    D      |           |      |
# +----------------+-----------+-----------+------+
# |                |           |           |      |
# +----------------+-----------+-----------+------+
# |~/.zlogout      |    E      |           |      |
# +----------------+-----------+-----------+------+
#

# Source Prezto.
if [[ -s "$HOME/dotfiles/.zprezto/init.zsh" ]]; then
  source "$HOME/dotfiles/.zprezto/init.zsh"
fi

# Own setopts, after prezto config.

# See <https://github.com/kana/config/blob/master/sh/dot.zshrc>
# And `man zshoptions`
setopt hist_ignore_dups
setopt hist_ignore_space
setopt share_history
setopt glob
setopt glob_complete
setopt list_ambiguous
setopt list_packed
setopt list_types
unsetopt menu_complete # unsetopt default
unsetopt auto_cd # unsetopt default
unsetopt beep
unsetopt correct # don't correct command spelling

# Allow autocompletion directly after `=`, which is used by some programs to set parameters.
setopt magic_equal_subst

# This causes `cd path` where `path` is a symlink to show in the prompt the
# current real `pwd` instead of `path`. However, it works by losing the history of where
# you came from using `cd`, so that `cd ..` takes you to the parents of the symlink target directory.
# setopt chase_links

# Own Bash/zsh helpers.
sources=(shell.sh)
for x in ${sources[@]}; do
  if [[ -s "$HOME/dotfiles/$x" ]]; then
    source "$HOME/dotfiles/$x"
  fi
done

if type fzf > /dev/null 2>&1; then
  if [[ -f "/usr/share/doc/fzf/examples/completion.zsh" ]]; then
    # Ubuntu.
    source /usr/share/doc/fzf/examples/key-bindings.zsh
    source /usr/share/doc/fzf/examples/completion.zsh
  else
    # Arch linux.
    source /usr/share/fzf/key-bindings.zsh
    source /usr/share/fzf/completion.zsh
  fi
else
  bindkey '^R' history-incremental-search-backward
  bindkey '^S' history-incremental-search-forward
fi

# Like '^L', this clears the terminal, but it also prevents scrolling back to the old stuff.
# Very handy to do before a command that outputs lots of text, so you can find the beginning.
# <https://unix.stackexchange.com/a/531178>
function clear-scrollback-buffer {
  clear && printf '\e[3J'
  # .reset-prompt: bypass the zsh-syntax-highlighting wrapper
  # https://github.com/sorin-ionescu/prezto/issues/1026
  # https://github.com/zsh-users/zsh-autosuggestions/issues/107#issuecomment-183824034
  # -R: redisplay the prompt to avoid old prompts being eaten up
  # https://github.com/Powerlevel9k/powerlevel9k/pull/1176#discussion_r299303453
  zle .reset-prompt && zle -R
}
zle -N clear-scrollback-buffer
bindkey '^K' clear-scrollback-buffer

bindkey '^W' backward-kill-word
# The default binding. It erases current text and pops it back after you enter some other command maybe useful
bindkey '^Q' push-line

# bindkey '^Q' kill-whole-line

# Are you seriously still typing `cd ../../..`?
cd-parent() {
  cd ..
  zle .reset-prompt && zle -R
}
zle -N cd-parent
bindkey '^O' cd-parent

duplicate-terminal() {
  (pwd | $TERM_CMD &)
  # zle .reset-prompt && zle -R
}
zle -N duplicate-terminal
bindkey '^U' duplicate-terminal

# eval $(dircolors -b $HOME/dotfiles/shell/LS_COLORS)

# `autojump`, `z` and `fasd` are programs that help navigate directories quickly.
# I found `autojump` to be a bit slow and `z` buggy. Settled on the former for now.
# Link to `z` because it seems difficult to google: <https://github.com/rupa/z>
if type autojump > /dev/null 2>&1; then
  source "$HOME/secrets/autojump.zsh"
fi

# Once `ssh-agent` is running, run `ssh-add` once before you need your keys.
# Alternatively it works to put `eval $(ssh-agent)` in `.xinitrc`,
# but only when you are using `startx`.
agent_env_path="$HOME/.ssh-agent.env"
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
  rm -f "$agent_env_path"
  ssh-agent > "$agent_env_path"
fi
if [[ ! "$SSH_AUTH_SOCK" ]]; then
  source "$agent_env_path" > /dev/null
fi

if [ -f "$HOME/.zshrc_local" ]; then
  source "$HOME/.zshrc_local"
fi
