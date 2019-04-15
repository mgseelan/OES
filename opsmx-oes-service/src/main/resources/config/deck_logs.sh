#!/bin/bash
SPT_SPINNAKER_NAMESPACE=$1									######## In API it tagged as nameSpace
oc project  $SPT_SPINNAKER_NAMESPACE
deck1=$(oc get pods | grep spin-deck | awk '{printf $1}' )
oc logs "$deck1"
