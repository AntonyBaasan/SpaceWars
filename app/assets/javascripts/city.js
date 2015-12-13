/**
 * Created by Antony on 2015-12-11.
 */

var cityModule = angular.module("cityModule", ['ngResource']);

cityModule.controller('cityController', ["$scope", '$window','serviceBuilding', '$http', 'serviceUnit', function($scope, $window, serviceBuilding, $http, serviceUnit) {

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

    //Collect resource from building
    $scope.Collect = function(building){
        console.log("buildingId: "+building.id);

        serviceBuilding.collectBuilding(building.id).then(function(response) {

            var notice = 'Collected';

            if(response.data.notice != null) {
                notice = " " + response.data.notice;
                if(building.resource_type == "1")
                    $scope.city.stone += building.amount;
                if(building.resource_type == "2")
                    $scope.city.wood += building.amount;
            }
            toastr.success(notice);

        },function(response){
            toastr.error('Can\'t collect: '+response.data.error)
        });
    };

    //Delete a building
    $scope.DeleteBuilding = function(building){
        console.log("DeleteBuilding building.id: "+building.id);

        serviceBuilding.deleteBuilding(building.id).then(function(response) {

            $scope.buildings.splice( $scope.buildings.indexOf(building), 1 );
            toastr.success('Building deleted');

        },function(response){
            toastr.error('Can\'t delete: '+response.data.error)
        });
    };

    serviceUnit.getAllUnits().then(function(response) {
        console.log(response);
        $scope.units = response.data;
    });

    //create unit
    $scope.CreateUnit = function(typeId){
        console.log("typeId: "+typeId);

        var building = {
            "unit_type" : typeId,
        }

        serviceUnit.createUnit(building).then(function(response) {
            $scope.units.push(response.data);
            toastr.success('Unit Created');
        },function(response){
            console.log("createUnit: "+response.data.error);
            toastr.error('Can\'t create: '+response.data.error)
        });
    };

    //Delete a unit
    $scope.DeleteUnit = function(unit){
        console.log("DeleteUnit unit.id: "+unit.id);

        serviceUnit.deleteUnit(unit.id).then(function(response) {

            $scope.units.splice( $scope.units.indexOf(unit), 1 );
            toastr.success('Unit deleted');

        },function(response){
            toastr.error('Can\'t delete: '+response.data.error)
        });
    };


}]);