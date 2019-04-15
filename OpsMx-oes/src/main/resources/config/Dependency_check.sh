#!/bin/bash

# To check the availability of curl command. Curl is used to download required files from github

if [ ! -f /usr/bin/curl ]; then
         a=`which curl`
         count=`echo -n $a | wc -c`
         if [ $count -eq 0 ]; then
             echo "curl is not installed .. Cannot continue, please install curl before initiating the deployment .."
             exit 1;
         fi
fi

if [ ! -f /usr/bin/python ]; then
         a=`which python`
         count=`echo -n $a | wc -c`
         if [ $count -eq 0 ]; then
             echo "python is not installed .. Cannot continue, please install python before initiating the deployment.."
             exit 1;
         fi
fi

if [ ! -f /usr/bin/oc ]; then
         a=`which oc`
         count=`echo -n $a | wc -c`
         if [ $count -eq 0 ]; then
             echo " openshift is not installed.. Cannot continue, please install openshift version 3.9.x and above before initiating the deployment.."
             exit 1;
         fi
fi


if [ ! -f /usr/bin/kubectl ]; then
         a=`which kubectl`
         count=`echo -n $a | wc -c`
         if [ $count -eq 0 ]; then
             echo " kubectl is not installed .. Cannot continue, please install kubectl binary before initiating the deployment.."
             exit 1;
         fi
fi
