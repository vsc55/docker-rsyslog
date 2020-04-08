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

MYSQL_HOST=${MYSQL_HOST:-"localhost"}
MYSQL_PORT=${MYSQL_PORT:-"3306"}
MYSQL_DB=${MYSQL_DB:-"syslog"}
MYSQL_USER=${MYSQL_USER:-"root"}
MYSQL_PASS=${MYSQL_PASS:-""}

EXEC_SRV=/usr/sbin/rsyslogd
EXEC_SRV_ARGS=
EXEC_EXTERNAL=/data/external.sh

PATH_DATA=/data
PATH_CONF=$PATH_DATA/rsyslog.conf
PATH_PID=/var/run/rsyslog.pid

fun_update_config () {
	if [[ -f "$PATH_CONF" ]]; then
		sed -i "/input(type=\"imudp\"/c input(type=\"imudp\" port=\"${UDP_PORT}\")" "$PATH_CONF"
		sed -i "/input(type=\"imtcp\"/c input(type=\"imtcp\" port=\"${TCP_PORT}\")" "$PATH_CONF"
	fi
}

fun_waiting () {
	if [[ -f "$PATH_PID" ]]; then
		pid=$(cat "$PATH_PID")
		while [ -e /proc/$pid ]
		do
			sleep 5
		done
	fi
}

if [[ -f "$EXEC_EXTERNAL" ]]; then
	echo "*** RUN EXTERNAL ***"
	sh "$EXEC_EXTERNAL"
else
	echo "Starting service..."

	fun_update_config

	EXEC_SRV_ARGS="-i $PATH_PID"
	if [[ -f "$PATH_CONF" ]]; then
		EXEC_SRV_ARGS="$EXEC_SRV_ARGS -f $PATH_CONF"
	fi

	# DEBUG
	#echo "CMD [ $EXEC_SRV ]"
	#echo "ARG [ $EXEC_SRV_ARGS ]"

	$EXEC_SRV $EXEC_SRV_ARGS
	fun_waiting
fi
