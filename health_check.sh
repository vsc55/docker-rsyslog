#!/bin/bash

netstat -an | grep 514 > /dev/null
if [ 0 != $? ]; then
	echo "NOT OK"
	exit 1
else
	echo "OK"
	exit 0
fi
