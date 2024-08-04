#!/bin/sh

echo "Staring NVIDIA Fabric Manager installation"

echo "Checking for running Fabric Manager service"

STATUS=`systemctl is-active nvidia-fabricmanager`
  if [ ${STATUS} = 'active' ]; then
    echo "Fabric Manager service is running, stopping the same....."
    systemctl stop nvidia-fabricmanager
  else 
    echo "Fabric Manager service is not running....."
  fi

# copy all the files
echo "Copying files to desired location"
# choose lib location based on system arch
ARCH_TYPE_CMD=`uname -m`
LIB_LOC="/usr/lib/x86_64-linux-gnu"
if [ ${ARCH_TYPE_CMD} = 'aarch64' ]; then
    echo "detected aarch64 and changing lib location to /usr/lib/aarch64-linux-gnu...."
    LIB_LOC="/usr/lib/aarch64-linux-gnu"
fi

cp ${PWD}/libnvfm.so.1 ${LIB_LOC}
cp -P ${PWD}/libnvfm.so   ${LIB_LOC}

cp ${PWD}/nv-fabricmanager  /usr/bin
cp ${PWD}/nvswitch-audit  /usr/bin
cp ${PWD}/nvidia-fabricmanager.service  /lib/systemd/system

mkdir /usr/share/nvidia  > /dev/null 2>&1
mkdir /usr/share/nvidia/nvswitch/  > /dev/null 2>&1
cp ${PWD}/dgx2_hgx2_topology    /usr/share/nvidia/nvswitch/
cp ${PWD}/dgxa100_hgxa100_topology    /usr/share/nvidia/nvswitch/
cp ${PWD}/dgxh100_hgxh100_topology    /usr/share/nvidia/nvswitch/
cp ${PWD}/dgxh800_hgxh800_topology    /usr/share/nvidia/nvswitch/
cp ${PWD}/fabricmanager.cfg  /usr/share/nvidia/nvswitch/

cp ${PWD}/nv_fm_agent.h     /usr/include
cp ${PWD}/nv_fm_types.h     /usr/include

mkdir /usr/share/doc/nvidia-fabricmanager > /dev/null 2>&1
cp ${PWD}/LICENSE  /usr/share/doc/nvidia-fabricmanager
cp ${PWD}/third-party-notices.txt  /usr/share/doc/nvidia-fabricmanager

# enable Fabric Manager service
systemctl enable nvidia-fabricmanager

# let the user start FM service manually.
echo "Fabric Manager installation completed."
echo "Note: Fabric Manager service is not started. Start it using systemctl commands (like systemctl start nvidia-fabricmanager)"
