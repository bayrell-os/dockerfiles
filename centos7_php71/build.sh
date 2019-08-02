#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPT_PATH=`dirname $SCRIPT`
BASE_PATH=`dirname $SCRIPT_PATH`

RETVAL=0

case "$1" in
	
	stage_packages)
		docker build ./ -t bayrell/centos7_php71:stage_packages --file stages/01_stage_packages
		cd ..
	;;
	
	stage_etc)
		docker build ./ -t bayrell/centos7_php71:stage_etc --file stages/02_stage_etc
		docker tag bayrell/centos7_php71:stage_etc bayrell/centos7_php71:latest
		cd ..
	;;
	
	*)
		echo "Usage: $0 {stage_packages|stage_etc|final}"
		RETVAL=1

esac

exit $RETVAL		