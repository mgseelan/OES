#!/bin/bash

## Company : OpsMx
## Author : Gnana Seelan
echo "Current Time is : $(date)"


###  Spinnaker will be deployed in Openshift Platform
echo The Spinnaker will be deployed in : $6 platform

### Name space to install Spinnaker
echo The Namespace where you want to Deploy the Spinnaker and its Related Service is : $5

kubectl create namespace $5

echo $5 Namespace is created sucessfully

### The anyuid is set to access with root user
oc adm policy add-scc-to-user anyuid -z default -n $5

### Docker image location in which openshift specific spinnaker services will be pulled from opsmx docker repository
echo Enter the Docker registory/username [Ex: docker.io/opsmx11] :: $8

#Setting up the Minio Storage for the Deployment

echo Enter the Minio Access Key [Access key length should be between minimum 3 characters in length] :: $4
printf '\n'
echo Enter the Minio Secret Access Key [Secret key should be in between 8 and 40 characters] :: $1
printf '\n'
base1=$(echo -ne "$4" |base64)
base2=$(echo -ne "$1" |base64)

printf "\n [****] Fetching and Updating the Minio Secret [****] "
printf '\n'

curl https://raw.githubusercontent.com/OpsMx/Spinnaker-Install/oes/oes/minio_template4oes.yml -o minio_template.yml

echo minio_template.yml file is downloaded successfully


printf '\n'
sed -i "s/base64convertedaccesskey/$base1/" minio_template.yml
sed -i "s/base64convertedSecretAccesskey/$base2/" minio_template.yml
sed -i "s/SPINNAKER_NAMESPACE/$5/g" minio_template.yml
sed -i "s/MINIO_STORAGE/$3/g" minio_template.yml

kubectl create -n $5 -f minio_template.yml
sleep 10

# kubectl get pods -n $5 | grep minio | awk '{printf $3}'

kubectl logs minio -n $5

### Downloading and configuring halyard 
curl https://raw.githubusercontent.com/OpsMx/Spinnaker-Install/oes/oes/halyard_template4oes.yml -o halyard_template.yml

printf '\n'
curl https://raw.githubusercontent.com/OpsMx/Spinnaker-Install/oes/oes/halconfigmap_template4oes.yml -o halconfigmap_template.yml

printf '\n'

# pulling and pushing images
curl https://raw.githubusercontent.com/OpsMx/Spinnaker-Install/oes/oes/extract4oes.py -o extract.py

python extract.py $8

sed -i "s#example#$8#g" halyard_template.yml
sed -i "s/SPINNAKER_NAMESPACE/$5/g" halyard_template.yml
sed -i "s/SPINNAKER_NAMESPACE/$5/g" halconfigmap_template.yml
sed -i "s/SPINNAKER_VERSION/$size/g" halconfigmap_template.yml

# Applying the Halyard Pod
printf "\n [****] Configuring the Dependencies [****]"
printf '\n'


echo Enter the Spinnaker V2 Account Name to be configured :: $9  

printf '\n'
echo Enter the path of the Kube Config File :: $2

#Updating the configs in the Environment 
printf '\n'
printf " \n [****] Updating configmap [****]" 
sed -i "s/SPINNAKER_ACCOUNT/$9/g" halconfigmap_template.yml
sed -i "s/SPINNAKER_NAMESPACE/$5/g" halyard_template.yml
sed -i "s/SPINNAKER_NAMESPACE/$5/g" halconfigmap_template.yml
sed -i "s/MINIO_USER/$4/" halconfigmap_template.yml
sed -i "s/MINIO_PASSWORD/$1/" halconfigmap_template.yml

printf '\n'

printf "\n [****] Applying The Halyard ConfigMap, Secrets and the Halyard Deployment Pod [****] "
printf '\n'

oc apply -f halconfigmap_template.yml -n $5
sleep 5
oc  create secret generic kubeconfig --from-file=$2 -n $5
sleep 5
oc  apply -f halyard_template.yml -n $5

### Need 180 seconds (3 Minutes ) for comming up of pods
sleep 180 # Waiting for halyard pod to come up 

### Checking the status of the pod so we can do "hal deploy apply " in the respective spin-halyard pod

current_status=`oc get pods | grep spin-halyard | awk '{print $3}'`

if [ $current_status == Running ]
then
oc project -n $1
halyard_podname=`oc get pods | grep spin-halyard | awk '{print $1}'`
echo $halyard_podname
oc exec -it $halyard_podname /bin/bash

hal config version edit --version $7
hal deploy apply
else
echo Halyard pod is not comming up
fi
