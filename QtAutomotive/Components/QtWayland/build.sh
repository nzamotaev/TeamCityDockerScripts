#!/bin/bash
# $2 - "-debug/"
# $1 - where to install
cd /opt
ls -la /opt/checkout/qt/
ls -la /opt/checkout/
ls -la /opt/
tar xfv /opt/checkout/qt/qt.tar.gz
cd /opt/checkout/sources/
export CCACHE_PREFIX=icecc
export PATH=/usr/lib/ccache:$PATH
qmake
make -j 10
make install INSTALL_ROOT=/opt/build/_install_ 
