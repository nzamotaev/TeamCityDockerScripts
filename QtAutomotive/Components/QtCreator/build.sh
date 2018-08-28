#!/bin/bash
# $2 - "-debug/"
# $1 - where to install
/usr/sbin/iceccd -d --no-remote -l /tmp/iceccd.log --nice 5 -s 192.168.5.1 -b /tmp/icecc -m 0
cd /opt/checkout/sources/
export CCACHE_PREFIX=icecc
export PATH=/usr/lib/ccache:$PATH
echo "##teamcity[buildNumber '`git describe --abbrev=7`']"
QMAKE=`find /opt/qt -name qmake`
$QMAKE -r
make -j 5
make install INSTALL_ROOT=/opt/build/_install_
killall iceccd
