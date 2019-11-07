#!/bin/bash

############################################################################################################
## Constant Block

############################################################################################################
## Description Function Block
function usage {
cat << EOF

Usage: $0 <arguments>

Arguments:
    -h | --help         : print the help description

    -bd | --buildDocker       : build docker stuff
              -> parmeter: path to mount in the work directory

    -td | --testDocker       : testdocker stuff
              -> parmeter: path to mount in the work directory

EOF
}

############################################################################################################
## Start Function Block
function testDockerStuff(){
    cd ./.jenkinsTestDocker/
    ./dockerAccess.sh $@
    cd ..
}

function buildDockerStuff(){
    cd ./.privateDocker/
    ./dockerAccess.sh $@
    cd ..
}

############################################################################################################
## Start Main Block
case "$1" in
    -h | --help)
        echo "remove docker image: $IMAGE_NAME"
        usage
        exit $?
    ;;
    
    -td | --testDocker)
        echo "test docker stuff ${@:2}"
        testDockerStuff ${@:2}
        exit $?
    ;;
    
    -bd | --buildDocker)
        echo "build docker stuff ${@:2}"

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

        buildDockerStuff ${@:2}
        exit $?
    ;;

    *)
        usage
        exit $?
    ;;
esac
## End Main Block
############################################################################################################