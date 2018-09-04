#!/bin/bash
# $2 - "-debug/"
# $1 - where to install
cd /opt/checkout
git submodule foreach --recursive git reset --hard
./init-repository -f --module-subset=default,-qtwebkit,-qtwebkit-examples,-qtwebengine
echo "##teamcity[buildNumber '`git describe --first-parent --abbrev=7`']"
PLACE=`grep MODULE_VERSION qtbase/.qmake.conf | sed -e 's,^[^=]* = ,,'`
if [ "x$PLACE" == "x" ]; then
    PLACE=$1
fi
mkdir -p /opt/build/_install_
mkdir -p /opt/build/_build_
cd /opt/build/_build_
export CCACHE_PREFIX=icecc
export PATH=/usr/lib/ccache:$PATH
/opt/checkout/configure $2 -opensource -confirm-license \
        -nomake examples -nomake tests -opengl es2 \
        -prefix /opt/qt/auto/${PLACE}
make -j 30
make install INSTALL_ROOT=/opt/build/_install_ 
