#!/bin/bash

apt-get update

# for kernelbuild test
apt-get -y --force-yes install wget \
                               build-essential \
                               uboot-mkimage \
                               linux-libc-dev \
                               libtool
# for general usage
apt-get -y --force-yes install dosfstools \
                               usbutils \
                               pciutils

# for multimedia test
apt-get -y --force-yes install alsa-utils \
                               libgstreamer0.10-0 \
                               gstreamer0.10-plugins-base \
                               gstreamer0.10-plugins-bad \
                               gstreamer0.10-plugins-good \
                               gstreamer-tools \
                               gstreamer0.10-alsa \
                               gstreamer0.10-ffmpe
