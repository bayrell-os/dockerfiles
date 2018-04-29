#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPT_PATH=`dirname $SCRIPT`
BASE_PATH=`dirname $SCRIPT_PATH`

RETVAL=0

case "$1" in

  docker)
    docker build ./ -t bayrell/rabbitmq
    ;;

  *)
    echo "Usage: $0 {docker}"
    RETVAL=1

esac

exit $RETVAL