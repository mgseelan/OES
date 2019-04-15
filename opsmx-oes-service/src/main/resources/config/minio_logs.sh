#!/bin/bash

SPT_SPINNAKER_NAMESPACE=$1									######## In API it tagged as nameSpace
oc project  $SPT_SPINNAKER_NAMESPACE
minio1=$(oc get pods | grep minio | awk '{printf $1}' )
oc logs "$minio1"
