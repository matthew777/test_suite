#!/bin/bash

apt-get update

# for kernelbuild test
apt-get -y --force-yes install wget \
                               build-essential \
                               u-boot-tools \
                               linux-libc-dev \
                               libtool \
                               gcc \
                               make

# for general usage
apt-get -y --force-yes install dosfstools \
                               usbutils \
                               pciutils \
                               make \
                               wget \
                               openssh-server

# for multimedia test
apt-get -y --force-yes install alsa-utils \
                               libgstreamer0.10-0 \
                               gstreamer0.10-plugins-base \
                               gstreamer0.10-plugins-bad \
                               gstreamer0.10-plugins-good \
                               gstreamer0.10-plugins-ugly \
                               gstreamer-tools \
                               gstreamer0.10-alsa \
