# docker-offline-install
Instructions and scripts for installing Docker Engine in an offline / standalone environment.

This is useful for installing Docker engine on servers that don't or cannot have an internet connection.
Usually you would install Docker using package manager, but that of course requires the server to be connected to the internet.
One solution is to mirror the entire repository, but because of its size, this solution is not practical.

Thankfully, Docker manages their own repository for the Docker-Engine, including direct dependencies (see prerequisites).
Using a separate internet connected (online) computer, you can download the Docker repository, copy it using some media (i.e. cdrom, usb) to the target computer / server and install it using apt-get.

The included scripts utilize [**apt-mirror**](http://apt-mirror.github.com) for downloading the Docker repository.

The official Docker documentation for [installing Docker on Ubuntu](https://docs.docker.com/engine/install/ubuntu/) was also helpful writing these scripts. Make sure you comply to Docker's prerequisites before trying to install on Ubuntu.

The official Docker documentation for [installing Docker on Debian](https://docs.docker.com/engine/install/debian/) was also helpful writing these scripts. Make sure you comply to Docker's prerequisites before trying to install on Debian.

## Prerequisites:
* Check Docker's [dependencies](https://docs.docker.com/engine/installation/binaries/#check-runtime-dependencies)
  to make sure you have the basic dependencies installed on the target computer (i.e. iptables, apparmor).
  These are usually already installed in typical installations, but may be missing in some cases.
* Supported architectures (*amd64, armhf, arm64, ppc64el, s390x*)
* Supported distributive (*Ubuntu, Debian*)
* An online computer (a.k.a *source*)
* An offline / standalone computer (a.k.a *target*)
* **sudo** (*root*) privileges on both *source* and *target* computers
* Some sort of media to copy the included scripts and mirrored repository to the *target*
 

## Instructions
***
**Please Note:** Currently, the scripts are success oriented, no error checking is done. 
Please check the console output for any warnings/errors that may occur during the process.
***

### On the source (online) computer a manual mode:
1. [Download](https://github.com/dima-bzz/docker-offline-install/archive/master.zip) the scripts, or clone using git.
2. Extract the zip (you might need to install unzip).
3. cd into the relevant distribution directory of the scripts
   `cd Ubuntu`
4. Run the download script with sudo: `sudo ./docker-download.sh`
5. If all goes well, there should be gzip file named *docker_mirror.release.architecture.tar.gz* in the directory you ran the script from.
   Copy this file, **and** the *docker-install.sh* script to your media (i.e. cdrom, usb etc...)
   
### On the source (online) computer a auto mode using docker:
1. [Download](https://github.com/dima-bzz/docker-offline-install/archive/master.zip) the scripts, or clone using git.
2. Extract the zip (you might need to install unzip).
3. cd into extract archive directory.
4. Copy env-default to .env
   `cp env-default .env`
5. Uncomment what do you want downloaded, *RELEASE* and *ARCH* for your distributive.
6. Run docker-compose for your distributive `docker-compose up -d --build ubuntu-docker-offline`
7. Run `docker-compose logs -f` for view logs.
8. If all goes well, there should be gzip file named *docker_mirror.release.architecture.tar.gz* in the directory your distributive.
   Copy this file, **and** the *docker-install.sh* script to your media (i.e. cdrom, usb etc...)

### On the target (offline) computer:
1. Copy the *docker_mirror.release.architecture.tar.gz* and the *docker-install.sh* from the media to a writeable directory on the target.
2. Run the install script with sudo: `sudo ./docker-install.sh` (no need to extract the gzip, the script will do it for you).
3. If all goes well, Docker should be installed now. Test the installation by running: `docker ps`, you should get an empty list of running containers.

That's it!

## Security
These scripts copy Docker repository public key, so that the Release.gpg signature file can be verified 
during the offline install, just like apt-get does when installing online.

## Testing with docker
1. Test environment:
    * Ubuntu (14.04 amd64)
    * Debian (7.11 amd64)
2. cd into extract archive directory.
3. There should already be an archive inside the directory for test environment.
4. Run docker-compose for your distributive `docker-compose up -d --build ubuntu-test`
5. Go inside the container `docker-compose exec ubuntu-test bash`
6. Run command install `./docker-install.sh`
7. Run command to check version `docker version`

## Troubleshooting
* Cannot run scripts:
  * Downloaded scripts should already have executable file mode. 
  If not, try to run `sudo chmod +x *.sh` in the script directory (on *source* and *target* computers).
  * Make sure you are running the scripts using `sudo`
* Unable to install Docker on target:
  * Make sure you have dependencies mentioned above installed on the target.
* Other problems:
  * Check console outputs, they may give you clue about the problem.
  * Keep in touch, maybe I can help...


