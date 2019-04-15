#!/bin/bash

SPT_SPINNAKER_NAMESPACE=$1									######## In API it tagged as nameSpace
oc project  $SPT_SPINNAKER_NAMESPACE
gate1=$(oc get pods | grep spin-gate | awk '{printf $1}' )
oc logs "$gate1"
