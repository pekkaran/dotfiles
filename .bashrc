## .bashrc

# Check for an interactive session
[ -z "$PS1" ] && return

# Prompt
if [ "$(id -u)" == "0" ]; then
  export PS1='\[\e[0;31m\]\W\$\[\e[0m\] ' # red for root
else
  export PS1='\[\e[0;36m\]\W\$\[\e[0m\] ' # cyan for normal user
fi

PATH="$PATH:$HOME/dotfiles/bin"
PATH="$PATH:$HOME/bin"

source "$HOME/dotfiles/shell.sh"
source /usr/share/git/completion/git-completion.bash
