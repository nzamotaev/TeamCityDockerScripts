#!/bin/bash
# $2 - "-debug/"
# $1 - where to install
set -e
cd /opt/checkout/sources/
export CCACHE_PREFIX=icecc
export PATH=/usr/lib/ccache:$PATH
QMAKE=`find /opt/qt -name qmake`
echo "Pri file:"
find /opt/qt -name qt_lib_appman_main_private.pri
echo "Qmake location"
echo $QMAKE
$QMAKE HERE_SDK=/opt/carlo_sdk/ ./neptune3-ui.pro
make -j 5
make install INSTALL_ROOT=/opt/build/_install_
