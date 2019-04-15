#!/bin/bash


SPT_SPINNAKER_NAMESPACE=$1									######## In API it tagged as nameSpace
oc project  $SPT_SPINNAKER_NAMESPACE
halyard1=$(oc get pods | grep spin-halyard | awk '{printf $1}' )
oc logs "$halyard1"
