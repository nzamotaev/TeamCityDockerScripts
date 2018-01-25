#!/bin/bash
set -e
test "x$1" == "x"
echo Triton revision: %system.build.vcs.number.QtAutomotive_Components_HttpsGitLfsQtIoGerritTritonUiGit%
git clone git@git.pelagicore.net:uxteam/meta-qtas-demo.git
git clone git@git.pelagicore.net:uxteam/qtas-demo-manifest.git

META_PUSH=0
MANIFEST_PUSH=0

pushd meta-qtas-demo
git config user.email "nzamotaev@luxoft.com"
git config user.name "TeamCity server"
FILENAME="`find ./ -name triton-ui_git.bb`"
echo BB file: $FILENAME
test -f "$FILENAME"
sed 's/SRCREV *= *".*"/SRCREV = "%system.build.vcs.number.QtAutomotive_Components_HttpsGitLfsQtIoGerritTritonUiGit%"/' -i "$FILENAME"
T=`git diff`
if [ "x$T" == "x" ];then
    echo "No change to meta-qtas-demo"
else
    git commit -m "Triton: Automatic update to the latest version of Triton" "$FILENAME"
    META_PUSH=1
fi
REVISION="`git rev-parse HEAD`"
echo $REVISION
popd

pushd qtas-demo-manifest
ls -la
../TeamCityDockerScripts/DocumentationSDK/UpdateTritonVersion/pelux_parse.py pelux.xml "$REVISION"
git config user.email "nzamotaev@luxoft.com"
git config user.name "TeamCity server"
T=`git diff`
if [ "x$T" == "x" ];then
    echo "No change to manifests"
else
    git commit -m "Automatic update to the latest version of meta-qtas-demo" pelux.xml
    MANIFEST_PUSH=1
fi
popd

if [ "$META_PUSH" == "1" ]; then
    pushd meta-qtas-demo
    git push
    popd
fi

if [ "$MANIFEST_PUSH" == "1"]; then
    pushd qtas-demo-manifest
    git push
    popd
fi
