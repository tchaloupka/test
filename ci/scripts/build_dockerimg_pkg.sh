#!/bin/bash

# Builds a docker image debian package
# Expected parameters:
#	* path to docker image directory downloaded using https://github.com/concourse/docker-image-resource
#	* path to place the resulting image to

set -e

if ! [ -n "$1" ]; then
	echo "Missing path to docker image directory"
	return 1
fi

if ! [ -n "$2" ]; then
	echo "Missing path to target directory"
	return 1
fi

# Prepare the basic package structure
TMP_PKG_DIR="/tmp/dockerimg"
mkdir -p "$TMP_PKG_DIR/DEBIAN"
mkdir -p "$TMP_PKG_DIR/usr/share/ivisec/docker"
ls -la "$1"
