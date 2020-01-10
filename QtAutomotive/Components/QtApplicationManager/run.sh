#!/bin/bash
# $1 - teamcity temp dir
# $2 - teamcity source checkout dir
ContainerName=qt5appman
ImageName=qt5appman
Build=`readlink -f $1`
Checkout=`readlink -f $2`
ScriptDir=`readlink -f \`pwd\``
mkdir -p ${HOME}/.ccache1
Volumes="-v ${Build}:/opt/build -v ${Checkout}:/opt/checkout -v ${ScriptDir}:/opt/scripts -v /var/run/icecc:/var/run/icecc -v ${HOME}/.ccache1:/.ccache"

echo "##teamcity[blockOpened name='Building docker image']"
docker build --pull=false -t $ImageName . 
echo "##teamcity[blockClosed name='Building docker image']"

echo "##teamcity[blockOpened name='Remove docker container']"
docker rm -f $ContainerName 
echo "##teamcity[blockClosed name='Remove docker container']"

echo "##teamcity[blockOpened name='Build process']"
docker run -u `id -u $USER` --name="$ContainerName" $Volumes $ImageName /bin/bash -c "/opt/scripts/build.sh $3 $4"
echo "##teamcity[blockClosed name='Build process']"
