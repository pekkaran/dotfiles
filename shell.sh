#!/bin/bash
#
# Zsh/bash aliases, exports, and functions.
#
# One thing to remember is that the aliases only work if they are the first part
# of a command. If you want to do something like `ls | dmenu` or `ls | xargs vim`,
# then aliases for `dmenu` and `vim` will be ignored. So to make such use cases work,
# instead of aliases some programs have thin wrapper executables under `dotfiles/bin`.

# Coreutils and their replacements.
if type eza > /dev/null 2>&1; then
  # These might be available in future versions (currently in git master):
  # --no-permissions --no-filesize --no-user --no-time
  alias la='eza -la --group-directories-first'
  alias lat='eza -la -snew --group-directories-first'
  alias lar='eza -laR --group-directories-first'
  alias lag='eza -la --group-directories-first | \rg -i'
elif type exa > /dev/null 2>&1; then
  alias la='exa -la --group-directories-first'
  alias lat='exa -la -snew --group-directories-first'
  alias lar='exa -laR --group-directories-first'
  alias lag='exa -la --group-directories-first | \rg -i'
else
  alias ls='\ls --color=auto --group-directories-first'
  alias la='\ls -lahF --color=auto --group-directories-first'
  alias lat='\ls -lahFtr --color=auto --group-directories-first' # sort by time (reverse)
  alias lar='\ls -lahFR --color=auto --group-directories-first' # recursive
  alias lag='\ls -lahF --color=auto --group-directories-first | \rg -i'
fi
alias cp='\cp -i' # prompt before overwriting
alias mv='\mv -i' # prompt before overwriting
alias chx='chmod +x'
alias fs='du -shD' # size of file or folder. s:summarize, h:human_readable, D=dereference_links
alias df='df -hT' # Show file system space usage in human readabale format.
alias lf='du -shx * | sort -h' # find large directories/files in current folder. Btw, if /var is filling /, then you probably forgot to run `pacman -Sc` for a year.

# Searching. "rg" is a "grep" replacement
# -i: ignore case
# --hidden: include hidden files in search
alias rg='\rg -i --hidden'
alias rgi='\rg --hidden'
alias rgl='\rg -li' # Print filenames of matches instead.

# "fd" is a "find" replacement.
if type fdfind > /dev/null 2>&1; then
  # The binary name is different in some distros.
  alias fd='\fdfind -H'
  alias fdi='\fdfind -H -I'
else
  alias fd='\fd -H' # -H include hidden files
  alias fdi='\fd -H -I' # -I do not skip ignore files
fi

# Misc
alias en='LANG=en_EN.UTF-8' # Prefix commands with this to use the English locale.
alias ssha='ssh-add -t 150000 $(find ~/.ssh | grep id | grep -v pub)'
alias info='\info --vi-keys'
alias uusb='devmon -u' # unmount everything mounted by devmon (included in udevil)
alias gnutime="/usr/bin/time -f 'user: %U, sys: %S, percentage: %P, wall %e'"
# `gr myprogram --myargs` will run until crash, print backtrace and exit.
alias gr='gdb --ex run --ex bt -ex="set confirm off" --ex quit --args'
# Prepend with video file to exactly compute the number of frames in it.
alias packets='ffprobe -v error -select_streams v:0 -count_packets -show_entries stream=nb_read_packets -of csv=p=0'

# Media
alias za='zathura'
alias sxiv='sxiv -a -s f' # play animations, scale fit
alias feh='feh -FZx' # full screen, auto-zoom, borderless
alias mp='\ncmpcpp' # [m]usic [p]layer
alias mpv_fix_mono='mpv --audio-channels=1'
alias mpv2='\mpv --vo=vdpau' # This fixed some video playback issue when using the default --vo=gpu.
for i in $(seq 1 4); do
  alias ims$i="find . -maxdepth $i | grep -iE \"gif|png|jpg|jpeg\" | sort | sxiv -i"
  alias vids$i="find . -maxdepth $i | grep -iE \"gif|png|jpg|jpeg|mkv|mp4|avi|mov|webm\" | sort | mpv --playlist=-"
done
alias ims='ims1'
alias vids='vids1'

# Git
#   Git has its own alias functionality but I don't want to type the "git " prefix to use it.
alias add='git add'
alias branch='git branch -v'
# TODO Start use the new `switch` and `restore` commands instead of `checkout`:
# <https://www.banterly.net/2021/07/31/new-in-git-switch-and-restore/>
alias ch='git checkout'
alias chb='git checkout -b'
# alias cs='git switch' # Same as eg `git checkout old-branch`
# alias csc='git switch -c' # Same as eg `git checkout -b new-branch`
# alias cre='git restore` # Same as eg `git checkout -- file`. I think `restore` doesn't need `--`.
alias cherry-pick='git cherry-pick'
alias clone='git clone'
alias commit='git commit'
alias fe='git fetch --tags --prune'
# Setting $GIT_PAGER like that seems to fix an issue where few lines at top of the log are "invisible" until I scroll down and up (or press g).
alias log='GIT_PAGER="less" git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias  lo='GIT_PAGER="less" git log         --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias merge='git merge'
alias pull='git pull'
alias push='git push'
alias pushh='git push --set-upstream origin $(git branch --show-current)'
alias rebase='git rebase -i'
alias rc='git rebase --continue'
alias rom='git rebase -i origin/main'
alias romaster='git rebase -i origin/master'
alias remote='git remote'
# Change all staged content to non-staged changes.
alias rs='git restore --staged $(git rev-parse --show-toplevel)'
alias revert='git revert'
alias show='git show'
alias sta='git diff --stat HEAD~1 | head -n -1' # Summary of file line changes for corresponding `show`.
alias recentf="git diff --stat HEAD~1 | head -n -1" # Same as `sta`, but see the variants below.
# show0 == show, sta0 == sta, recentf0 == recentf
for i in $(seq 0 9); do
  alias show$i="git show HEAD~$i"
  # Files changed in the last i:th commit.
  alias sta$i="git diff --stat HEAD~$(($i + 1)) HEAD~$i | head -n -1"
  # Files changed in the last i commits together.
  alias recentf$i="git diff --stat HEAD~$(($i + 1)) HEAD | head -n -1"
done
alias stash='git stash'
alias status='git status'
alias s='git status -sb'
alias tag='git tag'
alias sm='git submodule'
alias sma='git submodule add'
alias sms='git submodule sync'
alias smu='git submodule update'
alias smuir='git submodule update --init --recursive'
# To remove a submodule `submodule rm <path>` and commit.
alias reflog='git reflog'
# -v: verbose, shows the diff in the commit message editor. This can also be set as git config option.
alias c='git commit -v'
alias ca='git commit -v -a'
alias cam='git commit -v --amend'
alias d='in-git-repository && git diff'
alias dc='in-git-repository && git diff --cached'
# Like `git diff` but for untracked files.
function dt() {
  for file in $(git ls-files --others --exclude-standard); do
    git --no-pager diff --no-index /dev/null $file
  done
}
# Grab all unstaged and stanged changes and commit them with the message "e".
function ce() {
  cd "$(git rev-parse --show-toplevel)"
  git add .
  git commit -a -m "e"
}
# List branches recently committed to.
alias recent='git for-each-ref --sort=-committerdate refs/heads/ | head -n 20'

## Pacman
# Use the English locale in case of something goes wrong. Capital first letter indicates sudo use.
alias PSyu='sudo LANG=C pacman -Syu' # The usual update all command.
alias PSyy='sudo LANG=C pacman -Syy' # Just sync. DO NOT run this before -S without -Syu because it may cause "partial update", see the arch wiki.
alias PS='sudo LANG=C pacman -S' # Install specific package(s).
alias PUx='sudo LANG=C pacman -U *pkg.tar.xz' # Install a just-built AUR package in the pwd.
alias PUz='sudo LANG=C pacman -U *pkg.tar.zst' # Install a just-built AUR package in the pwd.
alias PR='sudo LANG=C pacman -R' # Remove the specified package(s), retaining its configuration(s) and required dependencies
alias PRs='sudo LANG=C pacman -Rs' # Also remove dependencies of the packages, but not recursively so.
alias PSc="sudo LANG=C pacman -Sc" # Clean cache - delete all not currently installed package files.
alias Pclean="sudo LANG=C pacman -Sc" # Clean cache - delete all not currently installed package files.
alias PSkeys="sudo LANG=C pacman -Sy archlinux-keyring" # Usually this fixes PGP issues from updating packages.
alias pQ='LANG=C pacman -Q' # List all installed packages.
alias pfiles="LANG=C pacman -Ql" # List all files installed by a given package.
alias porphan="LANG=C pacman -Qdtq" # List all packages which are orphaned.

## Debian family package management. The names match the pacman aliases above.
alias AS='sudo apt-get install'
alias AR='sudo apt-get remove'
alias DS='sudo dpkg -i' # Install `.deb` file.
alias aQ='apt list --installed' # List all installed packages.

## Rust
alias cb='cargo build'
# --watch: Watch git root instead of $PWD because of my project crate organization.
alias cww='cargo watch --clear --watch "$(git rev-parse --show-toplevel)"'

alias cr='cargo run --'
# --tests: Do not run doc tests etc.
# --nocapture: Show prints from tests.
alias ct='cargo test --tests -- --nocapture'
alias cbr='cargo build --release'
alias crr='cargo run --release --'
# `cargo install cargo-deps`. `dot` is in the graphviz package.
alias depgraph='cargo deps --all-deps | dot -Tpng > graph.png'
alias depgraph1='cargo deps --all-deps --depth 1 | dot -Tpng > graph.png'
alias depgraph2='cargo deps --all-deps --depth 2 | dot -Tpng > graph.png'
# <https://github.com/kbknapp/cargo-outdated>
alias outdated='cargo outdated -R'

# Docker
alias dk='docker'
alias dkc='docker container'
alias dkls='docker container ls --all'
alias dkps='docker ps -a'
alias dki='docker image'
alias dkr='docker run'
alias dkri='docker run -it' # interactive, tty

alias w='$HOME/own-dev/wall/target/debug/wall'

# Not exactly to my taste, but I use GTK so rarely I didn't investigate options.
export GTK_THEME=Adwaita:dark

# Common linux environment variables
export CC=/usr/bin/clang
export CXX=/usr/bin/clang++

# There is the `dotfiles/bin/vim` executable which runs neovim if it's installed.
export EDITOR="vim"
export VISUAL="vim"

export PAGER="less"
export BROWSER="firefox"

# zsh and bash history size in lines.
export HISTSIZE=10000
export SAVEHIST=10000

# `less` arguments
# -i: ignore case is search
# -n: no line numbers
# -z: Scrolling behavior
# -g: hilight only current search match
# -M: ? --LONG-PROMPT
# -X: ? Supplying this makes the output not clear from the screen, which I didn't like.
# -F: Exit automatically if file fits the screen. Didn't like.
# -R: ? tl;dr
# -j: ? Line placement.
export LESS='-i -n -g -M -R -j0'

export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
#export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_so=$'\E[01;31;31m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# “Note that an empty entry is interpreted as the current directory, because that's how POSIX
# defined PATH, and POSIX hates you. This means that these variables must not begin or end
# with :, and must not contain :: anywhere in the middle.”
# LD_LIBRARY_PATH=$(echo $LD_LIBRARY_PATH | sed -E -e 's/^:*//' -e 's/:*$//' -e 's/:+/:/g')
# LIBRARY_PATH=$(echo $LIBRARY_PATH | sed -E -e 's/^:*//' -e 's/:*$//' -e 's/:+/:/g')

# Rust
# This directory is used by upstream rustup (ie when installing with curl script).
if [ -d "$HOME/.cargo" ]; then
  export PATH="$PATH:$HOME/.cargo/bin"
fi

export RUST_BACKTRACE=1

# This finds the sources installed by `rustup component add rust-src`.
# It's handy because running the rustup update keeps compiler and sources
# versions in sync.
type rustc >/dev/null 2>&1 && export RUST_SRC_PATH=$(rustc --print sysroot)/lib/rustlib/src/rust/src/

export VDPAU_NVIDIA_NO_OVERLAY=1

## My own variables

# The command by which prefered terminal is launched
export TERM_CMD="alacritty"

#export FONT_PANGO="DejaVu Sans Mono 12"
export FONT_PANGO="DejaVu Sans Mono for Powerline 12"

# User folder that stores information from scripts
export STATE_FOLDER="$HOME/.state"

# `cd` without manual tab-completing. Also an easier to type alias, as 'cd'
# uses the same finger in the standard touch typing style.
function k() {
  # Use `cd` for the full parts.
  dir="$(dirname $1)"
  cd "$dir"
  # Complete the last part.
  base="$(basename $1)"
  matches="$(ls -d */ | grep -iF "$base")"
  count=$(echo $matches | wc -l)
  if (( $count == 0 )); then
    exit
  elif (( $count > 1 )); then
    # For multiple matches, pick the shortest and print all.
    matches=$(echo "$matches" | perl -e 'print sort { length($a) <=> length($b) } <>')
    echo "$matches"
    cd "$(echo "$matches" | head -n 1)"
  else
    cd "$matches"
  fi
}

# Compact `watch git diff`.
function wgd() {
  if [[ $(git rev-parse --is-inside-work-tree) = true ]]; then
    # Use grep to remove three less informative lines. Might be some flags in git-diff
    # to do this better. Now it matches any line containing "index ". I couldn't get
    # beginning of line `^` to work, possibly because of color escape sequences.
    watch -c "git diff -U1 --color=always | grep -E -v '\-\-\-|\+\+\+|index '"
  fi
}

# Extract any archive.
function ex() {
  file="$1"
  case "$file" in
    *.tar.bz2) tar xjf "$file";;
    *.tar.gz) tar xzf "$file";;
    *.bz2) bunzip2 "$file";;
    *.rar) unrar x "$file";;
    *.gz) gunzip "$file";;
    *.tar) tar xf "$file";;
    *.tbz2) tar xjf "$file";;
    *.tgz) tar xzf "$file";;
    *.zip) unzip "$file";;
    *.Z) uncompress "$file";;
    *.7z) 7z x "$file";;
    *.xz) tar xvJf "$file";;
    *) echo "'$file' cannot be extracted via ex()"; return 1 ;;
  esac
}

function exrm() {
  ex "$1" && rm "$1"
}

function flat() {
  mv "$@"/* . && rmdir "$@"
}

# `cd` into path under current git project root. Outside git use $PWD.
function cdg() {
    cd "$(git rev-parse --show-toplevel 2> /dev/null || echo ".")/$@"
}

# Stream first youtube search result.
function yv() {
  youtube-dl \
    --default-search=ytsearch: \
    --youtube-skip-dash-manifest \
    -o - \
    "$*" \
    | mpv -
}

# Audio only.
function ya() {
  youtube-dl \
    --default-search=ytsearch: \
    --youtube-skip-dash-manifest \
    -o - \
    --format="bestaudio[ext!=webm]" \
    "$*" \
    | mpv -
}

# Add all search hits from the music library and play in order.
function play() {
  mpc clear
  mpc search title "$*" | mpc add
  mpc play
}

# Paranoid about making typos, avoid typing `rm -rf` to remove a git repository.
function rmgit() {
  if [ $# -ne 1 ]; then
    echo "Usage: gitrm <dir>"
    return
  fi

  if [ -d "$1/.git" ]; then
    rm -rf "$1/.git" && rm -r "$1"
  else
    echo "Not a git repository."
  fi
}

# Modern kids might instead call this "YOLO".
# Don't use this ever. Except when you really need to. Alright go ahead, I'm not responsible.
function roll() {
  cd "$(git rev-parse --show-toplevel)"
  git add .
  git commit --amend --no-edit
  git push --force
}
