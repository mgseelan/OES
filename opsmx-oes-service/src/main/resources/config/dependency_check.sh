#!/bin/bash

## Company : OpsMx
## Author : Gnana Seelan
#echo "Current Time is : $(date)"


# To check the availability of curl command. Curl is used to download required files from github 

if [ ! -f /usr/bin/curl ]; then
         a=`which curl`
         count=`echo -n $a | wc -c`
         if [ $count -eq 0 ]; then
             echo "curl is not installed .. Cannot continue, please install curl before initiating the deployment .."
             exit 1;
         fi
fi


# To check the availability of python command. Python is used to run python scripts

if [ ! -f /usr/bin/python ]; then
         a=`which python`
         count=`echo -n $a | wc -c`
         if [ $count -eq 0 ]; then
             echo "python is not installed .. Cannot continue, please install python before initiating the deployment.."
             exit 1;
         fi
fi

# To check the availability of kubectl command. kubectl binary is used to get information from the clusters

if [ ! -f /usr/bin/kubectl ]; then
         a=`which kubectl`
         count=`echo -n $a | wc -c`
         if [ $count -eq 0 ]; then	
             echo " kubectl is not installed .. Cannot continue, please install kubectl binary before initiating the deployment.."
             exit 1;
         fi
fi

# To check the availability of oc command. openshift is the basic need for the deployment of Spinnaker.

if [ ! -f /usr/bin/oc ]; then
         a=`which oc`
         count=`echo -n $a | wc -c`
         if [ $count -eq 0 ]; then
             echo " openshift is not installed .. Cannot continue, please install openshift binary before initiating the deployment.."
             exit 1;
         fi
fi


