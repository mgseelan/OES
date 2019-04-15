app.controller('setupController', function($scope,$http,$location,ServiceProvider) {
	
	$scope.isActive = function (viewLocation) { 
        return viewLocation === $location.path();
    };
	
	$scope.showSteps = true;
	$scope.opsmxLoader = false;
	$scope.showOnboard = false;
	$scope.isDisabled = true;
	// code for tooltip
	$(document).ready(function(){
		  $('[data-toggle="tooltip"]').tooltip();   
		});
	
	  $scope.platForms = [
	     		   {
	     		      option: 'Kubernetes',
	     		      id: 0,
	     		      imagePath : "/images/Kubernetes.png"
	     		    },
	     		    {
	     		      option: 'Openshift',
	     		      id: 1,
	     		      imagePath : "/images/Openshift.png"
	     		    }
	     		  ];
	 $scope.spinnakerVersions = [
	 	     		   /*{
	 	     		      option: '1.11.9',
	 	     		      id: 0
	 	     		    },*/
	 	     		    {
	 	     		      option: '1.12.1',
	 	     		      id: 1
	 	     		    }/*,
	 	     		    {
		 	     		   option: '1.12.2',
		 	     		   id: 2
		 	     		 }*/
	 	     		  ];
	 
	 // code for step 1
	 	 $scope.submitStep2 = function(data){
	 		$scope.showMessage = false;
		// var postData = {
				 $scope.selectedPlatForm =  data.platFormType;
				 $scope.selectedVersion = data.spinnakerVersion;
		// }
	 };
	 
	 // code for dependency check 
	 $scope.isDependencySuccess = false;
	 $scope.deploymentErrorMessage = "";
	 $scope.dependencyCheck = function(){
		 $scope.opsmxLoader = true;
		 ServiceProvider.dependencyCheck().then(function(response){
				$scope.opsmxLoader = false;
				$scope.finalStatus = response;
		    	if(response.status == "success"){
		    		$scope.isDependencySuccess = true;
		    		$scope.deploymentErrorMessage = "";
		    		$scope.isDisabled = false;
		    	}else{
		    		$scope.isDependencySuccess = false;
		    		$scope.deploymentErrorMessage = response.message;
		    		$scope.isDisabled = true;
		    	}
		    	console.log(response);
			},
			function(error){
				$scope.opsmxLoader = false;
				console.log("Error Response from dependency check");
			});
	 }	 
	 
	 $scope.checkKubernetesPlatform = function(){
		 //console.log($scope.platform);
	 };
	 
	 $scope.isplatformCheckSuccess = false;
	 $scope.checkOpenshiftPlatform= function(){
		 $scope.opsmxLoader = true;
		 var postData = {
			"platForm" : $scope.platform 
		 };
		 ServiceProvider.platformCheck(postData).then(function(response){
				$scope.opsmxLoader = false;
				console.log("Success Response from platformCheck");
		    	console.log(response);
		    	if(response.status == "success"){
		    		$scope.isplatformCheckSuccess = true;
		    		$scope.deploymentErrorMessage = "";		    		
		    	}else{
		    		$scope.isplatformCheckSuccess = false;
		    		$scope.deploymentErrorMessage = response.message;
		    	}
			},
			function(error){
				$scope.opsmxLoader = false;
				$scope.isplatformCheckSuccess = false;
				console.log("Error Response from platformCheck");
				console.log(error);				
			});
	 };
	 
	 $scope.nameSpaceExistErrorMessage = "";
	 $scope.isNameSpaceEdit = false;
	 $scope.isNamespaceCheckSuccess = false;
	 $scope.checkNamespace = function(){
		if($scope.nameSpace == undefined || $scope.nameSpace == ""){
			$scope.nameSpaceExistErrorMessage = "Please enter namespace."			
		}else{			
			$scope.opsmxLoader = true;
			var postData = {
				"namespace" : $scope.nameSpace 
			};
			$scope.nameSpaceExistErrorMessage ="";
			ServiceProvider.nameSpaceCheck(postData).then(function(response){
				$scope.opsmxLoader = false;
				console.log("Success Response from nameSpaceCheck");
			    console.log(response);
			    if(response.status == "success"){
			    	$scope.isNamespaceCheckSuccess = true;
			    	$scope.deploymentErrorMessage = "";		    		
			    }else{
			    	$scope.isNamespaceCheckSuccess = false;
			    	$scope.deploymentErrorMessage = response.message;
			    	$scope.isNameSpaceEdit = true;
			    }
			},
			function(error){
				$scope.opsmxLoader = false;
				$scope.isNamespaceCheckSuccess = false;
				console.log("Error Response from nameSpaceCheck");
				console.log(error);				
			});
		}
	 };
	 
	 $scope.editNameSpace = function(){
		 $scope.nameSpace = "";
		 $scope.isNameSpaceEdit = false;
		 $scope.nameSpaceExistErrorMessage = "";
		 $scope.deploymentErrorMessage = "";
	 };
	 // code for step 2
	 $scope.submitStep3 = function(data){
		 $scope.showMessage = false;
		// var postData = {
				 $scope.enteredAccessKey = data.accessKey;
				 $scope.enteredSecretAccessKey = data.secretAccessKey;
				 $scope.enteredSize = data.size;
				 console.log(data);
		// }
	 };
	 
	 // code for step 3
	 $scope.showMessage = false;
	 $scope.showFailedMessage = false;
	 $scope.submitStep4 = function(data){
		
		 $scope.showFailedMessage = false;
		 $scope.showMessage = false;
		// var postData = {
				 $scope.enteredpath = data.path;
				 $scope.enteredNameSpace = data.nameSpace;
		// }
			var postData = {
					platForm: $scope.selectedPlatForm,
					version: $scope.selectedVersion,
					accessKey: $scope.enteredAccessKey,
					secretAccessKey:  $scope.enteredSecretAccessKey,
					size: $scope.enteredSize,
					path: $scope.enteredpath,
					nameSpace: $scope.enteredNameSpace,
					dockerRegistryUsername:$scope.dockerUsername,
					spinnakerV2Account:$scope.spinnakerV2AccountName
			};
			console.log(postData); 
		//	$scope.pData = JSON.stringify(postData);
			//console.log($scope.pData);
			$scope.showSteps = true;
			$scope.opsmxLoader = true;
			ServiceProvider.deploySpinnaker(postData).then(function(response){
				$scope.opsmxLoader = false;
		    	if(response.status == "success"){
		    		$scope.showSteps = false;		    		
		    		$scope.finalMessage = response.message;
		    	}else{
		    		$scope.showSteps = false;
		    		//$scope.finalMessage = response.message;
		    		$scope.finalMessage = {"status":"failure",
		    				               "message":"Something went wrong. Please try again"};	   		
		    	}
		    	console.log(response);
		    	$scope.platFormType = '';
		    	$scope.spinnakerVersion = '';
		    	$scope.accessKey = '';
		    	$scope.secretAccessKey = '';
		    	$scope.size = '';
		    	$scope.path = '';
		    	$scope.nameSpace = '';	
		    	$scope.dockerUsername = '';
		    	$scope.spinnakerV2AccountName = '';
		    	window.location = "#/dashboard";
			},
			function(error){
				$scope.opsmxLoader = false;
				console.log("Error Response from deploySpinnaker");
				console.log(error);
				window.location = "#/dashboard";
			});		
			
	 };
	 
	 $scope.startOnBoard= function(){
		 $scope.showOnboard = true;
		 $('div.setup-panel div a[href="#step-1"]').click();
	 };
	 
	 $scope.getYamlData = function(){
		 ServiceProvider.getYamlData().then(function(response){				
		    	console.log(response);		    	
			}); 
	 };
	 $scope.executeShellScript = function(){
		 ServiceProvider.executeShellScript().then(function(response){				
		    	console.log(response);		    	
			}); 
	 };
	 
	 $scope.isShowStep1 = true;
	 $scope.isShowStep2 = false;
	 $scope.isShowStep3 = false;
	 $scope.isShowStep4 = false;
	 $scope.isShowStep5 = false;
	 
	 $scope.goToStep2 = function(){
		 $scope.isShowStep2 = true;
		 $scope.isShowStep1 = false;		
		 $scope.isShowStep3 = false;
		 $scope.isShowStep4 = false;
		 $scope.isShowStep5 = false;
		 $scope.isStep1Success = true;
		 $scope.deploymentErrorMessage = "";
	 };
	 
	 $scope.spinnakerVersion = "";
	 $scope.goToStep3 = function(){
		 $scope.isShowStep3 = true;
		 $scope.isShowStep1 = false;
		 $scope.isShowStep2 = false;
		 $scope.isShowStep4 = false;
		 $scope.isShowStep5 = false;
		 $scope.isStep2Success = true;
		 //console.log($scope.spinnakerVersion);
		 $scope.deploymentErrorMessage = "";
	 };
	 
	 $scope.accessKey = "";
	 $scope.secretAccessKey = "";
	 $scope.size = "";
	 $scope.goToStep4 = function(){
		 $scope.isShowStep4 = true;
		 $scope.isShowStep1 = false;
		 $scope.isShowStep2 = false;
		 $scope.isShowStep3 = false;
		 $scope.isShowStep5 = false;
		 $scope.isStep3Success = true;
		 $scope.deploymentErrorMessage = "";
	 };
	 
	 $scope.path = "";
	 $scope.dockerRegistryUsername = "";
	 $scope.spinnakerV2AccountName = "";
	 $scope.isMinioPullEnvSuccess = false;
	 $scope.goToStep5 = function(){	
		 $scope.deploymentErrorMessage = "";
		 $scope.opsmxLoader = true;
		 var postData = {
			"platForm" 			 	 : $scope.platform,
			"accessKey"			 	 : $scope.accessKey,
			"secretAccessKey" 		 : $scope.secretAccessKey,
			"size" 					 : $scope.size,
			"path"              	 : $scope.path,
			"nameSpace"         	 : $scope.nameSpace,
			"dockerRegistryUsername" : $scope.dockerRegistryUsername,
			"spinnakerV2Account"     : $scope.spinnakerV2Account
		 };
		 ServiceProvider.minioPullEnviorment(postData).then(function(response){
				$scope.opsmxLoader = false;
				console.log("Success Response from minioPullEnviorment");
		    	console.log(response);		    	
		    	if(response.status == "success"){
		    		$scope.isMinioPullEnvSuccess = true;
		    		$scope.deploymentErrorMessage = "";	
		    		$scope.isShowStep5 = true;
		   		 	$scope.isShowStep1 = false;
		   		 	$scope.isShowStep2 = false;
		   		 	$scope.isShowStep3 = false;
		   		 	$scope.isShowStep4 = false;
		   		 	$scope.isStep4Success = true;		   		 	
		    	}else{
		    		$scope.isMinioPullEnvSuccess = false;
		    		$scope.deploymentErrorMessage = response.message;
		    	}
			},
			function(error){
				$scope.opsmxLoader = false;
				$scope.isMinioPullEnvSuccess = false;
				console.log("Error Response from minioPullEnviorment");
				console.log(error);				
			});
	 };
	 
	 $scope.deploySpinnakerSuccess =false;
	 $scope.deploySpinnaker = function(){
		 $scope.opsmxLoader = true;
		 var postData = {
			"nameSpace"      : $scope.nameSpace,
			"version"        : $scope.spinnakerVersion
		 };
		 ServiceProvider.deploySpinnaker(postData).then(function(response){
				$scope.opsmxLoader = false;
				console.log("Success Response from deploySpinnaker");
		    	console.log(response);		    	
		    	if(response.status == "success"){		    		
		    		$scope.deploymentErrorMessage = "";	
		    		$scope.spinnakerurl = "http://"+response.ipaddress+":"+response.port;
		    		$scope.deploySpinnakerSuccess =true;
		    	}else{	
		    		$scope.spinnakerurl = "http://35.237.232.2:8888";
		    		$scope.deploymentErrorMessage = response.message;
		    	}
			},
			function(error){
				$scope.opsmxLoader = false;	
				$scope.deploySpinnakerSuccess =false;
				console.log("Error Response from deploySpinnaker");
				console.log(error);				
			});
	 };
	 
	 $scope.isShowPlatformStep = true;;
	 $scope.isShowNamespaceStep = false;
	 $scope.isShowVersionStep = false;
	 
	 $scope.goToNamespaceStep = function(){
		 $scope.isShowPlatformStep = false;;
		 $scope.isShowNamespaceStep = true;
		 $scope.isShowVersionStep = false;
		 $scope.deploymentErrorMessage = "";
	 };
	 
	 $scope.goToVersionStep = function(){
		 $scope.isShowPlatformStep = false;;
		 $scope.isShowNamespaceStep = false;
		 $scope.isShowVersionStep = true;
		 $scope.deploymentErrorMessage = "";
	 };
	 
	 $scope.isShowKubeStep = true;;
	 $scope.isShowDockerStep = false;
	 $scope.isShowAccountNameStep = false;
	 
	 $scope.goToDockerStep = function(){
		 $scope.isShowKubeStep = false;;
		 $scope.isShowDockerStep = true;
		 $scope.isShowAccountNameStep = false;
	 };
	 
	 $scope.goToAccountNameStep = function(){
		 $scope.isShowKubeStep = false;;
		 $scope.isShowDockerStep = false;
		 $scope.isShowAccountNameStep = true;
	 };
	 
	 
    
});


app.controller('dashboardController', function($scope,$http,$timeout,ServiceProvider,DashBoardService) {
	$scope.opsmxLoader = false;
	
	$scope.getAllSpinnakerInstances = function(){
		$scope.opsmxLoader = true;
		var getParams = {
			nameSpace : $scope.nameSpace	
		};
		ServiceProvider.getSpinnakarInstances(getParams).then(function(response) {
			$scope.opsmxLoader = false;
			console.log("Success Response from getSpinnakarInstances");
			console.log(response);
			$scope.spinnakerInstances = response;
		},
		function(error){
			$scope.opsmxLoader = false;
			console.log("Error Response from getSpinnakarInstances");
			console.log(error);  
		});
	};
	
	
	$scope.getSpinnakerDetails = function(key){
		$scope.opsmxLoader = true;
		$scope.spinnakerInstances[key].show=!$scope.spinnakerInstances[key].show;
		var getParams = {
			nameSpace : $scope.nameSpace	
		};
		ServiceProvider.getSpinnakerDetails(getParams).then(function(response) {
			$scope.opsmxLoader = false;
			console.log("Success Response from getSpinnakerDetails");
			console.log(response);
			$scope.spinnakerDetails = response[key].details;
		},
		function(error){
			$scope.opsmxLoader = false;
			console.log("Error Response from getSpinnakerDetails");
			console.log(error);  
		});
	};
	
	$scope.yamltojson = function(){
		$.get( 'yaml/elastic_set2.yaml', function( text ) {
	        var obj = jsyaml.load( text );
	        console.log( obj );        
	    });
	};
		
	
	$scope.editDeploymentDetail = function(key,record) {
		$scope.selectedDeplKey = angular.copy(key);
	    $scope.selectedDeplValue = angular.copy(record);
	    console.log($scope.selectedKey );
	    console.log($scope.record_to_edit);
	};
	
/*
	$scope.spinnakerConfig =
	{
			"Kubernetes Spinnaker":{ 
				"healthStatus" : "Healthy",
				"version"	   : "1.11.4",
				"details"	   : [
					{"version" : "2.6.1-20181220153244", "Instances":"1/1","service":"Deck","status":"Running"},
					{"version" : "1.4.0-20181217192627", "Instances":"2/2","service":"Gate","status":"Running"},
					{"version" : "2.1.0-20190104141519", "Instances":"2/2","service":"Orca","status":"Running"},
					{"version" : "4.2.2-20190105032508", "Instances":"2/2","service":"CloudDriver","status":"Running"},
					{"version" : "0.14.0-20181207134351", "Instances":"2/2","service":"Front50","status":"Running"},
					{"version" : "0.8.2-20181221095200", "Instances":"2/2","service":"Rosco","status":"Running"},
					{"version" : "1.0.0-20181207134351", "Instances":"2/2","service":"Igor","status":"Running"},
					{"version" : "2.2.3-20190104153242", "Instances":"2/2","service":"Echo","status":"Running"},
					{"version" : "1.3.0-20181207134351", "Instances":"2/2","service":"Fiat","status":"Running"},
					{"version" : "0.5.1-20190104141519", "Instances":"2/2","service":"Kayenta","status":"Running"}
				]
		    },
		    "Openshift Spinnaker":{		    	
				"healthStatus" : "Healthy",
				"version"	   : "1.10.9",
				"details"	   :[
					{"version" : "2.5.6-20181220144307", "Instances":"1/1","service":"Deck","status":"Running"},
					{"version" : "1.2.1-20181108172516", "Instances":"2/2","service":"Gate","status":"Running"},
					{"version" : "1.1.4-20190103160527", "Instances":"2/2","service":"Orca","status":"Running"},
					{"version" : "4.0.5-20190104164435", "Instances":"2/2","service":"CloudDriver","status":"Running"},
					{"version" : "0.13.1-20181217212321", "Instances":"2/2","service":"Front50","status":"Running"},
					{"version" : "0.8.0-20181003100130", "Instances":"2/2","service":"Rosco","status":"Running"},
					{"version" : "0.13.0-20181003100130", "Instances":"2/2","service":"Igor","status":"Running"},
					{"version" : "2.1.3-20181217212321", "Instances":"2/2","service":"Echo","status":"Running"},
					{"version" : "1.2.0-20181115151924", "Instances":"2/2","service":"Fiat","status":"Running"},
					{"version" : "0.4.1-20190105115745", "Instances":"2/2","service":"Kayenta","status":"Running"}
				]
			}
	};
	*/
	
	/*$.get( 'yaml/config.yaml', function( text ) {
        var obj = jsyaml.load( text );
        console.log( obj );
        $scope.configurations = obj;	        
    });	*/
	
	/*$scope.selectedRow = "";
	$scope.showDetail = function(key){
		$scope.selectedRow = key;		
	};
	
	$scope.hideDetail = function(){
		$scope.selectedRow = "";		
	};*/
	
	$scope.editSpinnakerInstance = function(){	
		    $scope.opsmxLoader = true;
			$.get('/resources/static/yaml/config.yaml', function(text) {
		        var obj = jsyaml.load( text );
		        console.log( obj );
		        $scope.opsmxLoader = false;
		        $scope.configurations = obj;	
		        $scope.showDeployConfig = true;	
		        $timeout(function(){
		            $scope.showDeployConfig = true;
		        },1000);
		    });	    
	};
	
	// upgrate spinnaker instance
	$scope.upgradeSpinnakerInstance = function(version){
		$scope.upgradeVersion = version; 
	}
	
	$scope.editDeploymentDetail = function(key,record) {
		$scope.selectedDeplKey = angular.copy(key);
	    $scope.selectedDeplValue = angular.copy(record);
	    console.log($scope.selectedKey );
	    console.log($scope.record_to_edit);
	}
	
    // code to add the new row in add account
	$scope.addAccount = function(configurationType){
		if(configurationType == "dockerRegistry"){
			$scope.selectedDeplValue.accounts.push({ 
	            'name': "", 
	            'username': "",
	            'password': "",
	            'providerVersion': "", 
	        });
		}else if(configurationType == "kubernetes"){
			$scope.selectedDeplValue.accounts.push({ 
	            'name': "", 
	            'providerVersion': "", 
	            'kubeconfigFile':"",
	            'namespaces':"",
	            'dockerRegistries':""
			
	        });
		}else if(configurationType == "openstack"){
			$scope.selectedDeplValue.accounts.push({ 
	            'name': "", 
	            'username': "",
	            'password': "",
	            'providerVersion': ""
	        });
		}
		else if(configurationType == "bitbucket"){
			$scope.selectedDeplValue.accounts.push({ 
	            'name': "", 
	            'username': "",
	            'password': ""
	        });
		}
		else if(configurationType == "github"){
			$scope.selectedDeplValue.accounts.push({ 
	            'name': "", 
	            'username': "",
	            'password': ""
	        });
		}
	}
	
	// code to save the edited data 
	$scope.saveEditData = function(configurationType,accountDetails){
		if(configurationType == ""){
			$scope.account = accountDetails;
			var firstObject = {
					'name': accountDetails[0].name, 
		            'username': accountDetails[0].username,
		            'password': accountDetails[0].password,
		            'providerVersion': accountDetails[0].providerVersion,
			}
		}else if(configurationType == "kubernetes"){
			$scope.account = accountDetails;
			var firstObject = {
					'name': accountDetails[0].name, 
		            'providerVersion': accountDetails[0].providerVersion,
		            'kubeconfigFile': accountDetails[0].kubeconfigFile,
		            'namespaces': accountDetails[0].namespaces,
		            'dockerRegistries': accountDetails[0].dockerRegistries 
			}
		}
		else if(configurationType == "openstack"){
			$scope.account = accountDetails;
			var firstObject = {
					'name': accountDetails[0].name, 
		            'username': accountDetails[0].username,
		            'password': accountDetails[0].password,
		            'providerVersion': accountDetails[0].providerVersion,
			}
		}
		else if(configurationType == "bitbucket"){
			$scope.account = accountDetails;
			var firstObject = {
					'name': accountDetails[0].name, 
		            'username': accountDetails[0].username,
		            'password': accountDetails[0].password,
		            
			}
		}
		else if(configurationType == "github"){
			$scope.account = accountDetails;
			var firstObject = {
					'name': accountDetails[0].name, 
		            'username': accountDetails[0].username,
		            'password': accountDetails[0].password,
			}
		}
	
		accountDetails.shift();
		accountDetails.push(firstObject);
	
	};
	
	var getEchoLogs = function(){
		$scope.opsmxLoader = true;
		var getParams = {
			nameSpace : $scope.nameSpace	
		};
		DashBoardService.getEchoLogs(getParams).then(function(response) {
			$scope.opsmxLoader = false;
			console.log("Success Response from getEchoLogs");
			console.log(response);	
			$scope.serviceLogs = response.logs;
		},
		function(error){
			$scope.opsmxLoader = false;
			console.log("Error Response from getEchoLogs");
			console.log(error);  
		});
	};
	var getCloudDriverLogs = function(){
		$scope.opsmxLoader = true;
		var getParams = {
			nameSpace : $scope.nameSpace	
		};
		DashBoardService.getCloudDriverLogs(getParams).then(function(response) {
			$scope.opsmxLoader = false;
			console.log("Success Response from getCloudDriverLogs");
			console.log(response);	
			$scope.serviceLogs = response.logs;
		},
		function(error){
			$scope.opsmxLoader = false;
			console.log("Error Response from getCloudDriverLogs");
			console.log(error);  
		});
	};
	var getDeckLogs = function(){
		$scope.opsmxLoader = true;
		var getParams = {
			nameSpace : $scope.nameSpace	
		};
		DashBoardService.getDeckLogs(getParams).then(function(response) {
			$scope.opsmxLoader = false;
			console.log("Success Response from getDeckLogs");
			console.log(response);	
			$scope.serviceLogs = response.logs;
		},
		function(error){
			$scope.opsmxLoader = false;
			console.log("Error Response from getDeckLogs");
			console.log(error);  
		});
	};
	var getFiatLogs = function(){
		$scope.opsmxLoader = true;
		var getParams = {
			nameSpace : $scope.nameSpace	
		};
		DashBoardService.getFiatLogs(getParams).then(function(response) {
			$scope.opsmxLoader = false;
			console.log("Success Response from getFiatLogs");
			console.log(response);	
			$scope.serviceLogs = response.logs;
		},
		function(error){
			$scope.opsmxLoader = false;
			console.log("Error Response from getFiatLogs");
			console.log(error);  
		});
	};
	var getFront50Logs = function(){
		$scope.opsmxLoader = true;
		var getParams = {
			nameSpace : $scope.nameSpace	
		};
		DashBoardService.getFront50Logs(getParams).then(function(response) {
			$scope.opsmxLoader = false;
			console.log("Success Response from getFront50Logs");
			console.log(response);	
			$scope.serviceLogs = response.logs;
		},
		function(error){
			$scope.opsmxLoader = false;
			console.log("Error Response from getFront50Logs");
			console.log(error);  
		});
	};
	var getGateLogs = function(){
		$scope.opsmxLoader = true;
		var getParams = {
			nameSpace : $scope.nameSpace	
		};
		DashBoardService.getGateLogs(getParams).then(function(response) {
			$scope.opsmxLoader = false;
			console.log("Success Response from getGateLogs");
			console.log(response);	
			$scope.serviceLogs = response;
		},
		function(error){
			$scope.opsmxLoader = false;
			console.log("Error Response from getGateLogs");
			$scope.serviceLogs = response.logs;  
		});
	};
	var getIgorLogs = function(){
		$scope.opsmxLoader = true;
		var getParams = {
			nameSpace : $scope.nameSpace	
		};
		DashBoardService.getIgorLogs(getParams).then(function(response) {
			$scope.opsmxLoader = false;
			console.log("Success Response from getIgorLogs");
			console.log(response);	
			$scope.serviceLogs = response.logs;
		},
		function(error){
			$scope.opsmxLoader = false;
			console.log("Error Response from getIgorLogs");
			console.log(error);  
		});
	};
	var getKayentaLogs = function(){
		$scope.opsmxLoader = true;
		var getParams = {
			nameSpace : $scope.nameSpace	
		};
		DashBoardService.getKayentaLogs(getParams).then(function(response) {
			$scope.opsmxLoader = false;
			console.log("Success Response from getKayentaLogs");
			console.log(response);	
			$scope.serviceLogs = response.logs;
		},
		function(error){
			$scope.opsmxLoader = false;
			console.log("Error Response from getKayentaLogs");
			console.log(error);  
		});
	};
	var getOrcaLogs = function(){
		$scope.opsmxLoader = true;
		var getParams = {
			nameSpace : $scope.nameSpace	
		};
		DashBoardService.getOrcaLogs(getParams).then(function(response) {
			$scope.opsmxLoader = false;
			console.log("Success Response from getOrcaLogs");
			console.log(response);	
			$scope.serviceLogs = response.logs;
		},
		function(error){
			$scope.opsmxLoader = false;
			console.log("Error Response from getOrcaLogs");
			console.log(error);  
		});
	};
	var getRoscoLogs = function(){
		$scope.opsmxLoader = true;
		var getParams = {
			nameSpace : $scope.nameSpace	
		};
		DashBoardService.getRoscoLogs(getParams).then(function(response) {
			$scope.opsmxLoader = false;
			console.log("Success Response from getRoscoLogs");
			console.log(response);	
			$scope.serviceLogs = response.logs;
		},
		function(error){
			$scope.opsmxLoader = false;
			console.log("Error Response from getRoscoLogs");
			console.log(error);  
		});
	};
	
	$scope.getServiceLogs = function(service){
		if(service == "echo"){
			getEchoLogs();
		}else if(service == "clouddriver"){
			getCloudDriverLogs();
		}else if(service == "Deck"){
			getDeckLogs();
		}else if(service == "Fiat"){
			getFiatLogs();
		}else if(service == "Front50"){
			getFront50Logs();
		}else if(service == "Gate"){
			getGateLogs();
		}else if(service == "Igor"){
			getIgorLogs();
		}else if(service == "Kayenta"){
			getKayentaLogs();
		}else if(service == "Orca"){
			getOrcaLogs();
		}else if(service == "Rosco"){
			getRoscoLogs();
		}
	};
	
	$scope.getHealthStatusLogs = function(){
		$scope.opsmxLoader = true;
		var getParams = {
			nameSpace : $scope.nameSpace	
		};
		DashBoardService.getHealthStatusCheck(getParams).then(function(response) {
			$scope.opsmxLoader = false;
			console.log("Success Response from getHealthStatusCheck");
			console.log(response);	
			$scope.serviceLogs = response.logs;
		},
		function(error){
			$scope.opsmxLoader = false;
			console.log("Error Response from getHealthStatusCheck");
			console.log(error);  
		});
	};
	
	
	
});


app.controller('spinnakerController',function($scope, $http, $location, $rootScope, $stateParams,$sce, $timeout, DashboardService, AuditService) {
	
});




