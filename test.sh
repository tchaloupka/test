#!/bin/sh

cd testrepo
echo -n "version="`git describe | tr -d '\n'` > files/build.properties
ls -la /
ls -la /build
ls -la /files
