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

NAME=$(cat "$1/repository" | tr -d '\n')
NAME=${NAME#*/}

VERSION=$(cat "$2" | tr -d '\n')
SIZE=$(du "$1/image" | cut -f1)

cat <<EOF > "$TMP_PKG_DIR/DEBIAN/control"
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
EOF

echo "control:"
cat "$TMP_PKG_DIR/DEBIAN/control"

cat <<EOF > "$TMP_PKG_DIR/DEBIAN/postinst"
#!/bin/bash
set -e

case $1 in
configure)
	# Load the image to docker
	docker load < /usr/share/ivisec/docker/$NAME
	;;
esac
EOF

echo ""
echo "postinst:"
cat "$TMP_PKG_DIR/DEBIAN/postinst"

cp "$1/image" "$TMP_PKG_DIR/usr/share/ivisec/docker/$NAME"

dpkg-deb --root-owner-group -b -Zxz -z9 "$TMP_PKG_DIR" "$3/ivisec-$NAME.deb"
