#!/bin/bash
cd /opt/checkout
cmake -H. -Bbuild -DENABLE_PDF=OFF
cd build
make -j `nproc`
cd ..
mv build/docs/html/ /opt/build/_install_/

