#!/bin/bash

UDP_PORT=${SYSLOG_UDP_PORT:-514}
TCP_PORT=${SYSLOG_TCP_PORT:-514}

LISTEN_UDP=-1
LISTEN_TCP=-1

netstat -lpnu | grep rsyslogd | grep ":${UDP_PORT} " > /dev/null
LISTEN_UDP=$?

netstat -lpnt | grep rsyslogd | grep ":${TCP_PORT} " > /dev/null
LISTEN_TCP=$?

if [ 0 == $LISTEN_UDP ] && [ 0 == $LISTEN_TCP ]
then
	echo "ALL LISTEN - OK"
	exit 0
else
	echo -n "UDP LISTEN - "
	case $LISTEN_UDP in
		0)
			echo "ON"
			;;
		1)
			echo "OFF"
			;;
		*)
			echo "UNKNOW (${LISTEN_UDP})"
			;;
	esac

	echo -n "TCP LISTEN - "
	case $LISTEN_TCP in
		0)
			echo "ON"
			;;
		1)
			echo "OFF"
			;;
		*)
			echo "UNKNOW (${LISTEN_TCP})"
			;;
	esac
	exit 1
fi
