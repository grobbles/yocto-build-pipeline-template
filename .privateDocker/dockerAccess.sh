#!/bin/bash

############################################################################################################
## Constant Block
IMAGE_NAME="yocto_private_build_environment"

############################################################################################################
## Description Function Block
function usage {
cat << EOF

Usage: $0 <arguments>

Arguments:
    -h, --help      : print the help description

    -s, --start     : start the container in a terminal session for tests

    -k, --kill      : stop the container

    -c, --console   : open a console to the container

    -y, --yocto     : start a yocto build process 
                        -> mount all resources in the container

    -r, --rm        : remove the image

    -p, --prune     : The docker system prune command will remove all stopped containers, all dangling images, and all unused networks.

    -b, --build     : build the docker image from Dockerfile

EOF
}

############################################################################################################
## Start Function Block
function removeAllUnusedDockerObjects(){
    docker system prune -f
}

function removeDockerImage(){
    docker image rm -f $IMAGE_NAME
}

function buildDocker(){
    docker build --tag $IMAGE_NAME . 
}

function startDocker(){
    docker run -it --rm \
        --volume="${HOME}/.ssh:/home/${USER}/.ssh" \
        --volume="${HOME}/.gitconfig:/home/${USER}/.gitconfig" \
        --env=HOST_UID=$(id -u) \
        --env=HOST_GID=$(id -g) \
        --env=USER=${USER} \
        --name=$CONTAINER \
        --workdir=${HOME} \
        $IMAGE_NAME
}

function yoctoBuildDocker(){
    workDirectory=$1
    downloadDirectory=$2
    proxy=$3

    docker run -it --rm \
        --volume="${HOME}/.ssh:/home/${USER}/.ssh" \
        --volume="${HOME}/.gitconfig:/home/${USER}/.gitconfig" \
        --volume="${HOME}/.git-credentials:/home/${USER}/.git-credentials" \
        --volume="$workDirectory/:/home/${USER}/yocto/" \
        --volume="$downloadDirectory/:/home/${USER}/yocto/build/downloads" \
        --env=HTTP_PROXY=$proxy\
        --env=HTTPS_PROXY=$proxy \
        --env=HOST_UID=$(id -u) \
        --env=HOST_GID=$(id -g) \
        --env=USER=${USER} \
        --name=$CONTAINER \
        --workdir=${HOME} \
        -v $(readlink -f $SSH_AUTH_SOCK):/ssh-agent \
        -e SSH_AUTH_SOCK=/ssh-agent \
        $IMAGE_NAME \
        "/bin/bash -c source /home/roder/yocto/poky/oe-init-build-env /home/roder/yocto/build && bitbake core-image-minimal" 
}

function openContainerConsole(){
    containerId=$(docker ps | grep $IMAGE_NAME | awk -e '{print $1}')
    docker exec -it $containerId bash
}

function killContainer(){
    containerId=$(docker ps | grep $IMAGE_NAME | awk -e '{print $1}')
    docker stop $containerId 
}

############################################################################################################
## Start Main Block
case "$1" in
    -h | --help)
            echo "remove docker image: $IMAGE_NAME"
            usage
            exit $?
        ;;

    -r | --rm)
            echo "remove docker image: $IMAGE_NAME"
            removeDockerImage
            exit $?
        ;;
            
    -p | --prune)
            echo "remove all unused docker objects from system"
            removeAllUnusedDockerObjects
            exit $?
        ;;

    -b | --build)
            echo "build a new docker image: $IMAGE_NAME"
            buildDocker
            exit $?
        ;;

    -k | --kill)
            echo "kill Container: $IMAGE_NAME"
            killContainer
            exit $?
        ;;

    -c | --console)
            echo "open Container Console: $IMAGE_NAME"
            openContainerConsole
            exit $?
        ;;

    -s | --start)
            echo "start docker container: $IMAGE_NAME"
            startDocker
            exit $?
        ;;

    -y | --yocto)
            workDirectory=$2
            if [ -z "$workDirectory" ]; then
                echo "ERROR: We need workDirectory to be set!"
                exit 100
            fi

            downloadDirectory=$3
            if [ -z "$downloadDirectory" ]; then
                echo "ERROR: We need downloadDirectory to be set!" 
                exit 100
            fi

            proxy=$4
            if [ -z "$proxy" ]; then
                echo "ERROR: We need proxy to be set!"
                proxy=$PROXY
            fi

            echo "start docker container: $IMAGE_NAME with WorkDirectory: $workDirectory and downloadDirectory: $downloadDirectory"
            yoctoBuildDocker $workDirectory $downloadDirectory $proxy
            exit $?
        ;;

    *)
            usage
            exit $?
        ;;
esac
## End Main Block
############################################################################################################
