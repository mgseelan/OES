#!/bin/bash
SPT_SPINNAKER_NAMESPACE=$1									######## In API it tagged as nameSpace
oc project  $SPT_SPINNAKER_NAMESPACE
rosco1=$(oc get pods | grep spin-rosco | awk '{printf $1}' )
oc logs "$rosco1"
