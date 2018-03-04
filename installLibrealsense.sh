#!/bin/bash
set -x
# Install the Intel Realsense library librealsense on a Jetson TX2 Development Kit
# Copyright (c) 2016-17 Jetsonhacks 
# MIT License
INSTALL_DIR=$PWD
sudo apt-get update
sudo apt-get install libusb-1.0-0-dev pkg-config -y
sudo apt-get install libglfw3-dev -y
sudo apt-get install qtcreator -y
sudo apt-get install cmake-curses-gui -y
# Install librealsense into home directory
#cd $HOME/Downloads
git clone https://github.com/IntelRealSense/librealsense.git
cd librealsense
# Checkout version 1.12.1 of librealsense, last tested version
git checkout v1.12.1
# Patch the uvcvideo internal module fix
patch -p1 -i $INSTALL_DIR/patches/uvc-v4l2.patch
# Install Qt libraries
sudo scripts/install_qt.sh
# Copy over the udev rules so that camera can be run from user space
sudo cp config/99-realsense-libusb.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules && udevadm trigger
cd ..
rm -rf librealsense
cd "$HOME/Downloads"
mkdir librealsense_install
cd librealsense_install
wget "https://github.com/IntelRealSense/librealsense/archive/v2.10.0.tar.gz"
tar xvf "v2.10.0.tar.gz"
cd "librealsense-2.10.0"
sudo apt-get update && sudo apt-get upgrade && sudo apt-get dist-upgrade
sudo apt-get install libusb-1.0-0-dev pkg-config libgtk-3-dev
sudo apt-get install libglfw3-dev
mkdir build
cd build
cmake ../ -DBUILD_EXAMPLES=true
make -j4
echo "All done!"
# Now compile librealsense and install
#mkdir build && cd build
# Build examples, including graphical ones
#cmake ../ -DBUILD_EXAMPLES=true
# The library will be installed in /usr/local/lib, header files in /usr/local/include
# The demos, tutorials and tests will located in /usr/local/bin.
#make && sudo make install



