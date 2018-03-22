#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPT_PATH=`dirname $SCRIPT`
BASE_PATH=`dirname $SCRIPT_PATH`

RETVAL=0

case "$1" in

	download)
		mkdir -p install/download

		pushd install/download
		wget https://downloads.asterisk.org/pub/telephony/asterisk/asterisk-13-current.tar.gz
		wget https://developers.amocrm.ru/download/asterisk.zip -O asterisk-amocrm.zip
		wget http://mirror.freepbx.org/modules/packages/freepbx/freepbx-13.0-latest.tgz
		popd
		
		;;
	
	
	docker)
		docker build ./ -t bayrell/asterisk_13lts --file stages/Dockerfile
		cd ..
		;;
	
	
	stage0)
		docker build ./ -t bayrell/asterisk_13lts:stage0 --file stages/Dockerfile0
		cd ..
		;;
	
	
	stage1)
		docker build ./ -t bayrell/asterisk_13lts:stage1 --file stages/Dockerfile1
		cd ..
		;;


	stage2)
		docker build ./ -t bayrell/asterisk_13lts:stage2 --file stages/Dockerfile2
		cd ..
		;;
	
	
	stage3)
		docker build ./ -t bayrell/asterisk_13lts:stage3 --file stages/Dockerfile3
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