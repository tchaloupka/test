#!/bin/bash

# Builds a docker image debian package
# Expected parameters:
#	* path to docker image directory downloaded using https://github.com/concourse/docker-image-resource
#	* path to the version file to use as a package version
#	* path to place the resulting image to

set -e

if ! [ -n "$1" ]; then echo "Missing path to docker image directory"; return 1; fi
if ! [ -d "$1" ]; then echo "Docker image directory not found"; return 1; fi

if ! [ -n "$2" ]; then echo "Missing path to version file"; return 1; fi
if ! [ -f "$2" ]; then echo "Version file not found"; return 1; fi

if ! [ -n "$3" ]; then echo "Missing path to target directory"; return 1; fi
if ! [ -d "$3" ]; then echo "Target directory not found"; return 1; fi

# Prepare the basic package structure
TMP_PKG_DIR="/tmp/dockerimg"
mkdir -p "$TMP_PKG_DIR/DEBIAN"
mkdir -p "$TMP_PKG_DIR/usr/share/ivisec/docker"

NAME=$(cat "$1"/repository | tr -d '\n')
NAME=${NAME#*/}

VERSION=$(cat "$2" | tr -d '\n')
SIZE=$(du "$1"/image | cut -f1)

cat <<EOT >> "$TMP_PKG_DIR/control"
Package: ivisec-${NAME}
Version: ${VERSION}
Architecture: any
Section: ivisec
Priority: optional
Installed-Size: ${SIZE}
Depends: docker-ce
Maintainer: info@ivisec.com
Homepage: www.ivisec.com
Description: Docker image package
EOT

cat "$TMP_PKG_DIR/control"
