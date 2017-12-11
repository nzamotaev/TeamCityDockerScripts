#!/bin/bash
# $2 - "-debug/"
# $1 - where to install
cd /
tar xv /opt/checkout/qt/qt.tar.gz
cd /opt/checkout/sources/
export CCACHE_PREFIX=icecc
export PATH=/usr/lib/ccache:$PATH
QMAKE=`find /opt/qt -name qmake`
$QMAKE
make -j 10
make install INSTALL_ROOT=/opt/build/_install_ 
