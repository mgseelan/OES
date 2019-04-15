#!/bin/sh

SPT_SPINNAKER_NAMESPACE=$7									######## In API it tagged as nameSpace
oc project -n $SPT_SPINNAKER_NAMESPACE

########## To check the health checkup of individual service by its health URL with checkUrl function


checkUrl() {
        echo "checking $2" 
        res=$(curl -sL -w "%{http_code}" "$1" -o /dev/null)
        if [ $res != 200 ]
                then
                        echo " $1 is not available and down. For troubleshooting refer to respective logs"  
                        count=`echo -n $res | wc -c`
                if [ $count -eq 0 ]; then
                        echo " Spinnaker is Healthy."
                else
                        echo " In Spinnaker all services are not up and running or having issues "
                fi
        else
                echo " $1 Status is UP and Healthy "
                count=`echo -n $res | wc -c`
                if [ $count -eq 0 ]; then
                        echo " Spinnaker is Healthy."
                else
                        echo " In Spinnaker all services are not up and running or having issues "
                fi
        fi
}
checkUrl "http://localhost:7002/health" clouddriver
checkUrl "http://localhost:9000/health" deck
checkUrl "http://localhost:8089/health" echo 
checkUrl "http://localhost:7003/health" fiat
checkUrl "http://localhost:8080/health" front50
checkUrl "http://localhost:8084/health" gate
checkUrl "http://localhost:8064/health" Halyard
checkUrl "http://localhost:8088/health" igor
checkUrl "http://localhost:8090/health" Kayenta
checkUrl "http://localhost:8083/health" orca
checkUrl "http://localhost:8087/health" Rosco
checkUrl "http://localhost:9000" minio
