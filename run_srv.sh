#!/bin/bash

#
# Boot script daemon.
#
# @verions 1.0
# @fecha 08/04/2020
# @author Javier Pastor
# @license GPL 3.0
#


UDP_PORT=${SYSLOG_UDP_PORT:-514}
TCP_PORT=${SYSLOG_TCP_PORT:-514}

EXEC_SRV=/usr/sbin/rsyslogd
EXEC_SRV_ARGS=
EXEC_EXTERNAL=/data/external.sh

PATH_DATA=/data
PATH_CONF=$PATH_DATA/rsyslog.conf
PATH_PID=/var/run/rsyslog.pid


fun_waiting () {
	RESULT=0

	if [[ -f $PATH_PID ]]; then
		pid=$(cat "$PATH_PID")
		
		for pid in $pids; do
			#sleep 5
			wait $pid || let "RESULT=1"
		done
	fi

	return $RESULT
}


if [[ -f $EXEC_EXTERNAL ]]; then
	echo "*** RUN EXTERNAL ***"
	sh $EXEC_EXTERNAL
else
	echo "Starting service..."

	EXEC_SRV_ARGS=-i $PATH_PID

	if [[ -f $PATH_CONF ]]; then
		EXEC_SRV_ARGS=$EXEC_SRV_ARGS -c $PATH_CONF
	fi

	$EXEC_SRV $EXEC_SRV_ARGS
	exit fun_waiting
fi
