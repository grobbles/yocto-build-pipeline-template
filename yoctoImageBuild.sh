#!/bin/bash

WORKSPACE=$1
echo "WORKSPACE = $WORKSPACE"
ls -la $WORKSPACE
ls -la $WORKSPACE/yocto
ls -la $WORKSPACE/yocto/build
ls -la $WORKSPACE/yocto/build/downloads

echo "Create build environment"
source $WORKSPACE/yocto/poky/oe-init-build-env $WORKSPACE/yocto/build

echo "start build process"
bitbake core-image-minimal