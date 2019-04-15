#!/bin/bash
SPT_SPINNAKER_NAMESPACE=$1									######## In API it tagged as nameSpace
oc project  $SPT_SPINNAKER_NAMESPACE

fiat1=$(oc get pods | grep fiat | awk '{printf $1}' )
oc logs "$fiat1"
