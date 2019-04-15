#!/bin/bash
SPT_SPINNAKER_NAMESPACE=$1									######## In API it tagged as nameSpace
oc project  $SPT_SPINNAKER_NAMESPACE

igor1=$(oc get pods | grep spin-igor | awk '{printf $1}' )
oc logs "$igor1"
