#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPT_PATH=`dirname $SCRIPT`
BASE_PATH=`dirname $SCRIPT_PATH`

RETVAL=0

case "$1" in

	download)
		mkdir -p install/download

		pushd install/download
		wget https://downloads.asterisk.org/pub/telephony/asterisk/releases/asterisk-15.3.0.tar.gz
		wget http://mirror.freepbx.org/modules/packages/freepbx/freepbx-14.0-latest.tgz
		wget https://developers.amocrm.ru/download/asterisk.zip -O asterisk-amocrm.zip
		#wget http://www.pjsip.org/release/2.7.2/pjproject-2.7.2.tar.bz2
		#wget http://www.digip.org/jansson/releases/jansson-2.6.tar.gz		
		#wget https://downloads.asterisk.org/pub/telephony/sounds/asterisk-core-sounds-en-wav-current.tar.gz
		#wget https://downloads.asterisk.org/pub/telephony/sounds/asterisk-extra-sounds-en-wav-current.tar.gz
		#wget https://downloads.asterisk.org/pub/telephony/sounds/asterisk-core-sounds-en-g722-current.tar.gz
		#wget https://downloads.asterisk.org/pub/telephony/sounds/asterisk-extra-sounds-en-g722-current.tar.gz
		#wget https://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/dahdi-linux-complete-2.8.0.1+2.8.0.tar.gz
		#wget https://downloads.asterisk.org/pub/telephony/libpri/libpri-1.6.0.tar.gz
		popd
		
		;;
	
	
	docker)
		docker build ./ -t bayrell/asterisk --file stages/Dockerfile
		cd ..
		;;
	
	
	stage0)
		docker build ./ -t bayrell/asterisk:stage0 --file stages/Dockerfile0
		cd ..
		;;
	
	
	stage1)
		docker build ./ -t bayrell/asterisk:stage1 --file stages/Dockerfile1
		cd ..
		;;
	
	
	all)
		$SCRIPT download
		$SCRIPT docker
		;;
	
	
	*)
		echo "Usage: $0 {download|docker|all}"
		RETVAL=1

esac

exit $RETVAL