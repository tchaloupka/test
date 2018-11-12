#!/bin/sh
echo "pwd=$PWD"
cd testrepo
echo -n "version="`git describe | tr -d '\n'` > ../files/build.properties
cd ..
ls -la $PWD
ls -la $PWD/files
ls -la $PWD/testrepo

