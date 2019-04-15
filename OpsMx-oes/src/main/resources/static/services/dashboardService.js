angular.module('serviceProvider', [])
app.service('DashBoardService', ['$http', '$q', function($http, $q) {
	return {
		getHealthStatusCheck: function(postData) {
            var deferred = $q.defer();
            $http({
            	method: "POST",
            	url: AppConfig.getBaseUrl()+"/getHealthStatusCheck",
            	data : postData,
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
        getEchoLogs: function(postData) {
            var deferred = $q.defer();
            $http({
            	method: "POST",
            	url: AppConfig.getBaseUrl()+"/getEchoLogs",
            	data : postData,
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
        getCloudDriverLogs: function(postData) {
            var deferred = $q.defer();
            $http({
            	method: "POST",
            	url: AppConfig.getBaseUrl()+"/getCloudDriverLogs",
            	data : postData,
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
        getDeckLogs: function(postData) {
            var deferred = $q.defer();
            $http({
            	method: "POST",
            	url: AppConfig.getBaseUrl()+"/getDeckLogs",
            	data : postData,
            	headers: {
            		'content-type': 'undefined'            		
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
        getFiatLogs: function(postData) {
            var deferred = $q.defer();
            $http({
            	method: "POST",
            	url: AppConfig.getBaseUrl()+"/getFiatLogs",
            	data : postData,
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
        getFront50Logs: function(postData) {
            var deferred = $q.defer();
            $http({
            	method: "POST",
            	url: AppConfig.getBaseUrl()+"/getFront50Logs",
            	data : postData,
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
        getGateLogs: function(postData) {
            var deferred = $q.defer();
            $http({
            	method: "POST",
            	url: AppConfig.getBaseUrl()+"/getGateLogs",
            	data : postData,
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
        getIgorLogs: function(postData) {
            var deferred = $q.defer();
            $http({
            	method: "POST",
            	url: AppConfig.getBaseUrl()+"/getIgorLogs",
            	data : postData,
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
        getKayentaLogs: function(postData) {
            var deferred = $q.defer();
            $http({
            	method: "POST",
            	url: AppConfig.getBaseUrl()+"/getKayentaLogs",
            	data : postData,
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
        getOrcaLogs: function(postData) {
            var deferred = $q.defer();
            $http({
            	method: "POST",
            	url: AppConfig.getBaseUrl()+"/getOrcaLogs",
            	data : postData,
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
        getRoscoLogs: function(postData) {
            var deferred = $q.defer();
            $http({
            	method: "POST",
            	url: AppConfig.getBaseUrl()+"/getRoscoLogs",
            	data : postData,
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
        }
          
	  }	  
}])