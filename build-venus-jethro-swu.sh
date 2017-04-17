#!/bin/bash

. ./sources/openembedded-core/oe-init-build-env build sources/bitbake
export MACHINE=ccgx
bitbake venus-upgrade-image venus-install-sdcard

export MACHINE=beaglebone
bitbake venus-install-sdcard

export MACHINE=raspberrypi2
bitbake venus-swu venus-image
