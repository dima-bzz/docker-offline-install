FROM amd64/debian:7.11

# Copy sources.list
COPY sources.test.list /etc/apt/sources.list

# Updating repositories and installing dependencies
RUN apt-get update && apt-get install -y --force-yes \
    perl-base=5.14.2-21+deb7u3 \
    lsb-release \
    perl \
    netbase \
    aufs-tools \
    ca-certificates \
    init-system-helpers \
    cgroupfs-mount \
    git \
    pigz

# Created work dir
RUN mkdir -p /home/docker

# Clear cache
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /home/docker

CMD ["tail", "-f", "/dev/null"]
#CMD ['/bin/bash', './docker-install.sh']