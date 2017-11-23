#!/bin/bash
# $2 - "-debug/"
# $1 - where to install
cd /opt/checkout
export CCACHE_PREFIX=icecc
export PATH=/usr/lib/ccache:$PATH
mkdir -p /opt/build/_install_
mkdir -p /opt/build/_build_
cd /opt/build/_build_
qmake -r
make -j 5
make install INSTALL_ROOT=/opt/build/_install_
