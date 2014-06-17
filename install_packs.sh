#!/bin/bash

apt-get update

apt-get -y --force-yes install wget \
                               build-essential \
                               uboot-mkimage \
                               linux-libc-dev \
                               libtool
