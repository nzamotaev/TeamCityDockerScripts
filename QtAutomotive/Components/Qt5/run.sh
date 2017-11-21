#!/bin/bash
# $1 - teamcity temp dir
# $2 - teamcity source checkout dir
set -e 
FootprintFile=.image
ContainerName=qt5build
ImageName=qt5build
Build=`readlink -f $1`
Checkout=`readlink -f $2`
ScriptDir=`readlink -f \`pwd\``
Volumes="-v ${Build}:/opt/build -v ${Checkout}:/opt/checkout -v ${ScriptDir}:/opt/scripts"
shift 2
ARGS=$@

if [ ! -f $FootprintFile ]; then
    echo "##teamcity[blockOpened name='Building docker image']"
    docker build -t $ImageName . 
    touch $FootprintFile
    echo "##teamcity[blockClosed name='Building docker image']"
fi

set +e

docker ps -a | grep -q $ContainerName > /dev/null
if [[ $? -eq 0 ]]; then
    echo "##teamcity[blockOpened name='Remove docker container']"
    docker rm $ContainerName 
    echo "##teamcity[blockClosed name='Remove docker container']"
fi

echo "##teamcity[blockOpened name='Build process']"
docker run --name="$ContainerName" $Volumes $ImageName /bin/bash -c "$ARGS"
echo "##teamcity[blockClosed name='Build process']"
