#!/bin/bash

SPT_SPINNAKER_NAMESPACE=$1									######## In API it tagged as nameSpace
oc project  $SPT_SPINNAKER_NAMESPACE
orca1=$(oc get pods | grep spin-orca | awk '{printf $1}' )
oc logs "$orca1"
