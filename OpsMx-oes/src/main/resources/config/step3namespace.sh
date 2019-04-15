#!/bin/bash
##company : OpsMx
## Author : Gnana Seelan
## echo "Current Time is : $(date)"

### Name space to install Spinnaker

SPT_SPINNAKER_NAMESPACE=$1
sname_space=$(oc get namespace | grep "$SPT_SPINNAKER_NAMESPACE" | awk '{print $1}')
if [ "$SPT_SPINNAKER_NAMESPACE" = "$sname_space" ] ; then
	echo "{ \"status\" : \"failure\", \"message\" : \"Namespace $SPT_SPINNAKER_NAMESPACE already exists\" }"
	exit 1;
else
	snamespace=$(oc create namespace "$SPT_SPINNAKER_NAMESPACE" > /dev/null 2>&1)
	echo "$snamespace" > /dev/null 2>&1
	# name_space=`oc get namespace | grep $SPT_SPINNAKER_NAMESPACE | awk '{print $1}'`
	# if [ "$SPT_SPINNAKER_NAMESPACE" = "$name_space"] ; then 
	### The anyuid is set to access with root user
	oc adm policy add-scc-to-user anyuid -z default -n "$SPT_SPINNAKER_NAMESPACE" > /dev/null 2>&1
	oc adm policy add-scc-to-user anyuid -z builder -n "$SPT_SPINNAKER_NAMESPACE" > /dev/null 2>&1
	oc adm policy add-scc-to-user anyuid -z deployer -n "$SPT_SPINNAKER_NAMESPACE" > /dev/null 2>&1
	oc adm policy add-scc-to-user anyuid -z spinnaker -n "$SPT_SPINNAKER_NAMESPACE" > /dev/null 2>&1
	echo "{ \"status\" : \"success\", \"message\" : \"Namespace $SPT_SPINNAKER_NAMESPACE created\" }"
	exit 1;
fi 

