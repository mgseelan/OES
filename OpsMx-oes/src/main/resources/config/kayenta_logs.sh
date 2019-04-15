#!/bin/bash

SPT_SPINNAKER_NAMESPACE=$1									######## In API it tagged as nameSpace
oc project  $SPT_SPINNAKER_NAMESPACE

kayenta1=$(oc get pods | grep kayenta | awk '{printf $1}' )
oc logs "$kayenta1"
