angular.module('serviceProvider', [])
app.service('ServiceProvider', ['$http', '$q', function($http, $q) {
	return {
	    // code to update the log topics
	    addServiceData: function(servicesData) {
			var deferred = $q.defer();
				$http({
					method: "POST",
					url: AppConfig.getBaseUrl()+"/testExecuteShellScript",	
					data: servicesData,
					transformRequest: angular.identity,
				    transformResponse: angular.identity,
					headers: {'content-type': 'application/json',
							 'Content-Type': undefined}
				}).then(function(response) {
					if (response.status == 200) {
						deferred.resolve(response.data)
					} else {
						deferred.reject("Error")
					}
				},function(error){
					deferred.reject("Error")
				})
				return deferred.promise;
	    },
	    getYamlData: function() {
			var deferred = $q.defer();
				$http({
					method: "GET",
					url: AppConfig.getBaseUrl()+"/readyaml",						
					transformRequest: angular.identity,
				    transformResponse: angular.identity,
					headers: {'content-type': 'application/json',
							 'Content-Type': undefined}
				}).then(function(response) {
					if (response.status == 200) {
						deferred.resolve(response.data)
					} else {
						deferred.reject("Error")
					}
				},function(error){
					deferred.reject("Error")
				})
				return deferred.promise;
	    },	    
	    // code to getDependencyCheck	    
	    dependencyCheck: function() {
            var deferred = $q.defer();
            $http({
              method: "GET",
              url: AppConfig.getBaseUrl()+"/getDependencyCheck",
              headers: {
                'content-type': 'application/json',
                'content-type': undefined
              }
            }).then(function(response) {
              if (response.status == 200) {
                deferred.resolve(response.data)
              } else {
                deferred.reject("Error while saving the details ")
              }
            })
            return deferred.promise;
          },
          platformCheck: function(postData) {
                var deferred = $q.defer();
                $http({
                	method: "POST",
                	data:postData,
                	url: AppConfig.getBaseUrl()+"/platformCheck",                	
                	headers: {
                		'content-type': 'application/json'
                	}
                }).then(function(response) {
                	if (response.status == 200) {
                		deferred.resolve(response.data)
                	} else {
                		deferred.reject("Error")
                	}
                })
                return deferred.promise;
            },            
            nameSpaceCheck: function(postData) {
                var deferred = $q.defer();
                $http({
                	method: "POST",
                	data:postData,
                	url: AppConfig.getBaseUrl()+"/nameSpaceCheck",                	
                	headers: {
                		'content-type': 'application/json'
                	}
                }).then(function(response) {
                	if (response.status == 200) {
                		deferred.resolve(response.data)
                	} else {
                		deferred.reject("Error")
                	}
                })
                return deferred.promise;
            },
            minioPullEnviorment: function(postData) {
                var deferred = $q.defer();
                $http({
                	method: "POST",
                	data:postData,
                	url: AppConfig.getBaseUrl()+"/minioPullEnviorment",                	
                	headers: {
                		'content-type': 'application/json'
                	}
                }).then(function(response) {
                	if (response.status == 200) {
                		deferred.resolve(response.data)
                	} else {
                		deferred.reject("Error")
                	}
                })
                return deferred.promise;
            },
          deploySpinnaker: function(postData) {
	        var deferred = $q.defer();
	        $http({
	          method: "POST",
	          url: AppConfig.getBaseUrl()+"/deploySpinnaker",
	          data: postData,
	          headers: {
	            'content-type': 'application/json'
	          }
	        }).then(function(response) {
	          if (response.status == 200) {
	            deferred.resolve(response.data)
	          } else {
	            deferred.reject("Error while saving the details ")
	          }
	        })
	        return deferred.promise;
      },
      getSpinnakarInstances: function(postData) {    	  
          var deferred = $q.defer();
          $http({
            method: "POST",
            url: AppConfig.getBaseUrl()+"/getSpinnakarInstances",
            data : postData,
            headers: {
              'content-type': 'application/json'
            }
          }).then(function(response) {
            if (response.status == 200) {
              deferred.resolve(response.data)
            } else {
              deferred.reject("Error while saving the details ")
            }
          })
          return deferred.promise;
        },
        getSpinnakerDetails: function(postData) {
            var deferred = $q.defer();
            $http({
              method: "POST",
              url: AppConfig.getBaseUrl()+"/getSpinnakerDetails",
              data : postData,
              headers: {
                'content-type': 'application/json'
              }
            }).then(function(response) {
              if (response.status == 200) {
                deferred.resolve(response.data)
              } else {
                deferred.reject("Error while saving the details ")
              }
            })
            return deferred.promise;
          }       
          
	  }	  
}])