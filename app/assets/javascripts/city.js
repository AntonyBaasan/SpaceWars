/**
 * Created by Antony on 2015-12-11.
 */

var cityModule = angular.module("cityModule", ['ngResource']);

cityModule.controller('cityController', ["$scope", '$window','serviceBuilding', function($scope, $window, serviceBuilding, $http) {

    $scope.name = "antony";
    serviceBuilding.getAllBuildings().then(function(response) {
        console.log(response);
        $scope.buildings = response.data;
    });

}]);