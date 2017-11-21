#!/bin/bash
# $1 - teamcity temp dir
# $2 - teamcity source checkout dir
set -e 
FootprintFile=.image
ContainerName=Qt5build
ImageName=Qt5build
Volumes="-v $1:/opt/build -v $2:/opt/checkout"
shift 2
ARGS=$@

if [ ! -f $FootprintFile ]; then
    echo "##teamcity[blockOpened name='Building docker image']"
    docker build -t $ImageName . 
    touch $FootprintFile
    echo "##teamcity[blockClosed name='Building docker image']"
fi

docker ps -a | grep -q $ContainerName > /dev/null
if [[ $? -eq 0 ]]; then
    echo "##teamcity[blockOpened name='Remove docker container']"
    docker rm $ContainerName 2>/dev/null
    echo "##teamcity[blockClosed name='Remove docker container']"
fi

echo "##teamcity[blockOpened name='Build process']"
docker run -t --name="$ContainerName" $Volumes $ImageName /bin/bash -c $ARGS
echo "##teamcity[blockClosed name='Build process']"
