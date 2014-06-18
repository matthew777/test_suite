#!/bin/bash

apt-get update

# for kernelbuild test
apt-get -y --force-yes install wget \
                               build-essential \
                               uboot-mkimage \
                               linux-libc-dev \
                               libtool

apt-get -y --force-yes install dosfstools
