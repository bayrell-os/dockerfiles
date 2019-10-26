#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPT_PATH=`dirname $SCRIPT`
BASE_PATH=`dirname $SCRIPT_PATH`

RETVAL=0

case "$1" in
	
	download)
		mkdir $SCRIPT_PATH/download
		pushd $SCRIPT_PATH/download
		wget https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v4.14/pip/pgadmin4-4.14-py2.py3-none-any.whl
		popd
	;;
	
	stage_install)
		docker build ./ -t bayrell/pgadmin:stage_install --file stages/01_stage_install
		cd ..
	;;
	
	stage_etc)
		docker build ./ -t bayrell/pgadmin:stage_etc --file stages/02_stage_etc
		docker tag bayrell/pgadmin:stage_etc bayrell/pgadmin:4.14
		docker tag bayrell/pgadmin:stage_etc bayrell/pgadmin:latest
		cd ..
	;;
	
	*)
		echo "Usage: $0 {download|stage_install|stage_etc}"
		RETVAL=1

esac

exit $RETVAL		