#!/bin/bash

## Company : OpsMx
## Author : Gnana Seelan
# echo "Current Time is : $(date)"
SPT_SPINNAKER_NAMESPACE=$1
SPT_DOCKER_REGISTERY_USERNAME=$2


### Docker image location in which openshift specific spinnaker services will be pulled from opsmx docker repository
echo Enter the Docker registory/username [Ex: docker.io/opsmx11] :: $SPT_DOCKER_REGISTERY_USERNAME

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