#!/usr/bin/env bash

trap 'error' ERR

function print_info() {
  local status=("$@")

  if test -t 1 && [ -x "$(command -v tput)" ]; then
    bold=$(tput bold)
    reset=$(tput sgr0)
    red=$(tput setaf 1)
    green=$(tput setaf 2)
    tan=$(tput setaf 3)
  fi

  if [ "${status[0]}" == "Success" ]; then
    printf "\n${bold}${green}%s${reset}\n\n" "${status[1]}"
  elif [ "${status[0]}" == "Error" ]; then
      printf "\n${bold}${red}%s${reset}\n\n" "Something went wrong"
  else
    printf "\n${bold}${tan}==========  %s  ==========${reset}\n\n" "$*"
  fi
}

function error() {
    print_info "Error"
    exit
}

release="centos${RELEASE:-}"
arch=$(uname --m)
archive="docker_offline.$release.$arch.tar.gz"
path="/var/rpm/download.docker.com"

print_info "Create a directory for repositories"

# Create a directory repositories
mkdir -p /var/rpm && echo "OK"

print_info "Extract mirrored repository"

# Extract mirrored repository
tar -xvzf "$archive" -C /var/rpm/

print_info "Installed packages"

# Installed packages
rpm -ivh --replacefiles --replacepkgs "$path"/*.rpm

print_info "Success" "Docker install successfully"

