#!/bin/bash
. ~/.bash_profile


##create log directory##
if [ ! -d /tmp/xunjian/log/local ]
then
	mkdir -p /tmp/xunjian/log/local
	echo "'/tmp/xunjian/log/local'  has been created"
else
    echo "'/tmp/xunjian/log/local' already exists"	
fi


