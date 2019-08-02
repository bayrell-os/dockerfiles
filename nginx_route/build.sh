#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPT_PATH=`dirname $SCRIPT`
BASE_PATH=`dirname $SCRIPT_PATH`

RETVAL=0

case "$1" in
	
	build)
		docker build ./ -t bayrell/nginx_route:latest --file stages/Dockerfile0
		cd ..
	;;
	
	*)
		echo "Usage: $0 {build}"
		RETVAL=1

esac

exit $RETVAL		