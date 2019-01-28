#!/bin/bash
set -e
test "x$1" != "x"
echo meta-qtas-demo revision: "$1"
git clone git@git.pelagicore.net:uxteam/qtas-demo-manifest.git

MANIFEST_PUSH=0

pushd qtas-demo-manifest
OLDREV=`../TeamCityDockerScripts/DocumentationSDK/UpdateManifest/pelux_parse.py pelux.xml "$1"`
NEWREV="$1"
git config user.email "nzamotaev@luxoft.com"
git config user.name "TeamCity server"
T=`git diff`
if [ "x$T" == "x" ];then
    echo "No change to manifests"
else
    echo "Comitting changes"
    (   echo "Automatic update to the latest version of meta-qtas-demo"
        echo "Changes:"
        cd "$2"
        git log ${OLDREV}..${NEWREV}
    ) | git commit -F - pelux.xml
    MANIFEST_PUSH=1
fi
popd

if [ "$MANIFEST_PUSH" == "1" ]; then
    pushd qtas-demo-manifest
    git push
    popd
fi
