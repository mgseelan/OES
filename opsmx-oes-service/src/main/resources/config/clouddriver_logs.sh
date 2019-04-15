#!/bin/bash

SPT_SPINNAKER_NAMESPACE=$1									######## In API it tagged as nameSpace
oc project  $SPT_SPINNAKER_NAMESPACE
clouddriver1=$(oc get pods | grep spin-clouddriver | awk '{printf $1}' )
oc logs "$clouddriver1"
