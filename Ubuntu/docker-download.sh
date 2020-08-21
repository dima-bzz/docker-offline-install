#!/usr/bin/env bash

trap 'error' ERR

function print_info() {
  local status=("$@")

  if test -t 1; then
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

if [ -z "${RELEASE}" ]; then
  print_info "Updating repositories and installing dependencies"

  # Updating repositories and installing dependencies
  apt-get update
  apt-get -y install wget lsb-release apt-transport-https ca-certificates apt-mirror curl gnupg-agent software-properties-common && echo "OK"
fi

release=${RELEASE:-$(lsb_release -cs)}
arch=${ARCH:-$(dpkg --print-architecture)}
archive="docker_mirror.$release.$arch.tar.gz"

print_info "Get Docker's public key and add to apt"

# Get Docker's public key and add it to apt for package signature verification
curl -fsSl https://download.docker.com/linux/ubuntu/gpg | apt-key add -

print_info "Add Docker's apt repo to apt-mirror's mirror list"

# Add Docker's apt repo to apt-mirror's mirror list
echo "deb-$arch https://download.docker.com/linux/ubuntu $release stable" > /etc/apt/mirror.list && echo "OK"

print_info "Run apt-mirror to download Docker repo"

# Run apt-mirror to download Docker repo
apt-mirror

print_info "Save Docker's public key to the mirror directory"

# Save Docker's public key to the mirror directory
apt-key export 9DC858229FC7DD38854AE2D88D81803C0EBFCD88 > /var/spool/apt-mirror/mirror/download.docker.com/docker.key && echo "OK"

print_info "Compress the mirror"

# Compress the mirror dir to an archive file in the home directory
tar -cvzf "$archive" -C /var/spool/apt-mirror/mirror download.docker.com

print_info "Success" "Archive $archive created successfully"