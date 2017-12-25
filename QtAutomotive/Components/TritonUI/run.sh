#!/bin/bash
# $1 - teamcity temp dir
# $2 - teamcity source checkout dir
ContainerName=tritonui
ImageName=tritonui
Build=`readlink -f $1`
Checkout=`readlink -f $2`
ScriptDir=`readlink -f \`pwd\``
Volumes="-v ${Build}:/opt/build -v ${Checkout}:/opt/checkout -v ${ScriptDir}:/opt/scripts -v /var/run/icecc:/var/run/icecc"

echo "##teamcity[blockOpened name='Building docker image']"
docker build --pull=false -t $ImageName . 
echo "##teamcity[blockClosed name='Building docker image']"

echo "##teamcity[blockOpened name='Remove docker container']"
docker rm -f $ContainerName 
echo "##teamcity[blockClosed name='Remove docker container']"

echo "##teamcity[blockOpened name='Download carlo_sdk']"
mkdir -p here
wget -O here/sdk.tar.gz http://10.9.0.1/qtauto/carlo/carlo-sdk-07-Sep-desktop-debug-gcc5-with-resources.tar.gz
echo "##teamcity[blockClosed name='Download carlo_sdk']"

echo "##teamcity[blockOpened name='Build process']"
docker run -u `id -u $USER` --name="$ContainerName" $Volumes $ImageName /bin/bash -c "/opt/scripts/build.sh $3 $4"
echo "##teamcity[blockClosed name='Build process']"
