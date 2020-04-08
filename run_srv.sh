#!/bin/bash

#
# Boot script daemon.
#
# @verions 1.0
# @fecha 08/04/2020
# @author Javier Pastor
# @license GPL 3.0
#


EXEC_SRV=/usr/sbin/rsyslogd
EXEC_EXTERNAL=/data/external.sh

if [[ -f $EXEC_EXTERNAL ]]; then
	echo "*** RUN EXTERNAL ***"
	sh $EXEC_EXTERNAL
else
	echo "Starting service..."
	$EXEC_SRV
fi
