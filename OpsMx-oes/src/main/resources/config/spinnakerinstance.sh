#!/bin/bash

SPT_SPINNAKER_NAMESPACE=$1			######## In API it tagged as nameSpace
PYTHON_PATH=$2
oc project  $SPT_SPINNAKER_NAMESPACE
healthystatus=`python $PYTHON_PATH/healthy.py  | tail -n 1`

spin_version=`hal version bom | grep -m1 version: | awk '{printf $2}'`


echo "Openshift Spinnaker: " 

echo " healthStatus : $healthystatus"  

echo " version : $spin_version"
