#!/bin/bash

## Company : OpsMx
## Author : Gnana Seelan
echo "Current Time is : $(date)"


SPT_DEPLOYMENT_PLATFORM=$1     								######## In API it tagged as platForm      #### SPT is script
SPT_SPIN_DIPLOYMENT_VERSION=$2								######## In API it tagged as version 
SPT_MINIO_ACCESS_KEY=$3										######## In API it tagged as accessKey 
SPT_MINIO_SECRET_ACCESSKEY=$4								######## In API it tagged as secretAccessKey 
SPT_PV_SIZE=$5												######## In API it tagged as size 
SPT_CONFIG_PATH=$6											######## In API it tagged as path 
SPT_SPINNAKER_NAMESPACE=$7									######## In API it tagged as nameSpace 
SPT_DOCKER_REGISTERY_USERNAME=$8							######## In API it tagged as dockerRegistryUsername
SPT_KUBERNETES_ACCOUNT=$9									######## In API it tagged as spinnakerV2Account 



###  Spinnaker will be deployed in Openshift Platform
echo The Spinnaker will be deployed in : $SPT_DEPLOYMENT_PLATFORM platform

### Name space to install Spinnaker
echo The Namespace where you want to Deploy the Spinnaker and its Related Service is : $SPT_SPINNAKER_NAMESPACE

oc create namespace $SPT_SPINNAKER_NAMESPACE

echo $SPT_SPINNAKER_NAMESPACE Namespace is created sucessfully

### Docker image location in which openshift specific spinnaker services will be pulled from opsmx docker repository
echo Enter the Docker registory/username [Ex: docker.io/opsmx11] :: $SPT_DOCKER_REGISTERY_USERNAME

### The anyuid is set to access with root user
oc adm policy add-scc-to-user anyuid -z default -n $SPT_SPINNAKER_NAMESPACE


#Setting up the Minio Storage for the Deployment

echo Enter the Minio Access Key [Access key length should be between minimum 3 characters in length] :: $SPT_MINIO_ACCESS_KEY
printf '\n'
echo Enter the Minio Secret Access Key [Secret key should be in between 8 and 40 characters] :: $SPT_MINIO_SECRET_ACCESSKEY
printf '\n'
base1=$(echo -ne "$SPT_MINIO_ACCESS_KEY" |base64)
base2=$(echo -ne "$SPT_MINIO_SECRET_ACCESSKEY" |base64)

printf "\n [****] Fetching and Updating the Minio Secret [****] "
printf '\n'

curl https://raw.githubusercontent.com/OpsMx/Spinnaker-Install/oes/oes/Updated/Rev_minio_template_4oes_1_12_1.yml -o minio_template.yml

echo minio_template.yml file is downloaded successfully


printf '\n'
sed -i "s/base64convertedaccesskey/$base1/" minio_template.yml
sed -i "s/base64convertedSecretAccesskey/$base2/" minio_template.yml
sed -i "s/SPINNAKER_NAMESPACE/$SPT_SPINNAKER_NAMESPACE/g" minio_template.yml
sed -i "s/MINIO_STORAGE/$SPT_PV_SIZE Gi/g" minio_template.yml

oc create -n $SPT_SPINNAKER_NAMESPACE -f minio_template.yml
sleep 10

# kubectl get pods -n $5 | grep minio | awk '{printf $3}'

oc logs minio -n $SPT_SPINNAKER_NAMESPACE

### Downloading and configuring halyard 
curl https://raw.githubusercontent.com/OpsMx/Spinnaker-Install/oes/oes/Updated/Rev_halyard_template_4oes_1_12_1.yml -o halyard_template.yml

printf '\n'
curl https://raw.githubusercontent.com/OpsMx/Spinnaker-Install/oes/oes/Updated/Rev_halconfigmap_template_4oes_1_12_1.yml -o halconfigmap_template.yml

printf '\n'

# pulling and pushing images
curl https://raw.githubusercontent.com/OpsMx/Spinnaker-Install/oes/oes/Updated/Rev_extract_4oes_1_12_1.py -o extract.py

python extract.py $SPT_DOCKER_REGISTERY_USERNAME

sed -i "s#example#$SPT_DOCKER_REGISTERY_USERNAME#g" halyard_template.yml
sed -i "s/SPINNAKER_NAMESPACE/$SPT_SPINNAKER_NAMESPACE/g" halyard_template.yml
sed -i "s/SPINNAKER_NAMESPACE/$SPT_SPINNAKER_NAMESPACE/g" halconfigmap_template.yml
sed -i "s/SPINNAKER_VERSION/$SPT_SPIN_DIPLOYMENT_VERSION/g" halconfigmap_template.yml

# Applying the Halyard Pod
printf "\n [****] Configuring the Dependencies [****]"
printf '\n'

echo Enter the Spinnaker V2 Account Name to be configured :: $SPT_KUBERNETES_ACCOUNT  

printf '\n'
echo Enter the path of the Kube Config File :: $SPT_CONFIG_PATH

#Updating the configs in the Environment 
printf '\n'
printf " \n [****] Updating configmap [****]" 
sed -i "s/SPINNAKER_ACCOUNT/$SPT_KUBERNETES_ACCOUNT/g" halconfigmap_template.yml
sed -i "s/SPINNAKER_NAMESPACE/$SPT_SPINNAKER_NAMESPACE/g" halyard_template.yml
sed -i "s/SPINNAKER_NAMESPACE/$SPT_SPINNAKER_NAMESPACE/g" halconfigmap_template.yml
sed -i "s/MINIO_USER/$SPT_MINIO_ACCESS_KEY/" halconfigmap_template.yml
sed -i "s/MINIO_PASSWORD/$SPT_MINIO_SECRET_ACCESSKEY/" halconfigmap_template.yml

printf '\n'

printf "\n [****] Applying The Halyard ConfigMap, Secrets and the Halyard Deployment Pod [****] "
printf '\n'

oc apply -f halconfigmap_template.yml -n $SPT_SPINNAKER_NAMESPACE
sleep 5
oc  create secret generic kubeconfig --from-file=$SPT_CONFIG_PATH -n $SPT_SPINNAKER_NAMESPACE

oc  apply -f halyard_template.yml -n $SPT_SPINNAKER_NAMESPACE

### Need 180 seconds (3 Minutes ) for comming up of pods
sleep 180 # Waiting for halyard pod to come up 

### Checking the status of the pod so we can do "hal deploy apply " in the respective spin-halyard pod

current_status=`oc get pods | grep spin-halyard | awk '{print $3}'`

if [ $current_status == Running ]
then
oc project $SPT_SPINNAKER_NAMESPACE
halyard_podname=`oc get pods | grep spin-halyard | awk '{print $1}'`
echo $halyard_podname
# oc exec -it $halyard_podname /bin/bash

oc exec $halyard_podname hal config version edit --version $SPT_SPIN_DIPLOYMENT_VERSION
oc exec $halyard_podname hal deploy apply
else
echo Halyard pod is not comming up
fi
