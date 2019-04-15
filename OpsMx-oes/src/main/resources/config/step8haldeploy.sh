#!/bin/bash
## Author : M Gnana Seelan


SPT_SPINNAKER_NAMESPACE=$1
SPT_SPIN_DIPLOYMENT_VERSION=$2

## Name space Availability Check
sname_space=$(oc get namespace | grep "$SPT_SPINNAKER_NAMESPACE" | awk '{print $1}')
if [ "$SPT_SPINNAKER_NAMESPACE" != "$sname_space" ] ; then
        echo "{ \"status\" : \"failure\", \"message\" : \"Namespace $SPT_SPINNAKER_NAMESPACE not available\" }"
        exit 1;
fi


sp_status=Running
sp_ready=1
spinnaker_ver_stat=0

current_status=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep spin-halyard | awk '{print $3}')
if [ "$current_status" == Running ]; then
	halyard_podname=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep spin-halyard | awk '{print $1}')
	echo "$halyard_podname" > /dev/null 2>&1
	## Spinnaker deployment version configuration in the spin-halyard pod
	oc -n "$SPT_SPINNAKER_NAMESPACE" rsh "$halyard_podname" /bin/bash hal config version edit --version "$SPT_SPIN_DIPLOYMENT_VERSION" > /dev/null 2>&1
	sleep 10

	if [ $? -eq "$spinnaker_ver_stat" ]; then 
		## hal deploy apply after the spinnaker deployment version configuration
		oc -n "$SPT_SPINNAKER_NAMESPACE" rsh "$halyard_podname" /bin/bash hal deploy apply > /dev/null 2>&1
		sleep 110
		### Hal Deploy Apply First Cycle pod Running and Ste    ady Status checking starts
		### The Pod details	
		deck_pod=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep deck | awk '{print $1}')
		redis_pod=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep redis | awk '{print $1}')
		gate_pod=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep gate | awk '{print $1}')
		rosco_pod=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep rosco | awk '{print $1}')
		echo_pod=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep echo | awk '{print $1}')		
		orca_pod=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep orca | awk '{print $1}')
		clouddriver_pod=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep clouddriver | awk '{print $1}')
		front50_pod=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep front50 | awk '{print $1}')
		fiat_pod=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep fiat | awk '{print $1}')
	
		### The Pods Running Status
		deck_status=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep deck | awk '{print $3}')	
		redis_status=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep redis | awk '{print $3}')	
		gate_status=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep gate | awk '{print $3}')
		rosco_status=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep rosco | awk '{print $3}')
		echo_status=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep echo | awk '{print $3}')
		orca_status=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep orca | awk '{print $3}')
		clouddriver_status=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep clouddriver | awk '{print $3}')
		front50_status=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep front50 | awk '{print $3}')
		fiat_status=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep fiat | awk '{print $3}')

		### The Pods Ready Status
		deck_ready=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep deck | awk '{print $2}' | cut -d "/" -f 1)
		redis_ready=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep redis | awk '{print $2}' | cut -d "/" -f 1)
		gate_ready=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep gate | awk '{print $2}' | cut -d "/" -f 1)
		rosco_ready=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep rosco | awk '{print $2}' | cut -d "/" -f 1)
		echo_ready=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep echo | awk '{print $2}' | cut -d "/" -f 1)
		orca_ready=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep orca | awk '{print $2}' | cut -d "/" -f 1)
		clouddriver_ready=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep clouddriver | awk '{print $2}' | cut -d "/" -f 1)
		front50_ready=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep front50 | awk '{print $2}' | cut -d "/" -f 1)
		fiat_ready=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep fiat | awk '{print $2}' | cut -d "/" -f 1)


		if [ "$deck_status" == "$sp_status" ] && [ "$redis_status" == "$sp_status" ] && [ "$gate_status" == "$sp_status" ] && [  "$rosco_status" == "$sp_status" ] && [  "$echo_status" == "$sp_status" ] && [  "$orca_status" == "$sp_status" ] && [  "$clouddriver_status" == "$sp_status" ] && [ "$front50_status" == "$sp_status" ] && [  "$fiat_status" == "$sp_status" ] ; then 
			sp_pod1=("$deck_pod" "$redis_pod" "$gate_pod" "$rosco_pod" "$echo_pod" "$orca_pod" "$clouddriver_pod" "$front50_pod" "$fiat_pod")
			len_sp_pod1=${#sp_pod1[@]}
			echo "$len_sp_pod1" > /dev/null 2>&1
			for (( i=0; i<len_sp_pod1; i++ ));
			do
				echo "${sp_pod1[$i]}"  > /dev/null 2>&1
			done
			sleep 5
			# oc get pods -n "$SPT_SPINNAKER_NAMESPACE"
			# echo " All Pods up Ruuning state  in First attempt"
			sp_status1=("$deck_status" "$redis_status" "$gate_status" "$rosco_status" "$echo_status" "$orca_status" "$clouddriver_status" "$front50_status" "$fiat_status")
			len_sp_status1=${#sp_status1[@]}
			echo "$len_sp_status1" > /dev/null 2>&1
			for (( j=0; j<len_sp_status1; j++ ));
			do
				echo "${sp_status1[$j]}" > /dev/null 2>&1
			done
			sleep 5
			if [ "$deck_ready" == "$sp_ready" ] && [  "$redis_ready" == "$sp_ready" ] && [  "$gate_ready" == "$sp_ready" ] && [  "$rosco_ready" == "$sp_ready" ] && [  "$echo_ready" == "$sp_ready" ] && [  "$orca_ready" == "$sp_ready" ] && [  "$clouddriver_ready" == "$sp_ready"  ] && [  "$front50_ready" == "$sp_ready" ] && [  "$fiat_ready" == "$sp_ready" ] ; then
				sp_ready1=("$deck_ready" "$redis_ready" "$gate_ready" "$rosco_ready" "$echo_ready" "$orca_ready" "$clouddriver_ready" "$front50_ready" "$fiat_ready")
				len_sp_ready1=${#sp_ready1[@]}
				echo "$len_sp_ready1" > /dev/null 2>&1
				for (( k=0; k<len_sp_ready1; k++ ));
				do
					echo "${sp_ready1[$k]}" > /dev/null 2>&1
				done
				# echo " All Pods up running and ready state  in First attempt"
				# oc get pods -n "$SPT_SPINNAKER_NAMESPACE"
				sleep 10
				## Changing ClusterIP to NodePort for Deck and Gate
				oc patch svc spin-deck --type='json' -p='[{"op": "replace", "path": "/spec/type", "value": "NodePort"}]' -n "$SPT_SPINNAKER_NAMESPACE" > /dev/null 2>&1
				sleep 3
				oc patch svc spin-gate --type='json' -p='[{"op": "replace", "path": "/spec/type", "value": "NodePort"}]' -n "$SPT_SPINNAKER_NAMESPACE" > /dev/null 2>&1
				sleep 3
				# oc get svc -n "$SPT_SPINNAKER_NAMESPACE"
				echo $spinnaker_dep_stat > /dev/null 2>&1
				## Getting the IP of Spinnaker URL 
				ip_address="$(curl -s http://checkip.amazonaws.com)" > /dev/null 2>&1
				sleep 2
				## Getting the port of Spinnaker URL service
				deck_Port=`oc get svc -n "$SPT_SPINNAKER_NAMESPACE" | grep spin-deck | awk '{print $5}' | cut -d ":" -f 2 | cut -d "/" -f 1`
				gate_Port=`oc get svc -n "$SPT_SPINNAKER_NAMESPACE" | grep spin-gate | awk '{print $5}' | cut -d ":" -f 2 | cut -d "/" -f 1`
				echo $gate_Port > /dev/null 2>&1
				echo $deck_Port > /dev/null 2>&1
				sleep 5
				echo "{ \"status\" : \"success\", \"message\" :\"Successfully deployed spinnaker version: $SPT_SPIN_DIPLOYMENT_VERSION in namespace: $SPT_SPINNAKER_NAMESPACE with the ip address:\", \"ipaddress\" : \"""$ip_address""\",\"port\":\"$deck_Port\" }"
				exit 1;			
					
			else
				# echo " First Cycle failed "				
				oc delete pod "$fiat_pod" -n "$SPT_SPINNAKER_NAMESPACE" > /dev/null 2>&1
				# oc delete pod "$gate_pod" -n "$SPT_SPINNAKER_NAMESPACE" > /dev/null 2>&1
				sleep 75
				deck_pod=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep deck | awk '{print $1}')
				redis_pod=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep redis | awk '{print $1}')
				rosco_pod=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep rosco | awk '{print $1}')
				echo_pod=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep echo | awk '{print $1}')		
				orca_pod=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep orca | awk '{print $1}')
				clouddriver_pod=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep clouddriver | awk '{print $1}')
				front50_pod=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep front50 | awk '{print $1}')
				## Recreated as not Ready in first round of check     
				gate_pod=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep gate | awk '{print $1}')
				fiat_pod=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep fiat | awk '{print $1}')
				## Status check
				deck_status=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep deck | awk '{print $3}')	
				redis_status=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep redis | awk '{print $3}')	
				rosco_status=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep rosco | awk '{print $3}')
				echo_status=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep echo | awk '{print $3}')
				orca_status=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep orca | awk '{print $3}')
				clouddriver_status=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep clouddriver | awk '{print $3}')
				front50_status=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep front50 | awk '{print $3}')
				## Recreated as not Ready in first round of check
				gate_status=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep gate | awk '{print $3}')
				fiat_status=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep fiat | awk '{print $3}')
				
				if [ "$deck_status" == "$sp_status" ] && [ "$redis_status" == "$sp_status" ] && [ "$gate_status" == "$sp_status" ] && [  "$rosco_status" == "$sp_status" ] && [  "$echo_status" == "$sp_status" ] && [  "$orca_status" == "$sp_status" ] && [  "$clouddriver_status" == "$sp_status" ] && [ "$front50_status" == "$sp_status" ] && [  "$fiat_status" == "$sp_status" ] ; then 
					sp_pod2=("$deck_pod" "$redis_pod" "$gate_pod" "$rosco_pod" "$echo_pod" "$orca_pod" "$clouddriver_pod" "$front50_pod" "$fiat_pod")
					len_sp_pod2=${#sp_pod2[@]}
					echo "$len_sp_pod2" > /dev/null 2>&1
					for (( l=0; l<len_sp_pod2; l++ ));
					do
						echo "${sp_pod2[$l]}" > /dev/null 2>&1
					done
					Sleep 5
					sp_status2=("$deck_status" "$redis_status" "$gate_status" "$rosco_status" "$echo_status" "$orca_status" "$clouddriver_status" "$front50_status" "$fiat_status")
					len_sp_status2=${#sp_status1[@]}
					echo "$len_sp_status2" > /dev/null 2>&1
					for (( m=0; m<len_sp_status2; m++ ));
					do
						echo "${sp_status2[$m]}" > /dev/null 2>&1
					done
					Sleep 5
					# oc get pods -n "$SPT_SPINNAKER_NAMESPACE"
					# echo " All Pods up Ruuning state  in Second attempt"
					## Ready check
					deck_ready=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep deck | awk '{print $2}' | cut -d "/" -f 1)
					redis_ready=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep redis | awk '{print $2}' | cut -d "/" -f 1)
					rosco_ready=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep rosco | awk '{print $2}' | cut -d "/" -f 1)
					echo_ready=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep echo | awk '{print $2}' | cut -d "/" -f 1)
					orca_ready=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep orca | awk '{print $2}' | cut -d "/" -f 1)
					clouddriver_ready=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep clouddriver | awk '{print $2}' | cut -d "/" -f 1)
					front50_ready=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep front50 | awk '{print $2}' | cut -d "/" -f 1)
					## Recreated as not Ready in first round of check
					gate_ready=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep gate | awk '{print $2}' | cut -d "/" -f 1)
					fiat_ready=$(oc get pods -n "$SPT_SPINNAKER_NAMESPACE" | grep fiat | awk '{print $2}' | cut -d "/" -f 1)
					
					if [ "$deck_ready" == "$sp_ready" ] && [  "$redis_ready" == "$sp_ready" ] && [  "$gate_ready" == "$sp_ready" ] && [  "$rosco_ready" == "$sp_ready" ] && [  "$echo_ready" == "$sp_ready" ] && [  "$orca_ready" == "$sp_ready" ] && [  "$clouddriver_ready" == "$sp_ready"  ] && [  "$front50_ready" == "$sp_ready" ] && [  "$fiat_ready" == "$sp_ready" ] ; then
						sp_ready2=("$deck_ready" "$redis_ready" "$gate_ready" "$rosco_ready" "$echo_ready" "$orca_ready" "$clouddriver_ready" "$front50_ready" "$fiat_ready")
						len_sp_ready2=${#sp_ready2[@]}
						echo "$len_sp_ready2" > /dev/null 2>&1
						for (( n=0; n<len_sp_ready2; n++ ));
						do
							echo "${sp_ready2[$n]}" > /dev/null 2>&1
						done
						# oc get pods -n "$SPT_SPINNAKER_NAMESPACE"
						# oc get svc -n "$SPT_SPINNAKER_NAMESPACE"
						# echo " All Pods up running and ready state in second attempt "
						sleep 10
						## Changing ClusterIP to NodePort for Deck and Gate
						oc patch svc spin-deck --type='json' -p='[{"op": "replace", "path": "/spec/type", "value": "NodePort"}]' -n "$SPT_SPINNAKER_NAMESPACE" > /dev/null 2>&1
						sleep 5
						oc patch svc spin-gate --type='json' -p='[{"op": "replace", "path": "/spec/type", "value": "NodePort"}]' -n "$SPT_SPINNAKER_NAMESPACE" > /dev/null 2>&1
						sleep 5 
						# oc get svc -n "$SPT_SPINNAKER_NAMESPACE"
						## Getting the IP of Spinnaker URL 
						ip_address="$(curl -s http://checkip.amazonaws.com)" > /dev/null 2>&1
						sleep 2
						## Getting the port of Spinnaker URL service
						deck_Port=`oc get svc -n "$SPT_SPINNAKER_NAMESPACE" | grep spin-deck | awk '{print $5}' | cut -d ":" -f 2 | cut -d "/" -f 1`
						sleep 5
						gate_Port=`oc get svc -n "$SPT_SPINNAKER_NAMESPACE" | grep spin-gate | awk '{print $5}' | cut -d ":" -f 2 | cut -d "/" -f 1`
						sleep 5
						echo $gate_Port > /dev/null 2>&1
						echo $deck_Port > /dev/null 2>&1
						echo "{ \"status\" : \"success\", \"message\" :\"Successfully deployed spinnaker version: $SPT_SPIN_DIPLOYMENT_VERSION in namespace: $SPT_SPINNAKER_NAMESPACE with the ip address:\", \"ipaddress\" : \"""$ip_address""\",\"port\":\"$deck_Port\" }"
						exit 1;	
					else
						echo "{ \"status\" : \"failure\", \"message\" : \" In pod $halyard_podname spinnaker version updated to $SPT_SPIN_DIPLOYMENT_VERSION and all the respective pods are in running condition but not in ready state as expected in second attempt. Hence look into the log to further troubleshooting \" }"
						exit 1;
					fi
				else
					echo "{ \"status\" : \"failure\", \"message\" : \" In pod $halyard_podname spinnaker version updated to $SPT_SPIN_DIPLOYMENT_VERSION and all the respective pods are in not running condition as expected in second attempt. Hence look into the log to further troubleshooting\" }"
					exit 1;
				fi
				exit 1;
			fi
		else
			echo "{ \"status\" : \"failure\", \"message\" : \" In pod $halyard_podname spinnaker version updated to $SPT_SPIN_DIPLOYMENT_VERSION and all the respective pods are in not running condition as expected in first attempt. Hence look into the log to further troubleshooting \" }"	
			exit 1;
		fi
	else
		echo "{ \"status\" : \"failure\", \"message\" : \" In pod $halyard_podname spinnaker version update is failed with the namespace ""$SPT_SPINNAKER_NAMESPACE"" to do hal deploy apply \" }"	
		exit 1;
	fi
else
	echo "{ \"status\" : \"failure\", \"message\" : \" There is no pod Available with the namespace ""$SPT_SPINNAKER_NAMESPACE"" to do hal deploy apply\" }"	
	exit 1;		
fi
