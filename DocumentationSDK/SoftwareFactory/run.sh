#!/bin/bash
# $1 - teamcity temp dir
# $2 - teamcity source checkout dir
ContainerName=softwarefactory
ImageName=softwarefactory
Build=`readlink -f $1`
Checkout=`readlink -f $2`
ScriptDir=`readlink -f \`pwd\``
Volumes="-v ${Build}:/opt/build -v ${Checkout}:/opt/checkout -v ${ScriptDir}:/opt/scripts"

echo "##teamcity[blockOpened name='Building docker image']"
cp ${2}/Dockerfile ./
docker build -t $ImageName .
echo "##teamcity[blockClosed name='Building docker image']"

echo "##teamcity[blockOpened name='Remove docker container']"
docker rm -f $ContainerName 
echo "##teamcity[blockClosed name='Remove docker container']"

echo "##teamcity[blockOpened name='Build process']"
docker run -u `id -u $USER` --name="$ContainerName" $Volumes $ImageName /bin/bash -c "/opt/scripts/build.sh"
echo "##teamcity[blockClosed name='Build process']"
