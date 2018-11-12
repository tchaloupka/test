#!/bin/sh

cd testrepo
echo "version="`git describe | trim -n '\n'` > files/build.properties
ls -la /
ls -la /build
ls -la /files
