#!/bin/bash

SPT_DEPLOYMENT_PLATFORM=$1
x="3.9.33"
platfor="$(oc version | grep openshift | cut -d " " -f 1)"
if [ "$platfor" == "$SPT_DEPLOYMENT_PLATFORM" ] ; then
	curver="$(oc version | grep openshift | cut -d " " -f 2 | cut -d "v" -f 2)"
	if [ "$curver" == "$x" ]; then
		#echo "Sucess : The given deployment $SPT_DEPLOYMENT_PLATFORM version is $curver"
		echo "{ \"status\" : \"success\", \"version\" : \"$curver\" , \"message\" : \"The given deployment $SPT_DEPLOYMENT_PLATFORM version is $curver\" }"
	else
		#echo "Failure : The given deployment $SPT_DEPLOYMENT_PLATFORM version does not match our requirement and the version is $curver"
		echo "{ \"status\" : \"failure\", \"message\" : \"The given deployment $SPT_DEPLOYMENT_PLATFORM version does not match our requirement and the version is $curver\" }"
		exit 1;
	fi
else
	echo "{ \"status\" : \"failure\", \"message\" : \" oc login failed. Login into oc then re-try.\" }"
	exit 1;
fi
