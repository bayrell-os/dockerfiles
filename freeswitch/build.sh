#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPT_PATH=`dirname $SCRIPT`
BASE_PATH=`dirname $SCRIPT_PATH`

RETVAL=0

case "$1" in

  download)
    mkdir -p install/download
	
    wget http://packages.irontec.com/public.key -O "install/download/IRONTEC"
    wget https://freeswitch.org/stash/projects/FS/repos/freeswitch/raw/yum/RPM-GPG-KEY-FREESWITCH -O "install/download/RPM-GPG-KEY-FREESWITCH"
    wget https://files.freeswitch.org/freeswitch-release-1-6.noarch.rpm -O "install/download/freeswitch-release-1-6.noarch.rpm"
	wget https://forensics.cert.org/cert-forensics-tools-release-el7.rpm -O "install/download/cert-forensics-tools-release-el7.rpm"
	wget https://download.postgresql.org/pub/repos/yum/9.4/redhat/rhel-7-x86_64/pgdg-centos94-9.4-3.noarch.rpm -O "install/download/pgdg-centos94-9.4-3.noarch.rpm"
	
	git clone https://github.com/fusionpbx/fusionpbx.git
	cd fusionpbx && git checkout 4.2.2 && rm -rf .git && cd ..
	
	;;
	
  docker)
    docker build ./ -t bayrell/freeswitch
    cd ..
    ;;
  
  run)
    $SCRIPT download
    $SCRIPT docker
    ;;
  
  *)
    echo "Usage: $0 {download|docker}"
    RETVAL=1

esac

exit $RETVAL