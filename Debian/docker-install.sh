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

print_info "Updating repositories and installing dependencies"

# Update apt, install lsb-release
apt-get update
apt-get -y install lsb-release && echo "OK"

release=$(lsb_release -cs)
arch=$(dpkg --print-architecture)
archive="docker_offline.$release.$arch.tar.gz"

print_info "Create a directory for mirrored repositories"

# Create a directory for mirrored repositories
mkdir -p /var/deb/apt-mirror && echo "OK"

print_info "Extract mirrored repository"

# Extract mirrored repository
tar -xvzf "$archive" -C /var/deb/apt-mirror/

print_info "Add local Docker mirror to apt-get sources list"

# Add local Docker mirror to apt-get sources list

echo "deb [arch=$arch] file:///var/deb/apt-mirror/download.docker.com/linux/debian $release stable" > /etc/apt/sources.list.d/docker_local.list && echo "OK"

print_info "Add the Docker public key to apt-get"

# Add the Docker public key to apt-get so that it can verify the package signatures
apt-key add /var/deb/apt-mirror/download.docker.com/docker.key

print_info "Updating repositories"

# Run apt-get update so that apt will recognize new local repo added in previous step
apt-get update

print_info "Install Docker engine"

# Install Docker engine
apt-get -y install docker-ce

#print_info "Check version Docker"

#docker version --format '{{.Server.Version}}'

print_info "Success" "Docker install successfully"

