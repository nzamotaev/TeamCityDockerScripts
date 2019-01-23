#!/bin/bash
set -e
test "x$1" != "x"
echo Triton revision: "$1"
git clone git@git.pelagicore.net:uxteam/meta-qtas-demo.git

META_PUSH=0

pushd meta-qtas-demo
git config user.email "nzamotaev@luxoft.com"
git config user.name "TeamCity server"
FILENAME="`find ./ -name qtapplicationmanager_git.bbappend`"
echo BB file: $FILENAME
test -f "$FILENAME" 

OLDHASH=`grep SRCREV $FILENAME|awk -F= '{print $2}'|sed 's/^[ \"]*//;s/[\" ]*$//'`
NEWHASH=$1

sed "s/SRCREV *= *\".*\"/SRCREV = \"$1\"/" -i "$FILENAME"
T=`git diff`
if [ "x$T" == "x" ];then
    echo "No change to meta-qtas-demo"
else
    echo "Comitting changes"
    (   echo "Qt Application Manager: Automatic update to the latest version of AppMan"
        echo "Changes:"
        cd "$2"
        git log --pretty=format:"%h%x09%an%x09%ad%x09%s" ${OLDHASH}..${NEWHASH} 
    ) | git commit -F - "$FILENAME"
    META_PUSH=1
fi
popd

if [ "$META_PUSH" == "1" ]; then
    pushd meta-qtas-demo
    git push
    popd
fi

