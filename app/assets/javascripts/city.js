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



    //create building button click
    $scope.CreateBuilding = function(typeId){
        console.log("typeId: "+typeId);

        var building = {
            "building_type" : typeId,
        }

        serviceBuilding.createBuilding(building).then(function(response) {
            $scope.buildings.push(response.data);
            toastr.success('Building Created');
        },function(response){
            console.log("createBuilding: "+response.data.error);
            toastr.error('Can\'t create: '+response.data.error)
        });
    };

    $scope.Collect = function(building){
        console.log("buildingId: "+building.id);

    };

    $scope.DeleteBuilding = function(building){
        console.log("DeleteBuilding building.id: "+building.id);

        serviceBuilding.deleteBuilding(building.id).then(function(response) {

            $scope.buildings.splice( $scope.buildings.indexOf(building), 1 );
            toastr.success('Building deleted');

        },function(response){
            toastr.error('Can\'t delete: '+response.data.error)
        });

    };


}]);