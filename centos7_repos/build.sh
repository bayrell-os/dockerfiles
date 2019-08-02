#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPT_PATH=`dirname $SCRIPT`
BASE_PATH=`dirname $SCRIPT_PATH`

RETVAL=0

case "$1" in
	
	stage_os_install)
		docker build ./ -t bayrell/centos7_repos:stage_os_install --file stages/01_stage_os_install
		cd ..
	;;

	stage_os_update)
		docker build ./ -t bayrell/centos7_repos:stage_os_update --file stages/02_stage_os_update
		docker tag bayrell/centos7_repos:stage_os_update bayrell/centos7_repos:latest
		cd ..
	;;
	
	*)
		echo "Usage: $0 {stage_os_install|stage_os_update}"
		RETVAL=1

esac

exit $RETVAL