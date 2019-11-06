#!/bin/bash
# $2 - "-debug/"
# $1 - where to install
set -e
cd /opt/checkout/sources/
export CCACHE_PREFIX=icecc
export PATH=/usr/lib/ccache:$PATH
echo "##teamcity[buildNumber '`git describe --abbrev=7`']"
git submodule update --init
QMAKE=`find /opt/qt -name qmake`
$QMAKE -r
make -j 10
make install INSTALL_ROOT=/opt/build/_install_ 