#!/bin/bash

UDP_PORT=${SYSLOG_UDP_PORT:-514}
TCP_PORT=${SYSLOG_TCP_PORT:-514}

netstat -an | grep ${TCP_PORT} > /dev/null
if [ 0 != $? ]; then
	echo "NOT OK"
	exit 1
else
	echo "OK"
	exit 0
fi
