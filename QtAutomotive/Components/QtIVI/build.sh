#!/bin/bash
# $2 - "-debug/"
# $1 - where to install
cd /opt/checkout/sources/
export CCACHE_PREFIX=icecc
export PATH=/usr/lib/ccache:$PATH
echo "##teamcity[buildNumber '`git describe --abbrev=7`']"
QMAKE=`find /opt/qt -name qmake`
$QMAKE -config enable-tests
make -j 5
echo "##teamcity[blockOpened name='Coverage']"
make -j 5 coverage
echo "##teamcity[blockClosed name='Coverage']"
make install INSTALL_ROOT=/opt/build/_install_
echo "##teamcity[blockOpened name='Install']"
make install
echo "##teamcity[blockClosed name='Install']"
echo "##teamcity[blockOpened name='Check-coverage']"
Xvfb :1 -ac -screen 0 1024x758x24 &
export DISPLAY=:1
make check-coverage TESTARGS="-o -,txt -o result.xml,xml"
kill %1
echo "##teamcity[blockClosed name='Check-coverage']"
