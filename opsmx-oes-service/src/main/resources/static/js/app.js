var app = angular.module('app', ['ngRoute','ngResource']);
app.config(function($routeProvider){
    $routeProvider
    	.when('/',{
    		templateUrl: './views/setup.html',
    		controller: 'setupController'
    	}).when('/dashboard',{
            templateUrl: './views/dashboard.html',
            controller: 'dashboardController'
        })        
});

