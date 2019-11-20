#!/bin/bash
set -e
test "x$1" != "x"
echo Triton revision: "$1"
#git clone git@git.pelagicore.net:uxteam/meta-qtas-demo.git
git clone git@github.com:Luxoft/meta-qt-auto-internal.git

META_PUSH=0

pushd meta-qt-auto-internal
git config user.email "nzamotaev@luxoft.com"
git config user.name "TeamCity server"
FILENAME="`find ./ -name neptune3-ui_git.bbappend;find ./ -name neptune3-ui_git.bb`"
echo BB file: $FILENAME
test -f "$FILENAME" 

OLDHASH=`grep SRCREV $FILENAME|awk -F= '{print $2}'|sed 's/^[ \"]*//;s/[\" ]*$//'`
NEWHASH=$1

sed "s/SRCREV *= *\".*\"/SRCREV = \"$1\"/" -i "$FILENAME"
if [ "x$3" != "x" ]; then
#Branch switching for neptune3-ui.
    BRANCH=`echo $3|awk -F/ '{print $NF}'`
    echo $BRANCH > _branches/neptune3-ui
    sed "s/\(SRC_URI *= *\"git:.*branch=\).*\(;user=\)/\1${BRANCH}\2/" -i "$FILENAME"
fi
T=`git diff`
if [ "x$T" == "x" ];then
    echo "No change to meta-qt-auto-internal"
else
    echo "Comitting changes"
    (   echo "Neptune3: Automatic update to the latest version of Neptune3-UI"
        echo "Changes:"
        cd "$2"
        git log --pretty=format:"%h%x09%an%x09%ad%x09%s" ${OLDHASH}..${NEWHASH} 
    ) | git commit -F - "$FILENAME"
    META_PUSH=1
fi
popd

if [ "$META_PUSH" == "1" ]; then
    pushd meta-qt-auto-internal
    git push
    popd
fi

