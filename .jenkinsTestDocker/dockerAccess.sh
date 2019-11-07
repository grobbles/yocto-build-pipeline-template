#!/bin/bash

############################################################################################################
## Constant Block
IMAGE="yocto_test_environment"

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
    docker image rm -f $IMAGE
}

function buildDocker(){
    docker build --tag $IMAGE . 
}

function startDocker(){
    docker run -it --rm \
        --user $(id -u):$(id -g) \
        --volume $PWD:/home/testEnvironment/ \
        --workdir /home/testEnvironment/ \
        $IMAGE
}

function executeTest(){
    testPath=$1
    docker run --rm \
        --user $(id -u):$(id -g) \
        --volume $testPath:/home/testEnvironment/ \
        --workdir /home/testEnvironment/ \
        $IMAGE pytest . --junitxml=./testOutput/testResults.xml
}

function openContainerConsole(){
    containerId=$(docker ps | grep ${IMAGE} | awk -e '{print $1}')
    docker exec -it $containerId bash
}

function killContainer(){
    containerId=$(docker ps | grep ${IMAGE} | awk -e '{print $1}')
    docker stop $containerId 
}

############################################################################################################
## Start Main Block
case "$1" in
    -h | --help)
            echo "remove docker image: $IMAGE"
            usage
            exit $?
        ;;

    -r | --rm)
            echo "remove docker image: $IMAGE"
            removeDockerImage
            exit $?
        ;;
    
    -p | --prune)
            echo "remove all unused docker objects from system"
            removeAllUnusedDockerObjects
            exit $?
        ;;

    -b | --build)
            echo "build a new docker image: $IMAGE"
            buildDocker
            exit $?
        ;;

    -k | --kill)
            echo "kill Container: $IMAGE"
            killContainer
            exit $?
        ;;

    -c | --console)
            echo "open Container Console: $IMAGE"
            openContainerConsole
            exit $?
        ;;

    -s | --start)
            echo "start docker container: $IMAGE"
            startDocker
            exit $?
        ;;

    -t | --test)
            echo "test docker container with mounted volume $2: $IMAGE"
            executeTest $2
            exit $?
        ;;

    *)
            usage
            exit $?
        ;;
esac
## End Main Block
############################################################################################################