#!/bin/bash

SPT_SPINNAKER_NAMESPACE=$1			######## In API it tagged as nameSpace
PYTHON_PATH=$2
oc project  $SPT_SPINNAKER_NAMESPACE
healthystatus=`python $PYTHON_PATH/healthy.py  | tail -n 1`

all11=`hal version bom | grep -m11 version:`

spin_version=`hal version bom | grep -m1 version: | awk '{printf $2}'`


Echo=`echo $all11 | awk '{printf $4}'`

Clouddriver=`echo $all11 | awk '{printf $6}'`

Deck=`echo $all11 | awk '{printf $8}'`

Fiat=`echo $all11 | awk '{printf $10}'`

Front50=`echo $all11 | awk '{printf $12}'`

Gate=`echo $all11 | awk '{printf $14}'`

Igor=`echo $all11 | awk '{printf $16}'`

Kayenta=`echo $all11 | awk '{printf $18}'`

Orca=`echo $all11 | awk '{printf $20}'`

Rosco=`echo $all11 | awk '{printf $22}'`


EchoIns=`oc get pods  | grep echo | tail -n 1 | awk '{printf $2 }'`
EchoSta=`oc get pods  | grep echo | tail -n 1 | awk '{printf $3}'`

ClouddriverIns=`oc  get pods  | grep clouddriver | tail -n 1 | awk '{printf $2}'`
ClouddriverSta=`oc  get pods  | grep clouddriver | tail -n 1 | awk '{printf $3}'`

DeckIns=`oc  get pods  | grep deck | tail -n 1 | awk '{printf $2}'`
DeckSta=`oc  get pods  | grep deck | tail -n 1 | awk '{printf $3}'`

FiatIns=`oc  get pods  | grep fiat | tail -n 1 | awk '{printf $2}'`
FiatSta=`oc  get pods  | grep fiat | tail -n 1 | awk '{printf $3}'`

Front50Ins=`oc  get pods | grep front50 | tail -n 1 | awk '{printf $2}'`
Front50Sta=`oc  get pods  | grep front50 | tail -n 1 | awk '{printf $3}'`

GateIns=`oc  get pods  | grep gate | tail -n 1 | awk '{printf $2}'`
GateSta=`oc  get pods  | grep gate | tail -n 1 | awk '{printf $3}'`


IgorIns=`oc  get pods  | grep igor | tail -n 1 | awk '{printf $2}'`
IgorSta=`oc  get pods  | grep igor | tail -n 1 | awk '{printf $3}'`

KayentaIns=`oc  get pods  | grep kayenta | tail -n 1 | awk '{printf $2}'`
KayentaSta=`oc  get pods  | grep kayenta | tail -n 1 | awk '{printf $3}'`

OrcaIns=`oc  get pods  | grep orca | tail -n 1 | awk '{printf $2}'`
OrcaSta=`oc  get pods  | grep orca | tail -n 1 | awk '{printf $3}'`


RoscoIns=`oc  get pods  | grep rosco | tail -n 1 | awk '{printf $2}'`
RoscoSta=`oc get pods  | grep rosco | tail -n 1 | awk '{printf $3}'`


echo "Openshift Spinnaker : " 
echo " healthStatus : $healthystatus" 
echo " version : $spin_version" 
echo " details : "
echo " - version : $Echo "
echo "   service : echo " 
echo "   instances : $EchoIns "
echo "   status : $EchoSta "
echo " - version : $Clouddriver "
echo "   service : clouddriver "
echo "   instances : $ClouddriverIns "
echo "   status : $ClouddriverSta "
echo " - version : $Deck "
echo "   service : Deck "
echo "   instances : $DeckIns "
echo "   status : $DeckSta "
echo " - version : $Fiat "
echo "   service : Fiat "
echo "   instances : $FiatIns "
echo "   status : $FiatSta "
echo " - version : $Front50 "
echo "   service : Front50 "
echo "   instances : $Front50Ins "
echo "   status : $Front50Sta "
echo " - version : $Gate "
echo "   service : Gate "
echo "   instances : $GateIns "
echo "   status : $GateSta "
echo " - version : $Igor "
echo "   service : Igor "
echo "   instances : $IgorIns "
echo "   status : $IgorSta "
echo " - version : $Kayenta "
echo "   service : Kayenta "
echo "   instances : $KayentaIns "
echo "   status : $KayentaSta "
echo " - version : $Orca "
echo "   service : Orca "
echo "   instances : $OrcaIns "
echo "   status : $OrcaSta "
echo " - version : $Rosco "
echo "   service : Rosco "
echo "   instances : $RoscoIns "
echo "   status : $RoscoSta "
