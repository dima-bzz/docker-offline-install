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

function download_package() {
    yum install --downloadonly --downloaddir="$1" -y docker-ce || \
    yum install --downloadonly --downloaddir="$1" --nobest -y docker-ce
}

print_info "Adding docker repositories"

# Adding docker repositories
yum-config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo

release="centos${RELEASE:-}"
arch=${ARCH:-$(uname --m)}
archive="docker_offline.$release.$arch.tar.gz"
path="/var/spool/download.docker.com"

print_info "Build yum cache"

# Build yum cache
yum makecache

print_info "Create directory"

# Create directory
mkdir -p "$path" && echo "OK"

print_info "Download Docker-CE and dependent packages"

# Download Docker-CE and dependent packages
download_package "$path"

print_info "Compress the Docker-CE and dependent packages"

# Compress the Docker-CE and dependent packages
tar -cvzf "$archive" -C /var/spool download.docker.com

print_info "Success" "Archive $archive created successfully"
