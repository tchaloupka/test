#!/bin/sh
echo "root=${ROOT_FOLDER}"
echo "pwd=$PWD"
cd testrepo
echo -n "version="`git describe | tr -d '\n'` > files/build.properties
ls -la /
ls -la /build
ls -la /files
ls -la ${ROOT_FOLDER}
