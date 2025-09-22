#!/bin/bash

if [ $(pwd) != "$HOME" ]; then
  echo "Run from home directory."
  exit
fi

mkdir -p .config/dunst
mkdir -p .config/mpd
mkdir -p .config/mpv
mkdir -p .config/ncmpcpp
mkdir -p .config/nvim
mkdir -p .config/zathura

config_files=(
  dunst/dunstrc
  mpd/mpd.conf
  mpv/scripts
  mpv/input.conf
  mpv/mpv.conf
  ncmpcpp/config
  nvim/init.lua
  zathura/zathurarc
  nvim/lua/plugins
)

mkdir -p .config/nvim/lua
for file in ${config_files[@]}; do
  ln -s "$HOME"/dotfiles/.config/"$file" .config/"$file"
done

files=(
  .bashrc
  .git_template
  .tmux
  .vim
  .xkb
  .alacritty.yml
  .editorconfig
  .i3status.conf
  .lldbinit
  .nethackrc
  .tmux.conf
  .vimrc
  .zlogin
  .zlogout
  .zpreztorc
  .zprofile
  .zshenv
  .zshrc
)
# Not included: .Xresources .xinitrc .i3

for file in ${files[@]}; do
  if [ -f "$file" ]; then
    mv "$file" "$file.old"
  fi
  ln -s dotfiles/"$file" .
done

secret_files=(
  .gitconfig
)

for file in ${secret_files[@]}; do
  if [ -f "$file" ]; then
    mv "$file" "$file.old"
  fi
  ln -s secrets/"$file" .
done
