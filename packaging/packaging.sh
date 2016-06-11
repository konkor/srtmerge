#!/bin/bash

VERSION="1.0"

rm -rf debs
mkdir debs
cd debs
ln -s ../../srtmerge-$VERSION.tar.gz srtmerge_$VERSION.orig.tar.gz
tar xf srtmerge_$VERSION.orig.tar.gz
cd srtmerge-$VERSION
cp -r ../../../debian/ .
debuild -us -uc
