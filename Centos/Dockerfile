ARG RELEASE=7.8.2003
FROM amd64/centos:${RELEASE}

RUN yum install -y epel-release.noarch yum-utils glibc-langpack-en ncurses

# Created work dir
RUN mkdir -p /home/docker

# Set working directory
WORKDIR /home/docker

#CMD ["tail", "-f", "/dev/null"]
CMD ["/bin/bash", "./docker-download.sh"]