#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPT_PATH=`dirname $SCRIPT`
BASE_PATH=`dirname $SCRIPT_PATH`

RETVAL=0

case "$1" in

  download)
	mkdir -p install/download
	
	git clone https://github.com/fusionpbx/fusionpbx.git
	cd fusionpbx && git checkout 4.2.2 && cd ..
	
	;;

  docker)
	docker build ./ -t bayrell/freeswitch --file stages/Dockerfile
	cd ..
	;;

  stage0)
	docker build ./ -t bayrell/freeswitch:stage0 --file stages/Dockerfile0
	cd ..
	;;
  
  stage1)
	docker build ./ -t bayrell/freeswitch:stage1 --file stages/Dockerfile1
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