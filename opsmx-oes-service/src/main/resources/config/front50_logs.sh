#!/bin/bash

SPT_SPINNAKER_NAMESPACE=$1									######## In API it tagged as nameSpace
oc project  $SPT_SPINNAKER_NAMESPACE

front501=$(oc get pods | grep spin-front50 | awk '{printf $1}' )
oc logs "$front501"
