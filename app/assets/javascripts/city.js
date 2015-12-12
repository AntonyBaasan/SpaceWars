/**
 * Created by Antony on 2015-12-11.
 */

var cityModule = angular.module("cityModule", []);

cityModule.controller('cityController', ["$scope", '$window', function($scope, $window) {

    $scope.name = "antony";

}]);