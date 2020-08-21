FROM amd64/debian:10.5

# Updating repositories and installing dependencies
RUN apt-get update && apt-get install -y wget \
    vim \
    lsb-release \
    apt-transport-https \
    ca-certificates \
    apt-mirror \
    curl \
    gnupg-agent \
    software-properties-common

# Created work dir
RUN mkdir -p /home/docker

# Clear cache
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /home/docker

#CMD ["tail", "-f", "/dev/null"]
CMD ["/bin/bash", "./docker-download.sh"]