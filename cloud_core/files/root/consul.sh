#!/bin/bash

INTERFACE="eth0"
NODE_ID=`echo $NODE_ID`
TASK_ID=`echo $TASK_ID`
SERVICE_ID=`echo $SERVICE_ID`
SERVICE_NAME=`echo $SERVICE_NAME`
SERVICE_TAGS=`echo $SERVICE_TAGS`
ROUTE_ENABLE=`echo $ROUTE_ENABLE`
ROUTE_PREFIX=`echo $ROUTE_PREFIX`
HOSTNAME=`hostname`
CONSUL_IP="consul:8500"


if [ "$SERVICE_NAME" = "" ]; then
	exit 0
fi
if [ "$SERVICE_TAGS" = "" ]; then
	SERVICE_TAGS="[]"
fi


while [ 1 ]; do
	
	# Register service in the consul
	IP=`ifconfig ${INTERFACE} | grep inet | awk '{print $2}' | sed -n 1p`
	DATA="{
		\"ID\": \"${HOSTNAME}\",
		\"Name\": \"${SERVICE_NAME}\",
		\"Address\": \"${IP}\",
		\"Port\": 80,
		\"Tags\": ${SERVICE_TAGS},
		\"Meta\": {
			\"SERVICE_ID\": \"${SERVICE_ID}\",
			\"SERVICE_NAME\": \"${SERVICE_NAME}\",
			\"NODE_ID\": \"${NODE_ID}\",
			\"TASK_ID\": \"${TASK_ID}\",
			\"ROUTE_PREFIX\": \"${ROUTE_PREFIX}\"
		},
		\"Check\": {
			\"DeregisterCriticalServiceAfter\": \"1m\",
			\"TTL\": \"16s\",
			\"Status\": \"passing\"
		}
	}"
	echo $DATA
	curl -H "Content-Type: application/json" -X PUT -d "${DATA}" http://${CONSUL_IP}/v1/agent/service/register
	
	# Health check
	curl -H "Content-Type: application/json" -X PUT http://${CONSUL_IP}/v1/agent/check/pass/service:${HOSTNAME}
	
	echo "Ok"
	sleep 5
done
