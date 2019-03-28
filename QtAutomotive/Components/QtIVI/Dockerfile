FROM ubuntu:xenial
MAINTAINER Nikolay Zamotaev <nzamotaev@luxoft.com> 
ENV DEBIAN_FRONTEND noninteractive

RUN sed -i 's/^# deb-src /deb-src /g;s/archive.ubuntu.com/10.9.0.1:3142\/archive.ubuntu.com/g' /etc/apt/sources.list
RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup 
RUN echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache 
RUN apt-get clean && apt-get update && apt-get install -y locales
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN locale-gen en_US.UTF-8 
ENV LANG en_US.UTF-8 
ENV LANGUAGE en_US:en 
ENV LC_ALL en_US.UTF-8 
 
RUN echo "exit 101" > /usr/sbin/policy-rc.d 
RUN chmod +x /usr/sbin/policy-rc.d 
RUN mkdir /.ccache && chmod 777 /.ccache 
 
RUN apt-get update && \ 
    apt-get -y build-dep qt5-default && \
    apt-get install -y icecc ccache --no-install-recommends && \
    apt-get -y install \
        libxcb-xinerama0-dev \
        '^libxcb.*-dev' libx11-xcb-dev libglu1-mesa-dev \
        libxrender-dev libxi-dev libssl-dev libxcursor-dev \
        libxcomposite-dev libxdamage-dev libxrandr-dev \
        libdbus-1-dev libfontconfig1-dev libcap-dev \
        libxtst-dev libpulse-dev libudev-dev libpci-dev \
        libnss3-dev libasound2-dev libxss-dev libegl1-mesa-dev \
        gperf bison libwayland-dev libwayland-egl1-mesa \
        libwayland-server0 libgles2-mesa-dev libxkbcommon-dev \
        cmake zlib1g-dev libdbus-glib-1-dev \
        git-core
RUN chmod a+rwX /opt
RUN apt-get update && apt-get -y install libtag1-dev python3-dev python3-virtualenv xvfb
COPY qt/qt.tar.gz /tmp/
RUN tar xvf /tmp/qt.tar.gz -C /
COPY dlt/dlt.tar.gz /tmp/
RUN tar xvf /tmp/dlt.tar.gz -C /

