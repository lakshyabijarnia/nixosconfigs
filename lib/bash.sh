#!/usr/bin/env bash

info () {
  echo -e "\033[1;30m[\033[1;32mi\033[1;30m] \033[0m $1"
}

prompt_nixos_machine_list () {
  if command -v fzf > /dev/null 2>&1; then
    command ls $HOME/.nixos-config/etc-nixos/machines | fzf --height=~15% --border=double || prompt_nixos_machine_list
  else
    nix-env -iA nixos.fzf
    prompt_nixos_machine_list
    nix-env -e fzf
  fi
}

get_nixos_machine () {
  eval "cat $HOME/.cache/nixos-machine 2> /dev/null || prompt_nixos_machine_list > $HOME/.cache/nixos-machine; cat $HOME/.cache/nixos-machine" | tail --lines=1
}

renix () {
  init_dir=$(pwd)
  
  machine="$1"

  mkdir -p $HOME/.cache/

  if [[ $machine == "" ]]; then
    machine=$(get_nixos_machine)
  else
    rm $HOME/.cache/nixos-machine
    echo $machine > $HOME/.cache/nixos-machine
  fi
  
  cd $HOME/.nixos-config/

  info "Checking for configuration updates..."
  git pull origin main
  
  cd etc-nixos/
  
  info "Building configuration for: '$machine'"
  sudo nixos-rebuild switch --flake ".#$machine"
  
  cd "$init_dir" > /dev/null 2>&1
}

alias update-flake-lock='nix flake update'
