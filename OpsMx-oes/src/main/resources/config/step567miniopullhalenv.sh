#!/bin/bash

#Company : OpsMx
## Author : Gnana Seelan
#echo "Current Time is : $(date)"


SPT_DEPLOYMENT_PLATFORM=$1     								######## In API it tagged as platForm      #### SPT is script
SPT_MINIO_ACCESS_KEY=$2										######## In API it tagged as accessKey 
SPT_MINIO_SECRET_ACCESSKEY=$3								######## In API it tagged as secretAccessKey 
SPT_PV_SIZE=$4												######## In API it tagged as size 
SPT_CONFIG_PATH=$5											######## In API it tagged as path 
SPT_SPINNAKER_NAMESPACE=$6									######## In API it tagged as nameSpace 
SPT_DOCKER_REGISTERY_USERNAME=$7							######## In API it tagged as dockerRegistryUsername
SPT_KUBERNETES_ACCOUNT=$8									######## In API it tagged as spinnakerV2Account 

#m#variable declarations for status check in all commands
sname_space=$(oc get namespace | grep "$SPT_SPINNAKER_NAMESPACE" | awk '{print $1}')
if [ "$SPT_SPINNAKER_NAMESPACE" != "$sname_space" ] ; then
        echo "{ \"status\" : \"failure\", \"message\" : \"Namespace $SPT_SPINNAKER_NAMESPACE not available\" }"
        exit 1;
fi

#Downloading minio template from github and Setting up the Minio Storage for the Deployment

curl https://raw.githubusercontent.com/OpsMx/Spinnaker-Install/oes/spinnaker-oc-install/minio_template.yml -o minio_template.yml  > /dev/null 2>&1
sleep 2

#m#printf "\n [****] Fetching and Updating the Minio Secret [****] "

base1=$(echo -ne "$SPT_MINIO_ACCESS_KEY" |base64)
base2=$(echo -ne "$SPT_MINIO_SECRET_ACCESSKEY" |base64)

echo 
#m#printf '\n'

sed -i "s/base64convertedaccesskey/$base1/" minio_template.yml

sed -i "s/base64convertedSecretAccesskey/$base2/" minio_template.yml

sed -i "s/SPINNAKER_NAMESPACE/$SPT_SPINNAKER_NAMESPACE/g" minio_template.yml

sleep 2

# sed -i "s/MINIO_STORAGE/$SPT_PV_SIZE Gi/g" minio_template.yml
echo "$SPT_PV_SIZE" > /dev/null 2>&1

### Downloading halyard and halconfigmap Templates from github and configuring halyard and halconfigmap templates

curl https://raw.githubusercontent.com/OpsMx/Spinnaker-Install/oes/spinnaker-oc-install/halconfigmap_template.yml -o halconfigmap_template.yml > /dev/null 2>&1
#m#printf '\n' 
curl https://raw.githubusercontent.com/OpsMx/Spinnaker-Install/oes/spinnaker-oc-install/extract.py -o extract.py > /dev/null 2>&1
#m#printf '\n' 
curl https://raw.githubusercontent.com/OpsMx/Spinnaker-Install/oes/spinnaker-oc-install/halyard_template.yml -o halyard_template.yml > /dev/null 2>&1
#m#printf '\n'
sleep 2

sed -i "s#example#$SPT_DOCKER_REGISTERY_USERNAME#g" halyard_template.yml

sed -i "s/SPINNAKER_NAMESPACE/$SPT_SPINNAKER_NAMESPACE/g" halyard_template.yml

sed -i "s/SPINNAKER_NAMESPACE/$SPT_SPINNAKER_NAMESPACE/g" halconfigmap_template.yml

sed -i "s/SPINNAKER_VERSION/$SPT_SPIN_DIPLOYMENT_VERSION/g" halconfigmap_template.yml

sleep 2
#m#printf "\n [****] Configuring the Dependencies  and Updating the configs in the Environment [****]"
#m#printf '\n'

#m#printf " \n [****] Updating configmap [****]" 
sed -i "s/SPINNAKER_ACCOUNT/$SPT_KUBERNETES_ACCOUNT/g" halconfigmap_template.yml

sed -i "s/SPINNAKER_NAMESPACE/$SPT_SPINNAKER_NAMESPACE/g" halyard_template.yml

sed -i "s/SPINNAKER_NAMESPACE/$SPT_SPINNAKER_NAMESPACE/g" halconfigmap_template.yml

sed -i "s/MINIO_USER/$SPT_MINIO_ACCESS_KEY/" halconfigmap_template.yml

sed -i "s/MINIO_PASSWORD/$SPT_MINIO_SECRET_ACCESSKEY/" halconfigmap_template.yml

sleep 2
#m#printf '\n'


oc create -n "$SPT_SPINNAKER_NAMESPACE" -f minio_template.yml > /dev/null 2>&1
sleep 20
minio_pod=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep minio | awk '{print $1}')
minio_status=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep minio | awk '{print $3}')
echo "$minio_pod" > /dev/null 2>&1
echo "$minio_status" > /dev/null 2>&1
if [ "$minio_status" == Running ] ; then
	minio_ready=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep minio | awk '{print $2}')
	echo "$minio_ready" > /dev/null 2>&1
	minio_ready1=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep minio | awk '{print $2}' | cut -d "/" -f 2)
	echo "$minio_ready1" > /dev/null 2>&1
	minio_ready2=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep minio | awk '{print $2}' | cut -d "/" -f 1)
	echo "$minio_ready2" > /dev/null 2>&1
	if [ "$minio_ready1" = "$minio_ready2" ] ; then
	        echo "$minio_ready1" > /dev/null 2>&1
	        echo "$minio_ready2" > /dev/null 2>&1
	        echo "$minio_ready"  > /dev/null 2>&1

		# pulling and pushing images
		
		python extract.py "$SPT_DOCKER_REGISTERY_USERNAME"  > /dev/null 2>&1
		#checking status and assigning to variable
		#m#printf "\n [****] Applying The Halyard ConfigMap, Secrets and the Halyard Deployment Pod [****] "
		#m#printf '\n'

		oc apply -f halconfigmap_template.yml -n "$SPT_SPINNAKER_NAMESPACE"  > /dev/null 2>&1
		#Checking status and preparing json format output
		oc create secret generic kubeconfig --from-file="$SPT_CONFIG_PATH" -n "$SPT_SPINNAKER_NAMESPACE" > /dev/null 2>&1
		oc apply -f halyard_template.yml -n "$SPT_SPINNAKER_NAMESPACE" > /dev/null 2>&1
		sleep 45
		spin_pod=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep spin-halyard | awk '{print $1}')
		spin_status=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep spin-halyard | awk '{print $3}')
		echo "$spin_pod" > /dev/null 2>&1
		echo "$spin_status" > /dev/null 2>&1
		if [ "$spin_status" == Running ] ; then
			spin_ready=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep spin-halyard | awk '{print $2}')
			echo "$spin_ready" > /dev/null 2>&1
			spin_ready1=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep spin-halyard | awk '{print $2}' | cut -d "/" -f 2)
			echo "$spin_ready1" > /dev/null 2>&1
			spin_ready2=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep spin-halyard | awk '{print $2}' | cut -d "/" -f 1)
			echo "$spin_ready2" > /dev/null 2>&1
			if [ "$spin_ready1" = "$spin_ready2" ] ; then
			        echo "$spin_ready1" > /dev/null 2>&1
			        echo "$spin_ready2" > /dev/null 2>&1
			        echo "$spin_ready" > /dev/null 2>&1
				echo "{ \"status\" : \"success\", \"message\" : \" Minio pod with $minio_pod is Running and Steady state. Docker image push pull success. Spin-halyard pod with $spin_pod is Running and Steady state for hal deploy apply with namespace $SPT_SPINNAKER_NAMESPACE and Plateform $SPT_DEPLOYMENT_PLATFORM \" }"
				exit 1;
			else 
				echo "{ \"status\" : \"failure\", \"message\" : \" Minio pod with $minio_pod is Running and Steady state. Docker image push pull success. Spin-halyard pod with $spin_pod is Running and is not Steady state for hal deploy apply with namespace $SPT_SPINNAKER_NAMESPACE\" }"
				exit 1;
			fi
		else
			echo "{ \"status\" : \"failure\", \"message\" : \" Minio pod with $minio_pod is Running and Steady state. Docker image push pull success. Spin-halyard pod with $spin_pod is not Running and Steady state for hal deploy apply with namespace $SPT_SPINNAKER_NAMESPACE\" }"	
			exit 1;
		fi
	else
			echo "{ \"status\" : \"failure\", \"message\" : \" Minio pod with $minio_pod is Running and is not Steady state. Docker image push pull not success. Spin-halyard pod with $spin_pod is not Running and Steady state for hal deploy apply with namespace $SPT_SPINNAKER_NAMESPACE\" }"
			exit 1;
        fi 
else
	echo "{ \"status\" : \"failure\", \"message\" : \" Minio pod with $minio_pod is not Running and Steady state. Docker image push pull not success. Spin-halyard pod with $spin_pod is not Running and Steady state for hal deploy apply with namespace $SPT_SPINNAKER_NAMESPACE\" }"
	exit 1;
fi
