#!/bin/bash
set -e
git clone git@git.pelagicore.net:uxteam/qtas-demo-manifest.git

MANIFEST_PUSH=0

pushd qtas-demo-manifest
../TeamCityDockerScripts/DocumentationSDK/SyncManifestWithPelux/sync.py pelux.xml "../$1/pelux.xml"
git config user.email "nzamotaev@luxoft.com"
git config user.name "TeamCity server"
T=`git diff`
if [ "x$T" == "x" ];then
    echo "No change to manifests"
else
    echo "Comitting changes"
    (   echo "Automatic sync with PELUX manifests"
    ) | git commit -F - pelux.xml
    MANIFEST_PUSH=1
fi
popd

if [ "$MANIFEST_PUSH" == "1" ]; then
    pushd qtas-demo-manifest
    git push
    popd
fi
